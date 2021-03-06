# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A software reverse engineering framework"
HOMEPAGE="https://www.nsa.gov/ghidra"
SRC_URI="https://github.com/NationalSecurityAgency/ghidra/archive/Ghidra_${PV}_build.tar.gz
	https://github.com/pxb1988/dex2jar/releases/download/2.0/dex-tools-2.0.zip
	https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/android4me/AXMLPrinter2.jar
	https://sourceforge.net/projects/catacombae/files/HFSExplorer/0.21/hfsexplorer-0_21-bin.zip
	mirror://sourceforge/yajsw/yajsw/yajsw-stable-12.12.zip
	https://dev.pentoo.ch/~blshkv/distfiles/ghidra-${PV}-gradle-dependencies.tar.gz"
#run: pentoo/scripts/gradle_dependencies.py from "${S}" directory to generate dependencies
#tar cvzf ./ghidra-9.0.2-gradle-dependencies.tar.gz -C /var/tmp/portage/dev-util/ghidra-9.0.2/work ghidra-Ghidra_9.0.2_build/dependencies/

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.8"
DEPEND="${DEPEND}
	>=virtual/jdk-1.8
	dev-java/gradle-bin:5.2.1
	sys-devel/bison
	dev-java/jflex
	dev-java/oracle-jdk-bin:11
	app-arch/unzip"

S="${WORKDIR}/ghidra-Ghidra_${PV}_build"

src_unpack() {
	#https://github.com/NationalSecurityAgency/ghidra/blob/05ad1aa9f3a28721467ae288be6769f226f7147d/DevGuide.md
	unpack ${A}
	mkdir -p "${S}/.gradle/flatRepo"
	cd "${S}/.gradle"

	unpack dex-tools-2.0.zip
	cp dex2jar-2.0/lib/dex-*.jar ./flatRepo || die "unable to copy some dist files"

	cp "${DISTDIR}/AXMLPrinter2.jar" ./flatRepo  || die "unable to copy some dist files"

	unpack hfsexplorer-0_21-bin.zip
	cp lib/*.jar ./flatRepo || die "unable to copy some dist files"

#	cp "${DISTDIR}"/jython-standalone-2.7.1.jar ./flatRepo || die "unable to copy some dist files"

	#/var/tmp/portage/dev-util/ghidra-9.0.2/work/ghidra.bin/Ghidra/Features/GhidraServer/yajsw-stable-12.12.zip'
	mkdir -p "${WORKDIR}"/ghidra.bin/Ghidra/Features/GhidraServer/
	cp "${DISTDIR}"/yajsw-stable-12.12.zip "${WORKDIR}"/ghidra.bin/Ghidra/Features/GhidraServer/ || die "unable to copy some dist files"

	cd "${S}"
}

src_prepare() {
	sed -i 's|gradle.gradleVersion != "5.0"|gradle.gradleVersion <= "5.0"|g' build.gradle || die 'sed failed'
	mkdir -p ".gradle/init.d"
	cp "${FILESDIR}"/repos.gradle .gradle/init.d
	sed -i "s|S_DIR|${S}|g" .gradle/init.d/repos.gradle
	#remove build date so we can unpack dist.zip later
	sed -i "s|_\${rootProject.BUILD_DATE_SHORT}||g" gradleScripts/distribution.gradle
	eapply_user
}

src_compile() {
	export JAVA_HOME="/opt/oracle-jdk-bin-11.0.2"
	export JAVAC="/opt/oracle-jdk-bin-11.0.2/bin/javac"
	export _JAVA_OPTIONS="$_JAVA_OPTIONS -Duser.home=$HOME"

	GRADLE="gradle-5.2.1 --gradle-user-home .gradle --console rich --no-daemon"
	GRADLE="${GRADLE} --offline"

	${GRADLE} yajswDevUnpack -x check -x test || die
	${GRADLE} buildGhidra -x check -x test || die
}

src_install() {
	#it is easier to unpack existing archive
	dodir /usr/share
	unzip build/dist/ghidra_9.0.2_PUBLIC_linux64.zip -d "${ED}"/usr/share/ || die "unable to unpack dist zip"
	mv "${ED}"/usr/share/ghidra_9.0.2 "${ED}"/usr/share/ghidra
	#fixme: add doc flag
	rm -r  "${ED}"/usr/share/ghidra/docs/
	dosym "${EPREFIX}"/usr/share/ghidra/ghidraRun /usr/bin/ghidra
}
