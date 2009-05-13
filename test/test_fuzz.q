
.tst.desc["Fuzz expectations"]{
 before{
  `.tst.contextHelper mock {[x;y] system "d ", string x} system "d"; / Need to change back to the proper execution context after every call that refers to a mocked variable in the current context
  `myRestore mock .tst.restore; / Mocking restore so the UI doesn't get clobbered
  `.tst.restore mock {};
  `.tst.expecList mock .tst.expecList;
  };
 after{
  myRestore[];
  };
 should["run the fuzz test the number of times specified"]{
  `ran mock 0;
  holds["run this";((),`runs)!(),20]{ran+:1};
  e: last .tst.expecList;
  .tst.runExpec e;
  .tst.contextHelper[];
  ran musteq 20;
  `ran mock 0;
  holds["run this";((),`runs)!(),40]{ran+:1};
  e: last .tst.expecList;
  .tst.runExpec e;
  .tst.contextHelper[];
  ran musteq 40;
  };
 should["fail when the percentage of failures exceeds the maximum percentage of failures"]{
  oldFailures: .tst.assertState.failures; / Don't want intentional failures made in the name of testing to cause a test failure
  `ran mock 0;
  holds["run this";`runs`maxFailRate!(20;.5)]{
   ran+:1;
   if[ran > 9; 1 musteq 2]; / Force failure for a certain percentage
   };
  e: last .tst.expecList;
  e:.tst.runExpec e;
  .tst.contextHelper[];
  testedFailures: .tst.assertState.failures;
  .tst.assertState.failures:oldFailures;
  e[`failRate] mustgt .5;
  e[`result] mustlike "*Fail";
  };
 should["not restore mocked variables between fuzz runs"]{
  `ran mock 0;
  holds["run this";((),`runs)!(),20]{ran+:1};
  e: last .tst.expecList;
  .tst.runExpec e;
  .tst.contextHelper[];
  ran musteq 20;
  };
 should["provide fuzz variables to the function"]{
  `aVar mock 0b;
  `bVar mock 0b;
  `cVar mock 0b;
  `xKey mock `symbol$();
  holds["run this";(`runs`vars)!(1;`a`b`c!(`symbol;1 2 3;20#0Nd))]{
   xKey:: key x;
   aVar:: x`a;
   bVar:: x`b;
   cVar:: x`c;
   };
  e: last .tst.expecList;
  .tst.runExpec e;
  .tst.contextHelper[];
  `a`b`c mustin xKey;
  type[aVar] musteq -11h;
  x[bVar] mustin 1 2 3;
  count[cVar] mustlt 20;
  type[cVar] musteq 14h;
  };
 };

.tst.desc["The Fuzz Generator"]{
 should["return a list of fuzz values of the given type provided a symbol"]{
  type[.tst.pickFuzz[`symbol;1]] musteq 11h;
  type[.tst.pickFuzz[`int;100]] musteq 6h;
  type[.tst.pickFuzz[`time;10]] musteq 19h;
  };
 should["run a generator function once for every run requested"]{
  `runsDone mock 0;
   .tst.pickFuzz[{runsDone+:1};100];
   runsDone musteq 100;
  };
 should["return a table of distinct fuzz values given a dictionary"]{
  r: .tst.pickFuzz[`a`b`c!`int`float`symbol;20];
  type[r] musteq 98h;
  type[r`a] musteq 6h;
  type[r`b] musteq 9h;
  type[r`c] musteq 11h;
  };
 should["return a list of elements from a general list"]{
  l: (10;`a;"foo";`a`b`c!1 2 3);
  (10,.tst.pickFuzz[l;20]) mustin l; / Force the list to start with an atom so the comparison works right
  };
 should["return a list of elements from a typed list"]{
  l: 10 30 33 22 80 4;
  .tst.pickFuzz[l;40] mustin l;
  l: `x`z`f`blah`ep;
  .tst.pickFuzz[l;40] mustin l;
  };
 should["return lists of fuzz values less than the maximum length given an empty typed list"]{
  l:.tst.pickFuzz[`float$();100];
  (count each l) mustlt .tst.fuzzListMaxLength;
  (type each l) musteq 9h;
  };
 should["return lists of fuzz values less than the specified length given a list of null values of a single type"]{
  l:.tst.pickFuzz[20#0Nd;100];
  (count each l) mustlt 20;
  (type each l) musteq abs type 0Nd;
  };
 should["return lists of fuzz values of the specified length based on a single value provided a list of identical elements"]{
  l: .tst.pickFuzz[20#100;1000];
  (count each l) mustlt 20;
  l mustlt' 100;
  l: .tst.pickFuzz[20#200;1000];
  l mustlt' 200;
  };
 };
