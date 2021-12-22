module fc_module #
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
    output reg [31:0]                                     max_index, // Only for last fully connected layer. It has same functionality with softmax. If output size is 10, max_index indicate index of value which is largest of 10 outputs.
    output reg                                            fc_done,
    
    input[20:0]                                           receive_size,//입력받는 원소의 수
    input[2:0]                                            receiveCommand,
    
    output reg                                            feature_receive_done,
    output reg                                            bias_receive_done,
    output reg                                            weight_receive_done
  );


  reg                                           m_axis_tuser;
  reg [C_S00_AXIS_TDATA_WIDTH-1 : 0]            m_axis_tdata;
  reg [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0]        m_axis_tkeep;
  reg                                           m_axis_tlast;
  reg                                           m_axis_tvalid;
  reg                                          s_axis_tready;
  reg                                          is_last_layer;
  assign S_AXIS_TREADY = s_axis_tready;
  assign M_AXIS_TDATA = m_axis_tdata;
  assign M_AXIS_TLAST = m_axis_tlast;
  assign M_AXIS_TVALID = m_axis_tvalid;
  assign M_AXIS_TUSER = 1'b0;
  assign M_AXIS_TKEEP = {(C_S00_AXIS_TDATA_WIDTH/8) {1'b1}}; 
  
  reg[3:0] currState, nextState;
  reg[20:0] receiveCount;
  reg[20:0] weightLineSize; //한 weight 행의 원소 수
  reg[6:0] weightReceiveCountSize; //weight 4줄을 몇번 반복해서 받아와야 하는지
  reg[7:0] sendRowCount;
  
  reg[7:0] featureRamAddr;
  wire[31:0] featureDataOut;
  reg featureRamEna;
  wire featureRamEnaWire, featureRamWriteEna;
  
  reg[5:0] biasRamAddr;
  wire[31:0] biasDataOut;
  reg biasRamEna;
  wire biasRamEnaWire, biasRamWriteEna;

  reg[7:0] weightRamAddr[3:0];
  wire[31:0] weightDataOut[3:0];
  reg[3:0] weightRamEna;
  wire[3:0] weightRamEnaWire, weightRamWriteEna;

  localparam Idle = 4'd0;
  localparam FeatureReceive = 4'd1;
  localparam FeatureReceiveDone = 4'd2;
  localparam BiasReceive = 4'd3;
  localparam BiasReceiveDone = 4'd4;
  localparam WeightReceive_0 = 4'd5;
  localparam WeightReceive_1 = 4'd6;
  localparam WeightReceive_2 = 4'd7;
  localparam WeightReceive_3 = 4'd8;
  localparam WeightReceiveDone = 4'd9;
  localparam Calculate = 4'd10;
  localparam Send = 4'd11;
  localparam Finish = 4'd12;

  localparam FeatureReceiveCommand = 3'd1;
  localparam BiasReceiveCommand = 3'd2;
  localparam WeightReceiveCommand = 3'd4;
  localparam FCStartCommand = 3'd5;
  
  assign featureRamEnaWire = (currState == FeatureReceive) ? S_AXIS_TVALID && S_AXIS_TREADY : featureRamEna;
  assign featureRamWriteEna = (currState == FeatureReceive) ? S_AXIS_TVALID && S_AXIS_TREADY : 0;
  assign biasRamEnaWire = (currState == BiasReceive) ? S_AXIS_TVALID && S_AXIS_TREADY : biasRamEna;
  assign biasRamWriteEna = (currState == BiasReceive) ? S_AXIS_TVALID && S_AXIS_TREADY : 0;
  assign weightRamEnaWire[0] = (currState == WeightReceive_0) ? {4{S_AXIS_TVALID && S_AXIS_TREADY}} : weightRamEna[0];
  assign weightRamEnaWire[1] = (currState == WeightReceive_1) ? {4{S_AXIS_TVALID && S_AXIS_TREADY}} : weightRamEna[1];
  assign weightRamEnaWire[2] = (currState == WeightReceive_2) ? {4{S_AXIS_TVALID && S_AXIS_TREADY}} : weightRamEna[2];
  assign weightRamEnaWire[3] = (currState == WeightReceive_3) ? {4{S_AXIS_TVALID && S_AXIS_TREADY}} : weightRamEna[3];
  assign weightRamWriteEna[0] = (currState == WeightReceive_0) ? {4{S_AXIS_TVALID && S_AXIS_TREADY}} : 0;
  assign weightRamWriteEna[1] = (currState == WeightReceive_1) ? {4{S_AXIS_TVALID && S_AXIS_TREADY}} : 0;
  assign weightRamWriteEna[2] = (currState == WeightReceive_2) ? {4{S_AXIS_TVALID && S_AXIS_TREADY}} : 0;
  assign weightRamWriteEna[3] = (currState == WeightReceive_3) ? {4{S_AXIS_TVALID && S_AXIS_TREADY}} : 0;
  
  sram_32x256 featureRam(.addra(featureRamAddr), .clka(clk), .dina(S_AXIS_TDATA), .douta(featureDataOut), 
                          .ena(featureRamEnaWire), .wea(featureRamWriteEna));
  sram_32x64 biasRam(.addra(biasRamAddr), .clka(clk), .dina(S_AXIS_TDATA), .douta(biasDataOut), 
                          .ena(biasRamEnaWire), .wea(biasRamWriteEna));                          
  sram_32x256 weightRam_0(.addra(weightRamAddr[0]), .clka(clk), .dina(S_AXIS_TDATA), .douta(weightDataOut[0]), 
                          .ena(weightRamEnaWire[0]), .wea(weightRamWriteEna[0]));
  sram_32x256 weightRam_1(.addra(weightRamAddr[1]), .clka(clk), .dina(S_AXIS_TDATA), .douta(weightDataOut[1]), 
                          .ena(weightRamEnaWire[1]), .wea(weightRamWriteEna[1]));
  sram_32x256 weightRam_2(.addra(weightRamAddr[2]), .clka(clk), .dina(S_AXIS_TDATA), .douta(weightDataOut[2]), 
                          .ena(weightRamEnaWire[2]), .wea(weightRamWriteEna[2]));
  sram_32x256 weightRam_3(.addra(weightRamAddr[3]), .clka(clk), .dina(S_AXIS_TDATA), .douta(weightDataOut[3]), 
                          .ena(weightRamEnaWire[3]), .wea(weightRamWriteEna[3]));
  
  reg[20:0]PE_feature_count;//총 feature에 넣은 데이터 수
  reg[1:0] PE_count; //4개씩 세는것
  wire[31:0] send_data;
  wire       PE_calc_done;
  reg       PE_in_done;
  reg       PE_clk;
  reg       PE_set;
  reg       PE_reset_n;
  wire signed[7:0] PE_feature_data;
  wire signed[7:0] PE_weight_data1;
  wire signed[7:0] PE_weight_data2;
  wire signed[7:0] PE_weight_data3;
  wire signed[7:0] PE_weight_data4;
  wire [7:0] PE_current_max;
  wire [7:0] PE_current_max0;
  wire [7:0] PE_current_max1;
  reg [7:0] fc_max;
  reg [2:0] max_count;
  
  PE4      PE4(.clk(PE_clk), .rst_n(PE_reset_n), .bias(biasDataOut), .in_a(PE_feature_data), .data_fin_a(PE_in_done),
               .in_b1(PE_weight_data1), .in_b2(PE_weight_data2), .in_b3(PE_weight_data3), .in_b4(PE_weight_data4),
               .send_result(send_data[31:0]), .all_done(PE_calc_done) );
               
  assign PE_feature_data =(PE_feature_count <1 || PE_feature_count>weightLineSize) ? {8{1'b0}}: (PE_count==1) ? featureDataOut[7:0]:(PE_count==2)? featureDataOut[15:8]: (PE_count==3)? featureDataOut[23:16]: featureDataOut[31:24];
  assign PE_weight_data1 =(PE_feature_count <1 || PE_feature_count>weightLineSize) ? {8{1'b0}}: (PE_count==1) ? weightDataOut[0][7:0]:(PE_count==2)? weightDataOut[0][15:8]: (PE_count==3)? weightDataOut[0][23:16]: weightDataOut[0][31:24];
  assign PE_weight_data2 =(PE_feature_count <2 || PE_feature_count>weightLineSize+1) ? {8{1'b0}}: (PE_count==1) ? weightDataOut[1][31:24]:(PE_count==2)? weightDataOut[1][7:0]: (PE_count==3)? weightDataOut[1][15:8]: weightDataOut[1][23:16];
  assign PE_weight_data3 =(PE_feature_count <3 || PE_feature_count > weightLineSize+2) ? {8{1'b0}}: (PE_count==1) ? weightDataOut[2][23:16]:(PE_count==2)? weightDataOut[2][31:24]: (PE_count==3)? weightDataOut[2][7:0]: weightDataOut[2][15:8];
  assign PE_weight_data4 =(PE_feature_count <4 || PE_feature_count > weightLineSize+3) ? {8{1'b0}}: (PE_count==1) ? weightDataOut[3][15:8]:(PE_count==2)? weightDataOut[3][23:16]: (PE_count==3)? weightDataOut[3][31:24]: weightDataOut[3][7:0];
  assign PE_current_max0 = ($signed(send_data[31:24]) > $signed(send_data[23:16])) ? send_data[31:24]:send_data[23:16];
  assign PE_current_max1 = ($signed(send_data[15:8]) > $signed(send_data[7:0])) ? send_data[15:8]:send_data[7:0];
  assign PE_current_max = ($signed(PE_current_max0) > $signed(PE_current_max1)) ? PE_current_max0:PE_current_max1;

/*
ila_0 fcTest (
   .clk(clk), // input wire clk


   .probe0(currState), // input wire [3:0]  probe0  
   .probe1(S_AXIS_TDATA), // input wire [31:0]  probe1 
   .probe2(S_AXIS_TVALID), // input wire [0:0]  probe2 
   .probe3(S_AXIS_TREADY), // input wire [0:0]  probe3 
   .probe4(M_AXIS_TDATA), // input wire [31:0]  probe4 
   .probe5(M_AXIS_TVALID), // input wire [0:0]  probe5 
   .probe6(M_AXIS_TREADY), // input wire [0:0]  probe6 
   .probe7(receiveCount), // input wire [20:0]  probe7 
   .probe8(sendRowCount), // input wire [7:0]  probe8 
   .probe9(M_AXIS_TLAST), // input wire [0:0]  probe9 
   .probe10(S_AXIS_TLAST), // input wire [0:0]  probe10 
   .probe11(biasRamEnaWire), // input wire [0:0]  probe11 
   .probe12(biasRamWriteEna), // input wire [0:0]  probe12 
   .probe13(weightRamEnaWire), // input wire [3:0]  probe13 
   .probe14(weightRamWriteEna), // input wire [3:0]  probe14 
   .probe15(featureRamAddr), // input wire [7:0]  probe15 
   .probe16(biasRamAddr), // input wire [5:0]  probe16 
   .probe17(weightRamAddr[0]), // input wire [7:0]  probe17 
   .probe18(weightRamAddr[1]), // input wire [7:0]  probe18 
   .probe19(weightRamAddr[2]), // input wire [7:0]  probe19 
   .probe20(weightRamAddr[3]), // input wire [7:0]  probe20
   .probe21(featureDataOut), // input wire [31:0]  probe21 
   .probe22(biasDataOut), // input wire [31:0]  probe22 
   .probe23(max_index), // input wire [31:0]  probe23 
   .probe24(weightDataOut[1]), // input wire [31:0]  probe24 
   .probe25(weightDataOut[2]), // input wire [31:0]  probe25 
   .probe26(weightDataOut[3]), // input wire [31:0]  probe26 
   .probe27(PE_feature_data), // input wire [7:0]  probe27 
   .probe28(PE_weight_data1), // input wire [7:0]  probe28 
   .probe29(PE_weight_data2), // input wire [7:0]  probe29 
   .probe30(PE_weight_data3), // input wire [7:0]  probe30 
   .probe31(PE_weight_data4), // input wire [7:0]  probe31
   .probe32(fc_max), // input wire [7:0]  probe32 
   .probe33(PE4.out_c_all[18:0]), // input wire [18:0]  probe33 
   .probe34(PE4.out_c_all[37:19]), // input wire [18:0]  probe34 
   .probe35(PE4.out_c_all[56:38]), // input wire [18:0]  probe35 
   .probe36(PE4.out_c_all[75:57]), // input wire [18:0]  probe36,
   .probe37(PE_clk), // input wire [0:0]  probe37 
   .probe38(PE_reset_n), // input wire [0:0]  probe38
   .probe39(PE4.temp[18:0]), // input wire [18:0]  probe39 
   .probe40(PE4.temp[37:19]), // input wire [18:0]  probe40 
   .probe41(PE4.temp[56:38]), // input wire [18:0]  probe41 
   .probe42(PE4.temp[75:57]), // input wire [18:0]  probe42
   .probe43(PE4.temp_q), // input wire [31:0]  probe43
   .probe44(receive_size), // input wire [20:0]  probe44 
   .probe45(weightLineSize), // input wire [20:0]  probe45 
   .probe46(weightReceiveCountSize), // input wire [6:0]  probe46 
   .probe47(is_last_layer), // input wire [0:0]  probe47
   .probe48(max_count), // input wire [2:0]  probe48
   .probe49(receiveCommand) // input wire [2:0]  probe49
   
);
  */

  //set currState
  always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
      currState <= Idle;
    end
    else begin
      currState <= nextState;
    end
  end

  //set nextState
  always @(*) begin
    case(currState)
      Idle: begin
        if(receiveCommand == FeatureReceiveCommand) begin
          nextState = FeatureReceive;
        end
        else begin
          nextState = Idle;
        end
      end

      FeatureReceive: begin
        if(receiveCount == receive_size / 4 - 1 && S_AXIS_TVALID) begin
          nextState = FeatureReceiveDone;
        end
        else begin
          nextState = FeatureReceive;
        end
      end

      FeatureReceiveDone: begin
        if(receiveCommand == BiasReceiveCommand) begin
          nextState = BiasReceive;
        end
        else begin
          nextState = FeatureReceiveDone;
        end
      end

      BiasReceive: begin
        if(!is_last_layer) begin
            if(receiveCount == receive_size / 4 - 1 && S_AXIS_TVALID) begin
              nextState = BiasReceiveDone;
            end
            else begin
              nextState = BiasReceive;
            end
        end
        else begin
            if(receiveCount == receive_size / 4 && S_AXIS_TVALID) begin
              nextState = BiasReceiveDone;
            end
            else begin
              nextState = BiasReceive;
            end
        end
      end

      BiasReceiveDone: begin
        if(receiveCommand == WeightReceiveCommand) begin
          nextState = WeightReceive_0;
        end
        else begin
          nextState = BiasReceiveDone;
        end
      end

      WeightReceive_0: begin
        if(receiveCount == weightLineSize / 4 - 1 && S_AXIS_TVALID) begin
          nextState = WeightReceive_1;
        end
        else begin
          nextState = WeightReceive_0;
        end
      end

      WeightReceive_1: begin
        if(receiveCount == weightLineSize / 4 - 1 && S_AXIS_TVALID) begin
            if(sendRowCount == 2 && is_last_layer) begin
                nextState = WeightReceiveDone;
            end
            else begin
                 nextState = WeightReceive_2;
            end
        end
        else begin
          nextState = WeightReceive_1;
        end
      end

      WeightReceive_2: begin
        if(receiveCount == weightLineSize / 4 - 1 && S_AXIS_TVALID) begin
          nextState = WeightReceive_3;
        end
        else begin
          nextState = WeightReceive_2;
        end
      end

      WeightReceive_3: begin
        if(receiveCount == weightLineSize / 4 - 1 && S_AXIS_TVALID) begin
          nextState = WeightReceiveDone;
        end
        else begin
          nextState = WeightReceive_3;
        end
      end
      
      WeightReceiveDone:begin
        if(receiveCommand == FCStartCommand) begin
          nextState = Calculate;
        end
        else begin
          nextState = WeightReceiveDone;
        end
      end
      
      Calculate: begin
        if(PE_calc_done) begin
          nextState = Send;
        end
        else begin
          nextState = Calculate;
        end
      end
      
      Send: begin
        if(m_axis_tvalid && M_AXIS_TREADY&& is_last_layer==0)begin
            if(sendRowCount == weightReceiveCountSize - 1) begin
                nextState = Finish;
            end
            else begin
                nextState = WeightReceive_0;
            end
        end
        else if(m_axis_tvalid && M_AXIS_TREADY&& is_last_layer==1) begin
            if(sendRowCount == weightReceiveCountSize && max_count==2) begin
                nextState = Finish;
            end
            else if(sendRowCount < weightReceiveCountSize && max_count==4) begin
                nextState = WeightReceive_0;
            end
            else begin
                nextState = Send;
            end
        end
        else begin
            nextState = Send;
        end
      end
      
      Finish: begin
        if(receiveCommand == 0) begin
          nextState = Idle;
        end
        else begin
          nextState = Finish;
        end
      end
      
      default: begin
        nextState = Idle;
      end
    endcase
  end

  //set control signal
  always @(posedge clk) begin
    case(currState)
      Idle: begin
        receiveCount <= 0;
        weightLineSize <= 0;
        weightReceiveCountSize <= 0;

        s_axis_tready <= 0;
        m_axis_tdata <= 0;
        m_axis_tvalid <= 0;
        featureRamAddr <= 0;
        featureRamEna <= 0;
//        featureRamWriteEna <= 0;
        feature_receive_done <= 0;

        biasRamAddr <= 0;
        biasRamEna <= 0;
//        biasRamWriteEna <= 0;
        bias_receive_done <= 0;

        weightRamAddr[0] <= 0;
        weightRamAddr[1] <= 0;
        weightRamAddr[2] <= 0;
        weightRamAddr[3] <= 0;
        weightRamEna <= 4'b0;
        weight_receive_done <= 0;
//        weightRamWriteEna <= 4'b0;
        is_last_layer <= 0;
        fc_done <= 0;
        
        sendRowCount <=0;
        
        PE_feature_count<=0;//총 feature에 넣은 데이터 수
        PE_count<=0; //4개씩 세는것
        PE_in_done<=0;
        PE_clk<=0;
        PE_set<=0;
        PE_reset_n<=0;
        //마지막 레이어를 위한 index 초기화
        fc_max <=8'sb10000000;
        max_count <=0;
      end

      FeatureReceive: begin
        if(!s_axis_tready) begin
          s_axis_tready <= 1;
          featureRamEna <= 1;
//          featureRamWriteEna <= 1;
        end
        else if(S_AXIS_TVALID) begin
          if(nextState == FeatureReceiveDone) begin
            receiveCount <= 0;
            s_axis_tready <= 0;
            featureRamEna <= 0;
//            featureRamWriteEna <= 0;
            featureRamAddr <= 0;
          end
          else begin
            receiveCount <= receiveCount + 1;
            featureRamAddr <= featureRamAddr + 1;
            featureRamEna <= 1;
//            featureRamWriteEna <= 1;
          end
        end
        else begin
          featureRamEna <= 0;
//          featureRamWriteEna <= 0;
        end

        if(receive_size == 64)begin
            is_last_layer <= 1;
        end
        weightLineSize <= receive_size;
      end

      FeatureReceiveDone: begin
        if(!feature_receive_done) begin
          feature_receive_done <= 1;
        end
        else if(nextState == BiasReceive) begin
          feature_receive_done <= 0;
        end
      end

      BiasReceive: begin
        if(!s_axis_tready) begin
          s_axis_tready <= 1;
          biasRamEna <= 1;
//          biasRamWriteEna <= 1;
        end
        else if(S_AXIS_TVALID) begin
          if(nextState == BiasReceiveDone) begin
            receiveCount <= 0;
            s_axis_tready <= 0;
            biasRamEna <= 0;
//            biasRamWriteEna <= 0;
            biasRamAddr <= 0;
          end
          else begin
            receiveCount <= receiveCount + 1;
            biasRamAddr <= biasRamAddr + 1;
            biasRamEna <= 1;
//            biasRamWriteEna <= 1;
          end
        end
        else begin
          biasRamEna <= 0;
//          biasRamWriteEna <= 0;
        end
      end

      BiasReceiveDone: begin
        if(!bias_receive_done) begin
          bias_receive_done <= 1;
        end
        else if(nextState == WeightReceive_0) begin
          bias_receive_done <= 0;
        end
      end

      WeightReceive_0: begin
        if(!s_axis_tready) begin
          s_axis_tready <= 1;
          weightRamEna[0] <= 1;
//          weightRamWriteEna[0] <= 1;
        end
        else if(S_AXIS_TVALID) begin
          if(nextState == WeightReceive_1) begin
            receiveCount <= 0;
            s_axis_tready <= 0;
            weightRamEna[0] <= 0;
//            weightRamWriteEna[0] <= 0;
            weightRamAddr[0] <= 0;
          end
          else begin
            receiveCount <= receiveCount + 1;
            weightRamAddr[0] <= weightRamAddr[0] + 1;
            weightRamEna[0] <= 1;
//            weightRamWriteEna[0] <= 1;
          end
        end
        else begin
          weightRamEna[0] <= 0;
//          weightRamWriteEna[0] <= 0;
        end

        weightReceiveCountSize <= (receive_size / weightLineSize) / 4;
      end

      WeightReceive_1: begin
        if(!s_axis_tready) begin
          s_axis_tready <= 1;
          weightRamEna[1] <= 1;
//          weightRamWriteEna[1] <= 1;
        end
        else if(S_AXIS_TVALID) begin
          if(nextState != WeightReceive_1) begin
            receiveCount <= 0;
            s_axis_tready <= 0;
            weightRamEna[1] <= 0;
//            weightRamWriteEna[1] <= 0;
            weightRamAddr[1] <= 0;
            PE_reset_n <=0;
          end
          else begin
            receiveCount <= receiveCount + 1;
            weightRamAddr[1] <= weightRamAddr[1] + 1;
            weightRamEna[1] <= 1;
//            weightRamWriteEna[1] <= 1;
          end
        end
        else begin
          weightRamEna[1] <= 0;
//          weightRamWriteEna[1] <= 0;
        end
      end

      WeightReceive_2: begin
        if(!s_axis_tready) begin
          s_axis_tready <= 1;
          weightRamEna[2] <= 1;
//          weightRamWriteEna[2] <= 1;
        end
        else if(S_AXIS_TVALID) begin
          if(nextState == WeightReceive_3) begin
            receiveCount <= 0;
            s_axis_tready <= 0;
            weightRamEna[2] <= 0;
//            weightRamWriteEna[2] <= 0;
            weightRamAddr[2] <= 0;
          end
          else begin
            receiveCount <= receiveCount + 1;
            weightRamAddr[2] <= weightRamAddr[2] + 1;
            weightRamEna[2] <= 1;
//            weightRamWriteEna[2] <= 1;
          end
        end
        else begin
          weightRamEna[2] <= 0;
//          weightRamWriteEna[2] <= 0;
        end
      end

      WeightReceive_3: begin
        if(!s_axis_tready) begin
          s_axis_tready <= 1;
          weightRamEna[3] <= 1;
//          weightRamWriteEna[3] <= 1;
        end
        else if(S_AXIS_TVALID) begin
          if(nextState == WeightReceiveDone) begin
            receiveCount <= 0;
            s_axis_tready <= 0;
            weightRamEna[3] <= 0;
//            weightRamWriteEna[3] <= 0;
            weightRamAddr[3] <= 0;
            //----------------------------
            //PE reset을 해줘야한다.
            PE_reset_n <=0;
          end
          else begin
            receiveCount <= receiveCount + 1;
            weightRamAddr[3] <= weightRamAddr[3] + 1;
            weightRamEna[3] <= 1;
//            weightRamWriteEna[3] <= 1;
          end
        end
        else begin
          weightRamEna[3] <= 0;
//          weightRamWriteEna[3] <= 0;
        end
      end
      
      WeightReceiveDone: begin
        if(!weight_receive_done) begin
          weight_receive_done <= 1;
        end
        else if(nextState == Calculate) begin
          weight_receive_done <= 0;
          featureRamEna <=0;
          weightRamEna[3:0]<=0;
        end
      end
      
      Calculate: begin
        biasRamEna           <=1;
        
        if(PE_calc_done) begin
        //계산 완료 전부다 초기화 후 send state로 보내야함
            PE_clk <=0;
            PE_set <=0;
            PE_reset_n <=0;
            PE_in_done<=0;
            PE_count <=0;
            PE_feature_count <=0;
            featureRamAddr[0] <=0;
            biasRamAddr <= biasRamAddr +1;
            //send_data m_axis_tdata에 올려놓고 send단계로 넘어간다.
//            m_axis_tdata[31:0] <= send_data[31:0];
            if(is_last_layer) begin
               m_axis_tdata[31:0] <= {send_data[7:0],send_data[15:8],send_data[23:16],send_data[31:24]};
            end
            else begin
            //relu 부분
               m_axis_tdata[31:24] <= (send_data[7])? {8{1'b0}} :send_data[7:0];
               m_axis_tdata[23:16] <= (send_data[15])? {8{1'b0}} :send_data[15:8];
               m_axis_tdata[15:8] <= (send_data[23])? {8{1'b0}} :send_data[23:16];
               m_axis_tdata[7:0] <= (send_data[31])? {8{1'b0}} :send_data[31:24];
            end
        end
        else if(PE_in_done & PE_clk) begin
        //넣기를 다 끝냈어도 계속 clock 은 뛰게 해주어야함
            PE_clk <=0;
        end
        else if(PE_set)begin
            //데이터들이 set되면 PE_clk를 켜주고 set을 0으로 내린다.
            //한칸 넣고 옮기기, 들어간것 개수 하나 늘려주기
            PE_clk   <=0;
            PE_set   <=0;
            PE_feature_count <= PE_feature_count+1;//총 넣어준것 개수
            PE_count <= PE_count +1;
        end
        else begin
            PE_clk <=1;
            if(!PE_reset_n) begin
            //처음 calculate로로 들어옴
                PE_reset_n <=1;
            end
            else if(PE_count==2'b00)begin
                if(PE_feature_count==0) begin
                    //처음 bram을 켜준다. 첫번쨰weightram을 켜야함
                    featureRamEna   <= 1;
                    weightRamEna[0] <= 1;
                end
                else if(PE_in_done) begin
                    weightRamEna[3]  <=0;
                end
                else begin
                    featureRamAddr <= featureRamAddr +1;
                    weightRamAddr[0] <= weightRamAddr[0] +1;
                end
                
                //데이터가 setting 돼있음
                PE_set               <= 1;
            end
            else if(PE_count ==2'b01) begin
                if(PE_feature_count==1)begin
                    //두번쨰 weightram을 켜야함
                    weightRamEna[1] <= 1;
                end
                else if(PE_in_done) begin
                    featureRamEna  <=0;
                    weightRamEna[0] <=0;
                end
                else begin
                    weightRamAddr[1] <= weightRamAddr[1]+1;
                end
                PE_set               <= 1;
            end
            else if(PE_count ==2'b10) begin
                if(PE_feature_count==2) begin
                    weightRamEna[2]<= 1;
                end
                else if(PE_in_done) begin
                    weightRamEna[1]  <=0;
                end
                else begin
                    weightRamAddr[2] <= weightRamAddr[2]+1;
                end
                PE_set               <= 1;
            end
            else if(PE_count ==2'b11) begin
                if(PE_feature_count==3) begin
                    weightRamEna[3] <= 1;
                end
                else if(PE_in_done) begin
                    weightRamEna[2]  <=0;
                end
                else begin
                    weightRamAddr[3] <= weightRamAddr[3]+1;
                end
                PE_set               <= 1;
            end
            //---------계산 끝났음을 알리는 신호
            if(PE_feature_count ==weightLineSize) begin
                PE_in_done <=1;
            end
        end

      end
      
      Send: begin
        if(is_last_layer && max_count <2 && sendRowCount == 2) begin
            if($signed(fc_max) < $signed(m_axis_tdata[(max_count*8)+:8])) begin
                fc_max <= m_axis_tdata[(max_count*8)+:8];
                max_index <= max_count + (sendRowCount*4);
            end
            max_count <= max_count +1;
            m_axis_tdata <= {{16{1'b0}} , m_axis_tdata[15:0]};
        end
        else if(is_last_layer && max_count <4 && sendRowCount < 2) begin
            if($signed(fc_max) < $signed(m_axis_tdata[(max_count*8)+:8])) begin
                fc_max <= m_axis_tdata[(max_count*8)+:8];
                max_index <= max_count + (sendRowCount*4);
            end
            max_count <= max_count +1; 
        end
        else if(!m_axis_tvalid) begin
            m_axis_tvalid <=1;
            if(is_last_layer) begin
                if(sendRowCount == weightReceiveCountSize) begin
                     m_axis_tlast <=1;
                end
            end
            else if(sendRowCount == weightReceiveCountSize-1) begin
                m_axis_tlast <=1;
            end
        end
        else if(M_AXIS_TREADY) begin
            m_axis_tvalid <=0;
            m_axis_tlast <=0;
            m_axis_tdata <=0;
            sendRowCount <= sendRowCount +1;
            max_count <= 0;
            featureRamAddr <= 0;
            weightRamAddr[0] <= 0;
            weightRamAddr[1] <= 0;
            weightRamAddr[2] <= 0;
            weightRamAddr[3] <= 0;
        end
        
//        if(nextState ==Finish) begin
//            m_axis_tlast <=1;
//        end
//        if(nextState != Send) begin
//            m_axis_tlast <=0;
//            m_axis_tvalid <=0;
//        end
      end
      Finish: begin
        if(!fc_done) begin
            fc_done <=1;
        end
      end
    endcase
  end

  
endmodule