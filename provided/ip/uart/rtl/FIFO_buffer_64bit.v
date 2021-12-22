`timescale 1ns / 1ps

module FIFO_buffer_64bit(clk, reset, data_in, r_done, data_out, b_empty, b_full,DataReady);
    input clk;
    input reset;
    input [7:0] data_in;
    input r_done;
    output [63:0] data_out;
    output b_empty;
    output b_full;
    output DataReady;
    reg [1:0] state = 2'b00;
    wire wt_done, rd_done, EMPTY,FULL;
    reg RD=0;
    reg WR=0;
    reg EN=0;
    reg Rst=0;
    parameter Write = 2'b01, Read = 2'b10, Idle = 2'b00;
    assign b_full = FULL;
    assign b_empty = EMPTY;
    assign DataReady = rd_done;

    always @(posedge clk) begin
        if(reset) begin
            EN <= 1;
            Rst <= 1;
            state <= Idle;
            end
        else begin
            EN <= 0;
            Rst <= 0;
            case(state)
            Idle: if(r_done && !FULL) begin
                    EN <= 1; WR <= 1; state <= Write;   end

                  else if(FULL) begin
                    EN <= 1; RD <= 1; state <= Read;   end

                  else begin
                    EN <= 0; WR <= 0; RD <= 0; state <= Idle; end

            Write: begin
                  EN <= 0; WR <= 0;
                  if(wt_done) begin
                    if(FULL) begin
                     EN <= 1; RD <=1; state <= Read; end
                    else begin
                     EN <= 0; WR <= 0; state <= Idle;  end
                  end
                  else state <= Write;
                  end

            Read: if(rd_done) begin
                    EN <= 0; RD <= 0; state <= Idle;  end
            default:;
            endcase
        end
    end
    FIFO_64bit F1(.clk(clk), .dataIn(data_in), .RD(RD), .WR(WR), .EN(EN), .dataOut(data_out), .Rst(Rst), .EMPTY(EMPTY), .FULL(FULL), .wt_done(wt_done), .rd_done(rd_done));


endmodule
