//This is a linear testbench in System Verilog to implement the below testcases for the DPRAM.sv design

//Test1 : driving one full packet(covering all the address locations linearly in the memory) and performing write operation followed by read operation.

//Test2 : driving a bunch of packets(each packet covers the write opeartion followed by read operation for all the address locations linearly in the memory)

//Test3 : Simultaneous write and read opertions with a unique write address and read address location in the memory

//Test4 : Simultaneous write and read operations with same write address and read address location in the memory

//Test5 : driving full packet(covering all the address locations randomly in the memory) and performing write operation followed by read operation

//Test6 : driving a bunch of packets(each packet covers the write and read operation for all the address locations randomly in the memory)

//Including Top and Interface modules
`include "top.sv"
`include "interface.sv"
//packet class to generate random addresses for test5 and test6
`include "packet5_6.sv" 

program testbench(input clk,intf vif);
  integer run;
  bit [7:0] in_q[$];
  bit [7:0] out_q[$];
  bit [7:0] in;
  bit [7:0] out;
  bit [7:0] in_data;
  integer success,failures;
  
  typedef struct{
    bit [3:0] w_addr,r_addr;
    bit [7:0] in_data;
  } packet;
  
  
  //task to preset the driving outputs from testbench
  task preset();
    vif.cb.wr_en <= 0;
    vif.cb.rd_en <= 0;
    vif.cb.wr_addr <= 0;
    vif.cb.rd_addr <= 0;
    vif.cb.data_in <= 0;
  endtask 
  
  //task to apply reset; Synchronous reset
  task apply_reset();
    begin
      vif.reset <= 1;
      repeat(2) @(vif.cb);
      vif.reset <= 0;
    end
  endtask
  
  
  //Task to generate stimulus for test1 and test2 and copying into the queues for comparison
  task generate_stimulus_1_2(ref bit [7:0] in_q[$],out_q[$]); 
    begin
      vif.cb.wr_en <= 1;
      in_q.delete();
      
      for(int i = 0;i < 16;i++)
        begin
          in_data <= $urandom;
          vif.cb.data_in <= in_data;
          vif.cb.wr_addr <= i;
          in_q.push_back(in_data);
          @(vif.cb);
        end
          
      vif.cb.wr_en <= 0;
      @(posedge clk);
          
      vif.cb.rd_en <= 1;
      out_q.delete();
      for(int j = 0;j < 16;j++)
        begin
          vif.cb.rd_addr <= j;
          @(vif.cb);
          out_q.push_back(vif.cb.data_out);
        end  
          
      vif.cb.rd_en <= 0;
      @(posedge clk);
    end
  endtask
  
  
  //function to generate stimulus for test3
  function automatic void generate_stimulus_3(ref packet pkt);
        pkt.w_addr = $urandom_range(0,15);
        pkt.r_addr = pkt.w_addr;
        pkt.in_data = $urandom;
  endfunction
  
  //function to generate stimulus for test4
  function automatic void generate_stimulus_4(ref packet pkt);
        pkt.w_addr = $urandom_range(0,15);
        pkt.r_addr = pkt.w_addr;
  endfunction
  
  //Driving function used for task3
  task drive_3(ref packet pkt,ref bit [7:0] in_q[$],out_q[$]); 
    begin
          vif.cb.wr_en <= 1;
          vif.cb.rd_en <= 1;
          in_q.delete();
          vif.cb.data_in <= pkt.in_data;
          vif.cb.wr_addr <= pkt.w_addr;
          vif.cb.rd_addr <= pkt.r_addr;
          in_q.push_back(pkt.in_data);
          @(vif.cb);
          
          //vif.cb.wr_en <= 0;
          //@(posedge clk);
          
      

          out_q.delete();
          @(vif.cb);
          out_q.push_back(vif.cb.data_out);
      
          //vif.cb.rd_en <= 0;
          //@(posedge clk);
    end
  endtask
  
  //Driving function used for task4
  task drive_4(ref packet pkt,ref bit [7:0] in_q[$],out_q[$]); 
    begin
      in_q.delete();
      vif.cb.wr_en <= 1;
      vif.cb.rd_en <= 1;
      vif.cb.data_in <= pkt.in_data;
      vif.cb.wr_addr <= pkt.w_addr;
      vif.cb.rd_addr <= pkt.r_addr;
      in_q.push_back(pkt.in_data);
      @(vif.cb);
      out_q.delete();    
      @(vif.cb);
      out_q.push_back(vif.cb.data_out);
    end
  endtask
  
  //Simple comparison function to validate data_in and data_out 
  function bit compare(ref bit [7:0]in,out);
    if(in == out)
      return 1;
    return 0;    
  endfunction
  
  
  //Result function used for test1 and test2
  function automatic result_1_2_5_6(integer success);
    bit [15:0] matched,mismatched;
    foreach(in_q[i])
      begin
        if(compare(in_q[i],out_q[i]))
           begin
             matched++;
             //$display("Matched %0d : input = %h, output = %h",i,in_q[i],out_q[i]);
           end
        
        else
          begin
            mismatched++;
            $display("Test_1_2_5_6 Failed");
            $display("Mismatched %0d : input = %h, output = %h",i,in_q[i],out_q[i]);
          end
      end
    
    if(matched == 16)
      begin
        //$display("[INFO]************Test Passed*********");
        //$display("[INFO] *Matched = %0d, Mismatched = %0d",matched,mismatched);
        success = success + 1;
      end
    else
      begin
        $display("[INFO]************Test_1_2_5_6 Failed*********");
        $display("[INFO] *Matched = %0d, Mismatched = %0d",matched,mismatched);
        failures = failures + 1;
      end
    
    return success;
  endfunction
   
 
  //Result function used for test3 and test4
  function automatic result_3_4(integer success);
    bit [15:0] matched,mismatched;
    foreach(in_q[i])
      begin
        if(compare(in_q[i],out_q[i]))
           begin
             matched++;
             //$display("Matched %0d : input = %h, output = %h",i,in_q[i],out_q[i]);
           end
        
        else
          begin
            mismatched++;
            $display("Mismatched %0d : input = %h, output = %h",i,in_q[i],out_q[i]);
          end
      end
    
    if(matched == 1)
      begin
        //$display("[INFO]************Test Passed*********");
        //$display("[INFO] *Matched = %0d, Mismatched = %0d",matched,mismatched);
        success = success + 1;
      end
    else
      begin
        $display("[INFO]************Test Failed_3_4*********");
        $display("[INFO] *Matched = %0d, Mismatched = %0d",matched,mismatched);
        failures = failures + 1;
      end
    return success;
    
  endfunction
  
  //Test1 : driving full packet(covering all the address locations linearly in the memory) and performing write and read operations
  task testcase1();
    integer s1;
    begin
      preset();
      apply_reset();
      generate_stimulus_1_2(in_q,out_q);
      s1 = result_1_2_5_6(success);
      if(s1 == 1)
        $display("testcase1 passed");
      else
        begin
          $display("testcase1 failed");
          $display(s1);
        end
    end
  endtask
  
  //Test2 : driving a bunch of packets(each packet covers the write and read operation for all the address locations linearly in the memory)
  task testcase2();
    integer s1;
    bit [15:0] check=0;
    begin
      preset();
      apply_reset();
      repeat(run)
        begin
          generate_stimulus_1_2(in_q,out_q);
          s1 = result_1_2_5_6(success);
          if(s1 == 1)
            check = check + s1;
        end
      if(check == run)
        begin
          $display("testcase2 passed");
          check = 0;
        end
      else
        begin
          $display("testcase2 failed");
          $display("[INFO] *tests generated = %d, *tests passed = %d", run, check);
        end
    end
  endtask
  
  
  //Test3 : Simultaneous write and read opertions with random address locations in the memory
  
  task testcase3();
    packet pkt;
    integer s1;
    bit [15:0] check=0;
    begin
      preset();
      apply_reset();
      repeat(run)
        begin
          generate_stimulus_3(pkt);
          drive_3(pkt,in_q,out_q);
          s1 = result_3_4(success);
          if(s1 == 1)
            check = check + s1;
        end
    if(check == run)
      begin
        $display("testcase3 passed");
        check = 0;
      end
    else
      begin
        $display("testcase3 failed");
        $display("[INFO] *tests generated = %d, *tests passed = %d", run, check);
      end
    end
  endtask
  
  //Test4 : Simultaneous write and read operations with a unique address location in the memory
  task testcase4();
    packet pkt;
    integer s1;
    bit [15:0] check=0;
    begin
      preset();
      apply_reset();
      generate_stimulus_4(pkt);
      repeat(run)
        begin
          pkt.in_data = $urandom;
          drive_4(pkt,in_q,out_q);
          s1 = result_3_4(success);
          if(s1 == 1)
            check = check + s1;
        end
      if(check == run)
        begin
          $display("testcase4 passed");
          check = 0;
        end
      else
        begin
          $display("testcase4 failed");
          $display("[INFO] *tests generated = %d, *tests passed = %d", run, check);
        end     
    end
  endtask
  
  //Test5 : driving full packet(covering all the address locations randomly in the memory) and performing write and read operations
  task testcase5();
    packet5_6 pkt; //Class handle
    bit [3:0] addr_qu[$];
    integer s1;
    begin
      preset();
      apply_reset();
      pkt = new;
      in_q.delete();
      addr_qu.delete();
      repeat(16) 
        begin
          if(pkt.randomize())
            begin
              vif.cb.wr_en <= 1;
              vif.cb.wr_addr <= pkt.wr_addr;
              addr_qu.push_back(pkt.wr_addr);
              vif.cb.data_in <= pkt.data_in;
              in_q.push_back(pkt.data_in);
              @(vif.cb);
            end
        end
      vif.cb.wr_en <= 0;
      @(posedge clk);
      vif.cb.rd_en <= 1;
      out_q.delete();
      for(int j = 0;j < addr_qu.size();j++)
        begin
          vif.cb.rd_addr <= addr_qu[j];
          @(vif.cb);
          out_q.push_back(vif.cb.data_out);
        end
      vif.cb.rd_en <= 0;
      @(posedge clk);
      s1 = result_1_2_5_6(success);
      if(s1 == 1)
        $display("testcase5 passed");
      else
        begin
          $display("testcase5 failed");
          $display(s1);
        end
    end
  endtask
 
  
  //Test6 : driving a bunch of packets(each packet covers the write and read operation for all the address locations randomly in the memory)
  task testcase6();
    packet5_6 pkt; //Class handle
    integer s1;
    bit [15:0] check=0;
    bit [3:0] addr_qu[$];
    begin
      preset();
      apply_reset();
      pkt = new;
      repeat(run)
        begin
          in_q.delete(); 
          addr_qu.delete();
          repeat(16) 
            begin
              if(pkt.randomize())
                begin
                  vif.cb.wr_en <= 1;
                  vif.cb.wr_addr <= pkt.wr_addr;
                  addr_qu.push_back(pkt.wr_addr);
                  vif.cb.data_in <= pkt.data_in;
                  in_q.push_back(pkt.data_in);
                  @(vif.cb);
                end
            end
          vif.cb.wr_en <= 0;
          @(posedge clk);
          vif.cb.rd_en <= 1;
          out_q.delete();
          for(int j = 0;j < addr_qu.size();j++)
            begin
              vif.cb.rd_addr <= addr_qu[j];
              @(vif.cb);
              out_q.push_back(vif.cb.data_out);
            end
          vif.cb.rd_en <= 0;
          @(posedge clk);
          s1 = result_1_2_5_6(success);
          if(s1 == 1)
            check = check + s1;
        end
      if(check == run)
        begin
          $display("testcase6 passed");
          check = 0;
        end
      else
        begin
          $display("testcase6 failed");
          $display("[INFO] *tests generated = %d, *tests passed = %d", run, check);
        end
    end
  endtask
  
  //Testing all testcases
  task all_tests();
    testcase1();
    testcase2();
    testcase3();
    testcase4();
    testcase5();
    testcase6();  
  endtask
  
  initial
    begin
      success = 0; failures = 0; run = 40;
      //testcase1();
      //testcase2();
      //testcase3();
      testcase4();
      //testcase5();
      //testcase6();
      //all_tests();
      $finish;
    end
  
endprogram 


