# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Packages needed to power the client NUC for WCTF events"
HOMEPAGE="http://wctf.us"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64"
IUSE="opencl"
S="${WORKDIR}"

RDEPEND="!pentoo/pentoo-system"

PDEPEND="dev-vcs/git
		net-misc/dhcpcd
		sys-apps/rng-tools
		sys-power/thermald
		sys-kernel/pentoo-sources
		sys-firmware/intel-microcode
		app-misc/screen
		app-editors/nano
		app-editors/vim
		dev-ruby/rb-inotify
		net-wireless/rtl8812au_aircrack-ng
		sys-process/iotop
		sys-process/htop
		sys-process/usbtop
		sys-boot/grub:2
		sys-kernel/genkernel
		app-admin/sudo
		net-wireless/wpa_supplicant
		net-wireless/aircrack-ng
		>=sys-apps/util-linux-2.31_rc1
		net-wireless/kismet
		net-wireless/kismetdb
		app-portage/gentoolkit
		app-portage/smart-live-rebuild
		net-ftp/tftp-hpa
		net-analyzer/tcpdump
		net-analyzer/nmap
		net-analyzer/netcat
		net-dns/bind-tools
		net-misc/autossh
		net-misc/ntp
		sys-apps/watchdog
		virtual/cron
		|| ( net-misc/iputils[arping(+)] net-analyzer/arping )
		opencl? ( net-wireless/gnuradio
				dev-libs/rocm-opencl-runtime
				xfce-base/xfce4-meta
				net-analyzer/gr-fosphor
				net-wireless/fosphor_knob
				x11-terms/xfce4-terminal
				www-client/google-chrome
				dev-libs/ocl-icd[khronos-headers(-)]
			)"

src_install() {
	#/usr/share/pentoo
	insinto /usr/share/pentoo
	doins "${FILESDIR}/pentoo-keyring.asc"

	#/etc/portage/repos.conf
	insinto /etc/portage/repos.conf
	doins "${FILESDIR}/pentoo.conf"

	insinto /etc/local.d
	doexe "${FILESDIR}"/99-ldm.start
}
