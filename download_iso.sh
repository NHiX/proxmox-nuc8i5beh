#!/bin/bash

# Configuration des variables
ISO_DIR="/mnt/microsd/template/iso"
LOG_FILE="/root/download_iso.log"
TEMP_DIR="/tmp/iso_download"

# Créer les répertoires nécessaires
mkdir -p "$ISO_DIR"
mkdir -p "$TEMP_DIR"

# Fonction de logging
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Fonction pour télécharger si nouvelle version
download_if_new() {
    local url="$1"
    local filename="$2"
    local distro="$3"
    
    if [ -n "$url" ]; then
        local filepath="$ISO_DIR/$filename"
        
        if [ ! -f "$filepath" ]; then
            log_message "Téléchargement de $distro: $filename"
            if curl -L -o "$filepath" "$url"; then
                log_message "NOUVELLE VERSION TÉLÉCHARGÉE: $distro - $filename"
            else
                log_message "ERREUR: Échec du téléchargement de $distro"
                rm -f "$filepath"
            fi
        else
            log_message "$distro déjà présent: $filename"
        fi
    else
        log_message "ERREUR: URL non trouvée pour $distro"
    fi
}

# Fonction pour obtenir la dernière version Ubuntu LTS Desktop
get_ubuntu_lts_desktop_url() {
    local releases_page=$(curl -s "https://releases.ubuntu.com/")
    local lts_version=$(echo "$releases_page" | grep -o 'href="[0-9][0-9]\.[0-9][0-9]/"' | grep -E "04/" | sort -V | tail -1 | sed 's/href="//;s/"//;s/\///')
    if [ -n "$lts_version" ]; then
        echo "https://releases.ubuntu.com/$lts_version/ubuntu-$lts_version-desktop-amd64.iso"
    fi
}

# Fonction pour obtenir la dernière version Ubuntu LTS Server
get_ubuntu_lts_server_url() {
    local releases_page=$(curl -s "https://releases.ubuntu.com/")
    local lts_version=$(echo "$releases_page" | grep -o 'href="[0-9][0-9]\.[0-9][0-9]/"' | grep -E "04/" | sort -V | tail -1 | sed 's/href="//;s/"//;s/\///')
    if [ -n "$lts_version" ]; then
        echo "https://releases.ubuntu.com/$lts_version/ubuntu-$lts_version-live-server-amd64.iso"
    fi
}

# Fonction pour obtenir la dernière version Ubuntu Desktop
get_ubuntu_latest_desktop_url() {
    local releases_page=$(curl -s "https://releases.ubuntu.com/")
    local latest_version=$(echo "$releases_page" | grep -o 'href="[0-9][0-9]\.[0-9][0-9]/"' | sort -V | tail -1 | sed 's/href="//;s/"//;s/\///')
    if [ -n "$latest_version" ]; then
        echo "https://releases.ubuntu.com/$latest_version/ubuntu-$latest_version-desktop-amd64.iso"
    fi
}

# Fonction pour obtenir la dernière version Ubuntu Server
get_ubuntu_latest_server_url() {
    local releases_page=$(curl -s "https://releases.ubuntu.com/")
    local latest_version=$(echo "$releases_page" | grep -o 'href="[0-9][0-9]\.[0-9][0-9]/"' | sort -V | tail -1 | sed 's/href="//;s/"//;s/\///')
    if [ -n "$latest_version" ]; then
        echo "https://releases.ubuntu.com/$latest_version/ubuntu-$latest_version-live-server-amd64.iso"
    fi
}

# Fonction pour obtenir la dernière version Arch Linux
get_archlinux_url() {
    local arch_page=$(curl -s "https://archlinux.org/download/")
    local iso_name=$(echo "$arch_page" | grep -o 'archlinux-[0-9][0-9][0-9][0-9]\.[0-9][0-9]\.[0-9][0-9]-x86_64\.iso' | head -1)
    if [ -n "$iso_name" ]; then
        echo "https://geo.mirror.pkgbuild.com/iso/latest/$iso_name"
    fi
}

