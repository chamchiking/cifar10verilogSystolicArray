`timescale 1ns / 1ps

module FIFO_64bit(clk, dataIn, RD, WR, EN, dataOut, Rst, EMPTY, FULL, wt_done, rd_done); 

input  clk, RD, WR, EN, Rst;
output  EMPTY, FULL;
output reg wt_done = 0;
output reg rd_done = 0;
input   [7:0]    dataIn;
output reg [63:0] dataOut; // internal registers 
reg [4:0]  Count = 0; 
reg [7:0] FIFO [0:7]; 
reg [4:0]  readCounter = 0, 
            writeCounter = 0;
assign EMPTY = (Count==0)? 1'b1:1'b0; 
assign FULL = (Count==8)? 1'b1:1'b0; 

always @ (posedge clk) begin 

if (EN==0) begin
    wt_done = 0;
    rd_done = 0;
    end 
 else begin 
  if (Count == 0 && readCounter == 8) begin
     readCounter = 0;
     writeCounter = 0;
  end
  
  
  if (Rst) begin 
   readCounter = 0; 
   writeCounter = 0;
   Count = 0;
  end 
 
  else if (RD ==1'b1 && FULL==1) begin 
   dataOut  = {FIFO[0], FIFO[1], FIFO[2], FIFO[3], FIFO[4], FIFO[5], FIFO[6], FIFO[7]}; 
   readCounter = readCounter+8;
   rd_done = 1;
  end 

  else if (WR==1'b1 && Count<8) begin
   FIFO[writeCounter]  = dataIn; 
   writeCounter  = writeCounter+1; 
   wt_done = 1;
  end 

  else begin
   wt_done = 0;
   rd_done = 0; 
  end 
    
  Count= writeCounter-readCounter; 
 
end
end 

endmodule