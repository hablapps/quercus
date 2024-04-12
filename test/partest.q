\l quercus.q
\l test/tests.q

test:{z~.[.qu.rparse;(x;y);::]};
testtime:{[parser;input;expected;times]
    system "t ",parser,input}
evaluation:{{test[x;y;z]}' [x[`parser];x[`input];x[`expected]]};

f:{({{$[(type[x]<0) or type[x]>20;enlist x;x]} each x} each `expected _ x), ([expected: x `expected])};
g:{{$[type[x]=0;x;enlist x]} each x}
h: {$[type[x]=0;`args`input`expected!flip x;x]}
addTests: {
    k!{
        v:f g h x y;
        (&/)evaluation[v,flip([]parser:{
            op:get[`.qu]x;
            $[count[y]>0;op . y;op]}[y;] peach v `args)]}[t;] peach k:1 _ key t:get`.test};

tests: ([]function: key s;test: value s:addTests[])