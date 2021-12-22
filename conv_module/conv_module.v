module conv_module #
 (
      parameter integer C_S00_AXIS_TDATA_WIDTH   = 32

 )
 (   //AXI-STREAM
    input wire                                            clk,
    input wire                                            rstn,
    output reg                                            S_AXIS_TREADY,
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
    //input                                               conv_start,
    output reg                                            conv_done,

    input[5:0] flen,
    input[8:0] in_ch,
    input[8:0] out_ch,
    
    input[2:0] command,
  
    output reg input_done,
    output reg bias_done,
    output reg weight_done
  );


  reg                                           m_axis_tuser;
  reg [C_S00_AXIS_TDATA_WIDTH-1 : 0]            m_axis_tdata;
  reg [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0]        m_axis_tkeep;
  reg                                           m_axis_tlast;
  reg                                           m_axis_tvalid;
  wire                                          s_axis_tready;

 // assign S_AXIS_TREADY = s_axis_tready;
  assign M_AXIS_TDATA = m_axis_tdata;
  assign M_AXIS_TLAST = m_axis_tlast;
  assign M_AXIS_TVALID = m_axis_tvalid;
  assign M_AXIS_TUSER = 1'b0;
  assign M_AXIS_TKEEP = {(C_S00_AXIS_TDATA_WIDTH/8) {1'b1}}; 



  reg[13:0] input_addr;
  reg[7:0]  input_din;
  //assign input_din = S_AXIS_TDATA[8*counter +:8];
  wire[7:0] input_dout;
  reg input_en;
  reg input_we;
  sram_8x8192 st_input(
    .addra(input_addr),
    .clka(clk),
    .dina(input_din),
    .douta(input_dout),
    .ena(input_en),
    .wea(input_we)
  );

  reg[15:0] im2col_addr;
  reg[7:0]  im2col_din;
  wire[7:0] im2col_dout;
  reg im2col_en;
  reg im2col_we;
  sram_8x18432 st_im2col(
    .addra(im2col_addr),
    .clka(clk),
    .dina(im2col_din),
    .douta(im2col_dout),
    .ena(im2col_en),
    .wea(im2col_we)
  );

  reg[15:0] im2col_addr1;
  reg[7:0]  im2col_din1;
  wire[7:0] im2col_dout1;
  reg im2col_en1;
  reg im2col_we1;
  sram_8x18432 st_im2col1(
    .addra(im2col_addr1),
    .clka(clk),
    .dina(im2col_din1),
    .douta(im2col_dout1),
    .ena(im2col_en1),
    .wea(im2col_we1)
  );

  reg[15:0] im2col_addr2;
  reg[7:0]  im2col_din2;
  wire[7:0] im2col_dout2;
  reg im2col_en2;
  reg im2col_we2;
  sram_8x18432 st_im2col2(
    .addra(im2col_addr2),
    .clka(clk),
    .dina(im2col_din2),
    .douta(im2col_dout2),
    .ena(im2col_en2),
    .wea(im2col_we2)
  );

  reg[15:0] im2col_addr3;
  reg[7:0]  im2col_din3;
  wire[7:0] im2col_dout3;
  reg im2col_en3;
  reg im2col_we3;
  sram_8x18432 st_im2col3(
    .addra(im2col_addr3),
    .clka(clk),
    .dina(im2col_din3),
    .douta(im2col_dout3),
    .ena(im2col_en3),
    .wea(im2col_we3)
  );
  
  reg[8:0] bias_addr;  
  reg[31:0] bias_din;
  wire[31:0] bias_dout;
  reg bias_en;
  reg bias_we; 
  sram_32x64 st_bias(
      .addra(bias_addr),
      .clka(clk),
      .dina(bias_din),
      .douta(bias_dout),
      .ena(bias_en),
      .wea(bias_we)
  );

  reg[12:0] weight_addr;
  reg[7:0] weight_din[8:0]; //8bit 짜리 9 개
  wire[7:0] weight_dout[8:0];
  reg weight_we;
  reg weight_en;
  sram_8x1024 st_weight0(
    .addra(weight_addr),
      .clka(clk),
      .dina(weight_din[0]),
      .douta(weight_dout[0]),
      .ena(weight_en),
      .wea(weight_we)
  );

  sram_8x1024 st_weight1(
    .addra(weight_addr),
      .clka(clk),
      .dina(weight_din[1]),
      .douta(weight_dout[1]),
      .ena(weight_en),
      .wea(weight_we)
  );

  sram_8x1024 st_weight2(
    .addra(weight_addr),
      .clka(clk),
      .dina(weight_din[2]),
      .douta(weight_dout[2]),
      .ena(weight_en),
      .wea(weight_we)
  );

  sram_8x1024 st_weight3(
    .addra(weight_addr),
      .clka(clk),
      .dina(weight_din[3]),
      .douta(weight_dout[3]),
      .ena(weight_en),
      .wea(weight_we)
  );

  sram_8x1024 st_weight4(
    .addra(weight_addr),
      .clka(clk),
      .dina(weight_din[4]),
      .douta(weight_dout[4]),
      .ena(weight_en),
      .wea(weight_we)
  );

  sram_8x1024 st_weight5(
    .addra(weight_addr),
      .clka(clk),
      .dina(weight_din[5]),
      .douta(weight_dout[5]),
      .ena(weight_en),
      .wea(weight_we)
  );

  sram_8x1024 st_weight6(
    .addra(weight_addr),
      .clka(clk),
      .dina(weight_din[6]),
      .douta(weight_dout[6]),
      .ena(weight_en),
      .wea(weight_we)
  );

  sram_8x1024 st_weight7(
    .addra(weight_addr),
      .clka(clk),
      .dina(weight_din[7]),
      .douta(weight_dout[7]),
      .ena(weight_en),
      .wea(weight_we)
  );

  sram_8x1024 st_weight8(
    .addra(weight_addr),
      .clka(clk),
      .dina(weight_din[8]),
      .douta(weight_dout[8]),
      .ena(weight_en),
      .wea(weight_we)
  );
  reg[31:0] input_buffer;
  reg[31:0] weight_temp;
  reg[287:0] weight_buffer;
  
  reg[2:0] counter;//8bit x 4 check
  reg[10:0] counter2; //32bits x n check ?  ?  ?   ? ?  ?  ?  ?  .
  reg[10:0] counter3; //4줄에 ???   ?  ?  ?   ?  ?   ? 체크(in-ch  ?  ?   ??  ?  ?  ?  )
  reg[10:0] counter4;

  localparam idle=3'd0;
  localparam receiving_input=3'd1;
  localparam INPUT_DONE = 2;
  localparam receiving_bias=3;
  localparam doing_im2col=3'd4;
  localparam receiving_weight=3'd5;
  localparam store_weight=3'd6;
  localparam CALCULATE = 7;
  localparam SEND = 8;
  localparam FINISH = 9;

  reg[3:0] state;

  reg[10:0]i,j,k;
  reg[10:0] x,y;
  reg[10:0] ch;
  reg[4:0] pick;
  reg reset;
  reg[2:0] count;
  wire[13:0] input_addr_wire;
  wire is_zero;
  reg[3:0] delay;
  
  im2col im2col(.is_zero(is_zero),.x(x),.y(y),.ch(ch),.pick(pick),.reset(reset),
                .input_addr(input_addr_wire),.flen(flen));
  
  
  //-------------------------------------------------------------------------------------------
  reg [20:0] PE_weight_receive_count;// weight를 총 몇번 받았는지
  reg [2:0]  PE_weight_count;//weight4개받은것중에 어떤걸써야하는지(0~3) 4면 weight새로받아야함
  reg [3:0]  PE_filter_count; //9개씩 세는것
  reg [20:0] PE_in_count;
  reg [3:0]  PE_count;//타이밍 조절용 카운트
  reg [20:0] PE_total_count; //out_ch 하나가 끝날때까지 세는 신호
  wire[31:0] send_data;
  wire       PE_calc_done;
  reg       PE_in_done;
  reg       PE_clk;
  reg       PE_set;
  reg       PE_reset_n;
  wire [31:0] PE_bias_data;
  wire [7:0] PE_im2col_dout;
  wire [7:0] PE_im2col_dout1;
  wire [7:0] PE_im2col_dout2;
  wire [7:0] PE_im2col_dout3;
  wire [7:0]  PE_filter;
  assign PE_bias_data = (PE_weight_count==0)?{4{bias_dout[7:0]}}:(PE_weight_count==1)?{4{bias_dout[15:8]}}:(PE_weight_count==2)? {4{bias_dout[23:16]}} :{4{bias_dout[31:24]}};
  //filter의 output 을 어느램에서 받을지를 결정
  assign PE_filter = (PE_in_done)?{8{1'b0}}:(PE_filter_count==0)? weight_dout[0]:(PE_filter_count==1)? weight_dout[1]:(PE_filter_count==2)? weight_dout[2]:(PE_filter_count==3)? weight_dout[3]:(PE_filter_count==4)? weight_dout[4]:
                     (PE_filter_count==5)? weight_dout[5]:(PE_filter_count==6)? weight_dout[6]:(PE_filter_count==7)? weight_dout[7]: weight_dout[8];
  assign PE_im2col_dout =  (PE_in_count < 9*in_ch)? im2col_dout:{8{1'b0}};
  assign PE_im2col_dout1 = (PE_in_count>0 && PE_in_count < (9*in_ch +1))? im2col_dout1:{8{1'b0}};
  assign PE_im2col_dout2 = (PE_in_count>1 && PE_in_count < (9*in_ch +2))? im2col_dout2:{8{1'b0}};
  assign PE_im2col_dout3 = (PE_in_count>2 && PE_in_count < (9*in_ch +3))? im2col_dout3:{8{1'b0}};
  PE4      PE4(.clk(PE_clk), .rst_n(PE_reset_n), .bias(PE_bias_data), .in_a(PE_filter), .data_fin_a(PE_in_done),
               .in_b1(PE_im2col_dout), .in_b2(PE_im2col_dout1), .in_b3(PE_im2col_dout2), .in_b4(PE_im2col_dout3),
               .send_result(send_data[31:0]), .all_done(PE_calc_done) );
  //-----------------------------------------------------------------------------------
  


  always @(posedge clk or negedge rstn) begin
  if (!rstn)begin
    state <= idle;
  end
  else begin
    case(state)
      idle: begin
        S_AXIS_TREADY<=0;
        m_axis_tdata<=0;
        m_axis_tvalid<=0; 
        
        input_addr<=0;
        bias_addr<=0;
        input_en<=0;
        input_we<=0;

        im2col_en<=0;
        im2col_en1<=0;
        im2col_en2<=0;
        im2col_en3<=0;
        im2col_we<=0;
        im2col_we1<=0;
        im2col_we2<=0;
        im2col_we3<=0;

        bias_en<=0;
        bias_we<=0;
        weight_en<=0;
        weight_we<=0;
        weight_buffer<=0;
        weight_temp<=0;

        counter<=0;
        counter2<=0;
        counter3<=0;
        counter4<=0;

        weight_addr<=-1;
        input_done<=0;
        bias_done<=0;
        weight_done<=0;

        reset<=1;
        i<=0;
        j<=0;
        k<=0;
        count<=0;
        delay<=0;
        im2col_addr<=-1;
        im2col_addr1<=-1;
        im2col_addr2<=-1;
        im2col_addr3<=-1;
        conv_done <= 0;

        if(command==1 && S_AXIS_TVALID)begin
          state<=receiving_input;
          input_we<=1;
          input_en<=1;
          reset<=0;
        end
        //---------------------------------------------------
        PE_clk <=0;
        PE_set <=0;
        PE_reset_n<=0;
        PE_weight_receive_count<=0;// weight를 총 몇번 받았는지
        PE_weight_count<=0;//weight4개받은것중에 어떤걸써야하는지(0~3) 4면 weight새로받아야함
        PE_filter_count<=0; //9개씩 세는것
        PE_in_done <=0;
        PE_in_count<=0;
        PE_total_count<=0;
        PE_count <=0;
        //---------------------------------------------------
      end

/*
    receiving_input: begin
      if(counter2 < flen*flen*in_ch/4-1) begin
          if(S_AXIS_TVALID) begin
              if(S_AXIS_TREADY==0 && counter==0) begin
                S_AXIS_TREADY<=1;
                counter<=counter+1; 
              end
              else
                S_AXIS_TREADY<=0;
                if(counter!=3) begin
                    counter<=counter+1;
                    input_addr<=counter2*4+counter;
                end
                else begin
                    counter<=0;
                end
              end
          
          
               S_AXIS_TREADY<=1;
              if(counter!=4) begin
                S_AXIS_TREADY<=0;
                input_addr<=counter2*4+counter;
//                input_din<=S_AXIS_TDATA[8*counter +:8]; //3210 순서대로 들어온다고 할때 낮은 address에 0을 넣도록
                counter<=counter+1;
              end
              else begin 
                if(counter2 < flen*flen*in_ch/4 -1) begin
                  S_AXIS_TREADY<=1;
                  counter<=0;
                  counter2<=counter2+1;
                end
                else begin
                  counter<=0;
                  counter2<=counter2+1;
                end
              end
          end
      end
      else begin
        counter<=0;
        counter2<=0;
        S_AXIS_TREADY<=0;
        input_done<=1;
        input_we<=0;
        input_en<=0;
        bias_we<=1;
        bias_en<=1;
        state<=INPUT_DONE;
      end
    end
    */
    
    receiving_input: begin
        if(counter2!= flen*flen*in_ch/4-1) begin
            if(counter==0) begin
                if(S_AXIS_TVALID) begin
                    S_AXIS_TREADY<=1;
                    input_buffer<=S_AXIS_TDATA;
                    counter<=counter+1;
                end
            end
            else if(0<counter && counter<5) begin
                counter<=counter+1;
                S_AXIS_TREADY<=0;
                input_din <= input_buffer[8*(counter-1) +:8];
                input_addr<=counter2*4+(counter-1);           
            end
            else if (counter==5) begin
                counter<=0;
                counter2<=counter2+1;
            end
        end
        else if(counter2== flen*flen*in_ch/4-1) begin
            if(counter==0) begin
                if(S_AXIS_TVALID) begin
                    S_AXIS_TREADY<=1;
                    counter<=counter+1;
                    input_buffer<=S_AXIS_TDATA;
                end
            end
            else if(0<counter && counter<5) begin
                S_AXIS_TREADY<=0;
                counter<=counter+1;
                input_din <= S_AXIS_TDATA[8*(counter-1) +:8];
                input_addr<=counter2*4+(counter-1);           
            end
            else if (counter==5) begin
                counter<=0;
                counter2<=0;
                input_done<=1;
                input_we<=0;
                input_en<=0;
                state<=INPUT_DONE;
            end
        end
    
    end
    
    INPUT_DONE: begin
        if(command==2) begin
            bias_we <=1;
            bias_en <=1;
            state <= receiving_bias;
        end
    end
       

    receiving_bias: begin
      if(!S_AXIS_TREADY & S_AXIS_TVALID) begin
        S_AXIS_TREADY <=1;
      end
      else if(counter2!=out_ch/4 && S_AXIS_TVALID)begin
            S_AXIS_TREADY <=0;
            bias_addr<=counter2;
            bias_din[7-:8]<= S_AXIS_TDATA[7-:8];
            bias_din[15-:8]<= S_AXIS_TDATA[15-:8];
            bias_din[23-:8]<= S_AXIS_TDATA[23-:8];
            bias_din[31-:8]<= S_AXIS_TDATA[31-:8];       //3210 순서로 저장 온 그대로 넣음
            counter2<=counter2+1;
      end    
      else begin
        counter2<=0;
        S_AXIS_TREADY<=0;
        bias_we<=0;
        bias_en<=1;
        bias_done<=1;
        state<=doing_im2col;
        input_en<=1;
        //////
      end
    end
    /*
    doing_im2col:  begin
     if(count!=4) begin
      if(i<flen*flen) begin
        if(j!=in_ch) begin
          if(k!=9)  begin
             if(delay==0) begin
                x<=i-(i/flen)*flen;
                y<=i/flen;
                pick<=k;
                ch<=j;
                delay<=delay+1;
              end
              else if(delay==1) begin
                 input_addr<=input_addr_wire;
                 delay<=delay+1;
              end
              else if (delay==2) begin
                  delay<=delay+1;
                  if(count==0) begin
                    im2col_en<=1;
                    im2col_we<=1;
                    im2col_addr<=im2col_addr+1;
                    if(is_zero) begin
                        im2col_din<=0;
                    end
                    else begin
                        im2col_din<=input_dout;
                    end
                  end
                  else if(count==1) begin
                    im2col_en1<=1;
                    im2col_we1<=1;
                    im2col_addr1<=im2col_addr1+1;
                    if(is_zero) begin
                        im2col_din1<=0;
                    end
                    else begin
                        im2col_din1<=input_dout;
                    end
                  end
                  else if(count==2) begin
                    im2col_en2<=1;
                    im2col_we2<=1;
                    im2col_addr2<=im2col_addr2+1;
                    if(is_zero) begin
                        im2col_din2<=0;
                    end
                    else begin
                        im2col_din2<=input_dout;
                    end
                  
                  end
                  else if(count==3) begin
                    im2col_en3<=1;
                    im2col_we3<=1;
                    im2col_addr3<=im2col_addr3+1;
                    if(is_zero) begin
                        im2col_din3<=0;
                    end
                    else begin
                        im2col_din3<=input_dout;
                    end
                  end
              end
              else if(delay==3) begin
                  k<=k+1;
                  delay<=0;
                  im2col_en<=0;
                  im2col_we<=0;
                  im2col_en1<=0;
                  im2col_we1<=0;
                  im2col_en2<=0;
                  im2col_we2<=0;
                  im2col_en3<=0;
                  im2col_we3<=0;
              end
           end
           else begin
                k<=0;
                j<=j+1;
           end
         end
        else begin
               j<=0;
               i<=i+4;
        end
       end
       else begin
           i<=count+1;
           count<=count+1;
       end   
      end
      else begin
         if(command==3) begin
            state<=receiving_weight;
//            S_AXIS_TREADY<=1;
          end
      end
    end
*/

    doing_im2col:  begin
     if(count!=4) begin
      if(i<flen*flen) begin
        if(j!=in_ch) begin
          if(k!=9)  begin
             if(delay==0) begin
                x<=i-(i/flen)*flen;
                y<=i/flen;
                pick<=k;
                ch<=j;
                delay<=delay+1;
              end
              else if(delay==1) begin
                 input_addr<=input_addr_wire;
                 delay<=delay+1;
              end
              else if(delay==2) begin
                  delay<=delay+1;
              end
              else if (delay==3) begin
                  delay<=delay+1;
                  if(count==0) begin
                    im2col_en<=1;
                    im2col_we<=1;
                    im2col_addr<=im2col_addr+1;
                    if(is_zero) begin
                        im2col_din<=0;
                    end
                    else begin
                        im2col_din<=input_dout;
                    end
                  end
                  else if(count==1) begin
                    im2col_en1<=1;
                    im2col_we1<=1;
                    im2col_addr1<=im2col_addr1+1;
                    if(is_zero) begin
                        im2col_din1<=0;
                    end
                    else begin
                        im2col_din1<=input_dout;
                    end
                  end
                  else if(count==2) begin
                    im2col_en2<=1;
                    im2col_we2<=1;
                    im2col_addr2<=im2col_addr2+1;
                    if(is_zero) begin
                        im2col_din2<=0;
                    end
                    else begin
                        im2col_din2<=input_dout;
                    end
                  
                  end
                  else if(count==3) begin
                    im2col_en3<=1;
                    im2col_we3<=1;
                    im2col_addr3<=im2col_addr3+1;
                    if(is_zero) begin
                        im2col_din3<=0;
                    end
                    else begin
                        im2col_din3<=input_dout;
                    end
                  end
              end
              else if(delay==4) begin
                  k<=k+1;
                  delay<=0;
                  im2col_en<=0;
                  im2col_we<=0;
                  im2col_en1<=0;
                  im2col_we1<=0;
                  im2col_en2<=0;
                  im2col_we2<=0;
                  im2col_en3<=0;
                  im2col_we3<=0;
              end
           end
           else begin
                k<=0;
                j<=j+1;
           end
         end
        else begin
               j<=0;
               i<=i+4;
        end
       end
       else begin
           i<=count+1;
           count<=count+1;
       end   
      end
      else begin
        state<=receiving_weight;
      end
    end
          
  /*
    receiving_weight: begin
      if(counter4!=out_ch*in_ch/4) begin // weight ? ?   받았?   ?
       if(S_AXIS_TVALID) begin
        if(counter3!=in_ch) begin //?  ?   4줄을 받았?   ?
         if(counter2!=4*9/4) begin// four filter
            if(counter!=4) begin
              S_AXIS_TREADY<=0;
              weight_buffer[(counter+counter2*4)*8+:8]<=S_AXIS_TDATA[8*4-counter+:8]; //weight_buffer n,n-1,.......,0
              counter<=counter+1;
            end
            else begin
              if(counter!=4*9/4-1) begin
               S_AXIS_TREADY<=1;
               counter<=0;
               counter2<=counter2+1;
              end
              else begin
               counter<=0;
               counter2<=counter2+1;
              end
            end
          end
          else begin
            counter<=0;
            counter2<=0;
            counter3<=counter3+1;
            counter4<=counter4+1;
            S_AXIS_TREADY<=0;
            weight_we<=1;
            weight_en<=1;
            state<=store_weight;
          end
        end
        else begin
          counter3<=0;
          weight_addr<=0;
          state<= CALCULATE;
          weight_en<=0;
          PE_weight_count <=0;
        end
       end
      end
      else begin
        counter<=0;
        counter2<=0;
        counter3<=0;
        counter4<=0;
        S_AXIS_TREADY<=0; //빼도?  .
        weight_done<=1;
      end
    end
    
    */
    
    receiving_weight: begin
        //if(counter4!=out_ch*in_ch/4)begin
            if(counter3!=in_ch) begin
                if(counter2!=4*9/4) begin
                    if(counter==0) begin
                        if(S_AXIS_TVALID) begin
                            S_AXIS_TREADY<=1;
                            weight_temp<=S_AXIS_TDATA;
                            counter<=counter+1;
                        end
                    end
                    else if(0<counter && counter<5) begin
                        counter<=counter+1;
                         S_AXIS_TREADY<=0;
                        weight_buffer[((counter-1)+counter2*4)*8+:8]<= weight_temp[8*(counter-1) +:8];
                    end
                    else if (counter==5) begin
                        counter<=0;
                        counter2<=counter2+1;
                    end
                end 
                else begin//counter2==4
                    counter<=0;
                    counter2<=0;
                    counter3<=counter3+1;
                    counter4<=counter4+1;
                    weight_we<=1;
                    weight_en<=1;
                    state<=store_weight;
                end
            end
            else begin //counter3==in_ch
                counter<=0;
                counter2<=0;
                counter3<=0;
                weight_addr<=-1;
                weight_done<=1;
                state<= CALCULATE;
                PE_weight_count <=0;
            end
        end
   // end
    
    store_weight: begin
      if(counter!=4) begin // buffer has 36 numbers and scatters it to 9 srams 
        weight_addr<=weight_addr+1;
        counter<=counter+1;
        weight_din[0]<=weight_buffer[counter*72+7-:8];
        weight_din[1]<=weight_buffer[counter*72+15-:8];
        weight_din[2]<=weight_buffer[counter*72+23-:8];
        weight_din[3]<=weight_buffer[counter*72+31-:8];
        weight_din[4]<=weight_buffer[counter*72+39-:8];
        weight_din[5]<=weight_buffer[counter*72+47-:8];
        weight_din[6]<=weight_buffer[counter*72+55-:8];
        weight_din[7]<=weight_buffer[counter*72+63-:8];
        weight_din[8]<=weight_buffer[counter*72+71-:8];
      end
      else begin
        counter<=0;
        weight_we<=0;
        state<=receiving_weight;
      end
   end
   
   CALCULATE: begin
        bias_en           <=1;
        
        if(PE_calc_done) begin
        //계산 완료 전부다 초기화 후 send state로 보내야함
            PE_clk <=0;
            PE_set <=0;
            PE_reset_n <=0;
            PE_in_done<=0;
            PE_in_count <=0;
            PE_count <=0;
            PE_filter_count <=0;
            //bram을 모두 꺼준다.
            weight_en <=0;
            im2col_en <=0;
            im2col_en1 <=0;
            im2col_en2 <=0;
            im2col_en3 <=0;
            //output channel 하나만큼을 다 만들어냈는지 확인
            if(PE_total_count >= 9*in_ch*flen*flen/4)begin
                PE_weight_count <= PE_weight_count +1;
                //totalcount 초기화
                PE_total_count <=0;
            end
            state <= SEND;
            //relu 부분
            m_axis_tdata[31:24] <= (send_data[7])? {8{1'b0}} :send_data[7:0];
            m_axis_tdata[23:16] <= (send_data[15])? {8{1'b0}} :send_data[15:8];
            m_axis_tdata[15:8] <= (send_data[23])? {8{1'b0}} :send_data[23:16];
            m_axis_tdata[7:0] <= (send_data[31])? {8{1'b0}} :send_data[31:24];
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
            PE_in_count <= PE_in_count+1;//이번 calculate에서 넣어준것 개수
            if(!PE_in_done) PE_total_count <= PE_total_count +1;//out channel 하나가 끝낼때까지 세주는 수
            //0~8까지 어떤 weight ram 에서 읽어야하는지
            if(PE_filter_count==8) begin
                PE_filter_count <=0;
            end
            else begin
                PE_filter_count <= PE_filter_count +1;
            end
        end
        else begin
            if(!PE_reset_n) begin
            //처음 calculate로로 들어옴
                PE_reset_n <=1;
                im2col_addr <= PE_total_count;
                im2col_addr1 <= PE_total_count;
                im2col_addr2 <= PE_total_count;
                im2col_addr3 <= PE_total_count;
            end
            else if(PE_in_count==0) begin
                //처음 bram을 켜준다. 첫번쨰weightram을 켜야함
                weight_en   <= 1;
                im2col_en   <= 1;
                if(weight_en)begin
                    PE_count <=PE_count +1;
                    if(PE_count ==2) begin
                        PE_count <=0;
                        PE_set <=1;
                        PE_clk <=1;
                    end
                end
            end
            else if(PE_in_count==1) begin
                im2col_en1 <= 1;
                if(im2col_en1 && PE_count==1)begin
                    im2col_addr <= im2col_addr +1;
                    PE_count <= PE_count +1;
                end
                else if(PE_count ==3) begin
                    PE_count <= 0;
                    PE_set <=1;
                    PE_clk <=1;
                end
                else begin
                    PE_count <= PE_count +1;
                end
            end
            else if(PE_in_count==2) begin
                im2col_en2 <= 1;
                if(im2col_en2 && PE_count==1)begin
                    im2col_addr <= im2col_addr +1;
                    im2col_addr1 <= im2col_addr1 +1;
                    PE_count <= PE_count +1;
                end
                else if( PE_count ==3) begin
                    PE_count <=0;
                    PE_set <= 1;
                    PE_clk <= 1;
                end
                else begin
                    PE_count <=PE_count + 1;
                end
            end
            else if(PE_in_count==3) begin
                im2col_en3<= 1;
                if(im2col_en3 && PE_count ==1)begin
                    im2col_addr <= im2col_addr +1;
                    im2col_addr1 <= im2col_addr1 +1;
                    im2col_addr2 <= im2col_addr2 +1;
                    PE_count <= PE_count +1;
                end
                else if(PE_count ==3) begin
                    PE_count <=0;
                    PE_set <= 1;
                    PE_clk <= 1;
                end
                else begin
                    PE_count <= PE_count +1;
                end
            end
            else begin
                if(PE_count ==0) begin
                    PE_count <= PE_count +1;
                    im2col_addr <= im2col_addr +1;
                    im2col_addr1 <= im2col_addr1 +1;
                    im2col_addr2 <= im2col_addr2 +1;
                    im2col_addr3 <= im2col_addr3 +1;
                end
                else if(PE_count ==3) begin
                    PE_count <=0;
                    PE_set <=1;
                    PE_clk <=1;
                end
                else begin
                    PE_count <= PE_count +1;
                end
            end
            
            if(PE_in_count <9*in_ch) begin
                weight_addr <= PE_weight_count*in_ch +(PE_in_count)/9;
                bias_addr <= PE_weight_receive_count;
            end
            //---------계산 끝났음을 알리는 신호
            if(PE_in_count == 9*in_ch) begin
                PE_in_done <=1;
            end
        end
   end
   
   SEND: begin
        if(!m_axis_tvalid) begin
            //완전 끝 데이터인지 체크해야함
            if(PE_weight_count==4 & (PE_weight_receive_count+1)*4==out_ch)begin
                m_axis_tlast <=1;
                if(m_axis_tlast) m_axis_tvalid <=1;
            end
            else begin
                m_axis_tvalid <=1;
            end
        end
        else if(M_AXIS_TREADY) begin
            m_axis_tvalid <=0;
            m_axis_tlast <=0;
            //finish 할지 weight receive로 보낼지 calculate로 보낼지
            if(PE_weight_count ==4 )begin
                PE_weight_count <=0;
                //완전 마지막 데이터인경우 또는 다시 weight를 받아야하느지
                if((PE_weight_receive_count+1)*4 ==out_ch) begin//finish로 보낸다.
                    state <= FINISH;
                end
                else begin//weight receive로 보낸다.
                    weight_addr<=-1; //추가함.by yoon
                    state <= receiving_weight;
                    PE_weight_receive_count <= PE_weight_receive_count +1;
                end
            end
            else begin
                state <= CALCULATE;
            end
        end
   end
   
   FINISH: begin
        if(!conv_done) begin
            conv_done <=1;
        end
        if(command == 0) begin
            state <= idle;
        end
        else begin
            state <= FINISH;
        end
   end 
         
   endcase
end
  end
  // TODO //

endmodule
///////////////////////////
