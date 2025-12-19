module top (
    input logic clk,
    input logic rst_n
);

  addr_t   imem_addr;
  enable_t imem_ren;
  data_t   imem_data;
  addr_t   dmem_addr;
  enable_t dmem_ren;
  data_t   dmem_read_data;
  enable_t dmem_wen;
  data_t   dmem_write_data;

  cpu core_0 (
      .clk              (clk),
      .rst_n            (rst_n),
      .imem_addr_o      (imem_addr),
      .imem_ren_o       (imem_ren),
      .imem_data_i      (imem_data),
      .dmem_addr_o      (dmem_addr),
      .dmem_ren_o       (dmem_ren),
      .dmem_read_data_i (dmem_read_data),
      .dmem_wen_o       (dmem_wen),
      .dmem_write_data_o(dmem_write_data)
  );

  memory mem0 (
      .clk         (clk),
      .imem_addr_i (imem_addr),
      .imem_ren_i  (imem_ren),
      .imem_data_o (imem_data),
      .dmem_addr_i (dmem_addr),
      .dmem_ren_i  (dmem_ren),
      .dmem_rdata_o(dmem_read_data),
      .dmem_wen_i  (dmem_wen),
      .dmem_wdata_i(dmem_write_data)
  );

endmodule
