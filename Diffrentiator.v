module Diffrentiator(
  input clk, n_rst,
  input  [31:0] in,
  output [31:0] out);
  
  reg [31:0] Delay1, Delay2_1, Delay2_2, Delay3;     
  reg [31:0] CMULT;
  
  wire [31:0] Z1;
  wire [31:0] Z2;
  wire [31:0] Z3;
  wire [31:0] Z4;
  
  wire [31:0] S1;
  wire [31:0] S2;
  
  //Intermediate wires
  wire [63:0] I1;
  wire [63:0] I2;
  wire [63:0] I3;
  wire [63:0] I4;
  
  
  //Multiplication outputs
  assign I1 = (in * CMULT);
  assign Z1 = I1[54:22];
  assign I2 = (Delay1 * CMULT) <<1;
  assign Z2 = I2[54:22];
  assign I3 = -(Delay2_2 * CMULT) <<1;
  assign Z3 = I3[54:22];  
  assign I4 = -(Delay3 * CMULT);
  assign Z4 = I4[54:22];
  
  //Addition outputs
  assign S1 = Z1 + Z2;
  assign S2 = S1 + Z3;
  assign out = S2 + Z4;
        
  
  //Fixed point arethmatic ( 10 bits -> integers
  //                         22 bits -> decimal ) 
  always @(posedge clk, negedge n_rst) begin
    if(!n_rst) begin
      CMULT <= 32'b0000000000_0011001101000000010100;  //0.2002
      Delay1   <= 0;
      Delay2_1 <= 0;    
      Delay2_2 <= 0;  //Take Delay2 output from here
      Delay3   <= 0;
    end
    else begin
      Delay1   <= in;
      Delay2_1 <= Delay1;
      Delay2_2 <= Delay2_1; 
      Delay3   <= Delay2_2;
     
    end
  end
endmodule
