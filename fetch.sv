module FETCH
    #(parameter DATA_WIDTH = 32)
    (
        clk,
        reset,
        i_PC_Src,
        i_Branch_Address,
        o_PC,
        o_Instruction
    );

    input  clk;
    input  reset;
    input  i_PC_Src;
    input  [DATA_WIDTH - 1:0] i_Branch_Address;
    output [DATA_WIDTH - 1:0] o_PC;
    output [DATA_WIDTH - 1:0] o_Instruction;

    logic [DATA_WIDTH - 1:0] PC_write;
    logic [DATA_WIDTH - 1:0] PC_read;
    logic [DATA_WIDTH - 1:0] PC_Plus4;

    assign PC_Plus4 = PC_read + 4;

    assign PC_write = i_PC_Src ? i_Branch_Address : PC_Plus4;

    assign o_PC = PC_Plus4;

    PC #(.DATA_WIDTH(DATA_WIDTH)) pc (.clk(clk), .reset(reset), .i_PC_write(PC_write), .o_PC_read(PC_read));

    Instruction_Memory #(.DATA_WIDTH(DATA_WIDTH)) im(.reset(reset), .i_Instruction_Address(PC_read), .o_Instruction(o_Instruction));

endmodule

module PC
    #(parameter DATA_WIDTH = 32)
    (
        clk,
        reset,
        i_PC_write,
        o_PC_read
    );

    input  logic clk;
    input  logic reset;
    input  logic [DATA_WIDTH - 1:0] i_PC_write;
    output logic [DATA_WIDTH - 1:0] o_PC_read;

    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            o_PC_read <= 32'b0;
        else
            o_PC_read <= i_PC_write;
    end

endmodule