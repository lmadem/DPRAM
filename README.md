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

<details>
  <summary> Verification Plan </summary>

  #### The verification plan for DPRAM design is implemented in two phases
  <li> First phase is to list out the possible testing scenarios for the design and implementing them in a SV linear testbench </li>
  <li> Second phase is to built a robust verification environment with all components and implement the testcases formulated in phase 1 </li>

  <details> 
    <summary> Test Plan </summary>

  ![image](https://github.com/lmadem/DPRAM/assets/93139766/513b9c91-3fff-4d29-95aa-8d11f876bfff)

  </details>
</details>

<details>
  <summary> Verification Results and EDA waveforms </summary>

  <details>
    <summary> SV Linear </summary>

  <li> Implemented all the listed testcases as per the test plan in SV linear testbench. The linear testbench consists of top module, interface, program block, packet class, and the design file. Please check out the folder SV Linear. It has all the required files </li>

  <li> The SV Linear testbench will be able to execute all testcases in one simulation, but the simulation order will be sequential </li>

  ### Test Plan Status
  
  ![image](https://github.com/lmadem/DPRAM/assets/93139766/0f80f109-38c1-4b42-a3f4-b38bf9de0fb0)

  #### TestCase1 EDA Waveform

  ![image](https://github.com/lmadem/DPRAM/assets/93139766/244f4145-1b79-4db1-838a-c70dd17a02eb)

  ![image](https://github.com/lmadem/DPRAM/assets/93139766/8de565ad-7eae-44c7-953d-ecafa0105b14)

  #### TestCase2 EDA Waveform

  ![image](https://github.com/lmadem/DPRAM/assets/93139766/e05b7601-2630-4059-b426-a0f0045d45ab)
  
  ![image](https://github.com/lmadem/DPRAM/assets/93139766/1029a8a9-b9f5-41c8-a4d9-544006365b9f)

   #### TestCase3 EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/b62854e1-2027-4c59-97ce-b137c01e8063)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/ef32d4b7-e997-41a7-b6e1-5a1c9d649d86)

   #### TestCase4 EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/ab62aa6a-790a-4bdd-87fb-652f2489d981)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/3136474e-660f-456d-b17f-7c2a817d600f)

   #### TestCase5 EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/377c7ef9-beed-4dd9-babc-22e215cd1028)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/0043d078-f5fd-49bf-b982-f47c21dc6eb7)

   #### TestCase6 EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/3c79976d-a6f0-4036-bedc-4dbfed6b71e9)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/5d3dfccc-c81e-4458-a3b3-121b790b8971)

   ### Alltestcase EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/86318a6d-de61-4fda-8d87-82dcc2b4d84d)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/5d7e0103-d3f0-4e7a-bfd7-dd315bf8287a)


  </details>
</details>
