module digit2segment(clk,segmentShow,dp,segment1,segment2,segment3,segment4);

input clk;
output segment1,segment2,segment3,segment4,dp;
output [6:0] segmentShow;

parameter inClk = 50_000_000;       //reference clock 
parameter refreshT = inClk/(60*4);  //60Hz 4 digit
reg [26:0] clkRefresh; 		        // count every clk  (max= 67 million)

reg [6:0] abcdefg;  		                                //รองรับตำแหน่งของ led
reg s4,s3,s2,s1;     		                                // ควบคุมการทำงานของ led แต่ละหลัก
reg [1:0] segmentID; 		                                // control 7-Segment id
reg [3:0] digit = 3, ten = 8, hundred = 3, thousand = 10; 	// รองรับตัวเลข 0-16 ของแต่ละตำแหน่ง

reg [15:0] num;		// interger 16 bit

always @(posedge clk) begin   //วงจร refresh 
	clkRefresh <= clkRefresh + 1;
	if (clkRefresh == refreshT) begin	
		segmentID <= segmentID + 1;
		clkRefresh <= 0;  //reset to zero
	end
	
	case(segmentID)  	// shift 7-segment
		2'b00 : begin s4 = 0; s3 = 0; s2 = 0; s1 = 1;  num = thousand; 	end
		2'b01 : begin s4 = 0; s3 = 0; s2 = 1; s1 = 0;  num = hundred; 	end
		2'b10 : begin s4 = 0; s3 = 1; s2 = 0; s1 = 0;  num = ten;	end
		2'b11 : begin s4 = 1; s3 = 0; s2 = 0; s1 = 0;  num = digit;	end
	endcase	

	// integer -> 7-segment
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

assign segment1 = s1; 	assign segment2 = s2; 	assign segment3 = s3; 	assign segment4 = s4;
assign segmentShow = abcdefg;    //num;

endmodule
