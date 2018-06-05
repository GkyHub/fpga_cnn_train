import  INS_CONST::*;

module top_control#(
    parameter   PE_NUM  = 32
    )(
    input   clk,
    input   rst,
    
    // instruction input interface
    input                   ins_valid,
    output                  ins_ready,
    input   [INST_W -1 : 0] ins,
    
    output  working,
    
    // instruction demux interface
    output                  ddr2pe_ins_valid,
    input                   ddr2pe_ins_ready,
    output  [INST_W -1 : 0] ddr2pe_ins,
    
    output                  pe_ins_valid,
    input                   pe_ins_ready,
    output  [INST_W -1 : 0] pe_ins,
    
    output                  pe2ddr_ins_valid,
    input                   pe2ddr_ins_ready,
    output  [INST_W -1 : 0] pe2ddr_ins,
    
    // layer configuration interface
    output  [3 : 0] conf_layer_type,
    output  [3 : 0] conf_in_ch_seg,
    output  [3 : 0] conf_out_ch_seg,
    output  [7 : 0] conf_in_img_width,
    output  [7 : 0] conf_out_img_width,
    output          conf_pooling, 
    output          conf_relu,
    output          conf_depool,
    
    // ping pong buffer control signal
    output  [PE_NUM -1 : 0] switch_d,   // switch the ping pong buffer data
    output  [PE_NUM -1 : 0] switch_p,   // switch the ping pong buffer param
    output  [PE_NUM -1 : 0] switch_i,   // switch the ping pong buffer idx
    output  [PE_NUM -1 : 0] switch_a,   // switch the ping pong buffer accum
    output                  switch_b,
    
    // pe working signal
    input   [PE_NUM -1 : 0] pe_done
    );
    
    reg                     ddr2pe_ins_valid_r;
    reg     [INST_W -1 : 0] ddr2pe_ins_r;    
    reg                     pe_ins_valid_r;
    reg     [INST_W -1 : 0] pe_ins_r;    
    reg                     pe2ddr_ins_valid_r;
    reg     [INST_W -1 : 0] pe2ddr_ins_r;
    
    assign ddr2pe_ins_valid = ddr2pe_ins_valid_r;
    assign ddr2pe_ins       = ddr2pe_ins_r;    
    assign pe_ins_valid     = pe_ins_valid_r;
    assign pe_ins           = pe_ins_r;    
    assign pe2ddr_ins_valid = pe2ddr_ins_valid_r;
    assign pe2ddr_ins       = pe2ddr_ins_r;
    
