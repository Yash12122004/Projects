module decode (clk,icode,ra,rb,valA,valB);
    
    input clk;                          //clock 
    input [3:0] icode,ra,rb;            //instruction code, register A, register B

    output reg [63:0] valA,valB;        //value A, value B
    
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
        if(icode==4'h2)                 //cmovq
        begin
            valA=register[ra];          //rax
            valB=0;
        end
        else if(icode==4'h4)           //rmmovq
        begin
            valA=register[ra];          //rax
            valB=register[rb];          //rbx 
        end
        else if(icode==4'h5)           //mrmovq
        begin
            valB=register[rb];          //rbx
        end
        else if(icode==4'h6)           //OPq
        begin
            valA=register[ra];          //rax
            valB=register[rb];          //rbx
        end
        else if(icode==4'h8)           //call
        begin
            valB=register[4];           //rsp
        end
        else if(icode==4'h9)            //ret
        begin
            valA=register[4];           //rsp
            valB=register[4];           //rsp
        end
        else if(icode==4'hA)            //pushq
        begin
            valA=register[ra];          //rax
            valB=register[4];           //rsp
        end
        else if(icode==4'hB)            //popq
        begin
            valA=register[4];           //rsp
            valB=register[4];           //rsp
        end     
        
    end
endmodule
