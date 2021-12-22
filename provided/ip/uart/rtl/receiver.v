`timescale 1ns / 1ps

module receiver #(parameter baud_rate_count= 108)
( 
input clk,
input RxD,
input reset,
input receive,
output reg done,
output reg [7:0] data
    );
    reg [1:0] state_, next_state_;
    reg [3:0] bit_counter;
    reg [30:0] counter;
    reg clear;
    reg shift;
    initial begin done <= 0; state_ <=0; next_state_<= 0; counter <= 0; bit_counter <= 0; data <= 0; clear <=0; shift <= 0; end
    always @(posedge clk) begin
        if (reset) 
           begin // reset is asserted (reset = 1)
            state_ =0; // state is idle (state = 0)
            counter =0; // counter for baud rate is reset to 0 
            bit_counter =0; //counter for bit transmission is reset to 0
            data = 0;
           end
        else begin
             counter = counter + 1; //counter for baud rate generator start counting 
             done = 0;
             if (state_ ==0  && receive == 1 && next_state_ == 0)
                begin counter =0;
                       data = 0;
                       //bit_counter = 0;
                end
             if (counter >= baud_rate_count) begin  //if count to 10416 (from 0 to 10415)
                  state_ = next_state_; //previous state change to next state
                  counter = 0; // reset couter to 0
                 if (shift)  begin  
                            data = data >>1; 
                            data[7] = RxD; 
                            bit_counter = bit_counter+1;
                            if(bit_counter>= 8)
                                done =1; 
                             
                             end//load the data if load is asserted
                 if (clear) bit_counter = 0; // reset the bitcounter if clear is asserted
                      
                end
             end
     end
    always @(posedge clk) begin
        case(state_)
            0: begin if(receive) begin    //IDLE state
                    next_state_ <= 1;
                    shift <= 1; 
                    clear <= 0;
                end
               else begin          
                next_state_ <= 0;
                shift <= 0;
                clear <= 0;
                end
                end
            1: begin
               if(bit_counter>=8) begin
                clear <= 1;
                next_state_ <= 0;
                shift <= 0;
                end
               else begin
                clear <= 0;
                next_state_ <=1;
                shift <= 1;
                end
                end                
        endcase
    end
endmodule
