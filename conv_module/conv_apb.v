module apb_conv
 
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
    input wire [0:0]    conv_done,
    
    output reg[5:0] flen,
    output reg[8:0] in_ch,
    output reg[8:0] out_ch,
    output reg[2:0] command,
    input wire input_done,
    input wire bias_done,
    input wire weight_done,
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
            32'h00000000 : prdata_reg <= command;
            32'h00000004 : prdata_reg <= in_ch;
            32'h00000008 : prdata_reg <= out_ch;
            32'h0000000c : prdata_reg <= flen;
            32'h00000020 : prdata_reg <= input_done;
            32'h00000024 : prdata_reg <= bias_done;
            32'h00000028 : prdata_reg <= weight_done;
            32'h0000002c : prdata_reg <= conv_done;
            
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
        command <= 0;
        in_ch <= 0;
        out_ch <= 0;
        flen <= 0;
        
      end 
      else begin 
        if (PWRITE & state_enable) begin 
          case ({PADDR[31:2], 2'h0}) 
            /*WRITEIN*/
            32'h00000000 : begin
              command <= PWDATA;
            end
            32'h00000004 : begin
              in_ch <= PWDATA;
            end
            32'h00000008 : begin
              out_ch <= PWDATA;
            end
            32'h0000000c : begin
              flen <= PWDATA;
            end
            default: ; 
          endcase 
        end 
      end 
    end 
 
endmodule 
