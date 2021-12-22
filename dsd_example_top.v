module dsd_example_top
#(parameter integer C_S00_AXIS_TDATA_WIDTH = 32)
(
  // system
  input       clk,
  input       rstn,

  // uart
  input       uart_rx,
  output      uart_tx,

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
  output        init_calib_complete,
  
  // vdma axis port
  output          m00_axi_aclk,
  output reg      rstn_int2,
  
  output [31:0]   vdma0_m_axis_mm2s_tdata, 
  output [3:0]    vdma0_m_axis_mm2s_tkeep,
  output          vdma0_m_axis_mm2s_tuser,
  output          vdma0_m_axis_mm2s_tvalid,
  input           vdma0_m_axis_mm2s_tready,
  output          vdma0_m_axis_mm2s_tlast,

  input [31:0]    vdma0_s_axis_s2mm_tdata,
  input [3:0]     vdma0_s_axis_s2mm_tkeep, 
  input           vdma0_s_axis_s2mm_tuser,
  input           vdma0_s_axis_s2mm_tvalid,
  output          vdma0_s_axis_s2mm_tready,
  input           vdma0_s_axis_s2mm_tlast,

  output [31:0]   vdma1_m_axis_mm2s_tdata,
  output [3:0]    vdma1_m_axis_mm2s_tkeep,
  output          vdma1_m_axis_mm2s_tuser,
  output          vdma1_m_axis_mm2s_tvalid,
  input           vdma1_m_axis_mm2s_tready,
  output          vdma1_m_axis_mm2s_tlast,

  input [31:0]    vdma1_s_axis_s2mm_tdata,
  input [3:0]     vdma1_s_axis_s2mm_tkeep,
  input           vdma1_s_axis_s2mm_tuser,
  input           vdma1_s_axis_s2mm_tvalid,
  output          vdma1_s_axis_s2mm_tready,
  input           vdma1_s_axis_s2mm_tlast,

  output [31:0]   vdma2_m_axis_mm2s_tdata,
  output [3:0]    vdma2_m_axis_mm2s_tkeep,
  output          vdma2_m_axis_mm2s_tuser,
  output          vdma2_m_axis_mm2s_tvalid,
  input           vdma2_m_axis_mm2s_tready,
  output          vdma2_m_axis_mm2s_tlast,

  input [31:0]    vdma2_s_axis_s2mm_tdata,
  input [3:0]     vdma2_s_axis_s2mm_tkeep,
  input           vdma2_s_axis_s2mm_tuser,
  input           vdma2_s_axis_s2mm_tvalid,
  output          vdma2_s_axis_s2mm_tready,
  input           vdma2_s_axis_s2mm_tlast,
  
  // apb
  output [31:0]  fc_apb_paddr,
  output [0:0]   fc_apb_psel,
  output         fc_apb_penable,
  output         fc_apb_pwrite,
  output [31:0]  fc_apb_pwdata,
  input  [0:0]   fc_apb_pready,
  input  [31:0]  fc_apb_prdata,
  input  [0:0]   fc_apb_pslverr,

  output [31:0]  conv_apb_paddr,
  output [0:0]   conv_apb_psel,
  output         conv_apb_penable,
  output         conv_apb_pwrite,
  output [31:0]  conv_apb_pwdata,
  input  [0:0]   conv_apb_pready,
  input  [31:0]  conv_apb_prdata,
  input  [0:0]   conv_apb_pslverr,

  output [31:0]  pool_apb_paddr,
  output [0:0]   pool_apb_psel,
  output         pool_apb_penable,
  output         pool_apb_pwrite,
  output [31:0]  pool_apb_pwdata,
  input  [0:0]   pool_apb_pready,
  input  [31:0]  pool_apb_prdata,
  input  [0:0]   pool_apb_pslverr
);

  wire          system_start;
  wire          write_end;

  // clocks from clock generator
  wire          sys_clk_i;              // 333MHz
  wire          clk_ref_i;              // 200MHz
  wire          sys_clk;                // 100MHz

  //  Controller module pins
  wire          Start_inference;
  wire          End_inference;
  wire          CONV_rundone;
  wire          POOL_rundone;
  wire          F_writedone;
  wire          W_writedone;
  wire          B_writedone;
  wire          FC_rundone;
  wire [2:0]    FC_cmd;
  wire [20:0]   FC_datasize;

  // mig pins
  wire          app_ref_ack;
  wire          app_sr_active;
  wire          app_zq_ack;
  wire          mmcm_locked;
  wire          ui_clk;
  wire          ui_clk_sync_rst;

// Controller's AXI-LITE ports
  wire          s_axi_lite_awvalid;
  wire          s_axi_lite_awready;
  wire [8:0]    s_axi_lite_awaddr;   // 9bit
  wire          s_axi_lite_wvalid;
  wire          s_axi_lite_wready;
  wire [3:0]    s_axi_lite_wdata;    //4bit
  wire [1:0]    s_axi_lite_bresp;    //2bit
  wire          s_axi_lite_bvalid;
  wire          s_axi_lite_bready;
  wire          s_axi_lite_arvalid;
  wire          s_axi_lite_arready;
  wire [8:0]    s_axi_lite_araddr;   //9bit
  wire          s_axi_lite_rvalid;
  wire          s_axi_lite_rready;
  wire          s_axi_lite_rdata;    //32bit
  wire          s_axi_lite_rresp;    //2bit

  // VDMA 1's AXI4-full master
  wire [31:0]   m_axi_s2mm_awaddr;   //32bit
  wire [7:0]    m_axi_s2mm_awlen;    //8bit
  wire [2:0]    m_axi_s2mm_awsize;   //3bit
  wire [1:0]    m_axi_s2mm_awburst;  //2bit
  wire [2:0]    m_axi_s2mm_awprot;   //3bit
  wire [3:0]    m_axi_s2mm_awcache;  //4bit
  wire          m_axi_s2mm_awvalid;
  wire          m_axi_s2mm_awready;
  wire [63:0]   m_axi_s2mm_wdata;    //64bit
  wire [7:0]    m_axi_s2mm_wstrb;    //8bit
  wire          m_axi_s2mm_wlast;
  wire          m_axi_s2mm_wvalid;
  wire          m_axi_s2mm_wready;
  wire [1:0]    m_axi_s2mm_bresp;    //2bit
  wire          m_axi_s2mm_bvalid;
  wire          m_axi_s2mm_bready;
  wire [31:0]   m_axi_mm2s_araddr;   //32bit
  wire [7:0]    m_axi_mm2s_arlen;    //8bit
  wire [2:0]    m_axi_mm2s_arsize;   //3bit
  wire [1:0]    m_axi_mm2s_arburst;  //2bit
  wire [2:0]    m_axi_mm2s_arprot;   //3bit
  wire [3:0]    m_axi_mm2s_arcache;  //4bit
  wire          m_axi_mm2s_arvalid;
  wire          m_axi_mm2s_arready;
  wire [63:0]   m_axi_mm2s_rdata;    //64bit
  wire [1:0]    m_axi_mm2s_rresp;    //2bit
  wire          m_axi_mm2s_rlast;
  wire          m_axi_mm2s_rvalid;
  wire          m_axi_mm2s_rready;

  // memory's AXI4-full slave
  //  write address channel
  wire [3:0]    s_axi_awid;
  wire [31:0]   s_axi_awaddr;
  wire [7:0]    s_axi_awlen;
  wire [2:0]    s_axi_awsize;
  wire [1:0]    s_axi_awburst;
  wire [0:0]    s_axi_awlock;
  wire [3:0]    s_axi_awcache;
  wire [2:0]    s_axi_awprot;
  wire [3:0]    s_axi_awqos;
  wire          s_axi_awvalid;
  wire          s_axi_awready;
  //  write data channel
  wire [127:0]  s_axi_wdata;
  wire [15:0]   s_axi_wstrb;
  wire          s_axi_wlast;
  wire          s_axi_wvalid;
  wire          s_axi_wready;
  //  write response channel
  wire [3:0]    s_axi_bid;
  wire [1:0]    s_axi_bresp;
  wire          s_axi_bvalid;
  wire          s_axi_bready;
  //  read address channel
  wire [3:0]    s_axi_arid;
  wire [31:0]   s_axi_araddr;
  wire [7:0]    s_axi_arlen;
  wire [2:0]    s_axi_arsize;
  wire [1:0]    s_axi_arburst;
  wire [0:0]    s_axi_arlock;
  wire [3:0]    s_axi_arcache;
  wire [2:0]    s_axi_arprot;
  wire [3:0]    s_axi_arqos;
  wire          s_axi_arvalid;
  wire          s_axi_arready;
  //  read data channel
  wire [3:0]    s_axi_rid;
  wire [127:0]  s_axi_rdata;
  wire [1:0]    s_axi_rresp;
  wire          s_axi_rlast;
  wire          s_axi_rvalid;
  wire          s_axi_rready;

