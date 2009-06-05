.utl.require .utl.PKGLOADING,"/mock.q"
.utl.require .utl.PKGLOADING,"/tests/internals.q"
.utl.require .utl.PKGLOADING,"/tests/assertions.q"
.utl.require .utl.PKGLOADING,"/tests/ui.q"
.utl.require .utl.PKGLOADING,"/tests/spec.q"
.utl.require .utl.PKGLOADING,"/tests/expec.q"
.utl.require .utl.PKGLOADING,"/tests/fuzz.q"
.utl.require .utl.PKGLOADING,"/loader.q"

.tst.PKGNAME: .utl.PKGLOADING

.tst.loadOutputModule:{[module];
 if[not module in enlist "text"; '"Unknown OutputModule ",module];
 .utl.require .tst.PKGNAME,"/output/",module,".q"
 }