//=============================================================================
// configuration instruction  
//=============================================================================
    
    reg     [3 : 0] layer_type_r;
    reg     [3 : 0] in_ch_seg_r;
    reg     [3 : 0] out_ch_seg_r;
    reg     [7 : 0] in_img_width_r;
    reg     [7 : 0] out_img_width_r;
    reg     pooling_r, relu_r, depool_r;
    
    // configuration FSM
    reg     all_done_r;
    
    always @ (posedge clk) begin
        all_done_r <= ddr2pe_ins_ready && pe2ddr_ins_ready && (&pe_done);
    end
    
    localparam  CONF_IDLE   = 2'b00;
    localparam  CONF_WAIT   = 2'b01;
    localparam  CONF_WORK   = 2'b10;
    
    reg     [1 : 0] conf_stat_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            conf_stat_r <= CONF_IDLE;
        end
        else begin
            case(conf_stat_r)
            CONF_IDLE: begin
                if (ins_valid && ins[63:62] == 2'b11) begin
                    conf_stat_r <= CONF_WAIT;
                end
            end
            CONF_WAIT: begin
                if (all_done_r) begin
                    conf_stat_r <= CONF_WORK;
                end
            end
            CONF_WORK: begin
                conf_stat_r <= CONF_IDLE;
            end
            endcase
        end
    end
    
    // configuration work
    always @ (posedge clk) begin
        if (conf_stat_r == CONF_WORK) begin
            layer_type_r    = ins[61:58];   
            in_ch_seg_r     = ins[55:52];    
            out_ch_seg_r    = ins[51:48];   
            in_img_width_r  = ins[47:40]; 
            out_img_width_r = ins[39:32];
            pooling_r       = (ins[61:60] == 2'b00) ? ins[57] : 1'b0;      
            relu_r          = (ins[61:60] == 2'b00) ? ins[56] : 1'b0;         
            depool_r        = (ins[61:60] == 2'b00) ? 1'b0 : ins[57];
        end
    end
    
    assign  conf_layer_type     = layer_type_r;   
    assign  conf_in_ch_seg      = in_ch_seg_r;    
    assign  conf_out_ch_seg     = out_ch_seg_r;   
    assign  conf_in_img_width   = in_img_width_r; 
    assign  conf_out_img_width  = out_img_width_r;
    assign  conf_pooling        = pooling_r;      
    assign  conf_relu           = relu_r;         
    assign  conf_depool         = depool_r;       
    
//=============================================================================
// ddr2pe instruction  
//=============================================================================  
    
    // receive instruction FSM
    localparam  LOAD_IDLE   = 2'b00;
    localparam  LOAD_WAIT   = 2'b01;
    localparam  LOAD_WORK   = 2'b10;
    
    reg     [1 : 0] load_stat_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            load_stat_r <= LOAD_IDLE;
        end
        else begin
            case(load_stat_r)
            LOAD_IDLE: begin
                if (ins_valid && ins[63:62] == 2'b00) begin
                    load_stat_r <= LOAD_WAIT;
                end
            end
            LOAD_WAIT: begin
                if (ddr2pe_ins_ready) begin
                    load_stat_r <= LOAD_WORK;
                end
            end
            LOAD_WORK: begin
                load_stat_r <= LOAD_IDLE;
            end
            endcase
        end
    end
    
    // send instruction
    always @ (posedge clk) begin
        if (rst) begin
            ddr2pe_ins_valid_r  <= 1'b0;
        end
        else if (load_stat_r == LOAD_WORK) begin
            ddr2pe_ins_valid_r  <= 1'b1;
            ddr2pe_ins_r        <= ins;
        end
        else begin
            ddr2pe_ins_valid_r  <= 1'b0;
        end
    end

//=============================================================================
// pe instruction  
//=============================================================================

    // receive instruction FSM
    localparam  CALC_IDLE   = 2'b00;
    localparam  CALC_WAIT   = 2'b01;
    localparam  CALC_WORK   = 2'b10;
    
    reg     [1 : 0] calc_stat_r;
    reg     [5 : 0] pe_id_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            calc_stat_r <= CALC_IDLE;
        end
        else begin
            case(calc_stat_r)
            CALC_IDLE: begin
                if (ins_valid && ins[63:62] == 2'b01) begin
                    calc_stat_r <= CALC_WAIT;
                end
            end
            CALC_WAIT: begin
                if (ddr2pe_ins_ready && pe_done[pe_id_r]) begin
                    calc_stat_r <= CALC_WORK;
                end
            end
            CALC_WORK: begin
                calc_stat_r <= CALC_IDLE;
            end
            endcase
        end
    end
    
    // record the pe to work
    always @ (posedge clk) begin
        if (rst) begin
            pe_id_r <= 0;
        end
        else if (calc_stat_r == CALC_IDLE && ins_valid && ins[63:62] == 2'b01) begin
            if (layer_type_r[0]) begin
                pe_id_r <= ins[57:52];
            end
            else begin
                pe_id_r <= ins[57:52] << 2;
            end
        end
    end
    
    // send instruction    
    always @ (posedge clk) begin
        if (rst) begin
            pe_ins_valid_r  <= 1'b0;
        end
        else if (calc_stat_r == CALC_WORK) begin
            pe_ins_valid_r  <= 1'b1;
            pe_ins_r        <= ins;
        end
        else begin
            pe_ins_valid_r  <= 1'b0;
        end
    end
    
//=============================================================================
// pe2ddr instruction  
//=============================================================================

    // receive instruction FSM
    localparam  SAVE_IDLE   = 2'b00;
    localparam  SAVE_WAIT   = 2'b01;
    localparam  SAVE_WORK   = 2'b10;
    
    reg     [1 : 0] save_stat_r;
    reg     [5 : 0] pe2ddr_id_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            save_stat_r <= SAVE_IDLE;
        end
        else begin
            case(save_stat_r)
            SAVE_IDLE: begin
                if (ins_valid && ins[63:62] == 2'b10) begin
                    save_stat_r <= SAVE_WAIT;
                end
            end
            SAVE_WAIT: begin
                if (pe2ddr_ins_ready && pe_done[pe2ddr_id_r]) begin
                    save_stat_r <= SAVE_WORK;
                end
            end
            SAVE_WORK: begin
                save_stat_r <= SAVE_IDLE;
            end
            endcase
        end
    end
    
    // record the pe to work
    always @ (posedge clk) begin
        if (rst) begin
            pe2ddr_id_r <= 0;
        end
        else if (save_stat_r == SAVE_IDLE && ins_valid && ins[63:62] == 2'b10) begin
            if (layer_type_r[0]) begin
                pe2ddr_id_r <= ins[57:52];
            end
            else begin
                pe2ddr_id_r <= ins[57:52] << 2;
            end
        end
    end
    
    // send instruction    
    always @ (posedge clk) begin
        if (rst) begin
            pe2ddr_ins_valid_r  <= 1'b0;
        end
        else if (save_stat_r == SAVE_WORK) begin
            pe2ddr_ins_valid_r  <= 1'b1;
            pe2ddr_ins_r        <= ins;
        end
        else begin
            pe2ddr_ins_valid_r  <= 1'b0;
        end
    end
    
//=============================================================================
// switch ping pong buffer
//=============================================================================
    reg     [PE_NUM -1 : 0] switch_d_r;
    reg     [PE_NUM -1 : 0] switch_p_r;
    reg     [PE_NUM -1 : 0] switch_i_r;
    reg     [PE_NUM -1 : 0] switch_a_r;
    reg                     switch_b_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            switch_d_r <= '0;
            switch_p_r <= '0;
            switch_i_r <= '0;
        end
        if (calc_stat_r == CALC_WORK) begin
            if (layer_type_r[0]) begin
                switch_d_r <= 1 << pe_id_r;
                switch_p_r <= 1 << pe_id_r;
                switch_i_r <= 1 << pe_id_r;
            end
            else begin
                switch_d_r <= 15 << pe_id_r;
                switch_p_r <= 15 << pe_id_r;
                switch_i_r <= 15 << pe_id_r;
            end
        end
        else begin
            switch_d_r <= '0;
            switch_p_r <= '0;
            switch_i_r <= '0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            switch_a_r <= '0;
        end
        else if (save_stat_r == SAVE_WORK) begin
            if (layer_type_r[0]) begin
                switch_a_r <= 1 << pe2ddr_id_r;
            end
            else begin
                switch_a_r <= 15 << pe2ddr_id_r;
            end
        end
        else if (calc_stat_r == CALC_WORK && layer_type_r[2:1] == 2'b10) begin
            if (layer_type_r[0]) begin
                switch_a_r <= 1 << pe_id_r;
            end
            else begin
                switch_a_r <= 15 << pe_id_r;
            end
        end
        else begin
            switch_a_r <= '0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            switch_b_r <= 1'b0;
        end
        else if (save_stat_r == SAVE_WORK && layer_type_r[2:1] == 2'b10 && ins[58]) begin
            switch_b_r <= 1'b1;
        end
        else begin
            switch_b_r <= 1'b0;
        end
    end
    
    assign  switch_d = switch_d_r;
    assign  switch_p = switch_p_r;
    assign  switch_i = switch_i_r;
    assign  switch_a = switch_a_r;
    assign  switch_b = switch_b_r;
    
//=============================================================================
// pe work status and ins ready
//=============================================================================

    reg     ins_ready_r;
    reg     working_r;
    
    assign  ins_ready = (conf_stat_r == CONF_WORK || load_stat_r == LOAD_WORK ||
            calc_stat_r == CALC_WORK || save_stat_r == SAVE_WORK);
    /*
    always @ (posedge clk) begin
        if (rst) begin
            ins_ready_r <= 1'b0;
        end
        else if (conf_stat_r == CONF_WORK || load_stat_r == LOAD_WORK ||
            calc_stat_r == CALC_WORK || save_stat_r == SAVE_WORK) begin
            ins_ready_r <= 1'b1;
        end
        else begin
            ins_ready_r <= 1'b0;
        end
    end
    */
    
    always @ (posedge clk) begin
        if (rst) begin
            working_r <= 1'b0;
        end
        else if (ins_valid || !all_done_r) begin
            working_r <= 1'b1;
        end
        else begin
            working_r <= 1'b0;
        end
    end
    
    // assign  ins_ready = ins_ready_r;
    assign  working   = working_r;
    
endmodule