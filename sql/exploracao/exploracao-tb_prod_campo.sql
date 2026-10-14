/* PROCURANDO VALORES NULOS NA COLUNA 'data_levantamento' */
SELECT * FROM ativos_carapicuiba.tb_prod_campo
WHERE data_levantamento IS NULL;

/* PRODUÇÃO INDIVIDUAL */
SELECT
	usuario_levantador,
    COUNT(*) AS prod_total_individual
FROM ativos_carapicuiba.tb_prod_campo
WHERE validacao_backoffice = 1
GROUP BY usuario_levantador
ORDER BY prod_total_individual DESC;

/* PRODUÇÃO INDIVIDUAL MENSAL */
SELECT 
	DATE_FORMAT(data_levantamento, "%M/%Y") AS mes,
    usuario_levantador,
    COUNT(*) AS producao_mensal
FROM ativos_carapicuiba.tb_prod_campo
WHERE validacao_backoffice = 1
GROUP BY 
	DATE_FORMAT(data_levantamento, "%M/%Y"),
	MONTH(data_levantamento),
    YEAR(data_levantamento),
    usuario_levantador
ORDER BY 
	YEAR(data_levantamento) DESC,
	MONTH(data_levantamento) DESC;
    
/* PRODUÇÃO INDIVIDUAL DIÁRIA E CONSULTAS DE METAS ALCANÇADAS NO ANO DE 2024 */
SELECT 
	DATE_FORMAT(data_levantamento, "%d/%M/%Y") AS dia,
    usuario_levantador,
    COUNT(*) AS prod_diaria,
	CASE 
		WHEN COUNT(*) < 200 THEN "Meta não alcançada"
        WHEN COUNT(*) >= 200 THEN "Meta alcançada"
	END AS metas
FROM ativos_carapicuiba.tb_prod_campo
WHERE YEAR(data_levantamento) = 2024 AND validacao_backoffice = 1
GROUP BY 
	DATE_FORMAT(data_levantamento, "%d/%M/%Y"),
	usuario_levantador,
    DAY(data_levantamento),
	MONTH(data_levantamento)
ORDER BY 
    MONTH(data_levantamento) DESC,
	DAY(data_levantamento) DESC;

/* QUANTIDADE DE DIAS QUE OS TÉCNICOS DE CAMPO BATERAM A META INDIVIDUALMENTE NO ANO DE 2024 */
SELECT 
	usuario_levantador, 
    COUNT(*) AS qtd_dias_metas_batidas
FROM(
	SELECT
		DATE(data_levantamento) AS data,
		usuario_levantador,
		COUNT(*) AS prod_diaria
    FROM ativos_carapicuiba.tb_prod_campo
    WHERE YEAR(data_levantamento) = 2024 AND validacao_backoffice = 1
    GROUP BY 
		DATE(data_levantamento),
        usuario_levantador
	HAVING COUNT(*) >= 200
) AS producao_diaria
GROUP BY usuario_levantador
ORDER BY qtd_dias_metas_batidas DESC;
    
/* PRODUÇÃO MENSAL TOTAL */
SELECT 	
	DATE_FORMAT(data_levantamento, "%M/%Y") AS mes,
    COUNT(*) AS producao_mensal 
FROM ativos_carapicuiba.tb_prod_campo
WHERE validacao_backoffice = 1
GROUP BY 
	DATE_FORMAT(data_levantamento, "%M/%Y"),
    MONTH(data_levantamento),
    YEAR(data_levantamento)
ORDER BY 
	YEAR(data_levantamento) DESC,
    MONTH(data_levantamento) DESC;