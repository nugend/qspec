if["" ~ @[get;`.tst.LIB_PATH;""];.tst.LIB_PATH:""] / Allow an override for the library path to exist

/ This could be used for a pretty generic path search and load module... maybe later
/ Attempt to find and load a list of files in order.  Will only load one file
.tst.tmp.load_libs:{[files];
 allfiles:files;
 while[count files;
  if[-11h ~ type key first files;
   system "l ", 1 _ string first files;
   :first files
   ];
   files: 1 _ files
   ];
  '"File not found at library load paths:\n\t", "\n\t" sv 1 _' string allfiles;
 }

.tst.tmp.prep_paths:{
 paths: hsym each `$raze ":" vs' ?[-11h = type each x;@[getenv;;""] each x;x];
 paths where not null paths
 }

/ Load each path/file combination in the default search path order
.tst.tmp.load:{[lib_paths;file_paths];
 / The order is important for the join between the lib paths and the file paths
 / You need to have (((lib_path1;file_path1);(lib_path2;file_path1));(lib_path1;file_path2)...
 .tst.tmp.load_libs each ` sv'' (.tst.tmp.prep_paths lib_paths) ,\:/: file_paths}

/ Raze nested lists to *only* lists of lists
.tst.tmp.raze1:{x,$[min 0h > type each y;enlist y;y]}/[();]

.tst.tmp.make_file_list:{$[11h ~ abs type x;x;.tst.tmp.raze1 .z.s each (-1 _ x),/:(last x)]}

/ Specific files to be loaded and paths to be searched
.tst.tmp.load_files:enlist (`qspec;(`mock.q;
                                   (`tests;(`internals.q;
                                            `assertions.q;
                                            `ui.q;
                                            `expec.q;
                                            `fuzz.q))))

.tst.tmp.paths: (`LD_LIBRARY_PATH;.tst.LIB_PATH;`QPATH;`Q_PATH)
.tst.tmp.files: .tst.tmp.raze1 over .tst.tmp.make_file_list each .tst.tmp.load_files

.tst.tmp.load[.tst.tmp.paths;.tst.tmp.files];

delete tmp from `.tst;
