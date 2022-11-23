ENTITY moore IS
	PORT(
	     -- clock do sistema
	     clk						: IN bit;
		  
		  -- reset do programa
		  reset					: IN bit;
		  
		  -- Andar de destino
		  andarDesejado		: IN integer RANGE 0 TO 15;
		  
		  -- Andar atual
		  andarAtual			: BUFFER integer RANGE 0 TO 15;
		  
		  -- Saida do motor
		  saida					: OUT BIT_VECTOR (1 DOWNTO 0));
		
		  --A saida diz se o elevador esta subindo, descendo ou parado.
		  
END moore;


ARCHITECTURE elevador OF moore IS
	TYPE tipoEstados IS (parado, subindo, descendo);
	SIGNAL estadoAtual: tipoEstados;
	BEGIN

		PROCESS(clk, reset, andarAtual)
		BEGIN
			IF reset = '1' THEN 
			-- Manda o elevador pro andar 0 e estado parado
			-- sem depender do clock.
			
				andarAtual <= 0;
				estadoAtual <= parado;
				
			ELSIF(clk'EVENT AND clk = '1') THEN
			-- Condicionais que dependem do clock:
			
				IF(andarDesejado - andarAtual > 0) THEN		
				--Entrada maior do que 0:
				-- - Estado subindo.
				-- - Atualiza o andar para o de cima.
				-- - Saida subindo
				
					estadoAtual <= subindo;
					andarAtual <= andarAtual + 1;
					saida <= "10";
					
				ELSIF(andarDesejado - andarAtual < 0) THEN
				--Entrada menor do que 0:
				-- - Estado descendo.
				-- - Atualiza o andar para o de baixo.
				-- - Saida descendo
				
					estadoAtual <= descendo;
					andarAtual <= andarAtual - 1;
					saida <= "01";		
					
				ELSE
				--Entrada igual a 0:
				-- - Estado parado.
				-- - Saida parado
				
					estadoAtual <= parado;
					saida <= "00";
				END IF;
				
			END IF;
			
		END PROCESS;
		
END elevador;
				
	
	
		  