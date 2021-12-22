`timescale 1ns / 1ps

module host_decoder(clk, rstn, uart_data_ready, uart_input_data, address, data, system_start, write_end, we, re);

    input clk;
    input rstn;
    input uart_data_ready;
    input [63:0] uart_input_data;
    output reg [27:0] address;
    output reg [31:0] data;
    output reg system_start;        // to controller
    output reg write_end;            // to controller
    output reg we;
    output reg re;

    wire [3:0] opcode;
    reg [63:0] instruction;

    parameter start = 4'b0010, w_end = 4'b0011  , write =4'b0100, read = 4'b0101;

    assign opcode = instruction[63:60];


    always @(posedge clk) begin
        if (rstn == 0) begin
            instruction <= 64'h0000_0000_0000_0000;
        end
        else if (uart_data_ready) begin
            instruction <= uart_input_data;
        end
        else begin
            instruction <= 0;
        end
    end



    always @(posedge clk or negedge rstn) begin
        if(~rstn) begin
            system_start <= 0;
            write_end <= 0;
            address <= 0;
            data <= 0;
            we <= 0;
            re <= 0;
        end
        else
            case(opcode)
                start: begin
                    system_start <= 1;
                    write_end <= 0;
                    address <= 0;
                    data <= 0;
                    we <= 0;
                    re <= 0;
                end

                w_end: begin
                    system_start <= 0;
                    write_end <= 1;
                    address <= 0;
                    data <= 0;
                    we <= 0;
                    re <= 0;
                end

                write: begin
                    system_start <= 0;
                    write_end <= 0;
                    address <= instruction[59:32];
                    data  <=  instruction[31:0];
                    we <= 1;
                    re <= 0;
                end

                read: begin
                    system_start <= 0;
                    write_end <= 0;
                    address <= instruction[59:32];
                    data <= 0;
                    we <= 0;
                    re <= 1;
                end

                default: begin
                    system_start <= 0;
                    write_end <= 0;
                    address <= 0;
                    data <= 0;
                    we <= 0;
                    re <= 0;
                end
            endcase
    end


endmodule
