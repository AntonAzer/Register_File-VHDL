# Register_File-Lab3-VHDL

# RTL DFFs Structal Model :
<img width="901" height="853" alt="image" src="https://github.com/user-attachments/assets/ca4ff136-8b81-4339-b0a3-c2b5f5cea6f7" />



# RTL Memory Array Structal Model :
<img width="856" height="860" alt="image" src="https://github.com/user-attachments/assets/b76b5c7b-ba8a-4c80-bf57-aa27afb22f33" />

----------------------------------------------------

Although the design methodologies were different (Structural vs. Behavioral), the RTL Viewer generated identical hardware schematics. This is because the behavioral memory array uses asynchronous reads, which forces the synthesizer to implement the memory using discrete D-Flip Flops and Multiplexers instead of dedicated Block RAM


# Testbench Waveform After 100 ns  :
<img width="1908" height="812" alt="image" src="https://github.com/user-attachments/assets/a3eff7a5-7089-4127-9580-ba76fcf1d1ea" />




Note: I edited the "Radix" to Hexadecimal.

# associated with the required in the document :
<img width="682" height="647" alt="image" src="https://github.com/user-attachments/assets/8d920df6-ba90-4475-b9f9-b8139fb4a1e0" />


Note: Port0 ,Port1 repreasent the two read_addresses in the code and not specific registers ,read the tb file to understand the wave form : ) 

Note Again: exactly at 50000ps (50 ns) the ports updated at falling edge not rising because changing read address is an Asynch. operation and it is exactly after 5 cycles.


<img width="540" height="742" alt="image" src="https://github.com/user-attachments/assets/c530d633-ab3a-41a7-8fbb-73aa4b23ca1f" />

 
----------------------------------------------------

If you want to take the files don't forget to rename the file you want to test like the entity name "RegisterFile" and set it as top level entity if you are in Quartus.
