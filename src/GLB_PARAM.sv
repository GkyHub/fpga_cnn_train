/*
    parameter package with global parameters and functions
*/

package GLOBAL_PARAM;

    localparam  DATA_W  = 8;    // neuron and weight bitwidth
    
    localparam  RES_W   = 32;   // intermediate result bitwidth
                                // gradient buffer bitwidth
                                
    localparam  TAIL_W  = RES_W - DATA_W;
                                
    localparam  IDX_W   = 4;    // sparse unit index bitwidth
    
    localparam  BATCH   = 32;   // hardware batch size
    
    localparam  DDR_W   = 256;
    
    localparam  DDR_ADDR_W  = 32;
    
    localparam  BURST_W     = 16;
    
    // calculate the bitwidth for representing number less than depth
    function integer bw;
        input integer depth;
        
        depth = depth - 1;
        
        for (bw=0; depth>0; bw=bw+1)
            depth = depth >> 1;
    endfunction
    
endpackage