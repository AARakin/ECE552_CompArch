module cache_fill_FSM(clk, rst_n, miss_detected, miss_address, fsm_busy, 
		      write_data_array, write_tag_array,memory_address, 
                      memory_data, memory_data_valid);

input clk, rst_n;
input miss_detected; // active high when tag match logic detects a miss
input [15:0] miss_address; // address that missed the cache
input [15:0] memory_data; // data returned by memory (after  delay)
input memory_data_valid; // active high indicates valid data returning on memory bus
output fsm_busy; // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
output write_data_array; // write enable to cache data array to signal when filling with memory_data
output write_tag_array; // write enable to cache tag array to signal when all words are filled in to data array
output [15:0] memory_address; // address to read from memory

// Counter Signals
wire overflow_out; // Unused
wire [2:0] count_in, count_out, count_plus_one;

// State Machine Setup
wire curr_state; // Current state output of the flop
wire nxt_state; // Next output for the flop
wire idle_to_wait;
wire wait_to_wait;
wire wait_to_idle;

///////////////////
// State Machine //
///////////////////
// State Machine input signals
// Idle to wait transition
assign idle_to_wait = (curr_state == 1'b0) & miss_detected;
// Stay in wait 
assign wait_to_wait = (curr_state == 1'b1) & ~wait_to_idle;
// Transition back to idle
assign wait_to_idle = (curr_state == 1'b1) & memory_data_valid; // These might not be used actually

assign nxt_state = (curr_state == 1'b0) ? (miss_detected) : (~(&count_out));
assign fsm_busy  = (curr_state == 1'b0) ? (miss_detected) : 1'b1;

// State 0 Idle State
// State 1 Wait State
dff State_flop(.q(curr_state), .d(nxt_state), .wen(1'b1), .clk(clk), .rst(~rst_n));
// Description: Miss is detected, then bring in the correct block from memory into the cache
// 8 chunks of data (sequentially)

/////////////
// Counter //
/////////////
// Count for eight cycles
// Only increment counter if we are in wait and memory data is valid
assign counter_in = (curr_state & memory_data_valid) ? count_plus_one : 
		(curr_state == 1'b0 & nxt_state == 1'b1) ? 1'b0 : count_out;
// Perform the increment
adder_3_bit adder_3_bit(.sum(count_plus_one), .A(counter_in), .B(1'b1), .ovfl_out(overflow_out));

// Hold the count
dff_3bit count_flop(.q(count_out), .d(count_in), .wen(1'b1), .clk(clk), .rst_n(rst_n));

////////////
// Memory //
////////////
// becomes one after the first valid data, stays until data is invalid
assign write_data_array = (curr_state & memory_data_valid);

// Only write tag on the 8th cycle
assign write_tag_array = (curr_state & (&count_out));

endmodule



