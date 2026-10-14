/* LIMPEZA DA TABELA 'tb_pot_lampada' */

/* HABILITANDO EDIÇÃO NO SAFE MODE */
SET SQL_SAFE_UPDATES = 0;

/* AJUSTE NA POTÊNCIA DO REATOR NAS LÂMPADAS DE VAPOR DE SÓDIO */
UPDATE ativos_carapicuiba.tb_pot_lampada 
SET 
    potencia_reator = CASE
        WHEN potencia = 400 THEN 400
        WHEN potencia = 250 THEN 250
        WHEN potencia = 100 THEN 100
        ELSE potencia_reator
    END
WHERE
    validacao_backoffice = 1
        AND possui_reator = 1
        AND potencia_reator = 0
        AND tipo_lampada = 'ILUMINAÇÃO PUBLICA'
        AND lampada = 'VAPOR DE SODIO';

/* AJUSTE NA COLUNA POSSUI REATOR, LÂMPADAS DE LED QUE NÃO POSSUEM REATORES */
UPDATE ativos_carapicuiba.tb_pot_lampada 
SET possui_reator = 0
WHERE
     validacao_backoffice = 1
        AND possui_reator = 1
        AND potencia_reator = 0
        AND tipo_lampada = 'ILUMINAÇÃO PUBLICA'
        AND lampada = 'LED';

/* AJUSTE NA COLUNA POSSUI REATOR, SEMÁFORO NÃO POSSUI REATOR */
UPDATE ativos_carapicuiba.tb_pot_lampada 
SET possui_reator = 0
WHERE
    validacao_backoffice = 1
        AND possui_reator = 1
        AND potencia_reator = 0;
        
/* CRIAÇÃO DE NOVA COLUNA 'status_manutencao' */
ALTER TABLE ativos_carapicuiba.tb_pot_lampada
ADD COLUMN status_manutencao VARCHAR(50) NOT NULL;

/* ADIÇÃO DE DADOS PARA CATEGORIZAR A COLUNA 'situacao' */
UPDATE ativos_carapicuiba.tb_pot_lampada
SET status_manutencao = 
	CASE 
		WHEN situacao IN ('ACESA 24H', 'DANIFICADA', 'SEM LAMPADA', 'OSCILANDO') THEN 'NECESSITA MANUTENÇÃO'
        WHEN situacao = 'NORMAL' THEN 'REGULAR'
	END;

/* LIMPEZA DA TABELA 'tb_backoffice' */

/* SEPARANDO E EXCLUINDO INFORMAÇÕES DE HORA, NÃO SERÃO UTILIZADAS NO PROJETO */
UPDATE ativos_carapicuiba.tb_backoffice 
SET data_backoffice = LEFT(data_backoffice, LOCATE(' ', data_backoffice) - 1);
    
/* DEFININDO UM PADRÃO DE ANO, '2024' PARA '24' POR EXEMPLO */
UPDATE ativos_carapicuiba.tb_backoffice
SET data_backoffice = REPLACE(REPLACE(data_backoffice, '2024', '24'), '2025', 25);

/* CRIAÇÃO DE UMA NOVA COLUNA TEMPORÁRIA COM O OBJETIVO DE ALTERAR O TIPO DE DADO... */
ALTER TABLE ativos_carapicuiba.tb_backoffice
ADD COLUMN data_temp DATE;

/* COLUNA NOVA RECEBENDO AS DATAS FORMATADAS */
UPDATE ativos_carapicuiba.tb_backoffice
SET data_temp = STR_TO_DATE(data_backoffice, '%e/%c/%y')
WHERE data_backoffice <> '';

/* APAGANDO ANTIGA COLUNA */
ALTER TABLE ativos_carapicuiba.tb_backoffice
DROP COLUMN data_backoffice;

/* ALTERANDO A POSIÇÃO DA COLUNA NA TABELA */
ALTER TABLE ativos_carapicuiba.tb_backoffice
MODIFY COLUMN data_temp DATE AFTER usuario_backoffice;

/* RENOMEANDO COLUNA PARA SEU NOME ORIGINAL */
ALTER TABLE ativos_carapicuiba.tb_backoffice
RENAME COLUMN data_temp TO data_backoffice;

/* LIMPEZA DA TABELA 'tb_prod_campo' */

/* SEPARANDO E EXCLUINDO INFORMAÇÕES DE HORA, NÃO SERÁ UTILIZADO NO PROJETO */
UPDATE ativos_carapicuiba.tb_prod_campo
SET data_hora_levantado = LEFT(data_hora_levantado, LOCATE(' ', data_hora_levantado) -1);

/* DEFININDO UM PADRÃO DE ANO, '2024' PARA '24' POR EXEMPLO */
UPDATE ativos_carapicuiba.tb_prod_campo
SET data_hora_levantado = REPLACE(REPLACE(data_hora_levantado, '2024','24'),'2025','25');

