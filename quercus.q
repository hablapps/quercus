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

lit:{$[x~count[x]#y;(count[x]_y;x);()]} / literal text
chr:lit x / char

rep:{r:();while[not ()~a:x y;r,:a 1;y:a 0];(y;r)} / repeat

cin:{$[(y1:first y)in x;(1_y;y1);()]} / char in

num:{"I"$(cin (first')string til 10)[x]} / number

