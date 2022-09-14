module Check_Condition
    (
        i_Cond,
        i_CPSR,
        o_IfCondition
    );

    input  logic [3:0] i_Cond;
    input  logic [3:0] i_CPSR;
    
    output logic o_IfCondition;

    // CPSR = NZCV

    logic N, Z, C, V;

    assign { N, Z, C, V } = i_CPSR;

    always_comb begin
        case (i_Cond)
            4'b0000:
                o_IfCondition <= Z;
            4'b0001:
                o_IfCondition <= ~Z;
            4'b0010:
                o_IfCondition <= C;
            4'b0011:
                o_IfCondition <= ~C;
            4'b0100:
                o_IfCondition <= N;
            4'b0101:
                o_IfCondition <= ~N;
            4'b0110:
                o_IfCondition <= V;
            4'b0111:
                o_IfCondition <= ~V;
            4'b1000:
                o_IfCondition <= C & ~Z;
            4'b1001:
                o_IfCondition <= ~C | Z;
            4'b1010:
                o_IfCondition <= N & V;
            4'b1011:
                o_IfCondition <= N ^ V;
            4'b1100:
                o_IfCondition <= ~Z & (N & V);
            4'b1101:
                o_IfCondition <= Z | (N ^ V);
            4'b1110:
                o_IfCondition <= 1'b1;
            default:
                o_IfCondition <= 1'b0;
        endcase
    end

endmodule