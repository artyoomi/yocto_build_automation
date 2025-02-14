DESCRIPTION = "Simple helloworld application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://yadro-hello.c"

S = "${WORKDIR}"

python do_display_banner() {
    bb.plain("***********************************************");
    bb.plain("*                                             *");
    bb.plain("*      Hello world recipe added in image      *");
    bb.plain("*                                             *");
    bb.plain("***********************************************");
}

addtask display_banner before do_build

# Compile program
do_compile() {
	${CC} ${LDFLAGS} yadro-hello.c -o yadro-hello
}

# Copy it to binaries directory and make executable
do_install() {
	install -d ${D}${bindir}
	install -m 0755 yadro-hello ${D}${bindir}
}
