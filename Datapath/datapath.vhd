library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	port (clk, reset : in std_logic;
			--------------Switches----------------
			switches_in : in std_logic_vector (4 downto 0);
			---------------------------------Sinais da FSM---------------------------------------------
			
			-----------Sinais da tabela de fases----------
			dp_apaga_sequencias, dp_carrega_sequencia	: in std_logic;
			
			---------Sinais do registrador de fases-------
			dp_prox_contin, dp_zera_fase, dp_muda_fase	: in std_logic;
			
			----Sinais do registrador Paralelo_Serie------
			dp_limpa_canal_serial, dp_carrega_reg_pisca_led, dp_envia_proximo	: in std_logic;
			
			----Sinais do registrador de jogada atual-----
			dp_limpa_entrada, dp_carrega_entrada, dp_prepara_prox_entrada	: in std_logic;
			
			----Sinais do registrador indice sequencia----
			dp_indice_inc_dec, dp_limpa_indice, dp_carrega_indice	: in std_logic;
			
			-------Sinais da logica de concatenacao-------
			dp_arreda, dp_desloc_esq, dp_carrega_aleatorio, dp_limpa_logica_concat : in std_logic;
			
			--------Sinal para manter led apagado---------
			dp_apaga_leds : in std_logic;
			----------------------------------------------
			----Sinais de controle dos temporizadores-----
			dp_conta_tempo_jogador, dp_carrega_tempo_jogador : in std_logic;
			dp_limpa_tempo_jogador, dp_conta_tempo_leds, dp_limpa_tempo_leds : in std_logic;
			
			---------Sinal de controle de bounce----------
			dp_prepara_debouncer : in std_logic;
			
			-----------Sinal de placar--------------------
			dp_libera_placar : in std_logic;
			----------------------------------------------------------------------------------------------
			
			----------Debug--------------
			out_banco_regs : out std_logic_vector (29 downto 0);
			out_reg_fase : out std_logic_vector (3 downto 0);
			out_reg_indice : out std_logic_vector (3 downto 0);
			out_reg_LEDs : out std_logic_vector (2 downto 0);
			out_reg_entrada : out std_logic_vector (29 downto 0);
			out_aleatorio : out std_logic_vector (2 downto 0);
			out_concatenacao : out std_logic_vector (29 downto 0);
			out_tempo_jogada : out integer range 0 to 11;
			-----------------------------
			-------------Saida LEDs----------------------------
			leds_out : out std_logic_vector (4 downto 0);
			-------------Saida resultados----------------------
			CERTO, MOSTROU, ACABOU, TEMPO, TEMPO_JOGADA, JOGADA : out std_logic;
			-------------Saida placar--------------------------
			placar : out std_logic_vector (3 downto 0)
			);
end entity;

architecture main of datapath is

component temp
	generic(
		m: integer --:= 25000000 PARA SER UM TEMP. DE 0,5 SEG.
	);
	port(
		clk: in std_logic;
		clear: in std_logic;
		start: in std_logic;
		finish : out std_logic
	);
end component;
-------------------------------------------------------------------------
component tempo_fase
	generic(
		n: integer;-- := 10;
		--m: integer := 37500000
		m : integer
	);
	port(
		clk: in std_logic;
		clear: in std_logic;
		start: in std_logic;
		param: in integer range 0 to n;
		time_left: out integer range 0 to n+1;
		finish : out std_logic
	);
end component;
-------------------------------------------------------------------------
component banco_de_reg
	generic (word_size :integer;-- := 50;
				address   :integer-- := 10
				);
	
	port (clk, clear 		: in std_logic;
			addr_in			: in integer range address-1 downto 0;
			--Writing interface
			write_eneable	: in std_logic;
			write_data 		: in std_logic_vector (word_size-1 downto 0);
			--Reading interface
			read_eneable	: in std_logic;
			read_data		: out std_logic_vector (word_size-1 downto 0)
			);
end component;
-------------------------------------------------------------------------
component reg_serie_paralelo
	generic (
		n: integer--:= 30
	);
	port(
		m : in integer range 0 to 9;
		load_leds, shft_left ,move, clk, clear: in std_logic;
		leds : in std_logic_vector (n-1 downto 0);
		Q: out std_logic_vector(2 downto 0)
	);
