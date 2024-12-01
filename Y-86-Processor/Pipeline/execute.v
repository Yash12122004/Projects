`include "./ALU/Xor/xor1bit.v" 
`include "./ALU/Xor/xor64bit.v"
`include "./ALU/And/and1bit.v"
`include "./ALU/And/and64bit.v"
`include "./ALU/Add/add1bit.v"
`include "./ALU/Add/add64bit.v"
`include "./ALU/Sub/sub64bit.v"
`include "./ALU/ALU/alu.v"

module execute(clk,E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,e_cnd,W_stat,m_stat,
                set_cc,
                M_stat,M_icode,M_cnd,M_valE,M_valA,M_dstE,M_dstM,e_valE,e_dstE,E_bubble);

input clk;
input[0:3] E_stat,m_stat,W_stat;
input[3:0] E_icode,E_ifun,E_dstE,E_dstM;
input[63:0] E_valC,E_valA,E_valB;

input set_cc;

input E_bubble;

output reg [0:3] M_stat;
output reg [3:0] M_icode,M_dstE,M_dstM,e_dstE;
output reg M_cnd;
output reg [63:0] M_valE,M_valA,e_valE;
output reg e_cnd=1; 

reg [2:0] CC_in=3'b000;       //condition codes


reg Z_F,S_F,O_F;
output reg[2:0] CC;

reg[1:0] control;
reg signed [63:0] aluA,aluB,ans;
wire signed [63:0] out;
wire overflow;

alu temp01(control,aluB,aluA,out,overflow); 

initial
    begin
        e_cnd=0;

        Z_F<=CC_in[0];
        S_F<=CC_in[1];
        O_F<=CC_in[2]; 
        
    end

always @(*) 
    begin
        if(E_icode==4'h1)
        begin 
            //do noughting
        end
        else
        begin  
            if(E_icode==4'h2)
            begin
                if(E_ifun==4'b0000)//rrmovq
                begin 
                    e_cnd=1; 
                end
                else if(E_ifun==4'b0001)//cmovle  
                begin 
                    e_cnd=S_F|O_F;
                end
                else if(E_ifun==4'b0010)//cmovl
                begin 
                    e_cnd=S_F^O_F; 
                end
                else if(E_ifun==4'b0011)//cmove
                begin 
                    e_cnd=Z_F; 
                end
                else if(E_ifun==4'b0100)//cmovne
                begin 
                    e_cnd=~Z_F;  
                end
                else if(E_ifun==4'b0101)//cmovge
                begin 
                    e_cnd=~(S_F^O_F); 
                end
                else if(E_ifun==4'b0110)//cmovg
                begin 
                    e_cnd=(S_F^O_F)|Z_F;  
                end
                else 
                begin
                    e_cnd=0;
                end
                aluA=E_valA;
                aluB=0;
                control = 2'b00;
            end
            else if (E_icode==4'h3) //irmovq V,rB
            begin
                aluA=E_valC;
                aluB=0;
                control = 2'b00; //add 
            end
            else if (E_icode==4'h4) //rmmovq rA,D(rB) 
            begin
                aluA = E_valC;
                aluB = E_valB;
                control= 2'b00; // add
            end
            else if (E_icode==4'h5) //mrmovq D(rB),rA
            begin
                aluA = E_valC;
                aluB = E_valB;
                control = 2'b00; //add
            end
            else if (E_icode==4'h6)//opq
            begin 
                if (E_ifun==4'b0000) 
                begin
                    control= 2'b00;
                end  
                else if (E_ifun==4'b0001) 
                begin
                    control=2'b01;
                end
                else if (E_ifun==4'b0010) 
                begin
                    control=2'b10;
                end
                else if (E_ifun==4'b0011) 
                begin
                    control =2'b11;
                end
            aluA <=E_valA;
            aluB <=E_valB;
            end
            else if(E_icode==4'h7)
            begin
                if(E_ifun==4'b0000)//jmp
                begin 
                    e_cnd=1; 
                end
                else if(E_ifun==4'b0001)//jmple
                begin 
                    e_cnd=S_F|O_F;
                end
                else if(E_ifun==4'b0010)//jmpl
                begin 
                    e_cnd=S_F^O_F;
                end
                else if(E_ifun==4'b0011)//jmpe
                begin 
                    e_cnd=Z_F; 
                end 
                else if(E_ifun==4'b0100)//jmpne
                begin 
                    e_cnd=~Z_F;
                end
                else if(E_ifun==4'b0101)//jmpge 
                begin 
                    e_cnd=~(S_F^O_F); 
                end
                else if(E_ifun==4'b0110)//jmpg
                begin 
                    e_cnd=(S_F^O_F)|Z_F; 
                end
                else 
                begin
                    e_cnd=0;
                end
            end
            else if (E_icode==4'h8)
            begin
                aluA= 1;
                aluB= E_valB;
                control=2'b01;       
            end
            else if (E_icode==4'h9) 
            begin
                aluA =1;
                aluB = E_valB;
                control = 2'b00;
            end

            else if (E_icode==4'hA) //pushq
            begin
                aluA=1;
                aluB=E_valB;       //decrementing stack pointer by 1
                control= 2'b01;
            end
            else if (E_icode==4'hB) //popq
            begin
                aluA=1; 
                aluB=E_valB; 
                control=2'b00;   
            end
            ans = out;
            e_valE = ans;
            if(E_icode==4'h2 || E_icode==4'h7)
            begin
                if(e_cnd)
                begin 
                    e_dstE=E_dstE;
                end
                else 
                begin
                    e_dstE=4'hF;
                end
            end
            else 
            begin 
                e_dstE=E_dstE;
            end
            if(out==0)
            begin
                Z_F <= 1;
            end
            else 
            begin
                Z_F <= 0;
            end 
            S_F <= out[63];
            O_F <= overflow;
            if(set_cc)
            begin
                // $display("Z_F=%d S_F=%d O_F=%d",Z_F,S_F,O_F);  
                CC_in[0] <= Z_F;
                CC_in[1] <= S_F;
                CC_in[2] <= O_F;     
            end
        end
    end



always@(posedge clk)
  begin                 // as memory will always be normal
      M_stat <= E_stat;
      M_icode <= E_icode; 
      M_cnd <= e_cnd;
      M_valE <= e_valE;
      M_valA <= E_valA;
      M_dstE <= e_dstE;
      M_dstM <= E_dstM;
  end

endmodule