# Fonction pour obtenir la dernière version Fedora Workstation
get_fedora_url() {
    local fedora_page=$(curl -s "https://getfedora.org/en/workstation/download/")
    local version=$(echo "$fedora_page" | grep -o 'Fedora-Workstation-Live-x86_64-[0-9][0-9]-[0-9]\.[0-9]\.iso' | head -1)
    if [ -n "$version" ]; then
        echo "https://download.fedoraproject.org/pub/fedora/linux/releases/$(echo $version | grep -o '[0-9][0-9]')/Workstation/x86_64/iso/$version"
    fi
}

# Fonction pour obtenir la dernière version AlmaLinux minimal
get_almalinux_url() {
    local alma_page=$(curl -s "https://mirrors.almalinux.org/isos.html")
    local version=$(echo "$alma_page" | grep -o 'AlmaLinux-[0-9]\.[0-9]-x86_64-minimal\.iso' | head -1)
    if [ -n "$version" ]; then
        local ver_num=$(echo "$version" | grep -o '[0-9]\.[0-9]')
        echo "https://repo.almalinux.org/almalinux/$ver_num/isos/x86_64/$version"
    fi
}

# Fonction pour obtenir la dernière version Rocky Linux minimal
get_rockylinux_url() {
    local rocky_page=$(curl -s "https://rockylinux.org/download")
    local version=$(echo "$rocky_page" | grep -o 'Rocky-[0-9]\.[0-9]-x86_64-minimal\.iso' | head -1)
    if [ -n "$version" ]; then
        local ver_num=$(echo "$version" | grep -o '[0-9]\.[0-9]')
        echo "https://download.rockylinux.org/pub/rocky/$ver_num/isos/x86_64/$version"
    fi
}

# Fonction pour obtenir la dernière version Debian minimal (netinst)
get_debian_url() {
    local debian_page=$(curl -s "https://www.debian.org/distrib/netinst")
    local version=$(echo "$debian_page" | grep -o 'debian-[0-9][0-9]\.[0-9]-amd64-netinst\.iso' | head -1)
    if [ -n "$version" ]; then
        echo "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/$version"
    fi
}

# Fonction pour obtenir la dernière version OpenBSD
get_openbsd_url() {
    local openbsd_page=$(curl -s "https://www.openbsd.org/ftp.html")
    local version=$(echo "$openbsd_page" | grep -o 'OpenBSD [0-9]\.[0-9]' | head -1 | grep -o '[0-9]\.[0-9]')
    if [ -n "$version" ]; then
        echo "https://cdn.openbsd.org/pub/OpenBSD/$version/amd64/install${version//.}.iso"
    fi
}

# Fonction pour obtenir la dernière version FreeBSD
get_freebsd_url() {
    local freebsd_page=$(curl -s "https://www.freebsd.org/releases/")
    local version=$(echo "$freebsd_page" | grep -o 'FreeBSD [0-9][0-9]\.[0-9]' | head -1 | grep -o '[0-9][0-9]\.[0-9]')
    if [ -n "$version" ]; then
        echo "https://download.freebsd.org/ftp/releases/amd64/amd64/ISO-IMAGES/$version/FreeBSD-$version-RELEASE-amd64-disc1.iso"
    fi
}

# Fonction pour obtenir la dernière version RockyLinux 10.x minimal
get_rockylinux10_url() {
    local rocky_page=$(curl -s "https://rockylinux.org/download")
    local version=$(echo "$rocky_page" | grep -o 'Rocky-10\.[0-9]-x86_64-minimal\.iso' | head -1)
    if [ -n "$version" ]; then
        local ver_num=$(echo "$version" | grep -o '10\.[0-9]')
        echo "https://download.rockylinux.org/pub/rocky/$ver_num/isos/x86_64/$version"
    fi
}

