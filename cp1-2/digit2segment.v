module digit2segment(clk,segmentShow,dp,segment1,segment2,segment3,segment4);

input clk;
output segment1,segment2,segment3,segment4,dp;
output [6:0] segmentShow;

reg [3:0] num = 0;  // temporary number
reg [6:0] abcdefg;  // abcdefg on segment

always @(posedge clk) begin  

	num <= 3;
	
	//-------- Interger to segment ----------------------------------
	case(num)
	1: abcdefg = 7'b0110000;
	2: abcdefg = 7'b1101101;
	3: abcdefg = 7'b1111001;
	4: abcdefg = 7'b0110011;
	5: abcdefg = 7'b1011011;
	6: abcdefg = 7'b1011111;
	7: abcdefg = 7'b1110000;
	8: abcdefg = 7'b1111111;
	9: abcdefg = 7'b1111011;
	0: abcdefg = 7'b1111110;
    default: abcdefg = 7'b0000000;
	endcase
end
assign segment1 = 1;	assign segment2 = 1;	assign segment3 = 1;	assign segment4 = 1;
assign segmentShow = abcdefg;    //num;
endmodule
