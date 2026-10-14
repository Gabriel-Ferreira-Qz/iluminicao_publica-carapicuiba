/* IDENTIFICANDO VALORES 'NULL' NA COLUNA 'data_backoffice' */
SELECT  
	id_ponto,
    usuario_backoffice,
    validacao_backoffice,
	data_backoffice,
	DATE_FORMAT(data_backoffice, "%M") AS mes 
FROM ativos_carapicuiba.tb_backoffice
WHERE data_backoffice IS NULL;

/* PRODUÇÃO INDIVIDUAL DE BACKOFFICE */
SELECT 
	usuario_backoffice,
    COUNT(id_unico) AS backoffice_feito
FROM ativos_carapicuiba.tb_backoffice
GROUP BY usuario_backoffice
ORDER BY backoffice_feito DESC;

/* PRODUÇÃO MENSAL TOTAL */
SELECT 
    DATE_FORMAT(data_backoffice, "%M/%Y") AS mes,
    COUNT(*) AS contagem_mensal
FROM ativos_carapicuiba.tb_backoffice
GROUP BY 
    DATE_FORMAT(data_backoffice, "%M/%Y"),
    YEAR(data_backoffice),
    MONTH(data_backoffice)
ORDER BY 
    YEAR(data_backoffice) DESC,
    MONTH(data_backoffice) DESC;
    
/* PRODUÇÃO INDIVIDUAL MENSAL DE BACKOFFICE */
SELECT 
    DATE_FORMAT(data_backoffice, "%M/%Y") AS mes,
    usuario_backoffice,
    COUNT(*) AS contagem_mensal
FROM ativos_carapicuiba.tb_backoffice
GROUP BY 
    DATE_FORMAT(data_backoffice, "%M/%Y"),
    usuario_backoffice,
    YEAR(data_backoffice),
    MONTH(data_backoffice)
ORDER BY 
    YEAR(data_backoffice) DESC,
    MONTH(data_backoffice) DESC;

/* PRODUÇÃO INDIVIDUAL DIÁRIA E CONSULTAS DE METAS ALCANÇADAS NO ANO DE 2024 */
SELECT 
	DATE_FORMAT(data_backoffice, "%d/%M/%Y") AS mes,
    usuario_backoffice,
    COUNT(*) AS qtd_backoffice_feito,
    CASE
		WHEN COUNT(*) < 200 THEN "Meta não alcançada"
        WHEN COUNT(*) >= 200 THEN "Meta alcançada"
	END AS meta
FROM ativos_carapicuiba.tb_backoffice
WHERE YEAR(data_backoffice) = 2024 AND validacao_backoffice = 1
GROUP BY 
	DATE_FORMAT(data_backoffice, "%d/%M/%Y"),
	DAY(data_backoffice),
    MONTH(data_backoffice),
    usuario_backoffice
ORDER BY 
	MONTH(data_backoffice)DESC,
	DAY(data_backoffice) DESC;

/* QUANTIDADE DE DIAS QUE O TIME DE BACKOFFICE BATEU A META INDIVIDUALMENTE NO ANO DE 2024 */
SELECT 
	usuario_backoffice,
    COUNT(*) AS qtd_metas_alcancadas
FROM (
	SELECT
		DATE(data_backoffice) AS data_backoffice,
		usuario_backoffice,
		COUNT(*) AS backoffice_feito
	FROM ativos_carapicuiba.tb_backoffice
	WHERE YEAR(data_backoffice) = 2024 AND validacao_backoffice = 1
    GROUP BY 
		DATE(data_backoffice),
        usuario_backoffice
	HAVING COUNT(*) >= 200
) AS producao_diaria
GROUP BY usuario_backoffice
ORDER BY qtd_metas_alcancadas DESC;