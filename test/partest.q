\l ../querqus.q;

test:{z~.[.qu.rparse;(x;y);::]};
testtime:{[parser;input;expected;times]
    do[times;r,:(system"t [parser][input]")];
    expected>=avg r};

// begin tests
flip(!).(`func;.qu.ret)