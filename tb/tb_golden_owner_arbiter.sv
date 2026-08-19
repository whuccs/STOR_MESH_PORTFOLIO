`timescale 1ns/1ps

module tb_golden_owner_arbiter;
  localparam int OWNER_NUM     = 3;
  localparam int WINDOW_CYCLES = 3;

  logic                 clk;
  logic                 reset_n;
  logic [OWNER_NUM-1:0] request;
  logic [OWNER_NUM-1:0] grant;
  logic [1:0]           current_golden_owner;

  golden_owner_arbiter #(
    .OWNER_NUM(OWNER_NUM),
    .WINDOW_CYCLES(WINDOW_CYCLES)
  ) dut (
    .clk(clk),
    .reset_n(reset_n),
    .request(request),
    .grant(grant),
    .current_golden_owner(current_golden_owner)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  task automatic expect_grant(input logic [OWNER_NUM-1:0] expected);
    #1;
    if (grant !== expected) begin
      $error("grant=%b expected=%b golden=%0d", grant, expected,
             current_golden_owner);
      $fatal(1);
    end
  endtask

  initial begin
    reset_n = 1'b0;
    request = '0;
    repeat (2) @(posedge clk);
    reset_n = 1'b1;

    // Owner 0 is initially Golden. If absent, owner 1 wins by fallback.
    request = 3'b110;
    expect_grant(3'b010);

    // When owner 0 requests, it wins even with other contenders.
    request = 3'b111;
    expect_grant(3'b001);

    // Rotate to owner 1 after one complete window.
    repeat (WINDOW_CYCLES) @(posedge clk);
    #1;
    if (current_golden_owner !== 1) $fatal(1, "owner 1 expected");
    request = 3'b111;
    expect_grant(3'b010);

    // Rotate to owner 2 and prove the lowest static priority can win.
    repeat (WINDOW_CYCLES) @(posedge clk);
    #1;
    if (current_golden_owner !== 2) $fatal(1, "owner 2 expected");
    request = 3'b110;
    expect_grant(3'b100);

    // No request must produce no grant.
    request = '0;
    expect_grant('0);

    $display("PASS tb_golden_owner_arbiter");
    $finish;
  end
endmodule
