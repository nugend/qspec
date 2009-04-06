\d .tst
/ Ideas:
/ .tst.VAR containing possible fixture paths
/ Environment variable with fixture paths?
.tst.fixtureAs:{[fixtureName;name];
 dirPath: (` vs .tst.tstPath) 0;
 fixtureInDir:{$[any mp:x = (` vs' ps:(key y))[;0];` sv y,first ps where mp;`]};
 fixture: $[not ` ~ fp:fixtureInDir[fixtureName;dirPath];
 loadFixture[fp;name];
 (`fixtures in key dirPath) and not ` ~ fp:fixtureInDir[fixtureName;` sv dirPath,`fixtures];
 loadFixture[fp;name];
 '"Error"];
 fixture ^ name
 }

.tst.loadFixture:{[path;name];
 $[2 = count n:` vs (` vs path) 1; / If there is an extension on the file path of the fixture
  loadFixtureTxt[path;name];
  -11h = type key path;
  loadFixtureFile[path;name];
  [$[` ~ .tst.currentDirFixture;saveDir[];removeDirVars[]];
   if[not (first n) ~ .tst.currentDirFixture;system "l ", 1 _ string path;
   .tst.currentDirFixture: first n;
   ];]];
 first n
 }

.tst.fixture:.tst.fixtureAs[;`]
.tst.currentDirFixture:`

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
saveDir:{
 if[not () ~ dirVars: findDirVars[];
  .tst.savedDir:`directory`vars!(system "cd";(!).(::;get each)@\:` sv' `.,'dirVars);
  removeDirVars dirVars];
 }

removeDirVars:{![`.;();0b;] $[(::) ~ x;findDirVars[];x]}

restoreDir:{
 if[not ` ~ .tst.currentDirFixture;removeDirVars[]];
 if[not "" ~ .tst.savedDir.directory;
  system "l ", .tst.savedDir.directory;
  (key .tst.savedDir.vars) set' value .tst.savedDir.vars;
  .tst.savedDir: .tst.defaultSavedDir;]
 }


/ Get a list of files (and thus variables) from the partition directory that do not match special partition directory files:
/ ie: Exclue the par.txt file and any partition directories (contained in the list .Q.ps), include the partition variable (.Q.pf) and the known partition tables (.Q.pt)
/ These will be the variables to delete from the top level namespace when we swap out a partition directory fixture
findDirVars:{
 $[count where -1h = (type .Q.qp get@) each tables `.;    /.Q.qp returns a boolean only when a table is a partition table or a splayed table
  distinct .Q.pf,.Q.pt,pvals where not any (pvals:key `:.) like/:(string .Q.pv),enlist "par.txt";
  ()]
 }

