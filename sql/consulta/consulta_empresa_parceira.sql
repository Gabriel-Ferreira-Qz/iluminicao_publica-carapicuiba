/* CONSULTAS OPERACIONAL DA EMPRESA PARCEIRA */

/* 1: PRODUTIVIDADE E OPERAÇÃO DE CAMPO */

/* PRODUÇÃO INDIVIDUAL, TÉCNICO DE CAMPO */
SELECT
	usuario_levantador,
    COUNT(*) AS prod_total_individual
FROM ativos_carapicuiba.tb_prod_campo
WHERE validacao_backoffice = 1
GROUP BY usuario_levantador
ORDER BY prod_total_individual DESC;
    
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
    
/* QUANDTIDADE DE DIAS QUE TECNICOS DE CAMPOS BATERAM A META INDIVIDUALMETE NO ANO DE 2024 */
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

/* PRODUÇÃO MENSAL TOTAL DOS TÉCNICOS DE CAMPO */
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

/* 2: PRODUTIVIDADE E VALIDAÇÃO BACKOFFICE */
    
/* PRODUÇÃO INDIVIDUAL DE BACKOFFICE */
SELECT 
	usuario_backoffice,
    COUNT(id_unico) AS backoffice_feito
FROM ativos_carapicuiba.tb_backoffice
GROUP BY usuario_backoffice
ORDER BY backoffice_feito DESC;

/* QUANTIDADES DE PONTOS EXCLUIDOS */
SELECT 
	usuario_backoffice,
    SUM(validacao_backoffice = 0) AS qtd_pontos_excluidos
FROM ativos_carapicuiba.tb_backoffice
GROUP BY usuario_backoffice
HAVING SUM(validacao_backoffice = 0) >= 1;

/* VALIDAÇÃO BACKOFFICE MENSAL TOTAL */
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

/* QUANDTIDADE DE DIAS QUE O TIME DE BACKOFFICE BATERAM A META INDIVIDUALMETE NO ANO DE 2024 */
SELECT 
	usuario_backoffice,
    COUNT(*) AS qtd_dias_meta_alcancadas
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
ORDER BY qtd_dias_meta_alcancadas DESC;

/* TEMPO DE CICLO (SLA): MÉDIA DE DIAS ENTRE LEVANTAMENTO E VALIDAÇÃO POR BACKOFFICE */
SELECT 
    B.usuario_backoffice,
    COUNT(B.id_unico) AS total_validados,
    ROUND(AVG(DATEDIFF(B.data_backoffice, P.data_levantamento)), 1) AS sla_medio_dias
FROM ativos_carapicuiba.tb_prod_campo AS P
INNER JOIN ativos_carapicuiba.tb_backoffice AS B
USING (id_unico)
WHERE B.validacao_backoffice = 1
GROUP BY B.usuario_backoffice
ORDER BY sla_medio_dias ASC;