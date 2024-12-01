// `include "../Add/add64bit.v"
// `include "../Add/add1bit.v"

`timescale 1ns / 1ps

module sub64bit(a,b,result,overflow);

input signed [63:0] a;
input signed [63:0] b;

wire signed [63:0] ones_comp;
wire signed [63:0] twos_comp;
wire signed comp_overflow;

output signed [63:0] result;
output overflow;

wire p,p_,q,q_,diff,diff_;
wire pq_,pq_diff_;
wire p_q,p_qdiff;
wire temp;

genvar i;
generate
    for (i = 0;i<64 ;i=i+1 )
        begin
            assign ones_comp[i]=(b[i]==0);
        end
    add64bit comp(ones_comp,64'b0000000000000000000000000000000000000000000000000000000000000001,twos_comp,comp_overflow);
    add64bit final(twos_comp,a,result,temp);
    assign p=a[63];
    assign q=b[63];
    assign diff=result[63];
    not(q_,q);
    not(p_,p);
    not(diff_,diff);
    and(pq_,p,q_);
    and(pq_diff_,pq_,diff_);
    and(p_q,p_,q);
    and(p_qdiff,p_q,diff);
    or(overflow,pq_diff_,p_qdiff);
endgenerate
endmodule
