module Synchronizer (clk,rst_n,in_sig,out_sig);

parameter num_stages=2;

input clk ,rst_n;
input in_sig;
output  out_sig ;

reg [num_stages-1 :0] sync_reg;




always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_reg <= 'b0;
    end
    else begin
    sync_reg <= {in_sig, sync_reg[num_stages-1:1]};
    end
end

assign out_sig = sync_reg[num_stages-1] ;


endmodule //Synchronizer