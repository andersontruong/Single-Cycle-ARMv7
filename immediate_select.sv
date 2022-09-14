module Immediate_Select
    (
        i_Immediate_24,
        i_Immediate_Src,

        o_Immediate_32
    );

    input  logic [23:0] i_Immediate_24;
    input  logic [1:0] i_Immediate_Src;

    output logic [31:0] o_Immediate_32;

    always_comb begin
        case (i_Immediate_Src)
            2'b00:
                o_Immediate_32 <= { 24'b0, i_Immediate_24[7:0] };
            2'b01:
                o_Immediate_32 <= { 20'b0, i_Immediate_24[11:0] };
            2'b10:
                o_Immediate_32 <= { 6'b0, i_Immediate_24[23:0], 2'b0 };
            default:
                o_Immediate_32 <= 32'b0;
        endcase
    end
    

endmodule