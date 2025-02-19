module decoder #(parameter N = 2) (
	input [N-1:0] e,
	output [2**N-1:0] d
);

	wire [2**N-1:0] d0;
	assign d0 = {{(2**N-1){1'b0}}, 1'b1};
	assign d = d0 << e;

endmodule


module mod_mux #(parameter N = 3)(
	input [(2**N)-1:0] A,
	input [0:N-1] S,
	output O
	);
	
	genvar j, k;
	
	wire [2**N-1:0] AA[N:0];
		
	generate
	for (k = 0; k < 2**N; k = k + 1) begin
		assign AA[0][k] = A[k];
	end
	endgenerate
	
	generate
	for (j = 0; j < N; j = j + 1)
	begin: col
		for (k = 0; k < 2**(N-1-j); k = k + 1) 
		begin: row
			MUX #(.N(1)) MUX_(
				.A(AA[j][2*k]),
				.B(AA[j][2*k+1]),
				.S(S[N-j-1]),
				.O(AA[j+1][k])
			);
		end	
	end
	endgenerate
	
	assign O = AA[N][0];
	
endmodule

