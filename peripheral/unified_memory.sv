import defs::*;

module unified_memory #(
    parameter MEM_CAPACITY = MEM_SIZE
) (
    input  logic    clk,
    /* Instruction port */
    input  addr_t   imem_addr_i,
    input  enable_t imem_ren_i,
    output data_t   imem_data_o,
    /* Data port */
    input  addr_t   dmem_addr_i,
    input  enable_t dmem_ren_i,
    output data_t   dmem_rdata_o,
    input  enable_t dmem_wen_i,
    input  data_t   dmem_wdata_i
);

    localparam BYTES = XLEN / 8;
    localparam ADDR_BITS = $clog2(MEM_CAPACITY);

    string        mem_file;
    byte unsigned mem      [0:MEM_CAPACITY-1];

    initial begin
        if (!$value$plusargs("IMEM=%s", mem_file))
            $display("Unified memory didn't load program file");
        if (mem_file != "") begin
            $display("[%m] load %s to unified memory", mem_file);
            $readmemh(mem_file, mem);
        end
    end

    bit [ADDR_BITS-1:0] offset_w;
    always_ff @(posedge clk) begin
        if (dmem_wen_i) begin
            for (offset_w = 0; offset_w < BYTES; offset_w++) begin
                mem[dmem_addr_i[ADDR_BITS-1:0]+offset_w] <= dmem_wdata_i[8*offset_w+:8];
            end
        end
    end

    bit [ADDR_BITS-1:0] offset_r;
    always_comb begin
        imem_data_o  = '0;
        dmem_rdata_o = '0;
        if (imem_ren_i) begin
            for (offset_r = 0; offset_r < BYTES; offset_r++) begin
                imem_data_o[8*offset_r+:8] = mem[imem_addr_i[ADDR_BITS-1:0]+offset_r];
            end
        end
        if (dmem_ren_i) begin
            for (offset_r = 0; offset_r < BYTES; offset_r++) begin
                dmem_rdata_o[8*offset_r+:8] = mem[dmem_addr_i[ADDR_BITS-1:0]+offset_r];
            end
        end
    end

endmodule