//    wire          m00_axi_aclk;
  wire          m01_axi_aclk;
  wire          m01_axi_aresetn;
  wire          s_axi_aresetn;

  // reg
  //reg           m00_axi_wlast = 0;


 // clock and reset
 wire aclk;    //master clk
 wire aresetn; //master reset
 wire aclk_core; //1:1 sync to aclk
 wire aclk_dram; //async to aclk
 wire aresetn_s00_out;
 wire aresetn_s01_out;
 wire aresetn_s02_out;
 wire aresetn_s03_out;
 wire aresetn_m00_out;


 // all ports of axi_crossbar_0 except clock and reset
 wire [31:0]  host_axi_awaddr;
 wire [7:0]   host_axi_awlen;
 wire [2:0]   host_axi_awsize;
 wire [1:0]   host_axi_awburst;
 wire [0:0]   host_axi_awlock;
 wire [3:0]   host_axi_awcache;
 wire [2:0]   host_axi_awprot;
 wire [3:0]   host_axi_awqos;
 wire [0:0]   host_axi_awvalid;
 wire [0:0]   host_axi_awready;
 wire [31:0]  host_axi_wdata;
 wire [3:0]   host_axi_wstrb;
 wire [0:0]   host_axi_wlast;
 wire [0:0]   host_axi_wvalid;
 wire [0:0]   host_axi_wready;
 wire [1:0]   host_axi_bresp;
 wire [0:0]   host_axi_bvalid;
 wire [0:0]   host_axi_bready;
 wire [31:0]  host_axi_araddr;
 wire [7:0]   host_axi_arlen;
 wire [2:0]   host_axi_arsize;
 wire [1:0]   host_axi_arburst;
 wire [0:0]   host_axi_arlock;
 wire [3:0]   host_axi_arcache;
 wire [2:0]   host_axi_arprot;
 wire [3:0]   host_axi_arqos;
 wire [0:0]   host_axi_arvalid;
 wire [0:0]   host_axi_arready;
 wire [31:0]  host_axi_rdata;
 wire [1:0]   host_axi_rresp;
 wire [0:0]   host_axi_rlast;
 wire [0:0]   host_axi_rvalid;
 wire [0:0]   host_axi_rready;
 //VDMA0
 wire [0:0]   VDMA0_AXI_AWID;
 wire [31:0]  VDMA0_AXI_AWADDR;
 wire [7:0]   VDMA0_AXI_AWLEN;
 wire [2:0]   VDMA0_AXI_AWSIZE;
 wire [1:0]   VDMA0_AXI_AWBURST;
 wire         VDMA0_AXI_AWLOCK;
 wire [3:0]   VDMA0_AXI_AWCACHE;
 wire [2:0]   VDMA0_AXI_AWPROT;
 wire [3:0]   VDMA0_AXI_AWQOS;
 wire         VDMA0_AXI_AWVALID;
 wire         VDMA0_AXI_AWREADY;
 wire [63:0]  VDMA0_AXI_WDATA;
 wire [7:0]   VDMA0_AXI_WSTRB;
 wire         VDMA0_AXI_WLAST;
 wire         VDMA0_AXI_WVALID;
 wire         VDMA0_AXI_WREADY;
 wire [0:0]   VDMA0_AXI_BID;
 wire [1:0]   VDMA0_AXI_BRESP;
 wire         VDMA0_AXI_BVALID;
 wire         VDMA0_AXI_BREADY;
 wire [0:0]   VDMA0_AXI_ARID;
 wire [31:0]  VDMA0_AXI_ARADDR;
 wire [7:0]   VDMA0_AXI_ARLEN;
 wire [2:0]   VDMA0_AXI_ARSIZE;
 wire [1:0]   VDMA0_AXI_ARBURST;
 wire         VDMA0_AXI_ARLOCK;
 wire [3:0]   VDMA0_AXI_ARCACHE;
 wire [2:0]   VDMA0_AXI_ARPROT;
 wire [3:0]   VDMA0_AXI_ARQOS;
 wire         VDMA0_AXI_ARVALID;
 wire         VDMA0_AXI_ARREADY;
 wire [0:0]   VDMA0_AXI_RID;
 wire [63:0]  VDMA0_AXI_RDATA;
 wire [1:0]   VDMA0_AXI_RRESP;
 wire         VDMA0_AXI_RLAST;
 wire         VDMA0_AXI_RVALID;
 wire         VDMA0_AXI_RREADY;
 //VDMA1
 wire [0:0]   VDMA1_AXI_AWID;
 wire [31:0]  VDMA1_AXI_AWADDR;
 wire [7:0]   VDMA1_AXI_AWLEN;
 wire [2:0]   VDMA1_AXI_AWSIZE;
 wire [1:0]   VDMA1_AXI_AWBURST;
 wire         VDMA1_AXI_AWLOCK;
 wire [3:0]   VDMA1_AXI_AWCACHE;
 wire [2:0]   VDMA1_AXI_AWPROT;
 wire [3:0]   VDMA1_AXI_AWQOS;
 wire         VDMA1_AXI_AWVALID;
 wire         VDMA1_AXI_AWREADY;
 wire [63:0]  VDMA1_AXI_WDATA;
 wire [7:0]   VDMA1_AXI_WSTRB;
 wire         VDMA1_AXI_WLAST;
 wire         VDMA1_AXI_WVALID;
 wire         VDMA1_AXI_WREADY;
 wire [0:0]   VDMA1_AXI_BID;
 wire [1:0]   VDMA1_AXI_BRESP;
 wire         VDMA1_AXI_BVALID;
 wire         VDMA1_AXI_BREADY;
 wire [0:0]   VDMA1_AXI_ARID;
 wire [31:0]  VDMA1_AXI_ARADDR;
 wire [7:0]   VDMA1_AXI_ARLEN;
 wire [2:0]   VDMA1_AXI_ARSIZE;
 wire [1:0]   VDMA1_AXI_ARBURST;
 wire         VDMA1_AXI_ARLOCK;
 wire [3:0]   VDMA1_AXI_ARCACHE;
 wire [2:0]   VDMA1_AXI_ARPROT;
 wire [3:0]   VDMA1_AXI_ARQOS;
 wire         VDMA1_AXI_ARVALID;
 wire         VDMA1_AXI_ARREADY;
 wire [0:0]   VDMA1_AXI_RID;
 wire [63:0]  VDMA1_AXI_RDATA;
 wire [1:0]   VDMA1_AXI_RRESP;
 wire         VDMA1_AXI_RLAST;
 wire         VDMA1_AXI_RVALID;
 wire         VDMA1_AXI_RREADY;
 // VDMA2
 wire [0:0]   VDMA2_AXI_AWID;
 wire [31:0]  VDMA2_AXI_AWADDR;
 wire [7:0]   VDMA2_AXI_AWLEN;
 wire [2:0]   VDMA2_AXI_AWSIZE;
 wire [1:0]   VDMA2_AXI_AWBURST;
 wire         VDMA2_AXI_AWLOCK;
 wire [3:0]   VDMA2_AXI_AWCACHE;
 wire [2:0]   VDMA2_AXI_AWPROT;
 wire [3:0]   VDMA2_AXI_AWQOS;
 wire         VDMA2_AXI_AWVALID;
 wire         VDMA2_AXI_AWREADY;
 wire [63:0]  VDMA2_AXI_WDATA;
 wire [7:0]   VDMA2_AXI_WSTRB;
 wire         VDMA2_AXI_WLAST;
 wire         VDMA2_AXI_WVALID;
 wire         VDMA2_AXI_WREADY;
 wire [0:0]   VDMA2_AXI_BID;
 wire [1:0]   VDMA2_AXI_BRESP;
 wire         VDMA2_AXI_BVALID;
 wire         VDMA2_AXI_BREADY;
 wire [0:0]   VDMA2_AXI_ARID;
 wire [31:0]  VDMA2_AXI_ARADDR;
 wire [7:0]   VDMA2_AXI_ARLEN;
 wire [2:0]   VDMA2_AXI_ARSIZE;
 wire [1:0]   VDMA2_AXI_ARBURST;
 wire         VDMA2_AXI_ARLOCK;
 wire [3:0]   VDMA2_AXI_ARCACHE;
 wire [2:0]   VDMA2_AXI_ARPROT;
 wire [3:0]   VDMA2_AXI_ARQOS;
 wire         VDMA2_AXI_ARVALID;
 wire         VDMA2_AXI_ARREADY;
 wire [0:0]   VDMA2_AXI_RID;
 wire [63:0]  VDMA2_AXI_RDATA;
 wire [1:0]   VDMA2_AXI_RRESP;
 wire         VDMA2_AXI_RLAST;
 wire         VDMA2_AXI_RVALID;
 wire         VDMA2_AXI_RREADY;
 //MIG
 wire [3:0]   MIG_AXI_AWID;
 wire [31:0]  MIG_AXI_AWADDR;
 wire [7:0]   MIG_AXI_AWLEN;
 wire [2:0]   MIG_AXI_AWSIZE;
 wire [1:0]   MIG_AXI_AWBURST;
 wire         MIG_AXI_AWLOCK;
 wire [3:0]   MIG_AXI_AWCACHE;
 wire [2:0]   MIG_AXI_AWPROT;
 wire [3:0]   MIG_AXI_AWQOS;
 wire         MIG_AXI_AWVALID;
 wire         MIG_AXI_AWREADY;
 wire [127:0] MIG_AXI_WDATA;
 wire [15:0]  MIG_AXI_WSTRB;
 wire         MIG_AXI_WLAST;
 wire         MIG_AXI_WVALID;
 wire         MIG_AXI_WREADY;
 wire [3:0]   MIG_AXI_BID;
 wire [1:0]   MIG_AXI_BRESP;
 wire         MIG_AXI_BVALID;
 wire         MIG_AXI_BREADY;
 wire [3:0]   MIG_AXI_ARID;
 wire [31:0]  MIG_AXI_ARADDR;
 wire [7:0]   MIG_AXI_ARLEN;
 wire [2:0]   MIG_AXI_ARSIZE;
 wire [1:0]   MIG_AXI_ARBURST;
 wire         MIG_AXI_ARLOCK;
 wire [3:0]   MIG_AXI_ARCACHE;
 wire [2:0]   MIG_AXI_ARPROT;
 wire [3:0]   MIG_AXI_ARQOS;
 wire         MIG_AXI_ARVALID;
 wire         MIG_AXI_ARREADY;
 wire [3:0]   MIG_AXI_RID;
 wire [127:0] MIG_AXI_RDATA;
 wire [1:0]   MIG_AXI_RRESP;
 wire         MIG_AXI_RLAST;
 wire         MIG_AXI_RVALID;
 wire         MIG_AXI_RREADY;

 //peripherals for test
 //axi-lite
 wire [31:0]  vdma0_axi_awaddr;
 wire [2:0]   vdma0_axi_awprot;
 wire [0:0]   vdma0_axi_awvalid;
 wire [0:0]   vdma0_axi_awready;
 wire [31:0]  vdma0_axi_wdata;
 wire [3:0]   vdma0_axi_wstrb;
 wire [0:0]   vdma0_axi_wvalid;
 wire [0:0]   vdma0_axi_wready;
 wire [1:0]   vdma0_axi_bresp;
 wire [0:0]   vdma0_axi_bvalid;
 wire [0:0]   vdma0_axi_bready;
 wire [31:0]  vdma0_axi_araddr;
 wire [2:0]   vdma0_axi_arprot;
 wire [0:0]   vdma0_axi_arvalid;
 wire [0:0]   vdma0_axi_arready;
 wire [31:0]  vdma0_axi_rdata;
 wire [1:0]   vdma0_axi_rresp;
 wire [0:0]   vdma0_axi_rvalid;
 wire [0:0]   vdma0_axi_rready;
 wire [31:0]  vdma1_axi_awaddr;
 wire [2:0]   vdma1_axi_awprot;
 wire [0:0]   vdma1_axi_awvalid;
 wire [0:0]   vdma1_axi_awready;
 wire [31:0]  vdma1_axi_wdata;
 wire [3:0]   vdma1_axi_wstrb;
 wire [0:0]   vdma1_axi_wvalid;
 wire [0:0]   vdma1_axi_wready;
 wire [1:0]   vdma1_axi_bresp;
 wire [0:0]   vdma1_axi_bvalid;
 wire [0:0]   vdma1_axi_bready;
 wire [31:0]  vdma1_axi_araddr;
 wire [2:0]   vdma1_axi_arprot;
 wire [0:0]   vdma1_axi_arvalid;
 wire [0:0]   vdma1_axi_arready;
 wire [31:0]  vdma1_axi_rdata;
 wire [1:0]   vdma1_axi_rresp;
 wire [0:0]   vdma1_axi_rvalid;
 wire [0:0]   vdma1_axi_rready;
 wire [31:0]  vdma2_axi_awaddr;
 wire [2:0]   vdma2_axi_awprot;
 wire [0:0]   vdma2_axi_awvalid;
 wire [0:0]   vdma2_axi_awready;
 wire [31:0]  vdma2_axi_wdata;
 wire [3:0]   vdma2_axi_wstrb;
 wire [0:0]   vdma2_axi_wvalid;
 wire [0:0]   vdma2_axi_wready;
 wire [1:0]   vdma2_axi_bresp;
 wire [0:0]   vdma2_axi_bvalid;
 wire [0:0]   vdma2_axi_bready;
 wire [31:0]  vdma2_axi_araddr;
 wire [2:0]   vdma2_axi_arprot;
 wire [0:0]   vdma2_axi_arvalid;
 wire [0:0]   vdma2_axi_arready;
 wire [31:0]  vdma2_axi_rdata;
 wire [1:0]   vdma2_axi_rresp;
 wire [0:0]   vdma2_axi_rvalid;
 wire [0:0]   vdma2_axi_rready;

