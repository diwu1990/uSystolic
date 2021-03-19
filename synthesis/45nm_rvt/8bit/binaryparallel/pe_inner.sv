`include "ireg_inner.sv"
`include "wreg.sv"
`include "mul_inner.sv"
`include "acc.sv"

module pe_inner #(
    parameter IWIDTH=8,
    parameter OWIDTH=24
) (
    input logic clk,
    input logic rst_n,
    input logic en_i,
    input logic clr_i,
    input logic en_w,
    input logic clr_w,
    input logic en_o,
    input logic clr_o,
    input logic signed [IWIDTH-1 : 0] ifm,
    input logic signed [IWIDTH-1 : 0] wght,
    input logic signed [OWIDTH-1 : 0] ofm,
    output logic signed [IWIDTH-1 : 0] ifm_d,
    output logic signed [IWIDTH-1 : 0] wght_d,
    output logic signed [OWIDTH-1 : 0] ofm_d
);

    logic signed [IWIDTH*2-1 : 0] prod;

    ireg_inner #(
        .WIDTH(IWIDTH)
    ) U_ireg_inner (
        .clk(clk),
        .rst_n(rst_n),
        .en(en_i),
        .clr(clr_i),
        .i_data(ifm),
        .o_data(ifm_d)
    );

    wreg #(
        .WIDTH(IWIDTH)
    ) U_wreg (
        .clk(clk),
        .rst_n(rst_n),
        .en(en_w),
        .clr(clr_w),
        .i_data(wght),
        .o_data(wght_d)
    );

    mul_inner #(
        .WIDTH(IWIDTH)
    ) U_mul_inner(
        .i_data0(ifm_d),
        .i_data1(wght_d),
        .o_data(prod)
    );

    acc #(
        .WIDTH(OWIDTH)
    ) U_acc(
        .clk(clk),
        .rst_n(rst_n),
        .en(en_o),
        .clr(clr_o),
        .i_data0({{(OWIDTH-IWIDTH*2){prod[IWIDTH*2-1]}}, prod}),
        .i_data1(ofm),
        .o_data(ofm_d)
    );

endmodule