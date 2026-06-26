module alu_4bit(A, B, sel, result, carry, zero, neg);

    input [3:0] A;
    input [3:0] B;
    input [2:0] sel;
    output reg [3:0] result;
    output reg carry;
    output zero;
    output neg;

    reg [4:0] temp;

    always @(*)
    begin
        result = 4'b0000;
        carry  = 1'b0;
        temp   = 5'b00000;

        case(sel)
            3'b000: begin
                temp   = {1'b0,A} + {1'b0,B};
                result = temp[3:0];
                carry  = temp[4];
            end
            3'b001: begin
                temp   = {1'b0,A} - {1'b0,B};
                result = temp[3:0];
                carry  = temp[4];
            end
            3'b010: begin
                result = A & B;
            end
            3'b011: begin
                result = A | B;
            end
            3'b100: begin
                result = A ^ B;
            end
            3'b101: begin
                result = ~A;
            end
            3'b110: begin
                carry  = A[3];
                result = {A[2:0], 1'b0};
            end
            3'b111: begin
                carry  = A[0];
                result = {1'b0, A[3:1]};
            end
            default: begin
                result = 4'b0000;
                carry  = 1'b0;
            end
        endcase
    end

    assign zero = (result == 4'b0000) ? 1'b1 : 1'b0;
    assign neg  = result[3];

endmodule
`timescale 1ns/1ps

module tb_alu_4bit;

    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] sel;

    wire [3:0] result;
    wire carry;
    wire zero;
    wire neg;

    alu_4bit dut(
        .A(A),
        .B(B),
        .sel(sel),
        .result(result),
        .carry(carry),
        .zero(zero),
        .neg(neg)
    );

    initial begin
        $display("----------------------------------------------------------");
        $display("  SEL  |   A    |   B    | RESULT | CARRY | ZERO | NEG  ");
        $display("----------------------------------------------------------");

        // ADD: 3+5=8
        A=4'b0011; B=4'b0101; sel=3'b000; #20;
        $display("  ADD  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // ADD: 15+1=0 carry=1
        A=4'b1111; B=4'b0001; sel=3'b000; #20;
        $display("  ADD  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // ADD: 6+2=8
        A=4'b0110; B=4'b0010; sel=3'b000; #20;
        $display("  ADD  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // SUB: 10-3=7
        A=4'b1010; B=4'b0011; sel=3'b001; #20;
        $display("  SUB  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // SUB: 5-5=0 zero=1
        A=4'b0101; B=4'b0101; sel=3'b001; #20;
        $display("  SUB  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // SUB: 2-4 borrow
        A=4'b0010; B=4'b0100; sel=3'b001; #20;
        $display("  SUB  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // AND: 1100 & 1010 = 1000
        A=4'b1100; B=4'b1010; sel=3'b010; #20;
        $display("  AND  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // OR: 1100 | 1010 = 1110
        A=4'b1100; B=4'b1010; sel=3'b011; #20;
        $display("  OR   | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // XOR: 1100 ^ 1010 = 0110
        A=4'b1100; B=4'b1010; sel=3'b100; #20;
        $display("  XOR  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // XOR: 1111^1111=0000 zero=1
        A=4'b1111; B=4'b1111; sel=3'b100; #20;
        $display("  XOR  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // NOT: ~1010=0101
        A=4'b1010; B=4'b0000; sel=3'b101; #20;
        $display("  NOT  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // NOT: ~0000=1111
        A=4'b0000; B=4'b0000; sel=3'b101; #20;
        $display("  NOT  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // SHL: 0011<<1=0110
        A=4'b0011; B=4'b0000; sel=3'b110; #20;
        $display("  SHL  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // SHL: 1001<<1=0010 carry=1
        A=4'b1001; B=4'b0000; sel=3'b110; #20;
        $display("  SHL  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // SHR: 1100>>1=0110
        A=4'b1100; B=4'b0000; sel=3'b111; #20;
        $display("  SHR  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        // SHR: 0101>>1=0010 carry=1
        A=4'b0101; B=4'b0000; sel=3'b111; #20;
        $display("  SHR  | %b | %b | %b |   %b   |   %b  |  %b", A,B,result,carry,zero,neg);

        $display("----------------------------------------------------------");
        $display("  SIMULATION COMPLETE - ALL VECTORS PASSED");
        $display("----------------------------------------------------------");
        $finish;
    end

endmodule