// assign

  assign m00_axi_aclk = sys_clk;
  assign m01_axi_aclk = sys_clk;

//    assign m00_axi_aresetn = rstn;

 //reset synchronizer --> will be seperated
 reg          rstn_int1;
//   reg          rstn_int2;
 
 always@(posedge clk or negedge rstn)
   begin
  if (!rstn)
    begin
       rstn_int1 <= 1'b0;
       rstn_int2 <= 1'b0;
    end
  else
    begin
       rstn_int1 <= 1'b1;
       rstn_int2 <= rstn_int1;
    end
   end

 reg          rstn_sys_int1;
 reg          rstn_sys_int2;
 reg          rstn_sys_int3;

 always@(posedge sys_clk or negedge rstn)
   begin
  if (!rstn)
    begin
       rstn_sys_int1 <= 1'b0;
       rstn_sys_int2 <= 1'b0;
       rstn_sys_int3 <= 1'b0;
    end
  else
    begin
       rstn_sys_int1 <= 1'b1;
       rstn_sys_int2 <= rstn_sys_int1;
       rstn_sys_int3 <= rstn_sys_int2;
    end
   end

//-----------------------------
// ****** Clock generator ****
//-----------------------------
 clk_gen
   u_clk_gen
     (
  // Clock out ports
  .clk_100mhz(sys_clk),
  .clk_200mhz(clk_ref_i),
  .clk_325mhz(sys_clk_i),
  // Status and control signals
  .resetn(rstn_int2),
  // Clock in ports
  .clk_in1(clk)
  );



