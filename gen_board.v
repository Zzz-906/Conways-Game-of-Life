module gen_board #(
    parameter W = 32,
    parameter H = 24,
    parameter L = W * H
)(
    input wire clk,
    input wire rst,
    input wire [31:0] seed,
    input wire [1:0] density, // 0=0%, 1=25%, 2=50%, 3=75%
    input wire en,
    output reg [L-1:0] board_out
);

wire [31:0] rand_val;
integer idx;
reg [31:0] count;
reg [L-1:0] board_temp;

wire [31:0] target_count = 
    (density == 2'b01) ? (L * 288 / 1000) :
    (density == 2'b10) ? (L * 693 / 1000) : 
    (density == 2'b11) ? (L * 1386 / 1000):
    0;

rand random_gen (
    .clk(clk),
    .rst(rst),
    .en(en && (count < target_count)),
    .seed(seed),
    .rand_out(rand_val)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        board_out <= {L{1'b0}};
        board_temp <= {L{1'b0}};
        count <= 0;
    end else if (en && (count < target_count)) begin
        idx = rand_val % L;
        board_temp[idx] <= 1'b1;
        count <= count + 1;
    end else if (count == target_count) begin
        board_out <= board_temp;
    end
end

endmodule