# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $id$

EAPI=5

inherit eutils

DESCRIPTION="Bruteforce offline the WPS pin exploiting the low or non-existing entropy"
HOMEPAGE="https://github.com/wiire/pixiewps"
SRC_URI="https://github.com/wiire/pixiewps/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

src_prepare() {
	epatch ${FILESDIR}/pixiewps-make.patch
	sed -i -e 's|/usr/local|/usr|' Makefile
}

src_install(){
	default
	dodoc ../README.md
}