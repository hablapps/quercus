\l quercus.q
\l test/tests.q

test:{z~.[.qu.rparse;(x;y);::]};
testtime:{[parser;input;expected;times]
    system "t ",parser,input}
evaluation:{{test[x;y;z]}' [x[`parser];x[`input];x[`expected]]};

addTests: {
    k!{
        (&/)evaluation[v,flip([]parser:{
            op:get[`.qu]x;
            $[count[y]>0;op . y;op]}[y;] peach (v:x[y])`args)]}[t;] peach k:1 _ key t:get`.test};

tests: ([]function: key s;test: value s:addTests[])