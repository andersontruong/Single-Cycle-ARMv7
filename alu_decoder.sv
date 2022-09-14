module ALU_Decoder
    (
        clk,
        reset,
        i_OpCode,
        i_Set_Condition,
        i_CPSR,
        i_IfCondition,
        i_IfDP,

        o_ALU_OpCode,
        o_CPSR
    );

    input  logic clk;
    input  logic reset;
    input  logic [3:0] i_OpCode;
    input  logic i_Set_Condition;
    input logic [3:0] i_CPSR;
    input  logic i_IfCondition;
    input  logic i_IfDP;

    output logic [2:0] o_ALU_OpCode;
    output logic [3:0] o_CPSR;

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

    always_comb begin
        // ADD (ADD)
        if (~i_IfDP)
            o_ALU_OpCode <= 3'b000;
        else
            case (i_OpCode)
            4'b0100:
                o_ALU_OpCode <= 3'b000;
            4'b0010:
                o_ALU_OpCode <= 3'b001;
            4'b0000:
                o_ALU_OpCode <= 3'b010;
            4'b1100:
                o_ALU_OpCode <= 3'b011;
            4'b0001:
                o_ALU_OpCode <= 3'b100;
            4'b1111:
                o_ALU_OpCode <= 3'b101;
            4'b1101:
                o_ALU_OpCode <= 3'b111;
            default:
                o_ALU_OpCode <= 3'b0;
            endcase
            
    end

    // CPSR

    always_ff @(posedge clk) begin
        if (reset)
            o_CPSR <= 4'b0;
        else if (i_Set_Condition & i_IfCondition)
            o_CPSR <= i_CPSR;
    end

endmodule