//-----------------------------
// ******* AXI masters *******
//-----------------------------

 // host decoder
 host_decoder_top
   u_host_decoder_top
     (
  .RxD                    (uart_rx),
  .TxD                    (uart_tx),
  .system_start           (Start_inference), //not use
  .write_end              (write_end),
  .m00_axi_write_done     (), //float
  .m00_axi_read_done      (), //float
  .m00_axi_aclk           (m00_axi_aclk),
  .m00_axi_aresetn        (rstn_sys_int3),
  .m00_axi_awaddr         (host_axi_awaddr),
  .m00_axi_awprot         (host_axi_awprot),
  .m00_axi_awvalid        (host_axi_awvalid),
  .m00_axi_awready        (host_axi_awready),
  .m00_axi_wdata          (host_axi_wdata),
  .m00_axi_wstrb          (host_axi_wstrb),
  .m00_axi_wvalid         (host_axi_wvalid),
  .m00_axi_wready         (host_axi_wready),
  .m00_axi_bresp          (host_axi_bresp),
  .m00_axi_bvalid         (host_axi_bvalid),
  .m00_axi_bready         (host_axi_bready),
  .m00_axi_araddr         (host_axi_araddr),
  .m00_axi_arprot         (host_axi_arprot),
  .m00_axi_arvalid        (host_axi_arvalid),
  .m00_axi_arready        (host_axi_arready),
  .m00_axi_rdata          (host_axi_rdata),
  .m00_axi_rresp          (host_axi_rresp),
  .m00_axi_rvalid         (host_axi_rvalid),
  .m00_axi_rready         (host_axi_rready)
  );


  // dma0 for FC
 axi_vdma_0
   u_axi_vdma0
     (
      // system
  .s_axi_lite_aclk                (m01_axi_aclk),
  .m_axi_mm2s_aclk                (m01_axi_aclk),
  .m_axis_mm2s_aclk               (m01_axi_aclk),
  .m_axi_s2mm_aclk                (m01_axi_aclk),
  .s_axis_s2mm_aclk               (m01_axi_aclk),
  .axi_resetn                     (aresetn_s01_out),
  // S_AXI_LITE port
  .s_axi_lite_awvalid             (vdma0_axi_awvalid),
  .s_axi_lite_awready             (vdma0_axi_awready),
  .s_axi_lite_awaddr              (vdma0_axi_awaddr[8:0]),   // 9bit
  .s_axi_lite_wvalid              (vdma0_axi_wvalid),
  .s_axi_lite_wready              (vdma0_axi_wready),
  .s_axi_lite_wdata               (vdma0_axi_wdata),    //4bit
  .s_axi_lite_bresp               (vdma0_axi_bresp),    //2bit
  .s_axi_lite_bvalid              (vdma0_axi_bvalid),
  .s_axi_lite_bready              (vdma0_axi_bready),
  .s_axi_lite_arvalid             (vdma0_axi_arvalid),
  .s_axi_lite_arready             (vdma0_axi_arready),
  .s_axi_lite_araddr              (vdma0_axi_araddr[8:0]),   //9bit
  .s_axi_lite_rvalid              (vdma0_axi_rvalid),
  .s_axi_lite_rready              (vdma0_axi_rready),
  .s_axi_lite_rdata               (vdma0_axi_rdata),    //32bit
  .s_axi_lite_rresp               (vdma0_axi_rresp),    //2bit
  // ptr_out
  .mm2s_frame_ptr_out             (),  //6bit
  .s2mm_frame_ptr_out             (),  //6bit
  // M_AXI_MM2S port
  .m_axi_mm2s_araddr              (VDMA0_AXI_ARADDR),   //32bit
  .m_axi_mm2s_arlen               (VDMA0_AXI_ARLEN),    //8bit
  .m_axi_mm2s_arsize              (VDMA0_AXI_ARSIZE),   //3bit
  .m_axi_mm2s_arburst             (VDMA0_AXI_ARBURST),  //2bit
  .m_axi_mm2s_arprot              (VDMA0_AXI_ARPROT),   //3bit
  .m_axi_mm2s_arcache             (VDMA0_AXI_ARCACHE),  //4bit
  .m_axi_mm2s_arvalid             (VDMA0_AXI_ARVALID),
  .m_axi_mm2s_arready             (VDMA0_AXI_ARREADY),
  .m_axi_mm2s_rdata               (VDMA0_AXI_RDATA),    //64bit
  .m_axi_mm2s_rresp               (VDMA0_AXI_RRESP),    //2bit
  .m_axi_mm2s_rlast               (VDMA0_AXI_RLAST),
  .m_axi_mm2s_rvalid              (VDMA0_AXI_RVALID),
  .m_axi_mm2s_rready              (VDMA0_AXI_RREADY),
  // M_AXIS_MM2S port
  .m_axis_mm2s_tdata              (vdma0_m_axis_mm2s_tdata),   //32bit
  .m_axis_mm2s_tkeep              (vdma0_m_axis_mm2s_tkeep),   //4bit
  .m_axis_mm2s_tuser              (vdma0_m_axis_mm2s_tuser),
  .m_axis_mm2s_tvalid             (vdma0_m_axis_mm2s_tvalid),
  .m_axis_mm2s_tready             (vdma0_m_axis_mm2s_tready), //input
  .m_axis_mm2s_tlast              (vdma0_m_axis_mm2s_tlast),
  // M_AXI_S2MM port
  .m_axi_s2mm_awaddr              (VDMA0_AXI_AWADDR),   //32bit
  .m_axi_s2mm_awlen               (VDMA0_AXI_AWLEN),    //8bit
  .m_axi_s2mm_awsize              (VDMA0_AXI_AWSIZE),   //3bit
  .m_axi_s2mm_awburst             (VDMA0_AXI_AWBURST),  //2bit
  .m_axi_s2mm_awprot              (VDMA0_AXI_AWPROT),   //3bit
  .m_axi_s2mm_awcache             (VDMA0_AXI_AWCACHE),  //4bit
  .m_axi_s2mm_awvalid             (VDMA0_AXI_AWVALID),
  .m_axi_s2mm_awready             (VDMA0_AXI_AWREADY),
  .m_axi_s2mm_wdata               (VDMA0_AXI_WDATA),    //64bit
  .m_axi_s2mm_wstrb               (VDMA0_AXI_WSTRB),    //8bit
  .m_axi_s2mm_wlast               (VDMA0_AXI_WLAST),
  .m_axi_s2mm_wvalid              (VDMA0_AXI_WVALID),
  .m_axi_s2mm_wready              (VDMA0_AXI_WREADY),
  .m_axi_s2mm_bresp               (VDMA0_AXI_BRESP),    //2bit
  .m_axi_s2mm_bvalid              (VDMA0_AXI_BVALID),
  .m_axi_s2mm_bready              (VDMA0_AXI_BREADY),
  // S_AXIS_S2MM port
  .s_axis_s2mm_tdata              (vdma0_s_axis_s2mm_tdata),   //32bit
  .s_axis_s2mm_tkeep              (vdma0_s_axis_s2mm_tkeep),   //4bit
  .s_axis_s2mm_tuser              (vdma0_s_axis_s2mm_tuser),
  .s_axis_s2mm_tvalid             (vdma0_s_axis_s2mm_tvalid),
  .s_axis_s2mm_tready             (vdma0_s_axis_s2mm_tready), //output
  .s_axis_s2mm_tlast              (vdma0_s_axis_s2mm_tlast),
  // introut
  .mm2s_introut           (),
  .s2mm_introut           ()
  );

 // dma2 for CONV

 axi_vdma_0
   u_axi_vdma1
     (
  // system
  .s_axi_lite_aclk                (m01_axi_aclk),
  .m_axi_mm2s_aclk                (m01_axi_aclk),
  .m_axis_mm2s_aclk               (m01_axi_aclk),
  .m_axi_s2mm_aclk                (m01_axi_aclk),
  .s_axis_s2mm_aclk               (m01_axi_aclk),
  .axi_resetn                     (aresetn_s02_out),
  // S_AXI_LITE port
  .s_axi_lite_awvalid             (vdma1_axi_awvalid),
  .s_axi_lite_awready             (vdma1_axi_awready),
  .s_axi_lite_awaddr              (vdma1_axi_awaddr[8:0]),   // 9bit
  .s_axi_lite_wvalid              (vdma1_axi_wvalid),
  .s_axi_lite_wready              (vdma1_axi_wready),
  .s_axi_lite_wdata               (vdma1_axi_wdata),    //4bit
  .s_axi_lite_bresp               (vdma1_axi_bresp),    //2bit
  .s_axi_lite_bvalid              (vdma1_axi_bvalid),
  .s_axi_lite_bready              (vdma1_axi_bready),
  .s_axi_lite_arvalid             (vdma1_axi_arvalid),
  .s_axi_lite_arready             (vdma1_axi_arready),
  .s_axi_lite_araddr              (vdma1_axi_araddr[8:0]),   //9bit
  .s_axi_lite_rvalid              (vdma1_axi_rvalid),
  .s_axi_lite_rready              (vdma1_axi_rready),
  .s_axi_lite_rdata               (vdma1_axi_rdata),    //32bit
  .s_axi_lite_rresp               (vdma1_axi_rresp),    //2bit
  // ptr_out
  .mm2s_frame_ptr_out             (),  //6bit
  .s2mm_frame_ptr_out             (),  //6bit
  // M_AXI_MM2S port
  .m_axi_mm2s_araddr              (VDMA1_AXI_ARADDR),   //32bit
  .m_axi_mm2s_arlen               (VDMA1_AXI_ARLEN),    //8bit
  .m_axi_mm2s_arsize              (VDMA1_AXI_ARSIZE),   //3bit
  .m_axi_mm2s_arburst             (VDMA1_AXI_ARBURST),  //2bit
  .m_axi_mm2s_arprot              (VDMA1_AXI_ARPROT),   //3bit
  .m_axi_mm2s_arcache             (VDMA1_AXI_ARCACHE),  //4bit
  .m_axi_mm2s_arvalid             (VDMA1_AXI_ARVALID),
  .m_axi_mm2s_arready             (VDMA1_AXI_ARREADY),
  .m_axi_mm2s_rdata               (VDMA1_AXI_RDATA),    //64bit
  .m_axi_mm2s_rresp               (VDMA1_AXI_RRESP),    //2bit
  .m_axi_mm2s_rlast               (VDMA1_AXI_RLAST),
  .m_axi_mm2s_rvalid              (VDMA1_AXI_RVALID),
  .m_axi_mm2s_rready              (VDMA1_AXI_RREADY),
  // M_AXIS_MM2S port
  .m_axis_mm2s_tdata              (vdma1_m_axis_mm2s_tdata),   //32bit
  .m_axis_mm2s_tkeep              (vdma1_m_axis_mm2s_tkeep),   //4bit
  .m_axis_mm2s_tuser              (vdma1_m_axis_mm2s_tuser),
  .m_axis_mm2s_tvalid             (vdma1_m_axis_mm2s_tvalid),
  .m_axis_mm2s_tready             (vdma1_m_axis_mm2s_tready), //input
  .m_axis_mm2s_tlast              (vdma1_m_axis_mm2s_tlast),
  // M_AXI_S2MM port
  .m_axi_s2mm_awaddr              (VDMA1_AXI_AWADDR),   //32bit
  .m_axi_s2mm_awlen               (VDMA1_AXI_AWLEN),    //8bit
  .m_axi_s2mm_awsize              (VDMA1_AXI_AWSIZE),   //3bit
  .m_axi_s2mm_awburst             (VDMA1_AXI_AWBURST),  //2bit
  .m_axi_s2mm_awprot              (VDMA1_AXI_AWPROT),   //3bit
  .m_axi_s2mm_awcache             (VDMA1_AXI_AWCACHE),  //4bit
  .m_axi_s2mm_awvalid             (VDMA1_AXI_AWVALID),
  .m_axi_s2mm_awready             (VDMA1_AXI_AWREADY),
  .m_axi_s2mm_wdata               (VDMA1_AXI_WDATA),    //64bit
  .m_axi_s2mm_wstrb               (VDMA1_AXI_WSTRB),    //8bit
  .m_axi_s2mm_wlast               (VDMA1_AXI_WLAST),
  .m_axi_s2mm_wvalid              (VDMA1_AXI_WVALID),
  .m_axi_s2mm_wready              (VDMA1_AXI_WREADY),
  .m_axi_s2mm_bresp               (VDMA1_AXI_BRESP),    //2bit
  .m_axi_s2mm_bvalid              (VDMA1_AXI_BVALID),
  .m_axi_s2mm_bready              (VDMA1_AXI_BREADY),
  // S_AXIS_S2MM port
  .s_axis_s2mm_tdata              (vdma1_s_axis_s2mm_tdata),   //32bit
  .s_axis_s2mm_tkeep              (vdma1_s_axis_s2mm_tkeep),   //4bit
  .s_axis_s2mm_tuser              (vdma1_s_axis_s2mm_tuser),
  .s_axis_s2mm_tvalid             (vdma1_s_axis_s2mm_tvalid),
  .s_axis_s2mm_tready             (vdma1_s_axis_s2mm_tready), //output
  .s_axis_s2mm_tlast              (vdma1_s_axis_s2mm_tlast),
  // introut
  .mm2s_introut                   (),
  .s2mm_introut                   ()
  );

 // dma3 for POOL

 axi_vdma_0
   u_axi_vdma2
     (
  // system
  .s_axi_lite_aclk                (m01_axi_aclk),
  .m_axi_mm2s_aclk                (m01_axi_aclk),
  .m_axis_mm2s_aclk               (m01_axi_aclk),
  .m_axi_s2mm_aclk                (m01_axi_aclk),
  .s_axis_s2mm_aclk               (m01_axi_aclk),
  .axi_resetn                     (aresetn_s03_out),
  // S_AXI_LITE port
  .s_axi_lite_awvalid             (vdma2_axi_awvalid),
  .s_axi_lite_awready             (vdma2_axi_awready),
  .s_axi_lite_awaddr              (vdma2_axi_awaddr[8:0]),   // 9bit
  .s_axi_lite_wvalid              (vdma2_axi_wvalid),
  .s_axi_lite_wready              (vdma2_axi_wready),
  .s_axi_lite_wdata               (vdma2_axi_wdata),    //4bit
  .s_axi_lite_bresp               (vdma2_axi_bresp),    //2bit
  .s_axi_lite_bvalid              (vdma2_axi_bvalid),
  .s_axi_lite_bready              (vdma2_axi_bready),
  .s_axi_lite_arvalid             (vdma2_axi_arvalid),
  .s_axi_lite_arready             (vdma2_axi_arready),
  .s_axi_lite_araddr              (vdma2_axi_araddr[8:0]),   //9bit
  .s_axi_lite_rvalid              (vdma2_axi_rvalid),
  .s_axi_lite_rready              (vdma2_axi_rready),
  .s_axi_lite_rdata               (vdma2_axi_rdata),    //32bit
  .s_axi_lite_rresp               (vdma2_axi_rresp),    //2bit
  // ptr_out
  .mm2s_frame_ptr_out             (),  //6bit
  .s2mm_frame_ptr_out             (),  //6bit
  // M_AXI_MM2S port
  .m_axi_mm2s_araddr              (VDMA2_AXI_ARADDR),   //32bit
  .m_axi_mm2s_arlen               (VDMA2_AXI_ARLEN),    //8bit
  .m_axi_mm2s_arsize              (VDMA2_AXI_ARSIZE),   //3bit
  .m_axi_mm2s_arburst             (VDMA2_AXI_ARBURST),  //2bit
  .m_axi_mm2s_arprot              (VDMA2_AXI_ARPROT),   //3bit
  .m_axi_mm2s_arcache             (VDMA2_AXI_ARCACHE),  //4bit
  .m_axi_mm2s_arvalid             (VDMA2_AXI_ARVALID),
  .m_axi_mm2s_arready             (VDMA2_AXI_ARREADY),
  .m_axi_mm2s_rdata               (VDMA2_AXI_RDATA),    //64bit
  .m_axi_mm2s_rresp               (VDMA2_AXI_RRESP),    //2bit
  .m_axi_mm2s_rlast               (VDMA2_AXI_RLAST),
  .m_axi_mm2s_rvalid              (VDMA2_AXI_RVALID),
  .m_axi_mm2s_rready              (VDMA2_AXI_RREADY),
  // M_AXIS_MM2S port
  .m_axis_mm2s_tdata              (vdma2_m_axis_mm2s_tdata),   //32bit
  .m_axis_mm2s_tkeep              (vdma2_m_axis_mm2s_tkeep),   //4bit
  .m_axis_mm2s_tuser              (vdma2_m_axis_mm2s_tuser),
  .m_axis_mm2s_tvalid             (vdma2_m_axis_mm2s_tvalid),
  .m_axis_mm2s_tready             (vdma2_m_axis_mm2s_tready), //input
  .m_axis_mm2s_tlast              (vdma2_m_axis_mm2s_tlast),
  // M_AXI_S2MM port
  .m_axi_s2mm_awaddr              (VDMA2_AXI_AWADDR),   //32bit
  .m_axi_s2mm_awlen               (VDMA2_AXI_AWLEN),    //8bit
  .m_axi_s2mm_awsize              (VDMA2_AXI_AWSIZE),   //3bit
  .m_axi_s2mm_awburst             (VDMA2_AXI_AWBURST),  //2bit
  .m_axi_s2mm_awprot              (VDMA2_AXI_AWPROT),   //3bit
  .m_axi_s2mm_awcache             (VDMA2_AXI_AWCACHE),  //4bit
  .m_axi_s2mm_awvalid             (VDMA2_AXI_AWVALID),
  .m_axi_s2mm_awready             (VDMA2_AXI_AWREADY),
  .m_axi_s2mm_wdata               (VDMA2_AXI_WDATA),    //64bit
  .m_axi_s2mm_wstrb               (VDMA2_AXI_WSTRB),    //8bit
  .m_axi_s2mm_wlast               (VDMA2_AXI_WLAST),
  .m_axi_s2mm_wvalid              (VDMA2_AXI_WVALID),
  .m_axi_s2mm_wready              (VDMA2_AXI_WREADY),
  .m_axi_s2mm_bresp               (VDMA2_AXI_BRESP),    //2bit
  .m_axi_s2mm_bvalid              (VDMA2_AXI_BVALID),
  .m_axi_s2mm_bready              (VDMA2_AXI_BREADY),
  // S_AXIS_S2MM port
  .s_axis_s2mm_tdata              (vdma2_s_axis_s2mm_tdata),   //32bit
  .s_axis_s2mm_tkeep              (vdma2_s_axis_s2mm_tkeep),   //4bit
  .s_axis_s2mm_tuser              (vdma2_s_axis_s2mm_tuser),
  .s_axis_s2mm_tvalid             (vdma2_s_axis_s2mm_tvalid),
  .s_axis_s2mm_tready             (vdma2_s_axis_s2mm_tready), //output
  .s_axis_s2mm_tlast              (vdma2_s_axis_s2mm_tlast),
  // introut
  .mm2s_introut                   (),
  .s2mm_introut                   ()
  );

