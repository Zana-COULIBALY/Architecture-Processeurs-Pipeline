module cache #(
    localparam ByteOffsetBits = 4,
    localparam IndexBits = 6,
    localparam TagBits = 22,

    localparam NrWordsPerLine = 4,
    localparam NrLines =64,

    localparam LineSize = 32 * NrWordsPerLine
) (
    input logic clk_i,
    input logic rstn_i,

    // pipeline instruction read port
    input logic [31:0] addr_i,
    input logic read_en_i,
    output logic read_valid_o,
    output logic [31:0] read_word_o,

    // Memory
    output logic [31:0] mem_addr_o,

    // Main memory interface
    output logic mem_read_en_o,
    input logic mem_read_valid_i,
    input logic [LineSize-1:0] mem_read_data_i
);

logic [31:0] addr_miss_w; 
logic [63:0] line_valid_r;
logic [63:0][22:0]tag_r; 
logic  [31:0] cache_data_r[64][4]; 
logic [3:0] offset_w, offset_miss_w; 
logic [4:0] index_w, index_miss_w; 
logic [21:0] tag_val_w, tag_val_miss_w; 
logic [1:0]offset_word_lecture_w, offset_word_lecture_miss_w;
logic hit_w, miss_w; 


always_comb begin: instruction_gestion_comb
	tag_val_w =addr_i[31:10]; 
	index_w=addr_i[9:4]; 
	offset_w=addr_i[3:0]; 
	offset_word_lecture_w= offset_w[1:0]; 
	 
end

typedef enum {start, hit_state, miss_st}
always_comb begin: hit_miss_comb
	hit_w=((tag_r[index_w]==tag_val_w)&(line_valid_r[index_w]==1'b1)&(miss_w!=1'b1))  ? 1'b1: 1'b0;  
end

always_ff @(posedge clk_i or negedge rstn_i) begin 
	if (rstn_i ==0) begin 
		line_valid_r<='0; 
		tag_r <= '0; 
	end 
	else if (mem_read_valid_i==1) begin
		cache_data_r[index_w]<= mem_read_data_i; 
		tag_r[index_w]<= tag_val_w;
		line_valid_r[index_w]<= mem_read_valid_i; 
	end 
end
 