end component;
-------------------------------------------------------------------------
component reg_entrada_jogador
	generic (
		n: integer;--:= 30;
		m: integer--:= 3
	);
	port(
		load_entrada, shft_left ,move, clk, clear: in std_logic;
		entrada : in std_logic_vector (m-1 downto 0);
		Q: out std_logic_vector(n-1 downto 0)
	);
end component;
-------------------------------------------------------------------------
component Reg_Mostra_Seq
	generic (
		n: integer--:= 3
	);
	port(load, clk, clear, fase: in std_logic;
		  I: in std_logic_vector(n-1 downto 0);
		  Qout: out std_logic_vector(n-1 downto 0)
	);
end component;
-------------------------------------------------------------------------
component Reg_de_Fase
	generic (
		n: integer--:= 3
	);
	port(load, clk, clear, selection: in std_logic;
		  Qout: out std_logic_vector(n-1 downto 0)
	);
end component;
-------------------------------------------------------------------------
component logica_concat
	generic (
		n: integer;--:= 30;
		m: integer--:= 3
	);
	port(
		load_aleat, shft_left ,move, clk, clear: in std_logic;
		Aleat : in std_logic_vector (m-1 downto 0);
		Q: out std_logic_vector(n-1 downto 0)
	);
end component;
-------------------------------------------------------------------------
component decoder
	port
	(En : in std_logic_vector (2 downto 0);
	leds: out std_logic_vector (4 downto 0));
end component;
-------------------------------------------------------------------------
component gerador_aleatorio
Port ( clock : in STD_LOGIC;
       reset : in STD_LOGIC;
       en : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR (2 downto 0);
       check: out STD_LOGIC);
end component;
-------------------------------------------------------------------------
component led_encoder
	generic (
				delay : integer-- := 10
				);
	port	(encoder_clk, encoder_reset : in std_logic;
			 prepare_new	: in std_logic;
			 bounced_swtiches : in std_logic_vector (4 downto 0);
			 encoded_sw: out std_logic_vector (2 downto 0);
			 user_interaction	: out std_logic);
end component;
-------------------------------------------------------------------------
component comparador
	generic (n: integer --:= 4
	);
	
	port (a, b: in std_logic_vector (n-1 downto 0);
			igual, maior, menor : out std_logic
	);
end component;
-------------------------------------------------------------------------

signal saida_banco_de_registradores : std_logic_vector (29 downto 0);
signal saida_concatenacao : std_logic_vector (29 downto 0);
signal saida_encoder_debouncer : std_logic_vector (2 downto 0);
signal saida_gerador_aleatorio : std_logic_vector (2 downto 0);
signal saida_registrador_de_fase : std_logic_vector (3 downto 0);
signal saida_registrador_de_jogada : std_logic_vector (29 downto 0);
signal saida_registrador_indice : std_logic_vector (3 downto 0);
signal saida_registrador_mostra_leds : std_logic_vector (2 downto 0);
signal leds_ligados : std_logic_vector (4 downto 0);
signal acertou : std_logic;
signal verifica_aleatorio : std_logic;
signal endereco_banco : integer range 0 to 10;
signal fase_final : std_logic_vector (3 downto 0);
signal parametro_fase : integer range 0 to 10; 

