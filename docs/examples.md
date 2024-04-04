# Examples

## IPv4 / Email

See [`motivation.md`]().

## Spanish ID (DNI) Validation

A Spanish ID can be validated performing a simple checksum:
 
 1. Take the numeric part of the ID and perform the modulo operation over 23.
 2. The resulting number is mapped to a specific uppercase letter.
 3. That letter should match the trailing uppercase character of the ID.

First off we need the number to letter dictionary:

```q
v:til[23]!"TRWAGMYFPDXBNJZSQVHLCKE";
```

Then, we must build our pattern. If we were working with regular expressions, it would look like this:

```
\d{8}[A-Z]
```

So, 8 digits followed by an uppercase character.

With Quercus, we can specify "8 digits" with:

```q
.qu.times[8;.qu.digit]
```

But we would want this part to be treated as a numerical later on. To achieve this, we can use `map`:

```q
.qu.map[("J"$)][.qu.times[8;.qu.digit]]
```

Then, we need to make sure we have an uppercase character after our numerical part. To specify this, we can use `seq` and `upr`:

```q
idp:.qu.seq[.qu.map[("J"$)][.qu.times[8;.qu.digit]];.qu.upr]
```

But we are not checking if the ID is valid or not, we are only checking the general pattern or structure of our string. To apply a function over our string we could use `map` as before, but since in this case we want to validate, we can use `fil` to check a condition:

```q
dniv:.qu.fil[{x[1]~v x[0]mod 23}] idp
```

In this particular case, `x[0]` contains the numerical value and `x[1]` contains the checksum letter, so we can do the modulo, transform the resulting number using `v` and finally check for equality.

To ilustrate this, we can run the following code snippet:

```q
ids:("78187169A";
     "97404065P";
     "50625576T";
     "00148482V";
     "40548751G";
     "40548251G");

show .qu.vparse[dniv] each ids;
```

They should all ve valid except the last one.

## ISIN Validation

Check [ISIN]() for more information on what it is, what is it used for and the format it uses.

For the purposes of this demonstration, we are going to assume that we have all the functions needed to perform the check already:

```q
toBase10:{raze string .Q.nA?x};
luhn:{
  r:reverse x;
  oddN:("J"$)each r where odd:count[r]#10b;
  evenN:("J"$)each raze string 2*("J"$) each r where not odd;
  0=(sum oddN, evenN)mod 10};
```

But we would also want to check if the given ISIN the expected format. It should follow the following regular expression:

```
[A-Z]{2}[A-Z0-9]{9}\d
```

So, two uppercase characters representing a country code, 9 alphanumeric characters and finally a single digit.

We can use `seq` and `times` to build up our parser:

```q
.qu.seq[.qu.times[2;.qu.upr];.qu.times[9;.qu.alphanum];.qu.digit]
```

But we will quickly realize that it doesn't produce an easy to read output:

```
("US";("037833100";"5")) ""
```

This nesting can be reduced by using `seqf`, which applies a function after sequencing:

```q
.qu.seqf[(,).][.qu.times[2;.qu.upr];.qu.seqf[(,).][.qu.times[9;.qu.alphanum];.qu.digit]]"US0378331005"
```

But this looks a bit clumsy, since we are nesting our `seqf` combinators. To get rid of that, we can use this fancy syntax:

```q
isinp:(.qu.seqf[(,).]/)(.qu.times[2;.qu.upr];.qu.times[9;.qu.alphanum];.qu.digit);
```

After that, we can use `fil` as in [Spanish ID Validation] to apply our checks and then perform some tests:

```q
isins:("US0378331005";
       "US0373831005";
       "U50378331005";
       "US03378331005";
       "AU0000XVGZA3";
       "AU0000VXGZA3";
       "FR0000988040");

show .qu.vparse[.qu.fil[(luhn toBase10::)][isinp]] each isin;

```
