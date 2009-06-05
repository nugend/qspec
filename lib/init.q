.u.require .u.PKGLOADING,"/mock.q"
.u.require .u.PKGLOADING,"/tests/internals.q"
.u.require .u.PKGLOADING,"/tests/assertions.q"
.u.require .u.PKGLOADING,"/tests/ui.q"
.u.require .u.PKGLOADING,"/tests/expec.q"
.u.require .u.PKGLOADING,"/tests/fuzz.q"
.u.require .u.PKGLOADING,"/loader.q"

.tst.PKGNAME: .u.PKGLOADING

.tst.loadOutputModule:{[module];
 if[not module in enlist "text"; '"Unknown OutputModule ",module];
 .u.require .tst.PKGNAME,"/output/",module,".q"
 }
