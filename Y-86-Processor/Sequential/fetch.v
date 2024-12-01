module fetch (clk,PC,instruct,icode,ifun,ra,rb,valC,valP,mem_err,instruct_err);
    input clk;                          // clock
    input [63:0] PC;                    // program counter
    input [0:79] instruct;              // instruction 
    
    output reg [3:0] icode,ifun,ra,rb;  // instruction code, function code, register A, register B
    output reg [63:0] valC,valP;        // Constant(Displacemnet/value), next PC
    output reg mem_err,instruct_err;    // memory error, instruction error

// initial 
//     begin 
//         inst_arr[32]=8'b00000000; //0 fnx
//         inst_arr[33]=8'b00000000; //rA rB
//         inst_arr[34]=8'b00000000; // 0 0 
//         inst_arr[35]=8'b00000000; // 0 0 
//         inst_arr[36]=8'b00000000; // 0 0
//     end

initial
begin
    instruct_err=0;
    mem_err=0;
end

always @(*)
begin
    
    icode=instruct[0:3];                    // icode is valid for all instructions
    ifun=instruct[4:7];                     // ifun 
    if(PC>64'd1023)                             // check if PC is out of range
        begin
            mem_err=1;  
        end
    else if(icode==4'h0)                        //halt
        begin
            valP=PC+1;                      
        end
    else if(icode==4'h1)                   //nop
        begin
            ra=4'hF;
            rb=4'hF; 
            valP=PC+1;
        end
    else if(icode==4'h2)                   //cmovXX
        begin
            {ra,rb}=instruct[8:15];
            valP=PC+2;
        end
    else if(icode==4'h3)                   //irmovq
        begin                   
            {ra,rb,valC}=instruct[8:79];
            valP=PC+10;
        end
    else if(icode==4'h4)                   //rmmovq
        begin
            {ra,rb,valC}=instruct[8:79];    
            valP=PC+10;
        end
    else if(icode==4'h5)                   //mrmovq
        begin
            {ra,rb,valC}=instruct[8:79];
            valP=PC+10;
        end
    else if(icode==4'h6)                   //opq
        begin
            {ra,rb}=instruct[8:15];
            valP=PC+2;
        end
    else if(icode==4'h7)                   //jXX
        begin
            valC=instruct[8:71];
            valP=PC+9;
        end
    else if(icode==4'h8)                   //call
        begin
            valC=instruct[8:71];
            valP=PC+9;
        end
    else if(icode==4'h9)                   //ret
        begin 
            valP=PC+1;
        end
    else if(icode==4'hA)                   //pushq
        begin
            {ra,rb}=instruct[8:15];
            valP=PC+2;
        end 
    else if(icode==4'hB)                   //popq
        begin
            {ra,rb}=instruct[8:15];
            valP=PC+2;
        end
    else                                   // invalid instruction
        begin 
            instruct_err=1; 
        end 
end
endmodule