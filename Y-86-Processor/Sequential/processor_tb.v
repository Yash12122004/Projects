`timescale 1ns/1ps
`include "processor.v"

module processor_tb;
    reg clk;
    reg [2:0]CC_in;
    reg [63:0] PC;
    reg [0:79] instruct;
    reg [7:0] inst_arr[1034]; 
  
    wire mem_err,instruct_err,Z_F,S_F,O_F,cond;
    wire [2:0] CC_out;
    wire [3:0] icode,ifun,ra,rb; 
    wire [63:0] next_pc,valC,valP,regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14;
    wire signed[63:0] valA,valB,valE,valM;



  fetch temp0(.clk(clk),.PC(PC),.instruct(instruct),.icode(icode),.ifun(ifun),.ra(ra),.rb(rb),.valC(valC),.valP(valP),.mem_err(mem_err),.instruct_err(instruct_err));
  decode temp1(.clk(clk),.icode(icode),.ra(ra),.rb(rb),.valA(valA),.valB(valB));
  execute temp2(.clk(clk),.icode(icode),.ifun(ifun),.valA(valA),.valB(valB),.valC(valC),.valE(valE),.cond(cond),.CC_in(CC_in),.CC_out(CC_out),.Z_F(Z_F),.S_F(S_F),.O_F(O_F));
  memory temp3(.clk(clk),.icode(icode),.valP(valP),.valA(valA),.valB(valB),.valM(valM),.valE(valE),.mem_err(mem_err));
  write_back temp4(.clk(clk),.icode(icode),.ra(ra),.rb(rb),.cond(cond),.valE(valE),.valM(valM),.regis0(regis0),.regis1(regis1),.regis2(regis2),.regis3(regis3),.regis4(regis4),.regis5(regis5),.regis6(regis6),.regis7(regis7),.regis8(regis8),.regis9(regis9),.regis10(regis10),.regis11(regis11),.regis12(regis12),.regis13(regis13),.regis14(regis14));
  pc_update temp5(.clk(clk),.cond(cond),.icode(icode),.valC(valC),.valP(valP),.next_pc(next_pc));
  processor temp6(.mem_err(mem_err),.icode(icode),.instruct_err(instruct_err),.clk(clk),.PC(PC),.valA(valA),.valB(valB),.valC(valC),.valE(valE),.valM(valM),.valP(valP));

always @(clk) begin
    CC_in=CC_out;
end

// always @(*) 
// begin
//     if(mem_err==1)
//     begin
//         $display("************************************memory error******************************************\n");
//         $finish;
//     end
//     // else if(instruct_err==1)
//     // begin
//     //     $display("************************************instruction error*************************************\n");
//     //     $finish;
//     // end
// end

// always@(*)
// begin
//     if(icode==4'b0)
//     begin
//         $display("*************************************halting**************************************************\n");
//         $finish;
//     end
// end


initial 
    begin
        for(integer i=0;i<1034;i=i+1)
        begin
            inst_arr[i]=8'd0; 
        end
        CC_in=3'b000;
    end

always@(clk)
begin
    PC<=next_pc; 
end

always@(mem_err)
begin
    if(mem_err)
    begin
        $display("********************************************Memory Error*************************************");
        $finish;
    end
end

always@(instruct_err)
begin
    if(instruct_err)
    begin 
        $display("********************************************Instruction Error*************************************");
        $finish;
    end
end

