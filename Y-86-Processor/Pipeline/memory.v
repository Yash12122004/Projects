module memory (clk,M_stat,M_cnd,M_dstE,M_dstM,W_stat,W_icode,W_valE,W_valM,W_dstE,W_dstM,m_stat,M_icode,M_valA,m_valM,M_valE,M_valP);

    input clk,M_cnd;                          //clock
    input [3:0] M_icode,M_dstE,M_dstM;                  //instruction code 
    input [63:0] M_valP,M_valA,M_valE;   //constant, next PC, value A, value B, value E
    input [0:3] M_stat;

    reg [63:0] memo_arr[0:1023];     //temporary memory for storing and assigning values

    // output regm memo_arr;                   //memory array
    
    reg mem_err;                        //memory error
    
    output reg [63:0] m_valM,W_valE,W_valM;             //value M 
    output reg [0:3] W_stat,m_stat;
    output reg [3:0] W_icode,W_dstE,W_dstM;

    // output reg [63:0] memory;     //memory 

    
    initial 
        begin
            mem_err=0;
            m_valM=64'b0;   
            for(integer i=0;i<1024;i=i+1)
            begin
                memo_arr[i]=i; 
            end
        end
    always @(*) 
        begin
            if(M_icode==4'h4)             //rmmovq 
                begin
                    if(M_valE>1023)
                    begin
                        mem_err=1;     //memory error
                    end 
                    else 
                    begin
                        memo_arr[M_valE]=M_valA;    //store value A in memory       
                        m_valM=M_valA; 
                        mem_err=0;
                    end
                end 
            else if(M_icode==4'h5)        //mrmovq
                begin
                    if(M_valE>1023)
                    begin
                        mem_err=1;     //memory error
                    end
                    else 
                    begin
                        m_valM=memo_arr[M_valE];    //load value E from memory
                        mem_err=0;                    
                    end
                end
            else if(M_icode==4'h8)        //call
                begin 
                    if(M_valE>1023)
                    begin
                        mem_err=1;     //memory error
                    end
                    else 
                    begin
                        memo_arr[M_valE]=M_valP;    //store next PC in memory
                        m_valM=M_valP;              
                        mem_err=0;
                    end
                end
            else if(M_icode==4'h9)        //ret
                begin
                    if(M_valA>1023)
                    begin
                        mem_err=1;     //memory error
                    end
                    else
                    begin
                        m_valM=memo_arr[M_valA];    //load value E from memory
                        mem_err=0;
                    end
                end
            else if(M_icode==4'hA)        //pushq
                begin
                    if(M_valE>1023)
                    begin
                        mem_err=1;     //memory error
                    end
                    else 
                    begin
                        memo_arr[M_valE]=M_valA;    //store value A in memory       
                        m_valM=memo_arr[M_valE];
                        mem_err=0;
                    end
                end
            else if(M_icode==4'hB)        //popq
                begin
                    if(M_valA>1023)
                    begin
                        mem_err=1;     //memory error
                    end
                    else
                    begin
                        m_valM=memo_arr[M_valA];    //load value E from memory
                        mem_err=0;
                    end
                end
            else 
                begin
                    mem_err=0;
    // do nothing 
                end 
        end
    always @(*)
        begin
            if(mem_err)
            begin
                m_stat=4'b0010;
            end
            else 
            begin
                m_stat=M_stat;
            end
        end
    
    always@(posedge clk)
        begin               //as writeback will always be normal
            W_stat <= m_stat;
            W_icode <= M_icode;
            W_valE <= M_valE;
            W_valM <= m_valM;
            W_dstE <= M_dstE;
            W_dstM <= M_dstM;
        end
endmodule