/* CRIAÇÃO DE UM NOVA COLUNA TEMPORÁRIA COM OBJETIVO DE ALTERAR O TIPO DE DADO, ANTES ARMAZENADO COMO TEXTO AGORA COMO TIPO DATA */
ALTER TABLE ativos_carapicuiba.tb_prod_campo
ADD COLUMN data_temp DATE;

/* COLUNA NOVA RECEBENDO AS DATA FORMATADAS */
UPDATE ativos_carapicuiba.tb_prod_campo
SET data_temp = STR_TO_DATE(data_hora_levantado, '%e/%c/%y')
WHERE data_hora_levantado <> '';

/* APAGANDO ANTIGA COLUNA */
ALTER TABLE ativos_carapicuiba.tb_prod_campo
DROP COLUMN data_hora_levantado;

/* ALTERANDO A POSIÇÃO DA COLUNA NA TABELA */
ALTER TABLE ativos_carapicuiba.tb_prod_campo
MODIFY COLUMN data_temp DATE AFTER usuario_levantador;

/* RENOMEANDO COLUNA PARA 'data_levantamento' */
ALTER TABLE ativos_carapicuiba.tb_prod_campo
RENAME COLUMN data_temp TO data_levantamento;


/* LIMPEZA DA TABELA 'tb_backoffice' */

/* CRIAÇÃO DE UM NOVA COLUNA TEMPORÁRIA COM OBJETIVO DE ALTERAR O TIPO DE DADO, ANTES ARMAZENADO COMO TEXTO AGORA COMO TIPO DATA */
ALTER TABLE ativos_carapicuiba.tb_backoffice
ADD COLUMN data_temp DATE;

/* COLUNA NOVA RECEBENDO AS DATA FORMATADAS NOS DADOS BRUTOS */
UPDATE ativos_carapicuiba.tb_backoffice AS B
JOIN dados_brutos_ativos.bruto_tb_carapicuiba AS C
USING (id_unico)
SET B.data_temp = STR_TO_DATE(REPLACE(C.data_backoffice, '2024', '24'), '%e/%c/%y')
WHERE B.data_backoffice IS NULL;

/* INSERINDO DATAS NOS ESPAÇOS NULOS DA COLUNA 'data_levantamento' */
UPDATE ativos_carapicuiba.tb_backoffice
SET data_backoffice = data_temp
WHERE data_backoffice IS NULL;

/* REMOVENDO COLUNA TEMPORÁRIA */
ALTER TABLE ativos_carapicuiba.tb_backoffice
DROP COLUMN data_temp;


/* LIMPEZA DA TABELA 'tb_prod_campo' */

/* CRIAÇÃO DE UM NOVA COLUNA TEMPORÁRIA COM OBJETIVO DE ALTERAR O TIPO DE DADO, ANTES ARMAZENADO COMO TEXTO AGORA COMO TIPO DATA */
ALTER TABLE ativos_carapicuiba.tb_prod_campo
ADD COLUMN data_temp DATE;

/* COLUNA NOVA RECEBENDO AS DATA FORMATADAS NOS DADOS BRUTOS */
UPDATE ativos_carapicuiba.tb_prod_campo AS P
JOIN dados_brutos_ativos.bruto_tb_carapicuiba AS C
USING (id_unico)
SET P.data_temp = STR_TO_DATE(REPLACE(C.data_hora_levantado, '2024', '24'), '%e/%c/%y')
WHERE P.data_levantamento IS NULL;

/* INSERINDO DATAS NOS ESPAÇOS NULOS DA COLUNA 'data_levantamento' */
UPDATE ativos_carapicuiba.tb_prod_campo
SET data_levantamento = data_temp
WHERE data_levantamento IS NULL;

/* REMOVENDO COLUNA TEMPORARIA */
ALTER TABLE ativos_carapicuiba.tb_prod_campo
DROP COLUMN data_temp;

/* REMOVENDO COLUNA 'circ_exclusivo', NÃO SERÁ NECESSÁRIA A UTILIZAÇÃO DESSA COLUNA NESSA TABELA */
ALTER TABLE ativos_carapicuiba.tb_prod_campo
DROP COLUMN circ_exclusivo;

/* MUDANDO O NOME NA COLUNA 'usuario_levantador' DE 'FABIELEALVES' PARA 'FABIELE' */
UPDATE ativos_carapicuiba.tb_prod_campo
SET usuario_levantador = 
	CASE
		WHEN usuario_levantador = 'FABIELEALVES' THEN 'FABIELE'
        ELSE usuario_levantador
	END;

/* ALTERANDO POSIÇÃO DA COLUNA */
ALTER TABLE ativos_carapicuiba.tb_prod_campo
MODIFY COLUMN validacao_backoffice BOOLEAN AFTER id_ponto;


/* LIMPEZA DA TABELA 'tb_circuito' */

/*BINARIZAÇÃO DA TABELA 'circ_exclusivo' */
UPDATE ativos_carapicuiba.tb_circuito
SET circ_exclusivo = 
	CASE 
		WHEN circ_exclusivo = 'SIM' THEN 1
        WHEN circ_exclusivo = 'NÃO' THEN 0
	END;