meta-consolinno
===========

This is the official hardware support layer for Consolinno Devices.
Meta-consolinno is a distribution independent layer and delivers bootloader
and kernel to our customers.

Further information about the hardware can be found on our webpage:

  <http://www.consolinno.de>

If you experience any problem with this software, please contact our
<support@consolinno.de> or the maintainer directly.
Please try to do the following first:

* look in the
  [Yocto Project Bugzilla](http://bugzilla.yoctoproject.org/)
  to see if a problem has already been reported
* look through recent entries of the
  [Yocto mailing list archives](https://lists.yoctoproject.org/pipermail/yocto/)
  to see if other people have run into similar
  problems or had similar questions answered.

License
=======

This layer is distributed under the MIT license if not noted otherwise.
This includes all recipes, configuration files and meta data created by
Phytec. Source code included in the tree is distributed under the
license stated in the corresponding recipe or as mentioned in the code.
There is some work of others companies included or referenced.
Attribution is kept as required. The receipt meta data is mostly MIT,
if not noted otherwise. The binaries and code compiled for the target
rootfs is distributed under the vendors license. The licenses are
provided in the /licenses subdirectory to be collected by bitbake.
Please be aware that you need to agree to the specific vendor licenses
if you use the proprietary code for your product.

Maintainer
==========

M:  Leonid Verhovskij <l.verhovskij@consolinno.de>  

Dependencies
============

This layer depends on Openembedded-Core and Bitbake:  
<http://git.openembedded.org/bitbake>  
<http://git.openembedded.org/openembedded-core>