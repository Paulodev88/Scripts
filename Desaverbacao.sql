USE SRH0063
GO
--/*
DELETE FROM SRH0063.SRH0063.CNT_5VANOTACAOPESSOA 
WHERE 1 = 1
	AND B5V050Tipo = 141
	AND B5V995TEXTOLOG LIKE 'ANOTAÇÕES DE CONTAGEM EM DOBRO MIGRADAS APOS A MIGRAÇÃO PRINCIPAL'

INSERT INTO SRH0063.SRH0063.CNT_5VANOTACAOPESSOA(
        B5V015TipoAnotacao,   -- A QUEM SE REFERE? (1) ANOTACAO PARA EMPREGADO
        B5V020Pessoa,         -- MATRICULA PESSOA DA 51 (B51901IdPessoa)
        B5V021Empregado,      -- MATRICULA EMPREGADO (B51001NumMatricula)
        B5V030DataAnotacao,   -- DATA INICIO DA ANOTACAO (DATA DE REGISTRO)
        B5V031DataTermino,    -- DATA FIM DA ANOTACAO
		B5V033Dias,           -- DIFERENCAS DE DATA_ANOT / DATA_FIM_ANOT
        B5V042DataCadastro,   -- DATA ATUAL GETDATE() 
        B5V050Tipo,           -- ANOTACAO (00036 Informar Utilizacao De Ferias)
		B5V140IdAnotEmp,		-- SEQUENCIAL DA ANOTAÇÃO
		B5V210NumeroInf,		-- PERIODO AQUISITIVO
		B5V215NumeroInF5,     -- MES DA FOLHA
		B5V998EMPRESA,         -- EMPRESA
		B5V048TipoDocto,		-- TIPO DOCUMENTO
		B5V049NumeroDocto,	-- Nº DOCUMENTO		
		B5V04BNumProtocolo,	-- Nº PROTOCOLO
		B5V232ValDisInf2,     -- TIPO DE MOVIMENTO
		B5V100Texto,
		B5V995TEXTOLOG,
		B5V301TipoDocto,
		B5V302NumeDocto,
		B5V304CmplDocto
)
--*/
SELECT
        1 AS B5V015TipoAnotacao,
        B51901IdPessoa AS B5V020Pessoa,   
        B55001NumMatricula AS B5V021Empregado,  
        B55003PerInicDt AS B5V030DataAnotacao,
		B55004PerFinalDt AS B5V031DataTermino,
        B55005NunDias AS B5V033Dias,   
	    GETDATE() AS B5V042DataCadastro,
        141 AS B5V050Tipo,
		ROW_NUMBER() OVER (PARTITION BY B55001NumMatricula ORDER BY B55000Id) AS B5V140IdAnotEmp,
        (
        SELECT TOP 1 B5V140IdAnotEmp
        FROM SRH0063.SRH0063.CNT_5VANOTACAOPESSOA
        WHERE B5V021Empregado = B55001NumMatricula AND B5V050Tipo = 41 AND B5V140IdAnotEmp = B55002NumPerAquisit
        ) AS B5V210NumeroInf,
		B55103PerFolha AS B5V215NumeroInF5,
	    1 AS B5V998EMPRESA,
		5 AS B5V048TipoDocto,
		B55110Docto AS  B5V049NumeroDocto,
		B55111Protocolo AS B5V04BNumProtocolo,
		B55120TipoMovto AS B5V232ValDisInf2,
		B55051TxtObservacao AS B5V100Texto,
		'ANOTAÇÕES DE CONTAGEM EM DOBRO MIGRADAS APOS A MIGRAÇÃO PRINCIPAL' AS B5V995TEXTOLOG,
		(
			CASE
				WHEN (
					B55110Docto IS NOT NULL 
					OR B55111Protocolo IS NOT NULL
				) THEN 'PORTARIA'
				ELSE NULL
			END
		) AS B5V301TipoDocto,
		B55110Docto AS B5V302NumeDocto,
		B55111Protocolo AS B5V304CmplDocto
FROM SRH0019E0001.SRH0019E0001.CNT_55FERIAS
JOIN SRH0063.SRH0063.CAD_51EMPREG ON B55001NumMatricula = B51001NumMatricula --
WHERE 1=1
    AND B55102TipoMovto IN ('U', 'P')  -- 
    AND B55105TipoVantagem = 'F' --
    AND B55120TipoMovto IN (6) --
	AND B55007Filler is not null
	AND B55042DatInterrupcao is null
  --  AND B51328SituacaoFunc = 'A'	
ORDER BY B55001NumMatricula, B55000Id DESC

/*

/*
<table	vgol="tabela: 55; posiciona: vgol.Filtro.pesquisaTabela(51002,55001,55003,T4020); tabelaprotegida: 51; ds: 1;
filtrosql: B51328='A' AND B55102='U' AND B55105='F' AND B55007 IS NOT NULL AND B55042 IS NULL AND BT4070=1
	AND #FCOL(B51002,LIKE2,#nomeEmpregado); seleciona:nao; maxregs: 150;" class="gol-tab1">
*/


select * from SRH0019E0001.SRH0019E0001.CNT_55FERIAS, SRH0019E0001.SRH0019E0001.CAD_51EMPREG,  SRH0019E0001.SRH0019E0001.TAB_CNT_T4TipMovFeri
where 1=1
and B55120TipoMovto = BT4010Id --
and B55001NumMatricula = B51001NumMatricula --
--and B51328SituacaoFunc = 'A'
and B55102TipoMovto = 'U' --
and B55105TipoVantagem = 'F' --
and B55007Filler is not null
and B55042DatInterrupcao is null
and BT4070ContDobro = 1

*/




