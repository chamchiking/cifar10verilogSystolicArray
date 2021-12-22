`timescale 1 ns / 1 ps


    module host_decoder_top
    #(
        // Users to add parameters here
        // User parameters ends
        // Do not modify the parameters beyond this line


        // Parameters of Axi Master Bus Interface M00_AXI
//      parameter  C_M00_AXI_START_DATA_VALUE   = 32'h61626364,
//      parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR = 32'h00000010,
        parameter integer C_M00_AXI_ADDR_WIDTH  = 32,
        parameter integer C_M00_AXI_DATA_WIDTH  = 32,
        parameter integer C_M00_AXI_TRANSACTIONS_NUM    = 1
    )
    (
        // Users to add ports here
        input wire RxD,
        output wire TxD,
        output wire system_start,
        output wire write_end,
        // User ports ends

        // Ports of Axi Master Bus Interface M00_AXI
//      input wire  m00_axi_init_axi_write,
//      input wire  m00_axi_init_axi_read,
        output wire  m00_axi_write_done,
        output wire  m00_axi_read_done,
        input wire  m00_axi_aclk,
        input wire  m00_axi_aresetn,
        output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
        output wire [2 : 0] m00_axi_awprot,
        output wire  m00_axi_awvalid,
        input wire  m00_axi_awready,
        output wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
        output wire [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
        output wire  m00_axi_wvalid,
        output wire m00_axi_wlast,
        input wire  m00_axi_wready,
        input wire [1 : 0] m00_axi_bresp,
        input wire  m00_axi_bvalid,
        output wire  m00_axi_bready,
        output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
        output wire [2 : 0] m00_axi_arprot,
        output wire  m00_axi_arvalid,
        input wire  m00_axi_arready,
        input wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
        input wire [1 : 0] m00_axi_rresp,
        input wire  m00_axi_rvalid,
        output wire  m00_axi_rready,
        input wire m00_axi_rlast
    );

    // wires & regs
    wire [7:0] data_in;
    wire [7:0] data_out;
    wire [63:0] uart_data_rcv;
    wire uart_trans_done;
    wire uart_data_ready;
    reg trans_start;
    wire [31:0] ddr_read_data;
    wire last_read;
    wire ddr_writes_done;
    wire ddr_reads_done;

    reg [63:0] dc_instruction;
    wire [27:0] dc_address;
    wire [31:0] dc_data;
    wire dc_we;
    wire dc_re;

    // Debug

// Instantiation of Axi Bus Interface M00_AXI
    axi_m_interface
    # (
//      .C_M_START_DATA_VALUE(C_M00_AXI_START_DATA_VALUE),
//      .C_M_TARGET_SLAVE_BASE_ADDR(C_M00_AXI_TARGET_SLAVE_BASE_ADDR),
        .C_M_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
        .C_M_AXI_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
        .C_M_TRANSACTIONS_NUM(C_M00_AXI_TRANSACTIONS_NUM)
    ) u_axi_m_interface (
//      .INIT_AXI_TXN(m00_axi_init_axi_txn),
        .WRITE_DONE(m00_axi_write_done),
        .READ_DONE(m00_axi_read_done),
        .M_AXI_ACLK(m00_axi_aclk),
        .M_AXI_ARESETN(m00_axi_aresetn),
        .M_AXI_AWADDR(m00_axi_awaddr),
        .M_AXI_AWPROT(m00_axi_awprot),
        .M_AXI_AWVALID(m00_axi_awvalid),
        .M_AXI_AWREADY(m00_axi_awready),
        .M_AXI_WDATA(m00_axi_wdata),
        .M_AXI_WSTRB(m00_axi_wstrb),
        .M_AXI_WVALID(m00_axi_wvalid),
        .M_AXI_WLAST(m00_axi_wlast),
        .M_AXI_WREADY(m00_axi_wready),
        .M_AXI_BRESP(m00_axi_bresp),
        .M_AXI_BVALID(m00_axi_bvalid),
        .M_AXI_BREADY(m00_axi_bready),
        .M_AXI_ARADDR(m00_axi_araddr),
        .M_AXI_RLAST(m00_axi_rlast),
        .M_AXI_ARPROT(m00_axi_arprot),
        .M_AXI_ARVALID(m00_axi_arvalid),
        .M_AXI_ARREADY(m00_axi_arready),
        .M_AXI_RDATA(m00_axi_rdata),
        .M_AXI_RRESP(m00_axi_rresp),
        .M_AXI_RVALID(m00_axi_rvalid),
        .M_AXI_RREADY(m00_axi_rready),

        .RxD(),
        .TxD(),
        .INIT_AXI_WRITE(dc_we),
        .INIT_AXI_READ(dc_re),
        .writes_done(ddr_writes_done),
        .reads_done(ddr_reads_done),
        .input_address(dc_address),
        .input_data(dc_data),
        .read_data(ddr_read_data)
    );


    // Add user logic here

    uart_top u_uart_top
    (
        .clk(m00_axi_aclk),
        .reset(~m00_axi_aresetn),
        .RxD(RxD),
        .uart_trans_start(ddr_reads_done),
        .uart_data_trans(ddr_read_data),
        .TxD(TxD),
        .uart_data_ready(uart_data_ready),
        .uart_trans_done(uart_trans_done),
        .uart_data_rcv(uart_data_rcv)
      );


      host_decoder u_host_decoder(
        .clk(m00_axi_aclk),
        .rstn(m00_axi_aresetn),
        .uart_data_ready(uart_data_ready),
        .uart_input_data(uart_data_rcv),
        .address(dc_address),
        .data(dc_data),
        .system_start(system_start),
        .write_end(write_end),
        .we(dc_we),
        .re(dc_re)
      );


    endmodule
