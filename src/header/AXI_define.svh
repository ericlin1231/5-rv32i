`ifndef AXI_DEFINE_SVH
`define AXI_DEFINE_SVH

parameter AXI_ID_BITS = 4;
parameter AXI_IDS_BITS = 8;
parameter AXI_ADDR_BITS = 32;
parameter AXI_LEN_BITS = 4;
parameter AXI_SIZE_BITS = 3;
parameter AXI_DATA_BITS = 32;
parameter AXI_STRB_BITS = 4;
parameter AXI_LEN_ONE = 4'h0;
parameter AXI_SIZE_BYTE = 3'b000;
parameter AXI_SIZE_HWORD = 3'b001;
parameter AXI_SIZE_WORD = 3'b010;
parameter AXI_BURST_INC = 2'h1;
parameter AXI_STRB_WORD = 4'b1111;
parameter AXI_STRB_HWORD = 4'b0011;
parameter AXI_STRB_BYTE = 4'b0001;
parameter AXI_RESP_OKAY = 2'h0;
parameter AXI_RESP_SLVERR = 2'h2;
parameter AXI_RESP_DECERR = 2'h3;

`endif
