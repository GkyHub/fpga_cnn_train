import GLOBAL_PARAM::bw;
import GLOBAL_PARAM::IDX_W;
import GLOBAL_PARAM::BATCH;

module pe_agu#(
    parameter   ADDR_W      = 8,
    parameter   IDX_DEPTH   = 256,
    parameter   IDX_ADDR_W  = bw(IDX_DEPTH),
    parameter   GRP_ID_X    = 0,
    parameter   GRP_ID_Y    = 0
    )(
    input   clk,
    input   rst,
    
    input   switch_idx_buf, 
    
    // instruction port
    input               start,
    output              done,
    input   [3  -1 : 0] mode,       // {phase[1 : 0], layer[0]}
                                    // phase: 00: forward, 01: backward, 10: update
                                    // layer: 0: conv, 1: fc
    input   [8  -1 : 0] idx_cnt,    // number of idx to deal with
    input   [8  -1 : 0] trip_cnt,   // number of cycles for the agu to work with a single cycle
    input               is_new,
    input   [4  -1 : 0] pad_code,   // {R, L, D, U}
    input               cut_y,
    output  [2  -1 : 0] conf_mode,
    
    // index buffer write port
    input   [IDX_W*2    -1 : 0] idx_wr_data,
    input   [IDX_ADDR_W -1 : 0] idx_wr_addr,
    input                       idx_wr_en,
    
    // buffer address generation port
    output  [ADDR_W     -1 : 0] dbuf_addr,  // data buffer address
    output                      dbuf_mask,  // padding mask
    output  [2          -1 : 0] dbuf_mux,   // data sharing mux
    
    output  [ADDR_W     -1 : 0] pbuf_addr,  // parameter buffer address
    output  [bw(BATCH)  -1 : 0] pbuf_sel,   // parameter scalar selection 
    
    output                      mac_new_acc,// mac array clear signal
    
    output  [ADDR_W     -1 : 0] abuf_addr,  // accumulate buffer address
    output  [BATCH      -1 : 0] abuf_acc_en,// enable mask
    output                      abuf_acc_new
    );
    
    reg     [ADDR_W     -1 : 0] dbuf_addr_r;
    reg                         dbuf_mask_r;
    reg     [2          -1 : 0] dbuf_mux_r;     
    reg     [ADDR_W     -1 : 0] pbuf_addr_r;
    reg     [bw(BATCH)  -1 : 0] pbuf_sel_r;
    reg                         mac_new_acc_r;
    reg     [ADDR_W     -1 : 0] abuf_addr_r;
    reg     [BATCH      -1 : 0] abuf_acc_en_r;
    reg                         abuf_acc_new_r;
    reg     [IDX_ADDR_W -1 : 0] idx_rd_addr_r;
    
    reg     done_r;
    
    wire    [IDX_W * 2  -1 : 0] idx_rd_data;
    
    wire    [8  -1 : 0] conf_idx_cnt; 
    wire    [8  -1 : 0] conf_trip_cnt;
    wire                conf_is_new;
    wire                conf_pad_u;
    wire                conf_pad_l;
    wire    [6  -1 : 0] conf_lim_r;
    wire    [6  -1 : 0] conf_lim_d;
    wire    [6  -1 : 0] conf_row_cnt;
    
    wire    start_fc, start_conv;
    wire    done_fc, done_conv;
    
    ping_pong_ram#(
        .DEPTH   (IDX_DEPTH     ),
        .WIDTH   (IDX_W * 2     ),
        .RAM_TYPE("distributed" )
    ) idx_ram_inst (
        .clk    (clk            ),
        .rst    (rst            ),
    
        .switch (switch_idx_buf ),
    
        .wr_addr(idx_wr_addr    ),
        .wr_data(idx_wr_data    ),
        .wr_en  (idx_wr_en      ),
    
        .rd_addr(idx_rd_addr_r  ),
        .rd_data(idx_rd_data    )
    );
    
    agu_config agu_config_inst(
        .clk        (clk        ),
        .rst        (rst        ),
    
        .start      (start      ),
        .mode       (mode       ),
        .idx_cnt    (idx_cnt    ),  
        .trip_cnt   (trip_cnt   ), 
        .is_new     (is_new     ),
        .pad_code   (pad_code   ), 
        .cut_y      (cut_y      ),
        
        .start_conv (start_conv ),
        .start_fc   (start_fc   ),
    
        .conf_mode      (conf_mode      ),
        .conf_idx_cnt   (conf_idx_cnt   ), 
        .conf_trip_cnt  (conf_trip_cnt  ),
        .conf_is_new    (conf_is_new    ),
        .conf_pad_u     (conf_pad_u     ),
        .conf_pad_l     (conf_pad_l     ),
        .conf_lim_r     (conf_lim_r     ),
        .conf_lim_d     (conf_lim_d     ),
        .conf_row_cnt   (conf_row_cnt   )
    );    
    
    wire    [IDX_ADDR_W -1 : 0] fc_idx_rd_addr;
    wire    [ADDR_W     -1 : 0] fc_dbuf_addr;
    wire                        fc_dbuf_mask;
    wire    [2          -1 : 0] fc_dbuf_mux;     
    wire    [ADDR_W     -1 : 0] fc_pbuf_addr;
    wire    [bw(BATCH)  -1 : 0] fc_pbuf_sel;
    wire                        fc_mac_new_acc;  
    wire    [ADDR_W     -1 : 0] fc_abuf_addr;
    wire    [BATCH      -1 : 0] fc_abuf_acc_en;
    wire                        fc_abuf_acc_new;
    
    wire    [IDX_ADDR_W -1 : 0] conv_idx_rd_addr;
    wire    [ADDR_W     -1 : 0] conv_dbuf_addr;
    wire                        conv_dbuf_mask;
    wire    [2          -1 : 0] conv_dbuf_mux;     
    wire    [ADDR_W     -1 : 0] conv_pbuf_addr;
    wire    [bw(BATCH)  -1 : 0] conv_pbuf_sel;
    wire                        conv_mac_new_acc;    
    wire    [ADDR_W     -1 : 0] conv_abuf_addr;
    wire    [BATCH      -1 : 0] conv_abuf_acc_en;
    wire                        conv_abuf_acc_new;
    
    fc_agu#(
        .ADDR_W (ADDR_W )
    ) fc_agu_inst (
        .clk            (clk            ),
        .rst            (rst            ),
    
        .start          (start_fc       ),
        .done           (fc_done        ),
        .conf_mode      (conf_mode      ),
        .conf_idx_cnt   (conf_idx_cnt   ),
        .conf_is_new    (conf_is_new    ),
    
        .idx_rd_addr    (fc_idx_rd_addr ),
        .idx            (idx_rd_data    ),
    
        .dbuf_addr      (fc_dbuf_addr   ),
        .dbuf_mask      (fc_dbuf_mask   ),
        .dbuf_mux       (fc_dbuf_mux    ),
    
        .pbuf_addr      (fc_pbuf_addr   ),
        .pbuf_sel       (fc_pbuf_sel    ),
        
        .mac_new_acc    (fc_mac_new_acc ),
    
        .abuf_addr      (fc_abuf_addr   ),
        .abuf_acc_en    (fc_abuf_acc_en ),
        .abuf_acc_new   (fc_abuf_acc_new)
    );
    
    conv_agu#(
        .ADDR_W     (ADDR_W     ),
        .GRP_ID_Y   (GRP_ID_X   ),
        .GRP_ID_X   (GRP_ID_Y   )
    ) conv_agu_inst (
        .clk            (clk            ),
        .rst            (rst            ),
    
        .start          (start_conv     ),
        .done           (conv_done      ),
        .conf_mode      (conf_mode      ),
        .conf_idx_cnt   (conf_idx_cnt   ), 
        .conf_trip_cnt  (conf_trip_cnt  ),
        .conf_is_new    (conf_is_new    ),
        .conf_pad_u     (conf_pad_u     ),
        .conf_pad_l     (conf_pad_l     ),
        .conf_lim_r     (conf_lim_r     ),
        .conf_lim_d     (conf_lim_d     ),
        .conf_row_cnt   (conf_row_cnt   ),
    
        .idx_rd_addr    (conv_idx_rd_addr),
        .idx            (idx_rd_data    ),
    
        .dbuf_addr      (conv_dbuf_addr ),
        .dbuf_mask      (conv_dbuf_mask ),
        .dbuf_mux       (conv_dbuf_mux  ), 
    
        .pbuf_addr      (conv_pbuf_addr ), 
        .pbuf_sel       (conv_pbuf_sel  ), 
    
        .mac_new_acc    (conv_mac_new_acc),
    
        .abuf_addr      (conv_abuf_addr   ),
        .abuf_acc_en    (conv_abuf_acc_en ),
        .abuf_acc_new   (conv_abuf_acc_new)
    );
    
    always @ (posedge clk) begin
        if (conf_mode == 2'b00 || conf_mode == 2'b10) begin
            idx_rd_addr_r   <= conv_idx_rd_addr;
            dbuf_addr_r     <= conv_dbuf_addr;
            dbuf_mask_r     <= conv_dbuf_mask;
            dbuf_mux_r      <= conv_dbuf_mux;    
            pbuf_addr_r     <= conv_pbuf_addr;
            pbuf_sel_r      <= conv_pbuf_sel;
            mac_new_acc_r   <= conv_mac_new_acc;            
            abuf_addr_r     <= conv_abuf_addr;
            abuf_acc_en_r   <= conv_abuf_acc_en;
            abuf_acc_new_r  <= conv_abuf_acc_new;
        end
        else begin
            idx_rd_addr_r   <= fc_idx_rd_addr;
            dbuf_addr_r     <= fc_dbuf_addr;
            dbuf_mask_r     <= fc_dbuf_mask;
            dbuf_mux_r      <= fc_dbuf_mux;    
            pbuf_addr_r     <= fc_pbuf_addr;
            pbuf_sel_r      <= fc_pbuf_sel;
            mac_new_acc_r   <= fc_mac_new_acc;
            abuf_addr_r     <= fc_abuf_addr;
            abuf_acc_en_r   <= fc_abuf_acc_en;
            abuf_acc_new_r  <= fc_abuf_acc_new;
        end
    end
    
    localparam  ST_IDLE    = 2'b00;
    localparam  ST_CONFIG  = 2'b01;
    localparam  ST_WORK    = 2'b10;
    
    reg     [1 : 0] stat_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            stat_r <= 2'b00;
        end
        else begin
            case(stat_r)
            ST_IDLE:    stat_r <= start ? ST_CONFIG : ST_IDLE;
            ST_CONFIG:  stat_r <= ST_WORK;
            ST_WORK: begin
                if ((conf_mode[0] && fc_done) || (~conf_mode[0] && conv_done)) begin
                    stat_r <= ST_IDLE;
                end
            end
            endcase
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            done_r  <= 1'b1;
        end
        else if (start) begin
            done_r  <= 1'b0;
        end
        else if ((stat_r == ST_WORK) && ((conf_mode[0] && fc_done) || (~conf_mode[0] && conv_done))) begin
            done_r  <= 1'b1;
        end
    end
     
    assign  done            = done_r;
    assign  dbuf_addr       = dbuf_addr_r;     
    assign  dbuf_mask       = dbuf_mask_r;     
    assign  dbuf_mux        = dbuf_mux_r;      
    assign  pbuf_addr       = pbuf_addr_r;     
    assign  pbuf_sel        = pbuf_sel_r;
    assign  mac_new_acc     = mac_new_acc_r;
    assign  abuf_addr       = abuf_addr_r;     
    assign  abuf_acc_en     = abuf_acc_en_r;   
    assign  abuf_acc_new    = abuf_acc_new_r;
    
endmodule