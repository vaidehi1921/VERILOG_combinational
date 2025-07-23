//half adder//
module top_module( input a,b,
                   output s,c);
                   always@(*)
                   begin
                    s=(a^b);
                    c=(a*b);
                   end

endmodule


//full adder//

module top_module( input a,b,c,
                   output s,cout);
                   always@(*)
                   begin
                    s=(a^b^c);
                    cout=(a^b)*c |(a*b);
                   end
endmodule
                    


// full adder using half adders//

module half_add(input a,b, output s,c);
    assign s= (a^b);
    assign c = (a*b);
endmodule

  module full_Add( input a,b,cin, ouptut s_out, c_out );
 wire s,co,c1;

 half_add(a,b,s,c0);
 half_add(s,cin,s_out,c1);
 assign c_out =(c0 |c1);

   endmodule



//half subtractor//
module half_sub( input a,b,  output reg d,bo);
always@(*)
begin
  d= (a^b);
  bo = (~a &b);
end
endmodule



// full subtractor using behavioral model //
module full_subtractor(input a,b,bin, output reg diff,bout);
    always @(*) 
    begin
        diff = a ^ b ^ bin;
        bout = (~a & b) | ((~a | b) & bin);
    end
endmodule





//4 bit binary adder- subtractor//
*/ define a full adder first */

module full_add(input a,b,cin, output reg s,c);
always@(*)
                   begin
                    s=(a^b^cin);
                    c=(a^b)*cin |(a*b);
                   end
endmodule

module 4bit_adder_sub #parameter(size = 4)
( input [size-1:0]a,b, input ctrl, output [size-1:0]s,cout);
bit [size-1:0] bc;
genvar g;

assign bc[0]= (b[0]^ ctrl);

full_adder fa0( a[0],bc[0],ctrl, s[0],c[0] );
generate
  for (g=1; g<size; g++)
  begin
    assign bc[g]= (b[g]^ ctrl);
    full_adder fa0( a[g],bc[g],cout[g-1], s[g],c[g] );
  end
endgenerate
endmodule



// 100 bit binary adder //

module top_module( input [99:0]a,b, input cin, output [99:0]sum, output cout);

genvar i;
wire [98:0] w;

    full_Add f0( a[0], b[0],cin, sum[0],w[0]);
    full_Add f1( a[99], b[99],w[98],sum[99], cout);
generate 
    for ( i =1; i<99; i++) 
        begin:full_add_loop
            full_Add f0( a[i], b[i],w[i-1], sum[i],w[i]);
  end
endgenerate
endmodule

module full_Add( input a,b,c,
                   output s,cout);
                   always@(*)
                   begin
                    s=(a^b^c);
                    cout=(a^b)*c |(a*b);
                   end
endmodule
          


// MAKE 32 BIT ADDER USING TWO 16 BIT ADDER//

module top_module ( input [31:0]a,b, output [31:0]sum);
wire w1, w2;

add16 ins1( .a(a[15:0]), .b(b[15:0]), .cin(1'b0), .sum(sum[15:0]), .cout(w1) );
add16 ins2( .a(a[31:16]), .b(b[31:16]), .cin(w1), .sum(sum[31:16]), .cout(w2) );

assign sum = { sum [31:16], sum [15:0]};
endmodule


// MAKE 32 BIT ADDER INSTANTING TWO 16 BIT ADDER EACH INSTANTIATING MORE 16 (1 BIT)ADDERS);

module top_module( input [31:0]a,b, output [31:0]sum );
wire w1, w2;

add16 ins1( .a(a[15:0]), .b(b[15:0]), .cin(1'b0), .sum(sum[15:0]), .cout(w1) );
add16 ins2( .a(a[31:16]), .b(b[31:16]), .cin(w1), .sum(sum[31:16]), .cout(w2) );
assign sum = { sum [31:16], sum [15:0]};
endmodule

module add1( input a, b, cin, output sum , cout);
assign sum =(a^b^cin);
assign cout =(a^b)*cin | a*b;
endmodule





// ADDERS WHICH WE USUALLY MAKE ARE PARALLEL OR RIPPLE ADDERS WHICH HAVE WORST DELAY BEACUSE CIN OF FIRST NEEDED TO BEGIN SECOND ADDER//
// HENCE TO IMPROVE SPEED WE USE
/*
1. CARRY SELECT ADDER
2. CARRY LOOKAHEAD ADDER
*/

// Make a carry select adder//

module top_module ( input [31:0]a, b , output [31:0]sum );
wire cin1, cin2,cin3,cout1,cout2, cout3;
wire [15:0] sum1,sum2,sum3,mux_op;
assign cin1 = 1'b0;
assign cin2 = 1'b0;
assign cin3 = 1'b1;

add16 ins1 (.a(a[15:0]), .b(b[15:0]), .cin(cin1), . cout(cout1), . sum (sum1));
add16 ins2 (.a(a[31:16]), .b(b[31:16]), .cin(cin2), .cout(cout2), .sum (sum2));
add16 ins3 (.a(a[31:16]), .b(b[31:16]), .cin(cin3), .cout(cout3),  .sum (sum3));


always@(*)
begin
  case (cout1)
  0: mux_op = sum2;
  1: mux_op = sum3;
  endcase
end
assign sum = { mux_op, sum1};
endmodule
