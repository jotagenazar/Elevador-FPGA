ENTITY mealy IS
	PORT(clk						: IN bit;
	
		  -- reset do programa
		  reset					: IN bit;
		  
		  -- moeda que vai adicionar na máquina 
		  moeda					: IN BIT_VECTOR (3 DOWNTO 0);
		  
		  -- "10" o refri está sendo liberado, "01" a máquina está devolvendo dinheiro
		  saida					: OUT BIT_VECTOR (1 DOWNTO 0);  
		  
		  -- botao confirma. Se 100 centavos na maquina, libera o refri, senao devolve o dinheiro.
		  botao					: IN bit;
		  
		  -- montante atual dentro da máquina, para acompanhar as somas
		  montante				: BUFFER integer RANGE 0 to 200);
END mealy;


ARCHITECTURE maquinaRefri OF mealy IS
	-- máquina com dois estados: recebeDinheiro e entregaRefri
	TYPE tipoEstados IS (recebeDinheiro, entregaRefri);
	
	-- acompanhando as transições
	SIGNAL estadoAtual: tipoEstados; 
	
	BEGIN

		PROCESS(clk, reset, montante)
		BEGIN
			
			-- caso reset seja acionado, voltamos para o início, sem nenhuma moeda na maquina
			IF(reset = '1') THEN 
				montante <= 0;
				estadoAtual <= recebeDinheiro;
				saida <= "00";
			
			-- caso botao seja acionado, também zeramos as moedas da máquina, porém de duas maneiras diferentes
			ELSIF(botao = '1') THEN
				montante <= 0;
				
				-- 1-) refri não pago
				IF(estadoAtual = recebeDinheiro) THEN 
					saida <= "01";	
					
				-- 2-) refri pago
				ELSE
					saida <= "10";
					
				END IF;
				
			-- acionando o clock, estamos adicionando alguma moeda na maquina
			ELSIF(clk'EVENT AND clk = '1') THEN 
				
				saida <= "00";
				estadoAtual <= recebeDinheiro;
				
				-- 10 CENTAVOS
				IF(moeda = "0001") THEN

					-- caso a moeda ultrapasse o valor do refri, devolvemos o dinheiro e resetamos o montante
					IF(montante + 10 > 100) THEN
						saida <= "01";
						montante <= 0;						
						
					-- caso a moeda não ultrapasse o valor do refri, somamos no montante
					ELSIF(montante + 10 < 100) THEN
						montante <= montante + 10;
					
					-- caso a moeda complete o pagamento do refri, transitamos para o novo estado e somamos no montante
					ELSE
						estadoAtual <= entregaRefri;
						montante <= montante + 10;
						
					END IF;
					
				-- mesma logica das atualizações seguem para todas as moedas	
				-- 25 CENTAVOS
				ELSIF(moeda = "0010") THEN
					
					IF(montante + 25 > 100) THEN
						saida <= "01";
						montante <= 0;						
						
					ELSIF(montante + 25 < 100) THEN
						montante <= montante + 25;
					
					ELSE 
						estadoAtual <= entregaRefri;
						montante <= montante + 25;
						
					END IF;
				
				-- 50 CENTAVOS
				ELSIF(moeda = "0100") THEN
					
					IF(montante + 50 > 100) THEN
						saida <= "01";
						montante <= 0;						
						
					ELSIF(montante + 50 < 100) THEN
						montante <= montante + 50;
					
					ELSE 
						estadoAtual <= entregaRefri;
						montante <= montante + 50;
						
					END IF;
				
				-- 100 CENTAVOS
				ELSIF(moeda = "1000") THEN
					
					IF(montante + 100 > 100) THEN
						saida <= "01";
						montante <= 0;						
					
					ELSE 
						estadoAtual <= entregaRefri;
						montante <= montante + 100;
						
					END IF;
					
				END IF;
			
			END IF;
			
		END PROCESS;
		
END maquinaRefri;