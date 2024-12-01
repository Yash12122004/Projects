// `include "and1bit.v"
`timescale 1ns / 1ps

module and64bit(a,b,result);

input signed [63:0] a;
input signed [63:0] b;
output signed [63:0] result;
genvar i;
generate 
    for ( i = 0; i < 64; i=i+1) 
    begin
        and1bit temp(result[i],a[i],b[i]);
    end
endgenerate

endmodule
