`timescale 1ns/1ps
`include "pc_update.v"

module pcupdate_tb;
    reg clk,cond=0;
    reg [63:0] PC;
    reg [79:0] instruct;
    reg [7:0] inst_arr[1034];

    wire mem_err,instruct_err;
    wire [3:0] icode,ifun,ra,rb;
    wire [63:0] next_pc,valC,valP; 

  fetch temp0(.clk(clk),.PC(PC),.instruct(instruct),.icode(icode),.ifun(ifun),.ra(ra),.rb(rb),.valC(valC),.valP(valP),.mem_err(mem_err),.instruct_err(instruct_err));
  pc_update temp1(.clk(clk),.cond(cond),.icode(icode),.valC(valC),.valP(valP),.next_pc(next_pc));


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
    PC=64'd60;

    //OPq
    inst_arr[62]=8'b01100001; //6 fn
    inst_arr[63]=8'b00100011; //rA rB 
    //cmovq
    inst_arr[64]=8'b00100000; //2 fn 
    inst_arr[65]=8'b00110100; //rA rB
    //cmovq
    inst_arr[66]=8'b10000101; // 8 
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
    PC=64'd64;
end

  initial 
		$monitor("clk=%b PC=%d icode=%b ifun=%b ra=%b rb=%b valC=%d valP=%d next_pc=%d",clk,PC,icode,ifun,ra,rb,valC,valP,next_pc);
endmodule