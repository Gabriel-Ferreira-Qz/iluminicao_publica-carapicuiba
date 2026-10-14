/* CONSULTAS TÉCNICAS ENEL */

/* 1:QUANTIDADE DE LAMPADAS E SEUS CONSUMOS */

/* POTENCIA TOTAL DO MUNICÍPIO */
SELECT ROUND(SUM(quantidade * potencia) / 1000000.0, 4) AS potencia_municipio_em_MW
FROM ativos_carapicuiba.tb_pot_lampada;

/* QUANTIDADE DE LAMPADA E POTENCIA TOTAL */
SELECT 
	lampada,
    COUNT(*) AS contagem__lampada,
    SUM(quantidade * potencia) AS potencia
FROM ativos_carapicuiba.tb_pot_lampada
WHERE validacao_backoffice = 1 AND tipo_item = 'IP'
GROUP BY lampada 
ORDER BY potencia DESC;

/* CONTAGEM CATEGORICA DA SITUAÇÃO DAS LAMPADAS */
SELECT
	status_manutencao,
    COUNT(situacao) AS contagem
FROM ativos_carapicuiba.tb_pot_lampada
WHERE validacao_backoffice = 1 AND tipo_item = 'IP'
GROUP BY status_manutencao
ORDER BY status_manutencao DESC;

/* LAMPADAS QUE NECESSITAM DE MANUTENÇÃO */
SELECT
	situacao,
    COUNT(situacao) AS contagem
FROM ativos_carapicuiba.tb_pot_lampada
WHERE validacao_backoffice = 1 AND tipo_item = 'IP' AND status_manutencao = 'NECESSITA MANUTENÇÃO'
GROUP BY situacao
ORDER BY contagem DESC;

/* CONTAGEM DE REATORES POR LAMPADAS */
SELECT 
	lampada, 
    COUNT(possui_reator) AS contagem_reatores
FROM ativos_carapicuiba.tb_pot_lampada
WHERE possui_reator = 1 AND validacao_backoffice = 1 AND tipo_item = 'IP'
GROUP BY lampada
ORDER BY contagem_reatores DESC; 

/* 2:QUANTIDADE DE CIRCUITOS E PONTOS MEDIDOS OU AVENÇADOS */

/* CONTAGEM DE CIRCUITO EXCLUSIVO */
SELECT
	circ_exclusivo,
    COUNT(*) AS contagem
FROM ativos_carapicuiba.tb_circuito
WHERE validacao_backoffice = 1
GROUP BY circ_exclusivo;

/* CONTAGEM DE PONTOS MEDIDOS E AVENÇADOS */
SELECT 
	medicao,
    COUNT(*) AS quantidade_pontos
FROM ativos_carapicuiba.tb_circuito
WHERE validacao_backoffice = 1
GROUP BY  medicao
ORDER BY quantidade_pontos DESC;

/* CONTAGEM DE PONTOS ALIMENTADORES EM CIRCUITOS MED E AVENÇADOS */
SELECT
	medicao,
    COUNT(*) AS contagem
FROM ativos_carapicuiba.tb_circuito
WHERE validacao_backoffice = 1 AND ponto_alim = 1
GROUP BY medicao;

/* 10 CIRCUITOS QUE MAIS CONCENTRA POSTES */
SELECT 
	numero_circuito, 
    COUNT(DISTINCT id_ponto) AS contagem
FROM ativos_carapicuiba.tb_circuito
WHERE numero_circuito NOT IN ('LIG DIR SECUNDARIA','N/A')
GROUP BY numero_circuito
ORDER BY contagem DESC
LIMIT 10;

/* 3:POTENCIA TOTAL POR CIRCUITO E PONTOS MEDIDOS OU AVENÇADOS */

/* POTENCIA TOTAL EM KW E MW DOS PONTOS DE ILUMINAÇÃO PUBLICA */
SELECT 
	C.medicao,
    ROUND(SUM(L.quantidade * L.potencia) / 1000.0, 2) AS potencia_total_kw,
    ROUND(SUM(L.quantidade * L.potencia) / 1000000.0, 4) AS potencia_total_mw
FROM ativos_carapicuiba.tb_circuito AS C
JOIN ativos_carapicuiba.tb_pot_lampada AS L
USING (id_unico)
WHERE C.validacao_backoffice = 1 AND tipo_item = 'IP'
GROUP BY medicao;

/* QUANTIDADE DE TIPOS DE LAMPADAS POR MEDIDO E AVENÇADO */
SELECT 
	L.lampada,
    SUM(C.medicao = 'MEDIDO') AS qtd_medidas,
    SUM(C.medicao = 'AVENCADA') AS qtd_avencadas
FROM ativos_carapicuiba.tb_pot_lampada AS L
JOIN ativos_carapicuiba.tb_circuito AS C
USING (id_unico)
WHERE C.validacao_backoffice = 1
GROUP BY L.lampada;

/* 20 CIRCUITOS COM MAIORES CONSUMOS DE POTENCIA */
SELECT 
	C.numero_circuito,
    C.medicao,
    COUNT(DISTINCT L.id_ponto) AS qtd_postes,
    ROUND(SUM(L.quantidade * L.potencia) / 1000.0, 2) AS potencia_total_kw
FROM ativos_carapicuiba.tb_circuito AS C
JOIN ativos_carapicuiba.tb_pot_lampada AS L
USING (id_unico)
WHERE C.validacao_backoffice = 1 AND L.tipo_item = 'IP'
GROUP BY C.numero_circuito, C.medicao
ORDER BY potencia_total_kw DESC
LIMIT 20;
