# FIX Protocol

## Introduction

> The Financial Information eXchange (FIX) is a vendor-neutral electronic communications protocol for the international real-time exchange of securities transaction information. The protocol is used by the FIX community, which includes nearly 300 member firms including all major investment banks.
> Investopedia

## Examples

### Message type "Logon"

`"8=FIX.4.2|9=65|35=A|49=SERVER|56=CLIENT|34=177|52=20090107-18:15:16|98=0|108=30|10=062|"`

As we can observe in the example above, the field "35" is equal to "A". This means we are facing a "Logon" message. The body of this message contains a field "98" (EncryptMethod) followed by a "108" (HeartBtInt).

### Message type "Execution Report"

`"8=FIX.4.2|9=178|35=8|49=PHLX|56=PERS|52=20071123-05:30:00.000|11=ATOMNOCCC9990900|20=3|150=E|39=E|55=MSFT|167=CS|54=1|38=15|40=2|44=15|58=PHLX EQUITY TESTING|59=0|47=C|32=0|31=0|151=15|14=0|6=0|10=128|"`

The body's fields can be seen in the following [documentation link](https://www.onixs.biz/fix-dictionary/4.2/msgType_8_8.html).

### Commonalities

We can see that only with these two examples the protocol isn't all that simple: depending on the `MsgType` we will get a different body that contains mandatory fields as well as some optional fields.

It's because of this that we need a "hardcoded" way of translating between field IDs to field name (for example, "8" should become "BeginString") and from either one of those to the type the field should have.

## Implementation using Quercus

### Foreword

First things first: we need to set our separator. Since both examples provided above were using the pipe character "|" as the separator, we will be using that exact one. Keep in mind that the FIX protocol itself uses Start of Heading ([SoH](https://www.ascii-code.com/1)). The pipe character is only used for representing the whole string since SoH isn't printable. This will affect the examples we will be using for testing our pattern since the checksum will need to be adjusted. On the "Logon" message, the checksum will become `145` instead of `062` and on the "Execution Report" we will have a checksum of `008` instead of `128`. From this point onward will be this example:

> Message type "Logon"
> ```q
> fixmsg:"8=FIX.4.2|9=65|35=A|49=SERVER|56=CLIENT|34=177|52=20090107-18:15:16|98=0|108=30|10=145|"
> ```

As for the code, we can set our operator with the following line of code:

```q
separator:"|";
```


Apart from this, we need to create the field ID to field name dictionary and either one of those to the final type the field will be cast to. This can be done with the following lines of code:

```q
ids:8 9 35 49 56 52 11 20 150 39 55 167 54 38 40 44 58 59 47 32 31 151 14 6 10 34 98 108;
idstr:`BeginString`BodyLength`MsgType`SenderCompID`TargetCompID`SendingTime`ClOrdID,
  `ExecTransType`ExecType`OrdStatus`Symbol`SecurityType`Side`OrderQty`OrdType,
  `Price`Text`TimeInForce`Rule80A`LastShares`LastPx`LeavesQty`CumQty`AvgPx`CheckSum,
  `MsgSeqNum`EncryptMethod`HeartBtInt;

types:"SJSSSZSJSSSSJJJJSJSJJJJJJJJJ";

dis:ids!idstr;
dit:idstr!types;
```

> This is a sample that only covers the fields used in these two examples we showed earlier. For a full implementation, these dictionaries would be much larger.

### Tuple pattern

With all of that out of the way, we can define the tuple pattern. In this context, we understand a tuple as a pair of field ID and the field content itself. We would wish to return them as a list of two elements (the actual tuple part), so that later on it can be all easily transformed into a dictionary, and each of the elements of this tuple should be in their correct types. For example, `8=FIX.4.2` should become:

```q
(`BeginString;`FIX.4.2)
```

Our pattern using Quercus looks like this:

```q
tuple:(seq/)(map[{dis[x]}]j;skip chr"=";many1[noneof[enlist separator]]);
```

Where we:
    1. Detect the field ID, cast it into an integer and convert it into the field name.
    2. Detect the "=" and skip it since we don't need it.
    3. Locate any number of characters as long as they are not our separator.

Only with this, we should be able to parse a single tuple:

```q
q.qu) tuple:(seq/)(map[{dis[x]}]j;skip chr"=";many1[noneof[enlist separator]]);
q.qu) show tuple"8=FIX.4.2";

((`BeginString;());"FIX.4.2") ""                       
((`BeginString;());"FIX.4.")  ,"2"                     
((`BeginString;());"FIX.4")   ".2"      
((`BeginString;());"FIX.")    "4.2"                    
((`BeginString;());"FIX")     ".4.2"                   
((`BeginString;());"FI")      "X.4.2"                  
((`BeginString;());,"F")      "IX.4.2"                 
```

This is a nice start if you ask me, but we could do even better. By using the `seqf` combinator instead of `seq`, we can apply a function to our pattern. By exploiting this, we should be able to transform this nested list into the much-needed tuple:

```q
tuple:(seqf[translate]/)(map[{dis[x]}]j;skip chr"=";many1[noneof[enlist separator]]);
```

Where `translate` follows this implementation:

```q
cast:{z[x]$y}[;;dit];
translate:{(v;cast[v:first first x;last x])};
```

In here, we get the _actual_ first element of this nested list and the field contents. The latter will then be converted into its proper type using the `dit` dictionary.

With all this, we get the following result using the same example as above:

```q
q.qu) tuple:(seqf[translate]/)(map[{dis[x]}]j;skip chr"=";many1[noneof[enlist separator]]);
q.qu) show tuple"8=FIX.4.2";

