module tb_pwm_generator;

    reg clk;
    reg reset;
    reg [7:0] duty;
    wire pwm_out;

    // Instantiate the PWM generator
    pwm_generator uut (
        .clk(clk),
        .reset(reset),
        .duty(duty),
        .pwm_out(pwm_out)
    );

    // Generate clock signal (50MHz equivalent if 10ns half-period)
    always #10 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        duty = 0;

        // Release reset
        #20;
        reset = 0;

        // Set duty cycle to 25% (roughly 64 out of 255)
        duty = 8'd64;
        #6000; // Let it run for a few cycles

        // Change duty cycle to 75% (roughly 192 out of 255)
        duty = 8'd192;
        #6000;

        $finish;
    end

endmodule