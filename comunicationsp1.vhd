-----------------------------------------
--  LIBRARY  ----------------------------
-----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------
--  ENTITY  -----------------------------
-----------------------------------------
entity comunicationsp1 is
	port (
		--sinal de clock
		clk :in std_logic;
		--resetar sistema
		reset	 : in	std_logic;
		poten : in std_logic;
		dout : out std_logic;
		cs : out std_logic;
		sclk : out std_logic;
		output : out std_logic_vector(1 to 12);
		led : out std_logic
		);

end comunicationsp1;
-----------------------------------------
--  ARCHITECTURE  -----------------------
-----------------------------------------
architecture logic of comunicationsp1 is
	-- Signal for clock 2MHz
	signal clk_2mhz : std_logic;
	signal cnt :integer :=0;
	
	-- Signal for LEDs
	signal data : std_logic_vector(1 to 12);
	
	-- Build an enumerated type for the state machine
	type state_type is (start, single, d2, d1, d0, sample, sample2, null_bit, 
		b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0, finish);
	-- Register to hold the current state
	signal state : state_type;

	begin
	--CONTADOR DE 2 MHz
	--colocar clk na sensibilidade
				process (clk)
					begin
					if (rising_edge (clk) ) then
						cnt <= cnt + 1;
						if cnt=24 then
							clk_2mhz <= '1';							
							elsif cnt=49 then
								clk_2mhz <= '0';
								cnt <= 0;
						end if;
					end if;
					sclk <= clk_2mhz;
				end process;
	--------------------------------
	--------------------------------
	--------------------------------
	process (reset, clk_2mhz)			
	begin	
		if (reset='1') then
			led <= '1';
			state <= start;
			
			elsif (falling_edge (clk_2mhz) ) then
				led <= '0';
				case state is
				when start=>
					cs <= '0';
					dout <= '1';
					state <= single;
					
				when single=>
					cs <= '0';
					dout <= '1';
					state <= d2;					
					
				when d2=>
					cs <= '0';
					dout <= '0';
					state <= d1;
					
				when d1=>
					cs <= '0';
					dout <= '0';
					state <= d0;
					
				when d0=>
					cs <= '0';
					dout <= '0';
					state <= sample;
					
				when sample=>
					cs <= '0';
					state<=sample2;
					
				when sample2=>
					cs <= '0';					
					state <= null_bit;
				
				when null_bit=>
					cs <= '0';
					state <= b11;
								
				when b11=>
					cs <= '0';
					data(12) <= poten;
					state <= b10;
				
				when b10=>
					cs <= '0';
					data(11) <= poten;
					state <= b9;
				
				when b9=>
					cs <= '0';
					data(10) <= poten;
					state <= b8;
										
				when b8=>
					cs <= '0';
					data(9) <= poten;
					state <= b7;
				
				when b7=>
					cs <= '0';
					data(8) <= poten;
					state <= b6;					
				
				when b6=>
					cs <= '0';
					data(7) <= poten;
					state <= b5;
				
				when b5=>
					cs <= '0';
					data(6) <= poten;
					state <= b4;				
				
				when b4=>
					cs <= '0';
					data(5) <= poten;
					state <= b3;
				
				when b3=>
					cs <= '0';
					data(4) <= poten;
					state <= b2;
				
				when b2=>
					cs <= '0';
					data(3) <= poten;
					state <= b1;
				
				when b1=>
					cs <= '0';
					data(2) <= poten;
					state <= b0;
				
				when b0=>
					cs <= '0';
					data(1) <= poten;
					state <= finish;
				
				when finish=>
					cs <= '1';
					output <= data;
					state <= start;				
				
			end case;				
		end if;	
	end process;
end logic;
