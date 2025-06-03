module next_state #(
    parameter W = 32,
    parameter H = 24,
    parameter L = W * H
)(
    input wire clk,
    input wire [7:0] B,
    input wire [7:0] S, 
    input wire [L-1:0] board_in,
    output reg [L-1:0] board_out
);

reg [L-1:0] board_temp = {L{1'b0}};
integer i,j;
reg [3:0] neighbors;

function [3:0] alive_neighbors;
    input integer index;
    integer row, col, row_back, row_forward, col_back, col_forward;
    begin
        row = index / W; col = index % W;
        row_back = row == 0 ? H - 1 : row - 1;
        row_forward = row == H - 1 ? 0 : row + 1;
        col_back = col == 0 ? W - 1 : col - 1;
        col_forward = col == W - 1 ? 0 : col + 1;
        alive_neighbors = (board_in[row_back * W + col_back] ? 1 : 0) 
                        + (board_in[row_back * W + col] ? 1 : 0)
                        + (board_in[row_back * W + col_forward] ? 1 : 0)
                        + (board_in[row * W + col_back] ? 1 : 0)
                        + (board_in[row * W + col_forward] ? 1 : 0)
                        + (board_in[row_forward * W + col_back] ? 1 : 0)
                        + (board_in[row_forward * W + col] ? 1 : 0)
                        + (board_in[row_forward * W + col_forward] ? 1 : 0);
     end
endfunction

always @(posedge clk) begin
    board_temp = {L{1'b0}};
    for (i = 0; i < L; i = i + 1) begin
       neighbors = alive_neighbors(i);
        if (!board_in[i] && B[neighbors - 1]) begin
            board_temp[i] = 1'b1;
        end
        else if (board_in[i] && S[neighbors - 1]) begin
            board_temp[i] = 1'b1;
        end
    end
    board_out = board_temp;
end

endmodule