class fifo_driver extends uvm_driver #(fifo_transaction);
	`uvm_component_utils(fifo_driver)	
    virtual fifo_if vif;
	
	function new(string name="fifo_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual fifo_if)::get(this,"","vif",vif)) begin
			`uvm_fatal(get_type_name (),"Couldn't retrieve the virtual interface handle");
		end
	endfunction
	
	virtual task run_phase(uvm_phase phase);	
		super.run_phase (phase); 
		$display("Starting UVM Driver Run phase...");
		
		forever begin
			fifo_transaction req_item;
			seq_item_port.get_next_item(req_item);
			@(posedge vif.DRIVER.clk);
			if(req_item.write) begin 
				vif.DRIVER.driver_cb.write <= req_item.write;
				vif.DRIVER.driver_cb.data_in <= req_item.data_in;
				vif.DRIVER.driver_cb.read <= req_item.read;
			end
			
			else if(req_item.read) begin 				
				vif.DRIVER.driver_cb.read <= req_item.read;	
				vif.DRIVER.driver_cb.write <= req_item.write;
			end
			
			seq_item_port.item_done(req_item);
		end
	endtask
endclass	