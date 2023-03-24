module snake_downred_rom (
	input logic clock,
	input logic [9:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:944] /* synthesis ram_init_file = "./snake_downred.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
