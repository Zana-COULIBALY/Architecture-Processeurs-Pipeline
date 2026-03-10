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

logic [1:0][NrLines-1:0]                 line_valid_r;
logic [1:0][NrLines-1:0][TagBits-1:0]    tag_r;
logic [1:0][NrLines-1:0][LineSize-1:0]   cache_data_r;
logic [NrLines-1:0]                      lru_r;

logic [3:0]  offset_w;
logic [5:0]  index_w;
logic [21:0] tag_val_w;
logic [1:0]  offset_word_lecture_w;

logic hit0_w, hit1_w, hit_w;
logic sel_way_w;

logic [LineSize-1:0] mem_read_word_w;
logic [31:0] word_mem_w;
logic [31:0] word_cache_w;

logic miss_pending_r;
logic [5:0] miss_index_r;
logic [21:0] miss_tag_r;
logic [1:0] miss_wordoff_r;
logic victim_way_r;
logic [31:0] miss_addr_r;

always_comb begin: instruction_gestion_comb
    tag_val_w = addr_i[31:10];
    index_w   = addr_i[9:4];
    offset_w  = addr_i[3:0];
    offset_word_lecture_w = offset_w[3:2];
end

assign mem_read_word_w = mem_read_data_i;
assign word_mem_w      = mem_read_word_w[miss_wordoff_r*32 +: 32];

always_comb begin
    hit0_w = (line_valid_r[0][index_w] == 1'b1) && (tag_r[0][index_w] == tag_val_w);
    hit1_w = (line_valid_r[1][index_w] == 1'b1) && (tag_r[1][index_w] == tag_val_w);
    hit_w  = hit0_w || hit1_w;
    sel_way_w = hit1_w ? 1'b1 : 1'b0;
end

assign word_cache_w = cache_data_r[sel_way_w][index_w][offset_word_lecture_w*32 +: 32];

always_comb begin
    read_valid_o = 1'b0;
    read_word_o  = 32'b0;
    mem_read_en_o = 1'b0;
    mem_addr_o    = 32'b0;

    if (miss_pending_r) begin
        mem_read_en_o = 1'b1;
        mem_addr_o    = miss_addr_r;
        if (mem_read_valid_i) begin
            read_valid_o = 1'b1;
            read_word_o  = mem_read_data_i[miss_wordoff_r*32 +: 32];
        end
    end else if (read_en_i) begin
        if (hit_w) begin
            read_valid_o = 1'b1;
            read_word_o  = word_cache_w;
        end else begin
            mem_read_en_o = 1'b1;
            mem_addr_o    = {addr_i[31:ByteOffsetBits], {ByteOffsetBits{1'b0}}};
            if (mem_read_valid_i) begin
                read_valid_o = 1'b1;
                read_word_o  = mem_read_data_i[offset_word_lecture_w*32 +: 32];
            end
        end
    end
end

always_ff @(posedge clk_i or negedge rstn_i) begin
    if (rstn_i == 0) begin
        line_valid_r   <= '0;
        tag_r          <= '0;
        cache_data_r   <= '0;
        lru_r          <= '0;
        miss_pending_r <= 1'b0;
        miss_index_r   <= '0;
        miss_tag_r     <= '0;
        miss_wordoff_r <= '0;
        victim_way_r   <= 1'b0;
        miss_addr_r    <= '0;
    end else begin
        if (!miss_pending_r && read_en_i && !hit_w) begin
            miss_pending_r <= 1'b1;
            miss_index_r   <= index_w;
            miss_tag_r     <= tag_val_w;
            miss_wordoff_r <= offset_word_lecture_w;
            miss_addr_r    <= {addr_i[31:ByteOffsetBits], {ByteOffsetBits{1'b0}}};

            if (!line_valid_r[0][index_w])      victim_way_r <= 1'b0;
            else if (!line_valid_r[1][index_w]) victim_way_r <= 1'b1;
            else                                victim_way_r <= lru_r[index_w];
        end

        if (miss_pending_r && mem_read_valid_i) begin
            cache_data_r[victim_way_r][miss_index_r] <= mem_read_data_i;
            tag_r[victim_way_r][miss_index_r]        <= miss_tag_r;
            line_valid_r[victim_way_r][miss_index_r] <= 1'b1;
            lru_r[miss_index_r]                      <= ~victim_way_r;
            miss_pending_r                           <= 1'b0;
        end

        if (!miss_pending_r && read_en_i && hit_w) begin
            lru_r[index_w] <= ~sel_way_w;
        end
    end
end

endmodule
