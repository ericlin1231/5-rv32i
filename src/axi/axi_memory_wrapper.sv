import defs::*;

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

  logic [XLEN-1:0] imem_addr;
  logic imem_ren;
  logic [XLEN-1:0] imem_rdata;
  logic [XLEN-1:0] dmem_addr;
  logic imem_resp_valid;

  logic dmem_ren;
  logic [XLEN-1:0] dmem_rdata;
  logic dmem_wen;
  logic [AXI_DATA_BITS/8-1:0] dmem_wstrb;
  logic [XLEN-1:0] dmem_wdata;
  logic dmem_resp_valid;
  memory mem0 (
      .clk(ACLK),

      /********** IMEM slave 0 interface ***************/
      .imem_addr,
      .imem_ren,
      .imem_rdata,

      /********** DMEM slave 1 interface ***************/
      .dmem_addr,
      .dmem_ren,
      .dmem_rdata,
      .dmem_wen,
      .dmem_wstrb,
      .dmem_wdata
  );

  /*------------------------- Slave 0 (imem) -------------------------*/
  always_comb begin
    ARREADY_S0 = 1'b1;
    AWREADY_S0 = 1'b0;
    WREADY_S0  = 1'b0;
    BRESP_S0   = AXI_RESP_OKAY;
    BVALID_S0  = 1'b0;

    imem_addr  = ARADDR_S0;
  end

  assign imem_ren = ARVALID_S0 && ARREADY_S0;
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      imem_resp_valid <= 1'b0;
      RVALID_S0       <= 1'b0;
      RDATA_S0        <= '0;
      RRESP_S0        <= AXI_RESP_OKAY;
    end else begin
      imem_resp_valid <= imem_ren;

      if (imem_resp_valid) begin
        RDATA_S0  <= imem_rdata;
        RRESP_S0  <= AXI_RESP_OKAY;
        RVALID_S0 <= 1'b1;
      end else if (RVALID_S0 && RREADY_S0) begin
        RVALID_S0 <= 1'b0;
      end else if (RVALID_S0 && !RREADY_S0) begin
        RVALID_S0 <= RVALID_S0;
      end else begin
        RVALID_S0 <= 1'b0;
      end
    end
  end

  /*------------------------- Slave 1 (dmem) -------------------------*/
  always_comb begin
    ARREADY_S1 = 1'b1;
    AWREADY_S1 = 1'b1;
    WREADY_S1  = 1'b1;

    dmem_addr  = ARVALID_S1 ? ARADDR_S1 : AWADDR_S1;
    dmem_wdata = WDATA_S1;
    dmem_wstrb = WSTRB_S1;
    dmem_wen   = (AWVALID_S1 && AWREADY_S1 && WVALID_S1 && WREADY_S1);
  end

  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      dmem_ren        <= 1'b0;
      dmem_resp_valid <= 1'b0;
      RVALID_S1       <= 1'b0;
      RDATA_S1        <= '0;
      RRESP_S1        <= AXI_RESP_OKAY;
      BRESP_S1        <= AXI_RESP_OKAY;
      BVALID_S1       <= 1'b0;
    end else begin
      dmem_ren        <= ARVALID_S1 && ARREADY_S1;
      dmem_resp_valid <= dmem_ren;

      if (dmem_resp_valid) begin
        RDATA_S1  <= dmem_rdata;
        RRESP_S1  <= AXI_RESP_OKAY;
        RVALID_S1 <= 1'b1;
      end else if (RVALID_S1 && RREADY_S1) begin
        RVALID_S1 <= 1'b0;
      end else if (RVALID_S1 && !RREADY_S1) begin
        RVALID_S1 <= RVALID_S1;
      end else begin
        RVALID_S1 <= 1'b0;
      end

      /* write response */
      if (dmem_wen) begin
        BRESP_S1  <= AXI_RESP_OKAY;
        BVALID_S1 <= 1'b1;
      end else if (BVALID_S1 && BREADY_S1) begin
        BVALID_S1 <= 1'b0;
      end
    end
  end

endmodule