begin

	out_banco_regs <= saida_banco_de_registradores;
	out_reg_fase <= saida_registrador_de_fase;
	out_reg_indice <= saida_registrador_indice;
	out_reg_LEDs <= saida_registrador_mostra_leds;
	out_reg_entrada <= saida_registrador_de_jogada;
	out_aleatorio <= saida_gerador_aleatorio;
	out_concatenacao <= saida_concatenacao;
	
	CERTO <= acertou;
	
	endereco_banco <= to_integer(unsigned(saida_registrador_de_fase));
	
	parametro_fase <= to_integer(unsigned(saida_registrador_de_fase));
	
	fase_final <= std_logic_vector(to_unsigned(10, 4));

	leds_out <= (others => '0') when dp_apaga_leds = '1' else
					leds_ligados	 when dp_apaga_leds = '0';
					
	placar <= saida_registrador_de_fase when dp_libera_placar = '1' else
				 (others => '0') 				when dp_libera_placar = '0';

	Banco_de_Registradores : banco_de_reg generic map (word_size => 30, address => 10) --Banco de registradores (30 x 10)
													  port map	  (clk => clk, clear => dp_apaga_sequencias, addr_in => endereco_banco,
																		write_eneable => dp_carrega_sequencia, write_data => saida_concatenacao,
																		read_eneable => '1', read_data => saida_banco_de_registradores);
																		
	Registrador_de_Fase	: reg_de_fase generic map (n => 4) --Pode contar ate 16 (0 a 15)
												  port map	  (clk => clk, clear => dp_zera_fase, load => dp_muda_fase, selection => dp_prox_contin, Qout => saida_registrador_de_fase);
												  
	Concatenacao : logica_concat generic map (n => 30, m=> 3) --Coloca grupos de 3 nos 30
										  port map    (clk => clk, clear => dp_limpa_logica_concat, load_aleat => dp_carrega_aleatorio,
															shft_left => '1', move => dp_arreda, Aleat => saida_gerador_aleatorio, Q => saida_concatenacao);
	--Verifica aleatorio														
	Gerador_Sequencia_Aleatorio : gerador_aleatorio port map	(clock => clk, reset => reset, en => '1', Q => saida_gerador_aleatorio, check => verifica_aleatorio);
	
	
	Temporizador_LED : temp generic map (m => 10) --0.5 segundos
									port map		(clk => clk, clear => dp_limpa_tempo_leds, start => dp_conta_tempo_leds, finish => TEMPO);
									
	Registrador_Mostra_LEDs : reg_serie_paralelo generic map (n => 30) --30 bits
																port map		(m => parametro_fase, load_leds => dp_carrega_reg_pisca_led, clear => dp_limpa_canal_serial, clk => clk,
																				 shft_left => '1', move => dp_envia_proximo, leds => saida_banco_de_registradores, Q => saida_registrador_mostra_leds);
																				 
	LED_Decoder : decoder port map (En => saida_registrador_mostra_leds, leds => leds_ligados);
	
	Registrador_de_Jogada : reg_entrada_jogador generic map (n => 30, m => 3) --Coloca grupos de 3 nos 30
															  port map    (clk => clk, shft_left => '1', clear => dp_limpa_entrada, move => dp_prepara_prox_entrada, load_entrada => dp_carrega_entrada,
																				entrada => saida_encoder_debouncer, Q => saida_registrador_de_jogada);
																				
	Encoder_Debouncer : led_encoder generic map (delay => 1)
											  port map    (encoder_clk => clk, encoder_reset => reset, prepare_new => dp_prepara_debouncer, bounced_swtiches => switches_in,
																encoded_sw => saida_encoder_debouncer, user_interaction => JOGADA);
																
	Comparador_de_Jogada : comparador generic map (n => 30)
												 port map    (a => saida_banco_de_registradores, b => saida_registrador_de_jogada, igual => acertou);
												 
	Registrador_Indice	: reg_mostra_seq generic map (n => 4)
													  port map 	  (clk => clk, clear => dp_limpa_indice, load => dp_carrega_indice, fase => dp_indice_inc_dec, I=> saida_registrador_de_fase, Qout => saida_registrador_indice);
													  
	Comparador_de_Indice : comparador generic map (n => 4)
												 port map (a => saida_registrador_indice, b => (others=>'0'), igual => MOSTROU);
												
	Comparador_de_Fase	: comparador generic map (n => 4)
												 port map (a => saida_registrador_de_fase, b => fase_final, igual => ACABOU);
												 
	Temporizador_Jogada	: tempo_fase generic map (n => 10, m => 30)
												 port map	 (clk => clk, clear => dp_limpa_tempo_jogador, start => dp_conta_tempo_jogador, param => parametro_fase, finish => TEMPO_JOGADA, time_left => out_tempo_jogada );
end architecture;