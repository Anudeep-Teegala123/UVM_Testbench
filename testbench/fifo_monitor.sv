class fifo_monitor #(parameter FIFO_DEPTH = 8, parameter DATA_WIDTH = 8) extends uvm_monitor;
    `uvm_component_param_utils(fifo_monitor #(FIFO_DEPTH, DATA_WIDTH))

    uvm_analysis_port #(fifo_transaction #(FIFO_DEPTH, DATA_WIDTH)) mon_analysis_port;
    virtual fifo_if vif;

    function new(string name = "fifo_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_analysis_port = new("mon_analysis_port", this);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Couldn't retrieve the virtual interface handle")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @(posedge vif.MONITOR.clk);  // Wait for clock edge first
            if (vif.MONITOR.rst) begin  // Only proceed after reset
                // Check for write or read transaction
              if (vif.MONITOR.monitor_cb.write && !vif.MONITOR.monitor_cb.full) begin
                    fifo_transaction #(FIFO_DEPTH, DATA_WIDTH) req_item;
                    req_item = fifo_transaction#(FIFO_DEPTH, DATA_WIDTH)::type_id::create("req_item");
                    req_item.write    = vif.MONITOR.monitor_cb.write;
                    req_item.data_in  = vif.MONITOR.monitor_cb.data_in;
                    req_item.full     = vif.MONITOR.monitor_cb.full;
                    req_item.read     = vif.MONITOR.monitor_cb.read;
                    req_item.empty    = vif.MONITOR.monitor_cb.empty;
                    req_item.data_out = vif.MONITOR.monitor_cb.data_out;

                    `uvm_info(get_type_name(), $sformatf("Write Transaction: %s", req_item.convert2string()), UVM_MEDIUM)
                    mon_analysis_port.write(req_item);
                end
                else if (vif.MONITOR.monitor_cb.read && !vif.MONITOR.monitor_cb.empty) begin
                    fifo_transaction #(FIFO_DEPTH, DATA_WIDTH) req_item;
                    req_item = fifo_transaction#(FIFO_DEPTH, DATA_WIDTH)::type_id::create("req_item");
                    req_item.write    = vif.MONITOR.monitor_cb.write;
                    req_item.data_in  = vif.MONITOR.monitor_cb.data_in;
                    req_item.full     = vif.MONITOR.monitor_cb.full;
                    req_item.read     = vif.MONITOR.monitor_cb.read;
                    req_item.empty    = vif.MONITOR.monitor_cb.empty;
                    req_item.data_out = vif.MONITOR.monitor_cb.data_out;

                    `uvm_info(get_type_name(), $sformatf("Read Transaction: %s", req_item.convert2string()), UVM_MEDIUM)
                    mon_analysis_port.write(req_item);
                end
            end
        end
    endtask
endclass