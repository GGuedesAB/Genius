library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game is
	port (clk, reset : in std_logic;
	--------------------------Debug--------------------------------------
			-----------Sinais da tabela de fases----------
			db_apaga_sequencias, db_carrega_sequencia	: out std_logic;
			
			---------Sinais do registrador de fases-------
			db_prox_contin, db_zera_fase, db_muda_fase	: out std_logic;
			
			----Sinais do registrador Paralelo_Serie------
			db_limpa_canal_serial, db_carrega_reg_pisca_led, db_envia_proximo	: out std_logic;
			
			----Sinais do registrador de jogada atual-----
			db_limpa_entrada, db_carrega_entrada, db_prepara_prox_entrada	: out std_logic;
			
			----Sinais do registrador indice sequencia----
			db_indice_inc_dec, db_limpa_indice, db_carrega_indice	: out std_logic;
			
			-------Sinais da logica de concatenacao-------
			db_arreda, db_desloc_esq, db_carrega_aleatorio, db_limpa_logica_concat : out std_logic;
			
			--------------Sinal placar--------------------
			db_libera_placar : out std_logic;

			---------Sinal controle debouncer-------------
			db_prepara_debouncer : out std_logic;
			
			--------Sinal para manter led apagado---------
			db_apaga_leds : out std_logic;
			----------------------------------------------------------------------------------

			---------------------------Sinais de controle dos temporizadores------------------------------
			db_conta_tempo_jogador, db_carrega_tempo_jogador, db_limpa_tempo_jogador, db_conta_tempo_leds, db_limpa_tempo_leds : out std_logic;
			----------------------------------------------------------------------------------------------
			
			------------------------------Sinais de Entrada-----------------------------------
			db_jogada, db_interrup_tempo : out std_logic;
			--O sinal interrup_tempo serve para informar que acabou o tempo do jogador
			--O sinal tempo_mostra_led serve para informar que o LED ficou aceso pelo tempo especificado
			db_CERTO, db_ACABOU, db_MOSTROU, db_TEMPO_MOSTRA_LED	: out std_logic;
			----------------------------------------------------------------------------------
			db_placar : out std_logic_vector (3 downto 0);
			----------Debug datapath------------------------------
			out_banco_regs : out std_logic_vector (29 downto 0);
			out_reg_fase : out std_logic_vector (3 downto 0);
			out_reg_indice : out std_logic_vector (3 downto 0);
			out_reg_LEDs : out std_logic_vector (2 downto 0);
			out_reg_entrada : out std_logic_vector (29 downto 0);
			out_aleatorio : out std_logic_vector (2 downto 0);
			out_concatenacao : out std_logic_vector (29 downto 0);
			out_tempo_sob	: out integer range 0 to 11;
			-------------------------------------------------------
			
			switches_in : in std_logic_vector (4 downto 0);
			leds_out	: out std_logic_vector (4 downto 0);
			placar_final : out std_logic_vector (3 downto 0);
			led_jogada_liberada : out std_logic;
			led_jogada_correta : out std_logic);
end entity;

