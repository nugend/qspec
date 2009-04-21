.tst.desc["Test Loading"]{
 before{
  `basePath mock ` sv (` vs .tst.tstPath)[0],`nestedFiles;
  `pathList mock `foo`bar`baz!` sv' basePath,'`foo`bar`baz;
 };
 should["recursively find all files matching an extension in a path"]{
  (asc ` sv' `a`b`c`d`d,'`q) musteq asc (` vs' .tst.suffixMatch[".q";pathList[`foo]])[;1];
  `e.k musteq asc (` vs' .tst.suffixMatch[".k";pathList[`foo]])[;1];
  };
 should["find all test files in a list of paths"]{
  (asc ` sv' `a`b`c`d`d`f`g,'`q) musteq asc (` vs' .tst.findTests[value pathList])[;1];
  };
 should["return a q file given a q file"]{
  path: ` sv (value pathList)[0],`one`a.q; / Happen to know this file exists
  path musteq .tst.findTests[path];
  };
 };
