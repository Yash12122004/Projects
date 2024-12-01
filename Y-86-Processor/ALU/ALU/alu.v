`timescale 1ns / 1ps

// `include "../Xor/xor1bit.v"
// `include "../Xor/xor64bit.v"
// `include "../And/and1bit.v"
// `include "../And/and64bit.v"
// `include "../Add/add1bit.v"
// `include "../Add/add64bit.v"
// `include "../Sub/sub64bit.v"


module alu(control,a,b,result,overflow);

input [1:0] control;
input signed [63:0] a;
input signed [63:0] b;
output reg signed [63:0] result;
output reg overflow;

wire add_overflow,sub_overflow,xor_overflow,and_overflow;
wire signed [63:0] add_result,sub_result,and_result,xor_result;

add64bit temp_add(a,b,add_result,add_overflow);
sub64bit temp_sub(a,b,sub_result,sub_overflow);
and64bit temp_and(a,b,and_result);
assign and_overflow=0;
xor64bit temp_xor(a,b,xor_result);
assign xor_overflow=0;

always @(*) 
    begin
        case (control)
            2'b00:  //Add
                begin
                    result=add_result;
                    overflow=add_overflow;   
                end
            2'b01:  //Sub
                begin 
                    result=sub_result;
                    overflow=sub_overflow;
                end
            2'b10:  //And
                begin
                    result=and_result;
                    overflow=and_overflow;
                end
            2'b11:  //Xor
                begin
                    result=xor_result;
                    overflow=xor_overflow;
                end
        endcase    
    end

endmodule
