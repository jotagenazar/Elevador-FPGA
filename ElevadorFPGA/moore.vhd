ENTITY moore IS
	PORT(clk						: IN bit;
		  reset					: IN bit;
		  andarDesejado		: IN integer RANGE 0 TO 15;
		  andarAtual			: BUFFER integer RANGE 0 TO 15;
		  saida					: OUT BIT_VECTOR (1 DOWNTO 0));
END moore;


ARCHITECTURE elevador OF moore IS
	TYPE tipoEstados IS (parado, subindo, descendo);
	SIGNAL estadoAtual: tipoEstados;
	BEGIN

		PROCESS(clk, reset, andarAtual)
		BEGIN
			IF reset = '1' THEN 
				andarAtual <= 0;
				estadoAtual <= parado;
				
			ELSIF(clk'EVENT AND clk = '1') THEN
				IF(andarDesejado - andarAtual > 0) THEN
					estadoAtual <= subindo;
					andarAtual <= andarAtual + 1;
					saida <= "10";
					
				ELSIF(andarDesejado - andarAtual < 0) THEN
					estadoAtual <= descendo;
					andarAtual <= andarAtual - 1;
					saida <= "01";		
					
				ELSE
					estadoAtual <= parado;
					saida <= "00";
				END IF;
				
			END IF;
			
		END PROCESS;
		
END elevador;
				
	
	
		  