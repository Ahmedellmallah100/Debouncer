module Fsm (
    clk,  rst_n,  sync_sig,   timer_done,   debouncer_out,  timer_en
);
  // State Encoding
  parameter idle = 2'b00;
  parameter check_high = 2'b01;
  parameter high_state = 2'b10;
  parameter check_low = 2'b11;

  // I/O Ports
  input clk, rst_n;
  input sync_sig;
  input timer_done;
  output reg timer_en;
  output reg debouncer_out;


  // State Registers
  reg [1:0] cs, ns;

  // Sequential Logic for State Transition
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cs <= idle;
    else cs <= ns;
  end

  // Combinational Logic for Next State and Output Logic
  always @(*) begin
    case (cs)
      idle:
      if (~sync_sig) begin
        ns = idle;
      end else begin
        ns = check_high;
      end

      check_high:
      if (sync_sig & ~timer_done) begin
        ns = check_high;
      end else if (sync_sig & timer_done) begin
        ns = high_state;
      end else begin
        ns = idle;
      end


      high_state:
      if (sync_sig) begin
        ns = high_state;
      end else begin
        ns = check_low;
      end
      check_low:
      if (~sync_sig & ~timer_done) begin
        ns = check_low;
      end else if (~sync_sig & timer_done) begin
        ns = idle;
      end else begin
        ns = high_state;
      end
      default: ns = idle;

    endcase
  end


  // Output Logic
  always @(*) begin
    case (cs)

      idle: begin
        debouncer_out = 0;
        timer_en = 0;
      end
      check_high: begin
        debouncer_out = 0;
        timer_en = 1;
      end
      high_state: begin
        debouncer_out = 1;
        timer_en = 0;
      end
      check_low: begin
        debouncer_out = 1;
        timer_en = 1;
      end

      default: begin
        debouncer_out = 0;
        timer_en = 0;
      end
    endcase
  end


endmodule  //Fsm
