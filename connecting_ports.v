/*connecting ports by name and by position */

BY name

module top_module ( input a,b,c,d, output out1, out2);
mod_a inst( .in1(a), .in2(b), .in3(c), .in4(d), .out1(out1), .out2(out2));

endmodule



BY position

module top_module ( input a,b,c,d, output out1, out2);
mod_a inst(a, b, c, d , out1, out2);

endmodule



/* shift register of length 3 */

module top_module ( inputs clk,d , output q);
wire w1, w2,w3 ;
my_dff in1( .clk(clk), .d(d), .q(w1));
my_dff in2( .clk(clk), .d(w1), .q(w2));
my_dff in3( .clk(clk), .d(w2), .q(w3));

assign q = w3;
endmodule
