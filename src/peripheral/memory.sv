import defs::*;

module memory (
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

    localparam ADDR_BITS = $clog2(MEM_SIZE);
    localparam ADDR_TOP_BIT = ADDR_BITS + ADDR_SHIFT - 1;
    localparam ADDR_BOTTOM_BIT = ADDR_SHIFT;

    string mem_file;
    data_t mem      [0:MEM_SIZE-1];

    initial begin
        if (!$value$plusargs("IMEM=%s", mem_file))
            $display("Unified memory didn't load program file");
        if (mem_file != "") begin
            $display("[%m] load %s to unified memory", mem_file);
            $readmemh(mem_file, mem);
        end
    end

    /* effective address */
    logic [ADDR_BITS-1:0] imem_addr;
    logic [ADDR_BITS-1:0] dmem_addr;
    assign imem_addr = imem_addr_i[ADDR_TOP_BIT:ADDR_BOTTOM_BIT];
    assign dmem_addr = dmem_addr_i[ADDR_TOP_BIT:ADDR_BOTTOM_BIT];

    always_comb begin
        imem_data_o  = '0;
        dmem_rdata_o = '0;
        if (imem_ren_i) begin
            imem_data_o = mem[imem_addr];
        end
        if (dmem_ren_i) begin
            dmem_rdata_o = mem[dmem_addr];
        end
    end

    always_ff @(posedge clk) begin
        if (dmem_wen_i) begin
            mem[dmem_addr] <= dmem_wdata_i;
        end
    end

endmodule
