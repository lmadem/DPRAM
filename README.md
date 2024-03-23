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

  <li> Implemented all the listed testcases as per the test plan in SV linear testbench. The linear testbench consists of top module, interface, program block, packet class, and the design file.          Please check out the folder SV Linear. It has all the required files </li>

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

  <details> 
    <summary> SV Environment </summary>

   <li> Built a robust verification environment in System Verilog and implemented all the testcases. The SV testbench verification environment consists of packet class, generator class, driver             class, Monitor classes, scoreboard class, environment class, base_test class, test classes, program block, top module, interface and the design </li>

   <li> The SV Environment will be able to drive one testcase per simulation </li>

   <li> Please check out the folder SV Environment. It has all the required files </li>

   ### Test Plan Status
  
   ![image](https://github.com/lmadem/DPRAM/assets/93139766/0f80f109-38c1-4b42-a3f4-b38bf9de0fb0)

   #### TestCase1 EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/91699b7c-8d97-4614-9bee-eb045295ba4c)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/ac51d701-6da4-4eae-b6cd-47231c3dce62)

   #### TestCase2 EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/a17d561b-9dbe-4a29-9444-b79921ea1b8a)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/3931895f-cc88-4df4-bb1a-49c8e11603a2)

   #### TestCase3 EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/8fe76380-5ab2-45a3-a2ba-c76a035be1a9)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/7b175382-208a-4480-8de9-fdcd8d93e6fa)

   #### TestCase4 EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/60be9ae7-47d0-4e3c-9765-9dd9c89ba8b8)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/b2e73df4-f072-42b8-bb25-99f7bb82068e)

   #### TestCase5 EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/18619610-7768-4dae-8e0c-5e4741d67a5e)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/b04d17c1-7c14-4dce-b485-8a5a74e9b2bb)

   #### TestCase6 EDA Waveform

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/3ec06e8e-0b08-4efb-a961-030ef16e0716)

   ![image](https://github.com/lmadem/DPRAM/assets/93139766/4642952a-41a0-4c51-aa1e-9d0bd13edf8a)
 
  </details>
</details>

<details>
  <summary> EDA Playground Link and Simluation Steps </summary>

  #### EDA Playground Link

  ```bash
https://www.edaplayground.com/x/JvGt
  ```

  #### Verification Standards

  <li> Constrained random stimulus, robust generator, driver and monitors and In-order scoreboard </li>

  #### Simulation Steps
  <details>
    <summary> SV Linear </summary>

##### Step 1 : Comment "top.sv", "interface.sv", and "test.sv"(lines 4,5,6) in testbench.sv file 

##### Step 2 : Uncomment "Alltests.sv"(line 10) in testbench.sv file

##### Step 3 : Comment line 16(which is SV environment testbench) and Uncomment line 13(SV Linear testbench). Please read the comments in top.sv file for more info

##### Step 4 : To run individual tests, please look into the above attached screenshots in SV Linear folder of Verification Results and EDA Waveforms

  </details>
  
  <details>
    <summary> SV Environment </summary>

##### Step 1 : UnComment "top.sv", "interface.sv", and "test.sv"(lines 4,5,6) in testbench.sv file 

##### Step 2 : comment "Alltests.sv"(line 10) in testbench.sv file

##### Step 3 : UnComment line 16(which is SV environment testbench) and comment line 13(SV Linear testbench). Please read the comments in top.sv file for more info

##### Step 4 : To run individual tests, please look into the above attached screenshots in SV Environment folder of Verification Results and EDA Waveforms

  </details>
</details>
