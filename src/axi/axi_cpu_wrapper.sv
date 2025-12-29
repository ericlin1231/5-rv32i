module axi_cpu_wrapper
  import CPU_profile::*;
  import AXI_define::*;
  import tracer::*;
(
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

  logic global_stall_en;
  logic [XLEN-1:0] imem_addr;
  logic imem_ren;
  logic [XLEN-1:0] imem_rdata;
  logic [XLEN-1:0] dmem_addr;
  logic dmem_ren;
  logic [XLEN-1:0] dmem_rdata;
  logic dmem_wen;
  logic [AXI_DATA_BITS/8-1:0] dmem_wstrb;
  logic [XLEN-1:0] dmem_wdata;

  logic imem_raddr_handshake;
  logic imem_rdata_handshake;
  logic dmem_raddr_handshake;
  logic dmem_rdata_handshake;
  logic dmem_waddr_handshake;
  logic dmem_wdata_handshake;
  assign imem_raddr_handshake = (ARVALID_M0 && ARREADY_M0);
  assign imem_rdata_handshake = (RVALID_M0 && RREADY_M0);
  assign dmem_raddr_handshake = (ARVALID_M1 && ARREADY_M1);
  assign dmem_rdata_handshake = (RVALID_M1 && RREADY_M1);
  assign dmem_waddr_handshake = (AWVALID_M1 && AWREADY_M1);
  assign dmem_wdata_handshake = (WVALID_M1 && WREADY_M1);

  logic imem_read_pending;
  logic dmem_read_pending;
  logic dmem_write_pending;

`ifdef TRACE
  tracer_axi_t imem_trace;
  tracer_bus_t if_trace;
  tracer_bus_t id_trace;
  tracer_bus_t ex_trace;
  tracer_bus_t mem_trace;
  tracer_bus_t wb_trace;

  Debug debug_core_0 (
      .ACLK(ACLK),
      .imem_trace(imem_trace),
      .if_trace(if_trace),
      .id_trace(id_trace),
      .ex_trace(ex_trace),
      .mem_trace(mem_trace),
      .wb_trace(wb_trace)
  );

  assign imem_trace.rdata = RDATA_M0;
`endif

  cpu core_0 (
      .ACLK(ACLK),
      .ARESETn(ARESETn),
      .global_stall_en(global_stall_en),

      /********** IMEM Master 0 Interface **************/
      .imem_addr(imem_addr),
      .imem_ren(imem_ren),
      .imem_rdata(imem_rdata),
      .imem_raddr_handshake(imem_raddr_handshake),
      .imem_rdata_handshake(imem_rdata_handshake),

      /********** DMEM Master 1 Interface **************/
      .dmem_addr (dmem_addr),
      .dmem_ren  (dmem_ren),
      .dmem_rdata(dmem_rdata),
      .dmem_wen  (dmem_wen),
      .dmem_wstrb(dmem_wstrb),
      .dmem_wdata(dmem_wdata)

      /********** pipeline signal trace output ***********/
`ifdef TRACE,
      .if_trace (if_trace),
      .id_trace (id_trace),
      .ex_trace (ex_trace),
      .mem_trace(mem_trace),
      .wb_trace (wb_trace)
`endif
  );

  /* Master 0 read IMEM */
  logic [AXI_ADDR_BITS-1:0] araddr_M0;
  logic                     arvalid_M0;
  logic                     rready_M0;
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      araddr_M0         <= '0;
      arvalid_M0        <= 1'b0;
      rready_M0         <= 1'b0;
      imem_rdata        <= '0;
      imem_read_pending <= 1'b0;
    end else begin
      /* always ready */
      rready_M0 <= 1'b1;

      /* launch read request */
      if (!imem_read_pending && imem_ren) begin
        araddr_M0  <= imem_addr;
        arvalid_M0 <= 1'b1;
      end
      /* read address handshake */
      if (ARVALID_M0 && ARREADY_M0) begin
        arvalid_M0        <= 1'b0;
        imem_read_pending <= 1'b1;
      end
      /* response accepted */
      if (RVALID_M0 && RREADY_M0) begin
        imem_read_pending <= 1'b0;
        if (RRESP_M0 == AXI_RESP_OKAY) imem_rdata <= RDATA_M0;
      end
    end
  end
  assign ARADDR_M0  = araddr_M0;
  assign ARVALID_M0 = arvalid_M0;
  assign RREADY_M0  = rready_M0;

  /*----------------------- Data port (Master 1) -----------------------*/
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      ARVALID_M1        <= 1'b0;
      ARADDR_M1         <= '0;
      dmem_read_pending <= 1'b0;
    end else begin
      if (!dmem_read_pending && dmem_ren) begin
        ARVALID_M1 <= 1'b1;
        ARADDR_M1  <= dmem_addr;
      end
      if (ARVALID_M1 && ARREADY_M1) begin
        ARVALID_M1        <= 1'b0;
        dmem_read_pending <= 1'b1;
      end
      if (RVALID_M1 && RREADY_M1) begin
        dmem_read_pending <= 1'b0;
      end
    end
  end

  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      RREADY_M1  <= 1'b0;
      dmem_rdata <= '0;
    end else begin
      RREADY_M1 <= 1'b1;
      if (RVALID_M1 && RREADY_M1 && RRESP_M1 == AXI_RESP_OKAY) begin
        dmem_rdata <= RDATA_M1;
      end
    end
  end

  /* while AXI read next instruction
   * need 4 cycle to fetch
   * AXI write transaction only need 3 cycle
   * block dmem write port to prevent double write
   */
  logic dmem_write_block;
  assign dmem_write_block = (AWADDR_M1 == dmem_addr && WDATA_M1 == dmem_wdata);

  /* write address + data */
  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      AWVALID_M1         <= 1'b0;
      WVALID_M1          <= 1'b0;
      AWADDR_M1          <= '0;
      WDATA_M1           <= '0;
      WSTRB_M1           <= '0;
      dmem_write_pending <= 1'b0;
    end else begin
      if (!dmem_write_pending && dmem_wen && !dmem_write_block) begin
        AWVALID_M1 <= 1'b1;
        WVALID_M1  <= 1'b1;
        AWADDR_M1  <= dmem_addr;
        WDATA_M1   <= dmem_wdata;
        WSTRB_M1   <= dmem_wstrb;
      end

      if (AWVALID_M1 && AWREADY_M1) begin
        AWVALID_M1 <= 1'b0;
      end
      if (WVALID_M1 && WREADY_M1) begin
        WVALID_M1 <= 1'b0;
      end

      if ((AWVALID_M1 && AWREADY_M1) || (WVALID_M1 && WREADY_M1)) begin
        dmem_write_pending <= 1'b1;
      end
      if (BVALID_M1 && BREADY_M1) begin
        dmem_write_pending <= 1'b0;
      end
    end
  end

  always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
      BREADY_M1 <= 1'b0;
    end else begin
      BREADY_M1 <= 1'b1;
    end
  end

  /* AXI master 0 write channel unused */
  always_comb begin
    AWADDR_M0  = '0;
    AWVALID_M0 = 1'b0;
    WDATA_M0   = '0;
    WSTRB_M0   = '0;
    WVALID_M0  = 1'b0;
    BREADY_M0  = 1'b1;
  end

  /* global stall when new instruction hasn't coming */
  always_comb begin
    global_stall_en = !imem_raddr_handshake;
  end


endmodule
