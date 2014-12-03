Cache
====================

Memory Hierarchy Concept
---------------------
![Memory hierarchy][memory_hierarchy]

* ideal: infinitely large, infinitely fast
  * mimicked imperfectly via hierarchy

![i5][i5_core]

Cache Memory
------------------------
* based on the idea that if you want a piece of data from memory
  1. you'll want it again soon (temporal locality)
  2. you'll want other data from nearby(spatial locality)
* operation
  * Saves data that has been recently used
  * moves data from memory in lines(blocks)
    * higher bandwidth

> e.g. ARM Cortex A9
>> line length = 8 words
>> 4-way set associative
>> critical word first
>> size = 16, 32 or 64 kB

> e.g
>>
>> 1. cache starts empty
>> 2. read at $24
>>   3. cache miss
>>   4. all of B1 copied to cache L0
>>   5. word 1 passed to proc
>> 6. read at $28
>>   7. cache hit in L0
>>   8. word 2 passed to proc

![Cache example][cache_eg_1]

Performance
---------------

* Average access time:
*  t<sub>avg</sub> = hC + (1 - h)M
* h = hit rate, (1 - h) = miss rate, C = cache hit time, M = miss penalty to load missing block

> e.g.
>>  h = 90%, C = 1 cycle, M = 10 cycles
>>
>>  t<sub>avg</sub> = 0.9 x 1 + (1 - 0.9) 10 = 1.9 cycles

* improving t<sub>avg</sub>
  * Increasing h:
    * keep the right blocks(mapping scheme)
    * prefetch: load lines before requested(h/w prediction or s/w instruction)
    * bigger cache
  * Decrease C:
    * small cache size
    * multiple banks
  * Decrease M
    * load-through: give data to proc while line still loading
    * critical word first: memory sends block starting with requested data and wrapping

Store Instructions
--------------------

* if block missing: write miss
  * load-block
* modify cache line

![Store Instruction][store_instruction]

Write policy:

  * Write through:
    * modify mem at same time(poor performance)
  * Write back
    * mark line dirty
    * write line to mem on eviction
    * cache cherncy problem: different caches with different copies of same block

Mapping Schemes
--------------------

![Fully associative mapping scheme][fully_associative]
![Direct associative mapping scheme][direct_associative]
![Set associative mapping scheme][set_associative]

Eviction Policy
--------------------

* if cache full(fully associative) or set full(set associative), which line should be replaced by new block(read/write miss)?
* Least recently used(LRU)
  * better than FIFO or random

Address decomposition
----------------------

![Address decomposition][address_decomposition]

> e.g. line size = 32 bytes, #lines = 64, # address bits = 16
>>
>> addresses 0 - 31   B0    0000 0000 000X XXXX
>>
>>           32- 63   B0    0000 0000 001X XXXX
>>
>>           64- 95   B0    0000 0000 010X XXXX
>>
>> address 0x1234 => 0001 0010 0011 0100
>>
>> Fully associative:
>> **0001 0010 001** tag, **1 0100** offset
>>
>> 4 way set associative:
>> **0001 001** tag, **0 001** index, **1 0100** offset<br>
>> \#sets = 64 / 4 = 16, index bits = log<sub>2</sub>16 = 4
>>
>> Direct mapped:
>> **0001 0** tag, **010 001** index, **1 0100** offset<br>
>> index bits = log<sub>2</sub>64 = 6

Virtual Memory
---------------------

* each process sees its own virtual address space 0 - 2<sup>n</sup> - 1
* virtual memory pages are mapped to physical (main) memory pages
* overflow(pages that exceed pysical memory capacity) are swapped to hard disk
* [handout][cache_vm]: v.m. for 2 processes
* (page size ~ 4kB: need large transfers to achieve good b/w due to high latenecy of HDD)

Page Table
---------------------
* one per process
* list of mappings of virtual pages to physical pages(page frames)
* Memory Management Unit(MMU) translates virtual addresses into physical
* [handout][cache_vm]: v.m. address translation


Translation Lookaside Buffer
--------------------------

* caches recent v.p-to-p.f.(???) translation
* fully associative
* without TLB, every LD, ST or instr. fetch requires 2 mem accesses(1 for translation and 1 for data)
* [handout][cache_vm]: v.m. associative mapped TLB

Page Faults
--------------------

* on address translation if no matching page frame, MMU raises exception
* page fault handler
  * creates or swaps pages from HDD
  * updates page table(s)
  * returns and excepting instruction restarted
* page frames chosen for replacement via LRU

Hard Disk Drives
-----------------------

![Hard disk drive][hard_disk] <br>

* data stored on magnetized platters spinning at 5000 - 10 000 rpm
* data stored using transitions in polarity
* platter surface<br>

![Platter surface][platter_surface]

* access time = seek time(to move heads) + rotational delay(for sector to spin under head)

See next [chapter][7_processor]
See previous [chapter][5_memory]
<!-- IDs for images -->
[memory_hierarchy]: ./img/memory_hierarchy.png
[i5_core]: ./img/i5_core.png
[cache_eg_1]: ./img/cache_eg_1.png
[store_instruction]: ./img/store_instruction.png
[fully_associative]: ./img/fully_associative.png
[direct_associative]: ./img/direct_associative.png
[set_associative]: ./img/set_associative.png
[address_decomposition]: ./img/address_decomposition.png
[hard_disk]: ./img/hard_disk.png
[platter_surface]: ./img/platter_surface.png
[7_processor]: ./7_processor.html
[5_memory]: ./5_memory.html

[cache_vm]: ./docs/cache_vm.pdf
