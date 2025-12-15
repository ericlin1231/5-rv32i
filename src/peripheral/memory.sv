module memory (
    input  logic          clk,
    /* Instruction port connect to Master 0 */
    input  addr_t         imem_addr_i,
    input  enable_t       imem_ren_i,
    output data_t         imem_data_o,
    /* Data port connect to Master 1 */
    input  addr_t         dmem_addr_i,
    input  enable_t       dmem_ren_i,
    output data_t         dmem_rdata_o,
    input  enable_t       dmem_wen_i,
    input  logic    [3:0] dmem_wstrb_i,
    input  data_t         dmem_wdata_i
);

    localparam ADDR_BITS = $clog2(MEM_SIZE);
    localparam ADDR_MSB = ADDR_BITS + ADDR_SHIFT - 1;
    localparam ADDR_LSB = ADDR_SHIFT;

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
    assign imem_addr = imem_addr_i[ADDR_MSB:ADDR_LSB];
    assign dmem_addr = dmem_addr_i[ADDR_MSB:ADDR_LSB];
    /* word aligned access assertion */
    // always_comb begin
    //     assert (imem_addr_i[1:0] == 2'b00)
    //     else $fatal("imem addr not aligned: %h", imem_addr_i);
    //     assert (dmem_addr_i[1:0] == 2'b00)
    //     else $fatal("dmem addr not aligned: %h", dmem_addr_i);

    //     assert (imem_addr_i[31:ADDR_MSB+1] == '0)
    //     else $fatal("imem addr OOR: %h", imem_addr_i);
    //     assert (dmem_addr_i[31:ADDR_MSB+1] == '0)
    //     else $fatal("dmem addr OOR: %h", dmem_addr_i);
    // end


    always_ff @(posedge clk) begin
        if (imem_ren_i) imem_data_o <= mem[imem_addr];
        if (dmem_ren_i) dmem_rdata_o <= mem[dmem_addr];
    end

    data_t wdata_mask;
    assign wdata_mask = {
        {8{dmem_wstrb_i[3]}}, {8{dmem_wstrb_i[2]}}, {8{dmem_wstrb_i[1]}}, {8{dmem_wstrb_i[0]}}
    };
    always_ff @(posedge clk) begin
        if (dmem_wen_i) begin
            mem[dmem_addr] <= (mem[dmem_addr] & ~wdata_mask) | (dmem_wdata_i & wdata_mask);
        end
    end

endmodule
