`include "./ALU/Xor/xor1bit.v" 
`include "./ALU/Xor/xor64bit.v"
`include "./ALU/And/and1bit.v"
`include "./ALU/And/and64bit.v"
`include "./ALU/Add/add1bit.v"
`include "./ALU/Add/add64bit.v"
`include "./ALU/Sub/sub64bit.v"
`include "./ALU/ALU/alu.v"

module execute(clk,icode,ifun,valA,valB,valC,valE,cond,CC_in,CC_out,Z_F,S_F,O_F);

input clk;
input[3:0] icode,ifun;
input[2:0] CC_in;
input signed [63:0] valA,valB,valC;

output reg cond,Z_F,S_F,O_F;
output reg[2:0] CC_out;
output reg[63:0] valE;

reg[1:0] control;
reg signed [63:0] aluA,aluB,ans;
wire signed [63:0] out;
wire overflow;

alu temp01(control,aluB,aluA,out,overflow);

initial
    begin
        cond=0;
        Z_F<=CC_in[0];
        S_F<=CC_in[1];
        O_F<=CC_in[2]; 
    end

always @(*) 
begin
    if(icode==4'h2)
    begin
        if(ifun==4'b0000)//rrmovq
        begin 
            cond=1; 
        end
        else if(ifun==4'b0001)//cmovle  
        begin 
            cond=S_F|O_F;
        end
        else if(ifun==4'b0010)//cmovl
        begin 
            cond=S_F^O_F; 
        end
        else if(ifun==4'b0011)//cmove
        begin 
            cond=Z_F; 
        end
        else if(ifun==4'b0100)//cmovne
        begin 
            cond=~Z_F;  
        end
        else if(ifun==4'b0101)//cmovge
        begin 
            cond=~(S_F^O_F); 
        end
        else if(ifun==4'b0110)//cmovg
        begin 
            cond=(S_F^O_F)|Z_F;  
        end
        else 
        begin
            cond=0;
        end
        aluA=valA;
        aluB=0;
        control = 2'b00;
    end
    else if (icode==4'h3) //irmovq V,rB
    begin
        aluA=valC;
        aluB=0;
        control = 2'b00; //add
    end
    else if (icode==4'h4) //rmmovq rA,D(rB) 
    begin
        aluA = valC;
        aluB = valB;
        control= 2'b00; // add
    end
    else if (icode==4'h5) //mrmovq D(rB),rA
    begin
        aluA = valC;
        aluB = valB;
        control = 2'b00; //add
    end
    else if (icode==4'h6)//opq
    begin 
      if (ifun==4'b0000) 
      begin
        control= 2'b00;
      end  
      else if (ifun==4'b0001) 
      begin
        control=2'b01;
      end
      else if (ifun==4'b0010) 
      begin
        control=2'b10;
      end
      else if (ifun==4'b0011) 
      begin
        control =2'b11;
      end
      aluA <=valA;
      aluB <=valB;
    end
    else if(icode==4'h7)
    begin
        if(ifun==4'b0000)//jmp
        begin 
            cond=1; 
        end
        else if(ifun==4'b0001)//jmple
        begin 
            cond=S_F|O_F;
        end
        else if(ifun==4'b0010)//jmpl
        begin 
            cond=S_F^O_F;
        end
        else if(ifun==4'b0011)//jmpe
        begin 
            cond=Z_F; 
        end 
        else if(ifun==4'b0100)//jmpne
        begin 
            cond=~Z_F;
        end
        else if(ifun==4'b0101)//jmpge
        begin 
            cond=~(S_F^O_F); 
        end
        else if(ifun==4'b0110)//jmpg
        begin 
            cond=(S_F^O_F)|Z_F; 
        end
        else 
        begin
            cond=0;
        end
    end
    else if (icode==4'h8)
    begin
        aluA= 8;
        aluB= valB;
        control=2'b01;      
    end
    else if (icode==4'h9) 
    begin
        aluA =8;
        aluB = valB;
        control = 2'b00;
    end

    else if (icode==4'hA) //pushq
    begin
        aluA=8;
        aluB=valB;       //decrementing stack pointer by 8
        control= 2'b01;
    end
    else if (icode==4'hB) //popq
    begin
        aluA=8; 
        aluB=valB; 
        control=2'b00;   
    end
  ans = out;
  valE = ans;
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
  CC_out[0] <= Z_F;
  CC_out[1] <= S_F;
  CC_out[2] <= O_F;     
end
endmodule