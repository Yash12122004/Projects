`timescale 1ns/1ps
`include "fetch.v"
`include "decode.v"
`include "execute.v"

module execute_tb;
    reg clk;
    reg [63:0] PC,valM;
    reg [79:0] instruct;
    reg [7:0] inst_arr[1034];
    reg [2:0] CC_in;

    wire mem_err,instruct_err,Z_F,S_F,O_F,cond;
    wire [3:0] icode,ifun,ra,rb;
    wire [2:0] CC_out;
    wire signed[63:0] valC,valP;
    wire signed[63:0] valA,valB,valE;

    
  fetch temp0(.clk(clk),.PC(PC),.instruct(instruct),.icode(icode),.ifun(ifun),.ra(ra),.rb(rb),.valC(valC),.valP(valP),.mem_err(mem_err),.instruct_err(instruct_err));
  decode temp1(.clk(clk),.icode(icode),.ra(ra),.rb(rb),.valA(valA),.valB(valB));
//   memory temp1(.clk(clk),.icode(icode),.valP(valP),.valA(valA),.valB(valB),.valM(valM),.valE(valE),.mem_err(mem_err),.instruct_err(instruct_err));
execute temp2(.clk(clk),.icode(icode),.ifun(ifun),.valA(valA),.valB(valB),.valC(valC),.valE(valE),.cond(cond),.CC_in(CC_in),.CC_out(CC_out),.Z_F(Z_F),.S_F(S_F),.O_F(O_F));

always @(CC_out) begin
    CC_in=CC_out;
end

initial 
    begin
        for(integer i=0;i<1034;i=i+1)
        begin
            inst_arr[i]=8'd0; 
        end
        CC_in=3'b000;
    end

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
    //OPq
    inst_arr[62]=8'b01100001; //6 fn
    inst_arr[63]=8'b00100011; //rA rB
    //cmovq
    inst_arr[64]=8'b00100001; //2 fn
    inst_arr[65]=8'b00110100; //rA rB
    //irmovq
    inst_arr[66]=8'b00110101; // 3 ge 
    inst_arr[67]=8'b01010011; // rA rB 
    inst_arr[68]=8'b00000000; // valC  
    inst_arr[69]=8'b00000000; // valC 
    inst_arr[70]=8'b00000000; // valC
    inst_arr[71]=8'b00000000; // valC
    inst_arr[72]=8'b00000000; // valC
    inst_arr[73]=8'b00000000; // valC
    inst_arr[74]=8'b00000000; // valC
    inst_arr[75]=8'b00000110; // valC
    //pushq
    inst_arr[171]=8'b10100000; // A 0 
    //jxx
    inst_arr[90]=8'b01110001; //7 fn
    inst_arr[91]=8'b00000000; //Destination
    inst_arr[98]=8'b00000011; //Destination
    clk=1;
    PC=64'd62;
    #10
    clk=~clk;
    PC=64'd64;
    #10
    clk=~clk;
    PC=64'd66;
    #10
    clk=~clk;
    PC=64'd171;
    #10
    clk=~clk;
    PC=64'd90;
end

  initial 
		$monitor("clk=%b PC=%d icode=%d ifun=%d ra=%d rb=%d valA=%d valB=%d valC=%d valP=%d valE=%d CC_in=%b CC_out=%b Z_F=%d S_F=%d O_F=%d cond=%d",clk,PC,icode,ifun,ra,rb,valA,valB,valC,valP,valE,CC_in,CC_out,Z_F,S_F,O_F,cond);
endmodule