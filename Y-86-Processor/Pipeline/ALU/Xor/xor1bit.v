`timescale 1ns / 10ps

module xor1bit(c,a,b);
    input a,b;
    output c;
    xor x1(c,a,b);
endmodule