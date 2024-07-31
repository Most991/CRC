`timescale 1ns/1ps
////////////////////////////////////////////////////////////////////////////////////////////////
module CRC_TB #(parameter CLK_Period = 100 , Test_cases = 10 , data_width = 8)(); 
////////////////////////////////////////////////////////////////////////////////////////////////
reg            data_tb;
reg            Active_tb;
reg            CLK_tb,RST_tb;
wire           CRC_tb;
wire           Valid_tb;
reg            enable_tb;  
////////////////////////////////////////////////////////////////////////////////////////////////
reg    [data_width-1:0]   Test         [Test_cases-1:0] ;
reg    [data_width-1:0]   Expec_Outs   [Test_cases-1:0] ;
////////////////////////////////////////////////////////////////////////////////////////////////
integer ii;
////////////////////////////////////////////////////////////////////////////////////////////////
always #(CLK_Period/2) CLK_tb = ~CLK_tb;
////////////////////////////////////////////////////////////////////////////////////////////////
initial
begin
 $dumpfile("CRC.vcd") ;       
 $dumpvars; 
 

 $readmemh("DATA_h.txt", Test);
 $readmemh("Expec_Out_h.txt", Expec_Outs);
 
 
 initialize();
 
 for(ii=0;ii<Test_cases;ii=ii+1)
 begin
   test_data(Test[ii]);
   get_out(Expec_Outs[ii],ii);
 end  
 
 #(10*CLK_Period)
 $stop;
end


////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
task initialize;
  begin
    CLK_tb = 1'b0;
    Active_tb = 1'b0;
    data_tb = 1'b0;
  end  
endtask  
////////////////////////////////////////////////////////////////////////////////////////////////
task reset;
 begin
  RST_tb  = 1'b1; 
  #(CLK_Period)
  RST_tb  = 1'b0;
  #(CLK_Period)
  RST_tb  = 1'b1;
 end
endtask
////////////////////////////////////////////////////////////////////////////////////////////////
task test_data;
 input reg [data_width-1:0] data_tst;
 begin
   reset();
    #(CLK_Period) 
    data_tb = data_tst[0];
    #(CLK_Period)
    Active_tb = 1'b1;
    #(CLK_Period)
    data_tb = data_tst[1];
    #(CLK_Period)
    data_tb = data_tst[2];
    #(CLK_Period)
    data_tb = data_tst[3];
    #(CLK_Period)
    data_tb = data_tst[4];
    #(CLK_Period)
    data_tb = data_tst[5];
    #(CLK_Period)
    data_tb = data_tst[6];
    #(CLK_Period)
    data_tb = data_tst[7];
    #(CLK_Period)
    Active_tb = 1'b0;   
 end 
endtask  
////////////////////////////////////////////////////////////////////////////////////////////////
task get_out;
    input [data_width-1:0] out_tst;
    input [4:0] i;
    reg   [data_width-1:0]   CRC_8bits; 
    begin
      enable_tb=1'b1;
      #(CLK_Period)
      CRC_8bits[0] = CRC_tb;
      #(CLK_Period)
      CRC_8bits[1] = CRC_tb;
      #(CLK_Period)
      CRC_8bits[2] = CRC_tb;
      #(CLK_Period)
      CRC_8bits[3] = CRC_tb;
      #(CLK_Period)
      CRC_8bits[4] = CRC_tb;
      #(CLK_Period)
      CRC_8bits[5] = CRC_tb;
      #(CLK_Period)
      CRC_8bits[6] = CRC_tb;
      #(CLK_Period)
      CRC_8bits[7] = CRC_tb;
      #(CLK_Period)
      if(CRC_8bits == out_tst)
        $display ("Test case%d is succeeded and output is %h ",i,CRC_8bits);
      else
        $display ("Test case%d is failed and output is %h ",i,CRC_8bits); 
        
      #(CLK_Period)  
      CRC_8bits = 'b0; 
      enable_tb = 1'b0;	  
    end
endtask    
////////////////////////////////////////////////////////////////////////////////////////////////
CRC DUT(
.data(data_tb),
.Active(Active_tb),
.CLK(CLK_tb),
.RST(RST_tb),
.CRC(CRC_tb),
.Valid(Valid_tb),
.enable(enable_tb)
);

endmodule