`BeginString`FIX.4.2 ""               
`BeginString`FIX.4.  ,"2"             
`BeginString`FIX.4   ".2"    
`BeginString`FIX.    "4.2"            
`BeginString`FIX     ".4.2"           
`BeginString`FI      "X.4.2"          
`BeginString`F       "IX.4.2"
```

### Matching N Tuples

Using this `tuple` pattern, we can then match N tuples. To do that, since we know that we have a set separator, we can leverage the `sep` combinator, which takes two patterns as inputs: the pattern that will be repeated and then the separator pattern. In our case, the first one will be `tuple`, whereas the second one will be simply `chr separator`, as defined above.

We also need to take into consideration that at the end of our FIX message we will find an extra separator that delimits the end of the message:

```q
fixformat:(seq/)(sep[tuple;chr separator];skip chr separator;eof);
```

Once again this will bring some noise to our output. To get rid of it, we can once again use `seqf` to "bubble up" the desired output:

```q
q.qu) fixformat:(seqf[(,).]/)(sep[tuple;chr separator];skip chr separator;eof);
q.qu) show fixformat fixmsg;

(`BeginString`FIX.4.2;(`BodyLength;65);`MsgType`A;`SenderCompID`SERVER;`TargetCompID`CLIENT;(`MsgSeqNum;177);(`SendingTime;2009.01.07T18:15:16.000);(`EncryptMethod;0);(`HeartBtInt;30);(`CheckSum;145)) ""
```

### Validating the checksum

Now that we have our core parser built, we can move on to validating the checksum. For that, we will need to do some work _before_ and _after_ our parser evaluates. First, we will need to calculate our checksum, then parse, and then match that first result to the one found on the message itself.

#### Calculating the checksum

To calculate the checksum, we should apply this function to our message:

```q
checkSumCalc:{(sum -7 _x)mod 256};
```

We first get rid of the `CheckSum` field altogether (the last seven characters) and sum all the other characters. After that, we perform the modulo on that result and that's the result of our checksum.

As you can probably guess, this should be done _before_ parsing because we are not only parsing but transforming as well. To achieve this, we can use `map` and `mget` (TODO: explain `mget`):

```q
q.qu) show map[checkSumCalc][mget] fixmsg;

145 "8=FIX.4.2|9=65|35=A|49=SERVER|56=CLIENT|34=177|52=20090107-18:15:16|98=0|108=30|10=145|"
```

We get _**both**_ the checksum and the unparsed string. If we couple this with our parser using `seq`:

```q
q.qu) fixp:seq[map[checkSumCalc][mget];fixformat];
q.qu) show fixp fixmsg;

(145;(`BeginString`FIX.4.2;(`BodyLength;65);`MsgType`A;`SenderCompID`SERVER;`TargetCompID`CLIENT;(`MsgSeqNum;177);(`SendingTime;2009.01.07T18:15:16.000);(`EncryptMethod;0);(`HeartBtInt;30);(`CheckSum;145))) ""
```

We get our list of tuples instead of the unparsed string. With this in mind, we can later extract the `CheckSum` field and compare it against it. Before that, however, it would be nice to turn our list of tuples into an actual dictionary. We can create a function `todict` that looks like this:

```q
q.qu) todict:{(first x;(!). flip last x)};
```

Which then we can run on our parsed result using `map`:

```q
q.qu) fixp:map[todict] seq[map[checkSumCalc][mget];fixformat];
q.qu) show fixp fixmsg;

(145;`BeginString`BodyLength`MsgType`SenderCompID`TargetCompID`MsgSeqNum`SendingTime`EncryptMethod`HeartBtInt`CheckSum!(`FIX.4.2;65;`A;`SERVER;`CLIENT;177;2009.01.07T18:15:16.000;0;30;145)) ""
```

Now the only thing left would be to compare the checksum and, if successful, get rid of it on the final result (return only the dictionary).

First, we can create a function that actually compares the value of our checksums:

```q
q.qu) checkSumMatch:{first[x]~last[x][`CheckSum]};
```

Keep in mind that `x`'s first element is the checksum value and its last is the dictionary.

Now, using `fil`, we can perform the check which if unsuccessful will drop everything we have until this point:

```q
q.qu) fixp:fil[checkSumMatch]
           map[todict]
           seq[map[checkSumCalc][mget];
               fixformat];
```

This doesn't change the output shape so, to get rid of the checksum integer, we can `map` with `last`:

```q
q.qu) fixp:map[last]
           fil[checkSumMatch]
           map[todict]
           seq[map[checkSumCalc][mget];
               fixformat];

q.qu) show fixp fixmsg;

BeginString  | `FIX.4.2
BodyLength   | 65
MsgType      | `A
SenderCompID | `SERVER
TargetCompID | `CLIENT
MsgSeqNum    | 177
SendingTime  | 2009.01.07T18:15:16.000
EncryptMethod| 0
HeartBtInt   | 30
CheckSum     | 145
```



