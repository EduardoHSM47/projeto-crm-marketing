# Bronze — Dados Brutos

Esta camada contém os dados exatamente como vieram da fonte original, sem nenhuma transformação aplicada.

## Fonte

Dataset: [Customer Personality Analysis](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis)  
Plataforma: Kaggle  
Formato original: CSV (`marketing_campaign.csv`)  
Separador: tabulação (`\t`)  
Total de registros: 2.240 linhas  
Total de colunas: 29  

## Como os dados foram carregados

O arquivo CSV foi importado diretamente no MySQL via MySQL Workbench, sem nenhuma limpeza ou transformação prévia. A tabela resultante foi nomeada `marketing_campaign` no schema `projeto1`.

## Problemas identificados nesta camada

A inspeção inicial revelou os seguintes problemas, que foram tratados na camada Silver:

- `Dt_Customer` tipada como TEXT em vez de DATE
- `Marital_Status` com categorias inválidas: Absurd, YOLO e Alone
- `Year_Birth` com valores impossíveis: 1893, 1899 e 1900
- `Income` com outlier extremo de 666.666
- `Z_CostContact` e `Z_Revenue` com valor fixo para todos os registros

Todo o processo de inspeção está documentado em `silver/data_quality_checks.sql`.
