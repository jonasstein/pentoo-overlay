# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev

HASH_COMMIT="7afa751a9673c0427d75116eac14dce2d19adedb"

DESCRIPTION="A general purpose RFID tool for Proxmark3 hardware"
HOMEPAGE="https://github.com/Proxmark/proxmark3"
SRC_URI="https://github.com/Proxmark/${PN}/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="firmware"

#fpga_compress fails to compile
MAKEOPTS="${MAKEOPTS} -j1"

DEPEND="virtual/libusb:0
	sys-libs/ncurses:*[tinfo]
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	sys-libs/readline:=
	firmware? ( sys-devel/gcc-arm-none-eabi )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${HASH_COMMIT}

src_prepare() {
	sed -i -e 's/-ltermcap/-ltinfo/g' client/Makefile || die
	sed -i -e 's/-ltermcap/-ltinfo/g' liblua/Makefile || die
	sed -i -e 's#lualibs/#../../usr/share/proxmark3/lualibs/#' client/scripting.h || die
	sed -i -e 's#scripts/#../../usr/share/proxmark3/scripts/#' client/scripting.h || die
	mv driver/77-mm-usb-device-blacklist.rules driver/77-pm3-usb-device-blacklist.rules
	eapply_user
}

src_compile(){
	if use firmware; then
		emake all
	else
		emake client
	fi
}

src_install(){
	dobin client/{flasher,proxmark3,fpga_compress}
	#install scripts too
	insinto /usr/share/proxmark3/lualibs
	doins client/lualibs/*
	insinto /usr/share/proxmark3/scripts
	doins client/scripts/*
	if use firmware; then
		insinto /usr/share/proxmark3
		doins armsrc/obj/*.elf
		doins bootrom/obj/bootrom.elf
		doins recovery/*.bin
		doins tools/mfkey/mfkey{32,64}
	fi
	udev_dorules driver/77-pm3-usb-device-blacklist.rules
}
