\d .tst
.tst.defaultAssertState:.tst.assertState:``failures`assertsRun!(::;();0);
.tst.tstPath: `;

internals:()!()
internals[`]:()!()
internals[`specObj]:`result`title!(`didNotRun;"")
internals[`defaultExpecObj]:`result`errorText!(`didNotRun;())
internals[`testObj]: internals[`defaultExpecObj], ((),`type)!(),`test
internals[`fuzzObj]: internals[`defaultExpecObj], `type`runs`vars`maxFailRate!(`fuzz;100;`int;0f)
internals[`perfObj]: internals[`defaultExpecObj], ((),`type)!(),`perf

if[not `callbacks in key .tst; / Avoid callback overwriting issue when dogfooding
 callbacks:((),`)!(),(::);
 callbacks[`loadDesc]:{};
 ];

