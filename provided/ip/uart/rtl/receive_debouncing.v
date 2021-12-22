`timescale 1ns / 1ps

module receive_debouncing #(parameter threshold = 20)// set parameter thresehold to guage how long button pressed
(
input clk, //clock signal
input d_in, //input buttons for receive and reset
input done,
output reg receive //receive signal
);
    
reg button_ff1 = 0; //button flip-flop for synchronization. Initialize it to 0
reg button_ff2 = 0; //button flip-flop for synchronization. Initialize it to 0
reg [30:0]count_r = 0; //20 bits count for increment & decrement when button is pressed or released. Initialize it to 0 


// First use two flip-flops to synchronize the button signal the "clk" clock domain

always @(posedge clk) begin
button_ff1 <= d_in;
button_ff2 <= button_ff1;
end



// When the push-button is pushed or released, we increment or decrement the counter
// The counter has to reach threshold before we decide that the push-button state has changed
always @(posedge clk) begin 
    if (done) begin
        count_r <=0;
        receive <= 0;
        end
    else begin
    if (!button_ff2) begin//if button_ff2 is 1 
        if (~&count_r)//if it isn't at the count limit. Make sure won't count up at the limit. First AND all count and then not the AND
            count_r <= count_r+1; // when btn pressed, count up
    end 
    else begin
    if (|count_r)//if count has at least 1 in it. Make sure no subtraction when count is 0 
            count_r <= count_r-1; //when btn relesed, count down
    end
 
 
    if (count_r > threshold )//if the count is greater the threshold 
        receive <= 1; //debounced signal is 1
    else
        receive <= 0; //debounced signal is 0
    end
end


endmodule
