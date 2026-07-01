-- =============================================
-- GOLD — Análises Exploratórias de Marketing
-- Fonte: projeto1.marketing_campaign_silver
-- =============================================

-- Segmentação por faixa etária
-- Atenção: idade calculada com base na data atual (YEAR(CURDATE()))
-- O resultado pode variar conforme o ano em que a query é executada
SELECT
    CASE
        WHEN YEAR(CURDATE()) - Year_Birth >= 30 AND YEAR(CURDATE()) - Year_Birth < 41 THEN '30-40'
        WHEN YEAR(CURDATE()) - Year_Birth >= 41 AND YEAR(CURDATE()) - Year_Birth < 51 THEN '41-50'
        WHEN YEAR(CURDATE()) - Year_Birth >= 51 AND YEAR(CURDATE()) - Year_Birth < 61 THEN '51-60'
        WHEN YEAR(CURDATE()) - Year_Birth >= 61 AND YEAR(CURDATE()) - Year_Birth < 71 THEN '61-70'
        ELSE '71+'
    END AS faixa_etaria,
    COUNT(*) AS total_clientes
FROM projeto1.marketing_campaign_silver
GROUP BY faixa_etaria
ORDER BY faixa_etaria;

-- Segmentação por faixa de renda
SELECT 
    CASE
        WHEN Income >= 1000  AND Income < 10000 THEN '1k-10k'
        WHEN Income >= 10000 AND Income < 20000 THEN '10k-20k'
        WHEN Income >= 20000 AND Income < 30000 THEN '20k-30k'
        WHEN Income >= 30000 AND Income < 40000 THEN '30k-40k'
        WHEN Income >= 40000 AND Income < 50000 THEN '40k-50k'
        WHEN Income >= 50000 AND Income < 60000 THEN '50k-60k'
        WHEN Income >= 60000 AND Income < 70000 THEN '60k-70k'
        ELSE '70k+'
    END AS Faixa_Renda,
    COUNT(*) AS total
FROM projeto1.marketing_campaign_silver
GROUP BY Faixa_Renda
ORDER BY Faixa_Renda;

-- Segmentação por estado civil com taxa de aceitação da última campanha
-- Solteiros e divorciados respondem quase o dobro em relação a casados
SELECT Marital_Status,
       COUNT(*) AS Total,
       ROUND(AVG(Response) * 100, 2) AS Taxa_Aceitacao_Response
FROM projeto1.marketing_campaign_silver
GROUP BY Marital_Status
ORDER BY Total DESC;

-- Valor gasto por categoria e estado civil
-- Apesar de 'Outros/Não Informado' apresentar o maior gasto médio,
-- o grupo possui apenas 4 clientes — sem relevância estatística.
-- Entre os grupos representativos, viúvos (Widow) têm o maior gasto médio.
SELECT Marital_Status, 
       COUNT(*) AS Total_Clientes,
       SUM(MntWines) AS Total_Wines, 
       SUM(MntFruits) AS Total_Fruits,
       SUM(MntMeatProducts) AS Total_Meat,
       SUM(MntFishProducts) AS Total_Fish,
       SUM(MntSweetProducts) AS Total_Sweet,
       SUM(MntGoldProds) AS Total_Premium,
       SUM(MntWines + MntFruits + MntMeatProducts + 
           MntFishProducts + MntSweetProducts + MntGoldProds) AS Gasto_Total,
       ROUND(AVG(MntWines + MntFruits + MntMeatProducts + 
           MntFishProducts + MntSweetProducts + MntGoldProds), 2) AS Gasto_Medio
FROM projeto1.marketing_campaign_silver
GROUP BY Marital_Status
ORDER BY Gasto_Medio DESC;

-- Impacto de dependentes no gasto, controlando por renda (quartis)
-- Após controlar a variável renda por meio de quartis, clientes sem dependentes
-- apresentam o maior gasto médio em todas as faixas de renda.
-- À medida que o número de dependentes aumenta, o gasto médio tende a diminuir,
-- indicando que essa relação não é explicada apenas pela diferença de renda entre os grupos.
WITH renda_quartil AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY Income) AS Quartil
    FROM projeto1.marketing_campaign_silver
)
SELECT
    Quartil,
    Kidhome + Teenhome AS Qtd_Dependentes,
    COUNT(*) AS Total_Clientes,
    ROUND(AVG(
        MntWines + MntFruits + MntMeatProducts +
        MntFishProducts + MntSweetProducts + MntGoldProds
    ), 2) AS Gasto_Medio
FROM renda_quartil
GROUP BY Quartil, Qtd_Dependentes
ORDER BY Quartil, Qtd_Dependentes;
