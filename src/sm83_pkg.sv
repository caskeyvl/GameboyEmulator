package sm83_pkg;

// ---------------------------------------------------------------------------
// ALU operations
// ---------------------------------------------------------------------------
typedef enum logic [4:0] {
    ALU_ADD  = 5'd0,   // A + r          Z 0 H C
    ALU_ADC  = 5'd1,   // A + r + CY     Z 0 H C
    ALU_SUB  = 5'd2,   // A - r          Z 1 H C
    ALU_SBC  = 5'd3,   // A - r - CY     Z 1 H C
    ALU_AND  = 5'd4,   // A & r          Z 0 1 0
    ALU_XOR  = 5'd5,   // A ^ r          Z 0 0 0
    ALU_OR   = 5'd6,   // A | r          Z 0 0 0
    ALU_CP   = 5'd7,   // A - r (no wb)  Z 1 H C
    ALU_INC  = 5'd8,   // r + 1          Z 0 H -
    ALU_DEC  = 5'd9,   // r - 1          Z 1 H -
    ALU_ADD16 = 5'd10, // HL + r16       - 0 H C
    ALU_ADDSP = 5'd11, // SP + e8        0 0 H C
    // CB-prefix rotates / shifts
    ALU_RLC  = 5'd12,  // rotate left, old bit 7 -> C
    ALU_RRC  = 5'd13,  // rotate right, old bit 0 -> C
    ALU_RL   = 5'd14,  // rotate left through C
    ALU_RR   = 5'd15,  // rotate right through C
    ALU_SLA  = 5'd16,  // shift left arithmetic
    ALU_SRA  = 5'd17,  // shift right arithmetic (MSB preserved)
    ALU_SWAP = 5'd18,  // swap upper/lower nibbles
    ALU_SRL  = 5'd19,  // shift right logical
    // CB-prefix bit ops
    ALU_BIT  = 5'd20,  // test bit n      Z 0 1 -
    ALU_RES  = 5'd21,  // reset bit n     - - - -
    ALU_SET  = 5'd22,  // set bit n       - - - -
    // Misc accumulator ops
    ALU_DAA  = 5'd23,  // decimal adjust  Z - 0 C
    ALU_CPL  = 5'd24,  // complement A    - 1 1 -
    ALU_NOP  = 5'd31   // pass-through
} alu_op_t;

// ---------------------------------------------------------------------------
// Flags register (F), upper nibble only, lower 4 bits always 0
// Packed so the whole struct can be treated as logic [7:0] and assigned
// directly to/from the F register.
// ---------------------------------------------------------------------------
typedef struct packed {
    logic z;        // bit 7 — zero
    logic n;        // bit 6 — subtract
    logic h;        // bit 5 — half-carry
    logic c;        // bit 4 — carry
    logic [3:0] unused; // bits 3-0, hardwired 0
} flags_t;

// ---------------------------------------------------------------------------
// 8-bit registers (r8)
// ---------------------------------------------------------------------------
typedef enum logic [2:0] {
    REG8_B   = 3'd0,
    REG8_C   = 3'd1,
    REG8_D   = 3'd2,
    REG8_E   = 3'd3,
    REG8_H   = 3'd4,
    REG8_L   = 3'd5,
    REG8_MHL = 3'd6,
    REG8_A   = 3'd7
} reg8_e;

// ---------------------------------------------------------------------------
// 16-bit registers (r16)
// ---------------------------------------------------------------------------
typedef enum logic [2:0] {
    REG16_BC = 3'd0,
    REG16_DE = 3'd1,
    REG16_HL = 3'd2,
    REG16_SP = 3'd3,
    REG16_AF = 3'd4,
    REG16_PC = 3'd5
} reg16_e;

endpackage : sm83_pkg
