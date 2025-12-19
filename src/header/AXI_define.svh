`ifndef AXI_DEFINE_SVH
`define AXI_DEFINE_SVH

parameter int unsigned AXI_ID_BITS = 4;
parameter int unsigned AXI_IDS_BITS = 8;
parameter int unsigned AXI_ADDR_BITS = 32;
parameter int unsigned AXI_LEN_BITS = 4;
parameter int unsigned AXI_SIZE_BITS = 3;
parameter int unsigned AXI_DATA_BITS = 32;
parameter int unsigned AXI_STRB_BITS = 4;
parameter logic [3:0] AXI_LEN_ONE = 4'h0;
parameter logic [2:0] AXI_SIZE_BYTE = 3'b000;
parameter logic [2:0] AXI_SIZE_HWORD = 3'b001;
parameter logic [2:0] AXI_SIZE_WORD = 3'b010;
parameter logic [1:0] AXI_BURST_INC = 2'h1;
parameter logic [3:0] AXI_STRB_WORD = 4'b1111;
parameter logic [3:0] AXI_STRB_HWORD = 4'b0011;
parameter logic [3:0] AXI_STRB_BYTE = 4'b0001;
parameter logic [1:0] AXI_RESP_OKAY = 2'h0;
parameter logic [1:0] AXI_RESP_SLVERR = 2'h2;
parameter logic [1:0] AXI_RESP_DECERR = 2'h3;

`endif
