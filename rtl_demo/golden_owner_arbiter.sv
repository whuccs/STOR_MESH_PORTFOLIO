// Self-contained portfolio demo. This is a simplified, independently
// rewritten example and is not a copy of the full project RTL.
module golden_owner_arbiter #(
  parameter int OWNER_NUM     = 5,
  parameter int WINDOW_CYCLES = 9,
  localparam int OWNER_W      = (OWNER_NUM > 1) ? $clog2(OWNER_NUM) : 1,
  localparam int WINDOW_W     = (WINDOW_CYCLES > 1) ? $clog2(WINDOW_CYCLES) : 1
) (
  input  logic                 clk,
  input  logic                 reset_n,
  input  logic [OWNER_NUM-1:0] request,
  output logic [OWNER_NUM-1:0] grant,
  output logic [OWNER_W-1:0]   current_golden_owner
);

  logic [WINDOW_W-1:0] window_counter;
  integer index;
  logic winner_found;

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      window_counter        <= '0;
      current_golden_owner <= '0;
    end else if ((WINDOW_CYCLES <= 1) ||
                 (window_counter == WINDOW_CYCLES - 1)) begin
      window_counter <= '0;
      if ((OWNER_NUM <= 1) ||
          (current_golden_owner == OWNER_NUM - 1))
        current_golden_owner <= '0;
      else
        current_golden_owner <= current_golden_owner + 1'b1;
    end else begin
      window_counter <= window_counter + 1'b1;
    end
  end

  always_comb begin
    grant        = '0;
    winner_found = 1'b0;

    // The rotating owner wins when it is requesting.
    if (request[current_golden_owner]) begin
      grant[current_golden_owner] = 1'b1;
      winner_found                = 1'b1;
    end

    // Otherwise use deterministic low-index priority.
    for (index = 0; index < OWNER_NUM; index = index + 1) begin
      if (!winner_found && request[index]) begin
        grant[index] = 1'b1;
        winner_found = 1'b1;
      end
    end
  end

endmodule
