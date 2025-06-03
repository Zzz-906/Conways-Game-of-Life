module rand(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [31:0] seed,
    output wire [31:0] rand_out
);

reg [7:0] r256;
reg [7:0] r253;
reg [7:0] r163;
reg [31:0] r_num; //reset before use

always @(posedge clk or posedge rst) begin
    if (rst) begin
        r256 <= 8'hAB;
        r253 <= 8'hCC;
        r163 <= 8'h6E;
        r_num <= 32'hDEADBEEF + seed;
    end else if (en) begin
        r256 <= r256 + 8'd1;
        r253 <= (r253 + 8'd1) % 8'd253;
        r163 <= (r163 + 8'd1) % 8'd163;
        r_num <= (r_num ^ {r256, r253, r163}) * 32'h18881617 + r_num[28:23] * r256 * 32'hCABBA9E + r_num[22:19] * {r253 ^ r163} * 32'hCCD + 32'hBEEBEE;
    end
end

assign rand_out = r_num;

endmodule