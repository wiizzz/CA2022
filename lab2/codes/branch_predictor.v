module branch_predictor
(
    clk_i, 
    rst_i,
    Branch_i,

    update_i,   //input X
	result_i,   //current state
	predict_o   // next state Z
);
input clk_i, rst_i, update_i, result_i, Branch_i;
output predict_o;

reg [1:0] history;
reg   predict_o;

// TODO
always @(*) begin
    if(history == 2'b11 || history == 2'b10)begin
        predict_o = 1;
    end
    else begin
        predict_o = 0;
    end
end

always@(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        history = 2'b11;
    end  
    else if(Branch_i)begin
        if(update_i == result_i)begin
            if (history == 2'b11 || history == 2'b10) begin
                history = 2'b11;
            end
            else if(history == 2'b01 || history == 2'b00)begin
                history = 2'b00;
            end
        end
        else begin
            if(history == 2'b11)begin
                history = 2'b10;
            end
            else if(history == 2'b10)begin
                history = 2'b01;
            end
            else if(history == 2'b01)begin
                history = 2'b10;
            end
            else if(history == 2'b00)begin
                history = 2'b01;
            end
        end
    end
end

endmodule
