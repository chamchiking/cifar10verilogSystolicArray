`timescale 1ns / 1ps

module Convert_32to8(clk, data_in, data_out, t_done, start, t_signal, s_empty);
input clk;
input [31:0] data_in;
input t_done;
input start;
output reg [7:0]data_out;
output reg t_signal;
output reg s_empty;

reg state;
reg [31:0] data_temp;
reg [5:0] counter;
parameter idle = 1'b0, sending = 1'b1 ;

initial begin s_empty= 1; t_signal = 0; counter <= 0; state <= idle; end

always @(posedge clk) begin
    case(state)
        idle: begin
            s_empty = 0;  
            if(start) begin              
                     state = sending;
                     data_temp = data_in;
                     data_out = data_temp[31:24];
                     t_signal = 1;
                     end
        end
        
        sending : begin
                if(counter<4) begin
                    if(t_done) begin
                        data_temp = {data_temp[23:0], 8'h00 };
                        data_out = data_temp[31:24];
                        counter = counter +1;
                        if(counter == 4) begin
                            s_empty = 1; t_signal = 0; counter = 0; state = idle; end
                     end
                end     
                else;
        end
    endcase
end

endmodule
