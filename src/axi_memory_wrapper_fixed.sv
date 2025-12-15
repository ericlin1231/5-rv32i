module axi_memory_wrapper (
    input logic ACLK,
    input logic ARESETn,

    /****** slave 0 attach to imem ******/
    // read address channel
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
    // read address channel
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

    /* Internal memory signals */
    addr_t                         imem_addr;
    enable_t                       imem_ren;
    data_t                         imem_data;

    addr_t                         dmem_addr;
    enable_t                       dmem_ren;
    data_t                         dmem_rdata;
    enable_t                       dmem_wen;
    logic    [AXI_DATA_BITS/8-1:0] dmem_wstrb;
    data_t                         dmem_wdata;

    /* -----------------------------
     * Slave 0 (IMEM) : Read-only AXI-Lite slave, sync-read memory
     * ----------------------------- */
    typedef enum logic [1:0] {
        S0_RD_IDLE,
        S0_RD_WAIT_DATA,
        S0_RD_RESP
    } s0_rd_state_e;
    s0_rd_state_e                     s0_rd_state;

    logic         [AXI_ADDR_BITS-1:0] s0_rd_addr_reg;
    logic                             s0_ren_pulse;
    logic         [AXI_DATA_BITS-1:0] s0_rdata_reg;

    // ARREADY when idle and not holding a response
    assign ARREADY_S0 = (s0_rd_state == S0_RD_IDLE);

    always_ff @(posedge ACLK) begin
        if (!ARESETn) begin
            s0_rd_state    <= S0_RD_IDLE;
            s0_rd_addr_reg <= '0;
            s0_ren_pulse   <= 1'b0;
            s0_rdata_reg   <= '0;
            RVALID_S0      <= 1'b0;
            RDATA_S0       <= '0;
            RRESP_S0       <= 2'b00;
        end else begin
            // default
            s0_ren_pulse <= 1'b0;
            RRESP_S0     <= 2'b00;

            unique case (s0_rd_state)
                S0_RD_IDLE: begin
                    if (ARVALID_S0 && ARREADY_S0) begin
                        s0_rd_addr_reg <= ARADDR_S0;
                        s0_ren_pulse   <= 1'b1;  // kick sync read
                        s0_rd_state    <= S0_RD_WAIT_DATA;
                    end
                end

                S0_RD_WAIT_DATA: begin
                    // sync read data becomes valid this cycle (from previous ren pulse)
                    s0_rdata_reg <= imem_data;
                    RDATA_S0     <= imem_data;
                    RVALID_S0    <= 1'b1;
                    s0_rd_state  <= S0_RD_RESP;
                end

                S0_RD_RESP: begin
                    if (RVALID_S0 && RREADY_S0) begin
                        RVALID_S0   <= 1'b0;
                        s0_rd_state <= S0_RD_IDLE;
                    end
                end

                default: s0_rd_state <= S0_RD_IDLE;
            endcase
        end
    end

    // IMEM write channel not supported
    assign AWREADY_S0 = 1'b0;
    assign WREADY_S0  = 1'b0;
    assign BRESP_S0   = 2'b00;
    assign BVALID_S0  = 1'b0;

    /* Drive IMEM port of memory */
    assign imem_addr  = s0_rd_addr_reg;
    assign imem_ren   = s0_ren_pulse;

    /* -----------------------------
     * Slave 1 (DMEM) : AXI-Lite slave, sync-read + sync-write memory
     * ----------------------------- */
    // Read path
    typedef enum logic [1:0] {
        S1_RD_IDLE,
        S1_RD_WAIT_DATA,
        S1_RD_RESP
    } s1_rd_state_e;
    s1_rd_state_e                     s1_rd_state;

    logic         [AXI_ADDR_BITS-1:0] s1_rd_addr_reg;
    logic                             s1_ren_pulse;
    logic         [AXI_DATA_BITS-1:0] s1_rdata_reg;

    assign ARREADY_S1 = (s1_rd_state == S1_RD_IDLE);

    always_ff @(posedge ACLK) begin
        if (!ARESETn) begin
            s1_rd_state    <= S1_RD_IDLE;
            s1_rd_addr_reg <= '0;
            s1_ren_pulse   <= 1'b0;
            s1_rdata_reg   <= '0;
            RVALID_S1      <= 1'b0;
            RDATA_S1       <= '0;
            RRESP_S1       <= 2'b00;
        end else begin
            s1_ren_pulse <= 1'b0;
            RRESP_S1     <= 2'b00;

            unique case (s1_rd_state)
                S1_RD_IDLE: begin
                    if (ARVALID_S1 && ARREADY_S1) begin
                        s1_rd_addr_reg <= ARADDR_S1;
                        s1_ren_pulse   <= 1'b1;
                        s1_rd_state    <= S1_RD_WAIT_DATA;
                    end
                end

                S1_RD_WAIT_DATA: begin
                    s1_rdata_reg <= dmem_rdata;
                    RDATA_S1     <= dmem_rdata;
                    RVALID_S1    <= 1'b1;
                    s1_rd_state  <= S1_RD_RESP;
                end

                S1_RD_RESP: begin
                    if (RVALID_S1 && RREADY_S1) begin
                        RVALID_S1   <= 1'b0;
                        s1_rd_state <= S1_RD_IDLE;
                    end
                end

                default: s1_rd_state <= S1_RD_IDLE;
            endcase
        end
    end

    // Write path
    typedef enum logic [1:0] {
        S1_WR_IDLE,
        S1_WR_WAIT,
        S1_WR_RESP
    } s1_wr_state_e;
    s1_wr_state_e                       s1_wr_state;

    logic         [  AXI_ADDR_BITS-1:0] s1_awaddr_reg;
    logic         [  AXI_DATA_BITS-1:0] s1_wdata_reg;
    logic         [AXI_DATA_BITS/8-1:0] s1_wstrb_reg;
    logic s1_got_aw, s1_got_w;
    logic s1_wen_pulse;

    assign AWREADY_S1 = (s1_wr_state == S1_WR_IDLE) && !s1_got_aw;
    assign WREADY_S1  = (s1_wr_state == S1_WR_IDLE) && !s1_got_w;

    always_ff @(posedge ACLK) begin
        if (!ARESETn) begin
            s1_wr_state   <= S1_WR_IDLE;
            s1_awaddr_reg <= '0;
            s1_wdata_reg  <= '0;
            s1_wstrb_reg  <= '0;
            s1_got_aw     <= 1'b0;
            s1_got_w      <= 1'b0;
            s1_wen_pulse  <= 1'b0;
            BVALID_S1     <= 1'b0;
            BRESP_S1      <= 2'b00;
        end else begin
            // defaults
            s1_wen_pulse <= 1'b0;
            BRESP_S1     <= 2'b00;

            unique case (s1_wr_state)

                S1_WR_IDLE: begin
                    // capture AW
                    if (AWVALID_S1 && AWREADY_S1) begin
                        s1_awaddr_reg <= AWADDR_S1;
                        s1_got_aw     <= 1'b1;
                    end
                    // capture W
                    if (WVALID_S1 && WREADY_S1) begin
                        s1_wdata_reg <= WDATA_S1;
                        s1_wstrb_reg <= WSTRB_S1;
                        s1_got_w     <= 1'b1;
                    end

                    // When both are available (including newly-captured this cycle), perform one-cycle sync write.
                    if ( (s1_got_aw || (AWVALID_S1 && AWREADY_S1)) &&
         (s1_got_w  || (WVALID_S1  && WREADY_S1 )) ) begin
                        s1_wen_pulse <= 1'b1;
                        BVALID_S1    <= 1'b1;
                        s1_wr_state  <= S1_WR_RESP;

                        // clear capture flags for next transaction
                        s1_got_aw    <= 1'b0;
                        s1_got_w     <= 1'b0;
                    end
                end

                S1_WR_RESP: begin
                    if (BVALID_S1 && BREADY_S1) begin
                        BVALID_S1   <= 1'b0;
                        s1_wr_state <= S1_WR_IDLE;
                    end
                end

                default: s1_wr_state <= S1_WR_IDLE;
            endcase
        end
    end

    /* Drive DMEM port of memory */
    // Read
    assign dmem_addr  = s1_rd_addr_reg;
    assign dmem_ren   = s1_ren_pulse;

    // Write
    assign dmem_wen   = s1_wen_pulse;
    assign dmem_wdata = s1_wdata_reg;
    assign dmem_wstrb = s1_wstrb_reg;

    /* Memory instance */
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
