`timescale 1ns/1ps
`include "fetch.v"
`include "decode.v"

module decode_tb;

  reg clk;
  reg [63:0] PC;
  reg [0:79] instruct;
  reg [7:0] inst_arr[0:1034];

  wire [3:0] icode,ifun,ra,rb; 
  wire [63:0] valA, valB, valC, valM,valP;
  wire imem_error, instr_valid;
  
  fetch temp0(.clk(clk),.PC(PC),.instruct(instruct),.icode(icode),.ifun(ifun),.ra(ra),.rb(rb),.valC(valC),.valP(valP),.mem_err(mem_err),.instruct_err(instruct_err));
  decode temp1(.clk(clk),.icode(icode),.ra(ra),.rb(rb),.valA(valA),.valB(valB));
  

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
		$monitor("clk=%b icode=%b ifun=%b ra=%b rb=%b valA=%d valB=%d ",clk,icode,ifun,ra,rb,valA,valB);

endmodule