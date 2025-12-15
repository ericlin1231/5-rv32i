module axi_cpu_wrapper (
    input logic ACLK,
    input logic ARESETn,

    /****** Master 0 attach to imem ******/
    // read address channel
    output logic [  AXI_ADDR_BITS-1:0] ARADDR_M0,
    output logic                       ARVALID_M0,
    input  logic                       ARREADY_M0,
    /* read data channel */
    input  logic [  AXI_DATA_BITS-1:0] RDATA_M0,
    input  logic [                1:0] RRESP_M0,
    input  logic                       RVALID_M0,
    output logic                       RREADY_M0,
    /* write address channel */
    output logic [  AXI_ADDR_BITS-1:0] AWADDR_M0,
    output logic                       AWVALID_M0,
    input  logic                       AWREADY_M0,
    /* write data channel */
    output logic [  AXI_DATA_BITS-1:0] WDATA_M0,
    output logic [AXI_DATA_BITS/8-1:0] WSTRB_M0,
    output logic                       WVALID_M0,
    input  logic                       WREADY_M0,
    /* write response channel */
    input  logic [                1:0] BRESP_M0,
    input  logic                       BVALID_M0,
    output logic                       BREADY_M0,

    /****** Master 1 attach to dmem ******/
    // read address channel
    output logic [  AXI_ADDR_BITS-1:0] ARADDR_M1,
    output logic                       ARVALID_M1,
    input  logic                       ARREADY_M1,
    /* read data channel */
    input  logic [  AXI_DATA_BITS-1:0] RDATA_M1,
    input  logic [                1:0] RRESP_M1,
    input  logic                       RVALID_M1,
    output logic                       RREADY_M1,
    /* write address channel */
    output logic [  AXI_ADDR_BITS-1:0] AWADDR_M1,
    output logic                       AWVALID_M1,
    input  logic                       AWREADY_M1,
    /* write data channel */
    output logic [  AXI_DATA_BITS-1:0] WDATA_M1,
    output logic [AXI_DATA_BITS/8-1:0] WSTRB_M1,
    output logic                       WVALID_M1,
    input  logic                       WREADY_M1,
    /* write response channel */
    input  logic [                1:0] BRESP_M1,
    input  logic                       BVALID_M1,
    output logic                       BREADY_M1
);

    enable_t                       global_stall_c;
    /* Master 0 port */
    logic    [  AXI_ADDR_BITS-1:0] imem_addr;
    logic                          imem_ren;
    logic    [  AXI_DATA_BITS-1:0] imem_rdata;
    /* Master 1 port */
    logic    [  AXI_ADDR_BITS-1:0] dmem_addr;
    logic                          dmem_ren;
    logic    [  AXI_DATA_BITS-1:0] dmem_rdata;
    logic                          dmem_wen;
    logic    [AXI_DATA_BITS/8-1:0] dmem_wstrb;
    logic    [  AXI_DATA_BITS-1:0] dmem_wdata;
    cpu core_0 (
        .clk             (ACLK),
        .rst_n           (ARESETn),
        .global_stall_c_i(global_stall_c),

        /* Master 0 signal */
        .imem_addr_o(imem_addr),
        .imem_ren_o (imem_ren),
        .imem_data_i(imem_rdata),

        /* Master 1 signal */
        .dmem_addr_o      (dmem_addr),
        .dmem_ren_o       (dmem_ren),
        .dmem_read_data_i (dmem_rdata),
        .dmem_wen_o       (dmem_wen),
        .dmem_wstrb_o     (dmem_wstrb),
        .dmem_write_data_o(dmem_wdata)
    );


endmodule
