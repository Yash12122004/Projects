`timescale 1ns/1ps
`include "fetch.v"
`include "memory.v"

module memory_tb;
    reg clk;
    reg [63:0] PC;
    reg [79:0] instruct;
    reg [7:0] inst_arr[1034];
  
    wire mem_err,instruct_err;
    wire [3:0] icode,ifun,ra,rb;
    wire [63:0] valC,valP,valB;

  fetch temp0(.clk(clk),.PC(PC),.instruct(instruct),.icode(icode),.ifun(ifun),.ra(ra),.rb(rb),.valC(valC),.valP(valP),.mem_err(mem_err),.instruct_err(instruct_err));
  memory temp1(.clk(clk),.icode(icode),.valP(valP),.valA(valA),.valB(valB),.valM(valM),.valE(valE),.mem_err(mem_err),.instruct_err(instruct_err));



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

    //Call
    inst_arr[68]=8'b10000000; // 8 0
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
		$monitor("clk=%b PC=%d icode=%b ifun=%b ra=%b rb=%b valC=%d valP=%d ",clk,PC,icode,ifun,ra,rb,valC,valP);
endmodule