-- =============================================
-- CAMADA BRONZE — Inspeção e Diagnóstico
-- Objetivo: entender a estrutura e qualidade
-- do dado bruto antes de qualquer transformação
-- =============================================

-- Estrutura e tipos de dado da tabela
DESCRIBE projeto1.marketing_campaign;

-- Total de clientes na base bruta
SELECT COUNT(*) AS total_clientes
FROM projeto1.marketing_campaign;

-- Verificando duplicatas por ID
SELECT ID, COUNT(*) AS qtd
FROM projeto1.marketing_campaign
GROUP BY ID
HAVING qtd > 1;

-- Verificando valores nulos nas colunas mais suspeitas
-- (colunas que dependem de preenchimento manual ou fonte externa)
SELECT 'Income' AS coluna, COUNT(*) - COUNT(Income) AS qtd_nulos
FROM projeto1.marketing_campaign
UNION ALL
SELECT 'Education', COUNT(*) - COUNT(Education)
FROM projeto1.marketing_campaign
UNION ALL
SELECT 'Marital_Status', COUNT(*) - COUNT(Marital_Status)
FROM projeto1.marketing_campaign
UNION ALL
SELECT 'Dt_Customer', COUNT(*) - COUNT(Dt_Customer)
FROM projeto1.marketing_campaign;

-- Verificando categorias únicas em Marital_Status
-- Encontrado: Absurd, YOLO (inválidos) e Alone (redundante com Single)
SELECT DISTINCT Marital_Status
FROM projeto1.marketing_campaign;

-- Testando o tratamento de Marital_Status antes de aplicar
SELECT 
    CASE 
        WHEN Marital_Status = 'Alone' THEN 'Single'
        WHEN Marital_Status IN ('Absurd', 'YOLO') THEN 'Outros/Não Informado'
        ELSE Marital_Status
    END AS Marital_Status
FROM projeto1.marketing_campaign;

-- Testando conversão de Dt_Customer de TEXT para DATE
SELECT STR_TO_DATE(Dt_Customer, '%d-%m-%Y') AS Dt_Customer
FROM projeto1.marketing_campaign;

-- Verificando outliers em Year_Birth (ordenação crescente)
-- Encontrado: 1893, 1899, 1900 (biologicamente impossíveis)
SELECT Year_Birth
FROM projeto1.marketing_campaign
ORDER BY Year_Birth ASC;

-- Verificando outliers em Income (ordenação decrescente)
-- Encontrado: 666.666 (extremamente acima do restante da base)
SELECT Income
FROM projeto1.marketing_campaign
ORDER BY Income DESC;

-- Validando quais linhas serão removidas pelos filtros de outlier
SELECT *
FROM projeto1.marketing_campaign
WHERE Year_Birth NOT IN (1893, 1899, 1900)
  AND Income < 666666;


-- =============================================
-- CAMADA SILVER — Criação da Tabela Limpa
-- Objetivo: aplicar todos os tratamentos e
-- criar a tabela final pronta para análise
-- Tratamentos aplicados:
--   - Marital_Status: padronização de categorias inválidas
--   - Dt_Customer: conversão de TEXT para DATE
--   - Year_Birth: remoção de anos impossíveis (< 1900)
--   - Income: remoção de outlier extremo (666.666)
--   - Z_CostContact e Z_Revenue: removidas por não
--     agregarem valor analítico (valor fixo em todos os registros)
-- Resultado: 2.240 → 2.212 linhas
-- =============================================

CREATE TABLE projeto1.marketing_campaign_silver AS
SELECT
    ID,
    Year_Birth,
    Education,
    CASE 
        WHEN Marital_Status = 'Alone' THEN 'Single'
        WHEN Marital_Status IN ('Absurd', 'YOLO') THEN 'Outros/Não Informado'
        ELSE Marital_Status
    END AS Marital_Status,
    Income,
    Kidhome,
    Teenhome,
    STR_TO_DATE(Dt_Customer, '%d-%m-%Y') AS Dt_Customer,
    Recency,
    MntWines,
    MntFruits,
    MntMeatProducts,
    MntFishProducts,
    MntSweetProducts,
    MntGoldProds,
    NumDealsPurchases,
    NumWebPurchases,
    NumCatalogPurchases,
    NumStorePurchases,
    NumWebVisitsMonth,
    AcceptedCmp3,
    AcceptedCmp4,
    AcceptedCmp5,
    AcceptedCmp1,
    AcceptedCmp2,
    Complain,
    Response
FROM projeto1.marketing_campaign
WHERE Year_Birth NOT IN (1893, 1899, 1900)
  AND Income < 666666;

-- Confirmando total de linhas na tabela Silver
SELECT COUNT(*) AS total_silver
FROM projeto1.marketing_campaign_silver;
