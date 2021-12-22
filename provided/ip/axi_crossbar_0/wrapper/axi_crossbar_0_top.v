module axi_crossbar_0_top
  (/*AUTOARG*/
   // Outputs
   s00_axi_awready, s00_axi_wready, s00_axi_bresp, s00_axi_bvalid,
   s00_axi_arready, s00_axi_rdata, s00_axi_rresp, s00_axi_rlast,
   s00_axi_rvalid, m00_axi_awaddr, m00_axi_awlen, m00_axi_awsize,
   m00_axi_awburst, m00_axi_awlock, m00_axi_awcache, m00_axi_awprot,
   m00_axi_awregion, m00_axi_awqos, m00_axi_awvalid, m00_axi_wdata,
   m00_axi_wstrb, m00_axi_wlast, m00_axi_wvalid, m00_axi_bready,
   m00_axi_araddr, m00_axi_arlen, m00_axi_arsize, m00_axi_arburst,
   m00_axi_arlock, m00_axi_arcache, m00_axi_arprot, m00_axi_arregion,
   m00_axi_arqos, m00_axi_arvalid, m00_axi_rready, m01_axi_awaddr,
   m01_axi_awlen, m01_axi_awsize, m01_axi_awburst, m01_axi_awlock,
   m01_axi_awcache, m01_axi_awprot, m01_axi_awregion, m01_axi_awqos,
   m01_axi_awvalid, m01_axi_wdata, m01_axi_wstrb, m01_axi_wlast,
   m01_axi_wvalid, m01_axi_bready, m01_axi_araddr, m01_axi_arlen,
   m01_axi_arsize, m01_axi_arburst, m01_axi_arlock, m01_axi_arcache,
   m01_axi_arprot, m01_axi_arregion, m01_axi_arqos, m01_axi_arvalid,
   m01_axi_rready,
   // Inputs
   aclk, aresetn, s00_axi_awaddr, s00_axi_awlen, s00_axi_awsize,
   s00_axi_awburst, s00_axi_awlock, s00_axi_awcache, s00_axi_awprot,
   s00_axi_awqos, s00_axi_awvalid, s00_axi_wdata, s00_axi_wstrb,
   s00_axi_wlast, s00_axi_wvalid, s00_axi_bready, s00_axi_araddr,
   s00_axi_arlen, s00_axi_arsize, s00_axi_arburst, s00_axi_arlock,
   s00_axi_arcache, s00_axi_arprot, s00_axi_arqos, s00_axi_arvalid,
   s00_axi_rready, m00_axi_awready, m00_axi_wready, m00_axi_bresp,
   m00_axi_bvalid, m00_axi_arready, m00_axi_rdata, m00_axi_rresp,
   m00_axi_rlast, m00_axi_rvalid, m01_axi_awready, m01_axi_wready,
   m01_axi_bresp, m01_axi_bvalid, m01_axi_arready, m01_axi_rdata,
   m01_axi_rresp, m01_axi_rlast, m01_axi_rvalid
   );

   input aclk;
   input aresetn;
   input [31:0] s00_axi_awaddr;
   input [7:0] 	s00_axi_awlen;
   input [2:0] 	s00_axi_awsize;
   input [1:0] 	s00_axi_awburst;
   input [0:0] 	s00_axi_awlock;
   input [3:0] 	s00_axi_awcache;
   input [2:0] 	s00_axi_awprot;
   input [3:0] 	s00_axi_awqos;
   input [0:0] 	s00_axi_awvalid;
   output [0:0] s00_axi_awready;
   input [31:0] s00_axi_wdata;
   input [3:0] 	s00_axi_wstrb;
   input [0:0] 	s00_axi_wlast;
   input [0:0] 	s00_axi_wvalid;
   output [0:0] s00_axi_wready;
   output [1:0] s00_axi_bresp;
   output [0:0] s00_axi_bvalid;
   input [0:0] 	s00_axi_bready;
   input [31:0] s00_axi_araddr;
   input [7:0] 	s00_axi_arlen;
   input [2:0] 	s00_axi_arsize;
   input [1:0] 	s00_axi_arburst;
   input [0:0] 	s00_axi_arlock;
   input [3:0] 	s00_axi_arcache;
   input [2:0] 	s00_axi_arprot;
   input [3:0] 	s00_axi_arqos;
   input [0:0] 	s00_axi_arvalid;
   output [0:0] s00_axi_arready;
   output [31:0] s00_axi_rdata;
   output [1:0]  s00_axi_rresp;
   output [0:0]  s00_axi_rlast;
   output [0:0]  s00_axi_rvalid;
   input [0:0] 	 s00_axi_rready;

   
   output [31:0] m00_axi_awaddr;
   output [7:0]  m00_axi_awlen;
   output [2:0]  m00_axi_awsize;
   output [1:0]  m00_axi_awburst;
   output [0:0]  m00_axi_awlock;
   output [3:0]  m00_axi_awcache;
   output [2:0]  m00_axi_awprot;
   output [3:0]  m00_axi_awregion;
   output [3:0]  m00_axi_awqos;
   output [0:0]  m00_axi_awvalid;
   input [0:0] 	 m00_axi_awready;
   output [31:0] m00_axi_wdata;
   output [3:0]  m00_axi_wstrb;
   output [0:0]  m00_axi_wlast;
   output [0:0]  m00_axi_wvalid;
   input [0:0] 	 m00_axi_wready;
   input [1:0] 	 m00_axi_bresp;
   input [0:0] 	 m00_axi_bvalid;
   output [0:0]  m00_axi_bready;
   output [31:0] m00_axi_araddr;
   output [7:0]  m00_axi_arlen;
   output [2:0]  m00_axi_arsize;
   output [1:0]  m00_axi_arburst;
   output [0:0]  m00_axi_arlock;
   output [3:0]  m00_axi_arcache;
   output [2:0]  m00_axi_arprot;
   output [3:0]  m00_axi_arregion;
   output [3:0]  m00_axi_arqos;
   output [0:0]  m00_axi_arvalid;
   input [0:0] 	 m00_axi_arready;
   input [31:0]  m00_axi_rdata;
   input [1:0] 	 m00_axi_rresp;
   input [0:0] 	 m00_axi_rlast;
   input [0:0] 	 m00_axi_rvalid;
   output [0:0]  m00_axi_rready;

   output [31:0] m01_axi_awaddr;
   output [7:0]  m01_axi_awlen;
   output [2:0]  m01_axi_awsize;
   output [1:0]  m01_axi_awburst;
   output [0:0]  m01_axi_awlock;
   output [3:0]  m01_axi_awcache;
   output [2:0]  m01_axi_awprot;
   output [3:0]  m01_axi_awregion;
   output [3:0]  m01_axi_awqos;
   output [0:0]  m01_axi_awvalid;
   input [0:0] 	 m01_axi_awready;
   output [31:0] m01_axi_wdata;
   output [3:0]  m01_axi_wstrb;
   output [0:0]  m01_axi_wlast;
   output [0:0]  m01_axi_wvalid;
   input [0:0] 	 m01_axi_wready;
   input [1:0] 	 m01_axi_bresp;
   input [0:0] 	 m01_axi_bvalid;
   output [0:0]  m01_axi_bready;
   output [31:0] m01_axi_araddr;
   output [7:0]  m01_axi_arlen;
   output [2:0]  m01_axi_arsize;
   output [1:0]  m01_axi_arburst;
   output [0:0]  m01_axi_arlock;
   output [3:0]  m01_axi_arcache;
   output [2:0]  m01_axi_arprot;
   output [3:0]  m01_axi_arregion;
   output [3:0]  m01_axi_arqos;
   output [0:0]  m01_axi_arvalid;
   input [0:0] 	 m01_axi_arready;
   input [31:0]  m01_axi_rdata;
   input [1:0] 	 m01_axi_rresp;
   input [0:0] 	 m01_axi_rlast;
   input [0:0] 	 m01_axi_rvalid;
   output [0:0]  m01_axi_rready;


  wire [63:0] m_axi_awaddr;
  wire [15:0] m_axi_awlen;
  wire [5:0] m_axi_awsize;
  wire [3:0] m_axi_awburst;
  wire [1:0] m_axi_awlock;
  wire [7:0] m_axi_awcache;
  wire [5:0] m_axi_awprot;
  wire [7:0] m_axi_awregion;
  wire [7:0] m_axi_awqos;
  wire [1:0] m_axi_awvalid;
  wire [1:0] m_axi_awready;
  wire [63:0] m_axi_wdata;
  wire [7:0] m_axi_wstrb;
  wire [1:0] m_axi_wlast;
  wire [1:0] m_axi_wvalid;
  wire [1:0] m_axi_wready;
  wire [3:0] m_axi_bresp;
  wire [1:0] m_axi_bvalid;
  wire [1:0] m_axi_bready;
  wire [63:0] m_axi_araddr;
  wire [15:0] m_axi_arlen;
  wire [5:0] m_axi_arsize;
  wire [3:0] m_axi_arburst;
  wire [1:0] m_axi_arlock;
  wire [7:0] m_axi_arcache;
  wire [5:0] m_axi_arprot;
  wire [7:0] m_axi_arregion;
  wire [7:0] m_axi_arqos;
  wire [1:0] m_axi_arvalid;
  wire [1:0] m_axi_arready;
  wire [63:0] m_axi_rdata;
  wire [3:0] m_axi_rresp;
  wire [1:0] m_axi_rlast;
  wire [1:0] m_axi_rvalid;
  wire [1:0] m_axi_rready;
   
  assign {m01_axi_awaddr         ,m00_axi_awaddr         } = m_axi_awaddr;
  assign {m01_axi_awlen  	,m00_axi_awlen  	} = m_axi_awlen;
  assign {m01_axi_awsize 	,m00_axi_awsize 	} = m_axi_awsize;
  assign {m01_axi_awburst	,m00_axi_awburst	} = m_axi_awburst;
  assign {m01_axi_awlock  	,m00_axi_awlock         } = m_axi_awlock;
  assign {m01_axi_awcache	,m00_axi_awcache	} = m_axi_awcache;
  assign {m01_axi_awprot 	,m00_axi_awprot 	} = m_axi_awprot;
  assign {m01_axi_awregion	,m00_axi_awregion	} = m_axi_awregion;
  assign {m01_axi_awqos  	,m00_axi_awqos  	} = m_axi_awqos;
  assign {m01_axi_awvalid	,m00_axi_awvalid	} = m_axi_awvalid;
  assign {m01_axi_wdata  	,m00_axi_wdata  	} = m_axi_wdata;
  assign {m01_axi_wstrb  	,m00_axi_wstrb  	} = m_axi_wstrb;
  assign {m01_axi_wlast  	,m00_axi_wlast  	} = m_axi_wlast;
  assign {m01_axi_wvalid 	,m00_axi_wvalid 	} = m_axi_wvalid;
  assign {m01_axi_bready 	,m00_axi_bready 	} = m_axi_bready;
  assign {m01_axi_araddr 	,m00_axi_araddr 	} = m_axi_araddr;
  assign {m01_axi_arlen  	,m00_axi_arlen  	} = m_axi_arlen;
  assign {m01_axi_arsize 	,m00_axi_arsize 	} = m_axi_arsize;
  assign {m01_axi_arburst	,m00_axi_arburst	} = m_axi_arburst;
  assign {m01_axi_arlock 	,m00_axi_arlock 	} = m_axi_arlock;
  assign {m01_axi_arcache	,m00_axi_arcache	} = m_axi_arcache;
  assign {m01_axi_arprot 	,m00_axi_arprot 	} = m_axi_arprot;
  assign {m01_axi_arregion	,m00_axi_arregion	} = m_axi_arregion;
  assign {m01_axi_arqos  	,m00_axi_arqos  	} = m_axi_arqos;
  assign {m01_axi_arvalid	,m00_axi_arvalid	} = m_axi_arvalid;
  assign {m01_axi_rready  ,m00_axi_rready               } = m_axi_rready; 

  assign m_axi_awready  = {m01_axi_awready ,m00_axi_awready };    
  assign m_axi_wready   = {m01_axi_wready  ,m00_axi_wready  };
  assign m_axi_bresp    = {m01_axi_bresp   ,m00_axi_bresp   };
  assign m_axi_bvalid   = {m01_axi_bvalid  ,m00_axi_bvalid  };
  assign m_axi_arready  = {m01_axi_arready ,m00_axi_arready };
  assign m_axi_rdata    = {m01_axi_rdata   ,m00_axi_rdata   };
  assign m_axi_rresp    = {m01_axi_rresp   ,m00_axi_rresp   };
  assign m_axi_rlast    = {m01_axi_rlast   ,m00_axi_rlast   };
  assign m_axi_rvalid   = {m01_axi_rvalid  ,m00_axi_rvalid  };

   
   axi_crossbar_0
     u_axi_splitter
       (
	// Outputs
	.s_axi_awready			(s00_axi_awready[0:0]),
	.s_axi_wready			(s00_axi_wready[0:0]),
	.s_axi_bresp			(s00_axi_bresp[1:0]),
	.s_axi_bvalid			(s00_axi_bvalid[0:0]),
	.s_axi_arready			(s00_axi_arready[0:0]),
	.s_axi_rdata			(s00_axi_rdata[31:0]),
	.s_axi_rresp			(s00_axi_rresp[1:0]),
	.s_axi_rlast			(s00_axi_rlast[0:0]),
	.s_axi_rvalid			(s00_axi_rvalid[0:0]),
	.m_axi_awaddr			(m_axi_awaddr[63:0]),
	.m_axi_awlen			(m_axi_awlen[15:0]),
	.m_axi_awsize			(m_axi_awsize[5:0]),
	.m_axi_awburst			(m_axi_awburst[3:0]),
	.m_axi_awlock			(m_axi_awlock[1:0]),
	.m_axi_awcache			(m_axi_awcache[7:0]),
	.m_axi_awprot			(m_axi_awprot[5:0]),
	.m_axi_awregion			(m_axi_awregion[7:0]),
	.m_axi_awqos			(m_axi_awqos[7:0]),
	.m_axi_awvalid			(m_axi_awvalid[1:0]),
	.m_axi_wdata			(m_axi_wdata[63:0]),
	.m_axi_wstrb			(m_axi_wstrb[7:0]),
	.m_axi_wlast			(m_axi_wlast[1:0]),
	.m_axi_wvalid			(m_axi_wvalid[1:0]),
	.m_axi_bready			(m_axi_bready[1:0]),
	.m_axi_araddr			(m_axi_araddr[63:0]),
	.m_axi_arlen			(m_axi_arlen[15:0]),
	.m_axi_arsize			(m_axi_arsize[5:0]),
	.m_axi_arburst			(m_axi_arburst[3:0]),
	.m_axi_arlock			(m_axi_arlock[1:0]),
	.m_axi_arcache			(m_axi_arcache[7:0]),
	.m_axi_arprot			(m_axi_arprot[5:0]),
	.m_axi_arregion			(m_axi_arregion[7:0]),
	.m_axi_arqos			(m_axi_arqos[7:0]),
	.m_axi_arvalid			(m_axi_arvalid[1:0]),
	.m_axi_rready			(m_axi_rready[1:0]),
	// Inputs
	.aclk				(aclk),
	.aresetn			(aresetn),
	.s_axi_awaddr			(s00_axi_awaddr[31:0]),
	.s_axi_awlen			(s00_axi_awlen[7:0]),
	.s_axi_awsize			(s00_axi_awsize[2:0]),
	.s_axi_awburst			(s00_axi_awburst[1:0]),
	.s_axi_awlock			(s00_axi_awlock[0:0]),
	.s_axi_awcache			(s00_axi_awcache[3:0]),
	.s_axi_awprot			(s00_axi_awprot[2:0]),
	.s_axi_awqos			(s00_axi_awqos[3:0]),
	.s_axi_awvalid			(s00_axi_awvalid[0:0]),
	.s_axi_wdata			(s00_axi_wdata[31:0]),
	.s_axi_wstrb			(s00_axi_wstrb[3:0]),
	.s_axi_wlast			(s00_axi_wlast[0:0]),
	.s_axi_wvalid			(s00_axi_wvalid[0:0]),
	.s_axi_bready			(s00_axi_bready[0:0]),
	.s_axi_araddr			(s00_axi_araddr[31:0]),
	.s_axi_arlen			(s00_axi_arlen[7:0]),
	.s_axi_arsize			(s00_axi_arsize[2:0]),
	.s_axi_arburst			(s00_axi_arburst[1:0]),
	.s_axi_arlock			(s00_axi_arlock[0:0]),
	.s_axi_arcache			(s00_axi_arcache[3:0]),
	.s_axi_arprot			(s00_axi_arprot[2:0]),
	.s_axi_arqos			(s00_axi_arqos[3:0]),
	.s_axi_arvalid			(s00_axi_arvalid[0:0]),
	.s_axi_rready			(s00_axi_rready[0:0]),
	.m_axi_awready			(m_axi_awready[1:0]),
	.m_axi_wready			(m_axi_wready[1:0]),
	.m_axi_bresp			(m_axi_bresp[3:0]),
	.m_axi_bvalid			(m_axi_bvalid[1:0]),
	.m_axi_arready			(m_axi_arready[1:0]),
	.m_axi_rdata			(m_axi_rdata[63:0]),
	.m_axi_rresp			(m_axi_rresp[3:0]),
	.m_axi_rlast			(m_axi_rlast[1:0]),
	.m_axi_rvalid			(m_axi_rvalid[1:0]));

endmodule // axi_crossbar_0_top
