/* QUERY PARA TESTAR INFORMAÇÕES DAS TABELAS */
SELECT DISTINCT
	CASE
		WHEN TRIM(usuario_ponto) = 'VALIDADO BACKOFFICE' THEN 1
        WHEN TRIM(usuario_ponto) = 'EXCLUIDO' THEN 0
	END AS VERIFICACAO_BOOLEANA,
    usuario_ponto
FROM dados_brutos_ativos.bruto_tb_carapicuiba;

/* CRIANÇÃO DE NOVAS TABELAS EM OUTRO BANCO DE DADOS CHAMADO "ativos_carapicuiba" CONTENDO TODAS TABELAS SEGMENTAS PARA RELACIONA-LAS NO FUTURO*/
CREATE TABLE `ativos_carapicuiba`.`tb_backoffice`(
	`id_unico` INT NOT NULL PRIMARY KEY,
    `id_ponto` INT NOT NULL,
    `usuario_backoffice` VARCHAR(50) NOT NULL,
    `data_backoffice` TEXT NOT NULL,
    `validacao_backoffice` BOOLEAN NOT NULL
);

CREATE TABLE `ativos_carapicuiba`.`tb_circuito`(
	`id_unico` INT NOT NULL PRIMARY KEY,
    `id_ponto` INT NOT NULL,
	`validacao_backoffice` BOOLEAN NOT NULL,
    `medicao` VARCHAR(20) NOT NULL,
    `medidor` VARCHAR(30) NOT NULL,
    `tipo_alim` VARCHAR(50) NOT NULL,
    `ponto_alim` BOOLEAN NOT NULL,
    `circ_exclusivo` VARCHAR(50) NOT NULL,
    `numero_circuito` VARCHAR(50) NOT NULL,
    `circuito` VARCHAR(50) NOT NULL
);

CREATE TABLE `ativos_carapicuiba`.`tb_prod_campo`(
	`id_unico` INT NOT NULL PRIMARY KEY,
    `id_ponto` INT NOT NULL,
    `usuario_levantador` VARCHAR(50) NOT NULL,
    `data_hora_levantado` TEXT NOT NULL,
    `circ_exclusivo` varchar(50) NOT NULL,
    `validacao_backoffice` BOOLEAN NOT NULL
);

CREATE TABLE `ativos_carapicuiba`.`tb_pot_lampada`(
	`id_unico` INT NOT NULL PRIMARY KEY,
    `id_ponto` INT NOT NULL,
    `validacao_backoffice` BOOLEAN NOT NULL,
    `tipo_item` VARCHAR(50) NOT NULL,
    `tipo_lampada` VARCHAR(50) NOT NULL,
    `lampada` VARCHAR(50) NOT NULL,
    `quantidade` INT NOT NULL,
    `potencia` INT NOT NULL,
    `possui_reator` BOOLEAN NOT NULL,
    `potencia_reator` INT NOT NULL,
    `situacao` VARCHAR(50) NOT NULL
);

CREATE TABLE `ativos_carapicuiba`.`tb_coordenada`(
	`id_unico` INT PRIMARY KEY NOT NULL,
    `id_ponto` INT NOT NULL,
    `latitude_sugerida` DECIMAL(10,8) NOT NULL,
    `longitude_sugerida` DECIMAL(10,8) NOT NULL
);

/* INSERCAO DE DADOS PARA AS NOVAS TABELAS ALTERANDO O NOME E DADOS DA COLUNA "usuario_ponto" PARA "validacao_backoffice" COM DADOS DO TIPO BINÁRIO */
INSERT INTO ativos_carapicuiba.tb_backoffice
SELECT 
	id_unico,
    id_ponto,
    usuario_backoffice,
    data_backoffice,
    CASE 
		WHEN TRIM(usuario_ponto) = 'VALIDADO BACKOFFICE' THEN 1
        WHEN TRIM(usuario_ponto) = 'EXCLUIDO' THEN 0
	END AS validacao_backoffice
FROM dados_brutos_ativos.bruto_tb_carapicuiba;

INSERT INTO ativos_carapicuiba.tb_circuito
SELECT 
	id_unico,
    id_ponto,
        CASE
        WHEN TRIM(usuario_ponto) = 'VALIDADO BACKOFFICE' THEN 1
        WHEN TRIM(usuario_ponto) = 'EXCLUIDO' THEN 0
    END AS validacao_backoffice,
    medicao,
    medidor,
    tipo_alim,
    CASE 
		WHEN TRIM(ponto_alim) = 'SIM' THEN 1
		WHEN TRIM(ponto_alim) = 'NÃO' THEN 0
	END AS ponto_alim,
    circ_exclusivo,
    numero_circuito,
    circuito
FROM dados_brutos_ativos.bruto_tb_carapicuiba;

INSERT INTO ativos_carapicuiba.tb_prod_campo
SELECT 
	id_unico,
    id_ponto,
    usuario_levantador,
    data_hora_levantado,
    circ_exclusivo,
	CASE 
		WHEN TRIM(usuario_ponto) = 'VALIDADO BACKOFFICE' THEN 1
        WHEN TRIM(usuario_ponto) = 'EXCLUIDO' THEN 0
	END AS validacao_backoffice
FROM dados_brutos_ativos.bruto_tb_carapicuiba;

INSERT INTO ativos_carapicuiba.tb_pot_lampada
SELECT 
	id_unico, 
    id_ponto,
    CASE
		WHEN TRIM(usuario_ponto) = 'VALIDADO BACKOFFICE' THEN 1
        WHEN TRIM(usuario_ponto) = 'EXCLUIDO' THEN 0
	END AS validacao_backoffice,
    UPPER(tipo_item) AS tipo_item,
    UPPER(tipo_lampada) AS tipo_lampada,
	CASE 
		WHEN TRIM(lampada) = 'SEM LAMPADA' THEN 'SEM LAMPADA E LUMINARIA'
        ELSE TRIM(lampada)
	END lampada,
    CASE
		WHEN quantidade = 'N/A' THEN 0
        ELSE quantidade
	END AS quantidade,
    CASE
		WHEN potencia = 'N/A' THEN 0
        ELSE potencia
	END AS potencia,
	CASE
		WHEN possui_reator IN (400,250,100,'SIM') THEN 1
		WHEN possui_reator IN ('N/A','NAO') THEN 0
		ELSE possui_reator
	END AS possui_reator,
	CASE
		WHEN potencia_reator IN ('NAO','N/A') THEN 0
		ELSE potencia_reator
	END AS potencia_reator,
    situacao
FROM dados_brutos_ativos.bruto_tb_carapicuiba;

INSERT INTO ativos_carapicuiba.tb_coordenada 
SELECT 
	id_unico,
    id_ponto,
    latitude_sugerida,
    longitude_sugerida
FROM dados_brutos_ativos.bruto_tb_carapicuiba
;
