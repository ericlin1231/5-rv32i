import defs::*;

module memory #(
    parameter MEM_SIZE = 4096,
    parameter TYPE = ""
) (
    input  logic            clk,
    input  logic            ren,
    input  logic            wen,
    input  logic [XLEN-1:0] addr_i,
    input  logic [XLEN-1:0] data_i,
    output logic [XLEN-1:0] data_o
);

    localparam BYTES = XLEN / 8;
    localparam ADDR_BITS = $clog2(MEM_SIZE);

    string imem_file;
    byte unsigned mem[0:MEM_SIZE-1];
    initial begin
        if (TYPE == "") $error("Implement memory but not declare type");
        if (TYPE == "IMEM") begin
            if (!$value$plusargs("IMEM=%s", imem_file))
                $display("Instruction memory didn't load program file");
            if (imem_file != "") begin
                $display("[%m] load %s to instruction memory", imem_file);
                $readmemh(imem_file, mem);
            end
        end
    end

    bit [ADDR_BITS-1:0] offset_w;
    always_ff @(posedge clk) begin
        if (wen) begin
            for (offset_w = 0; offset_w < BYTES; offset_w++) begin
                mem[addr_i[ADDR_BITS-1:0]+offset_w] <= data_i[8*offset_w+:8];
            end
        end
    end

    bit [ADDR_BITS-1:0] offset_r;
    always_comb begin
        if (ren) begin
            for (offset_r = 0; offset_r < BYTES; offset_r++) begin
                data_o[8*offset_r+:8] = mem[addr_i[ADDR_BITS-1:0]+offset_r];
            end
        end else begin
            data_o <= data_o;
        end
    end

endmodule
