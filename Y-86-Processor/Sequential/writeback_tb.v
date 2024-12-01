`timescale 1ns/1ps
`include "fetch.v"
`include "decode.v"
`include "write_back.v"

module writeback_tb;

  reg clk,cond=1;
  reg [63:0] PC;
  reg [0:79] instruct;
  reg [7:0] inst_arr[0:1034];

  wire [3:0] icode,ifun,ra,rb; 
  wire [63:0] valA, valB, valC,valP;
  wire [63:0] valE,valM;    
  wire imem_error, instr_valid;
  wire [63:0] regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14;        //registers
  
  fetch temp0(.clk(clk),.PC(PC),.instruct(instruct),.icode(icode),.ifun(ifun),.ra(ra),.rb(rb),.valC(valC),.valP(valP),.mem_err(mem_err),.instruct_err(instruct_err));
  decode temp1(.clk(clk),.icode(icode),.ra(ra),.rb(rb),.valA(valA),.valB(valB));
  write_back temp2(.clk(clk),.icode(icode),.ra(ra),.rb(rb),.cond(cond),.valE(valE),.valM(valM),.regis0(regis0),.regis1(regis1),.regis2(regis2),.regis3(regis3),.regis4(regis4),.regis5(regis5),.regis6(regis6),.regis7(regis7),.regis8(regis8),.regis9(regis9),.regis10(regis10),.regis11(regis11),.regis12(regis12),.regis13(regis13),.regis14(regis14));


always @(PC) 
    begin
        instruct={
        inst_arr[PC],
        inst_arr[PC+1],
        inst_arr[PC+2],
        inst_arr[PC+3],
        inst_arr[PC+4],
        inst_arr[PC+5],
        inst_arr[PC+6],
        inst_arr[PC+7],
        inst_arr[PC+8],
        inst_arr[PC+9]
    };
    end


initial 
begin 
    clk=1;
    PC=64'd64;

    //OPq
    inst_arr[62]=8'b01100001; //6 fn
    inst_arr[63]=8'b00100011; //rA rB
    //cmovq
    inst_arr[64]=8'b00100000; //2 fn 
    inst_arr[65]=8'b00110100; //rA rB
    //cmovq
    inst_arr[66]=8'b00100101; // 2 ge
    inst_arr[67]=8'b01010011; // rA rB

    //halt
    inst_arr[68]=8'b00000000; // 0 0
    //jxx
    inst_arr[60]=8'b01110000; //7 fn
    inst_arr[61]=8'b00110100; //Destination

    #10
    clk=~clk;
    PC=64'd62;
    #10
    clk=~clk;
    PC=64'd68;
    #10
    clk=~clk;
    PC=64'd60;
end


  initial 
		$monitor("clk=%b icode=%b ifun=%b ra=%b rb=%b valA=%d valB=%d valE=%d valM=%d regis0=%d regis1=%d regis2=%d regis3=%d regis4=%d regis5=%d regis6=%d regis7=%d regis8=%d regis9=%d regis10=%d regis11=%d regis12=%d regis13=%d regis14=%d",clk,icode,ifun,ra,rb,valA,valB,valE,valM,regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14);

endmodule