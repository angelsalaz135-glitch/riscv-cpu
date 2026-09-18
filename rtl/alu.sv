module alu (
    input  rv32_pkg::word_t   a_i,
    input  rv32_pkg::word_t   b_i,
    input  rv32_pkg::alu_op_t op_i,
    output rv32_pkg::word_t   result_o
);

    import rv32_pkg::*;

    always_comb begin
        case (op_i)
            ALU_ADD:  result_o = a_i + b_i;
            ALU_SUB:  result_o = a_i - b_i;

            ALU_AND:  result_o = a_i & b_i;
            ALU_OR:   result_o = a_i | b_i;
            ALU_XOR:  result_o = a_i ^ b_i;

            ALU_SLL:  result_o = a_i << b_i[4:0];
            ALU_SRL:  result_o = a_i >> b_i[4:0];
            ALU_SRA:  result_o = $signed(a_i) >>> b_i[4:0];

            ALU_SLT:  result_o =
                ($signed(a_i) < $signed(b_i)) ? 32'd1 : 32'd0;

            ALU_SLTU: result_o =
                (a_i < b_i) ? 32'd1 : 32'd0;

            default:  result_o = '0;
        endcase
    end

endmodule