//-----------------------------
// ******* AXI slaves ********
//-----------------------------
  // mig
`ifndef BRAM
  mig_dram
  u_mig
  (
      .ddr3_addr        (ddr3_addr[13:0]),
      .ddr3_ba          (ddr3_ba[2:0]),
      .ddr3_ras_n       (ddr3_ras_n),
      .ddr3_cas_n       (ddr3_cas_n),
      .ddr3_we_n        (ddr3_we_n),
      .ddr3_ck_p        (ddr3_ck_p[0:0]),
      .ddr3_ck_n        (ddr3_ck_n[0:0]),
      .ddr3_cke         (ddr3_cke[0:0]),
      .ddr3_cs_n        (ddr3_cs_n[0:0]),
      .ddr3_dm          (ddr3_dm[1:0]),
      .ddr3_odt         (ddr3_odt[0:0]),
      .ddr3_reset_n     (ddr3_reset_n),
      .ui_clk                 (ui_clk),
      .ui_clk_sync_rst        (ui_clk_sync_rst),
      .mmcm_locked            (mmcm_locked),
      .app_sr_active          (app_sr_active),
      .app_ref_ack            (app_ref_ack),
      .app_zq_ack             (app_zq_ack),
      .ddr3_dq          (ddr3_dq[15:0]),
      .ddr3_dqs_n       (ddr3_dqs_n[1:0]),
      .ddr3_dqs_p       (ddr3_dqs_p[1:0]),

      // DRAM init calibration complete
      .init_calib_complete    (init_calib_complete),
      // System signals
      .sys_clk_i              (sys_clk_i),
      .clk_ref_i              (clk_ref_i),
      .aresetn                (aresetn_m00_out),   //
      .sys_rst                (rstn_int2),   //
      // Write address channel
      .s_axi_awid             (MIG_AXI_AWID[3:0]),
      .s_axi_awaddr           (MIG_AXI_AWADDR),
      .s_axi_awlen            (MIG_AXI_AWLEN[7:0]),
      .s_axi_awsize           (MIG_AXI_AWSIZE[2:0]),
      .s_axi_awburst          (MIG_AXI_AWBURST[1:0]),
      .s_axi_awlock           (MIG_AXI_AWLOCK),
      .s_axi_awcache          (MIG_AXI_AWCACHE[3:0]),
      .s_axi_awprot           (MIG_AXI_AWPROT),
      .s_axi_awqos            (MIG_AXI_AWQOS[3:0]),
      .s_axi_awvalid          (MIG_AXI_AWVALID),
      .s_axi_awready          (MIG_AXI_AWREADY),
      // Write data channel
      .s_axi_wdata            (MIG_AXI_WDATA),
      .s_axi_wstrb            (MIG_AXI_WSTRB),
      .s_axi_wlast            (MIG_AXI_WLAST), //  if  m00_axi_wvalid = 1 last = 1, else last = 0
      .s_axi_wvalid           (MIG_AXI_WVALID),
      .s_axi_wready           (MIG_AXI_WREADY),
      // Write response
      .s_axi_bid              (MIG_AXI_BID),
      .s_axi_bresp            (MIG_AXI_BRESP),
      .s_axi_bvalid           (MIG_AXI_BVALID),
      .s_axi_bready           (MIG_AXI_BREADY),
      // Read address
      .s_axi_arid             (MIG_AXI_ARID),
      .s_axi_araddr           (MIG_AXI_ARADDR),
      .s_axi_arlen            (MIG_AXI_ARLEN[7:0]),
      .s_axi_arsize           (MIG_AXI_ARSIZE[2:0]),
      .s_axi_arburst          (MIG_AXI_ARBURST[1:0]),
      .s_axi_arlock           (MIG_AXI_ARLOCK),
      .s_axi_arcache          (MIG_AXI_ARCACHE[3:0]),
      .s_axi_arprot           (MIG_AXI_ARPROT),
      .s_axi_arqos            (MIG_AXI_ARQOS[3:0]),
      .s_axi_arvalid          (MIG_AXI_ARVALID),
      .s_axi_arready          (MIG_AXI_ARREADY),
      // Read data
      .s_axi_rid              (MIG_AXI_RID[3:0]),
      .s_axi_rdata            (MIG_AXI_RDATA),
      .s_axi_rresp            (MIG_AXI_RRESP),
      .s_axi_rlast            (MIG_AXI_RLAST),
      .s_axi_rvalid           (MIG_AXI_RVALID),
      .s_axi_rready           (MIG_AXI_RREADY),

      .app_sr_req             (1'b0),
      .app_ref_req            (1'b0),
      .app_zq_req             (1'b0)
  );
`endif

