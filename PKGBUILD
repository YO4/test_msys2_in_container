pkgbase=msys2-runtime
pkgname=('msys2-runtime' 'msys2-runtime-devel')
pkgver=0.0.0
pkgrel=1
pkgdesc="Cygwin POSIX emulation engine"
arch=('x86_64')
license=('GPL')
makedepends=('cocom'
#            'git'
             'perl'
             'gcc'
             'mingw-w64-cross-crt-git'
             'mingw-w64-cross-gcc'
             'mingw-w64-cross-zlib'
             'zlib-devel'
             'gettext-devel'
             'libiconv-devel'
             'autotools'
             'xmlto'
             'docbook-xsl')
# re zipman: https://github.com/msys2/MSYS2-packages/pull/2687#issuecomment-965714874
options=('!zipman')
source=('git+https://github.com/YO4/msys2-runtime#branch=in-container-posix-semantics')
sha256sums=('SKIP')

# =========================================== #
pkgver() {
  cd "${srcdir}"/msys2-runtime
  git log -n1 --pretty=format:wip%ad.%h --date=format:%Y%m%d | head -1
}

prepare() {
  cd "${srcdir}"/msys2-runtime
  if test true != "$(git config core.symlinks)"
  then
    git config core.symlinks true &&
    git reset --hard
  fi
}

build() {
  [[ -d "${srcdir}"/build-${CHOST} ]] && rm -rf "${srcdir}"/build-${CHOST}
  mkdir -p "${srcdir}"/build-${CHOST} && cd "${srcdir}"/build-${CHOST}

  # Gives more verbose compile output when debugging.
  local -a extra_config
  if check_option "debug" "y"; then
    export CCWRAP_VERBOSE=1
    OPTIM="-O0"
    extra_config+=(--enable-debugging)
  else
    OPTIM="-O2"
  fi

  CFLAGS="$OPTIM -pipe -ggdb -Wno-error=deprecated -Wno-error=stringop-truncation -Wno-error=missing-attributes -Wno-error=maybe-uninitialized" #-Wno-error=class-memaccess
  CXXFLAGS="$OPTIM -pipe -ggdb -Wno-error=deprecated -Wno-error=stringop-truncation -Wno-error=missing-attributes -Wno-error=maybe-uninitialized" #-Wno-error=class-memaccess

  # otherwise it asks git which appends "-dirty" because of our uncommited patches
  CFLAGS+=" -DCYGPORT_RELEASE_INFO=${pkgver}"

  (cd "${srcdir}/msys2-runtime/winsup" && ./autogen.sh)

  "${srcdir}"/msys2-runtime/configure \
    --prefix=/usr \
    --build=${CHOST} \
    --sysconfdir=/etc \
    "${extra_config[@]}"
  LC_ALL=C make
  LC_ALL=C make -j1 DESTDIR="${srcdir}"/dest install

  #pushd ${CHOST}/winsup/cygwin > /dev/null
  #LANG=C make libmsys2_s.a
  #cp libmsys2_s.a "${srcdir}"/dest/usr/${CHOST}/lib/
  #popd > /dev/null

  rm -rf "${srcdir}"/dest/etc
}

package_msys2-runtime() {
  pkgdesc="Posix emulation engine for Windows"
  conflicts=('catgets' 'libcatgets' 'msys2-runtime-3.4')
  replaces=('catgets' 'libcatgets' 'msys2-runtime-3.4')

  mkdir -p "${pkgdir}"/usr
  cp -rf "${srcdir}"/dest/usr/bin "${pkgdir}"/usr/
  cp -rf "${srcdir}"/dest/usr/libexec "${pkgdir}"/usr/
  rm -f "${pkgdir}"/usr/bin/cyglsa-config
  rm -f "${pkgdir}"/usr/bin/cyglsa.dll
  rm -f "${pkgdir}"/usr/bin/cyglsa64.dll
  rm -f "${pkgdir}"/usr/bin/cygserver-config
  cp -rf "${srcdir}"/dest/usr/share "${pkgdir}"/usr/
}

package_msys2-runtime-devel() {
  pkgdesc="MSYS2 headers and libraries"
  depends=("msys2-runtime=${pkgver}")
  conflicts=('libcatgets-devel' 'msys2-runtime-3.4-devel')
  replaces=('libcatgets-devel' 'msys2-runtime-3.4-devel')

  mkdir -p "${pkgdir}"/usr/bin
  cp -rLf "${srcdir}"/dest/usr/${CHOST}/include "${pkgdir}"/usr/
  rm -f "${pkgdir}"/usr/include/iconv.h
  rm -f "${pkgdir}"/usr/include/unctrl.h
  # provided by libtirpc
  rm -fr "${pkgdir}"/usr/include/rpc/

  cp -rLf "${srcdir}"/dest/usr/${CHOST}/lib "${pkgdir}"/usr/
}
