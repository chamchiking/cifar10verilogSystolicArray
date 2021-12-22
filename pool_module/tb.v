module tb;
    reg a;
    initial begin
        a = 0;
        #10
        a = 1;
        #10
        a = 0;
    end
endmodule