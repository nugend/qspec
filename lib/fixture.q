/ Need to manage directories or only attempt to use absolute paths (latter is probably easier)
.tst.fixtureAs:{[fixtureName;name];
 dirPath: (` vs .tst.tstPath) 0;
 fixtureInDir:{$[any mp:x = (` vs' ps:(key y))[;0];` sv y,first ps where mp;`]};
 fixture: $[not ` ~ fp:fixtureInDir[fixtureName;dirPath];
 .tst.loadFixture[fp;name];
 (`fixtures in key dirPath) and not ` ~ fp:fixtureInDir[fixtureName;` sv dirPath,`fixtures];
 .tst.loadFixture[fp;name];
 '"Error loading fixture '", (string fixtureName), "', not found in:\n\t", (1 _ string dirPath),"\n\t", (1 _ string ` sv dirPath,`fixtures)];
 fixture ^ name
 }

.tst.loadFixture:{[path;name];
 $[2 = count fixtureName:` vs (` vs path) 1; / If there is an extension on the file path of the fixture
  .tst.loadFixtureTxt[path;name];
  -11h = type key path;
  .tst.loadFixtureFile[path;name];
  all -11h = (type key@) each ` sv' path,'key path; / If the path is a directory of files (splayed dir)
  .tst.loadFixtureFile[path;name];
  .tst.loadFixtureDir[path;name]];
 first fixtureName
 }

.tst.fixture:.tst.fixtureAs[;`]
.tst.currentDirFixture:`

.tst.loadFixtureDir:{[f;name];
 fixtureName: (` vs f) 1;
 dirFixtureLoaded: not ` ~ .tst.currentDirFixture;
 if[not dirFixtureLoaded;.tst.saveDir[];];
 if[not fixtureName ~ .tst.currentDirFixture;
  if[dirFixtureLoaded;.tst.removeDirVars[];];
  system "l ", 1 _ string f;
  .tst.currentDirFixture: fixtureName;
  ];
 }

.tst.loadFixtureTxt:{[f;name];
 fname: ((` vs (` vs f) 1) 0) ^ name;
 .tst.mock[fname;(raze l[0;1] vs l[0];enlist l[0;1]) 0: 1 _ l: read0 f];
 fname
 }

.tst.loadFixtureFile:{[f;name];
 .tst.mock[fname:((` vs f) 1) ^ name;get f];
 fname
 }

.tst.savedDir:.tst.defaultSavedDir:`directory`vars!("";(`,())!(),(::))
.tst.saveDir:{
 if[not () ~ dirVars: .tst.findDirVars[];
  .tst.savedDir:`directory`vars!(system "cd";(!).(::;get each)@\:` sv' `.,'dirVars);
  .tst.removeDirVars dirVars];
 }

.tst.removeDirVars:{![`.;();0b;] $[(::) ~ x;.tst.findDirVars[];x]}

.tst.restoreDir:{
 if[not ` ~ .tst.currentDirFixture;
  .tst.removeDirVars[];
   .tst.currentDirFixture:`];
 if[not "" ~ .tst.savedDir.directory;
  system "l ", .tst.savedDir.directory;
  (key .tst.savedDir.vars) set' value .tst.savedDir.vars;
  .tst.savedDir: .tst.defaultSavedDir;]
 }


/ Get a list of files (and thus variables) from the partition directory that do not match special partition directory files:
/ ie: Exclue the par.txt file and any partition directories (contained in the list .Q.ps), include the partition variable (.Q.pf) and the known partition tables (.Q.pt)
/ These will be the variables to delete from the top level namespace when we swap out a partition directory fixture
.tst.findDirVars:{
 $[count where -1h = (type .Q.qp get@) each ` sv' `.,'tables `.;    /.Q.qp returns a boolean only when a table is a partition table or a splayed table
  distinct .Q.pf,.Q.pt,pvals where not any (pvals:key `:.) like/:(string .Q.pv),enlist "par.txt";
  ()]
 }

