module pool_module #
 (
      parameter integer C_S00_AXIS_TDATA_WIDTH   = 32

 )
 (   //AXI-STREAM
    input wire                                            clk,
    input wire                                            rstn,
    output wire                                           S_AXIS_TREADY,
    input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0]             S_AXIS_TDATA,
    input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0]         S_AXIS_TKEEP,
    input wire                                            S_AXIS_TUSER,
    input wire                                            S_AXIS_TLAST,
    input wire                                            S_AXIS_TVALID,
    input wire                                            M_AXIS_TREADY,
    output wire                                           M_AXIS_TUSER,
    output wire [C_S00_AXIS_TDATA_WIDTH-1 : 0]            M_AXIS_TDATA,
    output wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0]        M_AXIS_TKEEP,
    output wire                                           M_AXIS_TLAST,
    output wire                                           M_AXIS_TVALID,

     //Control
    input                                                 pool_start,
    output reg                                            pool_done,
    input[5:0]                                            flen,
    input[8:0]                                            in_channel
    
  );

  reg                                           m_axis_tuser;
  reg [C_S00_AXIS_TDATA_WIDTH-1 : 0]            m_axis_tdata;
  reg [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0]        m_axis_tkeep;
  reg                                           m_axis_tlast;
  reg                                           m_axis_tvalid;
  reg                                           s_axis_tready;

  assign S_AXIS_TREADY = s_axis_tready;
  assign M_AXIS_TLAST = m_axis_tlast;
  assign M_AXIS_TVALID = m_axis_tvalid;
  assign M_AXIS_TUSER = 1'b0;
  assign M_AXIS_TKEEP = {(C_S00_AXIS_TDATA_WIDTH/8) {1'b1}};

  wire[31:0] S_AXIS_TDATA_BIG;
  assign S_AXIS_TDATA_BIG = {S_AXIS_TDATA[7:0], S_AXIS_TDATA[15:8], S_AXIS_TDATA[23:16], S_AXIS_TDATA[31:24]};
  assign M_AXIS_TDATA = {m_axis_tdata[7:0], m_axis_tdata[15:8], m_axis_tdata[23:16], m_axis_tdata[31:24]};

  localparam IDLE = 3'd0;
  localparam RECEIVE_A1 = 3'd1; //flen != 4
  localparam RECEIVE_A2 = 3'd2;
  localparam RECEIVE_B1 = 3'd3; //flen == 4
  localparam RECEIVE_B2 = 3'd4;
  localparam SEND = 3'd5;
  localparam FINISH = 3'd6;

  reg[2:0] currState, nextState;
  reg[7:0] line[15:0];
  reg[3:0] receiveCount;
  reg[5:0] overallSendCount; //???? ??ея??? ?? ???? ??
  reg isSendStarted;
  reg[5:0] sendCount; //???? ???ея??? ???? ??
  reg[8:0] channelCount;
  reg isPoolUnfinished;
 /*
 ila_0 poolTest (
	.clk(clk), // input wire clk


	.probe0(currState), // input wire [2:0]  probe0  
	.probe1(receiveCount), // input wire [3:0]  probe1 
	.probe2(S_AXIS_TDATA), // input wire [31:0]  probe2 
	.probe3(sendCount), // input wire [5:0]  probe3 
	.probe4(overallSendCount), // input wire [5:0]  probe4 
	.probe5(channelCount), // input wire [8:0]  probe5 
	.probe6(M_AXIS_TDATA), // input wire [31:0]  probe6 
	.probe7(line[0]), // input wire [7:0]  probe7 
	.probe8(line[1]), // input wire [7:0]  probe8 
	.probe9(line[2]), // input wire [7:0]  probe9 
	.probe10(line[3]), // input wire [7:0]  probe10 
	.probe11(line[4]), // input wire [7:0]  probe11 
	.probe12(line[5]), // input wire [7:0]  probe12 
	.probe13(line[6]), // input wire [7:0]  probe13 
	.probe14(line[7]), // input wire [7:0]  probe14 
	.probe15(line[8]), // input wire [7:0]  probe15 
	.probe16(line[9]), // input wire [7:0]  probe16 
	.probe17(line[10]), // input wire [7:0]  probe17 
	.probe18(line[11]), // input wire [7:0]  probe18 
	.probe19(line[12]), // input wire [7:0]  probe19 
	.probe20(line[13]), // input wire [7:0]  probe20 
	.probe21(line[14]), // input wire [7:0]  probe21 
	.probe22(line[15]), // input wire [7:0]  probe22
	.probe23(S_AXIS_TVALID),
	.probe24(M_AXIS_TREADY)
);
 */

  //set currState
  always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
      currState <= IDLE;
    end
    else begin
      currState <= nextState;
    end
  end

  //set nextState
  always @(*) begin
    case(currState)
      IDLE: begin
        if(pool_start) begin
          if(flen == 4) begin
            nextState = RECEIVE_B1;
          end
          else begin
            nextState = RECEIVE_A1;
          end
        end
        else begin
          nextState = IDLE;
        end
      end

      RECEIVE_A1: begin
        if(receiveCount == flen / 4 - 1 && S_AXIS_TVALID) begin
          nextState = RECEIVE_A2;
        end
        else begin
          nextState = RECEIVE_A1;
        end
      end

      RECEIVE_A2: begin
        if(receiveCount == flen / 4 - 1 && S_AXIS_TVALID) begin
          nextState = SEND;
        end
        else begin
          nextState = RECEIVE_A2;
        end
      end

      RECEIVE_B1: begin
        if(receiveCount == 3 && S_AXIS_TVALID) begin
          nextState = RECEIVE_B2;
        end
        else begin
          nextState = RECEIVE_B1;
        end
      end

      RECEIVE_B2: begin
        nextState = SEND;
        /*
        if(S_AXIS_TVALID) begin
          nextState = SEND;
        end
        else begin
          nextState = RECEIVE_B2;
        end
        */
      end

      SEND: begin
        if(!isSendStarted) begin
          nextState = SEND;
        end
        else begin
          if(flen == 4) begin
            if(M_AXIS_TREADY) begin
              if(channelCount == in_channel - 1) begin
                nextState = FINISH;
              end
              else begin
                nextState = RECEIVE_B1;
              end
            end
            else begin
              nextState = SEND;
            end
          end
          else begin
            if(M_AXIS_TREADY) begin
              if(sendCount == flen / 8 - 1) begin //???? ???? ?? ??? ???? ??? ???? ???
                if(overallSendCount == flen * flen / 16 - 1) begin //???? ????? ?? ???? ???
                  if(channelCount == in_channel - 1) begin //?????? ????? ???
                    nextState = FINISH;
                  end
                  else begin //???? ????? ??? ???
                    nextState = RECEIVE_A1;
                  end
                end
                else begin //???? ????? ???? ????? ???
                  nextState = RECEIVE_A1;
                end
              end
              else begin //???? ???? ?? ???? ???
                nextState = SEND;
              end
            end
            else begin //VDMA ????? ???? ??? ??? ???
              nextState = SEND;
            end
          end 
        end
      end

      FINISH: begin
        if(pool_start == 0) begin
          nextState = IDLE;
        end
        else begin
          nextState = FINISH;
        end
      end

      default: begin
        nextState = IDLE;
      end
    endcase
  end

  //set control signal
  always @(posedge clk) begin
    case(currState)
      IDLE: begin
        channelCount <= 0;

        s_axis_tready <= 0;
        receiveCount <= 0;

        overallSendCount <= 0;
        sendCount <= 0;
        isSendStarted <= 0;
        m_axis_tlast <= 0;
        m_axis_tvalid <= 0;

        pool_done <= 0;
      end

      RECEIVE_A1: begin
        if(!s_axis_tready) begin
          s_axis_tready <= 1;
        end
        else if(S_AXIS_TVALID) begin
          if(nextState == RECEIVE_A2) begin
            s_axis_tready <= 0;
            receiveCount <= 0;
          end
          else begin
            receiveCount <= receiveCount + 1;
            s_axis_tready <= 1;
          end
        end
      end

      RECEIVE_A2: begin
        if(!s_axis_tready) begin
          s_axis_tready <= 1;
        end
        else if(S_AXIS_TVALID) begin
          if(nextState == SEND) begin
            s_axis_tready <= 0;
            receiveCount <= 0;
          end
          else begin
            receiveCount <= receiveCount + 1;
            s_axis_tready <= 1;
          end
        end
      end

      RECEIVE_B1: begin
        if(!s_axis_tready) begin
          s_axis_tready <= 1;
        end
        else if(S_AXIS_TVALID) begin
          if(nextState == RECEIVE_B2) begin
            s_axis_tready <= 0;
            receiveCount <= 0;
          end
          else begin
            receiveCount <= receiveCount + 1;
            s_axis_tready <= 1;
          end
        end
      end

      RECEIVE_B2: begin
      end

      SEND: begin
        if(flen == 4) begin
          if(isSendStarted) begin //?ещ?б╞????
            if(m_axis_tvalid && M_AXIS_TREADY) begin //???? ?? ??? ???
              channelCount <= channelCount + 1;
            end
            if(nextState != SEND) begin
              m_axis_tlast <= 0;
              isSendStarted <= 0;
              m_axis_tvalid <= 0;
            end
          end
          else begin //??? state?? ???? ???
            if(channelCount == in_channel - 1) begin
              m_axis_tlast <= 1;
            end
            isSendStarted <= 1;
            m_axis_tvalid <= 1;
          end
        end
        else begin
          if(isSendStarted) begin //?ещ?б╞????
            if(m_axis_tvalid && M_AXIS_TREADY) begin //??? ??? ?????
              if(overallSendCount == flen * flen / 16 - 1) begin //??? ?? ?????? ???
                if(channelCount == in_channel - 1) begin //?????? ???
                  channelCount <= 0;
                  m_axis_tlast <= 0;
                end
                else begin
                  channelCount <= channelCount + 1;
                end
                overallSendCount <= 0;
              end
              else begin //??? ?? ?????? ????? ??? ???
                if(overallSendCount == flen * flen / 16 - 2 && channelCount == in_channel - 1) begin 
                  m_axis_tlast <= 1;
                end
                overallSendCount <= overallSendCount + 1;
              end

              if(sendCount == flen / 8 - 1) begin
                sendCount <= 0;
              end
              else begin
                sendCount <= sendCount + 1;
              end
            end
            if(nextState != SEND) begin
              m_axis_tvalid <= 0;
              isSendStarted <= 0;
            end
          end
          else begin //SEND state?? ???? ??? ????? ?????? ??
            isSendStarted <= 1;
            m_axis_tvalid <= 1;
          end
        end
      end

      FINISH: begin
        pool_done <= 1;
        m_axis_tlast <= 0;
      end
    endcase
  end

  //line register ????
  wire[7:0] currentMaxA, currentMaxB;
  assign currentMaxA = (S_AXIS_TDATA_BIG[31:24] > S_AXIS_TDATA_BIG[23:16]) ? S_AXIS_TDATA_BIG[31:24] : S_AXIS_TDATA_BIG[23:16];
  assign currentMaxB = (S_AXIS_TDATA_BIG[15:8] > S_AXIS_TDATA_BIG[7:0]) ? S_AXIS_TDATA_BIG[15:8] : S_AXIS_TDATA_BIG[7:0];
  always @(posedge clk) begin
    if(currState == RECEIVE_A1 && S_AXIS_TVALID) begin
      line[receiveCount * 2] <= currentMaxA;
      line[receiveCount * 2 + 1] <= currentMaxB;
    end
    else if(currState == RECEIVE_A2 && S_AXIS_TVALID) begin
      line[receiveCount * 2] <= (line[receiveCount * 2] > currentMaxA) ? line[receiveCount * 2] : currentMaxA;
      line[receiveCount * 2 + 1] <= (line[receiveCount * 2 + 1] > currentMaxB) ? line[receiveCount * 2 + 1] : currentMaxB;
    end
    else if(currState == RECEIVE_B1 && S_AXIS_TVALID) begin
      line[receiveCount * 2] <= currentMaxA;
      line[receiveCount * 2 + 1] <= currentMaxB;
     end
     else if(currState == RECEIVE_B2) begin
      line[0] <= (line[0] > line[2]) ? line[0] : line[2];
      line[1] <= (line[1] > line[3]) ? line[1] : line[3];
      line[2] <= (line[4] > line[6]) ? line[4] : line[6];
      line[3] <= (line[5] > line[7]) ? line[5] : line[7];
    end
  end

  //send
  always @(posedge clk) begin
    if(currState == SEND) begin
      if(!m_axis_tvalid) begin
        m_axis_tdata[31:24] <= line[0];
        m_axis_tdata[23:16] <= line[1];
        m_axis_tdata[15:8] <= line[2];
        m_axis_tdata[7:0] <= line[3];
      end
      else if(M_AXIS_TREADY && nextState == SEND) begin
        m_axis_tdata[31:24] <= line[sendCount * 4 + 4];
        m_axis_tdata[23:16] <= line[sendCount * 4 + 5];
        m_axis_tdata[15:8] <= line[sendCount * 4 + 6];
        m_axis_tdata[7:0] <= line[sendCount * 4 + 7];
      end
    end
    else begin
      m_axis_tdata <= 0;
    end
  end
 
endmodule