module Top_tb ();
 // Parameters
  parameter num_stages = 2;
  parameter counter_final_value = 5;

  // I/O Ports
  reg clk, rst_n;
  reg  noisy_in;
  wire debouncer_out;



  // Instantiate Top
  Top #(
      .num_stages(num_stages),
      .counter_final_value(counter_final_value)
  ) top (
      .*
  );

 //clk generation
 initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
 end



 // Test Sequence
 initial begin
    // Initialize signals
    rst_n = 1'b0;
    noisy_in = 1'b0;

    // Release reset after some time
    @(negedge clk);
    rst_n = 1'b1;

 // Simulate a noisy signal
 repeat (10) @(negedge clk);
 noisy_in = 1'b0;  @(negedge clk);
 noisy_in = 1'b1;  @(negedge clk);
 noisy_in = 1'b0;  @(negedge clk);
 noisy_in = 1'b1;  @(negedge clk);

 // Stable high signal
  noisy_in = 1'b1;  
  repeat (50) @(negedge clk);


 // Simulate a noisy signal
  @(negedge clk);
 noisy_in = 1'b0;  @(negedge clk);
 noisy_in = 1'b1;  @(negedge clk);
 noisy_in = 1'b0;  @(negedge clk);
 noisy_in = 1'b1;  @(negedge clk);

 // Stable low signal
  noisy_in = 1'b0; 
  repeat (50) @(negedge clk);


    $stop;  // End simulation 
 end

 initial begin
    $monitor("Time=%0t | rst_n=%b | noisy_in=%b | debouncer_out=%b", $time, rst_n, noisy_in,
             debouncer_out);
  end
endmodule  //Top_tb