# Fonction pour obtenir la dernière version AlmaLinux 10.x minimal
get_almalinux10_url() {
    local alma_page=$(curl -s "https://mirrors.almalinux.org/isos.html")
    local version=$(echo "$alma_page" | grep -o 'AlmaLinux-10\.[0-9]-x86_64-minimal\.iso' | head -1)
    if [ -n "$version" ]; then
        local ver_num=$(echo "$version" | grep -o '10\.[0-9]')
        echo "https://repo.almalinux.org/almalinux/$ver_num/isos/x86_64/$version"
    fi
}

# Fonction pour obtenir la dernière version NetBSD minimal x86_64
get_netbsd_url() {
    local netbsd_page=$(curl -s "https://www.netbsd.org/releases/")
    local version=$(echo "$netbsd_page" | grep -o 'NetBSD [0-9]\.[0-9]' | head -1 | grep -o '[0-9]\.[0-9]')
    if [ -n "$version" ]; then
        echo "https://cdn.netbsd.org/pub/NetBSD/NetBSD-$version/amd64/installation/cdrom/boot-com.iso"
    fi
}

# Fonction pour obtenir la dernière version TrueNAS-SCALE
get_truenas_scale_url() {
    local truenas_page=$(curl -s "https://api.github.com/repos/truenas/scale-build/releases/latest")
    local download_url=$(echo "$truenas_page" | grep -o '"browser_download_url":[^,]*\.iso"' | head -1 | sed 's/"browser_download_url":"//;s/"//')
    if [ -n "$download_url" ]; then
        echo "$download_url"
    fi
}

