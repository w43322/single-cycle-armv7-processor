module InstructionMemory(
    input [9:0] Addr,
    output [31:0] Data
);
    reg [31:0] rom [255:0]; initial begin $readmemb("ROM.mem", rom); end
    
    assign Data = rom[Addr[9:2]];
endmodule
