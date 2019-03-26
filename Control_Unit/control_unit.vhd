library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
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
			certo, acabou, mostrou, tempo_mostra_led	: in std_logic
			----------------------------------------------------------------------------------
			);
end entity;

architecture main of control_unit is

	type estado is (------------------------------------Estados para preenchimento da tabela de fases-------------------------------------------
						 INICIO, LIMPA_TABELA, PREPARA_FASE, CARREGA_FASE, PROXIMA_FASE, CHEGOU_FASE_10, PREPARA_PROX_SEQ, ARREDA1, ARREDA2, ARREDA3,
						 ----------------------------------------------------------------------------------------------------------------------------
						 ------------------------------------Estados para exibir LEDs de uma certa fase----------------------------------------------
						 CONFIG_JOGO, PREPARA_MOSTRA_LED, MOSTRA, MOSTROU_LED, CARREGA_PROX_LED, MOSTROU_TODOS, PROX_LED1, PROX_LED2, PROX_LED3, 
						 ESPERA_INTERVALO, REINICIA_TEMPO_LED,
						 ----------------------------------------------------------------------------------------------------------------------------
						 --------------------------Estados para capturar entrada do jogador e comparar-----------------------------------------------
						 INICIA_TEMPO_JOGADOR, AGUARDA_ENTRADA, CARREGA_ENTRADA_JOGADOR, ACABOU_ENTRADAS, AJUSTA_ENT1, AJUSTA_ENT2, AJUSTA_ENT3, 
						 ESPERA_FIM_JOGADA,JUIZ, ACERTO, ULTIMA_FASE, MOSTRA_ACERTO,
						 ----------------------------------------------------------------------------------------------------------------------------
						 --------------------------------------Estados para mostrar o placar---------------------------------------------------------
						 MOSTRA_PLACAR
						 );
	signal estado_atual, proximo_estado : estado;

