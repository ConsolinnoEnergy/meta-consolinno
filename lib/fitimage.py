from abc import ABC, abstractmethod
from functools import cmp_to_key
import os.path

class OfProperty:
    def __init__(self, key, val):
        self.key = key
        self.val = val

    def emit(self, d):
        if self.val is not None:
            return "%s = %s;" % (self.key, self.emit_val(d))
        else:
            return "%s;" % (self.key,)

    def emit_val(self, d, as_raw = False):
        assert(d is not None)
        v = d.expand(self.val)
        return self._emit_val(v, as_raw = as_raw)

    @abstractmethod
    def _emit_val(self, as_raw = False):
        assert(False)

class OfPropertyBool(OfProperty):
    def __init__(self, key, val = None):
        assert(val is None);
        super().__init__(key, val)

class OfPropertyString(OfProperty):
    def __init__(self, key, val):
        super().__init__(key, val)

    def _emit_val(self, v, as_raw = False):
        if as_raw:
            return "%s" % v
        else:
            return '"%s"' % v

class OfPropertyH32(OfProperty):
    def __init__(self, key, val):
        super().__init__(key, val)

    def _emit_val(self, v, as_raw = False):
        if as_raw:
            return '0x%08x' % v
        else:
            return '<0x%08x>' % v

class OfPropertyI32(OfProperty):
    def __init__(self, key, val):
        super().__init__(key, val)

    def _emit_val(self, v, as_raw = False):
        if as_raw:
            return "%d" % v
        else:
            return '<%d>' % v

class OfPropertyIncBin(OfProperty):
    def __init__(self, key, val):
        super().__init__(key, val)

    def _emit_val(self, v, as_raw = False):
        assert(not as_raw)
        return '/incbin/("%s")' % v

class OfNode:
    def __init__(self, name, instance = None, pseudo_reg = False):
        self.name = name
        self.instance = instance
        self._pseudo_reg = pseudo_reg
        self._props = []
        self._nodes = []
        self._instance_prop = None

    def add_prop(self, prop):
        self._props.append(prop)
        return self

    def add_prop_strring(self, key, val):
        return self.add_prop(OfPropertyString(key, val))

    def add_prop_h32(self, key, val):
        return self.add_prop(OfPropertyH32(key, val))

    def add_prop_i32(self, key, val):
        return self.add_prop(OfPropertyI32(key, val))

    def add_node(self, node):
        self._nodes.append(node)
        return self

    def attr_map(self, attrs):
        res = []
        for (val, attr, klass) in attrs:
            if val is None:
                continue

            self.add_prop(klass(attr, val))

        return res

    def finish(self):
        if self.instance is not None:
            self._instance_prop = OfPropertyH32("reg", self.instance)

            if not self._pseudo_reg:
                self.add_prop(self._instance_prop)

        for n in self._nodes:
            n.finish()

        return self

    @staticmethod
    def indent(data):
        return map(lambda x: ('\t%s' % x).rstrip(), data)

    def emit(self, d):
        res = []

        if self._instance_prop is None:
            res.append(d.expand("%s {" % self.name))
        else:
            res.append(d.expand("%s%s%s {" % (
                self.name,
                ['@', '-'][self._pseudo_reg],
                self._instance_prop.emit_val(d, as_raw = True))))

        props = []
        for p in filter(lambda x: x.key.startswith('#'), self._props):
            props.append(p.emit(d))

        for p in filter(lambda x: not x.key.startswith('#'), self._props):
            props.append(p.emit(d))

        nodes = []
        for n in self._nodes:
            nodes.extend(n.emit(d))

        res.extend(self.indent(props))
        if props and nodes:
            res.append("")
        res.extend(self.indent(nodes))

        res.append("};")

        return res

