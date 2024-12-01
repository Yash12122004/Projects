`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "hazard_control.v"
module processor;
  reg clk;
  reg [0:3] stat = 4'b1000;           // AOK, HLT, ADR, INS 

  reg [63:0] F_PC_in;
  wire [63:0] F_PC_out;
  wire [0:3] D_stat,E_stat,M_stat,W_stat,m_stat;
  wire [3:0] D_icode,E_icode,M_icode,W_icode;
  wire [3:0] D_ifun,E_ifun;           
  wire [3:0] D_rA,D_rB;
  wire [63:0] D_valC,D_valP,M_valP;
  wire [3:0] d_srcA,d_srcB;
  wire [63:0] E_valC,E_valA,E_valB,e_valE,M_valE,M_valA,m_valM,W_valE,W_valM;
  wire [3:0] E_dstE,E_dstM,E_srcA,E_srcB,e_dstE,M_dstE,M_dstM,W_dstE,W_dstM;
  wire M_cnd,e_cnd;

  wire F_stall, D_stall, D_bubble, E_bubble, M_bubble, W_stall, set_cc;
  wire [63:0] regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14;


  always@(W_stat)begin
    stat = W_stat;
  end  

  always@(stat) begin
    if(stat==4'b0100)
    begin
      $display("********************* Halting **********************");
      $finish;
    end 
    else if(stat==4'b0010) 
    begin
      $display("********************* Memory error **********************");
      $finish;
    end
    else if(stat==4'b0001)    
    begin
      $display("********************* Instruction Error****************************");
      $finish;
    end
  end

  always #10 clk = ~clk;

  always @(posedge clk) F_PC_in <= F_PC_out;  


  fetch temp01(
    .clk(clk),.M_icode(M_icode),.W_icode(W_icode),.M_valA(M_valA),.W_valM(W_valM),.M_cnd(M_cnd),.F_PC_in(F_PC_in),.F_stall(F_stall),.D_stall(D_stall),.D_bubble(D_bubble),.D_icode(D_icode),.D_ifun(D_ifun),.D_rA(D_rA),.D_rB(D_rB),.D_valC(D_valC),.D_valP(D_valP),.D_stat(D_stat),.F_PC_out(F_PC_out),.M_valP(M_valP)
  );

  decode_writeback temp02(
    .clk(clk),.D_stat(D_stat),.D_icode(D_icode),.D_ifun(D_ifun),.D_rA(D_rA),.D_rB(D_rB),.D_valC(D_valC),.D_valP(D_valP),
    .E_bubble(E_bubble),.E_stat(E_stat),.E_icode(E_icode),.E_ifun(E_ifun),.E_valC(E_valC),.E_valA(E_valA),.E_valB(E_valB),.E_dstE(E_dstE),.E_dstM(E_dstM),.E_srcA(E_srcA),.E_srcB(E_srcB),
    .d_srcA(d_srcA),.d_srcB(d_srcB),.e_dstE(e_dstE),.M_dstE(M_dstE),.M_dstM(M_dstM),.W_dstE(W_dstE),.W_dstM(W_dstM),.e_valE(e_valE),.M_valE(M_valE),.m_valM(m_valM),.W_valE(W_valE),.W_valM(W_valM),.W_icode(W_icode),
    .regis0(regis0),.regis1(regis1),.regis2(regis2),.regis3(regis3),.regis4(regis4),.regis5(regis5),.regis6(regis6),.regis7(regis7),.regis8(regis8),.regis9(regis9),.regis10(regis10),.regis11(regis11),.regis12(regis12),.regis13(regis13),.regis14(regis14)
  );

  execute temp03(
    .clk(clk),.E_stat(E_stat),.E_icode(E_icode),.E_ifun(E_ifun),.E_valC(E_valC),.E_valA(E_valA),.E_valB(E_valB),.E_dstE(E_dstE),.E_dstM(E_dstM),.e_cnd(e_cnd),.W_stat(W_stat),.m_stat(m_stat),
    .set_cc(set_cc),
    .M_stat(M_stat),.M_icode(M_icode),.M_cnd(M_cnd),.M_valE(M_valE),.M_valA(M_valA),.M_dstE(M_dstE),.M_dstM(M_dstM),.e_valE(e_valE),.e_dstE(e_dstE)
  );


  memory temp04(
    .clk(clk),.M_stat(M_stat),.M_cnd(M_cnd),.M_dstE(M_dstE),.M_dstM(M_dstM),.W_stat(W_stat),.W_icode(W_icode),.W_valE(W_valE),.W_valM(W_valM),.W_dstE(W_dstE),.W_dstM(W_dstM),.m_stat(m_stat),.M_icode(M_icode),.M_valA(M_valA),.m_valM(m_valM),.M_valE(M_valE),.M_valP(M_valP)
  );

  hazard_control temp05(
    .D_icode(D_icode),.d_srcA(d_srcA),.d_srcB(d_srcB),.E_icode(E_icode),.E_dstM(E_dstM),.e_cnd(e_cnd),.M_icode(M_icode),.m_stat(m_stat),.W_stat(W_stat),
    .F_stall(F_stall),.D_stall(D_stall),.D_bubble(D_bubble),.E_bubble(E_bubble),.set_cc(set_cc)
  );
  
  

  initial 
    begin
      $dumpfile("processor.vcd");
      $dumpvars(0,processor);
      F_PC_in=64'd0;  
      clk=0;
      // $monitor("F_PC_in=%d F_PC_out=%d D_icode=%d, ifun=%d,E_icode=%d, M_icode=%d , W_icode=%d ,D_rA=%d,D_rB=%d, m_valM=%d, M_valA=%d ,D_valC=%d, e_valE=%d regis2=%d regis3=%d regis4=%d W_valM=%d m_valM=%d W_dstE=%d W_valE=%d\n ",F_PC_in,F_PC_out,D_icode,D_ifun,E_icode,M_icode,W_icode,D_rA,D_rB,m_valM,M_valA,D_valC,e_valE,regis2,regis3,regis4,W_valM,m_valM,W_dstE,W_valE);
      $monitor("clk=%d F_PC_in=%d F_PC_out=%d D_icode=%d, ifun=%d,E_icode=%d, M_icode=%d , W_icode=%d ,D_rA=%d,D_rB=%d, m_valM=%d, M_valA=%d ,D_valC=%d, e_valE=%d regis2=%d regis3=%d regis4=%d W_valM=%d m_valM=%d W_dstE=%d W_valE=%d\n ",clk,F_PC_in,F_PC_out,D_icode,D_ifun,E_icode,M_icode,W_icode,D_rA,D_rB,m_valM,M_valA,D_valC,e_valE,regis2,regis3,regis4,W_valM,m_valM,W_dstE,W_valE);

    end
endmodule