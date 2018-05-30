import  GLOBAL_PARAM::bw;

module short_fifo#(
    parameter   DATA_W  = 16,
    parameter   DEPTH   = 16
    )(
    input   clk,
    input   rst,

    input   [DATA_W -1 : 0] wr_data,
    input                   wr_valid,
    output                  wr_ready,

    output  [DATA_W -1 : 0] rd_data,
    input                   rd_ready,
    output                  rd_valid
    );

    localparam PTR_W = bw(DEPTH);

    reg     [PTR_W  -1 : 0] wr_ptr_r;
    reg     [PTR_W  -1 : 0] rd_ptr_r;
    reg     [DATA_W -1 : 0] ram[DEPTH];

    reg     wr_ready_r, rd_valid_r;
    wire    valid_rd_trans, valid_wr_trans;

    assign  valid_rd_trans = rd_valid_r && rd_ready;
    assign  valid_wr_trans = wr_ready_r && wr_valid;

    // write pointer logic
    always @ (posedge clk) begin
        if (rst) begin
            wr_ptr_r <= 0;
        end
        else if (valid_wr_trans) begin
            wr_ptr_r <= wr_ptr_r + 1;
        end
    end

    // read pointer logic
    always @ (posedge clk) begin
        if (rst) begin
            rd_ptr_r <= 0;
        end
        else if (valid_rd_trans) begin
            rd_ptr_r <= rd_ptr_r + 1;
        end
    end

    // write ready logic
    always @ (posedge clk) begin
        if (rst) begin
            wr_ready_r <= 1'b1;
        end
        else begin
            case({valid_wr_trans, valid_rd_trans})
            2'b01: // read
                wr_ready_r <= 1'b1;
            2'b10: // write
                if (rd_ptr_r == (wr_ptr_r + 1)) begin
                    wr_ready_r <= 1'b0;
                end
            default: // nothing happens
                wr_ready_r <= wr_ready_r;
            endcase
        end
    end

    // read ready logic
    always @ (posedge clk) begin
        if (rst) begin
            rd_valid_r <= 1'b0;
        end
        else begin
            case({valid_wr_trans, valid_rd_trans})
            2'b01: // read
                if (rd_ptr_r == (wr_ptr_r - 1)) begin
                    rd_valid_r <= 1'b0;
                end
            2'b10: // write
                rd_valid_r <= 1'b1;
            default: // nothing happens
                rd_valid_r <= rd_valid_r;
            endcase
        end
    end

    // ram
    always @ (posedge clk) begin
        if (valid_wr_trans) begin
            ram[wr_ptr_r] <= wr_data;
        end
    end

    assign  rd_data = ram[rd_ptr_r];
    assign  rd_valid = rd_valid_r;
    assign  wr_ready = wr_ready_r;

endmodule