import sm83_pkg::*; 

module alu(
    input alu_op_t op,

    input logic [7:0] a,
    input logic [7:0] b,

    input flags_t flags_in,
    output flags_t flags_out,

    input logic [2:0] bit_idx,

    output logic [7:0] result,
);

    always_comb begin
        logic [8:0] s_tmp;
        result      = 8'h00;
        flags_out   = flags_in;

        unique case (op)
            ALU_ADD: begin
                s_tmp       = {1'b0, a} + {1'b0, b};
                result      = s_tmp[7:0]; 
                flags_out.z = ~|s_tmp[7:0];
                flags_out.n = 1'b0;
                flags_out.h = (a[3:0] + b[3:0]) > 4'hF;
                flags_out.c = s_tmp[8];
            end
            ALU_ADC: begin
                s_tmp       = {1'b0, a} + {1'b0, b} + {8'b0, flags_in.c};
                result      = s_tmp[7:0];
                flags_out.z = ~|s_tmp[7:0];
                flags_out.n = 1'b0;
                flags_out.h = (a[3:0] + b[3:0] + flags_in.c) > 4'hF;
                flags_out.c = s_tmp[8];
            end
            ALU_SUB: begin
                s_tmp       = {1'b0, a} - {1'b0, b};
                result      = s_tmp[7:0];
                flags_out.z = ~|s_tmp[7:0];
                flags_out.n = 1'b1;
                flags_out.h = a[3:0] < b[3:0];
                flags_out.c = s_tmp[8];
            end
            ALU_SBC:  begin                 // A - r - CY     Z 1 H C
                s_tmp       = {1'b0, a} - {1'b0, b} - {8'b0, flags_in.c};
                result      = s_tmp[7:0];
                flags_out.z = ~|s_tmp[7:0];
                flags_out.n = 1'b1;
                flags_out.h = a[3:0] < (b[3:0] + flags_in.c);
                flags_out.c = s_tmp[8];
            end
            ALU_AND: begin                                      
                result      = a & b; 
                flags_out.z = ~|s_tmp[7:0];                     
                flags_out.n = 1'b0;                             
                flags_out.h = 1'b1;                             
                flags_out.c = 1'b0;                             
            end                                                 
            ALU_XOR: begin                                      
                result      = a ^ b;
                flags_out.z = ~|s_tmp[7:0];                     
                flags_out.n = 1'b0;
                flags_out.h = 1'b0; 
                flags_out.c = 1'b0; 
            end
            ALU_OR: begin
                result      = a | b;
                flags_out.z = ~|s_tmp[7:0];
                flags_out.n = 1'b0;
                flags_out.h = 1'b0; 
                flags_out.c = 1'b0; 
            end
            ALU_CP: begin                               
                s_tmp       = {1'b0, a} - {1'b0, b};
                result      = s_tmp[7:0]; 
                flags_out.z = ~|s_tmp[7:0];
                flags_out.n = 1'b1;
                flags_out.h = (a[3:0] - b[3:0]) > 4'hF;
                flags_out.c = s_tmp[8];
            end                                         
            ALU_INC: begin                              
                s_tmp       = {1'b0, a} + 1'b1;
                result      = s_tmp[7:0]; 
                flags_out.z = ~|s_tmp[7:0];
                flags_out.n = 1'b0;
                flags_out.h = (a[3:0] + 1'b1) > 4'hF; 
                flags_out.c = s_tmp[8]; 
            end                                         
            ALU_DEC: begin                              
                s_tmp       = {1'b0, a} - 1'b1;
                result      = s_tmp[7:0]; 
                flags_out.z = ~|s_tmp[7:0];
                flags_out.n = 1'b1;
                flags_out.h = (a[3:0] + 1'b1) > 4'hF; 
                flags_out.c = s_tmp[8]; 
            end                                         
            ALU_ADD16: begin
            end                                         
            ALU_ADDSP: begin                            
            end                                         
        endcase                                         
    end                                                 

endmodule : alu
