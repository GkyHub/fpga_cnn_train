
//  Xilinx Simple Dual Port Single Clock RAM
//  This code implements a parameterizable SDP single clock memory.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.

import GLOBAL_PARAM::bw;

module sdp_sync_ram #(
    parameter NB_COL            = 8,                    // Specify number of columns (number of bytes)
    parameter COL_WIDTH         = 8,                    // Specify column width (byte width, typically 8 or 9)
    parameter RAM_DEPTH         = 512,                  // Specify RAM depth (number of entries)
    parameter RAM_PERFORMANCE   = "HIGH_PERFORMANCE",   // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" '
    parameter RAM_TYPE          = "block",              // "auto" / "block" / "distributed" 
    parameter INIT_FILE         = ""                    // Specify name/location of RAM initialization file if using one (leave blank if not)
    )(
    input   [bw(RAM_DEPTH)      -1 : 0] addra,  // Write address bus, width determined from RAM_DEPTH
    input   [bw(RAM_DEPTH)      -1 : 0] addrb,  // Read address bus, width determined from RAM_DEPTH
    input   [(NB_COL*COL_WIDTH) -1 : 0] dina,   // RAM input data
    input                               clka,   // Clock
    input   [NB_COL             -1 : 0] wea,    // Byte-write enable
    input                               enb,    // Read Enable, for additional power savings, disable when not in use
    input                               rstb,   // Output reset (does not affect memory contents)
    output  [(NB_COL*COL_WIDTH) -1 : 0] doutb   // RAM output data
    );

    reg [(NB_COL*COL_WIDTH)-1:0] ram_data = {(NB_COL*COL_WIDTH){1'b0}};

    integer ram_index;
    genvar i;
    
    // generate ram according to RAM_TYPE
    // only the synthesis attribute is changed in these generate if blocks
    generate
        if (RAM_TYPE == "block") begin: BLOCK_RAM
            (* ram_style= "block" *) reg [(NB_COL*COL_WIDTH)-1:0] BRAM [RAM_DEPTH-1:0];
            
            if (INIT_FILE != "") begin: use_init_file
                initial
                    $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
            end 
            else begin: init_bram_to_zero
                initial
                    for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
                        BRAM[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
            end
            
            always @(posedge clka) begin
                if (enb) begin
                    ram_data <= BRAM[addrb];
                end
            end
            
            for (i = 0; i < NB_COL; i = i+1) begin: byte_write
                always @(posedge clka) begin
                    if (wea[i])
                        BRAM[addra][i*COL_WIDTH +: COL_WIDTH] <= dina[i*COL_WIDTH +: COL_WIDTH];
                end
            end
            
        end
        
        else if (RAM_TYPE == "distributed") begin: DIST_RAM
            (* ram_style= "distributed" *) reg [(NB_COL*COL_WIDTH)-1:0] BRAM [RAM_DEPTH-1:0];
            
            if (INIT_FILE != "") begin: use_init_file
                initial
                    $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
            end 
            else begin: init_bram_to_zero
                initial
                    for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
                        BRAM[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
            end
            
            always @(posedge clka) begin
                if (enb) begin
                    ram_data <= BRAM[addrb];
                end
            end
            
            for (i = 0; i < NB_COL; i = i+1) begin: byte_write
                always @(posedge clka) begin
                    if (wea[i])
                        BRAM[addra][i*COL_WIDTH +: COL_WIDTH] <= dina[i*COL_WIDTH +: COL_WIDTH];
                end
            end
        end
        
        else begin: AUTO_RAM
            reg [(NB_COL*COL_WIDTH)-1:0] BRAM [RAM_DEPTH-1:0];
            
            if (INIT_FILE != "") begin: use_init_file
                initial
                    $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
            end 
            else begin: init_bram_to_zero
                initial
                    for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
                        BRAM[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
            end
            
            always @(posedge clka) begin
                if (enb) begin
                    ram_data <= BRAM[addrb];
                end
            end
            
            for (i = 0; i < NB_COL; i = i+1) begin: byte_write
                always @(posedge clka) begin
                    if (wea[i])
                        BRAM[addra][i*COL_WIDTH +: COL_WIDTH] <= dina[i*COL_WIDTH +: COL_WIDTH];
                end
            end
        end
    endgenerate

    //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
    generate
        if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register
        
            // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
            assign doutb = ram_data;
        
        end else begin: output_register
        
            // The following is a 2 clock cycle read latency with improve clock-to-out timing        
            reg [(NB_COL*COL_WIDTH)-1:0] doutb_reg = {(NB_COL*COL_WIDTH){1'b0}};
        
            always @(posedge clka) begin
                if (rstb)
                    doutb_reg <= {(NB_COL*COL_WIDTH){1'b0}};
                else if (enb)
                    doutb_reg <= ram_data;
            end
        
            assign doutb = doutb_reg;
        
        end
    endgenerate

endmodule
