# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Web server vulnerability scanner"
HOMEPAGE="http://www.cirt.net/Nikto2"
COMMIT="b8454661c4dc9249cb515311cb2a80906a0a4b7a"
MY_P="${PN}-${COMMIT}"
SRC_URI="https://github.com/sullo/nikto/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

#nikto provie its own libwhisker, do no use net-libs/libwhisker[ssl]
RDEPEND="dev-lang/perl
	virtual/perl-JSON-PP
	net-analyzer/nmap
	ssl? (
		dev-libs/openssl
		dev-perl/Net-SSLeay
	)
"

S="${WORKDIR}/${MY_P}/program"

src_prepare() {
	sed -i -e 's:config.txt:nikto.conf:g' plugins/* || die
	sed -i -e 's:/etc/nikto.conf:/etc/nikto/nikto.conf:' nikto.pl || die
	sed -i -e 's:# EXECDIR=/opt/nikto:EXECDIR=/usr/share/nikto:' nikto.conf || die

	default
}

src_install() {
	insinto /etc/nikto
	doins nikto.conf

	dobin nikto.pl replay.pl
	dosym nikto.pl /usr/bin/nikto

	dodir /usr/share/nikto
	insinto /usr/share/nikto
	doins -r plugins templates databases

	dodoc docs/*.txt
	dodoc docs/nikto_manual.html
}