# Fonction pour obtenir la dernière version Alpine Linux standard x86_64
get_alpinelinux_url() {
    local alpine_page=$(curl -s "https://alpinelinux.org/downloads/")
    local version=$(echo "$alpine_page" | grep -o 'alpine-standard-[0-9]\+\.[0-9]\+\.[0-9]\+-x86_64\.iso' | head -1)
    if [ -n "$version" ]; then
        local ver_num=$(echo "$version" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
        echo "https://dl-cdn.alpinelinux.org/alpine/v${ver_num%.*}/releases/x86_64/$version"
    fi
}

# Début du script
log_message "=== DÉBUT DU TÉLÉCHARGEMENT DES ISO ==="

# Ubuntu LTS Desktop
log_message "Recherche de la dernière version Ubuntu LTS Desktop..."
ubuntu_lts_desktop_url=$(get_ubuntu_lts_desktop_url)
if [ -n "$ubuntu_lts_desktop_url" ]; then
    filename=$(basename "$ubuntu_lts_desktop_url")
    download_if_new "$ubuntu_lts_desktop_url" "$filename" "Ubuntu LTS Desktop"
fi

# Ubuntu LTS Server
log_message "Recherche de la dernière version Ubuntu LTS Server..."
ubuntu_lts_server_url=$(get_ubuntu_lts_server_url)
if [ -n "$ubuntu_lts_server_url" ]; then
    filename=$(basename "$ubuntu_lts_server_url")
    download_if_new "$ubuntu_lts_server_url" "$filename" "Ubuntu LTS Server"
fi

# Ubuntu Latest Desktop
log_message "Recherche de la dernière version Ubuntu Desktop..."
ubuntu_latest_desktop_url=$(get_ubuntu_latest_desktop_url)
if [ -n "$ubuntu_latest_desktop_url" ]; then
    filename=$(basename "$ubuntu_latest_desktop_url")
    download_if_new "$ubuntu_latest_desktop_url" "$filename" "Ubuntu Latest Desktop"
fi

# Ubuntu Latest Server
log_message "Recherche de la dernière version Ubuntu Server..."
ubuntu_latest_server_url=$(get_ubuntu_latest_server_url)
if [ -n "$ubuntu_latest_server_url" ]; then
    filename=$(basename "$ubuntu_latest_server_url")
    download_if_new "$ubuntu_latest_server_url" "$filename" "Ubuntu Latest Server"
fi

# Arch Linux
log_message "Recherche de la dernière version Arch Linux..."
archlinux_url=$(get_archlinux_url)
if [ -n "$archlinux_url" ]; then
    filename=$(basename "$archlinux_url")
    download_if_new "$archlinux_url" "$filename" "Arch Linux"
fi

# Fedora
log_message "Recherche de la dernière version Fedora..."
fedora_url=$(get_fedora_url)
if [ -n "$fedora_url" ]; then
    filename=$(basename "$fedora_url")
    download_if_new "$fedora_url" "$filename" "Fedora"
fi

# AlmaLinux
log_message "Recherche de la dernière version AlmaLinux minimal..."
almalinux_url=$(get_almalinux_url)
if [ -n "$almalinux_url" ]; then
    filename=$(basename "$almalinux_url")
    download_if_new "$almalinux_url" "$filename" "AlmaLinux Minimal"
fi

# Rocky Linux
log_message "Recherche de la dernière version Rocky Linux minimal..."
rockylinux_url=$(get_rockylinux_url)
if [ -n "$rockylinux_url" ]; then
    filename=$(basename "$rockylinux_url")
    download_if_new "$rockylinux_url" "$filename" "Rocky Linux Minimal"
fi

# Debian
log_message "Recherche de la dernière version Debian minimal..."
debian_url=$(get_debian_url)
if [ -n "$debian_url" ]; then
    filename=$(basename "$debian_url")
    download_if_new "$debian_url" "$filename" "Debian Minimal"
fi

# OpenBSD
log_message "Recherche de la dernière version OpenBSD..."
openbsd_url=$(get_openbsd_url)
if [ -n "$openbsd_url" ]; then
    filename=$(basename "$openbsd_url")
    download_if_new "$openbsd_url" "$filename" "OpenBSD"
fi

# FreeBSD
log_message "Recherche de la dernière version FreeBSD..."
freebsd_url=$(get_freebsd_url)
if [ -n "$freebsd_url" ]; then
    filename=$(basename "$freebsd_url")
    download_if_new "$freebsd_url" "$filename" "FreeBSD"
fi

# RockyLinux 10.x
log_message "Recherche de la dernière version RockyLinux 10.x minimal..."
rockylinux10_url=$(get_rockylinux10_url)
if [ -n "$rockylinux10_url" ]; then
    filename=$(basename "$rockylinux10_url")
    download_if_new "$rockylinux10_url" "$filename" "RockyLinux 10.x Minimal"
fi

# AlmaLinux 10.x
log_message "Recherche de la dernière version AlmaLinux 10.x minimal..."
almalinux10_url=$(get_almalinux10_url)
if [ -n "$almalinux10_url" ]; then
    filename=$(basename "$almalinux10_url")
    download_if_new "$almalinux10_url" "$filename" "AlmaLinux 10.x Minimal"
fi

# NetBSD
log_message "Recherche de la dernière version NetBSD minimal..."
netbsd_url=$(get_netbsd_url)
if [ -n "$netbsd_url" ]; then
    filename=$(basename "$netbsd_url")
    download_if_new "$netbsd_url" "$filename" "NetBSD Minimal"
fi

# TrueNAS-SCALE
log_message "Recherche de la dernière version TrueNAS-SCALE..."
truenas_scale_url=$(get_truenas_scale_url)
if [ -n "$truenas_scale_url" ]; then
    filename=$(basename "$truenas_scale_url")
    download_if_new "$truenas_scale_url" "$filename" "TrueNAS-SCALE"
fi

# Alpine Linux
log_message "Recherche de la dernière version Alpine Linux standard..."
alpinelinux_url=$(get_alpinelinux_url)
if [ -n "$alpinelinux_url" ]; then
    filename=$(basename "$alpinelinux_url")
    download_if_new "$alpinelinux_url" "$filename" "Alpine Linux Standard"
fi

# Nettoyage
rm -rf "$TEMP_DIR"

log_message "=== FIN DU TÉLÉCHARGEMENT DES ISO ==="
log_message "Les ISO sont stockés dans: $ISO_DIR"
log_message "Log disponible dans: $LOG_FILE"
