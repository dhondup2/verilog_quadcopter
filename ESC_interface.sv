module ESC_interface(clk, rst_n, SPEED, OFF, PWM);

input clk, rst_n;
input [10:0] SPEED;
input [9:0] OFF;
output PWM;

logic PWM;
logic [11:0] compensated_speed;
logic [20:0] timer;       // 20-bit timer to set the rising edge of pwm
logic [16:0] setting;       // Set the upperbound of the counter
logic rst;                  // rst triggered by the timer. rst the PWM ff
logic set;                  // set trriger by the timer. set the PWM to 1 at end of 20 ms(puls period)
logic [20:0] count;               // input to the timer; eclipsed time ticks

// left shift compensated_speed by 2 bits
// given 50 MHz clk (20 ns/cycle), 20ns * 16 = 32 us
// With 1 increment of SPEED or count, the timer increase
// by 32 us
// We do the left shift when assignning "setting"
assign compensated_speed = SPEED + OFF;

// By default, if both SPEED and OFF are 0, PWM width is 1ms.
// Given 50 MHZ clk, we need 0d50000 cycles
assign setting = (~compensated_speed) ? 17'd50000 : {0, compensated_speed << 2};

assign rst = (count[16:0] >= setting) ? 1'b1 :1'b0;
assign set = &count;
// Counter
always_ff@(posedge clk, negedge rst_n)
    if(~rst_n)
        count <= 20'b0;
    else 
        count <= count + 1;

// PWM ff
always_ff@(posedge clk, negedge rst_n)
    if(~rst_n)
        PWM <= 1'b0;
    else if(rst)
        PWM <= 1'b0;
    else if(set)
        PWM <= 1'b1;

endmodule


