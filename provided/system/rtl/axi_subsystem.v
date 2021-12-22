module axi_subsystem
  (/*AUTOARG*/
   // Outputs
   aresetn_s00_out, aresetn_s01_out, aresetn_s02_out, aresetn_s03_out,
   aresetn_m00_out, s00_axi_awready, s00_axi_wready, s00_axi_bresp,
   s00_axi_bvalid, s00_axi_arready, s00_axi_rdata, s00_axi_rresp,
   s00_axi_rlast, s00_axi_rvalid, S01_AXI_AWREADY, S01_AXI_WREADY,
   S01_AXI_BID, S01_AXI_BRESP, S01_AXI_BVALID, S01_AXI_ARREADY,
   S01_AXI_RID, S01_AXI_RDATA, S01_AXI_RRESP, S01_AXI_RLAST,
   S01_AXI_RVALID, S02_AXI_AWREADY, S02_AXI_WREADY, S02_AXI_BID,
   S02_AXI_BRESP, S02_AXI_BVALID, S02_AXI_ARREADY, S02_AXI_RID,
   S02_AXI_RDATA, S02_AXI_RRESP, S02_AXI_RLAST, S02_AXI_RVALID,
   S03_AXI_AWREADY, S03_AXI_WREADY, S03_AXI_BID, S03_AXI_BRESP,
   S03_AXI_BVALID, S03_AXI_ARREADY, S03_AXI_RID, S03_AXI_RDATA,
   S03_AXI_RRESP, S03_AXI_RLAST, S03_AXI_RVALID, M00_AXI_AWID,
   M00_AXI_AWADDR, M00_AXI_AWLEN, M00_AXI_AWSIZE, M00_AXI_AWBURST,
   M00_AXI_AWLOCK, M00_AXI_AWCACHE, M00_AXI_AWPROT, M00_AXI_AWQOS,
   M00_AXI_AWVALID, M00_AXI_WDATA, M00_AXI_WSTRB, M00_AXI_WLAST,
   M00_AXI_WVALID, M00_AXI_BREADY, M00_AXI_ARID, M00_AXI_ARADDR,
   M00_AXI_ARLEN, M00_AXI_ARSIZE, M00_AXI_ARBURST, M00_AXI_ARLOCK,
   M00_AXI_ARCACHE, M00_AXI_ARPROT, M00_AXI_ARQOS, M00_AXI_ARVALID,
   M00_AXI_RREADY, m00_axi_awaddr, m00_axi_awprot, m00_axi_awvalid,
   m00_axi_wdata, m00_axi_wstrb, m00_axi_wvalid, m00_axi_bready,
   m00_axi_araddr, m00_axi_arprot, m00_axi_arvalid, m00_axi_rready,
   m01_axi_awaddr, m01_axi_awprot, m01_axi_awvalid, m01_axi_wdata,
   m01_axi_wstrb, m01_axi_wvalid, m01_axi_bready, m01_axi_araddr,
   m01_axi_arprot, m01_axi_arvalid, m01_axi_rready, m02_axi_awaddr,
   m02_axi_awprot, m02_axi_awvalid, m02_axi_wdata, m02_axi_wstrb,
   m02_axi_wvalid, m02_axi_bready, m02_axi_araddr, m02_axi_arprot,
   m02_axi_arvalid, m02_axi_rready, m03_apb_paddr, m03_apb_psel,
   m03_apb_penable, m03_apb_pwrite, m03_apb_pwdata, m04_apb_paddr,
   m04_apb_psel, m04_apb_penable, m04_apb_pwrite, m04_apb_pwdata,
   m05_apb_paddr, m05_apb_psel, m05_apb_penable, m05_apb_pwrite,
   m05_apb_pwdata,
   // Inputs
   aclk, aresetn, aclk_core, aclk_dram, s00_axi_awaddr, s00_axi_awlen,
   s00_axi_awsize, s00_axi_awburst, s00_axi_awlock, s00_axi_awcache,
   s00_axi_awprot, s00_axi_awqos, s00_axi_awvalid, s00_axi_wdata,
   s00_axi_wstrb, s00_axi_wlast, s00_axi_wvalid, s00_axi_bready,
   s00_axi_araddr, s00_axi_arlen, s00_axi_arsize, s00_axi_arburst,
   s00_axi_arlock, s00_axi_arcache, s00_axi_arprot, s00_axi_arqos,
   s00_axi_arvalid, s00_axi_rready, S01_AXI_AWID, S01_AXI_AWADDR,
   S01_AXI_AWLEN, S01_AXI_AWSIZE, S01_AXI_AWBURST, S01_AXI_AWLOCK,
   S01_AXI_AWCACHE, S01_AXI_AWPROT, S01_AXI_AWQOS, S01_AXI_AWVALID,
   S01_AXI_WDATA, S01_AXI_WSTRB, S01_AXI_WLAST, S01_AXI_WVALID,
   S01_AXI_BREADY, S01_AXI_ARID, S01_AXI_ARADDR, S01_AXI_ARLEN,
   S01_AXI_ARSIZE, S01_AXI_ARBURST, S01_AXI_ARLOCK, S01_AXI_ARCACHE,
   S01_AXI_ARPROT, S01_AXI_ARQOS, S01_AXI_ARVALID, S01_AXI_RREADY,
   S02_AXI_AWID, S02_AXI_AWADDR, S02_AXI_AWLEN, S02_AXI_AWSIZE,
   S02_AXI_AWBURST, S02_AXI_AWLOCK, S02_AXI_AWCACHE, S02_AXI_AWPROT,
   S02_AXI_AWQOS, S02_AXI_AWVALID, S02_AXI_WDATA, S02_AXI_WSTRB,
   S02_AXI_WLAST, S02_AXI_WVALID, S02_AXI_BREADY, S02_AXI_ARID,
   S02_AXI_ARADDR, S02_AXI_ARLEN, S02_AXI_ARSIZE, S02_AXI_ARBURST,
   S02_AXI_ARLOCK, S02_AXI_ARCACHE, S02_AXI_ARPROT, S02_AXI_ARQOS,
   S02_AXI_ARVALID, S02_AXI_RREADY, S03_AXI_AWID, S03_AXI_AWADDR,
   S03_AXI_AWLEN, S03_AXI_AWSIZE, S03_AXI_AWBURST, S03_AXI_AWLOCK,
   S03_AXI_AWCACHE, S03_AXI_AWPROT, S03_AXI_AWQOS, S03_AXI_AWVALID,
   S03_AXI_WDATA, S03_AXI_WSTRB, S03_AXI_WLAST, S03_AXI_WVALID,
   S03_AXI_BREADY, S03_AXI_ARID, S03_AXI_ARADDR, S03_AXI_ARLEN,
   S03_AXI_ARSIZE, S03_AXI_ARBURST, S03_AXI_ARLOCK, S03_AXI_ARCACHE,
   S03_AXI_ARPROT, S03_AXI_ARQOS, S03_AXI_ARVALID, S03_AXI_RREADY,
   M00_AXI_AWREADY, M00_AXI_WREADY, M00_AXI_BID, M00_AXI_BRESP,
   M00_AXI_BVALID, M00_AXI_ARREADY, M00_AXI_RID, M00_AXI_RDATA,
   M00_AXI_RRESP, M00_AXI_RLAST, M00_AXI_RVALID, m00_axi_awready,
   m00_axi_wready, m00_axi_bresp, m00_axi_bvalid, m00_axi_arready,
   m00_axi_rdata, m00_axi_rresp, m00_axi_rvalid, m01_axi_awready,
   m01_axi_wready, m01_axi_bresp, m01_axi_bvalid, m01_axi_arready,
   m01_axi_rdata, m01_axi_rresp, m01_axi_rvalid, m02_axi_awready,
   m02_axi_wready, m02_axi_bresp, m02_axi_bvalid, m02_axi_arready,
   m02_axi_rdata, m02_axi_rresp, m02_axi_rvalid, m03_apb_pready,
   m03_apb_prdata, m03_apb_pslverr, m04_apb_pready, m04_apb_prdata,
   m04_apb_pslverr, m05_apb_pready, m05_apb_prdata, m05_apb_pslverr
   );

    // clock and reset
    input          aclk;    //master clk
    input          aresetn; //master reset

    input          aclk_core; //1:1 sync to aclk
    input          aclk_dram; //async to aclk

    //   input aresetn_core;
    //   input aresetn_dram;

    output         aresetn_s00_out;
    output         aresetn_s01_out;
    output         aresetn_s02_out;
    output         aresetn_s03_out;

    output         aresetn_m00_out;

    // all ports of axi_crossbar_0 except clock and reset
    input [31:0]   s00_axi_awaddr;
    input [7:0]    s00_axi_awlen;
    input [2:0]    s00_axi_awsize;
    input [1:0]    s00_axi_awburst;
    input [0:0]    s00_axi_awlock;
    input [3:0]    s00_axi_awcache;
    input [2:0]    s00_axi_awprot;
    input [3:0]    s00_axi_awqos;
    input [0:0]    s00_axi_awvalid;
    output [0:0]   s00_axi_awready;
    input [31:0]   s00_axi_wdata;
    input [3:0]    s00_axi_wstrb;
    input [0:0]    s00_axi_wlast;
    input [0:0]    s00_axi_wvalid;
    output [0:0]   s00_axi_wready;
    output [1:0]   s00_axi_bresp;
    output [0:0]   s00_axi_bvalid;
    input [0:0]    s00_axi_bready;
    input [31:0]   s00_axi_araddr;
    input [7:0]    s00_axi_arlen;
    input [2:0]    s00_axi_arsize;
    input [1:0]    s00_axi_arburst;
    input [0:0]    s00_axi_arlock;
    input [3:0]    s00_axi_arcache;
    input [2:0]    s00_axi_arprot;
    input [3:0]    s00_axi_arqos;
    input [0:0]    s00_axi_arvalid;
    output [0:0]   s00_axi_arready;
    output [31:0]  s00_axi_rdata;
    output [1:0]   s00_axi_rresp;
    output [0:0]   s00_axi_rlast;
    output [0:0]   s00_axi_rvalid;
    input [0:0]    s00_axi_rready;

    // s01, s02, s03, m00 ports of axi_interconnect except clock and reset
    input [0:0]    S01_AXI_AWID;
    input [31:0]   S01_AXI_AWADDR;
    input [7:0]    S01_AXI_AWLEN;
    input [2:0]    S01_AXI_AWSIZE;
    input [1:0]    S01_AXI_AWBURST;
    input          S01_AXI_AWLOCK;
    input [3:0]    S01_AXI_AWCACHE;
    input [2:0]    S01_AXI_AWPROT;
    input [3:0]    S01_AXI_AWQOS;
    input          S01_AXI_AWVALID;
    output         S01_AXI_AWREADY;
    input [63:0]   S01_AXI_WDATA;
    input [7:0]    S01_AXI_WSTRB;
    input          S01_AXI_WLAST;
    input          S01_AXI_WVALID;
    output         S01_AXI_WREADY;
    output [0:0]   S01_AXI_BID;
    output [1:0]   S01_AXI_BRESP;
    output         S01_AXI_BVALID;
    input          S01_AXI_BREADY;
    input [0:0]    S01_AXI_ARID;
    input [31:0]   S01_AXI_ARADDR;
    input [7:0]    S01_AXI_ARLEN;
    input [2:0]    S01_AXI_ARSIZE;
    input [1:0]    S01_AXI_ARBURST;
    input          S01_AXI_ARLOCK;
    input [3:0]    S01_AXI_ARCACHE;
    input [2:0]    S01_AXI_ARPROT;
    input [3:0]    S01_AXI_ARQOS;
    input          S01_AXI_ARVALID;
    output         S01_AXI_ARREADY;
    output [0:0]   S01_AXI_RID;
    output [63:0]  S01_AXI_RDATA;
    output [1:0]   S01_AXI_RRESP;
    output         S01_AXI_RLAST;
    output         S01_AXI_RVALID;
    input          S01_AXI_RREADY;

    input [0:0]    S02_AXI_AWID;
    input [31:0]   S02_AXI_AWADDR;
    input [7:0]    S02_AXI_AWLEN;
    input [2:0]    S02_AXI_AWSIZE;
    input [1:0]    S02_AXI_AWBURST;
    input          S02_AXI_AWLOCK;
    input [3:0]    S02_AXI_AWCACHE;
    input [2:0]    S02_AXI_AWPROT;
    input [3:0]    S02_AXI_AWQOS;
    input          S02_AXI_AWVALID;
    output         S02_AXI_AWREADY;
    input [63:0]   S02_AXI_WDATA;
    input [7:0]    S02_AXI_WSTRB;
    input          S02_AXI_WLAST;
    input          S02_AXI_WVALID;
    output         S02_AXI_WREADY;
    output [0:0]   S02_AXI_BID;
    output [1:0]   S02_AXI_BRESP;
    output         S02_AXI_BVALID;
    input          S02_AXI_BREADY;
    input [0:0]    S02_AXI_ARID;
    input [31:0]   S02_AXI_ARADDR;
    input [7:0]    S02_AXI_ARLEN;
    input [2:0]    S02_AXI_ARSIZE;
    input [1:0]    S02_AXI_ARBURST;
    input          S02_AXI_ARLOCK;
    input [3:0]    S02_AXI_ARCACHE;
    input [2:0]    S02_AXI_ARPROT;
    input [3:0]    S02_AXI_ARQOS;
    input          S02_AXI_ARVALID;
    output         S02_AXI_ARREADY;
    output [0:0]   S02_AXI_RID;
    output [63:0]  S02_AXI_RDATA;
    output [1:0]   S02_AXI_RRESP;
    output         S02_AXI_RLAST;
    output         S02_AXI_RVALID;
    input          S02_AXI_RREADY;

    input [0:0]    S03_AXI_AWID;
    input [31:0]   S03_AXI_AWADDR;
    input [7:0]    S03_AXI_AWLEN;
    input [2:0]    S03_AXI_AWSIZE;
    input [1:0]    S03_AXI_AWBURST;
    input          S03_AXI_AWLOCK;
    input [3:0]    S03_AXI_AWCACHE;
    input [2:0]    S03_AXI_AWPROT;
    input [3:0]    S03_AXI_AWQOS;
    input          S03_AXI_AWVALID;
    output         S03_AXI_AWREADY;
    input [63:0]   S03_AXI_WDATA;
    input [7:0]    S03_AXI_WSTRB;
    input          S03_AXI_WLAST;
    input          S03_AXI_WVALID;
    output         S03_AXI_WREADY;
    output [0:0]   S03_AXI_BID;
    output [1:0]   S03_AXI_BRESP;
    output         S03_AXI_BVALID;
    input          S03_AXI_BREADY;
    input [0:0]    S03_AXI_ARID;
    input [31:0]   S03_AXI_ARADDR;
    input [7:0]    S03_AXI_ARLEN;
    input [2:0]    S03_AXI_ARSIZE;
    input [1:0]    S03_AXI_ARBURST;
    input          S03_AXI_ARLOCK;
    input [3:0]    S03_AXI_ARCACHE;
    input [2:0]    S03_AXI_ARPROT;
    input [3:0]    S03_AXI_ARQOS;
    input          S03_AXI_ARVALID;
    output         S03_AXI_ARREADY;
    output [0:0]   S03_AXI_RID;
    output [63:0]  S03_AXI_RDATA;
    output [1:0]   S03_AXI_RRESP;
    output         S03_AXI_RLAST;
    output         S03_AXI_RVALID;
    input          S03_AXI_RREADY;

    //   output   M00_AXI_ARESET_OUT_N;
    //   input    M00_AXI_ACLK;
    output [3:0]   M00_AXI_AWID;
    output [31:0]  M00_AXI_AWADDR;
    output [7:0]   M00_AXI_AWLEN;
    output [2:0]   M00_AXI_AWSIZE;
    output [1:0]   M00_AXI_AWBURST;
    output         M00_AXI_AWLOCK;
    output [3:0]   M00_AXI_AWCACHE;
    output [2:0]   M00_AXI_AWPROT;
    output [3:0]   M00_AXI_AWQOS;
    output         M00_AXI_AWVALID;
    input          M00_AXI_AWREADY;
    output [127:0] M00_AXI_WDATA;
    output [15:0]  M00_AXI_WSTRB;
    output         M00_AXI_WLAST;
    output         M00_AXI_WVALID;
    input          M00_AXI_WREADY;
    input [3:0]    M00_AXI_BID;
    input [1:0]    M00_AXI_BRESP;
    input          M00_AXI_BVALID;
    output         M00_AXI_BREADY;
    output [3:0]   M00_AXI_ARID;
    output [31:0]  M00_AXI_ARADDR;
    output [7:0]   M00_AXI_ARLEN;
    output [2:0]   M00_AXI_ARSIZE;
    output [1:0]   M00_AXI_ARBURST;
    output         M00_AXI_ARLOCK;
    output [3:0]   M00_AXI_ARCACHE;
    output [2:0]   M00_AXI_ARPROT;
    output [3:0]   M00_AXI_ARQOS;
    output         M00_AXI_ARVALID;
    input          M00_AXI_ARREADY;
    input [3:0]    M00_AXI_RID;
    input [127:0]  M00_AXI_RDATA;
    input [1:0]    M00_AXI_RRESP;
    input          M00_AXI_RLAST;
    input          M00_AXI_RVALID;
    output         M00_AXI_RREADY;

    // m0, m01, m02, m03, m05 ports of axi_crossbar_1 except clock and reset
    output [31:0]  m00_axi_awaddr;
    output [2:0]   m00_axi_awprot;
    output [0:0]   m00_axi_awvalid;
    input [0:0]    m00_axi_awready;
    output [31:0]  m00_axi_wdata;
    output [3:0]   m00_axi_wstrb;
    output [0:0]   m00_axi_wvalid;
    input [0:0]    m00_axi_wready;
    input [1:0]    m00_axi_bresp;
    input [0:0]    m00_axi_bvalid;
    output [0:0]   m00_axi_bready;
    output [31:0]  m00_axi_araddr;
    output [2:0]   m00_axi_arprot;
    output [0:0]   m00_axi_arvalid;
    input [0:0]    m00_axi_arready;
    input [31:0]   m00_axi_rdata;
    input [1:0]    m00_axi_rresp;
    input [0:0]    m00_axi_rvalid;
    output [0:0]   m00_axi_rready;

    output [31:0]  m01_axi_awaddr;
    output [2:0]   m01_axi_awprot;
    output [0:0]   m01_axi_awvalid;
    input [0:0]    m01_axi_awready;
    output [31:0]  m01_axi_wdata;
    output [3:0]   m01_axi_wstrb;
    output [0:0]   m01_axi_wvalid;
    input [0:0]    m01_axi_wready;
    input [1:0]    m01_axi_bresp;
    input [0:0]    m01_axi_bvalid;
    output [0:0]   m01_axi_bready;
    output [31:0]  m01_axi_araddr;
    output [2:0]   m01_axi_arprot;
    output [0:0]   m01_axi_arvalid;
    input [0:0]    m01_axi_arready;
    input [31:0]   m01_axi_rdata;
    input [1:0]    m01_axi_rresp;
    input [0:0]    m01_axi_rvalid;
    output [0:0]   m01_axi_rready;

    output [31:0]  m02_axi_awaddr;
    output [2:0]   m02_axi_awprot;
    output [0:0]   m02_axi_awvalid;
    input [0:0]    m02_axi_awready;
    output [31:0]  m02_axi_wdata;
    output [3:0]   m02_axi_wstrb;
    output [0:0]   m02_axi_wvalid;
    input [0:0]    m02_axi_wready;
    input [1:0]    m02_axi_bresp;
    input [0:0]    m02_axi_bvalid;
    output [0:0]   m02_axi_bready;
    output [31:0]  m02_axi_araddr;
    output [2:0]   m02_axi_arprot;
    output [0:0]   m02_axi_arvalid;
    input [0:0]    m02_axi_arready;
    input [31:0]   m02_axi_rdata;
    input [1:0]    m02_axi_rresp;
    input [0:0]    m02_axi_rvalid;
    output [0:0]   m02_axi_rready;

    output [31:0]  m03_apb_paddr;
    output [0:0]   m03_apb_psel;
    output         m03_apb_penable;
    output         m03_apb_pwrite;
    output [31:0]  m03_apb_pwdata;
    input [0:0]    m03_apb_pready;
    input [31:0]   m03_apb_prdata;
    input [0:0]    m03_apb_pslverr;
    output [31:0]  m04_apb_paddr;
    output [0:0]   m04_apb_psel;
    output         m04_apb_penable;
    output         m04_apb_pwrite;
    output [31:0]  m04_apb_pwdata;
    input [0:0]    m04_apb_pready;
    input [31:0]   m04_apb_prdata;
    input [0:0]    m04_apb_pslverr;
    output [31:0]  m05_apb_paddr;
    output [0:0]   m05_apb_psel;
    output         m05_apb_penable;
    output         m05_apb_pwrite;
    output [31:0]  m05_apb_pwdata;
    input [0:0]    m05_apb_pready;
    input [31:0]   m05_apb_prdata;
    input [0:0]    m05_apb_pslverr;



    wire [31:0]    m03_axi_awaddr;
    wire [2:0]     m03_axi_awprot;
    wire [0:0]     m03_axi_awvalid;
    wire [0:0]     m03_axi_awready;
    wire [31:0]    m03_axi_wdata;
    wire [3:0]     m03_axi_wstrb;
    wire [0:0]     m03_axi_wvalid;
    wire [0:0]     m03_axi_wready;
    wire [1:0]     m03_axi_bresp;
    wire [0:0]     m03_axi_bvalid;
    wire [0:0]     m03_axi_bready;
    wire [31:0]    m03_axi_araddr;
    wire [2:0]     m03_axi_arprot;
    wire [0:0]     m03_axi_arvalid;
    wire [0:0]     m03_axi_arready;
    wire [31:0]    m03_axi_rdata;
    wire [1:0]     m03_axi_rresp;
    wire [0:0]     m03_axi_rvalid;
    wire [0:0]     m03_axi_rready;

    wire [31:0]    m04_axi_awaddr;
    wire [2:0]     m04_axi_awprot;
    wire [0:0]     m04_axi_awvalid;
    wire [0:0]     m04_axi_awready;
    wire [31:0]    m04_axi_wdata;
    wire [3:0]     m04_axi_wstrb;
    wire [0:0]     m04_axi_wvalid;
    wire [0:0]     m04_axi_wready;
    wire [1:0]     m04_axi_bresp;
    wire [0:0]     m04_axi_bvalid;
    wire [0:0]     m04_axi_bready;
    wire [31:0]    m04_axi_araddr;
    wire [2:0]     m04_axi_arprot;
    wire [0:0]     m04_axi_arvalid;
    wire [0:0]     m04_axi_arready;
    wire [31:0]    m04_axi_rdata;
    wire [1:0]     m04_axi_rresp;
    wire [0:0]     m04_axi_rvalid;
    wire [0:0]     m04_axi_rready;

    wire [31:0]    m05_axi_awaddr;
    wire [2:0]     m05_axi_awprot;
    wire [0:0]     m05_axi_awvalid;
    wire [0:0]     m05_axi_awready;
    wire [31:0]    m05_axi_wdata;
    wire [3:0]     m05_axi_wstrb;
    wire [0:0]     m05_axi_wvalid;
    wire [0:0]     m05_axi_wready;
    wire [1:0]     m05_axi_bresp;
    wire [0:0]     m05_axi_bvalid;
    wire [0:0]     m05_axi_bready;
    wire [31:0]    m05_axi_araddr;
    wire [2:0]     m05_axi_arprot;
    wire [0:0]     m05_axi_arvalid;
    wire [0:0]     m05_axi_arready;
    wire [31:0]    m05_axi_rdata;
    wire [1:0]     m05_axi_rresp;
    wire [0:0]     m05_axi_rvalid;
    wire [0:0]     m05_axi_rready;


    wire [31:0]    m00_s00_axi_awaddr;
    wire [7:0]     m00_s00_axi_awlen;
    wire [2:0]     m00_s00_axi_awsize;
    wire [1:0]     m00_s00_axi_awburst;
    wire [0:0]     m00_s00_axi_awlock;
    wire [3:0]     m00_s00_axi_awcache;
    wire [2:0]     m00_s00_axi_awprot;
    wire [3:0]     m00_s00_axi_awregion;
    wire [3:0]     m00_s00_axi_awqos;
    wire [0:0]     m00_s00_axi_awvalid;
    wire [0:0]     m00_s00_axi_awready;
    wire [31:0]    m00_s00_axi_wdata;
    wire [3:0]     m00_s00_axi_wstrb;
    wire [0:0]     m00_s00_axi_wlast;
    wire [0:0]     m00_s00_axi_wvalid;
    wire [0:0]     m00_s00_axi_wready;
    wire [1:0]     m00_s00_axi_bresp;
    wire [0:0]     m00_s00_axi_bvalid;
    wire [0:0]     m00_s00_axi_bready;
    wire [31:0]    m00_s00_axi_araddr;
    wire [7:0]     m00_s00_axi_arlen;
    wire [2:0]     m00_s00_axi_arsize;
    wire [1:0]     m00_s00_axi_arburst;
    wire [0:0]     m00_s00_axi_arlock;
    wire [3:0]     m00_s00_axi_arcache;
    wire [2:0]     m00_s00_axi_arprot;
    wire [3:0]     m00_s00_axi_arregion;
    wire [3:0]     m00_s00_axi_arqos;
    wire [0:0]     m00_s00_axi_arvalid;
    wire [0:0]     m00_s00_axi_arready;
    wire [31:0]    m00_s00_axi_rdata;
    wire [1:0]     m00_s00_axi_rresp;
    wire [0:0]     m00_s00_axi_rlast;
    wire [0:0]     m00_s00_axi_rvalid;
    wire [0:0]     m00_s00_axi_rready;


    wire [31:0]    m01_s00_axi_awaddr;
    wire [7:0]     m01_s00_axi_awlen;
    wire [2:0]     m01_s00_axi_awsize;
    wire [1:0]     m01_s00_axi_awburst;
    wire [0:0]     m01_s00_axi_awlock;
    wire [3:0]     m01_s00_axi_awcache;
    wire [2:0]     m01_s00_axi_awprot;
    wire [3:0]     m01_s00_axi_awregion;
    wire [3:0]     m01_s00_axi_awqos;
    wire [0:0]     m01_s00_axi_awvalid;
    wire [0:0]     m01_s00_axi_awready;
    wire [31:0]    m01_s00_axi_wdata;
    wire [3:0]     m01_s00_axi_wstrb;
    wire [0:0]     m01_s00_axi_wlast;
    wire [0:0]     m01_s00_axi_wvalid;
    wire [0:0]     m01_s00_axi_wready;
    wire [1:0]     m01_s00_axi_bresp;
    wire [0:0]     m01_s00_axi_bvalid;
    wire [0:0]     m01_s00_axi_bready;
    wire [31:0]    m01_s00_axi_araddr;
    wire [7:0]     m01_s00_axi_arlen;
    wire [2:0]     m01_s00_axi_arsize;
    wire [1:0]     m01_s00_axi_arburst;
    wire [0:0]     m01_s00_axi_arlock;
    wire [3:0]     m01_s00_axi_arcache;
    wire [2:0]     m01_s00_axi_arprot;
    wire [3:0]     m01_s00_axi_arregion;
    wire [3:0]     m01_s00_axi_arqos;
    wire [0:0]     m01_s00_axi_arvalid;
    wire [0:0]     m01_s00_axi_arready;
    wire [31:0]    m01_s00_axi_rdata;
    wire [1:0]     m01_s00_axi_rresp;
    wire [0:0]     m01_s00_axi_rlast;
    wire [0:0]     m01_s00_axi_rvalid;
    wire [0:0]     m01_s00_axi_rready;

    //wire for connect axi - axilite
    wire [31:0]    m00_s00_axil_awaddr;
    wire [2:0]     m00_s00_axil_awprot;
    wire [0:0]     m00_s00_axil_awvalid;
    wire [0:0]     m00_s00_axil_awready;
    wire [31:0]    m00_s00_axil_wdata;
    wire [3:0]     m00_s00_axil_wstrb;
    wire [0:0]     m00_s00_axil_wvalid;
    wire [0:0]     m00_s00_axil_wready;
    wire [1:0]     m00_s00_axil_bresp;
    wire [0:0]     m00_s00_axil_bvalid;
    wire [0:0]     m00_s00_axil_bready;
    wire [31:0]    m00_s00_axil_araddr;
    wire [2:0]     m00_s00_axil_arprot;
    wire [0:0]     m00_s00_axil_arvalid;
    wire [0:0]     m00_s00_axil_arready;
    wire [31:0]    m00_s00_axil_rdata;
    wire [1:0]     m00_s00_axil_rresp;
    wire [0:0]     m00_s00_axil_rvalid;
    wire [0:0]     m00_s00_axil_rready;


    axi_crossbar_0_top
      u_axi_splitter
        (
         // Outputs
         .s00_axi_awready        (s00_axi_awready[0:0]),
         .s00_axi_wready         (s00_axi_wready[0:0]),
         .s00_axi_bresp          (s00_axi_bresp[1:0]),
         .s00_axi_bvalid         (s00_axi_bvalid[0:0]),
         .s00_axi_arready        (s00_axi_arready[0:0]),
         .s00_axi_rdata          (s00_axi_rdata[31:0]),
         .s00_axi_rresp          (s00_axi_rresp[1:0]),
         .s00_axi_rlast          (s00_axi_rlast[0:0]),
         .s00_axi_rvalid         (s00_axi_rvalid[0:0]),
         .m00_axi_awaddr         (m00_s00_axi_awaddr[31:0]),
         .m00_axi_awlen          (m00_s00_axi_awlen[7:0]),
         .m00_axi_awsize         (m00_s00_axi_awsize[2:0]),
         .m00_axi_awburst        (m00_s00_axi_awburst[1:0]),
         .m00_axi_awlock         (m00_s00_axi_awlock[0:0]),
         .m00_axi_awcache        (m00_s00_axi_awcache[3:0]),
         .m00_axi_awprot         (m00_s00_axi_awprot[2:0]),
         .m00_axi_awregion       (m00_s00_axi_awregion[3:0]),
         .m00_axi_awqos          (m00_s00_axi_awqos[3:0]),
         .m00_axi_awvalid        (m00_s00_axi_awvalid[0:0]),
         .m00_axi_wdata          (m00_s00_axi_wdata[31:0]),
         .m00_axi_wstrb          (m00_s00_axi_wstrb[3:0]),
         .m00_axi_wlast          (m00_s00_axi_wlast[0:0]),
         .m00_axi_wvalid         (m00_s00_axi_wvalid[0:0]),
         .m00_axi_bready         (m00_s00_axi_bready[0:0]),
         .m00_axi_araddr         (m00_s00_axi_araddr[31:0]),
         .m00_axi_arlen          (m00_s00_axi_arlen[7:0]),
         .m00_axi_arsize         (m00_s00_axi_arsize[2:0]),
         .m00_axi_arburst        (m00_s00_axi_arburst[1:0]),
         .m00_axi_arlock         (m00_s00_axi_arlock[0:0]),
         .m00_axi_arcache        (m00_s00_axi_arcache[3:0]),
         .m00_axi_arprot         (m00_s00_axi_arprot[2:0]),
         .m00_axi_arregion       (m00_s00_axi_arregion[3:0]),
         .m00_axi_arqos          (m00_s00_axi_arqos[3:0]),
         .m00_axi_arvalid        (m00_s00_axi_arvalid[0:0]),
         .m00_axi_rready         (m00_s00_axi_rready[0:0]),
         .m01_axi_awaddr         (m01_s00_axi_awaddr[31:0]),
         .m01_axi_awlen          (m01_s00_axi_awlen[7:0]),
         .m01_axi_awsize         (m01_s00_axi_awsize[2:0]),
         .m01_axi_awburst        (m01_s00_axi_awburst[1:0]),
         .m01_axi_awlock         (m01_s00_axi_awlock[0:0]),
         .m01_axi_awcache        (m01_s00_axi_awcache[3:0]),
         .m01_axi_awprot         (m01_s00_axi_awprot[2:0]),
         .m01_axi_awregion       (m01_s00_axi_awregion[3:0]),
         .m01_axi_awqos          (m01_s00_axi_awqos[3:0]),
         .m01_axi_awvalid        (m01_s00_axi_awvalid[0:0]),
         .m01_axi_wdata          (m01_s00_axi_wdata[31:0]),
         .m01_axi_wstrb          (m01_s00_axi_wstrb[3:0]),
         .m01_axi_wlast          (m01_s00_axi_wlast[0:0]),
         .m01_axi_wvalid         (m01_s00_axi_wvalid[0:0]),
         .m01_axi_bready         (m01_s00_axi_bready[0:0]),
         .m01_axi_araddr         (m01_s00_axi_araddr[31:0]),
         .m01_axi_arlen          (m01_s00_axi_arlen[7:0]),
         .m01_axi_arsize         (m01_s00_axi_arsize[2:0]),
         .m01_axi_arburst        (m01_s00_axi_arburst[1:0]),
         .m01_axi_arlock         (m01_s00_axi_arlock[0:0]),
         .m01_axi_arcache        (m01_s00_axi_arcache[3:0]),
         .m01_axi_arprot         (m01_s00_axi_arprot[2:0]),
         .m01_axi_arregion       (m01_s00_axi_arregion[3:0]),
         .m01_axi_arqos          (m01_s00_axi_arqos[3:0]),
         .m01_axi_arvalid        (m01_s00_axi_arvalid[0:0]),
         .m01_axi_rready         (m01_s00_axi_rready[0:0]),
         // Inputs
         .aclk               (aclk_core),
         .aresetn            (aresetn_s00_out), //from interconnect
         .s00_axi_awaddr         (s00_axi_awaddr[31:0]),
         .s00_axi_awlen          (s00_axi_awlen[7:0]),
         .s00_axi_awsize         (s00_axi_awsize[2:0]),
         .s00_axi_awburst        (s00_axi_awburst[1:0]),
         .s00_axi_awlock         (s00_axi_awlock[0:0]),
         .s00_axi_awcache        (s00_axi_awcache[3:0]),
         .s00_axi_awprot         (s00_axi_awprot[2:0]),
         .s00_axi_awqos          (s00_axi_awqos[3:0]),
         .s00_axi_awvalid        (s00_axi_awvalid[0:0]),
         .s00_axi_wdata          (s00_axi_wdata[31:0]),
         .s00_axi_wstrb          (s00_axi_wstrb[3:0]),
         .s00_axi_wlast          (s00_axi_wlast[0:0]),
         .s00_axi_wvalid         (s00_axi_wvalid[0:0]),
         .s00_axi_bready         (s00_axi_bready[0:0]),
         .s00_axi_araddr         (s00_axi_araddr[31:0]),
         .s00_axi_arlen          (s00_axi_arlen[7:0]),
         .s00_axi_arsize         (s00_axi_arsize[2:0]),
         .s00_axi_arburst        (s00_axi_arburst[1:0]),
         .s00_axi_arlock         (s00_axi_arlock[0:0]),
         .s00_axi_arcache        (s00_axi_arcache[3:0]),
         .s00_axi_arprot         (s00_axi_arprot[2:0]),
         .s00_axi_arqos          (s00_axi_arqos[3:0]),
         .s00_axi_arvalid        (s00_axi_arvalid[0:0]),
         .s00_axi_rready         (s00_axi_rready[0:0]),

         .m00_axi_awready        (m00_s00_axi_awready[0:0]),
         .m00_axi_wready         (m00_s00_axi_wready[0:0]),
         .m00_axi_bresp          (m00_s00_axi_bresp[1:0]),
         .m00_axi_bvalid         (m00_s00_axi_bvalid[0:0]),
         .m00_axi_arready        (m00_s00_axi_arready[0:0]),
         .m00_axi_rdata          (m00_s00_axi_rdata[31:0]),
         .m00_axi_rresp          (m00_s00_axi_rresp[1:0]),
         .m00_axi_rlast          (m00_s00_axi_rlast[0:0]),
         .m00_axi_rvalid         (m00_s00_axi_rvalid[0:0]),

         .m01_axi_awready        (m01_s00_axi_awready[0:0]),
         .m01_axi_wready         (m01_s00_axi_wready[0:0]),
         .m01_axi_bresp          (m01_s00_axi_bresp[1:0]),
         .m01_axi_bvalid         (m01_s00_axi_bvalid[0:0]),
         .m01_axi_arready        (m01_s00_axi_arready[0:0]),
         .m01_axi_rdata          (m01_s00_axi_rdata[31:0]),
         .m01_axi_rresp          (m01_s00_axi_rresp[1:0]),
         .m01_axi_rlast          (m01_s00_axi_rlast[0:0]),
         .m01_axi_rvalid         (m01_s00_axi_rvalid[0:0]));

    //crossbar0 m01 to s of here
    //here m to crossbar1 s00
    axi4_32_to_axilite
      u_axi_to_axilite
        (
         // Outputs
         .s_axi_awready          (m01_s00_axi_awready),
         .s_axi_wready           (m01_s00_axi_wready),
         .s_axi_bresp            (m01_s00_axi_bresp[1:0]),
         .s_axi_bvalid           (m01_s00_axi_bvalid),
         .s_axi_arready          (m01_s00_axi_arready),
         .s_axi_rdata            (m01_s00_axi_rdata[31:0]),
         .s_axi_rresp            (m01_s00_axi_rresp[1:0]),
         .s_axi_rlast            (m01_s00_axi_rlast),
         .s_axi_rvalid           (m01_s00_axi_rvalid),

         .m_axi_awaddr           (m00_s00_axil_awaddr[31:0]),
         .m_axi_awprot           (m00_s00_axil_awprot[2:0]),
         .m_axi_awvalid          (m00_s00_axil_awvalid),
         .m_axi_wdata            (m00_s00_axil_wdata[31:0]),
         .m_axi_wstrb            (m00_s00_axil_wstrb[3:0]),
         .m_axi_wvalid           (m00_s00_axil_wvalid),
         .m_axi_bready           (m00_s00_axil_bready),
         .m_axi_araddr           (m00_s00_axil_araddr[31:0]),
         .m_axi_arprot           (m00_s00_axil_arprot[2:0]),
         .m_axi_arvalid          (m00_s00_axil_arvalid),
         .m_axi_rready           (m00_s00_axil_rready),

         // Inputs
         .aclk               (aclk_core),
         .aresetn            (aresetn_s00_out),

         .s_axi_awaddr           (m01_s00_axi_awaddr[31:0]),
         .s_axi_awlen            ({4'b0,m01_s00_axi_awlen[3:0]}), //only supports 4bit
         .s_axi_awsize           (m01_s00_axi_awsize[2:0]),
         .s_axi_awburst          (m01_s00_axi_awburst[1:0]),
         .s_axi_awlock           (1'b0),//({1'b0,m01_s00_axi_awlock[0:0]}),
         .s_axi_awcache          (m01_s00_axi_awcache[3:0]),
         .s_axi_awprot           (m01_s00_axi_awprot[2:0]),
         .s_axi_awregion         (m01_s00_axi_awregion[3:0]),//
         .s_axi_awqos            (m01_s00_axi_awqos[3:0]),
         .s_axi_awvalid          (m01_s00_axi_awvalid),
         .s_axi_wdata            (m01_s00_axi_wdata[31:0]),
         .s_axi_wstrb            (m01_s00_axi_wstrb[3:0]),
         .s_axi_wlast            (m01_s00_axi_wlast),
         .s_axi_wvalid           (m01_s00_axi_wvalid),
         .s_axi_bready           (m01_s00_axi_bready),
         .s_axi_araddr           (m01_s00_axi_araddr[31:0]),
         .s_axi_arlen            ({4'b0,m01_s00_axi_arlen[3:0]}), //only supports 4bit
         .s_axi_arsize           (m01_s00_axi_arsize[2:0]),
         .s_axi_arburst          (m01_s00_axi_arburst[1:0]),
         .s_axi_arlock           (m01_s00_axi_arlock[0:0]),
         .s_axi_arcache          (m01_s00_axi_arcache[3:0]),
         .s_axi_arprot           (m01_s00_axi_arprot[2:0]),
         .s_axi_arregion         (m01_s00_axi_arregion[3:0]),
         .s_axi_arqos            (m01_s00_axi_arqos[3:0]),
         .s_axi_arvalid          (m01_s00_axi_arvalid),
         .s_axi_rready           (m01_s00_axi_rready),

         .m_axi_awready          (m00_s00_axil_awready),
         .m_axi_wready           (m00_s00_axil_wready),
         .m_axi_bresp            (m00_s00_axil_bresp[1:0]),
         .m_axi_bvalid           (m00_s00_axil_bvalid),
         .m_axi_arready          (m00_s00_axil_arready),
         .m_axi_rdata            (m00_s00_axil_rdata[31:0]),
         .m_axi_rresp            (m00_s00_axil_rresp[1:0]),
         .m_axi_rvalid           (m00_s00_axil_rvalid));

    axi_interconnect_1 //s00 s01 sync, m00 async
      u_axi_datapath0
        (
         // Outputs
         .S00_AXI_ARESET_OUT_N   (aresetn_s00_out),
         .S00_AXI_AWREADY        (m00_s00_axi_awready),
         .S00_AXI_WREADY         (m00_s00_axi_wready),
         .S00_AXI_BID            (),//float
         .S00_AXI_BRESP          (m00_s00_axi_bresp[1:0]),
         .S00_AXI_BVALID         (m00_s00_axi_bvalid),
         .S00_AXI_ARREADY        (m00_s00_axi_arready),
         .S00_AXI_RID            (),//float
         .S00_AXI_RDATA          (m00_s00_axi_rdata[31:0]),
         .S00_AXI_RRESP          (m00_s00_axi_rresp[1:0]),
         .S00_AXI_RLAST          (m00_s00_axi_rlast),
         .S00_AXI_RVALID         (m00_s00_axi_rvalid),
         .S01_AXI_ARESET_OUT_N   (aresetn_s01_out),
         .S01_AXI_AWREADY        (S01_AXI_AWREADY),
         .S01_AXI_WREADY         (S01_AXI_WREADY),
         .S01_AXI_BID            (S01_AXI_BID[0:0]),
         .S01_AXI_BRESP          (S01_AXI_BRESP[1:0]),
         .S01_AXI_BVALID         (S01_AXI_BVALID),
         .S01_AXI_ARREADY        (S01_AXI_ARREADY),
         .S01_AXI_RID            (S01_AXI_RID[0:0]),
         .S01_AXI_RDATA          (S01_AXI_RDATA[63:0]),
         .S01_AXI_RRESP          (S01_AXI_RRESP[1:0]),
         .S01_AXI_RLAST          (S01_AXI_RLAST),
         .S01_AXI_RVALID         (S01_AXI_RVALID),
         .S02_AXI_ARESET_OUT_N   (aresetn_s02_out),
         .S02_AXI_AWREADY        (S02_AXI_AWREADY),
         .S02_AXI_WREADY         (S02_AXI_WREADY),
         .S02_AXI_BID            (S02_AXI_BID[0:0]),
         .S02_AXI_BRESP          (S02_AXI_BRESP[1:0]),
         .S02_AXI_BVALID         (S02_AXI_BVALID),
         .S02_AXI_ARREADY        (S02_AXI_ARREADY),
         .S02_AXI_RID            (S02_AXI_RID[0:0]),
         .S02_AXI_RDATA          (S02_AXI_RDATA[63:0]),
         .S02_AXI_RRESP          (S02_AXI_RRESP[1:0]),
         .S02_AXI_RLAST          (S02_AXI_RLAST),
         .S02_AXI_RVALID         (S02_AXI_RVALID),
         .S03_AXI_ARESET_OUT_N   (aresetn_s03_out),
         .S03_AXI_AWREADY        (S03_AXI_AWREADY),
         .S03_AXI_WREADY         (S03_AXI_WREADY),
         .S03_AXI_BID            (S03_AXI_BID[0:0]),
         .S03_AXI_BRESP          (S03_AXI_BRESP[1:0]),
         .S03_AXI_BVALID         (S03_AXI_BVALID),
         .S03_AXI_ARREADY        (S03_AXI_ARREADY),
         .S03_AXI_RID            (S03_AXI_RID[0:0]),
         .S03_AXI_RDATA          (S03_AXI_RDATA[63:0]),
         .S03_AXI_RRESP          (S03_AXI_RRESP[1:0]),
         .S03_AXI_RLAST          (S03_AXI_RLAST),
         .S03_AXI_RVALID         (S03_AXI_RVALID),
         .M00_AXI_ARESET_OUT_N   (aresetn_m00_out),
         .M00_AXI_AWID           (M00_AXI_AWID[3:0]),
         .M00_AXI_AWADDR         (M00_AXI_AWADDR[31:0]),
         .M00_AXI_AWLEN          (M00_AXI_AWLEN[7:0]),
         .M00_AXI_AWSIZE         (M00_AXI_AWSIZE[2:0]),
         .M00_AXI_AWBURST        (M00_AXI_AWBURST[1:0]),
         .M00_AXI_AWLOCK         (M00_AXI_AWLOCK),
         .M00_AXI_AWCACHE        (M00_AXI_AWCACHE[3:0]),
         .M00_AXI_AWPROT         (M00_AXI_AWPROT[2:0]),
         .M00_AXI_AWQOS          (M00_AXI_AWQOS[3:0]),
         .M00_AXI_AWVALID        (M00_AXI_AWVALID),
         .M00_AXI_WDATA          (M00_AXI_WDATA[127:0]),
         .M00_AXI_WSTRB          (M00_AXI_WSTRB[15:0]),
         .M00_AXI_WLAST          (M00_AXI_WLAST),
         .M00_AXI_WVALID         (M00_AXI_WVALID),
         .M00_AXI_BREADY         (M00_AXI_BREADY),
         .M00_AXI_ARID           (M00_AXI_ARID[3:0]),
         .M00_AXI_ARADDR         (M00_AXI_ARADDR[31:0]),
         .M00_AXI_ARLEN          (M00_AXI_ARLEN[7:0]),
         .M00_AXI_ARSIZE         (M00_AXI_ARSIZE[2:0]),
         .M00_AXI_ARBURST        (M00_AXI_ARBURST[1:0]),
         .M00_AXI_ARLOCK         (M00_AXI_ARLOCK),
         .M00_AXI_ARCACHE        (M00_AXI_ARCACHE[3:0]),
         .M00_AXI_ARPROT         (M00_AXI_ARPROT[2:0]),
         .M00_AXI_ARQOS          (M00_AXI_ARQOS[3:0]),
         .M00_AXI_ARVALID        (M00_AXI_ARVALID),
         .M00_AXI_RREADY         (M00_AXI_RREADY),
         // Inputs
         .INTERCONNECT_ACLK      (aclk),
         .INTERCONNECT_ARESETN   (aresetn),
         //S00 --> from axi_crossbar_0 (splitter)
         .S00_AXI_ACLK           (aclk_core),
         .S00_AXI_AWID           (1'b0),
         .S00_AXI_AWADDR         (m00_s00_axi_awaddr[31:0]),
         .S00_AXI_AWLEN          (m00_s00_axi_awlen[7:0]),//only supports 4 bit
         .S00_AXI_AWSIZE         (m00_s00_axi_awsize[2:0]),
         .S00_AXI_AWBURST        (m00_s00_axi_awburst[1:0]),
         .S00_AXI_AWLOCK         (1'b0),//(m00_s00_axi_awlock),//z
         .S00_AXI_AWCACHE        (m00_s00_axi_awcache[3:0]),
         .S00_AXI_AWPROT         (m00_s00_axi_awprot[2:0]),
         .S00_AXI_AWQOS          (m00_s00_axi_awqos[3:0]),
         .S00_AXI_AWVALID        (m00_s00_axi_awvalid),
         .S00_AXI_WDATA          (m00_s00_axi_wdata[31:0]),
         .S00_AXI_WSTRB          (m00_s00_axi_wstrb[3:0]),
         .S00_AXI_WLAST          (m00_s00_axi_wlast),
         .S00_AXI_WVALID         (m00_s00_axi_wvalid),
         .S00_AXI_BREADY         (m00_s00_axi_bready),
         .S00_AXI_ARID           (1'b0),
         .S00_AXI_ARADDR         (m00_s00_axi_araddr[31:0]),
         .S00_AXI_ARLEN          (m00_s00_axi_arlen[7:0]),
         .S00_AXI_ARSIZE         (m00_s00_axi_arsize[2:0]),
         .S00_AXI_ARBURST        (m00_s00_axi_arburst[1:0]),
         .S00_AXI_ARLOCK         (m00_s00_axi_arlock),
         .S00_AXI_ARCACHE        (m00_s00_axi_arcache[3:0]),
         .S00_AXI_ARPROT         (m00_s00_axi_arprot[2:0]),
         .S00_AXI_ARQOS          (m00_s00_axi_arqos[3:0]),
         .S00_AXI_ARVALID        (m00_s00_axi_arvalid),
         .S00_AXI_RREADY         (m00_s00_axi_rready),
         //S01 --> from vdma0 for FC
         .S01_AXI_ACLK           (aclk_core),
         .S01_AXI_AWID           (S01_AXI_AWID[0:0]),
         .S01_AXI_AWADDR         (S01_AXI_AWADDR[31:0]),
         .S01_AXI_AWLEN          (S01_AXI_AWLEN[7:0]),
         .S01_AXI_AWSIZE         (S01_AXI_AWSIZE[2:0]),
         .S01_AXI_AWBURST        (S01_AXI_AWBURST[1:0]),
         .S01_AXI_AWLOCK         (S01_AXI_AWLOCK),
         .S01_AXI_AWCACHE        (S01_AXI_AWCACHE[3:0]),
         .S01_AXI_AWPROT         (S01_AXI_AWPROT[2:0]),
         .S01_AXI_AWQOS          (S01_AXI_AWQOS[3:0]),
         .S01_AXI_AWVALID        (S01_AXI_AWVALID),
         .S01_AXI_WDATA          (S01_AXI_WDATA[63:0]),
         .S01_AXI_WSTRB          (S01_AXI_WSTRB[7:0]),
         .S01_AXI_WLAST          (S01_AXI_WLAST),
         .S01_AXI_WVALID         (S01_AXI_WVALID),
         .S01_AXI_BREADY         (S01_AXI_BREADY),
         .S01_AXI_ARID           (S01_AXI_ARID[0:0]),
         .S01_AXI_ARADDR         (S01_AXI_ARADDR[31:0]),
         .S01_AXI_ARLEN          (S01_AXI_ARLEN[7:0]),
         .S01_AXI_ARSIZE         (S01_AXI_ARSIZE[2:0]),
         .S01_AXI_ARBURST        (S01_AXI_ARBURST[1:0]),
         .S01_AXI_ARLOCK         (S01_AXI_ARLOCK),
         .S01_AXI_ARCACHE        (S01_AXI_ARCACHE[3:0]),
         .S01_AXI_ARPROT         (S01_AXI_ARPROT[2:0]),
         .S01_AXI_ARQOS          (S01_AXI_ARQOS[3:0]),
         .S01_AXI_ARVALID        (S01_AXI_ARVALID),
         .S01_AXI_RREADY         (S01_AXI_RREADY),
         //S02 --> from vdma1 for CONV
         .S02_AXI_ACLK           (aclk_core),
         .S02_AXI_AWID           (S02_AXI_AWID[0:0]),
         .S02_AXI_AWADDR         (S02_AXI_AWADDR[31:0]),
         .S02_AXI_AWLEN          (S02_AXI_AWLEN[7:0]),
         .S02_AXI_AWSIZE         (S02_AXI_AWSIZE[2:0]),
         .S02_AXI_AWBURST        (S02_AXI_AWBURST[1:0]),
         .S02_AXI_AWLOCK         (S02_AXI_AWLOCK),
         .S02_AXI_AWCACHE        (S02_AXI_AWCACHE[3:0]),
         .S02_AXI_AWPROT         (S02_AXI_AWPROT[2:0]),
         .S02_AXI_AWQOS          (S02_AXI_AWQOS[3:0]),
         .S02_AXI_AWVALID        (S02_AXI_AWVALID),
         .S02_AXI_WDATA          (S02_AXI_WDATA[63:0]),
         .S02_AXI_WSTRB          (S02_AXI_WSTRB[7:0]),
         .S02_AXI_WLAST          (S02_AXI_WLAST),
         .S02_AXI_WVALID         (S02_AXI_WVALID),
         .S02_AXI_BREADY         (S02_AXI_BREADY),
         .S02_AXI_ARID           (S02_AXI_ARID[0:0]),
         .S02_AXI_ARADDR         (S02_AXI_ARADDR[31:0]),
         .S02_AXI_ARLEN          (S02_AXI_ARLEN[7:0]),
         .S02_AXI_ARSIZE         (S02_AXI_ARSIZE[2:0]),
         .S02_AXI_ARBURST        (S02_AXI_ARBURST[1:0]),
         .S02_AXI_ARLOCK         (S02_AXI_ARLOCK),
         .S02_AXI_ARCACHE        (S02_AXI_ARCACHE[3:0]),
         .S02_AXI_ARPROT         (S02_AXI_ARPROT[2:0]),
         .S02_AXI_ARQOS          (S02_AXI_ARQOS[3:0]),
         .S02_AXI_ARVALID        (S02_AXI_ARVALID),
         .S02_AXI_RREADY         (S02_AXI_RREADY),
         //S03 --> from vdma2 for POOL
         .S03_AXI_ACLK           (aclk_core),
         .S03_AXI_AWID           (S03_AXI_AWID[0:0]),
         .S03_AXI_AWADDR         (S03_AXI_AWADDR[31:0]),
         .S03_AXI_AWLEN          (S03_AXI_AWLEN[7:0]),
         .S03_AXI_AWSIZE         (S03_AXI_AWSIZE[2:0]),
         .S03_AXI_AWBURST        (S03_AXI_AWBURST[1:0]),
         .S03_AXI_AWLOCK         (S03_AXI_AWLOCK),
         .S03_AXI_AWCACHE        (S03_AXI_AWCACHE[3:0]),
         .S03_AXI_AWPROT         (S03_AXI_AWPROT[2:0]),
         .S03_AXI_AWQOS          (S03_AXI_AWQOS[3:0]),
         .S03_AXI_AWVALID        (S03_AXI_AWVALID),
         .S03_AXI_WDATA          (S03_AXI_WDATA[63:0]),
         .S03_AXI_WSTRB          (S03_AXI_WSTRB[7:0]),
         .S03_AXI_WLAST          (S03_AXI_WLAST),
         .S03_AXI_WVALID         (S03_AXI_WVALID),
         .S03_AXI_BREADY         (S03_AXI_BREADY),
         .S03_AXI_ARID           (S03_AXI_ARID[0:0]),
         .S03_AXI_ARADDR         (S03_AXI_ARADDR[31:0]),
         .S03_AXI_ARLEN          (S03_AXI_ARLEN[7:0]),
         .S03_AXI_ARSIZE         (S03_AXI_ARSIZE[2:0]),
         .S03_AXI_ARBURST        (S03_AXI_ARBURST[1:0]),
         .S03_AXI_ARLOCK         (S03_AXI_ARLOCK),
         .S03_AXI_ARCACHE        (S03_AXI_ARCACHE[3:0]),
         .S03_AXI_ARPROT         (S03_AXI_ARPROT[2:0]),
         .S03_AXI_ARQOS          (S03_AXI_ARQOS[3:0]),
         .S03_AXI_ARVALID        (S03_AXI_ARVALID),
         .S03_AXI_RREADY         (S03_AXI_RREADY),

         //M00 --> to mig
         .M00_AXI_ACLK           (aclk_dram),
         .M00_AXI_AWREADY        (M00_AXI_AWREADY),
         .M00_AXI_WREADY         (M00_AXI_WREADY),
         .M00_AXI_BID            (M00_AXI_BID[3:0]),
         .M00_AXI_BRESP          (M00_AXI_BRESP[1:0]),
         .M00_AXI_BVALID         (M00_AXI_BVALID),
         .M00_AXI_ARREADY        (M00_AXI_ARREADY),
         .M00_AXI_RID            (M00_AXI_RID[3:0]),
         .M00_AXI_RDATA          (M00_AXI_RDATA[127:0]),
         .M00_AXI_RRESP          (M00_AXI_RRESP[1:0]),
         .M00_AXI_RLAST          (M00_AXI_RLAST),
         .M00_AXI_RVALID         (M00_AXI_RVALID));

    axi_crossbar_1_top
      u_axi_controlpath0
        (
         // Outputs
         .s00_axi_awready        (m00_s00_axil_awready[0:0]),
         .s00_axi_wready         (m00_s00_axil_wready[0:0]),
         .s00_axi_bresp          (m00_s00_axil_bresp[1:0]),
         .s00_axi_bvalid         (m00_s00_axil_bvalid[0:0]),
         .s00_axi_arready        (m00_s00_axil_arready[0:0]),
         .s00_axi_rdata          (m00_s00_axil_rdata[31:0]),
         .s00_axi_rresp          (m00_s00_axil_rresp[1:0]),
         .s00_axi_rvalid         (m00_s00_axil_rvalid[0:0]),
         .m00_axi_awaddr         (m00_axi_awaddr[31:0]),
         .m00_axi_awprot         (m00_axi_awprot[2:0]),
         .m00_axi_awvalid        (m00_axi_awvalid[0:0]),
         .m00_axi_wdata          (m00_axi_wdata[31:0]),
         .m00_axi_wstrb          (m00_axi_wstrb[3:0]),
         .m00_axi_wvalid         (m00_axi_wvalid[0:0]),
         .m00_axi_bready         (m00_axi_bready[0:0]),
         .m00_axi_araddr         (m00_axi_araddr[31:0]),
         .m00_axi_arprot         (m00_axi_arprot[2:0]),
         .m00_axi_arvalid        (m00_axi_arvalid[0:0]),
         .m00_axi_rready         (m00_axi_rready[0:0]),
         .m01_axi_awaddr         (m01_axi_awaddr[31:0]),
         .m01_axi_awprot         (m01_axi_awprot[2:0]),
         .m01_axi_awvalid        (m01_axi_awvalid[0:0]),
         .m01_axi_wdata          (m01_axi_wdata[31:0]),
         .m01_axi_wstrb          (m01_axi_wstrb[3:0]),
         .m01_axi_wvalid         (m01_axi_wvalid[0:0]),
         .m01_axi_bready         (m01_axi_bready[0:0]),
         .m01_axi_araddr         (m01_axi_araddr[31:0]),
         .m01_axi_arprot         (m01_axi_arprot[2:0]),
         .m01_axi_arvalid        (m01_axi_arvalid[0:0]),
         .m01_axi_rready         (m01_axi_rready[0:0]),
         .m02_axi_awaddr         (m02_axi_awaddr[31:0]),
         .m02_axi_awprot         (m02_axi_awprot[2:0]),
         .m02_axi_awvalid        (m02_axi_awvalid[0:0]),
         .m02_axi_wdata          (m02_axi_wdata[31:0]),
         .m02_axi_wstrb          (m02_axi_wstrb[3:0]),
         .m02_axi_wvalid         (m02_axi_wvalid[0:0]),
         .m02_axi_bready         (m02_axi_bready[0:0]),
         .m02_axi_araddr         (m02_axi_araddr[31:0]),
         .m02_axi_arprot         (m02_axi_arprot[2:0]),
         .m02_axi_arvalid        (m02_axi_arvalid[0:0]),
         .m02_axi_rready         (m02_axi_rready[0:0]),
         .m03_axi_awaddr         (m03_axi_awaddr[31:0]),
         .m03_axi_awprot         (m03_axi_awprot[2:0]),
         .m03_axi_awvalid        (m03_axi_awvalid[0:0]),
         .m03_axi_wdata          (m03_axi_wdata[31:0]),
         .m03_axi_wstrb          (m03_axi_wstrb[3:0]),
         .m03_axi_wvalid         (m03_axi_wvalid[0:0]),
         .m03_axi_bready         (m03_axi_bready[0:0]),
         .m03_axi_araddr         (m03_axi_araddr[31:0]),
         .m03_axi_arprot         (m03_axi_arprot[2:0]),
         .m03_axi_arvalid        (m03_axi_arvalid[0:0]),
         .m03_axi_rready         (m03_axi_rready[0:0]),
         .m04_axi_awaddr         (m04_axi_awaddr[31:0]),
         .m04_axi_awprot         (m04_axi_awprot[2:0]),
         .m04_axi_awvalid        (m04_axi_awvalid[0:0]),
         .m04_axi_wdata          (m04_axi_wdata[31:0]),
         .m04_axi_wstrb          (m04_axi_wstrb[3:0]),
         .m04_axi_wvalid         (m04_axi_wvalid[0:0]),
         .m04_axi_bready         (m04_axi_bready[0:0]),
         .m04_axi_araddr         (m04_axi_araddr[31:0]),
         .m04_axi_arprot         (m04_axi_arprot[2:0]),
         .m04_axi_arvalid        (m04_axi_arvalid[0:0]),
         .m04_axi_rready         (m04_axi_rready[0:0]),
         .m05_axi_awaddr         (m05_axi_awaddr[31:0]),
         .m05_axi_awprot         (m05_axi_awprot[2:0]),
         .m05_axi_awvalid        (m05_axi_awvalid[0:0]),
         .m05_axi_wdata          (m05_axi_wdata[31:0]),
         .m05_axi_wstrb          (m05_axi_wstrb[3:0]),
         .m05_axi_wvalid         (m05_axi_wvalid[0:0]),
         .m05_axi_bready         (m05_axi_bready[0:0]),
         .m05_axi_araddr         (m05_axi_araddr[31:0]),
         .m05_axi_arprot         (m05_axi_arprot[2:0]),
         .m05_axi_arvalid        (m05_axi_arvalid[0:0]),
         .m05_axi_rready         (m05_axi_rready[0:0]),
         // Inputs
         .aclk                   (aclk_core),
         .aresetn                (aresetn_s00_out), //from interconnect
         .s00_axi_awaddr         (m00_s00_axil_awaddr[31:0]),
         .s00_axi_awprot         (m00_s00_axil_awprot[2:0]),
         .s00_axi_awvalid        (m00_s00_axil_awvalid[0:0]),
         .s00_axi_wdata          (m00_s00_axil_wdata[31:0]),
         .s00_axi_wstrb          (m00_s00_axil_wstrb[3:0]),
         .s00_axi_wvalid         (m00_s00_axil_wvalid[0:0]),
         .s00_axi_bready         (m00_s00_axil_bready[0:0]),
         .s00_axi_araddr         (m00_s00_axil_araddr[31:0]),
         .s00_axi_arprot         (m00_s00_axil_arprot[2:0]),
         .s00_axi_arvalid        (m00_s00_axil_arvalid[0:0]),
         .s00_axi_rready         (m00_s00_axil_rready[0:0]),
         .m00_axi_awready        (m00_axi_awready[0:0]),
         .m00_axi_wready         (m00_axi_wready[0:0]),
         .m00_axi_bresp          (m00_axi_bresp[1:0]),
         .m00_axi_bvalid         (m00_axi_bvalid[0:0]),
         .m00_axi_arready        (m00_axi_arready[0:0]),
         .m00_axi_rdata          (m00_axi_rdata[31:0]),
         .m00_axi_rresp          (m00_axi_rresp[1:0]),
         .m00_axi_rvalid         (m00_axi_rvalid[0:0]),
         .m01_axi_awready        (m01_axi_awready[0:0]),
         .m01_axi_wready         (m01_axi_wready[0:0]),
         .m01_axi_bresp          (m01_axi_bresp[1:0]),
         .m01_axi_bvalid         (m01_axi_bvalid[0:0]),
         .m01_axi_arready        (m01_axi_arready[0:0]),
         .m01_axi_rdata          (m01_axi_rdata[31:0]),
         .m01_axi_rresp          (m01_axi_rresp[1:0]),
         .m01_axi_rvalid         (m01_axi_rvalid[0:0]),
         .m02_axi_awready        (m02_axi_awready[0:0]),
         .m02_axi_wready         (m02_axi_wready[0:0]),
         .m02_axi_bresp          (m02_axi_bresp[1:0]),
         .m02_axi_bvalid         (m02_axi_bvalid[0:0]),
         .m02_axi_arready        (m02_axi_arready[0:0]),
         .m02_axi_rdata          (m02_axi_rdata[31:0]),
         .m02_axi_rresp          (m02_axi_rresp[1:0]),
         .m02_axi_rvalid         (m02_axi_rvalid[0:0]),
         .m03_axi_awready        (m03_axi_awready[0:0]),
         .m03_axi_wready         (m03_axi_wready[0:0]),
         .m03_axi_bresp          (m03_axi_bresp[1:0]),
         .m03_axi_bvalid         (m03_axi_bvalid[0:0]),
         .m03_axi_arready        (m03_axi_arready[0:0]),
         .m03_axi_rdata          (m03_axi_rdata[31:0]),
         .m03_axi_rresp          (m03_axi_rresp[1:0]),
         .m03_axi_rvalid         (m03_axi_rvalid[0:0]),
         .m04_axi_awready        (m04_axi_awready[0:0]),
         .m04_axi_wready         (m04_axi_wready[0:0]),
         .m04_axi_bresp          (m04_axi_bresp[1:0]),
         .m04_axi_bvalid         (m04_axi_bvalid[0:0]),
         .m04_axi_arready        (m04_axi_arready[0:0]),
         .m04_axi_rdata          (m04_axi_rdata[31:0]),
         .m04_axi_rresp          (m04_axi_rresp[1:0]),
         .m04_axi_rvalid         (m04_axi_rvalid[0:0]),
         .m05_axi_awready        (m05_axi_awready[0:0]),
         .m05_axi_wready         (m05_axi_wready[0:0]),
         .m05_axi_bresp          (m05_axi_bresp[1:0]),
         .m05_axi_bvalid         (m05_axi_bvalid[0:0]),
         .m05_axi_arready        (m05_axi_arready[0:0]),
         .m05_axi_rdata          (m05_axi_rdata[31:0]),
         .m05_axi_rresp          (m05_axi_rresp[1:0]),
         .m05_axi_rvalid         (m05_axi_rvalid[0:0]));

    axi_to_apb
      u_axi_to_apb_m3
        (
         // Outputs
         .s_axi_awready          (m03_axi_awready),
         .s_axi_wready           (m03_axi_wready),
         .s_axi_bresp            (m03_axi_bresp[1:0]),
         .s_axi_bvalid           (m03_axi_bvalid),
         .s_axi_arready          (m03_axi_arready),
         .s_axi_rdata            (m03_axi_rdata[31:0]),
         .s_axi_rresp            (m03_axi_rresp[1:0]),
         .s_axi_rvalid           (m03_axi_rvalid),

         .m_apb_paddr            (m03_apb_paddr[31:0]),
         .m_apb_psel             (m03_apb_psel[0:0]),
         .m_apb_penable          (m03_apb_penable),
         .m_apb_pwrite           (m03_apb_pwrite),
         .m_apb_pwdata           (m03_apb_pwdata[31:0]),
         // Inputs
         .s_axi_aclk             (aclk_core),
         .s_axi_aresetn          (aresetn_s00_out),
         .s_axi_awaddr           (m03_axi_awaddr[31:0]),
         .s_axi_awvalid          (m03_axi_awvalid),
         .s_axi_wdata            (m03_axi_wdata[31:0]),
         .s_axi_wvalid           (m03_axi_wvalid),
         .s_axi_bready           (m03_axi_bready),
         .s_axi_araddr           (m03_axi_araddr[31:0]),
         .s_axi_arvalid          (m03_axi_arvalid),
         .s_axi_rready           (m03_axi_rready),

         .m_apb_pready           (m03_apb_pready[0:0]),
         .m_apb_prdata           (m03_apb_prdata[31:0]),
         .m_apb_pslverr          (m03_apb_pslverr[0:0]));

    axi_to_apb
      u_axi_to_apb_m4
        (
         // Outputs
         .s_axi_awready          (m04_axi_awready),
         .s_axi_wready           (m04_axi_wready),
         .s_axi_bresp            (m04_axi_bresp[1:0]),
         .s_axi_bvalid           (m04_axi_bvalid),
         .s_axi_arready          (m04_axi_arready),
         .s_axi_rdata            (m04_axi_rdata[31:0]),
         .s_axi_rresp            (m04_axi_rresp[1:0]),
         .s_axi_rvalid           (m04_axi_rvalid),
         .m_apb_paddr            (m04_apb_paddr[31:0]),
         .m_apb_psel             (m04_apb_psel[0:0]),
         .m_apb_penable          (m04_apb_penable),
         .m_apb_pwrite           (m04_apb_pwrite),
         .m_apb_pwdata           (m04_apb_pwdata[31:0]),
         // Inputs
         .s_axi_aclk             (aclk_core),
         .s_axi_aresetn          (aresetn_s00_out),
         .s_axi_awaddr           (m04_axi_awaddr[31:0]),
         .s_axi_awvalid          (m04_axi_awvalid),
         .s_axi_wdata            (m04_axi_wdata[31:0]),
         .s_axi_wvalid           (m04_axi_wvalid),
         .s_axi_bready           (m04_axi_bready),
         .s_axi_araddr           (m04_axi_araddr[31:0]),
         .s_axi_arvalid          (m04_axi_arvalid),
         .s_axi_rready           (m04_axi_rready),
         .m_apb_pready           (m04_apb_pready[0:0]),
         .m_apb_prdata           (m04_apb_prdata[31:0]),
         .m_apb_pslverr          (m04_apb_pslverr[0:0]));

    axi_to_apb
      u_axi_to_apb_m5
        (
         // Outputs
         .s_axi_awready          (m05_axi_awready),
         .s_axi_wready           (m05_axi_wready),
         .s_axi_bresp            (m05_axi_bresp[1:0]),
         .s_axi_bvalid           (m05_axi_bvalid),
         .s_axi_arready          (m05_axi_arready),
         .s_axi_rdata            (m05_axi_rdata[31:0]),
         .s_axi_rresp            (m05_axi_rresp[1:0]),
         .s_axi_rvalid           (m05_axi_rvalid),
         .m_apb_paddr            (m05_apb_paddr[31:0]),
         .m_apb_psel         (m05_apb_psel[0:0]),
         .m_apb_penable          (m05_apb_penable),
         .m_apb_pwrite           (m05_apb_pwrite),
         .m_apb_pwdata           (m05_apb_pwdata[31:0]),
         // Inputs
         .s_axi_aclk         (aclk_core),
         .s_axi_aresetn          (aresetn_s00_out),
         .s_axi_awaddr           (m05_axi_awaddr[31:0]),
         .s_axi_awvalid          (m05_axi_awvalid),
         .s_axi_wdata            (m05_axi_wdata[31:0]),
         .s_axi_wvalid           (m05_axi_wvalid),
         .s_axi_bready           (m05_axi_bready),
         .s_axi_araddr           (m05_axi_araddr[31:0]),
         .s_axi_arvalid          (m05_axi_arvalid),
         .s_axi_rready           (m05_axi_rready),
         .m_apb_pready           (m05_apb_pready[0:0]),
         .m_apb_prdata           (m05_apb_prdata[31:0]),
         .m_apb_pslverr          (m05_apb_pslverr[0:0]));

endmodule // axi_subsystem
