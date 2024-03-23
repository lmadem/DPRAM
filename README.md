# DPRAM
Design and Verification of Dual-Port RAM in System Verilog environment. The main intension of this repository is to document the verification plan and test case implementation in System Verilog testbench environment

<details>
  <summary> Defining the black box design of DUAL-PORT RAM </summary>

  ### In simple terms, DPRAM is a random-access memory that supports write and read operations at the same time

  <li> Input Ports : clk, reset, wr_en, rd_en, wr_addr, rd_addr, data_in </li>

  <li> Output Ports : data_out </li>

  #### Input Signals Description

  <li> clk     : clock </li>
  <li> reset   : Synchronous reset </li>
  <li> wr_en   : Write enable control signal, active high </li>
  <li> rd_en   : Read enable control signal, active high </li>
  <li> wr_addr : 4 bit write address </li>
  <li> rd_addr : 4 bit read address </li>
  <li> data_in : 8 bit data input </li>

  #### Output Signals Description

  <li> data_out : 8 bit data output </li>

  #### Black Box Design

  ![image](https://github.com/lmadem/DPRAM/assets/93139766/899a5cbf-4f4a-4ff5-a67b-499e9c8d2034)


  <li> This is a simple DUAL-PORT RAM design implemented in verilog. Please check out the file "DPRAM.v" for verilog code</li>
  
</details>
