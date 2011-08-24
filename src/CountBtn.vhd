----------------------------------------------------------------------------------
-- Company: 		 AtomSoftTech
-- Engineer: 		 Jason Lopez
-- 
-- Create Date:    21:13:39 08/23/2011 
-- Design Name:    CountBtn
-- Tool versions:  ISE Webpack 13.2
-- Description: 	 Count Up and show on PORT C
--
-- Dependencies:   CountBtn.ucf
--
-- Revision 0.01 - File Created
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CountBtn is
    Port ( clk : in  STD_LOGIC; -- Our Input Clock
			  rst : in  STD_LOGIC; -- Our Input Reset
			  btn : in STD_LOGIC;  -- Our Input Button
           DB : out  STD_LOGIC_VECTOR (15 downto 0) -- Our Output LEDs
			 );
end CountBtn;

architecture Behavioral of CountBtn is

signal count : STD_LOGIC_VECTOR (24 downto 0); -- Will be like our counting variable
signal state : STD_LOGIC_VECTOR (15 downto 0); -- Will hold the current state of the LED (0 or 1)
signal ready : STD_LOGIC;							  -- Make ready after time (debounce)

begin
process (clk,rst,state,ready,btn) is begin  -- Process these signals
   if rst = '0' then					 	 -- If Reset is LOW then RESET our variable, state and LEDs to 0
		count <= (others => '0');	 	 -- Place 0's in count
		state <= (others => '0');	 	 -- Place 0's in LED state 
		ready <= '0';						 -- Reset our Ready state
   elsif (rising_edge(clk)) then	 	 -- Wait for the clock to be high (rising edge)
      if(ready = '0') then	 			 -- If we are not ready then debounce. This happens after a button is pressed.
			count <= count + 1;			 -- Add 1 to our count variable
			if(count = 6400000) then 	 -- 200ms delay  (1s /32MHz = 31.25ns) (200ms / 31.25ns = 6400000 )
				ready <= '1';				 -- we are ready for a new press (set to 1)
				count <= (others => '0');-- Reset Count
			end if;
		else
			if (btn = '1') then	 		 -- If we are ready and the button is pressed
				state <= state + 1;		 -- Add 1 to our led state (will overflow to 0 automatically)
				ready <= '0'; 				 -- Clear our ready state for debounce
			end if;				
  		end if;				
   end if;
	
	DB <= state;						 	 -- Output the current state without regard to edge of clock
end process;

end Behavioral;

