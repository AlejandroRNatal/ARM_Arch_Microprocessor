
`define BYTE 2'b00
`define WORD 2'b10
`define HALFWORD 2'b01
`define START_ADDRESS 7'b0000000


module ram_256_b(input [31:0]data, input [6:0]address,
                 input w_r, input enable, input [1:0] access_mode,
                 output reg state, output reg[31:0] mem);
    reg [31:0] storage[0:255]; 

    integer fo, file_descriptor;
    always @(posedge enable, w_r)
        begin
        state =1'b0;
            if (enable)//High -> we are being requested
                begin
                    if(w_r)//HIGH -> read mode
                        case(access_mode)
                            `BYTE://byte
                                begin
                                    mem[7:0] <= storage[address];
                                    mem[31:8] <= 24'b0;
                                    state = 1'b1;
                                end
                            
                            `HALFWORD://// halfword(16-bit)
                                begin
                                    mem[15:8] <= storage[address];
                                    mem[7:0] <= storage[address + 1];
                                    mem[31:16] <= 16'b0;//padding the rest
                                    state = 1'b1;
                                end
                          
                            `WORD:  // word (32-bit)
                                begin
                                   mem[31:24] <= storage[address];
                                    mem[23:16] <= storage[address+1];
                                    mem[15:8] <= storage[address+2];
                                    mem[7:0] <= storage[address+3];
                                    state = 1'b1;
                                end

			//last case is don't care
                        endcase
                    else //write mode
                        case(access_mode)
                            // Byte
                            `BYTE:
                            begin
				                 storage[address] = data[7:0];
                                 state = 1'b1;
                                 end
                            // Halfword
                            `HALFWORD:
                                begin
                                    storage[address] = data[15:8];
                                    storage[address + 1] = data[7:0];
                                    state = 1'b1;
                                end
                            // Word
                            `WORD:
                                begin
                                    storage[address] = data[31:24];
                                    storage[address+1] = data[23:16];
                                    storage[address+2] = data[15:8];
                                    storage[address+3] = data[7:0];
                                    state = 1'b1;
                                end
                            default: begin
				                 storage[address] = data[7:0];
                                 state = 1'b1;
                            end
                        endcase
                    state =1'b1;
                end
            else
                begin
                    state = 1'b0;
                end

                #5 state = 1'b0;
        end



endmodule


module ram_interact();
    integer file_in, file_out, file_status, i;
    reg [31:0] data;
	reg enable, w_r;
    reg [31:0] data_in;
	reg [6:0] address;
    reg[1:0] mode;
    wire [31:0] data_output;
	wire MOC;
	
    ram_256_b ram (data, address, w_r, enable, mode, MOC,data_output);
	
    initial begin
		file_in = $fopen("data.txt","r");
		address =  `START_ADDRESS;
		while (!$feof(file_in)) begin
			file_status = $fscanf(file_in, "%d", data);
			ram.storage[address] = data;
			$display("Memory address: %h \n Data: %h", address, data);
			address = address + 1;
		end
		$fclose(file_in);
	end

	initial begin
		file_out = $fopen("memory.txt", "w");
		enable = 1'b0; w_r = 1'b1;
		address = #1 `START_ADDRESS;

        for(i =0; i  < 16; i = i+1)
        begin
         $display("\n\nWrite/Read: %b\nEnable:%b\nMode:%2b\n availability:%b\n", w_r, enable, mode, MOC);   
            #5 enable = 1'b1;

            #5 enable = 1'b0;
            address = address + 1;
           
            if(i == 0)
                mode <= `BYTE;
            if(i == 2)
                mode <= `HALFWORD;
            if(i == 4)
                mode <= `HALFWORD;
            if(i == 8)
                mode <= `WORD;
            else
                mode <= `BYTE;
            
        end

        //$fclose(file_out);
		$finish;
	end

	always @ (posedge enable)
	begin
	    #1;
	    $fdisplay(file_out,"Address: %d |data: %h", address, data_output);
	end

endmodule