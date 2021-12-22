module apb_fc
 
    ( 
    // CPU Interface Input (APB bus interface) 
    input wire          PCLK,       // APB clock 
    input wire          PRESETB,    // APB asynchronous reset (0: reset, 1: normal) 
    input wire [31:0]   PADDR,      // APB address 
    input wire          PSEL,       // APB select 
    input wire          PENABLE,    // APB enable 
    input wire          PWRITE,     // APB write enable 
    input wire [31:0]   PWDATA,     // APB write data 
    input wire [31:0]   clk_counter,
    input wire [31:0]   max_index,
    input wire [0:0]    fc_done,
    
    output reg [20:0]    receive_size,
    output reg [2:0]     receiveCommand,
    input wire           feature_receive_done,
    input wire           bias_receive_done,
    input wire           weight_receive_done,

    // CPU Interface Output (APB bus interface)
    output wire [31:0]  PRDATA 
    ); 

    wire              state_enable;
    wire              state_enable_pre;
    reg [31:0]        prdata_reg;
 
    assign state_enable = PSEL & PENABLE;
    assign state_enable_pre = PSEL & ~PENABLE;

    // READ OUTPUT
    always @(posedge PCLK, negedge PRESETB) begin
      if (PRESETB == 1'b0) begin
        prdata_reg <= 32'h00000000;
      end
      else begin
        if (~PWRITE & state_enable_pre) begin
          case ({PADDR[31:2], 2'h0})
            /*READOUT*/
            32'h00000000 : prdata_reg <= receiveCommand;
            32'h00000004 : prdata_reg <= receive_size;
            32'h00000008 : prdata_reg <= weight_receive_done;
            32'h0000000c : prdata_reg <= fc_done;
            32'h00000010 : prdata_reg <= feature_receive_done;
            32'h00000014 : prdata_reg <= bias_receive_done;
            32'h0000001c : prdata_reg <= clk_counter;
            32'h00000020 : prdata_reg <= max_index;
 
            default: prdata_reg <= 32'h0; 
          endcase 
        end 
        else begin 
          prdata_reg <= 32'h0; 
        end 
      end 
    end 

    assign PRDATA = (~PWRITE & state_enable) ? prdata_reg : 32'h00000000;

    // WRITE ACCESS 
    always @(posedge PCLK, negedge PRESETB) begin 
      if (PRESETB == 1'b0) begin 
        /*WRITERES*/
        receiveCommand <= 0;
        receive_size <= 0;
      end 
      else begin 
        if (PWRITE & state_enable) begin 
          case ({PADDR[31:2], 2'h0}) 
            /*WRITEIN*/
            32'h00000000 : begin
              receiveCommand <= PWDATA[2:0];
            end 
            32'h00000004 : begin
              receive_size <= PWDATA[20:0];
            end
            default: ; 
          endcase 
        end 
      end 
    end 
 
endmodule 

