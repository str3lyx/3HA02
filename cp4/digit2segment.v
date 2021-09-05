module digit2segment(clk, S5, S6, S7, segmentShow, dp, segment1, segment2, segment3, segment4);

input clk, S5, S6, S7;
output reg segment1,segment2,segment3,segment4,dp;
output reg [6:0] segmentShow;

reg [26:0] counter_10hz = 0;
reg [26:0] counter_1000hz = 0;
reg [13:0] num = 0;
reg step = 0;
reg [3:0] bcd;

// create 10hz clock and 1000hz_clock
always @(posedge clk) begin

	// reset
	if (S7 == 0) begin
		num <= 0;
	end
	
	// counter
	counter_10hz <= counter_10hz + 1;
	counter_1000hz <= counter_1000hz + 1;

	// 10 hz timer
	if (counter_10hz >= 5_000_000) begin
		counter_10hz <= 0;
		// number counting from 0 - 9999
		num <= num + step;
		if (num >= 9999)
			num <= 0;
	end

	// 1000hz timer
	if (counter_1000hz >= 50_000) begin
		counter_1000hz <= 0;
		// 7-segment updater
		if (segment1 == 1 && segment2 == 0 && segment3 == 0 && segment4 == 0) begin
			// 1000 thousand
			segment1 <= 0; segment2 <= 1; segment3 <= 0; segment4 <= 0;
			dp <= 0;
			bcd <= (num/100)%10;
		end else if (segment1 == 0 && segment2 == 1 && segment3 == 0 && segment4 == 0) begin
			// 0100 hundred
			segment1 <= 0; segment2 <= 0; segment3 <= 1; segment4 <= 0;
			dp <= 1;
			bcd <= (num/10)%10;
		end else if (segment1 == 0 && segment2 == 0 && segment3 == 1 && segment4 == 0) begin
			// 0010 ten
			segment1 <= 0; segment2 <= 0; segment3 <= 0; segment4 <= 1;
			dp <= 0;
			bcd <= num%10;
		end else begin
			// 0001 digit
			segment1 <= 1; segment2 <= 0; segment3 <= 0; segment4 <= 0;
			dp <= 0;
			bcd <= (num/1000)%10;
		end
	end
end

always @(negedge S5 or negedge S6 or negedge S7) begin
	if (S6 == 0 || S7 == 0) begin
		step <= 0;
	end else begin
		if (S5 == 0)
			step <= 1;
	end
end

always @(*) begin

    case (bcd)
        1: segmentShow <= 7'b0110000;
		2: segmentShow <= 7'b1101101;
		3: segmentShow <= 7'b1111001;
		4: segmentShow <= 7'b0110011;
		5: segmentShow <= 7'b1011011;
		6: segmentShow <= 7'b1011111;
		7: segmentShow <= 7'b1110000;
		8: segmentShow <= 7'b1111111;
		9: segmentShow <= 7'b1111011;
		0: segmentShow <= 7'b1111110;
        default: segmentShow <= 7'b0000000;
    endcase

end

endmodule
