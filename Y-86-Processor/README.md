## Implementation of Y86 Processor Architecture - Project 

This project involved the development of a processor architecture design based on the Y86 ISA using Verilog. The goal was to create a design that met specified requirements and could be thoroughly tested using simulations.

### 1. Overall Goal

The overall goal of the project was to develop a processor architecture design based on the Y86 ISA using Verilog. The project submission included:

- A detailed report describing the design details of each stage of the processor architecture, the supported features, and challenges encountered.
- Verilog code for the processor design and testbench.

### 2. Specifications

The processor design needed to meet the following specifications:

- Minimum Design: Implement a sequential design as discussed in Section 4.3 of the textbook.
- Full-Fledged Design: Implement a 5-stage pipeline as discussed in Sections 4.4 and 4.5 of the textbook, including support for eliminating pipeline hazards.

Important points to note:

- Both designs were required to execute all instructions from the Y86 ISA, except for call and ret instructions, to receive the mentioned marks.
- Additional marks were awarded for successfully executing call and ret instructions.

### 3. Design Approach

The design approach followed a modular approach, where each stage was coded as separate modules and tested independently. This ensured smoother integration without significant issues.

### 4. Suggestions for Design Verification

To verify the design, the following approaches were recommended:

- Conduct individual tests for each stage/module to ensure intended functionality.
- Write an assembly program, such as a sorting algorithm, using the Y86 ISA and corresponding encoded instructions to test the integrated design.
- Explore the possibility of creating an automated testbench to efficiently verify the design by automatically checking the processor and memory state after executing each instruction in the program.


### Instructions Supported

<ul>
  <li>halt
  <li>nop
  <li>cmovXX
  <li>irmovq
  <li>rmmovq
  <li>mrmovq
  <li> OPq
  <li> jmp
  <li>call
  <li>ret
  <li>pushq
  <li>popq
<ul>

  ---

This project provided a valuable opportunity to gain hands-on experience with processor architecture design, Verilog coding, and testing methodologies.
