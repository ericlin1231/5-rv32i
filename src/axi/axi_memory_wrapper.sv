module axi_memory_wrapper (
    input logic ACLK,
    input logic ARESETn,

    /****** slave 0 attach to imem ******/
    // read addresse channel
    input  logic [  AXI_ADDR_BITS-1:0] ARADDR_S0,
    input  logic                       ARVALID_S0,
    output logic                       ARREADY_S0,
    /* read data channel */
    output logic [  AXI_DATA_BITS-1:0] RDATA_S0,
    output logic [                1:0] RRESP_S0,
    output logic                       RVALID_S0,
    input  logic                       RREADY_S0,
    /* write address channel */
    input  logic [  AXI_ADDR_BITS-1:0] AWADDR_S0,
    input  logic                       AWVALID_S0,
    output logic                       AWREADY_S0,
    /* write data channel */
    input  logic [  AXI_DATA_BITS-1:0] WDATA_S0,
    input  logic [AXI_DATA_BITS/8-1:0] WSTRB_S0,
    input  logic                       WVALID_S0,
    output logic                       WREADY_S0,
    /* write response channel */
    output logic [                1:0] BRESP_S0,
    output logic                       BVALID_S0,
    input  logic                       BREADY_S0,

    /****** slave 1 attach to dmem ******/
    // read addresse channel
    input  logic [  AXI_ADDR_BITS-1:0] ARADDR_S1,
    input  logic                       ARVALID_S1,
    output logic                       ARREADY_S1,
    /* read data channel */
    output logic [  AXI_DATA_BITS-1:0] RDATA_S1,
    output logic [                1:0] RRESP_S1,
    output logic                       RVALID_S1,
    input  logic                       RREADY_S1,
    /* write address channel */
    input  logic [  AXI_ADDR_BITS-1:0] AWADDR_S1,
    input  logic                       AWVALID_S1,
    output logic                       AWREADY_S1,
    /* write data channel */
    input  logic [  AXI_DATA_BITS-1:0] WDATA_S1,
    input  logic [AXI_DATA_BITS/8-1:0] WSTRB_S1,
    input  logic                       WVALID_S1,
    output logic                       WREADY_S1,
    /* write response channel */
    output logic [                1:0] BRESP_S1,
    output logic                       BVALID_S1,
    input  logic                       BREADY_S1
);

    /* slave 0 */
    logic [  AXI_ADDR_BITS-1:0] imem_addr;
    logic                       imem_ren;
    logic [  AXI_DATA_BITS-1:0] imem_data;
    /* slave 1 */
    logic [  AXI_ADDR_BITS-1:0] dmem_addr;
    logic                       dmem_ren;
    logic [  AXI_DATA_BITS-1:0] dmem_rdata;
    logic                       dmem_wen;
    logic [AXI_DATA_BITS/8-1:0] dmem_wstrb;
    logic [  AXI_DATA_BITS-1:0] dmem_wdata;

    memory mem0 (
        .clk  (ACLK),
        .rst_n(ARESETn),

        /* slave 0 port */
        .imem_addr_i(imem_addr),
        .imem_ren_i (imem_ren),
        .imem_data_o(imem_data),

        /* slave 1 port */
        .dmem_addr_i (dmem_addr),
        .dmem_ren_i  (dmem_ren),
        .dmem_rdata_o(dmem_rdata),
        .dmem_wen_i  (dmem_wen),
        .dmem_wstrb_i(dmem_wstrb),
        .dmem_wdata_i(dmem_wdata)
    );

endmodule
