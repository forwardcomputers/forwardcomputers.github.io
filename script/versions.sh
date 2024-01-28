#!/bin/bash
#
set -eE
#
error () {
		JOB="$0"              # job name
		LASTLINE="$1"         # line of error occurrence
		LASTERR="$2"          # error code
		echo "ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}"
		exit 1
}
trap 'error ${LINENO} ${?}' ERR SIGHUP SIGINT SIGTERM
#
_dateISO=$( jq -nr 'now | todate' )
_dateLocal=$( jq -r 'fromdate | strflocaltime("%F %T %p")' <<< '"'${_dateISO}'"' )
echo -n > distro.yml

_sha=$( curl -sL https://api.github.com/repos/ohmybash/oh-my-bash/commits/master | jq -r '.sha' )
_url="https://github.com/ohmybash/oh-my-bash.git"
printf '{"distro":"oh-my-bash","name":"","version":"","sha":"%s","date":"%s","media":"Git","url":"%s"}\n' "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_sha=$( curl -sL https://api.github.com/repos/ohmyzsh/ohmyzsh/commits/master | jq -r '.sha' )
_url="https://github.com/ohmyzsh/ohmyzsh.git"
printf '{"distro":"oh-my-zsh","name":"","version":"","sha":"%s","date":"%s","media":"Git","url":"%s"}\n' "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_version=$( curl -sL https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/releases/latest | jq -r '.tag_name | gsub("v";"")' )
_sha=$( curl -sL https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/commits/main | jq -r '.sha' )
_url="https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${_version}/{posh-darwin-arm64,posh-linux-amd64,posh-linux-arm64,posh-windows-amd64.exe,themes.zip}"
printf '{"distro":"oh-my-posh","name":"","version":"%s","sha":"%s","date":"%s","media":"Executable","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_version=$( curl -sL https://api.github.com/repos/ipxe/wimboot/releases/latest | jq -r '.tag_name | gsub("v";"")' )
_sha=$( curl -sL https://api.github.com/repos/ipxe/wimboot/commits/master | jq -r '.sha' )
_url="https://github.com/ipxe/wimboot/raw/master/wimboot"
printf '{"distro":"ipxe","name":"wimboot","version":"%s","sha":"%s","date":"%s","media":"Executable","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_version=$( git -C "/ipxe" describe --tags --always --long --abbrev=1 --match "v*" )
_sha=$( curl -sL https://api.github.com/repos/ipxe/ipxe/commits/master | jq -r '.sha' )
_url="https://github.com/ipxe/ipxe.git"
printf '{"distro":"ipxe","name":"ipxe","version":"%s","sha":"%s","date":"%s","media":"Git","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_page=$( curl -sL https://gparted.org/gparted-live/stable/CHECKSUMS.TXT )
_version=$( awk -F"gparted-live-|-amd64.zip" '/amd64.zip/ {print $2; exit}' <<< ${_page} )
_sha=$( awk '/amd64.zip/ {print $1; exit}' <<< "${_page}" )
_url="https://downloads.sourceforge.net/gparted/$( awk '/amd64.zip/ {print $2; exit}' <<< ${_page} )"
printf '{"distro":"gparted","name":"","version":"%s","sha":"%s","date":"%s","media":"Compressed","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_page=$( curl -sL http://free.nchc.org.tw/clonezilla-live/stable/CHECKSUMS.TXT )
_version=$( awk -F"clonezilla-live-|-amd64.zip" '/amd64.zip/ {print $2; exit}' <<< ${_page} )
_sha=$( awk '/amd64.zip/ {print $1; exit}' <<< "${_page}" )
_url="http://free.nchc.org.tw/clonezilla-live/stable/$( awk '/amd64.zip/ {print $2; exit}' <<< ${_page} )"
printf '{"distro":"clonezilla","name":"","version":"%s","sha":"%s","date":"%s","media":"Compressed","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_sha=$( curl -sL https://rescuedisk.s.kaspersky-labs.com/updatable/2018/bases/krd.xml | awk -F'"' '/databases_timestamp/ {print $2}' )
_url="https://rescuedisk.s.kaspersky-labs.com/updatable/2018/krd.iso"
printf '{"distro":"krd","name":"","version":"","sha":"%s","date":"%s","media":"ISO","url":"%s"}\n' "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_version=$( curl -sL https://gitlab.com/systemrescue/systemrescue-sources/-/raw/main/VERSION )
_sha=$( curl -sL "https://www.system-rescue.org/releases/${_version}/systemrescue-${_version}-amd64.iso.sha256" | awk '{print $1}')
_url=$( curl -sL https://www.system-rescue.org/Download | awk -F'"' '/amd64.iso[/]download/ {print $4}' )
printf '{"distro":"systemrescue","name":"","version":"%s","sha":"%s","date":"%s","media":"ISO","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_version=$( curl -sL https://api.github.com/repos/openwrt/openwrt/releases/latest | jq -r '.tag_name | gsub("v";"")' )
_sha=$( curl -sL "https://downloads.openwrt.org/releases/${_version}/targets/x86/64/sha256sums" | awk '/openwrt-'${_version}'-x86-64-generic-ext4-combined.img.gz/ {print $1}')
_url="https://downloads.openwrt.org/releases/${_version}/targets/x86/64/openwrt-${_version}-x86-64-generic-ext4-combined.img.gz"
printf '{"distro":"openwrt","name":"","version":"%s","sha":"%s","date":"%s","media":"Compressed","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_page=$( curl -sL https://api.github.com/repos/pftf/RPi3/releases/latest )
_version=$( jq -r '.tag_name | gsub("v";"")' <<< "${_page}" )
_sha=$( curl -sL https://api.github.com/repos/pftf/RPi3/commits/master | jq -r '.sha' )
_url=$( jq -r '.assets[].browser_download_url' <<< "${_page}" )
printf '{"distro":"RPiUEFI","name":"3","version":"%s","sha":"%s","date":"%s","media":"Compressed","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_page=$( curl -sL https://api.github.com/repos/pftf/RPi4/releases/latest )
_version=$( jq -r '.tag_name | gsub("v";"")' <<< "${_page}" )
_sha=$( curl -sL https://api.github.com/repos/pftf/RPi4/commits/master | jq -r '.sha' )
_url=$( jq -r '.assets[].browser_download_url' <<< "${_page}" )
printf '{"distro":"RPiUEFI","name":"4","version":"%s","sha":"%s","date":"%s","media":"Compressed","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_page=$( curl -sL https://downloads.raspberrypi.org/operating-systems-categories.json )
for _type in 'with desktop' 'Lite' ; do
  _sha=$( jq -r '.[].images[] | select( .system=="64-bit" and .title=="Raspberry Pi OS '"${_type}"'" ).sha256' <<< "${_page}" )
  _version=$( jq -r '.[].images[] | select( .system=="64-bit" and .title=="Raspberry Pi OS '"${_type}"'" ) | .debianVersion + " - " + .version' <<< "${_page}" )
  _media="${_type/with d/D}"
  _url=$( jq -r '.[].images[] | select( .system=="64-bit" and .title=="Raspberry Pi OS '"${_type}"'" ).urlHttp' <<< "${_page}" )
  printf '{"distro":"rpios","name":"%s","version":"%s","sha":"%s","date":"%s","media":"Compressed","url":"%s"}\n' "${_media}" "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
done

_page=$( curl -sL https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/latest-releases.yaml )
_alpine_index=$( yq eval '.[].title | select(. == "Netboot") | path | .[0]' <<< "${_page}" )
_sha=$( yq eval '.['"${_alpine_index}"'].sha256' <<< "${_page}" )
_version=$( yq eval '.['"${_alpine_index}"'].version' <<< "${_page}" )
_url="https://dl-cdn.alpinelinux.org/alpine"
printf '{"distro":"alpine","name":"x86_64","version":"%s","sha":"%s","date":"%s","media":"Netboot","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
_page=$( curl -sL https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf/latest-releases.yaml )
_alpine_index=$( yq eval '.[].title | select(. == "Raspberry Pi") | path | .[0]' <<< "${_page}" )
_sha=$( yq eval '.['"${_alpine_index}"'].sha256' <<< "${_page}" )
_version=$( yq eval '.['"${_alpine_index}"'].version' <<< "${_page}" )
printf '{"distro":"alpine","name":"RPi","version":"%s","sha":"%s","date":"%s","media":"Netboot","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_url="https://geo.mirror.pkgbuild.com/iso/latest"
_page=$( curl -sL "${_url}/sha256sums.txt" )
_sha=$( awk '/bootstrap/ {print $1; exit}' <<< "${_page}" )
_version=$( awk -F'-' '/bootstrap/ {print $3; exit}' <<< "${_page}" )
printf '{"distro":"arch","name":"x86_64","version":"%s","sha":"%s","date":"%s","media":"Netboot","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}/arch" >> distro.yml
printf '{"distro":"arch","name":"x86_64","version":"%s","sha":"%s","date":"%s","media":"WSL","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}/archlinux-x86_64.iso" >> distro.yml
_url="https://geo.mirror.pkgbuild.com/images/latest"
_sha=$( curl "${_url}/Arch-Linux-x86_64-cloudimg.qcow2.SHA256" | awk '{print $1; exit}' )
printf '{"distro":"arch","name":"x86_64","version":"%s","sha":"%s","date":"%s","media":"Cloud","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}/Arch-Linux-x86_64-cloudimg.qcow2" >> distro.yml

_page=$( curl -sL "https://github.com/docker-library/official-images/raw/master/library/debian" )
_name=$( awk -F": |, " '/latest/ {print $2}' <<< "${_page}" )
_version=$( awk '/'"${_name}"' -- Debian / {print $5}' <<< "${_page}" )
_url="https://cdimage.debian.org/debian"
_page=$( curl -sL "${_url}-cd/current-live/amd64/iso-hybrid/SHA256SUMS" )
_sha=$( awk '/amd64-gnome.iso/ {print $1; exit}' <<< "${_page}" )
printf '{"distro":"debian","name":"%s","version":"%s","sha":"%s","date":"%s","media":"Netboot","url":"%s"}\n' "${_name}" "${_version}" "${_sha}" "${_dateLocal}" "${_url}/dists/${_name}/main/installer-amd64/current/images/netboot/debian-installer/amd64" >> distro.yml
_filename=$( awk '/amd64-gnome.iso/ {print $2; exit}' <<< "${_page}" )
printf '{"distro":"debian","name":"%s","version":"%s","sha":"%s","date":"%s","media":"Workstation","url":"%s"}\n' "${_name}" "${_version}" "${_sha}" "${_dateLocal}" "${_url}-cd/current-live/amd64/iso-hybrid/${_filename}" >> distro.yml
_url="https://cdimage.debian.org/mirror/cdimage/cloud"
_version=$( awk -F. '{print $1}' <<< "${_version}" )
_filename="debian-${_version}-generic-amd64.qcow2"
_sha=$( wget --no-hsts -qO- "${_url}/${_name}/latest/SHA512SUMS" | awk '/generic-amd64.qcow2/ {print $1; exit}' )
printf '{"distro":"debian","name":"%s","version":"%s","sha":"%s","date":"%s","media":"Cloud","url":"%s"}\n' "${_name}" "${_version}" "${_sha}" "${_dateLocal}" ""${_url}/${_name}/latest/${_filename}"" >> distro.yml

_version=$( curl -sL https://github.com/docker-library/official-images/raw/master/library/fedora | awk -F": |, " '/latest/ {print $2}' )
_url="https://dl.fedoraproject.org/pub/fedora"
_release=$( curl "${_url}/imagelist-fedora" | grep -o -P '(?<=Fedora-Workstation-Live-x86_64-'"${_version}"'-).*?(?=.iso)' | head -1 )
_sha=$( curl -sL "${_url}/linux/releases/${_version}/Everything/x86_64/iso/Fedora-Everything-${_version}-${_release}-x86_64-CHECKSUM" | awk '/^SHA256/ {print $4}' )
_url="${_url}/linux/releases/${_version}/Everything/x86_64/os/images/pxeboot"
printf '{"distro":"fedora","name":"fedora","version":"%s","sha":"%s","date":"%s","media":"Netboot","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
_url="https://dl.fedoraproject.org/pub/fedora/linux/releases/${_version}/Workstation/x86_64/iso"
_sha=$( curl -sL "${_url}/Fedora-Workstation-${_version}-${_release}-x86_64-CHECKSUM" | awk '/^SHA/ {print $4; exit}' )
_url="${_url}/Fedora-Workstation-Live-x86_64-${_version}-${_release}.iso"
printf '{"distro":"fedora","name":"fedora","version":"%s","sha":"%s","date":"%s","media":"Workstation","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
_url="https://dl.fedoraproject.org/pub/fedora/linux/releases/${_version}/Cloud/x86_64/images"
_sha=$( curl -sL "${_url}/Fedora-Cloud-${_version}-${_release}-x86_64-CHECKSUM" | awk '/^SHA256/ {print $4; exit}' )
_url="${_url}/Fedora-Cloud-Base-${_version}-${_release}.x86_64.qcow2"
printf '{"distro":"fedora","name":"fedora","version":"%s","sha":"%s","date":"%s","media":"Cloud","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_url="https://dl.fedoraproject.org/pub/fedora/linux/development/rawhide"
_version=$( curl -sL "${_url}/COMPOSE_ID" | awk -F'-' '{print $3}' )
_sha=$( curl -sL "${_url}/Everything/x86_64/iso/Fedora-Everything-iso-Rawhine-x86_64-${_version}-CHECKSUM" | awk '/^SHA256/ {print $4}' )
_url="${_url}/Everything/x86_64/os/images/pxeboot"
printf '{"distro":"fedora","name":"rawhide","version":"%s","sha":"%s","date":"%s","media":"Netboot","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
_url="https://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/Workstation/x86_64/iso"
_sha=$( curl -sL "${_url}/Fedora-Workstation-iso-Rawhide-x86_64-${_version}-CHECKSUM" | awk '/^SHA/ {print $4; exit}' )
_url="${_url}/Fedora-Workstation-Live-x86_64-Rawhide-${_version}.iso"
printf '{"distro":"fedora","name":"rawhide","version":"%s","sha":"%s","date":"%s","media":"Workstation","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
_url="https://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/Cloud/x86_64/images"
_sha=$( curl -sL "${_url}/Fedora-Cloud-Rawhide-x86_64-${_version}-CHECKSUM" | awk '/^SHA256/ {print $4; exit}' )
_url="${_url}/Fedora-Cloud-Base-Rawhide-${_version}.x86_64.qcow2"
printf '{"distro":"fedora","name":"rawhide","version":"%s","sha":"%s","date":"%s","media":"Workstation","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_url="http://stable.release.flatcar-linux.net/amd64-usr/current"
_version=$( curl -sL "${_url}/version.txt" | awk -F'=' '/FLATCAR_VERSION=/ {print $2}' )
_sha=$( curl -sL "${_url}/flatcar_production_pxe.vmlinuz.DIGESTS" | awk '/flatcar_production_pxe.vmlinuz/ {print $1; exit}' )
_url="${_url}/amd64-usr/current"
printf '{"distro":"flatcar","name":"","version":"%s","sha":"%s","date":"%s","media":"netboot","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_url="https://download.opensuse.org/distribution"
_version=$( curl -sL "${_url}/openSUSE-current/repo/oss/media.1/media" | tac | tac | awk -F'-' '{print $4; exit}' )
_url="https://download.opensuse.org/distribution/leap/${_version}"
_page=$( curl -sL "${_url}/live/openSUSE-Leap-${_version}-KDE-Live-x86_64-Media.iso.sha256" )
_sha=$( awk '{print $1}' <<< "${_page}" )
_filename=$( awk '{print $2}' <<< "${_page}" )
_url="${_url}/leap/${_new_version}/live/${_filename}"
printf '{"distro":"opensuse","name":"leap","version":"%s","sha":"%s","date":"%s","media":"Workstation","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
_url="https://download.opensuse.org/distribution/leap/${_version}"
_page=$( curl -sL "${_url}/appliances/openSUSE-Leap-${_version}-Minimal-VM.x86_64-Cloud.qcow2.sha256")
_sha=$( awk '{print $1}' <<< "${_page}" )
_filename=$( awk '{print $2}' <<< "${_page}" )
_url="${_url}/leap/${_new_version}/live/${_filename}"
printf '{"distro":"opensuse","name":"leap","version":"%s","sha":"%s","date":"%s","media":"Cloud","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
_url="https://download.opensuse.org/tumbleweed/iso"
_page=$( curl -sL "${_url}/openSUSE-Tumbleweed-KDE-Live-x86_64-Current.iso.sha256" )
_version=$( grep -o -P '(?<=Snapshot).*?(?=-)' <<< "${_page}" )
_sha=$( awk '{print $1}' <<< "${_page}" )
_filename=$( awk '{print $2}' <<< "${_page}" )
_url="${_url}/${_filename}"
printf '{"distro":"opensuse","name":"tumbleweed","version":"%s","sha":"%s","date":"%s","media":"Workstation","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
_url="https://download.opensuse.org/tumbleweed/appliances"
_page=$( curl -sL "${_url}/openSUSE-Tumbleweed-Minimal-VM.x86_64-Cloud.qcow2.sha256" )
_sha=$( awk '{print $1}' <<< "${_page}" )
_filename=$( awk '{print $2}' <<< "${_page}" )
_url="${_url}/${_filename}"
printf '{"distro":"opensuse","name":"tumbleweed","version":"%s","sha":"%s","date":"%s","media":"Cloud","url":"%s"}\n' "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_name=$( curl -sL https://raw.githubusercontent.com/tianon/docker-brew-ubuntu-core/master/rolling )
_url="https://releases.ubuntu.com"
_page=$( curl -sL "${_url}/${_name}/SHA256SUMS" )
_version=$( awk -F'-' '{print $2; exit}' <<< "${_page}" )
_sha=$( awk '/desktop/ {print $1; exit}' <<< "${_page}" )
_filename=$( awk -F'*' '/desktop/ {print $2; exit}' <<< "${_page}" )
_url="${_url}/${_name}/${_filename}"
printf '{"distro":"ubuntu","name":"%s","version":"%s","sha":"%s","date":"%s","media":"Workstation","url":"%s"}\n' "${_name}" "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
_url="https://releases.ubuntu.com"
_sha=$( awk '/live-server/ {print $1; exit}' <<< "${_page}" )
_filename=$( awk -F'*' '/live-server/ {print $2; exit}' <<< "${_page}" )
_url="${_url}/${_name}/${_filename}"
printf '{"distro":"ubuntu","name":"%s","version":"%s","sha":"%s","date":"%s","media":"Server","url":"%s"}\n' "${_name}" "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml
_url="https://cloud-images.ubuntu.com"
_sha=$( curl -sL "${_url}/${_name}/current/SHA256SUMS" | awk '/amd64-disk-kvm.img/ {print $1}' )
_url="${_url}/${_name}/current/${_name}-server-cloudimg-amd64-disk-kvm.img"
printf '{"distro":"ubuntu","name":"%s","version":"%s","sha":"%s","date":"%s","media":"Cloud","url":"%s"}\n' "${_name}" "${_version}" "${_sha}" "${_dateLocal}" "${_url}" >> distro.yml

_page=$( curl -sL --http1.1 https://docs.microsoft.com/en-us/windows/release-health/release-information )
_build=$( awk '/Servicing channels/{ FS="[><]"; getline; getline; getline; getline; getline; getline; getline; print $3}' <<< "${_page}" )
_version=$( awk '/Servicing channels/{ FS="[><]"; getline; getline; getline; print $3}' <<< "${_page}" )
_id=$( curl -sL --http1.1 "https://api.uupdump.net/listid.php?search=${_build}+amd64" | jq -r '.response.builds[] | select( .title | contains( "Cumulative" ) | not ) | .uuid' )
_url="https://uupdump.net/get.php?id=${_id}&pack=en-us&edition=Professional&aria2=2"
printf '{"distro":"windows","name":"10","version":"%s","build":"%s","id":"%s","date":"%s","media":"ISO","url":"%s"}\n' "${_version}" "${_build}" "${_id}" "${_dateLocal}" "${_url}" >> distro.yml
_kb=$( wget --no-hsts -qO- https://docs.microsoft.com/en-us/windows/release-health/release-information | awk -v FPAT='KB[0-9]+' 'NF{ print $1; exit }' )
_id=$( curl -sL --http1.1 https://www.catalog.update.microsoft.com/Search.aspx?q=Cumulative%20Windows%2010%20x64%20"${_kb}" | tac | tac | awk -F'id="' '/resultsbottomBorder/ {split($2,a,"_");print a[1]; exit}' )
_url=$( curl --http1.1 -d 'updateIDs=[{"size":0,"uidInfo":"'${_id}'","updateID":"'${_id}'"}]' -X POST -L https://www.catalog.update.microsoft.com/DownloadDialog.aspx | awk -F"'" '/url =/ {print $2}' )
printf '{"distro":"windows","name":"10","version":"%s","build":"%s","kb":"%s","id":"%s","date":"%s","media":"Update","url":"%s"}\n' "${_version}" "${_build}" "${_kb}" "${_id}" "${_dateLocal}" "${_url}" >> distro.yml

_page=$( curl -sL --http1.1 https://docs.microsoft.com/en-us/windows/release-health/windows11-release-information )
_build=$( awk '/Servicing channels/{ FS="[><]"; getline; getline; getline; getline; getline; getline; getline; print $3}'  <<< "${_page}" )
_version=$( awk '/Servicing channels/{ FS="[><]"; getline; getline; getline; print $3}' <<< "${_page}" )
_id=$( curl -sL --http1.1 "https://api.uupdump.net/listid.php?search=${_build}+amd64" | jq -r '.response.builds[] | select( .title | contains( "Cumulative" ) | not ) | .uuid' )
_url="https://uupdump.net/get.php?id=${_id}&pack=en-us&edition=Professional&aria2=2"
printf '{"distro":"windows","name":"11","version":"%s","build":"%s","id":"%s","date":"%s","media":"ISO","url":"%s"}\n' "${_version}" "${_build}" "${_id}" "${_dateLocal}" "${_url}" >> distro.yml
_kb=$( curl -sL --http1.1 https://docs.microsoft.com/en-us/windows/release-health/windows11-release-information | tac | tac | awk -v FPAT='KB[0-9]+' 'NF{ print $1; exit }' )
_id=$( curl -sL --http1.1 https://www.catalog.update.microsoft.com/Search.aspx?q=Cumulative%20Windows%2011%20x64%20"${_kb}" | tac | tac | awk -F'id="' '/resultsbottomBorder/ {split($2,a,"_");print a[1]; exit}' )
_url=$( curl -sL --http1.1 -d 'updateIDs=[{"size":0,"uidInfo":"'${_id}'","updateID":"'${_id}'"}]' -X POST -L https://www.catalog.update.microsoft.com/DownloadDialog.aspx | awk -F"'" '/url =/ {print $2}' )
printf '{"distro":"windows","name":"11","version":"%s","build":"%s","kb":"%s","id":"%s","date":"%s","media":"Update","url":"%s"}\n' "${_version}" "${_build}" "${_kb}" "${_id}" "${_dateLocal}" "${_url}" >> distro.yml

unset _bios
declare -A _bios
_bios[NUC7I3DNKE]="DNKBLI30"
_bios[NUC7I5BNK]="BNKBL357"
for _i in "${!_bios[@]}" ; do
  _version=$( curl -sL "https://www.asus.com/supportonly/${_i,,,}/helpdesk_bios" | awk -F'Version ' '/BIOS Update \['"${_bios[$_i]}"'\]/ && /Version / {print substr($2,1,4)}' )
  _url="https://dlcdnets.asus.com/pub/ASUS/NUC/NUC_7_Board/BIOS_Update_${_bios[$_i]}.zip?model=${_i}"
  printf '{"distro":"asus","name":"%s","bios":"%s","version":"%s","date":"%s","media":"BIOS","url":"%s"}\n' "${_i}" "${_bios[$_i]}" "${_version:-0}" "${_dateLocal}" "${_url}" >> distro.yml
done

_version=$( curl -sL "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/virtio-win-pkg-scripts-input/latest-build/buildversions.json" | jq -r '."virtio-win-prewhql".version' )
_url="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso"
printf '{"distro":"proxmox","name":"virtio","version":"%s","date":"%s","media":"ISO","url":"%s"}\n' "${_version}" "${_dateLocal}" "${_url}" >> distro.yml
