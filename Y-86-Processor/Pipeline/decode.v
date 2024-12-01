module decode_writeback(clk,D_stat,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,
    E_bubble,E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB,
    d_srcA,d_srcB,e_dstE,M_dstE,M_dstM,W_dstE,W_dstM,e_valE,M_valE,m_valM,W_valE,W_valM,W_icode,
    regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14
);



input clk;
input [3:0] D_icode,D_ifun,D_rA,D_rB,e_dstE,M_dstE,M_dstM,W_dstE,W_dstM,W_icode;
input [0:3] D_stat;
input [63:0] D_valC,D_valP,e_valE,M_valE,m_valM,W_valE,W_valM;
input E_bubble;

output reg [0:3] E_stat;
output reg [3:0] E_icode,E_ifun,E_dstE,E_dstM,E_srcA,E_srcB,d_srcA,d_srcB;
output reg [63:0] E_valC,E_valA,E_valB,E_valP,regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14;

reg [3:0] d_dstE,d_dstM;
reg [63:0] d_valA,d_valB;
reg [63:0] register[0:14];

initial 
    begin
        for(integer i=0;i<15;i=i+1) 
        begin
            register[i]=i;          //initial register
        end
    end

always@(*)
    begin

        //finding srcA,srcB,dstE,dstM values

        if(D_icode==4'h2)                 //cmovq
        begin
            d_srcA=D_rA;
            d_dstE=D_rB;
            d_valA=register[D_rA];          //rax
            d_valB=0;
        end
        else if(D_icode==4'h3)
        begin 
            d_dstE=D_rB;
        end
        else if(D_icode==4'h4)           //rmmovq
        begin
            d_srcA=D_rA;
            d_srcB=D_rB;
            d_valA=register[D_rA];          //rax
            d_valB=register[D_rB];          //rbx 
        end
        else if(D_icode==4'h5)           //mrmovq
        begin
            d_srcB=D_rB;
            d_dstM=D_rA;
            d_valB=register[D_rB];          //rbx
        end
        else if(D_icode==4'h6)           //OPq
        begin
            d_srcA = D_rA;
            d_srcB = D_rB;
            d_dstE = D_rB;
            d_valA=register[D_rA];          //rax
            d_valB=register[D_rB];          //rbx
        end
        else if(D_icode==4'h8)             //call
        begin
            d_srcB = 4;
            d_dstE = 4;
            d_valB=register[4];           //rsp
        end
        else if(D_icode==4'h9)            //ret
        begin
            d_srcA = 4;
            d_srcB = 4;
            d_dstE = 4;
            d_valA=register[4];           //rsp
            d_valB=register[4];           //rsp
        end
        else if(D_icode==4'hA)            //pushq
        begin
            d_srcA = D_rA;
            d_srcB = 4;
            d_dstE = 4;
            d_valA=register[D_rA];          //rax
            d_valB=register[4];           //rsp
        end
        else if(D_icode==4'hB)            //popq
        begin
            d_srcA = 4;
            d_srcB = 4;
            d_dstE = 4;
            d_dstM = D_rA;
            d_valA=register[4];           //rsp
            d_valB=register[4];           //rsp
        end 
        else 
        begin 
            d_srcA=4'hF;
            d_srcB=4'hF;
            d_dstE=4'hF;
            d_dstM=4'hF;
        end    
        // Forwarding A
        if(D_icode==4'h7 | D_icode == 4'h8) 
        begin
            d_valA = D_valP;
        end
        else if(d_srcA==e_dstE & e_dstE!=4'hF)
        begin 
            d_valA = e_valE;   
        end
        else if(d_srcA==M_dstM & M_dstM!=4'hF)
        begin 
            d_valA = m_valM;
        end
        else if(d_srcA==W_dstM & W_dstM!=4'hF)
        begin
            d_valA = W_valM;
        end
        else if(d_srcA==M_dstE & M_dstE!=4'hF)
        begin 
            d_valA = M_valE;
        end
        else if(d_srcA==W_dstE & W_dstE!=4'hF)
        begin 
            d_valA = W_valE;
        end 
        
        // Forwarding B
        if(d_srcB==e_dstE & e_dstE!=4'hF)      
        begin 
            d_valB = e_valE;
        end
        else if(d_srcB==M_dstM & M_dstM!=4'hF) 
        begin 
            d_valB = m_valM;
        end 
        else if(d_srcB==W_dstM & W_dstM!=4'hF) 
        begin 
            d_valB = W_valM;
        end
        else if(d_srcB==M_dstE & M_dstE!=4'hF) 
        begin 
            d_valB = M_valE;
        end
        else if(d_srcB==W_dstE & W_dstE!=4'hF) 
        begin 
            d_valB = W_valE;
        end
    end


    always@(posedge clk) 
    begin 
        if(E_bubble) 
        begin 
        $display("************ E_bubbled ***************\n");
        E_stat <= 4'b1000; 
        E_icode <= 4'b0001;
        E_ifun <= 4'b0000;
        E_valC <= 4'b0000;
        E_valA <= 4'b0000;
        E_valB <= 4'b0000;
        E_dstE <= 4'hF;
        E_dstM <= 4'hF;
        E_srcA <= 4'hF;
        E_srcB <= 4'hF; 
        end
        else 
        begin 
        E_stat <= D_stat;
        E_icode <= D_icode;   
        E_ifun <= D_ifun;
        E_valC <= D_valC;
        E_valA <= d_valA;
        E_valB <= d_valB;
        E_srcA <= d_srcA;
        E_srcB <= d_srcB;
        E_dstE <= d_dstE;
        E_dstM <= d_dstM;
        end

    end

//Writeback 
always @(posedge clk) 
    begin
        if(W_icode==4'h2)         //cmovq
            begin
                register[W_dstE]=W_valE; 
            end 
        else if(W_icode==4'h3)    //irmovq    
            begin
                register[W_dstE]=W_valE;
            end
        else if(W_icode==4'h5)        //mrmovq
            begin
                register[W_dstM]=W_valM;
            end
        else if(W_icode==4'h6)        //OPq
            begin
                register[W_dstE]=W_valE;
            end
        else if(W_icode==4'h8 || W_icode==4'h9 || W_icode==4'hA)        //call ret pushq
            begin
                register[W_dstE]=W_valE;
            end
        else if(W_icode==4'hB)        //popq
            begin
                register[W_dstE]=W_valE;
                register[W_dstM]=W_valM;
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