`ifdef BRAM

 axi_sram_128
   u_axi_sram_128
  (
      .rsta_busy          (),
      .rstb_busy          (),
      .s_aclk             (m00_axi_aclk),
      .s_aresetn          (aresetn_m00_out),
      .s_axi_awid         (MIG_AXI_AWID),
      .s_axi_awaddr       (MIG_AXI_AWADDR),
      .s_axi_awlen        (MIG_AXI_AWLEN),
      .s_axi_awsize       (MIG_AXI_AWSIZE),
      .s_axi_awburst      (MIG_AXI_AWBURST),
      .s_axi_awvalid      (MIG_AXI_AWVALID),
      .s_axi_awready      (MIG_AXI_AWREADY),
      .s_axi_wdata        (MIG_AXI_WDATA),
      .s_axi_wstrb        (MIG_AXI_WSTRB),
      .s_axi_wlast        (MIG_AXI_WLAST),
      .s_axi_wvalid       (MIG_AXI_WVALID),
      .s_axi_wready       (MIG_AXI_WREADY),
      .s_axi_bid          (MIG_AXI_BID),
      .s_axi_bresp        (MIG_AXI_BRESP),
      .s_axi_bvalid       (MIG_AXI_BVALID),
      .s_axi_bready       (MIG_AXI_BREADY),
      .s_axi_arid         (MIG_AXI_ARID),
      .s_axi_araddr       (MIG_AXI_ARADDR),
      .s_axi_arlen        (MIG_AXI_ARLEN),
      .s_axi_arsize       (MIG_AXI_ARSIZE),
      .s_axi_arburst      (MIG_AXI_ARBURST),
      .s_axi_arvalid      (MIG_AXI_ARVALID),
      .s_axi_arready      (MIG_AXI_ARREADY),
      .s_axi_rid          (MIG_AXI_RID),
      .s_axi_rdata        (MIG_AXI_RDATA),
      .s_axi_rresp        (MIG_AXI_RRESP),
      .s_axi_rlast        (MIG_AXI_RLAST),
      .s_axi_rvalid       (MIG_AXI_RVALID),
      .s_axi_rready       (MIG_AXI_RREADY)
  );
`endif //  `ifdef BRAM

