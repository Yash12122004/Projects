`include "fetch.v"

module fetch_tb;
  reg clk;
  
  wire [3:0] D_icode,D_ifun,D_rA,D_rB,D_stat;
  wire [63:0] D_valC,D_valP,F_PC_out;

  reg [3:0] M_icode,W_icode;
  reg [63:0] M_valA, W_valM,F_PC_in;

//   fetch temp0(.clk(clk),.M_icode(M_icode),.W_icode(W_icode),.M_valA(M_valA));  
  fetch temp01(.clk(clk),.M_icode(M_icode),.W_icode(W_icode),.M_valA(M_valA),.W_valM(W_valM),.M_cnd(M_cnd),.F_PC_in(F_PC_in),.F_stall(F_stall),.D_stall(D_stall),.D_bubble(D_bubble),.D_icode(D_icode),.D_ifun(D_ifun),.D_rA(D_rA),.D_rB(D_rB),.D_valC(D_valC),.D_valP(D_valP),.D_stat(D_stat),.F_PC_out(F_PC_out));

  always @(D_icode) 
  begin
    // $monitor("clk=%d F_PC_in=%d F_PC_out=%d D_icode=%d ifun=%d rA=%d rB=%d,valC=%d\n",clk,F_PC_in,F_PC_out,D_icode,D_ifun,D_rA,D_rB,D_valC);
    if(D_icode==0) 
    $display("**********************************Halting************************************************");
    $finish;
  end

  always @(posedge clk) F_PC_in <= F_PC_out; 

  always #10 clk = ~clk;

  initial begin 
    F_PC_in=64'd0; 
    clk=0;
end 
  
  initial 
		$monitor("clk=%d F_PC_in=%d F_PC_out=%d D_icode=%d ifun=%d rA=%d rB=%d,valC=%d\n",clk,F_PC_in,F_PC_out,D_icode,D_ifun,D_rA,D_rB,D_valC);
endmodule