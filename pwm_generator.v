module pwm_generator (
    input wire clk,          // System clock
    input wire reset,        // Active-high reset
    input wire [7:0] duty,   // 8-bit duty cycle input (0 to 255)
    output reg pwm_out       // The resulting PWM square wave
);

    // 8-bit internal counter
    reg [7:0] counter;

    // Sequential logic for the counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 8'b0;
        end else begin
            counter <= counter + 1'b1; // Automatically rolls over to 0 after 255
        end
    end

    // Combinational or sequential logic for the comparator
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pwm_out <= 1'b0;
        end else begin
            // Compare the counter with the target duty cycle
            if (counter < duty) begin
                pwm_out <= 1'b1;
            end else begin
                pwm_out <= 1'b0;
            end
        end
    end

endmodule