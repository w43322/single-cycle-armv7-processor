module Registers(
    input [3:0] ReadAddr1,
    input [3:0] ReadAddr2,
    output [31:0] ReadData1,
    output [31:0] ReadData2,
    input CLK,
    input WriteEnable,
    input [3:0] WriteAddr,
    input [31:0] WriteData
);
    reg [31:0] r [14:0]; initial begin $readmemb("REG.mem", r); end

    assign ReadData1 = r[ReadAddr1];
    assign ReadData2 = r[ReadAddr2];
    always @ (posedge CLK) begin
        if (WriteEnable) begin
            r[WriteAddr] <= WriteData;
        end
    end
endmodule
