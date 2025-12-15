module axi_bridge (
    input logic ACLK,
    input logic ARESETn,

    /****** Master 0 attach to imem ******/
    // read addresse channel
    input  logic [  AXI_ADDR_BITS-1:0] ARADDR_M0,
    input  logic                       ARVALID_M0,
    output logic                       ARREADY_M0,
    /* read data channel */
    output logic [  AXI_DATA_BITS-1:0] RDATA_M0,
    output logic [                1:0] RRESP_M0,
    output logic                       RVALID_M0,
    input  logic                       RREADY_M0,
    /* write address channel */
    input  logic [  AXI_ADDR_BITS-1:0] AWADDR_M0,
    input  logic                       AWVALID_M0,
    output logic                       AWREADY_M0,
    /* write data channel */
    input  logic [  AXI_DATA_BITS-1:0] WDATA_M0,
    input  logic [AXI_DATA_BITS/8-1:0] WSTRB_M0,
    input  logic                       WVALID_M0,
    output logic                       WREADY_M0,
    /* write response channel */
    output logic [                1:0] BRESP_M0,
    output logic                       BVALID_M0,
    input  logic                       BREADY_M0,

    /****** Master 1 attach to dmem ******/
    // read addresse channel
    input  logic [  AXI_ADDR_BITS-1:0] ARADDR_M1,
    input  logic                       ARVALID_M1,
    output logic                       ARREADY_M1,
    /* read data channel */
    output logic [  AXI_DATA_BITS-1:0] RDATA_M1,
    output logic [                1:0] RRESP_M1,
    output logic                       RVALID_M1,
    input  logic                       RREADY_M1,
    /* write address channel */
    input  logic [  AXI_ADDR_BITS-1:0] AWADDR_M1,
    input  logic                       AWVALID_M1,
    output logic                       AWREADY_M1,
    /* write data channel */
    input  logic [  AXI_DATA_BITS-1:0] WDATA_M1,
    input  logic [AXI_DATA_BITS/8-1:0] WSTRB_M1,
    input  logic                       WVALID_M1,
    output logic                       WREADY_M1,
    /* write response channel */
    output logic [                1:0] BRESP_M1,
    output logic                       BVALID_M1,
    input  logic                       BREADY_M1,


    /****** slave 0 attach to imem ******/
    // read addresse channel
    output logic [  AXI_ADDR_BITS-1:0] ARADDR_S0,
    output logic                       ARVALID_S0,
    input  logic                       ARREADY_S0,
    /* read data channel */
    input  logic [  AXI_DATA_BITS-1:0] RDATA_S0,
    input  logic [                1:0] RRESP_S0,
    input  logic                       RVALID_S0,
    output logic                       RREADY_S0,
    /* write address channel */
    output logic [  AXI_ADDR_BITS-1:0] AWADDR_S0,
    output logic                       AWVALID_S0,
    input  logic                       AWREADY_S0,
    /* write data channel */
    output logic [  AXI_DATA_BITS-1:0] WDATA_S0,
    output logic [AXI_DATA_BITS/8-1:0] WSTRB_S0,
    output logic                       WVALID_S0,
    input  logic                       WREADY_S0,
    /* write response channel */
    input  logic [                1:0] BRESP_S0,
    input  logic                       BVALID_S0,
    output logic                       BREADY_S0,

    /****** slave 1 attach to dmem ******/
    // read addresse channel
    output logic [  AXI_ADDR_BITS-1:0] ARADDR_S1,
    output logic                       ARVALID_S1,
    input  logic                       ARREADY_S1,
    /* read data channel */
    input  logic [  AXI_DATA_BITS-1:0] RDATA_S1,
    input  logic [                1:0] RRESP_S1,
    input  logic                       RVALID_S1,
    output logic                       RREADY_S1,
    /* write address channel */
    output logic [  AXI_ADDR_BITS-1:0] AWADDR_S1,
    output logic                       AWVALID_S1,
    input  logic                       AWREADY_S1,
    /* write data channel */
    output logic [  AXI_DATA_BITS-1:0] WDATA_S1,
    output logic [AXI_DATA_BITS/8-1:0] WSTRB_S1,
    output logic                       WVALID_S1,
    input  logic                       WREADY_S1,
    /* write response channel */
    input  logic [                1:0] BRESP_S1,
    input  logic                       BVALID_S1,
    output logic                       BREADY_S1
);

    /* Master and slave 0 */
    // read address channel
    assign ARADDR_S0  = ARADDR_M0;
    assign ARVALID_S0 = ARVALID_M0;
    assign ARREADY_M0 = ARREADY_S0;
    // read data channel
    assign RDATA_M0   = RDATA_S0;
    assign RRESP_M0   = RRESP_S0;
    assign RVALID_M0  = RVALID_S0;
    assign RREADY_S0  = RREADY_M0;
    // write address channel
    assign AWADDR_S0  = AWADDR_M0;
    assign AWVALID_S0 = AWVALID_M0;
    assign AWREADY_M0 = AWREADY_S0;
    // write data channel
    assign WDATA_S0   = WDATA_M0;
    assign WSTRB_S0   = WSTRB_M0;
    assign WVALID_S0  = WVALID_M0;
    assign WREADY_M0  = WREADY_S0;
    // write response channel
    assign BRESP_M0   = BRESP_S0;
    assign BVALID_M0  = BVALID_S0;
    assign BREADY_S0  = BREADY_M0;

    /* Master and slave 1 */
    // read address channel
    assign ARADDR_S1  = ARADDR_M1;
    assign ARVALID_S1 = ARVALID_M1;
    assign ARREADY_M1 = ARREADY_S1;
    // read data channel
    assign RDATA_M1   = RDATA_S1;
    assign RRESP_M1   = RRESP_S1;
    assign RVALID_M1  = RVALID_S1;
    assign RREADY_S1  = RREADY_M1;
    // write address channel
    assign AWADDR_S1  = AWADDR_M1;
    assign AWVALID_S1 = AWVALID_M1;
    assign AWREADY_M1 = AWREADY_S1;
    // write data channel
    assign WDATA_S1   = WDATA_M1;
    assign WSTRB_S1   = WSTRB_M1;
    assign WVALID_S1  = WVALID_M1;
    assign WREADY_M1  = WREADY_S1;
    // write response channel
    assign BRESP_M1   = BRESP_S1;
    assign BVALID_M1  = BVALID_S1;
    assign BREADY_S1  = BREADY_M1;

endmodule