architecture main of Processador is
component control_unit
	port (clk, reset	: in std_logic;
			---------------------------------Sinais de Saida---------------------------------
			
			-----------Sinais da tabela de fases----------
			apaga_sequencias, carrega_sequencia	: out std_logic;
			
			---------Sinais do registrador de fases-------
			prox_contin, zera_fase, muda_fase	: out std_logic;
			
			----Sinais do registrador Paralelo_Serie------
			limpa_canal_serial, carrega_reg_pisca_led, envia_proximo	: out std_logic;
			
			----Sinais do registrador de jogada atual-----
			limpa_entrada, carrega_entrada, prepara_prox_entrada	: out std_logic;
			
			----Sinais do registrador indice sequencia----
			indice_inc_dec, limpa_indice, carrega_indice	: out std_logic;
			
			-------Sinais da logica de concatenacao-------
			arreda, desloc_esq, carrega_aleatorio, limpa_logica_concat : out std_logic;
			
			-------------Sinal jogada liberada------------
			led_jogada_liberada : out std_logic;
			
			------------Sinal jogada certa----------------
			led_acerto : out std_logic;
			
			--------------Sinal placar--------------------
			libera_placar : out std_logic;

			---------Sinal controle debouncer-------------
			prepara_debouncer : out std_logic;
			
			--------Sinal para manter led apagado---------
			apaga_leds : out std_logic;
			----------------------------------------------------------------------------------

			---------------------------Sinais de controle dos temporizadores------------------------------
			conta_tempo_jogador, carrega_tempo_jogador, limpa_tempo_jogador, conta_tempo_leds, limpa_tempo_leds : out std_logic;
			----------------------------------------------------------------------------------------------
			
			------------------------------Sinais de Entrada-----------------------------------
			jogada, interrup_tempo : in std_logic;
			--O sinal interrup_tempo serve para informar que acabou o tempo do jogador
			--O sinal tempo_mostra_led serve para informar que o LED ficou aceso pelo tempo especificado
			CERTO, ACABOU, MOSTROU, TEMPO_MOSTRA_LED	: in std_logic
			----------------------------------------------------------------------------------
			);
	end component;
	
	component datapath
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
			----------------------------------------------------------------------------------------------
			
			-----------Sinal de placar--------------------
			dp_libera_placar : in std_logic;
			----------------------------------------------------------------------------------------------
			
			-------------Saida LEDs----------------------------
			leds_out : out std_logic_vector (4 downto 0);
			-------------Saida resultados----------------------
			CERTO, MOSTROU, ACABOU, TEMPO, TEMPO_JOGADA, JOGADA : out std_logic;
			----------Debug datapath------------------------------
			out_banco_regs : out std_logic_vector (29 downto 0);
			out_reg_fase : out std_logic_vector (3 downto 0);
			out_reg_indice : out std_logic_vector (3 downto 0);
			out_reg_LEDs : out std_logic_vector (2 downto 0);
			out_reg_entrada : out std_logic_vector (29 downto 0);
			out_aleatorio : out std_logic_vector (2 downto 0);
			out_concatenacao : out std_logic_vector (29 downto 0);
			out_tempo_jogada : out integer range 0 to 11;
			-------------------------------------------------------
			
			---------------Saida placar------------------------
			placar : out std_logic_vector (3 downto 0)
			);
	end component;

			---------------------------------Sinais Internos--------------------------------------------
			
			-----------Sinais da tabela de fases----------
			signal apaga_sequencias, carrega_sequencia	: std_logic;
			
			---------Sinais do registrador de fases-------
			signal prox_contin, zera_fase, muda_fase	: std_logic;
			
			----Sinais do registrador Paralelo_Serie------
			signal limpa_canal_serial, carrega_reg_pisca_led, envia_proximo	: std_logic;
			
			----Sinais do registrador de jogada atual-----
			signal limpa_entrada, carrega_entrada, prepara_prox_entrada	: std_logic;
			
			----Sinais do registrador indice sequencia----
			signal indice_inc_dec, limpa_indice, carrega_indice	: std_logic;
			
			-------Sinais da logica de concatenacao-------
			signal arreda, desloc_esq, carrega_aleatorio, limpa_logica_concat : std_logic;
			
			--------------Sinal placar--------------------
			signal libera_placar : std_logic;

			---------Sinal controle debouncer-------------
			signal prepara_debouncer : std_logic;
			
			--------Sinal para manter led apagado---------
			signal apaga_leds : std_logic;
			----------------------------------------------------------------------------------

			---------------------------Sinais de controle dos temporizadores------------------------------
			signal conta_tempo_jogador, carrega_tempo_jogador, limpa_tempo_jogador, conta_tempo_leds, limpa_tempo_leds : std_logic;
			----------------------------------------------------------------------------------------------
			
			------------------------------Sinais de Entrada-----------------------------------
			signal jogada, interrup_tempo : std_logic;
			--O sinal interrup_tempo serve para informar que acabou o tempo do jogador
			--O sinal tempo_mostra_led serve para informar que o LED ficou aceso pelo tempo especificado
			signal CERTO, ACABOU, MOSTROU, TEMPO_MOSTRA_LED	: std_logic;
			----------------------------------------------------------------------------------
			signal placar : std_logic_vector (3 downto 0);
			
	
