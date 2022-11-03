`timescale 1ns / 1ps

module Shifter_tb();

    reg [4:0] Amount;
    reg [1:0] Type;
    reg [31:0] In;
    wire [31:0] Out;
    
    Shifter obj(Amount, Type, In, Out);
    
    initial begin
        /*Logical Left*/
        for (integer i = 0; i < 32; i = i + 1'b1) begin
            Amount = i;
            Type = 2'b00;
            In = $random;
            #5;
        end
        /*Logical Right*/
        for (integer i = 0; i < 32; i = i + 1'b1) begin
            Amount = i;
            Type = 2'b01;
            In = $random;
            #5;
        end
        /*Arithmetic Right*/
        for (integer i = 0; i < 32; i = i + 1'b1) begin
            Amount = i;
            Type = 2'b10;
            In = $random;
            #5;
        end
        /*Rotate Right*/
        for (integer i = 0; i < 32; i = i + 1'b1) begin
            Amount = i;
            Type = 2'b11;
            In = $random;
            #5;
        end
        $stop;
    end

endmodule
