package INS_CONST;
    
    localparam INST_W       = 64;
    
    // configuration instruction
    // [63:62] instruction type: 2'b11
    // [61:58] layer type
    // [57:57] pooling/depool
    // [56:56] relu
    // [55:52] input channel segment
    // [51:48] output channel segment
    // [47:40] input image width (for data arrangment in ddr)
    // [39:32] output image width (for data arrangment in ddr)
    // [31: 0] null
    
    // layer type
    // [3 : 3] null
    // [2 : 1] phase
    // [0 : 0] type
    localparam LT_F_CONV    = 4'b0000;
    localparam LT_F_FC      = 4'b0001;
    localparam LT_B_CONV    = 4'b0010;
    localparam LT_B_FC      = 4'b0011;
    localparam LT_U_CONV    = 4'b0100;
    localparam LT_U_FC      = 4'b0101;
    
    // load instruction format
    // [63:62] instruction type: 2'b00
    // [61:58] opcode
    // [57:52] buf_id
    // [51:40] {4'd0, row_num, pix_num} / {param_size}
    // [39:32] size
    // [31: 0] ddr address
    localparam RD_OP_D      = 4'b0000;  // neuron
    localparam RD_OP_G      = 4'b0001;  // neuron gradient
    localparam RD_OP_DW     = 4'b0100;  // weights MSB
    localparam RD_OP_DB     = 4'b0101;  // bias MSB
    localparam RD_OP_TW     = 4'b0110;  // weights LSB
    localparam RD_OP_TB     = 4'b0111;  // bias LSB
    // localparam RD_OP_I      = 4'b1000;  // read index when read RD_OP_DW
    
    // calc instruction
    // [63:62] instruction type: 2'b01
    // [59:59] cut_y
    // [58:58] is_new
    // [57:52] pe_id
    // [51:48] pad_code
    // [47:40] pix_num
    // [39:32] index num
    
    // save instruction opcode
    // [63:62] instruction type: 2'b10
    // [61:58] opcode
    // [57:52] buf_id
    // [31: 0] ddr address
    localparam WR_OP_D      = 4'b0000;
    localparam WR_OP_W      = 4'b1000;
    localparam WR_OP_B      = 4'b1010;
    localparam WR_OP_TW     = 4'b1001;
    localparam WR_OP_TB     = 4'b1011;
    
    // instruction generation function for simulation
    function [63: 0] INS_CONF;
        input   [3 : 0] layer_type;
        input   pooling, relu;
        input   [3 : 0] in_ch_seg, out_ch_seg;
        input   [7 : 0] in_img_width, out_img_width;
        
        begin
            INS_CONF = {2'b11, layer_type, pooling, relu, in_ch_seg, out_ch_seg, 
                in_img_width, out_img_width, 32'd0};
        end
    endfunction
    
    function [63: 0] INS_LOAD;
        input   [3 : 0] load_type;
        input   [5 : 0] buf_id;
        input   [7 : 0] size;
        input   [11: 0] p_size; // {4'd0, row_num, pix_num}
        input   [31: 0] st_addr;
        
        begin
            INS_LOAD = {2'b00, load_type, buf_id, p_size, size, st_addr};
        end
        
    endfunction
    
    function [63: 0] INS_CALC;
        input   cut_y, is_new;
        input   [5 : 0] pe_id;
        input   [3 : 0] pad_code;
        input   [7 : 0] pix_num;
        input   [7 : 0] index_num;
        
        begin
            INS_CALC = {2'b01, 2'b00, cut_y, is_new, pe_id, pad_code, pix_num, index_num, 32'd0};
        end
    
    endfunction
    
    function [63: 0] INS_SAVE;
        input   [3 : 0] save_type;
        input   [5 : 0] buf_id;
        input   [11: 0] size;   // size / {4'd0, row_num, pix_num}       
        input   [7 : 0] shift;
        input   [31: 0] st_addr;        
        
        reg     [7 : 0] temp;
        
        begin
            INS_SAVE = {2'b10, save_type, buf_id, size, shift, st_addr};
        end
        
    endfunction
    
endpackage