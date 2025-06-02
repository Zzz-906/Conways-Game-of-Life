module Top (
    input wire clk,
    input wire rst,
    input wire start,
    input wire mode0,
    input wire mode1,
    input wire mode2,
    input wire add1,
    input wire add4,
    input wire add16,
    input wire add64
);

parameter W = 32;
parameter H = 24;
parameter L = W * H;

reg [L-1:0] board_now;
reg [L-1:0] board_next;
wire [L-1:0] board_null = {L{1'b0}};

reg en;
wire CONWAY, HIGH, LOW, BACTERIA, CORAL, VOTE, MAZE, DANCE;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        en <= 0;
        board_now <= board_null;
        board_next <= board_null;
    end else begin
        en <= start;
    end
end

assign CONWAY   = (~mode2 & ~mode1 & ~mode0);
assign HIGH     = (~mode2 & ~mode1 &  mode0);
assign LOW      = (~mode2 &  mode1 & ~mode0);
assign BACTERIA = (~mode2 &  mode1 &  mode0);
assign CORAL    = ( mode2 & ~mode1 & ~mode0);
assign VOTE     = ( mode2 & ~mode1 &  mode0);
assign MAZE     = ( mode2 &  mode1 & ~mode0);
assign DANCE    = ( mode2 &  mode1 &  mode0);

next_state #(.W(W), .H(H)) state_calculator (
    .clk(clk),
    .B(B_rule),
    .S(S_rule),
    .board_in(board_now),
    .board_out(board_next)
);

assign B_rule = CONWAY   ? 8'b00000100 : // B=3
                HIGH     ? 8'b00100100 : // B=36
                LOW      ? 8'b00000100 : // B=3
                BACTERIA ? 8'b00100010 : // B=34
                CORAL    ? 8'b00000100 : // B=3
                VOTE     ? 8'b01111000 : // B=5678
                MAZE     ? 8'b00000100 : // B=3
                DANCE    ? 8'b00001100 : // B=34
                8'b00000000;

assign S_rule = CONWAY   ? 8'b00001100 : // S=23
                HIGH     ? 8'b00001100 : // S=23
                LOW      ? 8'b00000101 : // S=13
                BACTERIA ? 8'b01110000 : // S=456
                CORAL    ? 8'b11111000 : // S=45678
                VOTE     ? 8'b11111000 : // S=45678
                MAZE     ? 8'b00011111 : // S=12345
                DANCE    ? 8'b00101000 : // S=34
                8'b00000000;

always @(posedge clk) begin
    if (en) begin
        board_now <= board_next;//first blit screen, then update board
    end
end

endmodule