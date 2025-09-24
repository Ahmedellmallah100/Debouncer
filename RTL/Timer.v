module Timer (clk, rst_n, timer_en, timer_done);

parameter counter_final_value=99;
localparam counter_width=$clog2(counter_final_value+1)   ;


input clk, rst_n;
input timer_en; 
output reg timer_done;  


reg [counter_width-1 :0] count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        timer_done <= 1'b0;
        count <= 'b0;
    end else if(timer_en) begin
         if (count == counter_final_value) begin
            timer_done <= 1'b1;
            count <= 'b0;
        end else begin
            count <= count + 1;
            timer_done <= 1'b0;
        end
    end else begin
        count <= 'b0;
        timer_done <= 1'b0;
    end
end

endmodule //Timer