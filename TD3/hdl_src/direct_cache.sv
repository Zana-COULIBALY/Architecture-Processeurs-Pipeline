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

//logic [31:0] addr_miss_w; 
logic [63:0] line_valid_r;
logic [63:0][22:0]tag_r; 
logic  [LineSize-1:0] cache_data_r[64]; 
logic [3:0] offset_w; 
logic [4:0] index_w; 
logic [21:0] tag_val_w; 
logic [1:0]offset_word_lecture_w;
logic hit_w;
logic [LineSize-1:0] mem_read_word_w; 
logic read_valid_w; 
logic [31:0] word_mem_w; 
always_comb begin: instruction_gestion_comb
	tag_val_w =addr_i[31:10]; 
	index_w=addr_i[9:4]; 
	offset_w=addr_i[3:0]; 
	offset_word_lecture_w= offset_w[3:2]; 
	 
end

assign mem_read_word_w=mem_read_data_i; 
assign word_mem_w=mem_read_word_w[offset_word_lecture_w*32+:32];
assign word_cache_w=cache_data_r[index_w][offset_word_lecture_w*32+:32];
assign hit_w=((tag_r[index_w]==tag_val_w)&(line_valid_r[index_w]==1'b1))  ? 1'b1: 1'b0;  

always_ff @(posedge clk_i or negedge rstn_i) begin 
	if (rstn_i ==0) begin 
		line_valid_r<='0; 
		tag_r <= '0; 
		cache_data_r<= '{default :'0};
	
	end 
	else if (mem_read_valid_i==1) begin
		cache_data_r[index_w]<= mem_read_word_w; 
		tag_r[index_w]<= tag_val_w;
		line_valid_r[index_w]<= mem_read_valid_i; 
	end 
end

/*always_ff @(posedge clk_i or negedge rstn_i) begin
	if (rstn_i ==0) begin 
		read_valid_o=0; 
	end
	else if  (hit_w==0) begin
		read_valid_o=read_valid_w; 
	end 
end */

always_comb begin 
	read_valid_o='0; 
	read_word_o='0;
	if (read_en_i) begin
		if (hit_w==1) begin
			read_valid_o=1; 
			read_word_o=cache_data_r[index_w][offset_word_lecture_w*32+:32]; 

		end 
		else begin 
			mem_read_en_o=1; 
			mem_addr_o=addr_i; 
			if (mem_read_valid_i) begin
				read_valid_o=1; 
				read_word_o=word_mem_w;
			end
		end
	end 
end  


/*


always_ff @(posedge clk_i or negedge rstn_i ) begin
	if ( rstn_i ==0) begin
		line_valid_r<='0;
		tag_r<='0; 
	end 

	else if (hit_w==1'b0) begin  // si on a un miss on écrit dans les registres du cache 
		cache_data_r[index_w]<= mem_read_data_i; 
		tag_r[index_w]<= tag_val_w;
		line_valid_r[index_w]<= mem_read_valid_i; 
	end 
end 

always_comb begin : cache_ouput_comb
	if (hit_w==1'b1 && read_en_i==1'b1) begin // on verifie le hit, le tag et le read_en
		read_valid_o=line_valid_r[index_w];
		read_word_o=cache_data_r[index_w][offset_word_lecture_w]; //on utilse que le 2bit de poids fort de l'offset 
		mem_read_en_o=1'b0; 
		

	end 
	
	else if (hit_w==1'b0 && mem_read_valid_i) begin // on verifie le hit et la validite des donnees en mem
		mem_addr_o=addr_i; 
		read_valid_o=line_valid_r[index_w]; 
		mem_read_en_o=1'b1; //il faut en la mem pour pouvoir lire les donnees 
		read_word_o=mem_read_data_i[offset_word_lecture_w]; // La mem envoie toute la ligne il faut donc selectionner le bon mot 
	end 
end */


endmodule
