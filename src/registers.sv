/**
 * registers.sv
 *
 * SM83 register file. Holds A, F, B, C, D, E, H, L (8-bit) and SP, PC (16-bit).
 * Supports muxed read/write by reg8_e and reg16_e selectors.
 * REG8_MHL is not a physical register — reads return 0x00, writes are ignored.
 */

import sm83_pkg::*;

module registers (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        wr_en8,
    input  reg8_e       wr_reg8,
    input  logic [7:0]  wr_data8,

    input  logic        wr_en16,
    input  reg16_e      wr_reg16,
    input  logic [15:0] wr_data16,

    input  reg8_e       rd_sel8,
    output logic [7:0]  rd_r8,

    input  reg16_e      rd_sel16,
    output logic [15:0] rd_r16
);

    logic [7:0]  r_a, r_b, r_c, r_d, r_e, r_h, r_l;
    flags_t      r_f;
    logic [15:0] r_sp, r_pc;

    // 8-bit read operation
    always_comb begin 
        unique case (rd_sel8)
            REG8_B:     rd_r8 = r_b;
            REG8_C:     rd_r8 = r_c;
            REG8_D:     rd_r8 = r_d;
            REG8_E:     rd_r8 = r_e;
            REG8_H:     rd_r8 = r_h;
            REG8_L:     rd_r8 = r_l;
            REG8_A:     rd_r8 = r_a;
            REG8_MHL:   rd_r8 = 8'h00;  // memory ref - value comes from bus, not reg file 
            default:    rd_r8 = 8'h00;
        endcase
    end

    // 16-bit read operations
    always_comb begin
        unique case (rd_sel16)
            REG16_BC: rd_r16 = {r_b, r_c};
            REG16_DE: rd_r16 = {r_d, r_e};
            REG16_HL: rd_r16 = {r_h, r_l};
            REG16_SP: rd_r16 = r_sp;
            REG16_AF: rd_r16 = {r_a, r_f};
            REG16_PC: rd_r16 = r_pc;
            default:  rd_r16 = 16'h0000; 
        endcase
    end

    // write operations (sequential)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_a  <= 8'h11;  // CGB identifier — games check A==0x11 to detect GBC hardware
            r_f  <= flags_t'(8'h80);
            r_b  <= 8'h00;
            r_c  <= 8'h00;
            r_d  <= 8'hFF;
            r_e  <= 8'h56;
            r_h  <= 8'h00;
            r_l  <= 8'h0D;
            r_sp <= 16'hFFFE;
            r_pc <= 16'h0100;
        end else begin
            if (wr_en8) begin
                unique case (wr_reg8)
                    REG8_B:   r_b <= wr_data8;
                    REG8_C:   r_c <= wr_data8;
                    REG8_D:   r_d <= wr_data8;
                    REG8_E:   r_e <= wr_data8;
                    REG8_H:   r_h <= wr_data8;
                    REG8_L:   r_l <= wr_data8;
                    REG8_A:   r_a <= wr_data8;
                    REG8_MHL: ;
                    default:  ;
                endcase
            end
            if (wr_en16) begin
                unique case (wr_reg16)
                    REG16_BC: {r_b, r_c} <= wr_data16;
                    REG16_DE: {r_d, r_e} <= wr_data16;
                    REG16_HL: {r_h, r_l} <= wr_data16;
                    REG16_SP: r_sp        <= wr_data16;
                    REG16_AF: begin
                        r_a <= wr_data16[15:8];
                        r_f <= flags_t'({wr_data16[7:4], 4'b0});
                    end
                    REG16_PC: r_pc <= wr_data16;
                    default:  ;
                endcase
            end
        end
    end

endmodule : registers
