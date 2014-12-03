Processor Design
=====================

Execution Stages
-------------------

| Store/type    | Data Processing | Load             | Store            | Branch          |
|---------------|-----------------|------------------|------------------|-----------------|
| 1 - fetch     | ADD r2, r0, r1  | LDR r1, [r0, #4] | STR r1, [r0, #4] | BEQ [PC, #16]   |
| 2 - reg read  | r0, r1          | r0               | r0, r1           | PC              |
| 3 - use ALU   | [r0] + [r1]     | [r0] + 4         | [r0] + 4         | [PC] + 16       |
| 4 - use mem   | -               | read             | write            | -               |
| 5 - reg write | r2<-            | r1<-             | -                | if z == 1 PC <- |

Datapath
----------------------

### Stage 1

![Data path stage 1][stage_1_datapath]

### Stage 2

![Data path stage 2][stage_2_datapath]

### Stage 3

![Data path stage 3][stage_3_datapath]

### Stage 4

![Data path stage 4][stage_4_datapath]

### Stage 5

![Data path stage 5][stage_5_datapath]

### Combined 6

See [handout][datapath_handout]

Control
---------------------

* registers are clocked, output always on
* data flow controlled by asserting register input and mux select signals (if not listed, control sig deasserted if listed, asserted)

####  Data processing instructions

> e.g. ADD r2, r0, r1

| Stage        | Action                 | Control Signals Asserted             |
|--------------|------------------------|--------------------------------------|
| 1 - fetch    | MAR <- [PC]            | MAR in, MAR<sub>sel</sub> = PC                  |
|              | read memory            | read                                 |
|              | IR <- mem data in      | IR<sub>in</sub>, MDR<sub>sel</sub> = mem                   |
|              | PC <- [PC] + 4         | PC<sub>sel</sub> = inc, PC<sub>in</sub>                    |
| 2 - reg read | RA <- [r0], RA <- [r1] | rd A = 0, RA<sub>in</sub>, rd B = 1, RB<sub>in</sub>       |
| 3 - ALU      | RZ <- [RA] + [RB]      | A<sub>sel</sub> = A, B<sub>sel</sub> = B, ALU<sub>op</sub> = add, Z<sub>in</sub> |
| 4 - mem      | RY <- [RZ]             | Y<sub>sel</sub> = Z, RY<sub>in</sub>                       |
| 5 - reg wr   | r2 <- [RY]             |  wrC = 2, wrEn                       |

> e.g. LDR r1, [r0, #4]

| Stage        | Action                 | Control Signals Asserted             |
|--------------|------------------------|--------------------------------------|
| 1 - fetch    | MAR <- [PC]            | MAR in, MAR<sub>sel</sub> = PC       |
|              | read memory            | read                                 |
|              | IR <- mem data in      | IR<sub>in</sub>, MDR<sub>sel</sub> = mem|
|              | PC <- [PC] + 4         | PC<sub>sel</sub> = inc, PC<sub>in</sub> |
| 2 - reg read | RA <- [r0]             | rd A = 0, RA<sub>in</sub>            |
| 3 - ALU      | RZ <- [RA] + 4         | A<sub>sel</sub> = A, B<sub>sel</sub> = offset, ALU<sub>op</sub> = add, Z<sub>in</sub> |
| 4 - mem      | MAR <- [RZ]            | MAR<sub>sel</sub> = Z, MAR<sub>in</sub>|
|              | read memory            | read                                  |
|              | RY <- mem data in      | Y<sub>sel</sub> = mem, RY<sub>in</sub>|
| 5 - reg wr   | r2 <- [RY]             | wrC = 1, wrEn                                      |

> e.g. STR r1, [r0, #4]

| Stage        | Action                 | Control Signals Asserted             |
|--------------|------------------------|--------------------------------------|
| 1 - fetch    | MAR <- [PC]            | MAR in, MAR<sub>sel</sub> = PC       |
|              | read memory            | read                                 |
|              | IR <- mem data in      | IR<sub>in</sub>, MDR<sub>sel</sub> = mem|
|              | PC <- [PC] + 4         | PC<sub>sel</sub> = inc, PC<sub>in</sub> |
| 2 - reg read | RA <- [r0]             | rd A = 0, RA<sub>in</sub>            |
|              | RB <- [r1]             | rd B = 1, RB<sub>in</sub>            |
| 3 - ALU      | RZ <- [RA] + 4         | A<sub>sel</sub> = A, B<sub>sel</sub> = offset, ALU<sub>op</sub> = add, Z<sub>in</sub> |
| 4 - mem      | MAR <- [RZ]            | MAR<sub>sel</sub> = Z, MAR<sub>in</sub>|
|              | MDR <- [RB]            | MDR<sub>in</sub>                     |
|              | write memory           | write                                |
|              | RY <- mem data in      | Y<sub>sel</sub> = mem, RY<sub>in</sub>|
| 5 - reg wr   | -                      | -                                     |

> e.g. BEQ [PC, #16]

| Stage        | Action                 | Control Signals Asserted             |
|--------------|------------------------|--------------------------------------|
| 1 - fetch    | MAR <- [PC]            | MAR in, MAR<sub>sel</sub> = PC       |
|              | read memory            | read                                 |
|              | IR <- mem data in      | IR<sub>in</sub>, MDR<sub>sel</sub> = mem|
|              | PC <- [PC] + 4         | PC<sub>sel</sub> = inc, PC<sub>in</sub> |
| 2 - reg read | -                      | -                                    |
| 3 - ALU      | RZ <- [PC] + 16        | A<sub>sel</sub> = A, B<sub>sel</sub> = offset, ALU<sub>op</sub> = add, Z<sub>in</sub> |
| 4 - mem      | RY <- [RZ]             | Y<sub>sel</sub> = Z, RY<sub>in</sub>|
| 5 - reg wr   | if (z == 1), PC <- [RY]| PC<sub>sel</sub> = Y, PC<sub>in</sub> = (Z == 1)|

* could finish in stage 3 by routing ALU output to PC max

### Control Logic

![Control Logic][control_logic]

* WMFC = wait for memory function complete
* MFC = memory function complete(from memory)
  * asserting WMFC with read or write control signal stalls step counter until memory asserts MFC(i.e. waits for read/write to finish)
* Combinational logic
  * inputs: control step, instruction, condition flags
  * outputs: all control signals

> e.g. IR<sub>in</sub> = T1
>>
>>  PC<sub>in</sub> = T1 + T5 (Z flag == 1) BEQ
>>
>> PC<sub>sel</sub> = T1
>>
>> PC <sub>sel</sub> = T5
>>
>> read = T1 + T4 LDR
>> write = T4 STR
>>
>> WMFC = read + write

See [next chapter][8_pipelining]
See [previous chapter][6_cache]
<!-- IDs of images -->
[stage_1_datapath]: ./img/stage_1_datapath.png
[stage_2_datapath]: ./img/stage_2_datapath.png
[stage_3_datapath]: ./img/stage_3_datapath.png
[stage_4_datapath]: ./img/stage_4_datapath.png
[stage_5_datapath]: ./img/stage_5_datapath.png
[control_logic]: ./img/control_logic.png

[datapath_handout]: ./docs/processor.pdf
[8_pipelining]: ./8_pipelining.html
[6_cache]: ./6_cache.html
