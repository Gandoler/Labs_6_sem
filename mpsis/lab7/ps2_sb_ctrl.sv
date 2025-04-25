 logic [7:0] scan_code;
    logic       scan_code_is_unread;
    
    assign interrupt_request_o = scan_code_is_unread;
    // promejutki
    logic        kdata;       
    logic [7:0]  keycode_o;
    logic         keycode_valid_o;

    // Экземпляр модуля PS2Receiver
    PS2Receiver PS2Receiver_inst(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .kclk_i(kclk_i),
        .kdata_i(kdata),
        .keycodeout_o(keycode_o),
        .keycode_valid_o(keycode_valid_o)
    );

    
    always_ff @(posedge clk_i or posedge rst_i) begin
    
            if(rst_i) begin
            scan_code<= 8'b0;
        scan_code_is_unread <= 1'b0;
    end else
            
            
            if (keycode_valid_o) begin
                scan_code <= keycode_o;
                scan_code_is_unread <= 1'b1;
                
            end else if ( req_i && !write_enable_i&& addr_i==32'h0) begin

                                        read_data_o <=  scan_code;
                                        scan_code_is_unread <= 1'b0;
                                        
            end else if  (interrupt_return_i) begin
                            scan_code_is_unread <= 1'b0;
                            
            end else if   ( req_i && !write_enable_i&& addr_i==32'h04) begin
                            read_data_o <= {31'h0, scan_code_is_unread};

             end else if   ( req_i && write_enable_i && addr_i==32'h24  && write_data_i == 1'b1) begin
                           scan_code_is_unread <= 1'b0;
                           scan_code<= 1'b0;
              end

    end


  


    
     
//  

endmodule
