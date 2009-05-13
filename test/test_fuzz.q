
.tst.desc["Fuzz expectations"]{
 should["let you set the number of runs"]{};
 should["let you set the maximum percentage of failures"]{};
 should["not restore mocked variables after every fuzz run"]{};
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
  .tst.pickFuzz[l;20] mustin l;
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
