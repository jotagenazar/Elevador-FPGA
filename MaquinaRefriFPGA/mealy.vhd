ENTITY mealy IS
	PORT(clk						: IN bit;
		  reset					: IN bit;
		  moeda					: IN BIT_VECTOR (3 DOWNTO 0);
		  saida					: OUT BIT_VECTOR (1 DOWNTO 0);
		  botao					: IN bit;
		  montante				: BUFFER integer RANGE 0 to 200);
END mealy;


ARCHITECTURE maquinaRefri OF mealy IS
	TYPE tipoEstados IS (recebeDinheiro, entregaRefri);
	SIGNAL estadoAtual: tipoEstados;
	BEGIN

		PROCESS(clk, reset, montante)
		BEGIN
			
			IF(reset = '1') THEN 
				montante <= 0;
				estadoAtual <= recebeDinheiro;
				saida <= "00";
				
			ELSIF(clk'EVENT AND clk = '1') THEN
				saida <= "00";
				
				IF(montante > 100) THEN
					saida <= "01";
					montante <= 0;
					estadoAtual <= recebeDinheiro;
					
				ELSIF(montante < 100) THEN
					estadoAtual <= recebeDinheiro;
					
					IF(botao = '1') THEN
						saida <= "01";
						montante <= 0;
					END IF;
					 
				ELSE -- MONTANTE == 100
					estadoAtual <= entregaRefri;
				
					IF(botao = '1') THEN
						saida <= "10";
						montante <= 0;
						
					ELSIF(moeda /= "0000") THEN
						saida <= "01";
						montante <= 0;
						
					END IF;
					
				END IF;	
				
				
				IF(moeda = "0001") THEN -- 10 CENTAVOS
					montante <= montante + 10;
					
				ELSIF(moeda = "0010") THEN	-- 25 CENTAVOS
					montante <= montante + 25;
				
				ELSIF(moeda = "0100") THEN -- 50 CENTAVOS
					montante <= montante + 50;
				
				ELSIF(moeda = "1000") THEN -- 100 CENTAVOS
					montante <= montante + 100;
					
				END IF;
					
			
			END IF;
			
		END PROCESS;
		
END maquinaRefri;