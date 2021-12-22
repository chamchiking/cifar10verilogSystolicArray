module total_top(
  input clk,
  input rstn,

  // uart
  input  uart_rx,
  output uart_tx,

  // ddr3 interface
  output [13:0] ddr3_addr,
  output [2:0]  ddr3_ba,
  output        ddr3_cas_n,
  output [0:0]  ddr3_ck_n,
  output [0:0]  ddr3_ck_p,
  output [0:0]  ddr3_cke,
  output [0:0]  ddr3_cs_n,
  output [1:0]  ddr3_dm,
  inout [15:0]  ddr3_dq,
  inout  [1:0]  ddr3_dqs_n,
  inout  [1:0]  ddr3_dqs_p,
  output [0:0]  ddr3_odt,
  output        ddr3_ras_n,
  output        ddr3_reset_n,
  output        ddr3_we_n,
  output        init_calib_complete
);

  wire          m00_axi_aclk;
  wire          rstn_int2;

  // apb
  wire [31:0]   fc_apb_paddr;
  wire [0:0]    fc_apb_psel;
  wire          fc_apb_penable;
  wire          fc_apb_pwrite;
  wire [31:0]   fc_apb_pwdata;
  wire [0:0]    fc_apb_pready;
  wire [31:0]   fc_apb_prdata;
  wire [0:0]    fc_apb_pslverr;

  wire [31:0]   conv_apb_paddr;
  wire [0:0]    conv_apb_psel;
  wire          conv_apb_penable;
  wire          conv_apb_pwrite;
  wire [31:0]   conv_apb_pwdata;
  wire [0:0]    conv_apb_pready;
  wire [31:0]   conv_apb_prdata;
  wire [0:0]    conv_apb_pslverr;

  wire [31:0]   pool_apb_paddr;
  wire [0:0]    pool_apb_psel;
  wire          pool_apb_penable;
  wire          pool_apb_pwrite;
  wire [31:0]   pool_apb_pwdata;
  wire [0:0]    pool_apb_pready;
  wire [31:0]   pool_apb_prdata;
  wire [0:0]    pool_apb_pslverr;

  wire [31:0]   vdma0_m_axis_mm2s_tdata;   // 32 bits
  wire [3:0]    vdma0_m_axis_mm2s_tkeep;   // 4 bits
  wire          vdma0_m_axis_mm2s_tuser;
  wire          vdma0_m_axis_mm2s_tvalid;
  wire          vdma0_m_axis_mm2s_tready;
  wire          vdma0_m_axis_mm2s_tlast;

  wire [31:0]   vdma0_s_axis_s2mm_tdata;   // 32 bits
  wire [3:0]    vdma0_s_axis_s2mm_tkeep;   // 4 bits
  wire          vdma0_s_axis_s2mm_tuser;
  wire          vdma0_s_axis_s2mm_tvalid;
  wire          vdma0_s_axis_s2mm_tready;
  wire          vdma0_s_axis_s2mm_tlast;

  wire [31:0]   vdma1_m_axis_mm2s_tdata;   //32bit
  wire [3:0]    vdma1_m_axis_mm2s_tkeep;   //4bit
  wire          vdma1_m_axis_mm2s_tuser;
  wire          vdma1_m_axis_mm2s_tvalid;
  wire          vdma1_m_axis_mm2s_tready;
  wire          vdma1_m_axis_mm2s_tlast;

  wire [31:0]   vdma1_s_axis_s2mm_tdata;   //32bit
  wire [3:0]    vdma1_s_axis_s2mm_tkeep;   //4bit
  wire          vdma1_s_axis_s2mm_tuser;
  wire          vdma1_s_axis_s2mm_tvalid;
  wire          vdma1_s_axis_s2mm_tready;
  wire          vdma1_s_axis_s2mm_tlast;


  wire [31:0]   vdma2_m_axis_mm2s_tdata;   //32bit
  wire [3:0]    vdma2_m_axis_mm2s_tkeep;   //4bit
  wire          vdma2_m_axis_mm2s_tuser;
  wire          vdma2_m_axis_mm2s_tvalid;
  wire          vdma2_m_axis_mm2s_tready;
  wire          vdma2_m_axis_mm2s_tlast;

  wire [31:0]   vdma2_s_axis_s2mm_tdata;   //32bit
  wire [3:0]    vdma2_s_axis_s2mm_tkeep;   //4bit
  wire          vdma2_s_axis_s2mm_tuser;
  wire          vdma2_s_axis_s2mm_tvalid;
  wire          vdma2_s_axis_s2mm_tready;
  wire          vdma2_s_axis_s2mm_tlast;

  ////////////////////////////////////////////////////////////
  dsd_example_top
  #(.C_S00_AXIS_TDATA_WIDTH(32)) u_dsd_example_top
  (
    .clk(clk),
    .rstn(rstn),
    
    // uart
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    
    // ddr interface
    .ddr3_addr(ddr3_addr),
    .ddr3_ba(ddr3_ba),
    .ddr3_cas_n(ddr3_cas_n),
    .ddr3_ck_n(ddr3_ck_n),
    .ddr3_ck_p(ddr3_ck_p),
    .ddr3_cke(ddr3_cke),
    .ddr3_cs_n(ddr3_cs_n),
    .ddr3_dm(ddr3_dm),
    .ddr3_dq(ddr3_dq),
    .ddr3_dqs_n(ddr3_dqs_n),
    .ddr3_dqs_p(ddr3_dqs_p),
    .ddr3_odt(ddr3_odt),
    .ddr3_ras_n(ddr3_ras_n),
    .ddr3_reset_n(ddr3_reset_n),
    .ddr3_we_n(ddr3_we_n),
    .init_calib_complete(init_calib_complete), 
    
    // vdma axis port
    .m00_axi_aclk(m00_axi_aclk),
    .rstn_int2(rstn_int2),
    
    .vdma0_m_axis_mm2s_tdata(vdma0_m_axis_mm2s_tdata),    
    .vdma0_m_axis_mm2s_tkeep(vdma0_m_axis_mm2s_tkeep), 
    .vdma0_m_axis_mm2s_tuser(vdma0_m_axis_mm2s_tuser),
    .vdma0_m_axis_mm2s_tvalid(vdma0_m_axis_mm2s_tvalid),
    .vdma0_m_axis_mm2s_tready(vdma0_m_axis_mm2s_tready),
    .vdma0_m_axis_mm2s_tlast(vdma0_m_axis_mm2s_tlast),
    
    .vdma0_s_axis_s2mm_tdata(vdma0_s_axis_s2mm_tdata),  
    .vdma0_s_axis_s2mm_tkeep(vdma0_s_axis_s2mm_tkeep),   
    .vdma0_s_axis_s2mm_tuser(vdma0_s_axis_s2mm_tuser),
    .vdma0_s_axis_s2mm_tvalid(vdma0_s_axis_s2mm_tvalid),
    .vdma0_s_axis_s2mm_tready(vdma0_s_axis_s2mm_tready),
    .vdma0_s_axis_s2mm_tlast(vdma0_s_axis_s2mm_tlast),
    
    .vdma1_m_axis_mm2s_tdata(vdma1_m_axis_mm2s_tdata),   
    .vdma1_m_axis_mm2s_tkeep(vdma1_m_axis_mm2s_tkeep),   
    .vdma1_m_axis_mm2s_tuser(vdma1_m_axis_mm2s_tuser),
    .vdma1_m_axis_mm2s_tvalid(vdma1_m_axis_mm2s_tvalid),
    .vdma1_m_axis_mm2s_tready(vdma1_m_axis_mm2s_tready),
    .vdma1_m_axis_mm2s_tlast(vdma1_m_axis_mm2s_tlast),
    
    .vdma1_s_axis_s2mm_tdata(vdma1_s_axis_s2mm_tdata),   
    .vdma1_s_axis_s2mm_tkeep(vdma1_s_axis_s2mm_tkeep),   
    .vdma1_s_axis_s2mm_tuser(vdma1_s_axis_s2mm_tuser),
    .vdma1_s_axis_s2mm_tvalid(vdma1_s_axis_s2mm_tvalid),
    .vdma1_s_axis_s2mm_tready(vdma1_s_axis_s2mm_tready),
    .vdma1_s_axis_s2mm_tlast(vdma1_s_axis_s2mm_tlast),
    
    
    .vdma2_m_axis_mm2s_tdata(vdma2_m_axis_mm2s_tdata),   
    .vdma2_m_axis_mm2s_tkeep(vdma2_m_axis_mm2s_tkeep),   
    .vdma2_m_axis_mm2s_tuser(vdma2_m_axis_mm2s_tuser),
    .vdma2_m_axis_mm2s_tvalid(vdma2_m_axis_mm2s_tvalid),
    .vdma2_m_axis_mm2s_tready(vdma2_m_axis_mm2s_tready),
    .vdma2_m_axis_mm2s_tlast(vdma2_m_axis_mm2s_tlast),
    
    .vdma2_s_axis_s2mm_tdata(vdma2_s_axis_s2mm_tdata),   
    .vdma2_s_axis_s2mm_tkeep(vdma2_s_axis_s2mm_tkeep),   
    .vdma2_s_axis_s2mm_tuser(vdma2_s_axis_s2mm_tuser),
    .vdma2_s_axis_s2mm_tvalid(vdma2_s_axis_s2mm_tvalid),
    .vdma2_s_axis_s2mm_tready(vdma2_s_axis_s2mm_tready),
    .vdma2_s_axis_s2mm_tlast(vdma2_s_axis_s2mm_tlast),
    
    // apb
    .fc_apb_paddr(fc_apb_paddr),
    .fc_apb_psel(fc_apb_psel),
    .fc_apb_penable(fc_apb_penable),
    .fc_apb_pwrite(fc_apb_pwrite),
    .fc_apb_pwdata(fc_apb_pwdata),
    .fc_apb_pready(fc_apb_pready),
    .fc_apb_prdata(fc_apb_prdata),
    .fc_apb_pslverr(fc_apb_pslverr),
    
    .conv_apb_paddr(conv_apb_paddr),
    .conv_apb_psel(conv_apb_psel),
    .conv_apb_penable(conv_apb_penable),
    .conv_apb_pwrite(conv_apb_pwrite),
    .conv_apb_pwdata(conv_apb_pwdata),
    .conv_apb_pready(conv_apb_pready),
    .conv_apb_prdata(conv_apb_prdata),
    .conv_apb_pslverr(conv_apb_pslverr),
    
    .pool_apb_paddr(pool_apb_paddr),
    .pool_apb_psel(pool_apb_psel),
    .pool_apb_penable(pool_apb_penable),
    .pool_apb_pwrite(pool_apb_pwrite),
    .pool_apb_pwdata(pool_apb_pwdata),
    .pool_apb_pready(pool_apb_pready),
    .pool_apb_prdata(pool_apb_prdata),
    .pool_apb_pslverr(pool_apb_pslverr)
  );
  ////////////////////////////////////////////////////////////
   

  students_top
  #(.C_S00_AXIS_TDATA_WIDTH(32)) u_students_top
  (
    .CLK                    (m00_axi_aclk),
    .RESETN                 (rstn_int2),
 
    // FC
    .FC_S_AXIS_TREADY          (vdma0_m_axis_mm2s_tready), // output
    .FC_S_AXIS_TDATA           (vdma0_m_axis_mm2s_tdata),
    .FC_S_AXIS_TKEEP           (vdma0_m_axis_mm2s_tkeep),
    .FC_S_AXIS_TUSER           (vdma0_m_axis_mm2s_tuser),
    .FC_S_AXIS_TLAST           (vdma0_m_axis_mm2s_tlast),
    .FC_S_AXIS_TVALID          (vdma0_m_axis_mm2s_tvalid),
    .FC_M_AXIS_TREADY          (vdma0_s_axis_s2mm_tready), // input
    .FC_M_AXIS_TUSER           (vdma0_s_axis_s2mm_tuser),
    .FC_M_AXIS_TDATA           (vdma0_s_axis_s2mm_tdata),
    .FC_M_AXIS_TKEEP           (vdma0_s_axis_s2mm_tkeep),
    .FC_M_AXIS_TLAST           (vdma0_s_axis_s2mm_tlast),
    .FC_M_AXIS_TVALID          (vdma0_s_axis_s2mm_tvalid),

    .FC_PADDR                  (fc_apb_paddr),
    .FC_PENABLE                (fc_apb_penable),
    .FC_PSEL                   (fc_apb_psel),
    .FC_PWDATA                 (fc_apb_pwdata),
    .FC_PWRITE                 (fc_apb_pwrite),
    .FC_PRDATA                 (fc_apb_prdata),
    .FC_PREADY                 (fc_apb_pready),
    .FC_PSLVERR                (fc_apb_pslverr),

    // CONV
    .CONV_S_AXIS_TREADY          (vdma1_m_axis_mm2s_tready),
    .CONV_S_AXIS_TDATA           (vdma1_m_axis_mm2s_tdata),
    .CONV_S_AXIS_TKEEP           (vdma1_m_axis_mm2s_tkeep),
    .CONV_S_AXIS_TUSER           (vdma1_m_axis_mm2s_tuser),
    .CONV_S_AXIS_TLAST           (vdma1_m_axis_mm2s_tlast),
    .CONV_S_AXIS_TVALID          (vdma1_m_axis_mm2s_tvalid),
    .CONV_M_AXIS_TREADY          (vdma1_s_axis_s2mm_tready),
    .CONV_M_AXIS_TUSER           (vdma1_s_axis_s2mm_tuser),
    .CONV_M_AXIS_TDATA           (vdma1_s_axis_s2mm_tdata),
    .CONV_M_AXIS_TKEEP           (vdma1_s_axis_s2mm_tkeep),
    .CONV_M_AXIS_TLAST           (vdma1_s_axis_s2mm_tlast),
    .CONV_M_AXIS_TVALID          (vdma1_s_axis_s2mm_tvalid),

    .CONV_PADDR                  (conv_apb_paddr),
    .CONV_PENABLE                (conv_apb_penable),
    .CONV_PSEL                   (conv_apb_psel),
    .CONV_PWDATA                 (conv_apb_pwdata),
    .CONV_PWRITE                 (conv_apb_pwrite),
    .CONV_PRDATA                 (conv_apb_prdata),
    .CONV_PREADY                 (conv_apb_pready),
    .CONV_PSLVERR                (conv_apb_pslverr),
 
    // POOL
    .POOL_S_AXIS_TREADY          (vdma2_m_axis_mm2s_tready),
    .POOL_S_AXIS_TDATA           (vdma2_m_axis_mm2s_tdata),
    .POOL_S_AXIS_TKEEP           (vdma2_m_axis_mm2s_tkeep),
    .POOL_S_AXIS_TUSER           (vdma2_m_axis_mm2s_tuser),
    .POOL_S_AXIS_TLAST           (vdma2_m_axis_mm2s_tlast),
    .POOL_S_AXIS_TVALID          (vdma2_m_axis_mm2s_tvalid),
    .POOL_M_AXIS_TREADY          (vdma2_s_axis_s2mm_tready),
    .POOL_M_AXIS_TUSER           (vdma2_s_axis_s2mm_tuser),
    .POOL_M_AXIS_TDATA           (vdma2_s_axis_s2mm_tdata),
    .POOL_M_AXIS_TKEEP           (vdma2_s_axis_s2mm_tkeep),
    .POOL_M_AXIS_TLAST           (vdma2_s_axis_s2mm_tlast),
    .POOL_M_AXIS_TVALID          (vdma2_s_axis_s2mm_tvalid),

    .POOL_PADDR                  (pool_apb_paddr),
    .POOL_PENABLE                (pool_apb_penable),
    .POOL_PSEL                   (pool_apb_psel),
    .POOL_PWDATA                 (pool_apb_pwdata),
    .POOL_PWRITE                 (pool_apb_pwrite),
    .POOL_PRDATA                 (pool_apb_prdata),
    .POOL_PREADY                 (pool_apb_pready),
    .POOL_PSLVERR                (pool_apb_pslverr)
  );
endmodule
