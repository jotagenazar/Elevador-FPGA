ENTITY mealy IS
	PORT(clk						: IN bit;
		  reset					: IN bit; /* reset do programa */
		  moeda					: IN BIT_VECTOR (3 DOWNTO 0); /* moeda que vai adicionar na máquina */
		  saida					: OUT BIT_VECTOR (1 DOWNTO 0); /* "10" o refri está sendo liberado, "01" a máquina está devolvendo dinheiro */
		  botao					: IN bit; /* botao confirma. Se 100 centavos na maquina, libera o refri, senao devolve o dinheiro. */
		  montante				: BUFFER integer RANGE 0 to 200); /* montante atual dentro da máquina, para acompanhar as somas */
END mealy;


ARCHITECTURE maquinaRefri OF mealy IS
	TYPE tipoEstados IS (recebeDinheiro, entregaRefri); /* máquina com dois estados: recebeDinheiro e entregaRefri */
	SIGNAL estadoAtual: tipoEstados; /* acompanhando as transições */
	BEGIN

		PROCESS(clk, reset, montante)
		BEGIN
		
			IF(reset = '1') THEN /* caso reset seja acionado, voltamos para o início, sem nenhuma moeda na maquina */
				montante <= 0;
				estadoAtual <= recebeDinheiro;
				saida <= "00";
			
			ELSIF(botao = '1') THEN /* caso botao seja acionado, também zeramos as moedas da máquina, porém de duas maneiras diferentes: */
				montante <= 0;
				
				/* 1-) refri não pago */
				IF(estadoAtual = recebeDinheiro) THEN 
					saida <= "01";	
					
				/* 2-) refri pago */
				ELSE
					saida <= "10";
					
				END IF;
				
			ELSIF(clk'EVENT AND clk = '1') THEN	/* acionando o clock, estamos adicionando alguma moeda na maquina */
				
				saida <= "00";
				estadoAtual <= recebeDinheiro;
				
				IF(moeda = "0001") THEN -- 10 CENTAVOS

					IF(montante + 10 > 100) THEN /* caso a moeda faça o montante atual ultrapassar o valor do refri, já devolvemos o dinheiro e resetamos o montante */
						saida <= "01";
						montante <= 0;						
						
					ELSIF(montante + 10 < 100) THEN /* caso a moeda não ultrapasse o valor do refri, somamos no montante, aguardando novas moedas */
						montante <= montante + 10;
					
					ELSE /* caso a moeda complete o pagamento do refri, transitamos para o novo estado e atualizamos o montante */
						estadoAtual <= entregaRefri;
						montante <= montante + 10;
						
					END IF;
					
				/* mesma logica das atualizações seguem para todas as moedas, apenas mudando o seu valor */
				ELSIF(moeda = "0010") THEN	-- 25 CENTAVOS
					
					IF(montante + 25 > 100) THEN
						saida <= "01";
						montante <= 0;						
						
					ELSIF(montante + 25 < 100) THEN
						montante <= montante + 25;
					
					ELSE 
						estadoAtual <= entregaRefri;
						montante <= montante + 25;
						
					END IF;
				
				ELSIF(moeda = "0100") THEN -- 50 CENTAVOS
					
					IF(montante + 50 > 100) THEN
						saida <= "01";
						montante <= 0;						
						
					ELSIF(montante + 50 < 100) THEN
						montante <= montante + 50;
					
					ELSE 
						estadoAtual <= entregaRefri;
						montante <= montante + 50;
						
					END IF;
				
				ELSIF(moeda = "1000") THEN -- 100 CENTAVOS
					
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