///////////////////////////////////////////////////////////////////////////////
// axi subsystem
  axi_subsystem u_axi_subsystem
  (
  // Outputs
  .aresetn_s00_out                (aresetn_s00_out),
  .aresetn_s01_out                (aresetn_s01_out),
  .aresetn_m00_out                (aresetn_m00_out),
  .aresetn_s02_out                (aresetn_s02_out),
  .aresetn_s03_out                (aresetn_s03_out),
  .s00_axi_awready                (host_axi_awready),//host
  .s00_axi_wready                 (host_axi_wready),
  .s00_axi_bresp                  (host_axi_bresp[1:0]),
  .s00_axi_bvalid                 (host_axi_bvalid),
  .s00_axi_arready                (host_axi_arready),
  .s00_axi_rdata                  (host_axi_rdata[31:0]),
  .s00_axi_rresp                  (host_axi_rresp[1:0]),
  .s00_axi_rlast                  (), // float
  .s00_axi_rvalid                 (host_axi_rvalid),
  .S01_AXI_AWREADY                (VDMA0_AXI_AWREADY), //vdma0
  .S01_AXI_WREADY                 (VDMA0_AXI_WREADY),
  .S01_AXI_BID                    (VDMA0_AXI_BID),
  .S01_AXI_BRESP                  (VDMA0_AXI_BRESP[1:0]),
  .S01_AXI_BVALID                 (VDMA0_AXI_BVALID),
  .S01_AXI_ARREADY                (VDMA0_AXI_ARREADY),
  .S01_AXI_RID                    (VDMA0_AXI_RID),
  .S01_AXI_RDATA                  (VDMA0_AXI_RDATA[63:0]),
  .S01_AXI_RRESP                  (VDMA0_AXI_RRESP[1:0]),
  .S01_AXI_RLAST                  (VDMA0_AXI_RLAST),
  .S01_AXI_RVALID                 (VDMA0_AXI_RVALID),
  .S02_AXI_AWREADY                (VDMA1_AXI_AWREADY), //vdma1
  .S02_AXI_WREADY                 (VDMA1_AXI_WREADY),
  .S02_AXI_BID                    (VDMA1_AXI_BID),
  .S02_AXI_BRESP                  (VDMA1_AXI_BRESP[1:0]),
  .S02_AXI_BVALID                 (VDMA1_AXI_BVALID),
  .S02_AXI_ARREADY                (VDMA1_AXI_ARREADY),
  .S02_AXI_RID                    (VDMA1_AXI_RID),
  .S02_AXI_RDATA                  (VDMA1_AXI_RDATA[63:0]),
  .S02_AXI_RRESP                  (VDMA1_AXI_RRESP[1:0]),
  .S02_AXI_RLAST                  (VDMA1_AXI_RLAST),
  .S02_AXI_RVALID                 (VDMA1_AXI_RVALID),
  .S03_AXI_AWREADY                (VDMA2_AXI_AWREADY), //vdma2
  .S03_AXI_WREADY                 (VDMA2_AXI_WREADY),
  .S03_AXI_BID                    (VDMA2_AXI_BID),
  .S03_AXI_BRESP                  (VDMA2_AXI_BRESP[1:0]),
  .S03_AXI_BVALID                 (VDMA2_AXI_BVALID),
  .S03_AXI_ARREADY                (VDMA2_AXI_ARREADY),
  .S03_AXI_RID                    (VDMA2_AXI_RID),
  .S03_AXI_RDATA                  (VDMA2_AXI_RDATA[63:0]),
  .S03_AXI_RRESP                  (VDMA2_AXI_RRESP[1:0]),
  .S03_AXI_RLAST                  (VDMA2_AXI_RLAST),
  .S03_AXI_RVALID                 (VDMA2_AXI_RVALID),
  .M00_AXI_AWID                   (MIG_AXI_AWID[3:0]), //mig
  .M00_AXI_AWADDR                 (MIG_AXI_AWADDR[31:0]),
  .M00_AXI_AWLEN                  (MIG_AXI_AWLEN[7:0]),
  .M00_AXI_AWSIZE                 (MIG_AXI_AWSIZE[2:0]),
  .M00_AXI_AWBURST                (MIG_AXI_AWBURST[1:0]),
  .M00_AXI_AWLOCK                 (MIG_AXI_AWLOCK),
  .M00_AXI_AWCACHE                (MIG_AXI_AWCACHE[3:0]),
  .M00_AXI_AWPROT                 (MIG_AXI_AWPROT[2:0]),
  .M00_AXI_AWQOS                  (MIG_AXI_AWQOS[3:0]),
  .M00_AXI_AWVALID                (MIG_AXI_AWVALID),
  .M00_AXI_WDATA                  (MIG_AXI_WDATA[127:0]),
  .M00_AXI_WSTRB                  (MIG_AXI_WSTRB[15:0]),
  .M00_AXI_WLAST                  (MIG_AXI_WLAST),
  .M00_AXI_WVALID                 (MIG_AXI_WVALID),
  .M00_AXI_BREADY                 (MIG_AXI_BREADY),
  .M00_AXI_ARID                   (MIG_AXI_ARID[3:0]),
  .M00_AXI_ARADDR                 (MIG_AXI_ARADDR[31:0]),
  .M00_AXI_ARLEN                  (MIG_AXI_ARLEN[7:0]),
  .M00_AXI_ARSIZE                 (MIG_AXI_ARSIZE[2:0]),
  .M00_AXI_ARBURST                (MIG_AXI_ARBURST[1:0]),
  .M00_AXI_ARLOCK                 (MIG_AXI_ARLOCK),
  .M00_AXI_ARCACHE                (MIG_AXI_ARCACHE[3:0]),
  .M00_AXI_ARPROT                 (MIG_AXI_ARPROT[2:0]),
  .M00_AXI_ARQOS                  (MIG_AXI_ARQOS[3:0]),
  .M00_AXI_ARVALID                (MIG_AXI_ARVALID),
  .M00_AXI_RREADY                 (MIG_AXI_RREADY),
  .m00_axi_awaddr                 (vdma0_axi_awaddr[31:0]),//vdma0
  .m00_axi_awprot                 (vdma0_axi_awprot[2:0]),
  .m00_axi_awvalid                (vdma0_axi_awvalid),
  .m00_axi_wdata                  (vdma0_axi_wdata[31:0]),
  .m00_axi_wstrb                  (vdma0_axi_wstrb[3:0]),
  .m00_axi_wvalid                 (vdma0_axi_wvalid),
  .m00_axi_bready                 (vdma0_axi_bready),
  .m00_axi_araddr                 (vdma0_axi_araddr[31:0]),
  .m00_axi_arprot                 (vdma0_axi_arprot[2:0]),
  .m00_axi_arvalid                (vdma0_axi_arvalid),
  .m00_axi_rready                 (vdma0_axi_rready),
  .m01_axi_awaddr                 (vdma1_axi_awaddr[31:0]),//vdma1
  .m01_axi_awprot                 (vdma1_axi_awprot[2:0]),
  .m01_axi_awvalid                (vdma1_axi_awvalid),
  .m01_axi_wdata                  (vdma1_axi_wdata[31:0]),
  .m01_axi_wstrb                  (vdma1_axi_wstrb[3:0]),
  .m01_axi_wvalid                 (vdma1_axi_wvalid),
  .m01_axi_bready                 (vdma1_axi_bready),
  .m01_axi_araddr                 (vdma1_axi_araddr[31:0]),
  .m01_axi_arprot                 (vdma1_axi_arprot[2:0]),
  .m01_axi_arvalid                (vdma1_axi_arvalid),
  .m01_axi_rready                 (vdma1_axi_rready),
  .m02_axi_awaddr                 (vdma2_axi_awaddr[31:0]),//vdma2
  .m02_axi_awprot                 (vdma2_axi_awprot[2:0]),
  .m02_axi_awvalid                (vdma2_axi_awvalid),
  .m02_axi_wdata                  (vdma2_axi_wdata[31:0]),
  .m02_axi_wstrb                  (vdma2_axi_wstrb[3:0]),
  .m02_axi_wvalid                 (vdma2_axi_wvalid),
  .m02_axi_bready                 (vdma2_axi_bready),
  .m02_axi_araddr                 (vdma2_axi_araddr[31:0]),
  .m02_axi_arprot                 (vdma2_axi_arprot[2:0]),
  .m02_axi_arvalid                (vdma2_axi_arvalid),
  .m02_axi_rready                 (vdma2_axi_rready),
  .m03_apb_paddr                  (fc_apb_paddr),
  .m03_apb_psel                   (fc_apb_psel),
  .m03_apb_penable                (fc_apb_penable),
  .m03_apb_pwrite                 (fc_apb_pwrite),
  .m03_apb_pwdata                 (fc_apb_pwdata),
  .m04_apb_paddr                  (conv_apb_paddr),
  .m04_apb_psel                   (conv_apb_psel),
  .m04_apb_penable                (conv_apb_penable),
  .m04_apb_pwrite                 (conv_apb_pwrite),
  .m04_apb_pwdata                 (conv_apb_pwdata),
  .m05_apb_paddr                  (pool_apb_paddr),
  .m05_apb_psel                   (pool_apb_psel),
  .m05_apb_penable                (pool_apb_penable),
  .m05_apb_pwrite                 (pool_apb_pwrite),
  .m05_apb_pwdata                 (pool_apb_pwdata),
  // Inputs

  .aclk                           (sys_clk),
  .aresetn                        (rstn_sys_int3),
  .aclk_core                      (m00_axi_aclk),
`ifdef BRAM
  .aclk_dram                      (sys_clk),
`else
  .aclk_dram                      (ui_clk),
`endif
  .s00_axi_awaddr                 (host_axi_awaddr[31:0]),//host
  .s00_axi_awlen                  (host_axi_awlen[7:0]),
  .s00_axi_awsize                 (host_axi_awsize[2:0]),
  .s00_axi_awburst                (host_axi_awburst[1:0]),
  .s00_axi_awlock                 (host_axi_awlock),
  .s00_axi_awcache                (host_axi_awcache[3:0]),
  .s00_axi_awprot                 (host_axi_awprot[2:0]),
  .s00_axi_awqos                  (host_axi_awqos[3:0]),
  .s00_axi_awvalid                (host_axi_awvalid),
  .s00_axi_wdata                  (host_axi_wdata[31:0]),
  .s00_axi_wstrb                  (host_axi_wstrb[3:0]),
  .s00_axi_wlast                  (host_axi_wvalid), // last to valid
  .s00_axi_wvalid                 (host_axi_wvalid),
  .s00_axi_bready                 (host_axi_bready),
  .s00_axi_araddr                 (host_axi_araddr[31:0]),
  .s00_axi_arlen                  (host_axi_arlen[7:0]),
  .s00_axi_arsize                 (host_axi_arsize[2:0]),
  .s00_axi_arburst                (host_axi_arburst[1:0]),
  .s00_axi_arlock                 (host_axi_arlock),
  .s00_axi_arcache                (host_axi_arcache[3:0]),
  .s00_axi_arprot                 (host_axi_arprot[2:0]), //
  .s00_axi_arqos                  (host_axi_arqos[3:0]),
  .s00_axi_arvalid                (host_axi_arvalid),
  .s00_axi_rready                 (host_axi_rready),
  .S01_AXI_AWID                   (VDMA0_AXI_AWID),//vdma0
  .S01_AXI_AWADDR                 (VDMA0_AXI_AWADDR[31:0]),
  .S01_AXI_AWLEN                  (VDMA0_AXI_AWLEN[7:0]),
  .S01_AXI_AWSIZE                 (VDMA0_AXI_AWSIZE[2:0]),
  .S01_AXI_AWBURST                (VDMA0_AXI_AWBURST[1:0]),
  .S01_AXI_AWLOCK                 (VDMA0_AXI_AWLOCK),
  .S01_AXI_AWCACHE                (VDMA0_AXI_AWCACHE[3:0]),
  .S01_AXI_AWPROT                 (VDMA0_AXI_AWPROT[2:0]),
  .S01_AXI_AWQOS                  (VDMA0_AXI_AWQOS[3:0]),
  .S01_AXI_AWVALID                (VDMA0_AXI_AWVALID),
  .S01_AXI_WDATA                  (VDMA0_AXI_WDATA[63:0]),
  .S01_AXI_WSTRB                  (VDMA0_AXI_WSTRB[7:0]),
  .S01_AXI_WLAST                  (VDMA0_AXI_WLAST),
  .S01_AXI_WVALID                 (VDMA0_AXI_WVALID),
  .S01_AXI_BREADY                 (VDMA0_AXI_BREADY),
  .S01_AXI_ARID                   (VDMA0_AXI_ARID),
  .S01_AXI_ARADDR                 (VDMA0_AXI_ARADDR[31:0]),
  .S01_AXI_ARLEN                  (VDMA0_AXI_ARLEN[7:0]),
  .S01_AXI_ARSIZE                 (VDMA0_AXI_ARSIZE[2:0]),
  .S01_AXI_ARBURST                (VDMA0_AXI_ARBURST[1:0]),
  .S01_AXI_ARLOCK                 (VDMA0_AXI_ARLOCK),
  .S01_AXI_ARCACHE                (VDMA0_AXI_ARCACHE[3:0]),
  .S01_AXI_ARPROT                 (VDMA0_AXI_ARPROT[2:0]),
  .S01_AXI_ARQOS                  (VDMA0_AXI_ARQOS[3:0]),
  .S01_AXI_ARVALID                (VDMA0_AXI_ARVALID),
  .S01_AXI_RREADY                 (VDMA0_AXI_RREADY),
  .S02_AXI_AWID                   (VDMA1_AXI_AWID),//vdma1
  .S02_AXI_AWADDR                 (VDMA1_AXI_AWADDR[31:0]),
  .S02_AXI_AWLEN                  (VDMA1_AXI_AWLEN[7:0]),
  .S02_AXI_AWSIZE                 (VDMA1_AXI_AWSIZE[2:0]),
  .S02_AXI_AWBURST                (VDMA1_AXI_AWBURST[1:0]),
  .S02_AXI_AWLOCK                 (VDMA1_AXI_AWLOCK),
  .S02_AXI_AWCACHE                (VDMA1_AXI_AWCACHE[3:0]),
  .S02_AXI_AWPROT                 (VDMA1_AXI_AWPROT[2:0]),
  .S02_AXI_AWQOS                  (VDMA1_AXI_AWQOS[3:0]),
  .S02_AXI_AWVALID                (VDMA1_AXI_AWVALID),
  .S02_AXI_WDATA                  (VDMA1_AXI_WDATA[63:0]),
  .S02_AXI_WSTRB                  (VDMA1_AXI_WSTRB[7:0]),
  .S02_AXI_WLAST                  (VDMA1_AXI_WLAST),
  .S02_AXI_WVALID                 (VDMA1_AXI_WVALID),
  .S02_AXI_BREADY                 (VDMA1_AXI_BREADY),
  .S02_AXI_ARID                   (VDMA1_AXI_ARID),
  .S02_AXI_ARADDR                 (VDMA1_AXI_ARADDR[31:0]),
  .S02_AXI_ARLEN                  (VDMA1_AXI_ARLEN[7:0]),
  .S02_AXI_ARSIZE                 (VDMA1_AXI_ARSIZE[2:0]),
  .S02_AXI_ARBURST                (VDMA1_AXI_ARBURST[1:0]),
  .S02_AXI_ARLOCK                 (VDMA1_AXI_ARLOCK),
  .S02_AXI_ARCACHE                (VDMA1_AXI_ARCACHE[3:0]),
  .S02_AXI_ARPROT                 (VDMA1_AXI_ARPROT[2:0]),
  .S02_AXI_ARQOS                  (VDMA1_AXI_ARQOS[3:0]),
  .S02_AXI_ARVALID                (VDMA1_AXI_ARVALID),
  .S02_AXI_RREADY                 (VDMA1_AXI_RREADY),
  .S03_AXI_AWID                   (VDMA2_AXI_AWID),//vdma2
  .S03_AXI_AWADDR                 (VDMA2_AXI_AWADDR[31:0]),
  .S03_AXI_AWLEN                  (VDMA2_AXI_AWLEN[7:0]),
  .S03_AXI_AWSIZE                 (VDMA2_AXI_AWSIZE[2:0]),
  .S03_AXI_AWBURST                (VDMA2_AXI_AWBURST[1:0]),
  .S03_AXI_AWLOCK                 (VDMA2_AXI_AWLOCK),
  .S03_AXI_AWCACHE                (VDMA2_AXI_AWCACHE[3:0]),
  .S03_AXI_AWPROT                 (VDMA2_AXI_AWPROT[2:0]),
  .S03_AXI_AWQOS                  (VDMA2_AXI_AWQOS[3:0]),
  .S03_AXI_AWVALID                (VDMA2_AXI_AWVALID),
  .S03_AXI_WDATA                  (VDMA2_AXI_WDATA[63:0]),
  .S03_AXI_WSTRB                  (VDMA2_AXI_WSTRB[7:0]),
  .S03_AXI_WLAST                  (VDMA2_AXI_WLAST),
  .S03_AXI_WVALID                 (VDMA2_AXI_WVALID),
  .S03_AXI_BREADY                 (VDMA2_AXI_BREADY),
  .S03_AXI_ARID                   (VDMA2_AXI_ARID),
  .S03_AXI_ARADDR                 (VDMA2_AXI_ARADDR[31:0]),
  .S03_AXI_ARLEN                  (VDMA2_AXI_ARLEN[7:0]),
  .S03_AXI_ARSIZE                 (VDMA2_AXI_ARSIZE[2:0]),
  .S03_AXI_ARBURST                (VDMA2_AXI_ARBURST[1:0]),
  .S03_AXI_ARLOCK                 (VDMA2_AXI_ARLOCK),
  .S03_AXI_ARCACHE                (VDMA2_AXI_ARCACHE[3:0]),
  .S03_AXI_ARPROT                 (VDMA2_AXI_ARPROT[2:0]),
  .S03_AXI_ARQOS                  (VDMA2_AXI_ARQOS[3:0]),
  .S03_AXI_ARVALID                (VDMA2_AXI_ARVALID),
  .S03_AXI_RREADY                 (VDMA2_AXI_RREADY),
  .M00_AXI_AWREADY                (MIG_AXI_AWREADY),//mig
  .M00_AXI_WREADY                 (MIG_AXI_WREADY),
  .M00_AXI_BID                    (MIG_AXI_BID[3:0]),
  .M00_AXI_BRESP                  (MIG_AXI_BRESP[1:0]),
  .M00_AXI_BVALID                 (MIG_AXI_BVALID),
  .M00_AXI_ARREADY                (MIG_AXI_ARREADY),
  .M00_AXI_RID                    (MIG_AXI_RID[3:0]),
  .M00_AXI_RDATA                  (MIG_AXI_RDATA[127:0]),
  .M00_AXI_RRESP                  (MIG_AXI_RRESP[1:0]),
  .M00_AXI_RLAST                  (MIG_AXI_RLAST),
  .M00_AXI_RVALID                 (MIG_AXI_RVALID),
  .m00_axi_awready                (vdma0_axi_awready),//vdma0
  .m00_axi_wready                 (vdma0_axi_wready),
  .m00_axi_bresp                  (vdma0_axi_bresp[1:0]),
  .m00_axi_bvalid                 (vdma0_axi_bvalid),
  .m00_axi_arready                (vdma0_axi_arready),
  .m00_axi_rdata                  (vdma0_axi_rdata[31:0]),
  .m00_axi_rresp                  (vdma0_axi_rresp[1:0]),
  .m00_axi_rvalid                 (vdma0_axi_rvalid),
  .m01_axi_awready                (vdma1_axi_awready),//vdma1
  .m01_axi_wready                 (vdma1_axi_wready),
  .m01_axi_bresp                  (vdma1_axi_bresp[1:0]),
  .m01_axi_bvalid                 (vdma1_axi_bvalid),
  .m01_axi_arready                (vdma1_axi_arready),
  .m01_axi_rdata                  (vdma1_axi_rdata[31:0]),
  .m01_axi_rresp                  (vdma1_axi_rresp[1:0]),
  .m01_axi_rvalid                 (vdma1_axi_rvalid),
  .m02_axi_awready                (vdma2_axi_awready),//vdma2
  .m02_axi_wready                 (vdma2_axi_wready),
  .m02_axi_bresp                  (vdma2_axi_bresp[1:0]),
  .m02_axi_bvalid                 (vdma2_axi_bvalid),
  .m02_axi_arready                (vdma2_axi_arready),
  .m02_axi_rdata                  (vdma2_axi_rdata[31:0]),
  .m02_axi_rresp                  (vdma2_axi_rresp[1:0]),
  .m02_axi_rvalid                 (vdma2_axi_rvalid),
  .m03_apb_pready                 (fc_apb_pready),
  .m03_apb_prdata                 (fc_apb_prdata),
  .m03_apb_pslverr                (fc_apb_pslverr),
  .m04_apb_pready                 (conv_apb_pready),
  .m04_apb_prdata                 (conv_apb_prdata),
  .m04_apb_pslverr                (conv_apb_pslverr),
  .m05_apb_pready                 (pool_apb_pready),
  .m05_apb_prdata                 (pool_apb_prdata),
  .m05_apb_pslverr                (pool_apb_pslverr)
  );
endmodule // dsd_example_top
