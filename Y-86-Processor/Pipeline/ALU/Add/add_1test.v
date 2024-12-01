`include "add1bit.v"

`timescale 1ns/1ps 
module and_1test;
reg  a;
reg  b;
reg  cin;
wire  cout;
wire  sum;
add1bit new(a,b,cin,sum,cout);
initial begin
    $dumpfile("test_add1.vcd");
    $dumpvars(0,and_test);
    a=1'b0;
    b=1'b0;
    cin=1'b0;
end

initial begin 
    $monitor("a=",a, " b= ",b," cin= ",cin," sum=",sum," cout =",cout);
    #5 
    a=1'b0;
    b=1'b0;
    cin=1'b1;
    #5 
    a=1'b0;
    b=1'b1;
    cin=1'b0;
    #5 
    a=1'b0;
    b=1'b1;
    cin=1'b1;
    #5 
    a=1'b1;
    b=1'b0;
    cin=1'b0;
    #5 
    a=1'b1;
    b=1'b0;
    cin=1'b0;
    #5 
    a=1'b1;
    b=1'b0;
    cin=1'b1;
    #5 
    a=1'b1;
    b=1'b1;
    cin=1'b0;
    #5 
    a=1'b1;
    b=1'b1;
    cin=1'b1;
end
endmodule