begin

	Controladora : control_unit port map(clk => clk, reset => reset, apaga_sequencias => apaga_sequencias, carrega_sequencia => carrega_sequencia,
													 prox_contin => prox_contin, zera_fase => zera_fase, muda_fase => muda_fase, limpa_canal_serial => limpa_canal_serial,
													 carrega_reg_pisca_led => carrega_reg_pisca_led, envia_proximo => envia_proximo, limpa_entrada => limpa_entrada,
													 carrega_entrada => carrega_entrada, prepara_prox_entrada => prepara_prox_entrada, indice_inc_dec => indice_inc_dec,
													 limpa_indice => limpa_indice, carrega_indice => carrega_indice, arreda => arreda, desloc_esq => desloc_esq,
													 carrega_aleatorio => carrega_aleatorio, limpa_logica_concat => limpa_logica_concat, led_acerto => led_jogada_correta,
													 libera_placar => libera_placar, prepara_debouncer => prepara_debouncer, apaga_leds => apaga_leds,
													 conta_tempo_jogador => conta_tempo_jogador, carrega_tempo_jogador => carrega_tempo_jogador, limpa_tempo_jogador => limpa_tempo_jogador,
													 conta_tempo_leds => conta_tempo_leds, limpa_tempo_leds => limpa_tempo_leds, jogada => jogada, led_jogada_liberada => led_jogada_liberada,
													 interrup_tempo => interrup_tempo, CERTO => CERTO, ACABOU => ACABOU, MOSTROU => MOSTROU, TEMPO_MOSTRA_LED => TEMPO_MOSTRA_LED);
	
	Caminho_de_Dados : datapath port map (clk => clk, reset => reset, switches_in => switches_in, dp_apaga_sequencias => apaga_sequencias, dp_carrega_sequencia => carrega_sequencia,
													  dp_prox_contin => prox_contin, dp_zera_fase => zera_fase, dp_muda_fase => muda_fase, dp_limpa_canal_serial => limpa_canal_serial,
													  dp_carrega_reg_pisca_led => carrega_reg_pisca_led, dp_envia_proximo => envia_proximo, dp_limpa_entrada => limpa_entrada,
													  dp_carrega_entrada => carrega_entrada, dp_prepara_prox_entrada => prepara_prox_entrada, dp_indice_inc_dec => indice_inc_dec,
													  dp_limpa_indice => limpa_indice, dp_carrega_indice => carrega_indice, dp_arreda => arreda, dp_desloc_esq => desloc_esq,
													  dp_carrega_aleatorio => carrega_aleatorio, dp_limpa_logica_concat => limpa_logica_concat, dp_apaga_leds => apaga_leds,
													  dp_conta_tempo_jogador => conta_tempo_jogador, dp_carrega_tempo_jogador => carrega_tempo_jogador, dp_limpa_tempo_jogador => limpa_tempo_jogador,
													  dp_conta_tempo_leds => conta_tempo_leds, dp_limpa_tempo_leds => limpa_tempo_leds, dp_prepara_debouncer => prepara_debouncer,
													  leds_out => leds_out, CERTO => CERTO, MOSTROU => MOSTROU, ACABOU => ACABOU, TEMPO => TEMPO_MOSTRA_LED,
													  TEMPO_JOGADA => interrup_tempo, JOGADA => jogada, placar => placar, dp_libera_placar => libera_placar,
			----------Debug--------------
			out_banco_regs => out_banco_regs, 
			out_reg_fase => out_reg_fase ,
			out_reg_indice => out_reg_indice ,
			out_reg_LEDs => out_reg_LEDs ,
			out_reg_entrada => out_reg_entrada ,
			out_aleatorio => out_aleatorio ,
			out_concatenacao => out_concatenacao,
			out_tempo_jogada => out_tempo_sob);
			
			-----------Sinais da tabela de fases----------
			db_apaga_sequencias <= 			apaga_sequencias;
			db_carrega_sequencia <=			carrega_sequencia;
			db_prox_contin <=					prox_contin;
			db_zera_fase <=					zera_fase;
			db_muda_fase <=					muda_fase;
			db_limpa_canal_serial <=		limpa_canal_serial;
			db_carrega_reg_pisca_led <=	carrega_reg_pisca_led;
			db_envia_proximo <=				envia_proximo;
			db_limpa_entrada <=				limpa_entrada;
			db_carrega_entrada <=			carrega_entrada;
			db_prepara_prox_entrada <=		prepara_prox_entrada;
			db_indice_inc_dec <= 			indice_inc_dec;
			db_limpa_indice <= 				limpa_indice;
			db_carrega_indice <= 			carrega_indice;	
			db_arreda <= 						arreda;
			db_desloc_esq <= 					desloc_esq;
			db_carrega_aleatorio <= 		carrega_aleatorio;
			db_limpa_logica_concat <= 		limpa_logica_concat;
			db_libera_placar <= 				libera_placar;
			db_prepara_debouncer <= 		prepara_debouncer;
			db_apaga_leds <= 					apaga_leds;
			db_conta_tempo_jogador <= 		conta_tempo_jogador;
			db_carrega_tempo_jogador <= 	carrega_tempo_jogador;
			db_limpa_tempo_jogador <= 		limpa_tempo_jogador;
			db_conta_tempo_leds <= 			conta_tempo_leds;
			db_limpa_tempo_leds <= 			limpa_tempo_leds;
			db_jogada <= 						jogada;
			db_interrup_tempo <= 			interrup_tempo;
			--O sinal interrup_tempo serve para informar que acabou o tempo do jogador
			--O sinal tempo_mostra_led serve para informar que o LED ficou aceso pelo tempo especificado
			db_CERTO <= CERTO;
			db_ACABOU <= ACABOU;
			db_MOSTROU <= MOSTROU;
			db_TEMPO_MOSTRA_LED <= TEMPO_MOSTRA_LED;
			
			
	placar_final <= placar;

end architecture;
