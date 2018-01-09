import GLOBAL_PARAM::bw;
import GLOBAL_PARAM::RES_W;
import GLOBAL_PARAM::TAIL_W;
import  GLOBAL_PARAM::DATA_W;

module accum_buf#(
    parameter   DEPTH   = 256,
    parameter   BATCH   = 32,
    parameter   RAM_TYPE= "block",
    parameter   ADDR_W  = bw(DEPTH)    // please do not change this parameter
    )(
    input       clk,
    input       rst,
    
    input       switch,
    
    // accumulation port
    input   [BATCH  -1 : 0]                 accum_en,
    input   [BATCH  -1 : 0]                 accum_new,
    input   [ADDR_W -1 : 0]                 accum_addr,
    input   [BATCH  -1 : 0][RES_W   -1 : 0] accum_data,
    
    // load intermediate result port
    input   [ADDR_W -1 : 0]                 wr_addr,
    input   [BATCH  -1 : 0][DATA_W  -1 : 0] wr_data,
    input                                   wr_data_en,
    input   [BATCH  -1 : 0][TAIL_W  -1 : 0] wr_tail,
    input                                   wr_tail_en,
    
    // store result port
    input   [ADDR_W -1 : 0]                 rd_addr,
    output  [BATCH  -1 : 0][RES_W   -1 : 0] rd_data,
    input   rd_en
    );
    
    // address and enable signal delay to sync with ram read delay
    wire    [5  -1 : 0][ADDR_W  -1 : 0] accum_addr_d;
    wire    [5  -1 : 0][BATCH   -1 : 0] accum_en_d;
    wire    [4  -1 : 0][BATCH   -1 : 0] accum_new_d;
    
    Q#(.DW(ADDR_W), .L(5)) accum_addr_q (.*, .s(accum_addr), .d(accum_addr_d));
    RQ#(.DW(BATCH), .L(5)) accum_en_q   (.*, .s(accum_en  ), .d(accum_en_d  ));
    RQ#(.DW(BATCH), .L(4)) accum_new_q  (.*, .s(accum_new ), .d(accum_new_d ));
    
    reg     [BATCH  -1 : 0][RES_W   -1 : 0] accum_res_r;
    wire    [BATCH  -1 : 0][DATA_W  -1 : 0] accum_wr_data;
    wire    [BATCH  -1 : 0][TAIL_W  -1 : 0] accum_wr_tail; 
    wire    [BATCH  -1 : 0][RES_W   -1 : 0] accum_rd_pack;
    wire    [BATCH  -1 : 0][DATA_W  -1 : 0] accum_rd_data;
    wire    [BATCH  -1 : 0][TAIL_W  -1 : 0] accum_rd_tail;
    
    wire    [BATCH  -1 : 0][DATA_W  -1 : 0] rd_msb;
    wire    [BATCH  -1 : 0][TAIL_W  -1 : 0] rd_lsb;
    
    genvar i;
    generate
        for (i = 0; i < BATCH; i = i + 1) begin: ACC_ARRAY
        
            assign  accum_rd_pack[i] = {accum_rd_data[i], accum_rd_tail[i]};
            assign  {accum_wr_data[i], accum_wr_tail[i]} = accum_res_r[i];
            
            wire    [RES_W  -1 : 0] op;
            
            assign  op = (accum_addr_d[4] == accum_addr_d[3]) ? accum_res_r[i] : accum_rd_pack[i];
            
            
            always @ (posedge clk) begin
                if (accum_en_d[3][i] && !accum_new_d[3][i]) begin
                    accum_res_r[i] <= accum_data[i] + op;
                end
                else begin
                    accum_res_r[i] <= accum_rd_pack[i];
                end
            end
            
            assign  rd_data[i] = {rd_msb[i], rd_lsb[i]};            
        
        end: ACC_ARRAY
    endgenerate
    
    dual_port_ping_pong_ram#(
        .DEPTH      (DEPTH          ),
        .WIDTH      (BATCH * DATA_W ),
        .RAM_TYPE   (RAM_TYPE       )
    ) data_buffer (
        .clk    (clk    ),
        .rst    (rst    ),
    
        .switch (switch ),
    
        // port A
        .a_wr_addr  (accum_addr_d[4]    ),
        .a_wr_data  (accum_wr_data      ),
        .a_wr_en    (accum_en_d[4] != 0 ),    
        .a_rd_addr  (accum_addr         ),
        .a_rd_data  (accum_rd_data      ),
        .a_rd_en    (1'b1               ),
    
        // port B
        .b_wr_addr  (wr_addr    ),
        .b_wr_data  (wr_data    ),
        .b_wr_en    (wr_data_en ),    
        .b_rd_addr  (rd_addr    ),
        .b_rd_data  (rd_msb     ),
        .b_rd_en    (rd_en      )
    );
    
    dual_port_ping_pong_ram#(
        .DEPTH      (DEPTH          ),
        .WIDTH      (BATCH * TAIL_W ),
        .RAM_TYPE   (RAM_TYPE       )
    ) tail_buffer (
        .clk    (clk    ),
        .rst    (rst    ),
    
        .switch (switch ),
    
        // port A
        .a_wr_addr  (accum_addr_d[4]    ),
        .a_wr_data  (accum_wr_tail      ),
        .a_wr_en    (accum_en_d[4] != 0 ),    
        .a_rd_addr  (accum_addr         ),
        .a_rd_data  (accum_rd_tail      ),
        .a_rd_en    (1'b1               ),
    
        // port B
        .b_wr_addr  (wr_addr    ),
        .b_wr_data  (wr_tail    ),
        .b_wr_en    (wr_tail_en ),    
        .b_rd_addr  (rd_addr    ),
        .b_rd_data  (rd_lsb     ),
        .b_rd_en    (rd_en      )
    );
    
endmodule