`timescale 1ns / 1ps

module uart_top
#(
    parameter baud_rate_count = 108,
    parameter threshold = 20
)
(
        input 	      clk,
		input 	      reset,
		input 	      RxD,
        input         uart_trans_start,
		input [31:0]  uart_data_trans,
		
		output 	      TxD,
		output        uart_data_ready,
		output        uart_trans_done,
		output [63:0]  uart_data_rcv
		);

   wire [7:0] 		 data_in;		
   wire [7:0] 		 data_out;
   wire 		     transmit;
   wire 		     receive;
   wire 		     r_done;
   wire 		     t_done;
   wire 		     b_empty;
   wire 		     b_full;
   wire 		     c_done;
   wire 		     t_signal;

   receive_debouncing 
     #(.threshold(threshold)) 
   u_receive_debouncing 
     (
      .clk(clk),
      .d_in(RxD),
      .done(r_done),
      .receive(receive));
   
   receiver
     #(.baud_rate_count(baud_rate_count)) 
   u_receiver 
     (
      .clk(clk),
      .RxD(RxD),
      .reset(reset),
      .receive(receive),
      .done(r_done),
      .data(data_in)); 

   FIFO_buffer_64bit 
     u_FIFO_buffer_64bit
       (
	.clk(clk),
	.reset(reset),
	.data_in(data_in),
	.r_done(r_done),
	.data_out(uart_data_rcv),
	.b_empty(b_empty),
	.b_full(b_full),
	.DataReady(uart_data_ready));

   Convert_32to8 
     u_Convert_32to8 
       (
	.clk(clk),
	.data_in(uart_data_trans),
	.t_done(t_done),
	.start(uart_trans_start),
	.data_out(data_out),
	.t_signal(t_signal),
	.s_empty(uart_trans_done));
   
   transmit_debouncing
     #(.threshold(threshold))  
   u_transmit_debouncing 
       (
	.clk(clk),
	.btn1(t_signal),
	.transmit(transmit),
	.stop(uart_trans_done),
	.t_done(t_done));
   
   transmitter
     #(.baud_rate_count(baud_rate_count))  
   u_transmitter 
       (
	.clk(clk),
	.reset(reset),
	.transmit(transmit),
	.TxD(TxD),
	.data(data_out),
	.done(t_done));

endmodule