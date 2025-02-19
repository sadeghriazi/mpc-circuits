module auction #(parameter N = 2, W = 2)( //b = W, n = 2^N
	input [(2**N)*W-1:0] bid,
	output [N-1:0] winner,
	output [W-1:0] winning_bid
	);
	
	genvar i;
	wire [W-1:0] B [2**N-1:0];
	generate
		for (i = 0; i < 2**N; i = i + 1) begin
			assign B[i] = bid[(i+1)*W-1:i*W]; 
		end
	endgenerate
	
	genvar j, k;
	
	wire [W-1:0] WV[N:0][2**N-1:0];
	wire [2**(N-1)-1:0] WID [N-1:0];
		
	generate
		for (k = 0; k < 2**N; k = k + 1) begin
			assign WV[0][k] = B[k];
		end
	endgenerate
	
	generate
		for (j = 0; j < N; j = j + 1) begin: col
			for (k = 0; k < 2**(N-1-j); k = k + 1) 
			begin: row
				COMP #(.N(W)) COMP_(
					.A(WV[j][2*k+1]),
					.B(WV[j][2*k]),
					.O(WID[j][k])
				);
				MUX #(.N(W)) MUX_(
					.A(WV[j][2*k]),
					.B(WV[j][2*k+1]),
					.S(WID[j][k]),
					.O(WV[j+1][k])
				);
			end	
		end
	endgenerate
	
	assign winning_bid = WV[N][0];
	
	assign winner[N-1] = WID[N-1][0];
	
	generate
		for (j = N-2; j >= 0; j = j - 1) begin: mux_
			mod_mux #(.N(N-j-1)) mod_mux_(
				.A(WID[j][(2**(N-j-1))-1:0]),
				.S(winner[N-1:j+1]),
				.O(winner[j])
			);
		end
	endgenerate
	
endmodule



