module tb_alu;

    timeunit 1ns;
    timeprecision 1ps;

    import rv32_pkg::*;

    word_t   a;
    word_t   b;
    word_t   result;
    alu_op_t op;

    int unsigned checks = 0;

    alu dut (
        .a_i      (a),
        .b_i      (b),
        .op_i     (op),
        .result_o (result)
    );

    task automatic check (
        input string   label,
        input alu_op_t operation,
        input word_t   operand_a,
        input word_t   operand_b,
        input word_t   expected
    );
        a  = operand_a;
        b  = operand_b;
        op = operation;

        #1ns;

        if (result !== expected) begin
            $fatal(
                1,
                "%s: a=%08h b=%08h expected=%08h got=%08h",
                label, a, b, expected, result
            );
        end

        checks++;
        $display("PASS: %s", label);
    endtask

    initial begin
        $dumpfile("build/alu.vcd");
        $dumpvars(0, tb_alu);

        // Addition and subtraction.
        check("ADD basic", ALU_ADD, 32'd7, 32'd5, 32'd12);

        check("ADD wraps at 32 bits",
              ALU_ADD, 32'hFFFFFFFF, 32'd1, 32'd0);

        check("SUB basic", ALU_SUB, 32'd9, 32'd4, 32'd5);

        check("SUB negative result",
              ALU_SUB, 32'd3, 32'd5, 32'hFFFFFFFE);

        // Bitwise logic.
        check("AND", ALU_AND,
              32'hF0F0F0F0, 32'h0FF00FF0, 32'h00F000F0);

        check("OR", ALU_OR,
              32'hF0F0F0F0, 32'h0FF00FF0, 32'hFFF0FFF0);

        check("XOR", ALU_XOR,
              32'hF0F0F0F0, 32'h0FF00FF0, 32'hFF00FF00);

        // Shifts.
        check("SLL basic", ALU_SLL, 32'd1, 32'd4, 32'd16);

        check("SLL by 31",
              ALU_SLL, 32'd1, 32'd31, 32'h80000000);

        check("SRL fills with zero",
              ALU_SRL, 32'h80000000, 32'd1, 32'h40000000);

        check("SRA preserves negative sign",
              ALU_SRA, 32'h80000000, 32'd1, 32'hC0000000);

        check("SRA positive value",
              ALU_SRA, 32'h40000000, 32'd1, 32'h20000000);

        check("SRA by 31",
              ALU_SRA, 32'h80000000, 32'd31, 32'hFFFFFFFF);

        check("Shift uses only bottom five bits",
              ALU_SLL, 32'd1, 32'd32, 32'd1);

        // Signed and unsigned comparisons.
        check("SLT negative versus positive",
              ALU_SLT, 32'hFFFFFFFF, 32'd1, 32'd1);

        check("SLTU same bits interpreted unsigned",
              ALU_SLTU, 32'hFFFFFFFF, 32'd1, 32'd0);

        check("SLT equal operands",
              ALU_SLT, 32'd5, 32'd5, 32'd0);

        check("SLTU less than",
              ALU_SLTU, 32'd3, 32'd5, 32'd1);

        $display("ALL %0d ALU TESTS PASSED", checks);
        $finish;
    end

endmodule

