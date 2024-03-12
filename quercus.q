/ 
Copyright 2024 Habla Computing SL.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
\

l:{$[x~count[x]#y;(count[x]_y;x);()]} / literal
c:{[x:`c;y]$[x~first y;(1_y;x);()]} / char
rep:{r:();while[not ()~()a:x y;y:a 0;r,:a 1];(y;r)} / repeat
cin:{$[(y1:first y)in x;(1_y;y1);()]} / char in
num:{@[rep[cin["0123456789"]][x];1;"J"$]} / number
seq:{(s0;a):x z;(s1;b):y s0;(s1;(a;b))} / sequence
par:{$[()~r:x z;y z;r]} / parallel
map:{(s;a):y z;(s;x a)} / map
end:{$[x~"";("",());()]} / $
bnd:{[x;y;z](s0;a):x z;y[a][s0]} / monadic bind
e:{$[()~r:x y;'`parse;not ""~r 0;'`rest;r 1]} / eval

