package rv32_pkg;

    // RV32 uses 32-bit register values and data paths.
    localparam int unsigned XLEN = 32;

    // Five bits select one of 32 registers.
    localparam int unsigned REG_ADDR_W = 5;

    // Shared types for data values and register indices.
    typedef logic [XLEN-1:0]       word_t;
    typedef logic [REG_ADDR_W-1:0] reg_addr_t;

    // Internal operation codes used to control our ALU.
    typedef enum logic [3:0] {
        ALU_ADD  = 4'd0,
        ALU_SUB  = 4'd1,
        ALU_AND  = 4'd2,
        ALU_OR   = 4'd3,
        ALU_XOR  = 4'd4,
        ALU_SLL  = 4'd5,
        ALU_SRL  = 4'd6,
        ALU_SRA  = 4'd7,
        ALU_SLT  = 4'd8,
        ALU_SLTU = 4'd9
    } alu_op_t;

endpackage : rv32_pkg
