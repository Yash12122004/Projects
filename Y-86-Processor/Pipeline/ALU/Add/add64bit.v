`timescale 1ns / 1ps
// `include "../Add/add1bit.v"

module add64bit(a,b,result,overflow);

input signed [63:0] a;
input signed [63:0] b;

wire signed [63:0] cout;

output signed [63:0] result;
output overflow;

wire p,p_,q,q_,sum,sum_;
wire p_q_,p_q_sum;
wire pq,pqsum_;

genvar i;
generate 
    for ( i = 0; i < 64; i=i+1) 
        begin
            if (i==0) 
                begin
                    add1bit temp(a[i],b[i],1'b0,result[i],cout[i]);
                end
            else
                begin
                    add1bit temp(a[i],b[i],cout[i-1],result[i],cout[i]);
                end
        end
        assign p=a[63];
        assign q=b[63];
        assign sum=result[63];
        not(q_,q);
        not(p_,p);
        not(sum_,sum);
        and(p_q_,p_,q_);
        and(p_q_sum,p_q_,sum);
        and(pq,p,q);
        and(pqsum_,pq,sum_);
        or(overflow,p_q_sum,pqsum_);
endgenerate

endmodule
