-- =============================================
-- GOLD — KPIs Estratégicos de Marketing
-- Fonte: projeto1.marketing_campaign_silver
-- =============================================

-- Total de clientes na base limpa
SELECT COUNT(id) AS total_clientes
FROM projeto1.marketing_campaign_silver;

-- Média de compras por canal (comportamento médio por cliente)
SELECT ROUND(AVG(NumDealsPurchases),1) AS avg_deals,
       ROUND(AVG(NumWebPurchases),1) AS avg_web,
       ROUND(AVG(NumCatalogPurchases),1) AS avg_catalog,
       ROUND(AVG(NumStorePurchases),1) AS avg_store
FROM projeto1.marketing_campaign_silver;

-- Volume total de compras por canal (canal mais utilizado na base toda)
-- Resultado: loja física é o canal dominante
SELECT SUM(NumDealsPurchases) AS sum_deals,
       SUM(NumWebPurchases) AS sum_web,
       SUM(NumCatalogPurchases) AS sum_catalog,
       SUM(NumStorePurchases) AS sum_store
FROM projeto1.marketing_campaign_silver;

-- Taxa de aceitação por campanha (%)
-- Campanha 2 teve a menor taxa (1.4%) e a última campanha a maior (15.1%)
SELECT ROUND(AVG(AcceptedCmp1) * 100,1) AS Campanha1,
       ROUND(AVG(AcceptedCmp2) * 100,1) AS Campanha2,
       ROUND(AVG(AcceptedCmp3) * 100,1) AS Campanha3,
       ROUND(AVG(AcceptedCmp4) * 100,1) AS Campanha4,
       ROUND(AVG(AcceptedCmp5) * 100,1) AS Campanha5,
       ROUND(AVG(Response) * 100,1) AS Ultima_Campanha
FROM projeto1.marketing_campaign_silver;

-- Clientes ativos x inativos
-- Critério: Recency > 50 dias = inativo (baseado na média de Recency da base = 49 dias)
SELECT 
    CASE
        WHEN Recency > 50 THEN 'Inativo'
        ELSE 'Ativo'
    END AS AtivosxInativos,
    COUNT(*) AS Total
FROM projeto1.marketing_campaign_silver
GROUP BY AtivosxInativos;