always@(icode)
begin
    if(icode==4'b0)
    begin 
        $display("******************************************** Halting*************************************");
        $finish;
    end
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
    // $display("%d %b",PC,instruct);
    end

initial 
begin 
    $dumpfile("processor_tb.vcd");
    $dumpvars(0, processor_tb);
    // OPq rB
    // cmovq

//Test_Bench-1

    // PC=64'd62;
    // inst_arr[62]=8'b01100000; //6 fn
    // inst_arr[63]=8'b00100011; //rA 
    // inst_arr[64]=8'b00100001; //8 fn
    // inst_arr[65]=8'b00110100; //rA rB
    // // //irmovq
    // inst_arr[66]=8'b10000101; // 8 ge 
    // inst_arr[67]=8'b01010011; // rA rB 
    // inst_arr[75]=8'd78; // valC
    // // inst_arr[75]=8'b00000110; // valC
    // //pushq
    // inst_arr[76]=8'b10100000; // A 0 
    // inst_arr[77]=8'b01000010; // rA rB
    // // //jxx
    // inst_arr[78]=8'b11110001; //7 fn
    // inst_arr[79]=8'b00000000; //Destination
    // inst_arr[87]=8'b00000011; //Destination
    
    
    // // // clk=1;
    
    
    // #10
    // clk=1;
    // // PC=64'd64;
    // #10
    // clk=~clk;
    // // // PC=64'd66;
    // #10
    // clk=~clk;
    // // PC=64'd71;
    // // #10
    // // clk=~clk;
    
    // // PC=64'd90;

// Test_Bench-2

inst_arr[80] = 8'h63;
inst_arr[81] = 8'hDE;

inst_arr[82] = 8'h63;
inst_arr[83] = 8'hDE;


inst_arr[84] = 8'h63;
inst_arr[85] = 8'hDE;

inst_arr[86] = 8'h63;
inst_arr[87] = 8'hDE;

inst_arr[88] = 8'h63;
inst_arr[89] = 8'hDE;

inst_arr[90] = 8'h63;
inst_arr[91] = 8'hDE;
inst_arr[91] = 8'h0;

PC=64'd1;
// clk=0;
inst_arr[1]  = 8'h10; //nop

#10
clk=1;
inst_arr[2] = 8'h20; //rrmovq
inst_arr[3] = 8'h12;

#10
clk=~clk;

inst_arr[4] = 8'h30;//irmovq
inst_arr[5] = 8'hF2;
inst_arr[6] = 8'h00;
inst_arr[7] = 8'h00;
inst_arr[8] = 8'h00;
inst_arr[9] = 8'h00;
inst_arr[10] = 8'h00;
inst_arr[11] = 8'h00;
inst_arr[12] = 8'h00;
inst_arr[13] = 8'h02;
#10
clk=~clk;
inst_arr[14] = 8'h40;//rmmovq
inst_arr[15] = 8'h24;
{inst_arr[16],inst_arr[17],inst_arr[18],inst_arr[19],inst_arr[20],inst_arr[21],inst_arr[22],inst_arr[23]} = 64'd1;
#10
clk=~clk;
inst_arr[24] = 8'h40;//rmmovq
inst_arr[25] = 8'h53;
{inst_arr[26],inst_arr[27],inst_arr[28],inst_arr[29],inst_arr[30],inst_arr[31],inst_arr[32],inst_arr[33]} = 64'd0;
#10
clk=~clk;
inst_arr[34] = 8'h50;//mrmovq
inst_arr[35] = 8'h53;
{inst_arr[36],inst_arr[37],inst_arr[38],inst_arr[39],inst_arr[40],inst_arr[41],inst_arr[42],inst_arr[43]} = 64'd0;
#10
clk=~clk;
inst_arr[44] = 8'h60;
inst_arr[45] = 8'h9A;
#10
clk=~clk;
inst_arr[46] = 8'h73;
{inst_arr[47],inst_arr[48],inst_arr[49],inst_arr[50],inst_arr[51],inst_arr[52],inst_arr[53],inst_arr[54]} = 64'd56;
#10
clk=~clk;
inst_arr[55] = 8'h10;
#10
clk=~clk;
inst_arr[56] = 8'hA0;
inst_arr[57] = 8'h9F;
#10
clk=~clk;
inst_arr[58] = 8'hB0;
inst_arr[59] = 8'h9F;
#10
clk=~clk;
inst_arr[60] = 8'h80;
{inst_arr[61],inst_arr[62],inst_arr[63],inst_arr[64],inst_arr[65],inst_arr[66],inst_arr[67],inst_arr[68]} = 64'd80;
#10
clk=~clk;
inst_arr[69] = 8'h60;
inst_arr[70] = 8'h56;
#10
clk=~clk;
inst_arr[71] = 8'h70;
{inst_arr[72],inst_arr[73],inst_arr[74],inst_arr[75],inst_arr[76],inst_arr[77],inst_arr[78],inst_arr[79]} = 64'd46;
#10
clk=~clk;

#10
clk=~clk;
inst_arr[82] = 8'h90;
end

initial 
    $monitor("instruct=%b\nclk=%b PC=%d icode=%d ifun=%d ra=%d rb=%d valA=%d valB=%d valC=%d valE=%d valM=%d valP=%d next_PC=%d CC_in=%b CC_out=%b Z_F=%b S_F=%b O_F=%b cond=%b mem_err=%b instruct_err=%b\n",instruct,clk,PC,icode,ifun,ra,rb,valA,valB,valC,valE,valM,valP,next_pc,CC_in,CC_out,Z_F,S_F,O_F,cond,mem_err,instruct_err);    
    // $monitor("regis0=%d regis1=%d regis2=%d regis3=%d regis4=%d regis5=%d regis6=%d regis7=%d regis8=%d regis9=%d regis10=%d regis11=%d regis12=%d regis13=%d regis14=%d\n",regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14);

endmodule
