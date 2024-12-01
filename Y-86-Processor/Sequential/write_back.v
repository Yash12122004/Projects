module write_back (clk,icode,ra,rb,cond,valE,valM,regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14);
    input clk,cond;                     //clock and condition
    input [3:0] icode,ra,rb;            //instruction code, register A, register B
    input [63:0] valE,valM;             //value E, value M
    
    output reg [63:0] regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14;        //registers
    
    reg [63:0] register[0:14];          //register

initial 
    begin
        for(integer i=0;i<15;i=i+1) 
        begin
            register[i]=i;          //initial register
        end
    end

always @(*) 
    begin
        if(icode==4'h2)         //cmovq 
            begin
                if(cond)
                begin
                    register[rb]=valE; 
                end
            end 
        else if(icode==4'h3)        //irmovq
            begin
                register[rb]=valE;
            end
        else if(icode==4'h5)        //mrmovq
            begin
                register[ra]=valM;
            end
        else if(icode==4'h6)        //OPq
            begin
                register[rb]=valE;
            end
        else if(icode==4'h8 || icode==4'h9 || icode==4'hA)        //call ret pushq
            begin
                register[4]=valE;
            end
        else if(icode==4'hB)        //popq
            begin
                register[4]=valE;
                register[ra]=valM;
            end

    regis0<=register[0];             // "<=" is used rather than "=" becuase of the parallel assignment
    regis1<=register[1];
    regis2<=register[2];
    regis3<=register[3];
    regis4<=register[4];
    regis5<=register[5];
    regis6<=register[6];
    regis7<=register[7];
    regis8<=register[8];
    regis9<=register[9];
    regis10<=register[10];
    regis11<=register[11];
    regis12<=register[12];
    regis13<=register[13];
    regis14<=register[14];
    end

endmodule