module ALU
    #(parameter DATA_WIDTH = 32)
    (
        i_Operand1,
        i_Operand2,
        i_ALU_OpCode,

        o_CPSR,
        o_ALU_Result
    );

    input  logic [DATA_WIDTH - 1:0] i_Operand1;
    input  logic [DATA_WIDTH - 1:0] i_Operand2;
    input  logic [2:0] i_ALU_OpCode;

    output logic [3:0] o_CPSR;
    output logic [DATA_WIDTH - 1:0] o_ALU_Result;

    /*
    ALU Codes

    000 ADD
    001 SUB
    010 AND
    011 ORR
    100 XOR
    101 NOT
    110 PASS A
    111 PASS B 
    */

    logic Negative;
    logic Zero;
    logic Carry;
    logic Overflow;
    logic throwaway;
    logic [DATA_WIDTH - 1:0] ALU_Result;

    logic SUB_Enable;

    assign SUB_Enable = i_ALU_OpCode[0] & ^i_ALU_OpCode;

    assign o_ALU_Result = ALU_Result;

    assign Negative = ALU_Result[DATA_WIDTH - 1:0];

    assign Zero = &~ALU_Result;

    assign Overflow = &~i_ALU_OpCode[2:1] & (i_Operand1[DATA_WIDTH - 1:0] ^ ALU_Result[DATA_WIDTH - 1:0]) & ( (i_Operand1[DATA_WIDTH - 1:0] & i_Operand2[DATA_WIDTH - 1:0] & &~i_ALU_OpCode) | ((i_Operand1[DATA_WIDTH - 1:0] ^ i_Operand2[DATA_WIDTH - 1:0]) & SUB_Enable) );

    assign o_CPSR = { Negative, Zero, Carry, Overflow };

    logic [DATA_WIDTH + 1:0] Op1_ADD_SUB;
    logic [DATA_WIDTH + 1:0] Op2_ADD_SUB;

    assign Op1_ADD_SUB = { 1'b0, i_Operand1, SUB_Enable };
    assign Op2_ADD_SUB = { 1'b0, SUB_Enable ? ~i_Operand2 : i_Operand2, SUB_Enable };

    always_comb begin
        throwaway <= 1'b0;

        casex (i_ALU_OpCode)
            3'b00x: // ADD/SUB
                { Carry, ALU_Result, throwaway } <= Op1_ADD_SUB + Op2_ADD_SUB;

            3'b010: // AND
                begin
                    Carry <= 1'b0;
                    ALU_Result <= i_Operand1 & i_Operand2;
                end

            3'b011: // ORR
                begin
                    Carry <= 1'b0;
                    ALU_Result <= i_Operand1 | i_Operand2;
                end

            3'b100: // XOR
                begin
                    Carry <= 1'b0;
                    ALU_Result <= i_Operand1 ^ i_Operand2;
                end

            3'b101: // NOT A
                begin
                    Carry <= 1'b0;
                    ALU_Result <= ~i_Operand1;
                end

            3'b110: // PASS A
                begin
                    Carry <= 1'b0;
                    ALU_Result <= i_Operand1;
                end

            3'b111: // PASS B
                begin
                    Carry <= 1'b0;
                    ALU_Result <= i_Operand2;
                end
            default
                begin
                    Carry <= 1'b0;
                    ALU_Result <= 32'bx;
                end
        endcase
    end

endmodule