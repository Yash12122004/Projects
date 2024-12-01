module fetch(clk,M_icode,W_icode,M_valA,W_valM,M_cnd,F_PC_in,F_stall,D_stall,D_bubble,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,D_stat,F_PC_out,M_valP);
    input clk,M_cnd,F_stall,D_stall,D_bubble; 
    input [3:0] M_icode,W_icode;
    input [63:0] M_valA,W_valM,F_PC_in;

    reg [3:0] icode, ifun,ra,rb;  //local values         
    reg [63:0] PC,valC,valP;                
    reg mem_err=0, instruct_err=0;          
    reg [0:3] stat_code;                    
    reg [0:79] instruct;                    
    reg [7:0] inst_arr[0:1024];             

    output reg [3:0] D_icode, D_ifun,D_rA, D_rB;
    output reg [63:0] D_valC,D_valP,F_PC_out,M_valP;
    output reg [0:3] D_stat=4'b1000;                  // AOK, HLT, ADR, INS


    always@(*)
    begin 
        if(M_icode==4'h7 & !M_cnd)  // Jump not taken
        begin    
            PC = M_valA; 
        end
        else if(W_icode==4'h9)      // Return statement 
        begin
            PC = W_valM;
        end
        else 
        begin
            PC = F_PC_in;          // in all other remaning cases
        end
    end


    always@(*) 
    begin 
        instruct_err=0;
        if(PC>64'd1013)                             // check if PC is out of range
        begin
            mem_err=1;  
        end
        instruct={
            inst_arr[PC],
            inst_arr[PC+1],
            inst_arr[PC+2],
            inst_arr[PC+3],
            inst_arr[PC+4],
            inst_arr[PC+5],
            inst_arr[PC+6],
            inst_arr[PC+7],
            inst_arr[PC+8],
            inst_arr[PC+9]
        };

        icode=instruct[0:3];                    // icode is valid for all instructions
        ifun=instruct[4:7];                     // ifun 
        
        if(icode==4'h0)                        //halt
            begin
                valP=PC;
                F_PC_out=valP;                      
            end
        else if(icode==4'h1)                   //nop
            begin
                valP=PC+1;
                F_PC_out=valP;
            end
        else if(icode==4'h2)                   //cmovXX
            begin
                {ra,rb}=instruct[8:15];
                valP=PC+2;
                F_PC_out=valP;
            end
        else if(icode==4'h3)                   //irmovq
            begin                   
                {ra,rb,valC}=instruct[8:79];
                valP=PC+10;
                F_PC_out=valP;
            end
        else if(icode==4'h4)                   //rmmovq
            begin
                {ra,rb,valC}=instruct[8:79];    
                valP=PC+10;
                F_PC_out=valP;
            end
        else if(icode==4'h5)                   //mrmovq
            begin
                {ra,rb,valC}=instruct[8:79];
                valP=PC+10;
                F_PC_out=valP;
            end
        else if(icode==4'h6)                   //opq
            begin
                {ra,rb}=instruct[8:15];
                valP=PC+2;
                F_PC_out=valP;
            end
        else if(icode==4'h7)                   //jXX
            begin
                valC=instruct[8:71];
                valP=PC+9;
                F_PC_out=valC;   
            end
        else if(icode==4'h8)                   //call
            begin
                valC=instruct[8:71];
                valP=PC+9;
                F_PC_out=valC;
                M_valP=valP;
            end
        else if(icode==4'h9)                   //ret
            begin 
                valP=PC+1;
                F_PC_out=valP; 
            end
        else if(icode==4'hA)                   //pushq
            begin
                {ra,rb}=instruct[8:15];
                valP=PC+2;
                F_PC_out=valP;
            end 
        else if(icode==4'hB)                   //popq
            begin
                {ra,rb}=instruct[8:15];
                valP=PC+2;
                F_PC_out=valP;
            end
        else                                   // invalid instruction
            begin 
                instruct_err=1; 
            end

        //updating stat codes 
        
        stat_code = 4'b1000;
        if(instruct_err==1)
        begin
            stat_code = 4'b0001;  
        end
        else if(mem_err==1)
        begin 
            stat_code = 4'b0010;
        end
        else if(icode==4'd0)
        begin
            stat_code = 4'b0100;
        end
        
    end

    // Sending values to Decode stage  

    always@(posedge clk)
    begin
        if(F_stall)
        begin 
            PC = F_PC_in;   
            $display("F_stalled\n");
        end
        if(D_stall)
        begin  
            //do noughting continue with prev instructions
            $display("D_stalled\n");
        end
        else if(D_bubble)     //If Decode stage is bubble then nop should be given to Decode stage
        begin
            $display("D_bubbled\n");
            D_icode <= 4'b0001;
            D_ifun <= 4'b0000;
            D_rA <= 4'b0000;
            D_rB <= 4'b0000;
            D_valC <= 64'b0;
            D_valP <= 64'b0;
            D_stat <= 4'b1000; 
        end
        else                    // if Decode stage is normal then send the values of icode,ifun,ra,rb ............ to decode stage
        begin
            D_icode <= icode; 
            D_ifun <= ifun;
            D_rA <= ra;
            D_rB <= rb;
            D_valC <= valC;
            D_valP <= valP; 
            D_stat <= stat_code; 
        end
    end

    initial 
    begin 

//Full instructions

    inst_arr[0]=8'h10; //nop
    
    inst_arr[1]=8'h61; //subtraction 
    inst_arr[2]=8'h47; //ra and rb
    
    inst_arr[3]=8'h23; //cmov  
    inst_arr[4]=8'h45; // ra=4 and rb=5    
    
    inst_arr[5]=8'h30; //irmovq        
    inst_arr[6]=8'hF1; //F and rB 
    inst_arr[7]=8'h00; //
    inst_arr[8]=8'd00;          
    inst_arr[9]=8'h00; 
    inst_arr[10]=8'h00; 
    inst_arr[11]=8'h00;        
    inst_arr[12]=8'h00; 
    inst_arr[13]=8'h00;
    inst_arr[14]=8'd26;

    inst_arr[15]=8'h40; //rmmovq 
    inst_arr[16]=8'h65; //ra and rb 
    inst_arr[17]=8'h00; //
    inst_arr[18]=8'd00;
    inst_arr[19]=8'd00; //0 0

    inst_arr[20]=8'h00; //3 0
    inst_arr[21]=8'h00; //F rB=7
    inst_arr[22]=8'h00;           
    inst_arr[23]=8'h00;           
    inst_arr[24]=8'd5; //D value   

    inst_arr[25]=8'h50;   //mrmovq        
    inst_arr[26]=8'h81;   // ra rb       
    inst_arr[27]=8'h00;           
    inst_arr[28]=8'h00;          
    inst_arr[29]=8'd00; 
    inst_arr[30]=8'h00; 
    inst_arr[31]=8'h00; 
    inst_arr[32]=8'h00;           
    inst_arr[33]=8'h00;           
    inst_arr[34]=8'd6; //D=6           
    
    inst_arr[35]=8'h60;  //OPq addition
    inst_arr[36]=8'h23;  //ra and rb 
    
    inst_arr[37]=8'h74;  // Jump if notequal 
    inst_arr[38]=8'h00;          
    inst_arr[39]=8'h00; 
    inst_arr[40]=8'h00; 
    inst_arr[41]=8'h00;
    inst_arr[42]=8'h00;
    inst_arr[43]=8'h00;
    inst_arr[44]=8'h00;
    inst_arr[45]=8'd48; //Jump to 48
    inst_arr[46]=8'h60;
    inst_arr[47]=8'h45;

    inst_arr[48]=8'h32; //irmovq
    inst_arr[49]=8'h00; 
    inst_arr[50]=8'h00; 
    inst_arr[51]=8'h00; 
    inst_arr[52]=8'h00;           
    inst_arr[53]=8'h00;       
    inst_arr[54]=8'h00;           
    inst_arr[55]=8'h00;           
    inst_arr[56]=8'h00;           
    inst_arr[57]=8'd10; //10          



    inst_arr[58]=8'hA0; //pushq
    inst_arr[59]=8'h6F; //ra and F

    inst_arr[60]=8'hB0; //popq
    inst_arr[61]=8'h5F; //ra and F

    inst_arr[62]=8'h00; //halt

//Push and Pop 

    // inst_arr[0]=8'hA0;  //push 
    // inst_arr[1]=8'h5F; 
    // inst_arr[2]=8'hB0;  //pop   
    // inst_arr[3]=8'h3F;             
    // inst_arr[4]=8'h00; //halt 

//Load Hazard

    // inst_arr[0]=8'h50; //mrmovq 
    // inst_arr[1]=8'h23; 
    // inst_arr[2]=8'h00;            
    // inst_arr[3]=8'h00;             
    // inst_arr[4]=8'h00; 
    // inst_arr[5]=8'h00;           
    // inst_arr[6]=8'h00;           
    // inst_arr[7]=8'h00;           
    // inst_arr[8]=8'h00;  
    // inst_arr[9]=8'd01;     

    // inst_arr[10]=8'h60;     //Add
    // inst_arr[11]=8'h42;         
    // inst_arr[12]=8'h00;


//Jump instructions

    // inst_arr[0]=8'h73; //Jump if equal  
    // // inst_arr[0]=8'h74; //Jump if not equal
    // inst_arr[1]=8'h00; 
    // inst_arr[2]=8'h00;            
    // inst_arr[3]=8'h00;             
    // inst_arr[4]=8'h00;           
    // inst_arr[5]=8'h00;           
    // inst_arr[6]=8'h00;           
    // inst_arr[7]=8'h00;           
    // inst_arr[8]=8'd10;          
    // inst_arr[9]=8'h00; 

    // inst_arr[10]=8'h20; 
    // inst_arr[11]=8'h70;        
    // inst_arr[12]=8'h00; 
    // inst_arr[13]=8'h00;
    // inst_arr[14]=8'h00;
    // inst_arr[15]=8'h00;
    // inst_arr[16]=8'h00;
    // inst_arr[17]=8'h00;
    // inst_arr[18]=8'd00; 

//Return
    // inst_arr[0]=8'h80; //call

    // inst_arr[1]=8'h00; 
    // inst_arr[2]=8'h00;            
    // inst_arr[3]=8'h00;             
    // inst_arr[4]=8'h00; 
    // inst_arr[5]=8'h00;           
    // inst_arr[6]=8'h00;           
    // inst_arr[7]=8'h00;           
    // inst_arr[8]=8'd10;

    // inst_arr[9]=8'd00;     

    // inst_arr[10]=8'h90; //ret 
    // inst_arr[11]=8'h00;         
    // inst_arr[12]=8'h00; 
    // inst_arr[13]=8'h00;
    // inst_arr[14]=8'h00;
    // inst_arr[15]=8'h00;
    // inst_arr[16]=8'h00;
    // inst_arr[17]=8'h00;
    // inst_arr[18]=8'd00;

end

endmodule