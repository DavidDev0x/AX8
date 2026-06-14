/* vim: set filetype=verilog : */
`timescale 1ns / 1ps

module register_8 (
    input clk,
    input we,  // write-enable
    input [7:0] d,
    output [7:0] q
);
  // WE=0 -> Data input = current Q (hold data)
  // WE=1 -> Data input = new data

  // d_in = (we & d) | (~we & q)
  wire [7:0] d_in;

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : gen_bit
      wire nwe;
      wire w0, w1;

      not n0 (nwe, we);
      and a0 (w0, we, d[i]);
      and a1 (w1, nwe, q[i]);
      or o0 (d_in[i], w0, w1);

      d_flipflop dff (
          .clk(clk),
          .d  (d_in[i]),
          .q  (q[i]),
          .nq ()
      );
    end
  endgenerate

endmodule
