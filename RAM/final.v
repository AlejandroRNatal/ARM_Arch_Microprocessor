
`define BYTE 2'b00
`define WORD 2'b10
`define HALFWORD 2'b01
`define START_ADDRESS 8'b00000000


module ram_256_b(input [31:0]data, input [7:0]address,
                 input w_r, input enable, input [1:0] access_mode,
                 output reg state, output reg[31:0] mem);
    // reg [31:0] storage[0:255]; 
    reg[7:0] storage[0:511];//512 bytes
    integer fo, file_descriptor;

    always @(posedge enable, w_r)

        begin
        //state =1'b0;
            
            if (enable)//High -> we are being requested
                begin
                    state = 1'b0;
                    if(w_r)//HIGH -> read mode
                        case(access_mode)
                            `BYTE://byte
                                begin
                                    mem[7:0] <= storage[address];
                                    mem[31:8] <= 24'h000000;
                                    // state = 1'b1;
                                end
                            
                            `HALFWORD://// halfword(16-bit)
                                begin
                                    mem[15:8] <= storage[address];
                                    mem[7:0] <= storage[address + 1];
                                    mem[31:16] <= 16'h0000;//padding the rest
                                    // state = 1'b1;
                                end
                          
                            `WORD:  // word (32-bit)
                                begin
                                   mem[31:24] <= storage[address];
                                    mem[23:16] <= storage[address+1];
                                    mem[15:8] <= storage[address+2];
                                    mem[7:0] <= storage[address+3];
                                    //state = 1'b1;
                                end

			//last case is don't care
                        endcase

                    else //write mode
                    begin
                        case(access_mode)

                            // Byte
                            `BYTE:
                            begin
				                 storage[address] = data[7:0];
                                //  state = 1'b1;
                                 end

                            // Halfword
                            `HALFWORD:
                                begin
                                    storage[address] = data[15:8];
                                    storage[address + 1] = data[7:0];
                                    //state = 1'b1;
                                end

                            // Word
                            `WORD:
                                begin
                                    storage[address] = data[31:24];
                                    storage[address+1] = data[23:16];
                                    storage[address+2] = data[15:8];
                                    storage[address+3] = data[7:0];
                                    //state = 1'b1;
                                end

                            default: begin
				                 storage[address] = data[7:0];
                                 state = 1'b1;
                            end

                        endcase
                        state =1'b1;//state = 1;
                    end

                end
                  
        end



endmodule


