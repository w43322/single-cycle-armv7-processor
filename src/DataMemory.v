module DataMemory(
    input [9:0] RWAddr,
    input [31:0] WriteData,
    input CLK,
    input WriteEnable,
    output [31:0] ReadData
);
    reg [31:0] ram [255:0]; initial begin $readmemb("RAM.mem", ram); end
    
    assign ReadData = ram[RWAddr[9:2]];
    always @ (posedge CLK) begin
        if (WriteEnable) begin
            ram[RWAddr[9:2]] <= WriteData;
        end
    end
endmodule
