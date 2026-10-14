
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

/* 10 CIRCUITOS QUE MAIS CONCENTRA LAMPADAS */
SELECT 
	numero_circuito, 
    COUNT(DISTINCT id_ponto) AS contagem
FROM ativos_carapicuiba.tb_circuito
WHERE numero_circuito <> 'LIG DIR SECUNDARIA'
GROUP BY numero_circuito
ORDER BY contagem DESC
LIMIT 10;