begin

	process (clk, reset)
	begin
		if (reset = '1') then
			estado_atual <= INICIO;
		elsif (rising_edge(clk)) then
			estado_atual <= proximo_estado;
		end if;
	end process;
	
	process (estado_atual, jogada, interrup_tempo, certo, acabou, mostrou, tempo_mostra_led)
	begin
		case estado_atual is
		
			when INICIO =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '1';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '1';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '1';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '1';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '1';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '1';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '1';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= LIMPA_TABELA;
				
			when LIMPA_TABELA =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '1';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= PREPARA_FASE;
				
			when PREPARA_FASE =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '1';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '1';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= CARREGA_FASE;
				
			when CARREGA_FASE =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '1';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '1';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= PROXIMA_FASE;
				
			when PROXIMA_FASE =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '1';
				muda_fase <= '1';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= CHEGOU_FASE_10;
				
			when CHEGOU_FASE_10 =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '1';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				if (acabou = '1') then
					--proximo_estado <= INICIO;
					proximo_estado <= CONFIG_JOGO;
				else
					proximo_estado <= PREPARA_PROX_SEQ;
				end if;
				
			when PREPARA_PROX_SEQ =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '1';
				desloc_esq <= '1';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= ARREDA1;
				
			when ARREDA1 =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '1';
				desloc_esq <= '1';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= ARREDA2;
				
			when ARREDA2 =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '1';
				desloc_esq <= '1';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= ARREDA3;
				
			when ARREDA3 =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '1';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= PREPARA_FASE;
				
				-------------------------------------Estados para mostrar LEDs de uma fase-------------------------------------------------------------------
				
			when CONFIG_JOGO =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '1';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '1';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '1';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '1';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '1';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= PREPARA_MOSTRA_LED;
				
			when PREPARA_MOSTRA_LED =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '1';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '1';
				carrega_indice <= '1';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '1';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= MOSTRA;
				
			when MOSTRA =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '1';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '0';
				----------------------------------------------
				if (tempo_mostra_led = '1') then
					--proximo_estado <= MOSTROU_LED;
					proximo_estado <= REINICIA_TEMPO_LED;
				else
					proximo_estado <= MOSTRA;
				end if;
				
			when REINICIA_TEMPO_LED =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '1';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				--------Cria um momento de leds apagados------
				apaga_leds <= '0';
				----------------------------------------------
				proximo_estado <= ESPERA_INTERVALO;
				
			when ESPERA_INTERVALO =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '1';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				--------Cria um momento de leds apagados------
				apaga_leds <= '1';
				----------------------------------------------
				--Usamos o mesmo tempo que o LEDs fica aceso
				if (tempo_mostra_led = '1') then
					proximo_estado <= MOSTROU_LED;
				else
					proximo_estado <= ESPERA_INTERVALO;
				end if;

				
			when MOSTROU_LED =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '1';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= CARREGA_PROX_LED;
				
			when CARREGA_PROX_LED =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '1';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= MOSTROU_TODOS;
				
			when MOSTROU_TODOS =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '1';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				if (mostrou = '1') then
					proximo_estado <= INICIA_TEMPO_JOGADOR;
				else
					proximo_estado <= PROX_LED1;
				end if;
				
			when PROX_LED1 =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '1';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= PROX_LED2;
				
			when PROX_LED2 =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '1';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '1';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= PROX_LED3;
				
			when PROX_LED3 =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '1';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '1';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= MOSTRA;
				
				-------------------------------------Estados para capturar a entrada do jogador-------------------------------------------------------------------
				
			when INICIA_TEMPO_JOGADOR =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '1';
				carrega_indice <= '1';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '1';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '1';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= AGUARDA_ENTRADA;
				
			when AGUARDA_ENTRADA =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '1';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '1';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				if (jogada = '1' and interrup_tempo = '0') then
					proximo_estado <= CARREGA_ENTRADA_JOGADOR;
				elsif (jogada = '0' and interrup_tempo = '0') then
					proximo_estado <= AGUARDA_ENTRADA;
				else
					proximo_estado <= JUIZ;
				end if;
				
			when CARREGA_ENTRADA_JOGADOR =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '1';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '1';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= ACABOU_ENTRADAS;
				
			when ACABOU_ENTRADAS =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				if (mostrou = '1') then
					proximo_estado <= JUIZ;
				else
					proximo_estado <= AJUSTA_ENT1;
				end if;
				
			when AJUSTA_ENT1 =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '1'; --Shift left
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= AJUSTA_ENT2;
				
			when AJUSTA_ENT2 =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '1';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '1';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= AJUSTA_ENT3;
				
			when AJUSTA_ENT3 =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '1';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= ESPERA_FIM_JOGADA;
				
			when ESPERA_FIM_JOGADA =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				if (jogada = '1') then
					proximo_estado <= ESPERA_FIM_JOGADA;
				else
					proximo_estado <= AGUARDA_ENTRADA;
				end if;
				
			when JUIZ =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '1';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '1';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '1';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				if (certo = '1') then
					proximo_estado <= MOSTRA_ACERTO;
				else
					proximo_estado <= MOSTRA_PLACAR;
				end if;
				
			when MOSTRA_ACERTO =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '1';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '1';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				if (tempo_mostra_led = '1') then
					proximo_estado <= ACERTO;
				else
					proximo_estado <= MOSTRA_ACERTO;
				end if;
				
			when ACERTO =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '1';
				muda_fase <= '1';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '1';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= ULTIMA_FASE;
				
			when ULTIMA_FASE =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '0';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				if (acabou = '1') then
					proximo_estado <= MOSTRA_PLACAR;
				else
					proximo_estado <= PREPARA_MOSTRA_LED;
				end if;
				
				-------------------------------------Estado para mostrar placar-------------------------------------------------------------------
				
			when MOSTRA_PLACAR =>
				-----------Sinais da tabela de fases----------
				apaga_sequencias <= '0';
				carrega_sequencia <= '0';
				---------Sinais do registrador de fases-------
				zera_fase <= '0';
				prox_contin <= '0';
				muda_fase <= '0';
				----Sinais do registrador Paralelo_Serie------
				limpa_canal_serial <= '0';
				carrega_reg_pisca_led <= '0';
				envia_proximo <= '0';
				----Sinais do registrador de jogada atual-----
				limpa_entrada <= '0';
				carrega_entrada <= '0';
				prepara_prox_entrada <= '0';
				----Sinais do registrador indice sequencia----
				limpa_indice <= '0';
				indice_inc_dec <= '0';
				carrega_indice <= '0';
				-------Sinais da logica de concatenacao-------
				limpa_logica_concat <= '0';
				arreda <= '0';
				desloc_esq <= '0';
				carrega_aleatorio <= '0';
				-------------Sinais tempo jogador-------------
				limpa_tempo_jogador <= '0';
				carrega_tempo_jogador <= '0';
				conta_tempo_jogador <= '0';
				--------------Sinais tempo leds---------------
				limpa_tempo_leds <= '0';
				conta_tempo_leds <= '0';
				-------------Sinal jogada liberada------------
				led_jogada_liberada <= '0';
				---------------Sinal acerto led---------------
				led_acerto <= '0';
				-----------Sinal libera placar----------------
				libera_placar <= '1';
				------------Sinal controle debouncer----------
				prepara_debouncer <= '0';
				--------------Sinal apaga leds----------------
				apaga_leds <= '1';
				----------------------------------------------
				proximo_estado <= MOSTRA_PLACAR;

			end case;
		end process;
end main;