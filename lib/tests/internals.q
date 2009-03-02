\d .tst
.tst.defaultAssertState:.tst.assertState:``failures`assertsRun!(::;();0);

internals:()!()
internals[`specObj]:((),`result)!((),`didNotRun)
internals[`defaultExpecObj]:`result`errorText!(`didNotRun;())
internals[`testObj]: internals[`defaultExpecObj], ((),`type)!(),`test
internals[`fuzzObj]: internals[`defaultExpecObj], `type`runs`vars`maxFailRate!(`fuzz;100;`int;0f)
internals[`perfObj]: internals[`defaultExpecObj], ((),`type)!(),`perf

