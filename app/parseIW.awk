#############################################################################
#   parseIW.awk
#   
#   Description:
#    Get the result of 'iw .. scan' and output it in 'iwlist scan' style
#   
#   Usage:
#    sudo iw dev wlan0 scan ap-force | gawk -f parseIW.awk
#
#   Note:
#    - Unlike iwlist, iw is called for a specific adapter. 
#      For me it's ok, since most of the code assumes there is a adapter called 'wlan0'
#    - Quality indicator is not given with iw, and is set to 'not available'
#      (no problem if you remove it, since it's not used in the module)
#    - And of course, all the leading spaces in output are not necessary ;)
##############################################################################

$1 == "BSS" {
    macadr = $2
    cells[macadr]["macaddress"] = $2
    cells[macadr]["enc"] = "off"
}
$1 == "SSID:" {
    cells[macadr]["ssid"]=""
    for(i=2;i<=NF;i++) {
	if (i > 2) {
	 cells[macadr]["ssid"] = cells[macadr]["ssid"] FS $i
	}
	else {
	 cells[macadr]["ssid"] = $i
	}
    }
}
$1 == "signal:" {
    cells[macadr]["signal_level"] = $2 " " $3
}
$1 == "WPA:" {
    cells[macadr]["enc"] = "on"
}
$1 == "WEP:" {
    cells[macadr]["enc"] = "on"
}

END {
    i = 1
    printf "myadapter     Scan completed :\n"
    for (c in cells) {
        printf "Cell %02d - Address: %s\n", i, substr(cells[c]["macaddress"], 1,17)
        printf "          Quality=%s\n", "not available"
        printf "          Signal level=%s\n", cells[c]["signal_level"]
        printf "          Encryption key:%s\n", cells[c]["enc"]
        printf "          ESSID:\"%s\"\n", cells[c]["ssid"]
        i++
    }
}