class OfTree:
    def __init__(self):
        self._nodes = []

    def add_node(self, node):
        self._nodes.append(node)
        return self

    def finish(self):
        for n in self._nodes:
            n.finish()
        return self

    def emit(self, d):
        res = [
            "/dts-v1/;",
        ]

        for n in self._nodes:
            res.append("")
            res.extend(n.emit(d))

        return '\n'.join(res)

##

class FitImage(OfNode):
    def __init__(self):
        super().__init__("/")

        self.description = "U-Boot fitImage for ${DISTRO_NAME}/${PV}/${MACHINE}"

    def finish(self):
        self.add_prop_strring("description", self.description)
        return super().finish()

    @staticmethod
    def get_hwid(dtb, id_attr, desc_attr):
        import subprocess
        with subprocess.Popen(["fdtget", dtb, "/", id_attr], stdout = subprocess.PIPE) as proc:
            data_id = proc.stdout.readline().strip()
        with subprocess.Popen(["fdtget", dtb, "/", desc_attr], stdout = subprocess.PIPE) as proc:
            data_desc = proc.stdout.readline().strip()

        if not data_id:
            return None

        return (int(data_id), data_desc.decode())

    @staticmethod
    def from_desc(kernels = [], dtbs = [], overlays = [], ramdisks = [],
                  id_attr = "device-id", desc_attr = "device-description"):
        images = OfNode("&images")

        idx    = 0
        for k in kernels:
            images.add_node(FitPart("kernel", idx)
                            .set_inputfile(k))

        for d in dtbs + overlays:
            (hw_id, hw_desc) = FitImage.get_hwid(d, id_attr, desc_attr) or (0, d)
            images.add_node(FitPart("fdt", hw_id)
                            .set_type("flat_dt")
                            .set_compression("none")
                            .set_description(hw_desc)
                            .set_inputfile(d))

        idx = 0
        for r in ramdisks:
            images.add_node(FitPart("ramdisk", idx)
                            .set_os("linux")
                            .set_compression("none")
                            .set_inputfile(r))

        return images

class FitNode(OfNode):
    def __init__(self, name, instance):
        super().__init__(name, instance, True)

class FitPart(FitNode):
    def __init__(self, type, instance = None):
        super().__init__(type, instance)
        self.type = type
        self.name = type
        self.__data = None
        self.desc = None
        self.arch = "${ARCH}"
        self.compression = None
        self.hash = "sha1"
        self.entry = None
        self.load = None
        self.os = None

    def set_compression(self, comp):
        self.compression = comp
        return self

    def set_os(self, os):
        self.os = os
        return self

    def set_load(self, load):
        self.load = load
        return self

    def set_entry(self, entry):
        self.entry = entry
        return self

    def set_description(self, desc):
        self.desc = desc
        return self

    def set_type(self, type):
        self.type = type
        return self

    def set_inputfile(self, fname):
        if self.desc is None:
            self.desc = os.path.basename(fname)

        if self.compression is None:
            if fname.endswith(".gz"):
                self.compression = "gzip"

        self.__data = OfPropertyIncBin("data", fname)

        return self

    def finish(self):
        assert(self.__data is not None)

        self.add_prop(self.__data)

        self.attr_map([
            (self.type,  "type",              OfPropertyString),
            (self.desc, "description",        OfPropertyString),
            (self.arch, "arch",               OfPropertyString),
            (self.os,   "os",                 OfPropertyString),
            (self.compression, "compression", OfPropertyString),
            (self.load,  "load",              OfPropertyH32),
            (self.entry, "entry",             OfPropertyH32),
        ])

        self.add_node(OfNode("hash-1", None)
                      .add_prop_strring("algo", self.hash))

        return super().finish()



if __name__ == '__main__':
    class D:
        def __init__(self):
            pass

        def expand(self, s):
            return s

    image = (OfTree()
             .add_node(FitImage()
                       .add_node(OfNode("images")
                                 .add_node(FitPart("kernel")
                                           .set_inputfile("vmlinuz.gz"))))
             .finish())

    print(image.emit(D()))
