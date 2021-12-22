`timescale 1ns / 1ps

module students_top 
#(parameter integer C_S00_AXIS_TDATA_WIDTH = 32)
(
  input wire                     CLK,
  input wire                     RESETN,

  // FC
  // For FC AXI STREAM protocol
  output wire                                     FC_S_AXIS_TREADY,
  input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0]       FC_S_AXIS_TDATA,
  input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0]   FC_S_AXIS_TKEEP,
  input wire                                      FC_S_AXIS_TUSER,
  input wire                                      FC_S_AXIS_TLAST,
  input wire                                      FC_S_AXIS_TVALID,
  input wire                                      FC_M_AXIS_TREADY,
  output wire                                     FC_M_AXIS_TUSER,
  output wire [C_S00_AXIS_TDATA_WIDTH-1 : 0]      FC_M_AXIS_TDATA,
  output wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0]  FC_M_AXIS_TKEEP,
  output wire                                     FC_M_AXIS_TLAST,
  output wire                                     FC_M_AXIS_TVALID,
    
  // For FC APB protocol
  input wire [31:0]                               FC_PADDR,
  input wire                                      FC_PSEL,
  input wire                                      FC_PENABLE,
  input wire                                      FC_PWRITE,
  input wire [31:0]                               FC_PWDATA,
  output wire                                     FC_PSLVERR,
  output wire [31:0]                              FC_PRDATA,
  output wire                                     FC_PREADY,
        
  // CONV
  // For CONV AXI STREAM protocol
  output wire                                     CONV_S_AXIS_TREADY,
  input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0]       CONV_S_AXIS_TDATA,
  input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0]   CONV_S_AXIS_TKEEP,
  input wire                                      CONV_S_AXIS_TUSER,
  input wire                                      CONV_S_AXIS_TLAST,
  input wire                                      CONV_S_AXIS_TVALID,
  input wire                                      CONV_M_AXIS_TREADY,
  output wire                                     CONV_M_AXIS_TUSER,
  output wire [C_S00_AXIS_TDATA_WIDTH-1 : 0]      CONV_M_AXIS_TDATA,
  output wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0]  CONV_M_AXIS_TKEEP,
  output wire                                     CONV_M_AXIS_TLAST,
  output wire                                     CONV_M_AXIS_TVALID,
       
  // For CONV APB protocol
  input wire [31:0]                               CONV_PADDR,
  input wire                                      CONV_PSEL,
  input wire                                      CONV_PENABLE,
  input wire                                      CONV_PWRITE,
  input wire [31:0]                               CONV_PWDATA,
  output wire                                     CONV_PSLVERR,
  output wire                                     CONV_PREADY,
  output wire [31:0]                              CONV_PRDATA,
       
  // POOL
  // For POOL AXI STREAM protocol
  output wire                                     POOL_S_AXIS_TREADY,
  input wire [C_S00_AXIS_TDATA_WIDTH-1:0]         POOL_S_AXIS_TDATA,
  input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1:0]     POOL_S_AXIS_TKEEP,
  input wire                                      POOL_S_AXIS_TUSER,
  input wire                                      POOL_S_AXIS_TLAST,
  input wire                                      POOL_S_AXIS_TVALID,
  input wire                                      POOL_M_AXIS_TREADY,
  output wire                                     POOL_M_AXIS_TUSER,
  output wire [C_S00_AXIS_TDATA_WIDTH-1:0]        POOL_M_AXIS_TDATA,
  output wire [(C_S00_AXIS_TDATA_WIDTH/8)-1:0]    POOL_M_AXIS_TKEEP,
  output wire                                     POOL_M_AXIS_TLAST,
  output wire                                     POOL_M_AXIS_TVALID,
        
  // For POOL APB protocol
  input wire [31:0]                               POOL_PADDR,
  input wire                                      POOL_PSEL,
  input wire                                      POOL_PENABLE,
  input wire                                      POOL_PWRITE,
  input wire [31:0]                               POOL_PWDATA,    
  output wire [31:0]                              POOL_PRDATA,  
  output wire                                     POOL_PREADY,
  output wire                                     POOL_PSLVERR
);

  //-------------------
  // ******* FC *******
  //-------------------
  top_fc
  #(.C_S00_AXIS_TDATA_WIDTH(32)) 
  u_fc_top
  (
  .CLK                    (CLK),
  .RESETN                 (RESETN),

  // AXI-STREAM
  .S_AXIS_TREADY          (FC_S_AXIS_TREADY),
  .S_AXIS_TDATA           (FC_S_AXIS_TDATA),
  .S_AXIS_TKEEP           (FC_S_AXIS_TKEEP),
  .S_AXIS_TUSER           (FC_S_AXIS_TUSER),
  .S_AXIS_TLAST           (FC_S_AXIS_TLAST),
  .S_AXIS_TVALID          (FC_S_AXIS_TVALID),
  .M_AXIS_TREADY          (FC_M_AXIS_TREADY),
  .M_AXIS_TUSER           (FC_M_AXIS_TUSER),
  .M_AXIS_TDATA           (FC_M_AXIS_TDATA),
  .M_AXIS_TKEEP           (FC_M_AXIS_TKEEP),
  .M_AXIS_TLAST           (FC_M_AXIS_TLAST),
  .M_AXIS_TVALID          (FC_M_AXIS_TVALID),
    
  // APB
  .PADDR                  (FC_PADDR),
  .PENABLE                (FC_PENABLE),
  .PSEL                   (FC_PSEL),
  .PWDATA                 (FC_PWDATA),
  .PWRITE                 (FC_PWRITE),
  .PRDATA                 (FC_PRDATA),
  .PREADY                 (FC_PREADY),
  .PSLVERR                (FC_PSLVERR)
  );
    
  //-------------------
  // ******* CONV *******
  //-------------------
  top_conv
  #(.C_S00_AXIS_TDATA_WIDTH(32)) u_conv_top
  (
   .CLK                    (CLK),
  .RESETN                 (RESETN),
  //AXI-STREAM
  .S_AXIS_TREADY          (CONV_S_AXIS_TREADY),
  .S_AXIS_TDATA           (CONV_S_AXIS_TDATA),
  .S_AXIS_TKEEP           (CONV_S_AXIS_TKEEP),
  .S_AXIS_TUSER           (CONV_S_AXIS_TUSER),
  .S_AXIS_TLAST           (CONV_S_AXIS_TLAST),
  .S_AXIS_TVALID          (CONV_S_AXIS_TVALID),
  .M_AXIS_TREADY          (CONV_M_AXIS_TREADY),
  .M_AXIS_TUSER           (CONV_M_AXIS_TUSER),
  .M_AXIS_TDATA           (CONV_M_AXIS_TDATA),
  .M_AXIS_TKEEP           (CONV_M_AXIS_TKEEP),
  .M_AXIS_TLAST           (CONV_M_AXIS_TLAST),
  .M_AXIS_TVALID          (CONV_M_AXIS_TVALID),
  
  //APB
  .PADDR                  (CONV_PADDR),
  .PENABLE                (CONV_PENABLE),
  .PSEL                   (CONV_PSEL),
  .PWDATA                 (CONV_PWDATA),
  .PWRITE                 (CONV_PWRITE),
  .PRDATA                 (CONV_PRDATA),
  .PREADY                 (CONV_PREADY),
  .PSLVERR                (CONV_PSLVERR)
  );
 
  //-----------------------------
  // ******* Pool *******
  //-----------------------------
  top_pool
  #(.C_S00_AXIS_TDATA_WIDTH(32)) u_top_pool
  (
  .CLK                    (CLK),
  .RESETN                 (RESETN),
  //AXI-STREAM
  .S_AXIS_TREADY          (POOL_S_AXIS_TREADY),
  .S_AXIS_TDATA           (POOL_S_AXIS_TDATA),
  .S_AXIS_TKEEP           (POOL_S_AXIS_TKEEP),
  .S_AXIS_TUSER           (POOL_S_AXIS_TUSER),
  .S_AXIS_TLAST           (POOL_S_AXIS_TLAST),
  .S_AXIS_TVALID          (POOL_S_AXIS_TVALID),
  .M_AXIS_TREADY          (POOL_M_AXIS_TREADY),
  .M_AXIS_TUSER           (POOL_M_AXIS_TUSER),
  .M_AXIS_TDATA           (POOL_M_AXIS_TDATA),
  .M_AXIS_TKEEP           (POOL_M_AXIS_TKEEP),
  .M_AXIS_TLAST           (POOL_M_AXIS_TLAST),
  .M_AXIS_TVALID          (POOL_M_AXIS_TVALID),
  
  //APB
  .PADDR                  (POOL_PADDR),
  .PENABLE                (POOL_PENABLE),
  .PSEL                   (POOL_PSEL),
  .PWDATA                 (POOL_PWDATA),
  .PWRITE                 (POOL_PWRITE),
  .PRDATA                 (POOL_PRDATA),
  .PREADY                 (POOL_PREADY),
  .PSLVERR                (POOL_PSLVERR)
  );
endmodule
