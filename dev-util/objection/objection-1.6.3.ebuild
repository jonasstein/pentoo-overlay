# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Runtime mobile exploration"
HOMEPAGE="https://github.com/sensepost/objection"
SRC_URI="https://github.com/sensepost/objection/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-util/frida-tools[${PYTHON_USEDEP}]
	dev-python/frida-python[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-2.0.8[${PYTHON_USEDEP}] <dev-python/prompt_toolkit-3.0.0[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/delegator[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare(){
	rm -r tests
	eapply_user
}
