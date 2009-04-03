\d .tst
/ Ideas:
/ .tst.VAR containing possible fixture paths
/ Environment variable with fixture paths?
.tst.fixture:{[fixtureName];
 dirPath: (` vs .tst.tstPath) 0;
 fixtures: $[fixtureName in key dirPath;
 ` sv dirPath,fixtureName;
 (`fixtures in key dirPath) and (fixtureName) in key ` sv dirPath,`fixtures;
 ` sv dirPath,`fixtures,fixtureName;
 '"Error"];
 }

.tst.currentDirFixture:`
.tst.savedDir:.tst.defaultSavedDir:`directory`vars!("";(`,())!(),(::))
saveDir:{
 if[not () ~ dirVars: findDirVars[];
  .tst.savedDir:`directory`vars!(system "cd";(!).(::;get each)@\:` sv' `.,'dirVars);
  removeVars dirVars];
 }

removeDirVars:{![`.;();0b;] $[(::) ~ x;findDirVars[];x]}

restoreDir:{
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

