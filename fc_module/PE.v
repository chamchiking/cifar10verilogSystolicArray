module PE
    #(
      parameter N=32
    )
    (
    input clk, rst_n,
    input signed [7:0] in_a, in_b,
    input      in_fin_a,
    output reg signed [7:0] out_a,
    output reg signed [N-1:0] out_c,
    output reg out_fin_a
    );
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            out_a <=0;
            out_c <=0;
            out_fin_a <=0;
        end
        else if(out_fin_a==1) begin
            out_fin_a <=0;
            out_c <= out_c;
        end
        else begin
            out_c <= out_c + in_a * in_b;
            out_a <= in_a;
            out_fin_a <= in_fin_a;
        end
    end
endmodule

module PE4
    #(
      parameter N = 32  
    )
    (
    input clk, rst_n,
    input [31:0] bias,
    input [7:0] in_a,
    input  data_fin_a,
    input [7:0] in_b1, in_b2, in_b3, in_b4,
    output reg [31:0] send_result, 
    output reg all_done
    );
    wire [4*N-1:0]  out_c_all;
    wire signed [7:0] inter1, inter2, inter3;
    wire [3:0]  finish;
    PE #(N) pe1(.clk(clk), .rst_n(rst_n), .in_a(in_a[7:0]), .in_b(in_b1[7:0]), .in_fin_a(data_fin_a), .out_a(inter1), .out_fin_a(finish[0]), .out_c(out_c_all[N-1:0]) );
    PE #(N) pe2(.clk(clk), .rst_n(rst_n), .in_a(inter1), .in_b(in_b2[7:0]), .in_fin_a(finish[0]), .out_a(inter2), .out_fin_a(finish[1]), .out_c(out_c_all[2*N-1:N]) );
    PE #(N) pe3(.clk(clk), .rst_n(rst_n), .in_a(inter2), .in_b(in_b3[7:0]), .in_fin_a(finish[1]), .out_a(inter3), .out_fin_a(finish[2]), .out_c(out_c_all[3*N-1:2*N]) );
    PE #(N) pe4(.clk(clk), .rst_n(rst_n), .in_a(inter3), .in_b(in_b4[7:0]), .in_fin_a(finish[2]), .out_a(          ), .out_fin_a(finish[3]), .out_c(out_c_all[4*N-1:3*N]) );
    wire [4*N-1:0] temp;
    wire [31:0] temp_q;    //그때그때의 quantization 값들을 저장하고 있는 부분
    
    
    reg accumulate_done;
    always @ (posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            accumulate_done <=0;
            all_done <=0;
        end
        else begin
            if(finish[3])begin
                accumulate_done <=1;
            end
            if(accumulate_done) begin
                all_done <=1;
            end
            else if(all_done)begin
                all_done <=0;
            end
        end
    end
    
    always @ (posedge clk) begin
        case(finish)
            4'b0001: begin
                //첫번째 accumulate finish
                //첫번째 quntization 부분만 입력
                send_result[31:24]<= temp_q[31:24];
            end
            4'b0010: begin
                //두번째 accumulate finish
                send_result[23:16]<= temp_q[23:16];
            end
            4'b0101: begin
                //세번째 accumulate finish
                send_result[15:8]<= temp_q[15:8];
            end
            4'b1010: begin
                //네번째 accumulate finish
                send_result[7:0]<= temp_q[7:0];
            end
            default:;
        endcase
    end
    
    //accumulate값 + bias를 가지고 있는부분
    assign temp[4*N-1:3*N] = $signed(out_c_all[N-1:0]) + $signed({bias[7:0],{6{1'b0}}});
    assign temp[3*N-1:2*N] = $signed(out_c_all[2*N-1:N]) + $signed({bias[15:8],{6{1'b0}}});
    assign temp[2*N-1:N] = $signed(out_c_all[3*N-1:2*N]) + $signed({bias[23:16],{6{1'b0}}});
    assign temp[N-1:0] = $signed(out_c_all[4*N-1:3*N]) + $signed({bias[31:24],{6{1'b0}}});
    
    //quantization 하는 부분
    assign temp_q[31] = temp[4*N-1];
    assign temp_q[30:24] = ({(N-14){temp[4*N-1]}} == temp[4*N-2:3*N+13]) ? temp[3*N+12:3*N+6]: {7{!temp[4*N-1]}};
    assign temp_q[23] = temp[3*N-1];
    assign temp_q[22:16] = ({(N-14){temp[3*N-1]}} == temp[3*N-2:2*N+13]) ? temp[2*N+12:2*N+6]: {7{!temp[3*N-1]}};
    assign temp_q[15] = temp[2*N-1];
    assign temp_q[14:8] = ({(N-14){temp[2*N-1]}} == temp[2*N-2:N+13]) ? temp[N+12:N+6]: {7{!temp[2*N-1]}};
    assign temp_q[7] = temp[N-1];
    assign temp_q[6:0] = ({(N-14){temp[N-1]}} == temp[N-2:13]) ? temp[12:6]: {7{!temp[N-1]}};
endmodule