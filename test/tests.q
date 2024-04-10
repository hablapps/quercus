// begin tests
\d .test
/f:{{{$[type[x]<0;enlist x;x]} each x} each x};
times: ([args:((2;.qu.digit);(3;.qu.digit);(2;.qu.lwr)); input: ("12";"1234";"ab"); expected: ("12";"spare";"ab")]);
lwr: ([args:(();());input:(enlist"a";"abc");expected:("a";"spare")])
many: ([args:(enlist .qu.digit;enlist .qu.lwr;enlist .qu.lwr);input:("123";"abcd";"");expected:("ambig";"ambig";())])
many1: ([args:enlist(enlist .qu.digit);input:enlist("");expected:enlist("parse")])
range: ([args: ("25";"ad";"az");input:(enlist"3";enlist "b";enlist "A"); expected:("3";"b";"parse")])
\d .
