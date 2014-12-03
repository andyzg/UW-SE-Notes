Pipelining
================

Datapath
---------------

* [Handout][processor]: pipelined processor datapath, second page

* stages operate concurrently
  * instruction execution overlapped
  ![Instruction execution][instruction_execution]

* output of stage 1 is buffered in B1-2 for use by stage 2 in next cycle(B2-3, B3-4, B4-5 similar)
  * includes info needed for control signals
* I-cache allows instruction fetch every cycle
* D-cache allows load/sore every cycle
* 1 instruction finishes per cycle(in steady state)

Hazards
------------------

* conditions that stall the pipeline

> e.g. miss in I-cache (2 extra cycles)
![Hazard example][hazard_example]

* types: data, control, structural, 2 cycles stall

Data Hazards
-------------------

> e.g.
>>
>> ADD r2, r0, r1
>>
>> ADD r3, r2, #1

![data hazard example][data_hazard_example]

* value [r0] + [r1] in pipeline after compute in clock cycle 3
* forward it

> e.g.
>>
>> ADD r2, r0, r1
>>
>> ADD r3, r2, #1

![data hazard example 1][data_hazard_example_1]

### Data Forwarding

![data forwarding][data_forwarding]

A<sub>sel</sub> = { PC + 4, A, Z }
B<sub>sel</sub> = { B, offset, Z }

* Also need forwarding paths from stage 5 and to stage 2

> e.g.
>> ![data forwarding example][data_forwarding_example]

Load Hazard
-----------------

* a dependent instruction following a load must delay 1 cycle

> e.g.
>>
>> ![load hazard example 1][load_hazard_example_1]

* load delay slot is instruction following load
* can avoid hazard by filling with independent instruction

> e.g.
>>
>> ![load hazard example 2][load_hazard_example_2]

Control Hazards
--------------------

* hazard on PC(caused by branches)

> e.g.
>>
>> ![control hazard example][control_hazard]

* ~20% dynamic instruction mix are branches
* reduce penalty to 1 cycle with dedicated branch adder in decode stage

Branch Delay Slot
----------------------

* "feature" instruction after branch always executed (i.e dont squash it)

> e.g.
>>
>> ![branch delay slot][branch_delay_slot]

Speculative Execution
------------------------

* predict branch direction(taken, not taken) and start fetching
* resolve branch(execute it)
  * if prediction correct, then
    * penalty avoided
  * else
    * squash speculative instructions
* branch history table

![Speculative execution][speculative_execution]

* BNT updated on branch resolution with BTA and branch behaviour(BT = branch taken, BNT not taken)

### 1 bit predictor

* states:
  * 0 = Likely not taken(LNT)
  * 1 = Likely taken(LT)
* problem: always mispredicts first and last loop iterations

![1 bit predictor][1_bit_predictor]

### 2 bit

* states:
  * 00 = Strongly not taken(SNT)
  * 01 = Likely not taken(LNT)
  * 10 = Likely taken(LT)
  * 11 = Strongly taken(ST)

![2 bit predictor][2_bit_predictor]

> e.g.
>>
>> on BNT miss, guess LNT

```
  i = 0;
  do {
    ...
    i++;
  } while (i < 3); // B1
```

>>
>> ![B1 prediction][branch_taken_example]

Structural Hazards
---------------------

* insufficient resources

> e.g. cache too small => less hit rate

> e.g. unified L1 => cannot fetch and ld/st in same cycle

Performance
------------------
* execution time : T = n x CPI / r where
  * n = dynamic instruction count
  * CPI average cycles instruction
  * r = clock rate(frequency)
* ideal CPI = 1
  * increased by hazards

> e.g.
>>
>> ![Performance example][performance]

`
CPI = 1.0 + B + L
= 1.0 + 0.15 x 0.2 x 2 + 0.2 x 0.4 x 1
= 1.14
`

* throughput
  * P = 1 / T
* speedup of processor r2 over processor 1
  * S = P <sub>2</sub> / P <sub>1</sub> = T <sub>1</sub> / T <sub>2</sub> = (n <sub>1</sub> x CPI <sub>1</sub> / r) / (n <sub>2</sub> x CPI <sub>2</sub> / r <sub>2</sub>)

if n <sub>1</sub> = n <sub>2</sub> and r <sub>1</sub> = r <sub>2</sub> , S = CPI <sub>1</sub> / CPI <sub>2</sub>

See [previous chapter][7_processor]
See [next chapter][9_arithmetic]
<!-- IDs -->
[instruction_execution]: ./img/instruction_execution.png
[hazard_example]: ./img/hazard_example.png
[data_hazard_example]: ./img/data_hazard_example.png
[data_hazard_example_1]: ./img/data_hazard_example_1.png
[data_forwarding]: ./img/data_forwarding.png
[data_forwarding_example]: ./img/data_forwarding_example.png
[load_hazard_example_1]: ./img/load_hazard_example_1.png
[load_hazard_example_2]: ./img/load_hazard_example_2.png
[control_hazard]: ./img/control_hazard.png
[branch_delay_slot]: ./img/branch_delay_slot.png
[speculative_execution]: ./img/speculative_execution.png
[1_bit_predictor]: ./img/1_bit_predictor.png
[2_bit_predictor]: ./img/2_bit_predictor.png
[branch_taken_example]: ./img/branch_taken_example.png
[performance]: ./img/performance.png

[7_processor]: ./7_processor.html
[9_arithmetic]: ./9_arithmetic.html
[processor]: ./docs/processor.pdf
