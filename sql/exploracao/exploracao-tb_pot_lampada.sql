SELECT * FROM ativos_carapicuiba.tb_pot_lampada; 

/* POTENCIA TOTAL DO MUNICÍPIO */
SELECT SUM((quantidade * potencia)/1000000) AS potencia_municipio_em_MW
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

/* CONTAGEM DE SITUAÇÕES DAS LAMPADAS */
SELECT
	situacao,
    COUNT(situacao) AS contagem
FROM ativos_carapicuiba.tb_pot_lampada
WHERE validacao_backoffice = 1 AND tipo_item = 'IP'
GROUP BY situacao
ORDER BY contagem DESC;

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
