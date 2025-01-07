### RAUC OTA Update System ###
JZR250103  
Um verschiedene OTA Update Systeme verwenden zu können, ist 
das RAUC System als YOCTO dynamic-layer eingebunden und kann über die 
Variable ENABLED_LAYERS aktiviert werden.

in der lokalen project-bblayers.conf findet man dazu:

```
ENABLED_LAYERS = "\
    ${@'rauc'   if d.getVar('DISTRO').find('-rauc') > 0   else ''} \
    ${@'mender' if d.getVar('DISTRO').find('-mender') > 0 else ''} \
"
```

Durch die Distro Bezeichnung  
**1u0022-rauc**  
wird somit das RAUC OTA Update System und mit  
**1u0022-mender**  
würde das Mender OTA Update Sytem aktivieren (250103: noch nicht implementiert)

#### update bootloader mit RAUC bundle #### 

Soll auch ein Bootloader Update durch das RAUC Bundle durchgeführt werden, so wird das über die in der gitlab-ci pipeline dynamisch erzeugten local-local.conf durch einen DISTRO-FEATURES Eintrag wie
```
DISTRO_FEATURES:append = " rauc_bb"
```
erreicht.  
Stand 2.0.6 ist noch kein bootloader slot in /etc/rauc/system.conf definiert. Daher kann der 
Bootloader Update nicht auf den Standard Weg durchgeführt werden. Eine Aktualisierung des 
Rootfs mit der Konfigurationsanpassung müsste 2x mit 2 Reboots durchgeführt werden. Erst bei der 
2. Installation würde die Slot-Information im aktiven System vorliegen und eine bootloader 'slot'
Installation könnte durchgeführt werden.  
Da dies aber schwer kommunizierbar ist, wird die Installation script basiert über den bundle hook 
check-install im script hook_bb.sh durchgeführt. Die Aktualisierung wird außerdem nur durchgeführt,
wenn ein binärer Vergleich ergibt, dass das enthaltene barebox-image noch nicht installiert ist.

##### ACHTUNG #####
Anders als die RAUC A/B Partitions-Technik ist der Bootloader-Update nicht 'bullet-proof', da hier kein
A/B Mechanismus implementiert ist. Das eMMC bietet zwar eine Standart boot0/boot1 Partition, hier ist aber keine Redundanz, Umschalting im fehlerfall etc. implementiert. sEin Stromausfall während des Schreibens der 512kB könnte also 
theoretisch zu einem nicht mehr bootbaren System führen. 
Das vorherige Prüfen des installierten Bootloaders ist somit essentiell, um das Risiko bei Stromausfall während der Installation zu minimieren.
