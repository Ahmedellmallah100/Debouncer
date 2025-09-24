module Top (
    clk, rst_n, noisy_in, debouncer_out
);
// Parameters
parameter num_stages=2;
parameter counter_final_value=99;

// I/O Ports
input clk, rst_n;   
input noisy_in; 
output debouncer_out;

// Internal Signals
wire sync_sig, timer_done, timer_en ;

// Instantiate Synchronizer
Synchronizer #(.num_stages(num_stages)) synchronizer (
    .clk(clk),
    .rst_n(rst_n),
    .in_sig(noisy_in),
    .out_sig(sync_sig)
);  

// Instantiate Timer
Timer #(.counter_final_value(counter_final_value)) timer (
    .clk(clk),
    .rst_n(rst_n),
    .timer_en(timer_en),
    .timer_done(timer_done)
);

// Instantiate FSM
Fsm fsm (
    .clk(clk),
    .rst_n(rst_n),
    .sync_sig(sync_sig),
    .timer_done(timer_done),
    .debouncer_out(debouncer_out),
    .timer_en(timer_en)
);  




endmodule //Top