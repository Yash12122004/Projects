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