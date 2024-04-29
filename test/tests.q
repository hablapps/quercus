// begin tests
\d .test
times: ([args:((2;.qu.digit);(3;.qu.digit);(2;.qu.lwr)); input: ("12";"1234";"ab"); expected: ("12";"spare";"ab")]);
lwr: ([args:(();());input:("a";"abc");expected:("a";"spare")]);
many: ([args:(.qu.digit;.qu.lwr;.qu.lwr);input:("123";"abcd";"");expected:("ambig";"ambig";())]);
many1: ([args:.qu.digit;input: "";expected: "parse"]);
range: ([args: ("25";"ad";"az");input:(enlist "3";enlist "b"; enlist "A"); expected:("3";"b";"parse")]);
word: `args`input`expected!((();();());("hello";"a";"abc1");("ambig";enlist"a";"ambig"));
braces: ((.qu.word;"{hello}";"hello");(.qu.word;"{hello";"parse"))
\d .
