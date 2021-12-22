module axi_crossbar_1_top
  (/*AUTOARG*/
   // Outputs
   s00_axi_awready, s00_axi_wready, s00_axi_bresp, s00_axi_bvalid,
   s00_axi_arready, s00_axi_rdata, s00_axi_rresp, s00_axi_rvalid,
   m00_axi_awaddr, m00_axi_awprot, m00_axi_awvalid, m00_axi_wdata,
   m00_axi_wstrb, m00_axi_wvalid, m00_axi_bready, m00_axi_araddr,
   m00_axi_arprot, m00_axi_arvalid, m00_axi_rready, m01_axi_awaddr,
   m01_axi_awprot, m01_axi_awvalid, m01_axi_wdata, m01_axi_wstrb,
   m01_axi_wvalid, m01_axi_bready, m01_axi_araddr, m01_axi_arprot,
   m01_axi_arvalid, m01_axi_rready, m02_axi_awaddr, m02_axi_awprot,
   m02_axi_awvalid, m02_axi_wdata, m02_axi_wstrb, m02_axi_wvalid,
   m02_axi_bready, m02_axi_araddr, m02_axi_arprot, m02_axi_arvalid,
   m02_axi_rready, m03_axi_awaddr, m03_axi_awprot, m03_axi_awvalid,
   m03_axi_wdata, m03_axi_wstrb, m03_axi_wvalid, m03_axi_bready,
   m03_axi_araddr, m03_axi_arprot, m03_axi_arvalid, m03_axi_rready,
   m04_axi_awaddr, m04_axi_awprot, m04_axi_awvalid, m04_axi_wdata,
   m04_axi_wstrb, m04_axi_wvalid, m04_axi_bready, m04_axi_araddr,
   m04_axi_arprot, m04_axi_arvalid, m04_axi_rready, m05_axi_awaddr,
   m05_axi_awprot, m05_axi_awvalid, m05_axi_wdata, m05_axi_wstrb,
   m05_axi_wvalid, m05_axi_bready, m05_axi_araddr, m05_axi_arprot,
   m05_axi_arvalid, m05_axi_rready,
   // Inputs
   aclk, aresetn, s00_axi_awaddr, s00_axi_awprot, s00_axi_awvalid,
   s00_axi_wdata, s00_axi_wstrb, s00_axi_wvalid, s00_axi_bready,
   s00_axi_araddr, s00_axi_arprot, s00_axi_arvalid, s00_axi_rready,
   m00_axi_awready, m00_axi_wready, m00_axi_bresp, m00_axi_bvalid,
   m00_axi_arready, m00_axi_rdata, m00_axi_rresp, m00_axi_rvalid,
   m01_axi_awready, m01_axi_wready, m01_axi_bresp, m01_axi_bvalid,
   m01_axi_arready, m01_axi_rdata, m01_axi_rresp, m01_axi_rvalid,
   m02_axi_awready, m02_axi_wready, m02_axi_bresp, m02_axi_bvalid,
   m02_axi_arready, m02_axi_rdata, m02_axi_rresp, m02_axi_rvalid,
   m03_axi_awready, m03_axi_wready, m03_axi_bresp, m03_axi_bvalid,
   m03_axi_arready, m03_axi_rdata, m03_axi_rresp, m03_axi_rvalid,
   m04_axi_awready, m04_axi_wready, m04_axi_bresp, m04_axi_bvalid,
   m04_axi_arready, m04_axi_rdata, m04_axi_rresp, m04_axi_rvalid,
   m05_axi_awready, m05_axi_wready, m05_axi_bresp, m05_axi_bvalid,
   m05_axi_arready, m05_axi_rdata, m05_axi_rresp, m05_axi_rvalid
   );



   input wire aclk		    ; 
   input wire aresetn		   ;  
   input wire [31 : 0] s00_axi_awaddr  ;
   input wire [2 : 0]  s00_axi_awprot   ;
   input wire [0 : 0]  s00_axi_awvalid  ;
   output wire [0 : 0] s00_axi_awready ;
   input wire [31 : 0] s00_axi_wdata   ;
   input wire [3 : 0]  s00_axi_wstrb    ;
   input wire [0 : 0]  s00_axi_wvalid   ;
   output wire [0 : 0] s00_axi_wready  ;
   output wire [1 : 0] s00_axi_bresp   ;
   output wire [0 : 0] s00_axi_bvalid  ;
   input wire [0 : 0]  s00_axi_bready   ;
   input wire [31 : 0] s00_axi_araddr  ;
   input wire [2 : 0]  s00_axi_arprot   ;
   input wire [0 : 0]  s00_axi_arvalid  ;
   output wire [0 : 0] s00_axi_arready ;
   output wire [31 : 0] s00_axi_rdata  ;
   output wire [1 : 0] 	s00_axi_rresp   ;
   output wire [0 : 0] 	s00_axi_rvalid  ;
   input wire [0 : 0] 	s00_axi_rready   ;

   
   output wire [31 : 0] m00_axi_awaddr;
   output wire [2 : 0] 	m00_axi_awprot;
   output wire [0 : 0] 	m00_axi_awvalid;
   input wire [0 : 0] 	m00_axi_awready;
   output wire [31 : 0] m00_axi_wdata;
   output wire [3 : 0] 	m00_axi_wstrb;
   output wire [0 : 0] 	m00_axi_wvalid;
   input wire [0 : 0] 	m00_axi_wready;
   input wire [1 : 0] 	m00_axi_bresp;
   input wire [0 : 0] 	m00_axi_bvalid;
   output wire [0 : 0] 	m00_axi_bready;
   output wire [31 : 0] m00_axi_araddr;
   output wire [2 : 0] 	m00_axi_arprot;
   output wire [0 : 0] 	m00_axi_arvalid;
   input wire [0 : 0] 	m00_axi_arready;
   input wire [31 : 0] 	m00_axi_rdata;
   input wire [1 : 0] 	m00_axi_rresp;
   input wire [0 : 0] 	m00_axi_rvalid;
   output wire [0 : 0] 	m00_axi_rready;

   output wire [31 : 0] m01_axi_awaddr;
   output wire [2 : 0] 	m01_axi_awprot;
   output wire [0 : 0] 	m01_axi_awvalid;
   input wire [0 : 0] 	m01_axi_awready;
   output wire [31 : 0] m01_axi_wdata;
   output wire [3 : 0] 	m01_axi_wstrb;
   output wire [0 : 0] 	m01_axi_wvalid;
   input wire [0 : 0] 	m01_axi_wready;
   input wire [1 : 0] 	m01_axi_bresp;
   input wire [0 : 0] 	m01_axi_bvalid;
   output wire [0 : 0] 	m01_axi_bready;
   output wire [31 : 0] m01_axi_araddr;
   output wire [2 : 0] 	m01_axi_arprot;
   output wire [0 : 0] 	m01_axi_arvalid;
   input wire [0 : 0] 	m01_axi_arready;
   input wire [31 : 0] 	m01_axi_rdata;
   input wire [1 : 0] 	m01_axi_rresp;
   input wire [0 : 0] 	m01_axi_rvalid;
   output wire [0 : 0] 	m01_axi_rready;

   output wire [31 : 0] m02_axi_awaddr;
   output wire [2 : 0] 	m02_axi_awprot;
   output wire [0 : 0] 	m02_axi_awvalid;
   input wire [0 : 0] 	m02_axi_awready;
   output wire [31 : 0] m02_axi_wdata;
   output wire [3 : 0] 	m02_axi_wstrb;
   output wire [0 : 0] 	m02_axi_wvalid;
   input wire [0 : 0] 	m02_axi_wready;
   input wire [1 : 0] 	m02_axi_bresp;
   input wire [0 : 0] 	m02_axi_bvalid;
   output wire [0 : 0] 	m02_axi_bready;
   output wire [31 : 0] m02_axi_araddr;
   output wire [2 : 0] 	m02_axi_arprot;
   output wire [0 : 0] 	m02_axi_arvalid;
   input wire [0 : 0] 	m02_axi_arready;
   input wire [31 : 0] 	m02_axi_rdata;
   input wire [1 : 0] 	m02_axi_rresp;
   input wire [0 : 0] 	m02_axi_rvalid;
   output wire [0 : 0] 	m02_axi_rready;

   output wire [31 : 0] m03_axi_awaddr;
   output wire [2 : 0] 	m03_axi_awprot;
   output wire [0 : 0] 	m03_axi_awvalid;
   input wire [0 : 0] 	m03_axi_awready;
   output wire [31 : 0] m03_axi_wdata;
   output wire [3 : 0] 	m03_axi_wstrb;
   output wire [0 : 0] 	m03_axi_wvalid;
   input wire [0 : 0] 	m03_axi_wready;
   input wire [1 : 0] 	m03_axi_bresp;
   input wire [0 : 0] 	m03_axi_bvalid;
   output wire [0 : 0] 	m03_axi_bready;
   output wire [31 : 0] m03_axi_araddr;
   output wire [2 : 0] 	m03_axi_arprot;
   output wire [0 : 0] 	m03_axi_arvalid;
   input wire [0 : 0] 	m03_axi_arready;
   input wire [31 : 0] 	m03_axi_rdata;
   input wire [1 : 0] 	m03_axi_rresp;
   input wire [0 : 0] 	m03_axi_rvalid;
   output wire [0 : 0] 	m03_axi_rready;

   output wire [31 : 0] m04_axi_awaddr;
   output wire [2 : 0] 	m04_axi_awprot;
   output wire [0 : 0] 	m04_axi_awvalid;
   input wire [0 : 0] 	m04_axi_awready;
   output wire [31 : 0] m04_axi_wdata;
   output wire [3 : 0] 	m04_axi_wstrb;
   output wire [0 : 0] 	m04_axi_wvalid;
   input wire [0 : 0] 	m04_axi_wready;
   input wire [1 : 0] 	m04_axi_bresp;
   input wire [0 : 0] 	m04_axi_bvalid;
   output wire [0 : 0] 	m04_axi_bready;
   output wire [31 : 0] m04_axi_araddr;
   output wire [2 : 0] 	m04_axi_arprot;
   output wire [0 : 0] 	m04_axi_arvalid;
   input wire [0 : 0] 	m04_axi_arready;
   input wire [31 : 0] 	m04_axi_rdata;
   input wire [1 : 0] 	m04_axi_rresp;
   input wire [0 : 0] 	m04_axi_rvalid;
   output wire [0 : 0] 	m04_axi_rready;

   output wire [31 : 0] m05_axi_awaddr;
   output wire [2 : 0] 	m05_axi_awprot;
   output wire [0 : 0] 	m05_axi_awvalid;
   input wire [0 : 0] 	m05_axi_awready;
   output wire [31 : 0] m05_axi_wdata;
   output wire [3 : 0] 	m05_axi_wstrb;
   output wire [0 : 0] 	m05_axi_wvalid;
   input wire [0 : 0] 	m05_axi_wready;
   input wire [1 : 0] 	m05_axi_bresp;
   input wire [0 : 0] 	m05_axi_bvalid;
   output wire [0 : 0] 	m05_axi_bready;
   output wire [31 : 0] m05_axi_araddr;
   output wire [2 : 0] 	m05_axi_arprot;
   output wire [0 : 0] 	m05_axi_arvalid;
   input wire [0 : 0] 	m05_axi_arready;
   input wire [31 : 0] 	m05_axi_rdata;
   input wire [1 : 0] 	m05_axi_rresp;
   input wire [0 : 0] 	m05_axi_rvalid;
   output wire [0 : 0] 	m05_axi_rready;

   wire [191 : 0] 	m_axi_awaddr;	
   wire [17 : 0] 	m_axi_awprot;	
   wire [5 : 0] 	m_axi_awvalid;	
   wire [5 : 0] 	m_axi_awready;	
   wire [191 : 0] 	m_axi_wdata;	
   wire [23 : 0] 	m_axi_wstrb;	
   wire [5 : 0] 	m_axi_wvalid;	
   wire [5 : 0] 	m_axi_wready;	
   wire [11 : 0] 	m_axi_bresp;	
   wire [5 : 0] 	m_axi_bvalid;	
   wire [5 : 0] 	m_axi_bready;	
   wire [191 : 0] 	m_axi_araddr;	
   wire [17 : 0] 	m_axi_arprot;	
   wire [5 : 0] 	m_axi_arvalid;	
   wire [5 : 0] 	m_axi_arready;	
   wire [191 : 0] 	m_axi_rdata;	
   wire [11 : 0] 	m_axi_rresp;
   wire [5 : 0] 	m_axi_rvalid;
   wire [5 : 0] 	m_axi_rready;

   assign {m05_axi_awaddr, m04_axi_awaddr, m03_axi_awaddr, m02_axi_awaddr, m01_axi_awaddr, m00_axi_awaddr} = m_axi_awaddr;
   assign {m05_axi_awprot, m04_axi_awprot, m03_axi_awprot, m02_axi_awprot, m01_axi_awprot, m00_axi_awprot} = m_axi_awprot;
   assign {m05_axi_awvalid,m04_axi_awvalid,m03_axi_awvalid,m02_axi_awvalid,m01_axi_awvalid,m00_axi_awvalid} = m_axi_awvalid;
   
   assign m_axi_awready = {m05_axi_awready,m04_axi_awready,m03_axi_awready,m02_axi_awready,m01_axi_awready,m00_axi_awready};
   
   assign {m05_axi_wdata, m04_axi_wdata, m03_axi_wdata, m02_axi_wdata, m01_axi_wdata, m00_axi_wdata} = m_axi_wdata;
   assign {m05_axi_wstrb, m04_axi_wstrb, m03_axi_wstrb, m02_axi_wstrb, m01_axi_wstrb, m00_axi_wstrb} = m_axi_wstrb;
   assign {m05_axi_wvalid,m04_axi_wvalid,m03_axi_wvalid,m02_axi_wvalid,m01_axi_wvalid,m00_axi_wvalid} = m_axi_wvalid;
   
   assign m_axi_wready =  {m05_axi_wready,m04_axi_wready,m03_axi_wready,m02_axi_wready,m01_axi_wready,m00_axi_wready};
   assign m_axi_bresp  =  {m05_axi_bresp, m04_axi_bresp, m03_axi_bresp, m02_axi_bresp, m01_axi_bresp, m00_axi_bresp}; 
   assign m_axi_bvalid =  {m05_axi_bvalid,m04_axi_bvalid,m03_axi_bvalid,m02_axi_bvalid,m01_axi_bvalid,m00_axi_bvalid};
   
   assign {m05_axi_bready, m04_axi_bready, m03_axi_bready, m02_axi_bready, m01_axi_bready, m00_axi_bready} = m_axi_bready;
   assign {m05_axi_araddr, m04_axi_araddr, m03_axi_araddr, m02_axi_araddr, m01_axi_araddr, m00_axi_araddr} = m_axi_araddr;
   assign {m05_axi_arprot, m04_axi_arprot, m03_axi_arprot, m02_axi_arprot, m01_axi_arprot, m00_axi_arprot} = m_axi_arprot;
   assign {m05_axi_arvalid,m04_axi_arvalid,m03_axi_arvalid,m02_axi_arvalid,m01_axi_arvalid,m00_axi_arvalid} = m_axi_arvalid;
   
   assign m_axi_arready  = {m05_axi_arready,m04_axi_arready,m03_axi_arready,m02_axi_arready,m01_axi_arready,m00_axi_arready};
   assign m_axi_rdata    = {m05_axi_rdata,  m04_axi_rdata,  m03_axi_rdata,  m02_axi_rdata,  m01_axi_rdata,  m00_axi_rdata};
   assign m_axi_rresp    = {m05_axi_rresp,  m04_axi_rresp,  m03_axi_rresp,  m02_axi_rresp,  m01_axi_rresp,  m00_axi_rresp};
   assign m_axi_rvalid   = {m05_axi_rvalid, m04_axi_rvalid, m03_axi_rvalid, m02_axi_rvalid, m01_axi_rvalid, m00_axi_rvalid};
   
   assign {m05_axi_rready,m04_axi_rready,m03_axi_rready,m02_axi_rready,m01_axi_rready,m00_axi_rready} = m_axi_rready;

   axi_crossbar_1 
     u_axi_lite_bus
       (
	.aclk(aclk),                   
	.aresetn(aresetn),             
	.s_axi_awaddr(s00_axi_awaddr),   
	.s_axi_awprot(s00_axi_awprot),   
	.s_axi_awvalid(s00_axi_awvalid), 
	.s_axi_awready(s00_axi_awready), 
	.s_axi_wdata(s00_axi_wdata),     
	.s_axi_wstrb(s00_axi_wstrb),     
	.s_axi_wvalid(s00_axi_wvalid),   
	.s_axi_wready(s00_axi_wready),   
	.s_axi_bresp(s00_axi_bresp),     
	.s_axi_bvalid(s00_axi_bvalid),   
	.s_axi_bready(s00_axi_bready),   
	.s_axi_araddr(s00_axi_araddr),   
	.s_axi_arprot(s00_axi_arprot),   
	.s_axi_arvalid(s00_axi_arvalid), 
	.s_axi_arready(s00_axi_arready), 
	.s_axi_rdata(s00_axi_rdata),     
	.s_axi_rresp(s00_axi_rresp),     
	.s_axi_rvalid(s00_axi_rvalid),   
	.s_axi_rready(s00_axi_rready),   
	.m_axi_awaddr(m_axi_awaddr),   
	.m_axi_awprot(m_axi_awprot),   
	.m_axi_awvalid(m_axi_awvalid), 
	.m_axi_awready(m_axi_awready), 
	.m_axi_wdata(m_axi_wdata),     
	.m_axi_wstrb(m_axi_wstrb),     
	.m_axi_wvalid(m_axi_wvalid),   
	.m_axi_wready(m_axi_wready),   
	.m_axi_bresp(m_axi_bresp),     
	.m_axi_bvalid(m_axi_bvalid),   
	.m_axi_bready(m_axi_bready),   
	.m_axi_araddr(m_axi_araddr),   
	.m_axi_arprot(m_axi_arprot),   
	.m_axi_arvalid(m_axi_arvalid), 
	.m_axi_arready(m_axi_arready), 
	.m_axi_rdata(m_axi_rdata),     
	.m_axi_rresp(m_axi_rresp),     
	.m_axi_rvalid(m_axi_rvalid),   
	.m_axi_rready(m_axi_rready)    
	);

endmodule // axi_crossbar_1_top
