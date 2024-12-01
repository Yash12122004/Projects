module pc_update (clk,cond,icode,valC,valM,valP,next_pc);
    input clk,cond;                 //clock, condition
    input [3:0] icode;              //instruction code
    input [63:0] valC,valM,valP;    //constant, memory value, next PC
    
    output reg [63:0] next_pc;      //new PC value
always @(*)
    begin
        if(icode==4'h7)               //jXX
        begin
            if(cond==1)
            begin
                next_pc=valC;         //if condition is true, next_pc should be valC
            end
            else
            begin
                next_pc=valP;
            end
        end
        else if(icode==4'h8)               //call
        begin
            next_pc=valC;    
        end
        else if(icode==4'h9)               //ret
        begin
            next_pc=valM;
        end
        else            //all other instructions
        begin
            next_pc=valP;
        end 
    end
endmodule