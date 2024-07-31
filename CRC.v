module CRC #(parameter SEED = 8'hD8)
(  
input   wire            data,
input   wire            Active,
input   wire            CLK,RST,
output  reg             CRC,
output  reg             Valid,
input   reg             enable
);


wire feedback;
reg [7:0] Reg;
reg [3:0] counter;

assign feedback = Reg[0] ^ data;

 
always @(posedge CLK, negedge RST)
 begin
   if (!RST)
     begin
       Reg <=  SEED;
       counter <= 0;
       Valid <= 1'b0;
     end
   else if (Active)
     begin
       Reg[0] <= Reg[1];
       Reg[1] <= Reg[2];
       Reg[2] <= Reg[3] ^ feedback;
       Reg[3] <= Reg[4];
       Reg[4] <= Reg[5];
       Reg[5] <= Reg[6];
       Reg[6] <= Reg[7] ^ feedback;
       Reg[7] <= feedback;
     end 
   else if (!Active && enable )
     begin
       counter <= counter + 1'b1;
       if (counter <= 4'b1000)
         begin
           {Reg[6:0],CRC} <= Reg ;
           Valid <= 1'b1;
         end
       else
         begin
           Valid <= 1'b0;
           counter <= 1'b0;
         end   
     end  
     
 end   
endmodule 
