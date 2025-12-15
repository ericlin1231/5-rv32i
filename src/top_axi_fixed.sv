import defs::*;

module top_axi_fixed (
    input logic ACLK,
    input logic ARESETn
);

    axi_cpu_wrapper core_0 (
        .ACLK,
        .ARESETn,

        /****** Master 0 attach to imem ******/
        // read addresse channel
        .ARADDR_M0,
        .ARVALID_M0,
        .ARREADY_M0,
        /* read data channel */
        .RDATA_M0,
        .RRESP_M0,
        .RVALID_M0,
        .RREADY_M0,
        /* write address channel */
        .AWADDR_M0,
        .AWVALID_M0,
        .AWREADY_M0,
        /* write data channel */
        .WDATA_M0,
        .WSTRB_M0,
        .WVALID_M0,
        .WREADY_M0,
        /* write response channel */
        .BRESP_M0,
        .BVALID_M0,
        .BREADY_M0,

        /****** Master 1 attach to dmem ******/
        // read addresse channel
        .ARADDR_M1,
        .ARVALID_M1,
        .ARREADY_M1,
        /* read data channel */
        .RDATA_M1,
        .RRESP_M1,
        .RVALID_M1,
        .RREADY_M1,
        /* write address channel */
        .AWADDR_M1,
        .AWVALID_M1,
        .AWREADY_M1,
        /* write data channel */
        .WDATA_M1,
        .WSTRB_M1,
        .WVALID_M1,
        .WREADY_M1,
        /* write response channel */
        .BRESP_M1,
        .BVALID_M1,
        .BREADY_M1
    );

    axi_memory_wrapper_fixed mem0 (
        .ACLK,
        .ARESETn,

        /****** slave 0 attach to imem ******/
        // read addresse channel
        .ARADDR_S0,
        .ARVALID_S0,
        .ARREADY_S0,
        /* read data channel */
        .RDATA_S0,
        .RRESP_S0,
        .RVALID_S0,
        .RREADY_S0,
        /* write address channel */
        .AWADDR_S0,
        .AWVALID_S0,
        .AWREADY_S0,
        /* write data channel */
        .WDATA_S0,
        .WSTRB_S0,
        .WVALID_S0,
        .WREADY_S0,
        /* write response channel */
        .BRESP_S0,
        .BVALID_S0,
        .BREADY_S0,

        /****** slave 1 attach to dmem ******/
        // read addresse channel
        .ARADDR_S1,
        .ARVALID_S1,
        .ARREADY_S1,
        /* read data channel */
        .RDATA_S1,
        .RRESP_S1,
        .RVALID_S1,
        .RREADY_S1,
        /* write address channel */
        .AWADDR_S1,
        .AWVALID_S1,
        .AWREADY_S1,
        /* write data channel */
        .WDATA_S1,
        .WSTRB_S1,
        .WVALID_S1,
        .WREADY_S1,
        /* write response channel */
        .BRESP_S1,
        .BVALID_S1,
        .BREADY_S1
    );

    axi_bridge AXI (
        .ACLK,
        .ARESETn,

        /****** Master 0 attach to imem ******/
        // read addresse channel
        .ARADDR_M0,
        .ARVALID_M0,
        .ARREADY_M0,
        /* read data channel */
        .RDATA_M0,
        .RRESP_M0,
        .RVALID_M0,
        .RREADY_M0,
        /* write address channel */
        .AWADDR_M0,
        .AWVALID_M0,
        .AWREADY_M0,
        /* write data channel */
        .WDATA_M0,
        .WSTRB_M0,
        .WVALID_M0,
        .WREADY_M0,
        /* write response channel */
        .BRESP_M0,
        .BVALID_M0,
        .BREADY_M0,

        /****** Master 1 attach to dmem ******/
        // read addresse channel
        .ARADDR_M1,
        .ARVALID_M1,
        .ARREADY_M1,
        /* read data channel */
        .RDATA_M1,
        .RRESP_M1,
        .RVALID_M1,
        .RREADY_M1,
        /* write address channel */
        .AWADDR_M1,
        .AWVALID_M1,
        .AWREADY_M1,
        /* write data channel */
        .WDATA_M1,
        .WSTRB_M1,
        .WVALID_M1,
        .WREADY_M1,
        /* write response channel */
        .BRESP_M1,
        .BVALID_M1,
        .BREADY_M1,


        /****** slave 0 attach to imem ******/
        // read addresse channel
        .ARADDR_S0,
        .ARVALID_S0,
        .ARREADY_S0,
        /* read data channel */
        .RDATA_S0,
        .RRESP_S0,
        .RVALID_S0,
        .RREADY_S0,
        /* write address channel */
        .AWADDR_S0,
        .AWVALID_S0,
        .AWREADY_S0,
        /* write data channel */
        .WDATA_S0,
        .WSTRB_S0,
        .WVALID_S0,
        .WREADY_S0,
        /* write response channel */
        .BRESP_S0,
        .BVALID_S0,
        .BREADY_S0,

        /****** slave 1 attach to dmem ******/
        // read addresse channel
        .ARADDR_S1,
        .ARVALID_S1,
        .ARREADY_S1,
        /* read data channel */
        .RDATA_S1,
        .RRESP_S1,
        .RVALID_S1,
        .RREADY_S1,
        /* write address channel */
        .AWADDR_S1,
        .AWVALID_S1,
        .AWREADY_S1,
        /* write data channel */
        .WDATA_S1,
        .WSTRB_S1,
        .WVALID_S1,
        .WREADY_S1,
        /* write response channel */
        .BRESP_S1,
        .BVALID_S1,
        .BREADY_S1
    );

endmodule
