`timescale 1ns / 1ps

module add1bit(a,b,cin,sum,cout);
input a,b,cin;
output sum,cout;
wire temp_sum,temp_cout,ab,bc,ac,abc;

xor d1(temp_sum,a,b);
xor d2(sum,temp_sum,cin);

and a1(ab,a,b);
and a2(bc,cin,b);
and a3(ac,a,cin);
or o1(abc,ab,bc);
or o2(cout,abc,ac);


endmodule
