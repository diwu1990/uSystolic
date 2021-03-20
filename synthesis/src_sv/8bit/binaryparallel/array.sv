`include "pe_border.sv"
`include "pe_inner.sv"

module array #(
    parameter HEIGHT=12,
    parameter WIDTH=14,
    parameter IWIDTH=8,
    parameter OWIDTH=24
) (
    input logic clk,
    input logic rst_n,
    input logic [HEIGHT-1 : 0] en_i,
    input logic [HEIGHT-1 : 0] clr_i,
    input logic [WIDTH-1 : 0] en_w,
    input logic [WIDTH-1 : 0] clr_w,
    input logic [WIDTH-1 : 0] en_o,
    input logic [WIDTH-1 : 0] clr_o,
    input logic signed [HEIGHT-1 : 0] ifm [IWIDTH-1 : 0],
    input logic signed [WIDTH-1 : 0] wght [IWIDTH-1 : 0],
    output logic signed [WIDTH-1 : 0] ofm [OWIDTH-1 : 0]
);

    logic [HEIGHT-1 : 0] en_i_x [WIDTH : 0];
    logic [HEIGHT-1 : 0] clr_i_x [WIDTH : 0];
    logic [WIDTH-1 : 0] en_w_x [HEIGHT : 0];
    logic [WIDTH-1 : 0] clr_w_x [HEIGHT : 0];
    logic [WIDTH-1 : 0] en_o_x [HEIGHT : 0];
    logic [WIDTH-1 : 0] clr_o_x [HEIGHT : 0];

    logic signed [HEIGHT-1 : 0][WIDTH : 0] ifm_x [IWIDTH-1 : 0];
    logic signed [WIDTH-1 : 0][HEIGHT : 0] wght_x [IWIDTH-1 : 0];
    logic signed [WIDTH-1 : 0][HEIGHT : 0] ofm_x [OWIDTH-1 : 0];

    genvar h, w;
    generate
        for (h = 0; h < HEIGHT; h++) begin
            pe_border #(
                IWIDTH=IWIDTH,
                OWIDTH=OWIDTH
            ) U_pe_border (
                .clk(clk),
                .rst_n(rst_n),
                .en_i(en_i_x[h][0]),
                .clr_i(clr_i_x[h][0]),
                .en_w(en_w_x[0][h]),
                .clr_w(clr_w_x[0][h]),
                .en_o(en_o_x[0][h]),
                .clr_o(clr_o_x[0][h]),
                .ifm(ifm_x[h][0]),
                .wght(wght_x[0][h]),
                .ofm(ofm_x[0][h]),
                .en_i_d(en_i_x[h][1]),
                .clr_i_d(clr_i_x[h][1]),
                .en_w_d(en_w_x[1][h]),
                .clr_w_d(clr_w_x[1][h]),
                .en_o_d(en_o_x[1][h]),
                .clr_o_d(clr_o_x[1][h]),
                .ifm_d(ifm_x[h][1]),
                .wght_d(wght_x[1][h]),
                .ofm_d(ofm_x[1][h])
            );
            for (w = 1; w < WIDTH; w++) begin
                pe_inner #(
                    IWIDTH=IWIDTH,
                    OWIDTH=OWIDTH
                ) U_pe_inner (
                    .clk(clk),
                    .rst_n(rst_n),
                    .en_i(en_i_x[h][w]),
                    .clr_i(clr_i_x[h][w]),
                    .en_w(en_w_x[w][h]),
                    .clr_w(clr_w_x[w][h]),
                    .en_o(en_o_x[w][h]),
                    .clr_o(clr_o_x[w][h]),
                    .ifm(ifm_x[h][w]),
                    .wght(wght_x[w][h]),
                    .ofm(ofm_x[w][h]),
                    .en_i_d(en_i_x[h][w+1]),
                    .clr_i_d(clr_i_x[h][w+1]),
                    .en_w_d(en_w_x[w+1][h]),
                    .clr_w_d(clr_w_x[w+1][h]),
                    .en_o_d(en_o_x[w+1][h]),
                    .clr_o_d(clr_o_x[w+1][h]),
                    .ifm_d(ifm_x[h][w+1]),
                    .wght_d(wght_x[w+1][h]),
                    .ofm_d(ofm_x[w+1][h])
                );
            end
        end
    endgenerate

endmodule