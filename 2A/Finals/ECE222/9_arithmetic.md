Arithmetic
===================

Floating Point Respresentation ( IEEE754 )
--------------------------

> e.g. F = &plusmn; 1.xxx * 2<sup>E</sup>
>>
>> ![floating point][floating_point]

| "precision" | S | E' | f | total | magnitude | precision |
|:-----------:|:-:|:-:|:--:|:-----:|:---------:|:---------:|
| 4 byte single| 1 | 8 | 23 | 32 | [2 x 10 <sup>-38</sup>, 2 x 10 <sup>38</sup>] | 7 decimal places |
| 8 byte double | 1 | 11 | 52 | 64 | [2 x 10 <sup>-308</sup> , 2 x 10 <sup>308</sup> ] | 15 decimal places |

* S : 0 = positive, 1 = negative
* E' : biased exponent, E' = E + bias, bias = 127 for s.p, 1023 for d.p
  * s.p.
    * E' <sub>min</sub> = 0000 0001 ; E <sub>min</sub> = 1 - 127 = -126
    * E' <sub>max</sub> = 1111 1110 ; E <sub>max</sub> = 254 - 127 = +127
    * E' always positive, facilitates comparing f.p numbers with integer ALU

* f : doesn't encode leading one
  * F = (-1) <sup>s</sup> * 1.f * 2 <sup>E'-bias</sup>

> e.g. represent 0.75 <sub>10</sub> in s.p. format  
>> 0.75 x 2 = 1.5  
>> 0.75 <sub>10</sub> = 0.11 <sub>2</sub> = 1.1 x 2 <sup>-1</sup> (normalized)  
>>> S = 0, f = 1, E' = -1 + 127 = 126 = 0111 1110
>> ![floating point example][floating_point_example]

E' reserved values: 0000 0000, 1111 1111

| E' | f | value |
|:--:|:-:|:--:|
| 0000 0000 | zero | 0 |
| 0000 0000 | non-zero| denormalized, very small results|
| 1111 1111 | zero | infinity |
| 1111 1111 | non-zero | NaN

denormalized representation (s.p):
F = (-1) <sub>s</sub> x 0.f x 2 <sup>-126</sup>

Addition/Subtraction
------------------------

> e.g. 1 x 2 <sup>-1</sup> - 1.11 x 2 <sup>-2</sup> using 4 sig dis
>> ![subtraction][addition_subtraction]

Multiplication/Division
------------------------

1. if multiplying, add exponents and subtract bias  
E' <sub>3</sub> = E' <sub>1</sub> + E' <sub>2</sub> - bias  
= (E <sup>true</sup> <sub>1</sub> + bias) + (E <sup>true</sup> <sub>2</sub> + bias) - bias  
= E <sup>true</sup> <sub>1</sub> + E <sup>true</sup> <sub>2</sub> + bias  
= E <sup>true</sup> <sub>3</sub> + bias

if dividing, subtract exponents and add bias

2. multiply/divide significands
3. normalize
4. round and repeat 3 if necessary

Rounding
----------------------

IEEE543: intermediate results keep 3 extra bits  
x = 1.b<sub>-1</sub>b<sub>-2</sub>...b<sub>-23</sub>b<sub>-24</sub>b<sub>-25</sub>b<sub>-26</sub>

rounding schemes: truncation, Von Neumann, round-to-nearest-even
error &equiv; round(x) - x

### Truncation

| b<sub>-24</sub>b<sub>-25</sub>b<sub>-26</sub> | x |
|:-:|:-:|
| 000 - 111 | 1.b<sub>-1</sub>b<sub>-2</sub>...b<sub>-23</sub>
error accumulates with successive operations

### Von Neumann

| b<sub>-24</sub>b<sub>-25</sub>b<sub>-26</sub> | x |
|:-:|:-:|
| 000 | 1.b<sub>-1</sub>b<sub>-2</sub>...b<sub>-23</sub> -> |
| 001 - 111 | 1.b<sub>-1</sub>b<sub>-2</sub>...b<sub>-22</sub>1
error tends to cancel out with successive operations

### Round-to-nearest-even
| b<sub>-24</sub>b<sub>-25</sub>b<sub>-26</sub> | x |
|:-:|:-:|
| 000 - 011 | 1.b<sub>-1</sub>b<sub>-2</sub>...b<sub>-23</sub>|
| 100 | 1.b<sub>-1</sub>b<sub>-2</sub>...b<sub>-23</sub>(b<sub>-23</sub> == 0)
| 100 | 1.b<sub>-1</sub>b<sub>-2</sub>...b<sub>-23</sub> + 2<sup>-23</sup>(b<sub>-23</sub> == 1)
| 101 - 111 | 1.b<sub>-1</sub>b<sub>-2</sub>...b<sub>-23</sub> + 2<sup>-23</sup>
error w.r.t. b<sub>-23</sub> &isin; [-.100, +.100]  
error tends to cancel out and has smaller range

Unsigned Multiplication
------------------------

> e.g.
>> ![Unsigned multiplication][unsigned_multiplication]

### Sequential Multiplier
![sequential multiplier][sequential_multiplier]

1. Initialize: C | A <- 0, Q <- multiplier, M <- Multiplicand
2. Repeat n times
  * C | A <- (q <sub>0</sub> == 1) ? A + M : A + 0
  * C | A | Q >> 1
3. product in A | Q
Each iteration P grows 1 bit, Q shrinks 1 bit

> e.g. iteration
>> ![sequential multiplier example][sequential_multiplier_example]

Signed Multiplication
------------------------

> e.g.
>> ![signed multiplication][signed_multiplication]

### Booth's Algorithm
Recode Q as B
| Q"i" | Q"i-1" | B"i" |
|:-:|:-:|:-:|
| 0 | 0 | 0 |
| 0 | 1 | +1|
| 1 | 0 | -1|
| 1 | 1 | 0 |
Q"-1" &equiv; 0

> e.g. 
>> ![booths algorithm][booths_algorithm_1]

> e.g. 
>> ![booths algorithm][booths_algorithm_2]

### Bit-Pair Recoding
* precode B as R
* pairs of Booth's bits B"i+1" B"i" replaced by R"i" = 2B"i+1" + B"i"

> e.g.
>> ![bit pair recoding][bit_pair_recoding]

> e.g.
>> ![bit pair recoding][bit_pair_recoding_1]

See [previous chapter][8_pipelining]
<!-- IDs down here -->
[floating_point]: ./img/floating_point.png
[floating_point_example]: ./img/floating_point_example.png
[addition_subtraction]: ./img/addition_subtraction.png
[unsigned_multiplication]: ./img/unsigned_multiplication.png
[sequential_multiplier]: ./img/sequential_multiplier.png
[sequential_multiplier_example]: ./img/sequential_multiplier_example.png
[booths_algorithm_1]: ./img/booths_algorithm_1.png
[booths_algorithm_2]: ./img/booths_algorithm_2.png
[bit_pair_recoding]: ./img/bit_pair_recoding.png
[bit_pair_recoding_1]: ./img/bit_pair_recoding_1.png

[8_pipelining]: ./8_pipelining.html