module ram_interact();
    integer file_in, file_out, file_status, i;
    reg [31:0] data;
	reg enable, w_r;
    reg [31:0] data_in;
	reg [7:0] address;
    reg[1:0] mode;
    wire [31:0] data_output;
	wire MOC;
	
    ram_256_b ram(data, address, w_r, enable, mode, MOC,data_output);
	
    initial begin
		file_in = $fopen("data.txt","r");
        w_r = 1'b0;
        mode = `WORD;
		address =  9'b000000000;
		while (!$feof(file_in)) begin
			file_status = $fscanf(file_in, "%d", data);
			ram.storage[address] = data;
			//$display("Memory address: %h \n Data: %h", address, data);
			address = address + 1;
		end
		$fclose(file_in);
	end

	initial begin
		//file_out = $fopen("memory.txt", "w");
        $display("ADDRESS\t\t|VALUE\t\t|Time\t|ENABLE\t|MOC\t|R/W");
        mode  = `WORD;
		enable = 1'b0; w_r = 1'b1;
		address =  9'b000000000;

        repeat(4) begin
        #5 enable = 1'b1;//one tick
        #5 enable = 1'b0;

            begin
                case(mode)
                    `WORD:
                        begin
                            address =address + 4;
                        end
                    
                    `HALFWORD:
                        begin
                            address = address + 2;
                        end
                    
                    `BYTE:
                        begin
                            address = address + 1;
                        end
                endcase
            end


        end

    end

        always@(posedge enable)
        begin
            #1 $display(" ADDRESS:%h | %b %b %b %b", address,data_output,enable, MOC,w_r);
        end


        initial begin
            #40;
            $display(" Enable MOC W/R");
            address = 0;
            enable=0;
            enable=1;
            w_r=0;
            mode = `BYTE;
            data_in = 8'hCC;

            #10;
            $display("\n Write byte %h to ram", data_in);
            $display("\n Value in Address %h : %h\t%b\t%b\t\t%b", address,ram.storage[address],enable,w_r,MOC);

            address = 2;
            enable=0;
            enable=1;
            w_r=0;
            mode = `HALFWORD;
            data_in = 16'hCACA;

            #10;
            $display("\n Write byte %h to ram", data_in);
            $display("\n Value in Address %h : %h\t%b\t%b\t\t%b", address,ram.storage[address],enable,w_r,MOC);
            address = address + 1;
            $display("\n Value in Address %h : %h\t%b\t%b\t\t%b", address,ram.storage[address],enable,w_r,MOC);
        
            address = 4;
            enable=0;
            enable=1;
            w_r=0;
            mode = `HALFWORD;
            data_in = 16'hBABA;

            #10;
            $display("\n Write byte %h to ram", data_in);
            $display("\n Value in Address %h : %h\t%b\t%b\t\t%b", address,ram.storage[address],enable,w_r,MOC);
            address = address + 1;
            $display("\n Value in Address %h : %h\t%b\t%b\t\t%b", address,ram.storage[address],enable,w_r,MOC);            

            address = 8;
            enable=0;
            enable=1;
            w_r=0;
            mode = `WORD;
            data_in = 32'hCACABABA;

            #10;
            $display("\n Write byte %h to ram", data_in);
            $display("\n Value in Address %h : %h\t%b\t%b\t\t%b", address,ram.storage[address],enable,w_r,MOC);
            address = address + 1;
            $display("\n Value in Address %h : %h\t%b\t%b\t\t%b", address,ram.storage[address],enable,w_r,MOC);            
            address = address + 1;
            $display("\n Value in Address %h : %h\t%b\t%b\t\t%b", address,ram.storage[address],enable,w_r,MOC);            
            address = address + 1;
            $display("\n Value in Address %h : %h\t%b\t%b\t\t%b", address,ram.storage[address],enable,w_r,MOC);            
 

            $display("\n\t\t\t ENABLE\tMOC\tW/R");
            
            
		enable=0;enable=1;
		w_r=1;
		mode = `BYTE;
		address=0;		
		#10
		$display("\nReading Byte in Address 0.\nData is: %h\t\t%b\t%b\t%b", data_output, enable, w_r, MOC);

		enable=0;enable=1;
		w_r=1;
		mode= `HALFWORD;
		address=2;
		#10
		$display("\nReading Halfword in Address 2.\nData is: %h\t\t%b\t%b\t%b", data_output, enable, w_r, MOC);

		enable=0;enable=1;
		w_r=1;
		mode= `HALFWORD;
		address=4;
		#10
		$display("\nReading Halfword in Address 4.\nData is: %h\t\t%b\t%b\t%b", data_output, enable, w_r, MOC);

		enable=0;
        enable=1;
		w_r=1;
		mode=`WORD;
		address = 8;
		#10;
		$display("\nReading Word in Address 8.\nData is: %h\t\tb\t%b\t%b", data_output, enable, w_r, MOC);
		
		enable=0;enable=1;
		w_r=1;
		mode=`WORD;
		address = 0;
		#10;
		$display("\nReading Word in Address 0.\nData is: %h\t\t%b\t %b\t%b", data_output, enable, w_r, MOC);
		
		enable=0;
        enable=1;
		w_r=1;
		mode=`WORD;
		address = 4;
		#10;
		$display("\nReading Word in Address 4.\nData is: %h\t\t%b\t%b\t%b", data_output, enable, w_r, MOC);
		
		enable=0;
        enable=1;
		w_r=1;
		mode=`WORD;
		address = 8;
		#10;
		$display("\nReading Word in Address 8.\nData is: %h\t\t%b\t%b\t %b", data_output, enable, w_r, MOC);
		
		$finish;
        end

endmodule
