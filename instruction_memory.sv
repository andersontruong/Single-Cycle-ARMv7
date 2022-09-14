module Instruction_Memory
    #(parameter DATA_WIDTH = 32, parameter NUM_INSTRUCTIONS = 5)
    (
        reset,
        i_Instruction_Address,
        o_Instruction
    );

    input  logic reset;
    input  logic [DATA_WIDTH - 1:0] i_Instruction_Address;
    output logic [DATA_WIDTH - 1:0] o_Instruction;

    logic [7:0] memory [0:NUM_INSTRUCTIONS * 4];
    
    always @(*) begin
        if (reset) begin
            o_Instruction <= 32'b0;
            { memory[0], memory[1], memory[2], memory[3] }     <= 32'b1110_00_111010_0000_0000_0000_00000001; // MOV R0, #3
            { memory[4], memory[5], memory[6], memory[7] }     <= 32'b1110_00_111010_0000_0001_0000_00000000; // MOV R1, #0
            { memory[8], memory[9], memory[10], memory[11] }   <= 32'b1110_01_000000_0001_0000_0000_00000000; // STR R0, R1
            { memory[12], memory[13], memory[14], memory[15] } <= 32'b1110_01_000001_0001_0001_0000_00000000; // LDR R1, R1
            /*
            { memory[0], memory[1], memory[2], memory[3] }     <= 32'b1110_00_111010_0000_0001_0000_00000001; // MOV R1, #1
            { memory[4], memory[5], memory[6], memory[7] }     <= 32'b1110_00_101000_0001_0001_0000_00000001; // ADD R1, R1, #1
            { memory[8], memory[9], memory[10], memory[11] }   <= 32'b1110_10_111111_1111_1111_1111_11111100; // B #-2
            { memory[12], memory[13], memory[14], memory[15] } <= 32'b1110_00_111010_0000_0001_0000_00000011; // MOV R1, #3
            { memory[16], memory[17], memory[18], memory[19] } <= 32'b1110_00_111010_0000_0001_0000_00000100; // MOV R1, #4
            */
        end
        else begin
            if (i_Instruction_Address >> 2 > NUM_INSTRUCTIONS)
                o_Instruction <= 32'bx;
            else
                o_Instruction <= {memory[i_Instruction_Address], memory[i_Instruction_Address + 1], memory[i_Instruction_Address + 2], memory[i_Instruction_Address + 3]};
        end
    end

endmodule