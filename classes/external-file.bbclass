## Adds external files as dependency

EXTERNAL_FILES ??= ""
EXTERNAL_FILES[type] = "list"

def get_external_files(d):
    files = []
    for f in oe.data.typed_value("EXTERNAL_FILES", d):
        if f.startswith("file://"):
            f = f[7:]

        files.append('%s:%s' % (f, os.path.exists(f)))

    return ' '.join(files)

do_unpack[file-checksums] += "${@get_external_files(d)}"
