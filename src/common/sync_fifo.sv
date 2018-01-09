module sync_fifo#(
    parameter   DATA_W  = 8,        // fifo width
    parameter   DEPTH   = 16,       // fifo depth (additonal register increase this depth by 1)
    parameter   AF_TH   = 10,       // almost full assert if data in fifo reach TH
                                    // > 0 && < depth
    parameter   TYPE    = "block"   // RAM type
    )(
    input   clk,
    input   rst,
    
    input   [DATA_W -1 : 0] wr_data,
    input                   wr_en,
    output                  full,
    output                  afull,  // almost full
    
    output  [DATA_W -1 : 0] rd_data,
    input                   rd_en,
    output                  empty
    );
    
    localparam  ADDR_W  = bw(DEPTH);
    
    reg     [ADDR_W -1 : 0] rd_addr_r;
    reg     [ADDR_W -1 : 0] wr_addr_r;
    reg     [ADDR_W    : 0] size_r;     // number of data in FIFO
    reg     [DATA_W -1 : 0] rd_data_r;
    
    reg     full_r, afull_r, empty_r;
    
    wire    push_data = wr_en && !full_r;
    wire    pop_data  = rd_en && !empty_r;
    
    always @ (posedge clk) begin
        if (rst) begin
            wr_addr_r   <= 0;
        end
        else if (wr_en && !full && size_r > 0) begin
            if (wr_addr_r == DEPTH - 1) begin
                wr_addr_r <= 0;
            end
            else begin
                wr_addr_r <= wr_addr_r + 1;
            end
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            rd_addr_r   <= 0;
        end
        else if (rd_en && !empty && size_r > 0) begin
            if (rd_addr_r == DEPTH - 1) begin
                rd_addr_r <= 0;
            end
            else begin
                rd_addr_r <= rd_addr_r + 1;
            end
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            size_r  <= 0;
        end
        else begin
            case({push_data, pop_data})
            2'b01: size_r <= size_r - 1;
            2'b10: size_r <= size_r + 1;
            default: size_r <= size_r;
            endcase
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            full_r <= 1'b0;
        end
        else if (size_r == DEPTH - 1 && wr_en && !rd_en) begin
            full_r <= 1'b1;
        end
        else if (size_r == DEPTH && rd_en) begin
            full_r <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            empty_r <= 1'b1;
        end
        else if (size_r == 1 && rd_en && !wr_en) begin
            empty_r <= 1'b1;
        end
        else if (size_r == 0 && wr_en) begin
            empty_r <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            afull_r <= 1'b0;
        end
        else begin
            if (size_r == TH - 1 && wr_en && !rd_en) begin
                afull_r <= 1'b1;
            end
            else if (size_r == TH && rd_en && !wr_en) begin
                afull_r <= 1'b0;
            end
        end
    end
        
    generate
        if (TYPE == "block") begin: BLOCK_RAM
            (* ram_style = "block" *)
            reg [DATA_W -1 : 0] ram[DEPTH];
            
            always @ (posedge clk) begin
                
            end
            
        end
        else if (TYPE == "distributed") begin: DIST_RAM
        
        end
        else begin: AUTO_RAM
            
        end
    endgenerate
    
    assign  full    = full_r;
    assign  afull   = afull_r;
    assign  empty   = empty_r;
    
endmodule