if["" ~ @[get;`.tst.LIB_PATH;""];.tst.LIB_PATH:""] / Allow an override for the library path to exist

/ This could be used for a pretty generic path search and load module... maybe later
/ Attempt to find and load a list of files in order.  Will only load one file
.tst.tmp.load_libs:{[files];
 allfiles: files;
 while[count files;
  if[-11h ~ type key first files;
   system "l ", 1 _ string first files;
   :first files
   ];
   files: 1 _ files
   ];
  '"File not found in search paths!";
 }

.tst.tmp.prep_paths:{hsym each x where not null x:distinct raze `$":" vs' $[10h = type x;enlist x;x]}

/ Load each path/file combination in the default search path order
.tst.tmp.load:{[paths;file_paths];
 .tst.tmp.load_libs each ` sv'' (.tst.tmp.prep_paths paths) ,\:/: file_paths}

/ Raze nested lists of symbols to list of symbol lists
.tst.tmp.raze1:{$[11h ~ abs type x;enlist x;x],enlist y}/

.tst.tmp.make_file_list:{$[11h ~ abs type x;x;.tst.tmp.raze1 .z.s each (-1 _ x),/:(last x)]}

/ Specific files to be loaded and paths to be searched
.tst.tmp.load_files:(`mock.q;
                    (`tests;(`internals.q;
                             `assertions.q;
                             `ui.q;
                             `expec.q;
                             `fuzz.q)))

/.tst.tmp.paths: (enlist .tst.LIB_PATH),(getenv each `PATH`LD_LIBRARY_PATH)
.tst.tmp.paths: .tst.LIB_PATH
.tst.tmp.files: raze .tst.tmp.make_file_list each .tst.tmp.load_files

.tst.tmp.load[.tst.tmp.paths;.tst.tmp.files];

delete tmp from `.tst;
