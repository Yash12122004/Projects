`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "write_back.v"
`include "pc_update.v"

module processor(mem_err,icode,instruct_err,clk,PC,valA,valB,valC,valE,valM,valP);
    
    input mem_err,instruct_err,clk;
    input [63:0] PC;
    input [63:0] valA,valB,valC,valE,valM,valP;
    input [3:0] icode;

// always @(*) 
// begin
//     if(instruct_err==1)
//     begin
//         $display("************************************instruction error*************************************\n");
//         $finish;
//     end
// end

// always@(icode)
// begin
//     if(icode==4'd0)
//     begin
//         $display("*************************************halting**************************************************\n");
//         $finish;
//     end
// end

endmodule