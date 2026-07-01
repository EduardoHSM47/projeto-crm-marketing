# Projeto 1 — Análise de CRM e Marketing de Clientes

## Contexto do Projeto

A empresa analisada é uma varejista de produtos alimentícios premium (vinhos, carnes, peixes, frutas e doces) que opera em lojas físicas e canais digitais (web e catálogo). Com base de clientes cadastrada entre 2012 e 2014, a empresa utiliza campanhas de marketing direto para engajar sua base e impulsionar vendas.

O objetivo deste projeto é analisar o comportamento de compra e o perfil dos clientes para identificar oportunidades de segmentação e melhorar a eficiência das campanhas de marketing.

As análises cobrem quatro áreas principais:

- Perfil demográfico dos clientes: segmentação por idade, renda e estado civil
- Comportamento de compra: canal preferido e categorias de maior gasto
- Performance de campanhas: taxa de aceitação por campanha e por perfil de cliente
- Atividade da base: proporção de clientes ativos vs inativos

Os scripts SQL de limpeza estão em [silver/data_quality_checks.sql](silver/data_quality_checks.sql).
Os scripts de análise estão em [gold/marketing_kpis.sql](gold/marketing_kpis.sql) e [gold/exploratory_analysis.sql](gold/exploratory_analysis.sql).

---

## Estrutura dos Dados e Inspeção Inicial

A base consiste em uma única tabela com 2.240 registros originais, cada um representando um cliente único. Após limpeza, a base final ficou com 2.212 clientes.

| Grupo | Colunas | Descrição |
|---|---|---|
| Dados pessoais | ID, Year_Birth, Education, Marital_Status, Income | Perfil demográfico |
| Dependentes | Kidhome, Teenhome | Filhos e adolescentes em casa |
| Engajamento | Recency, Dt_Customer | Última compra e data de cadastro |
| Gasto por categoria | MntWines, MntFruits, MntMeatProducts, MntFishProducts, MntSweetProducts, MntGoldProds | Valor gasto por tipo de produto nos últimos 2 anos |
| Canal de compra | NumWebPurchases, NumCatalogPurchases, NumStorePurchases, NumDealsPurchases | Quantidade de compras por canal |
| Campanhas | AcceptedCmp1-5, Response | Aceitação de cada campanha (0 ou 1) |
| Outros | Complain | Reclamações nos últimos 2 anos |

Problemas encontrados na inspeção inicial:

- `Dt_Customer` tipada como TEXT em vez de DATE
- `Marital_Status` com categorias inválidas: Absurd, YOLO e Alone
- `Year_Birth` com valores impossíveis: 1893, 1899 e 1900
- `Income` com outlier extremo de 666.666 (muito acima do restante da base)
- `Z_CostContact` e `Z_Revenue` com valor fixo para todos os clientes, sem utilidade analítica

---

## Resumo Executivo

A base de clientes é composta majoritariamente por pessoas entre 51-60 anos, casadas e com renda acima de 70 mil, perfil compatível com consumidores de produtos premium. Apesar disso, quase metade da base está inativa há mais de 50 dias. A loja física é o canal com maior volume de compras, e clientes sem parceiro respondem quase o dobro às campanhas em comparação com casados.

---

## Análise dos Insights

### Perfil Demográfico

A faixa etária dominante é 51-60 anos com 678 clientes (31% da base), seguida de 61-70 anos com 485 clientes. Menos de 10% da base tem menos de 40 anos, o que deixa claro que o público é maduro.

Em termos de renda, 506 clientes têm renda acima de 70k, a maior faixa isolada. Somando as faixas acima de 50k, mais da metade da base tem renda elevada.

Quanto ao estado civil, 857 clientes são casados (39%) e 571 vivem juntos (26%), ou seja, 65% da base tem parceiro. Apesar de serem apenas 76 clientes, o grupo de viúvos apresenta o maior gasto médio entre os estados civis com representatividade estatística relevante.

### Comportamento de Compra

A loja física é o canal dominante com média de 5,8 compras por cliente, contra 4,1 no canal web, 2,7 em catálogo e 2,3 com desconto.

Vinhos lideram o gasto em todas as segmentações: em clientes casados, por exemplo, o gasto total em vinhos chega a 256 mil, bem acima de qualquer outra categoria.

Vale destacar uma limitação encontrada nos dados: não é possível cruzar valor monetário com canal de compra diretamente. As colunas de valor registram gasto por categoria de produto, não por canal. A análise de canal foi feita com base em quantidade de compras.

### Performance de Campanhas

Taxa de aceitação por campanha:

| Campanha | Taxa de Aceitação |
|---|---|
| Campanha 1 | 6.4% |
| Campanha 2 | 1.4% |
| Campanha 3 | 7.4% |
| Campanha 4 | 7.4% |
| Campanha 5 | 7.3% |
| Última Campanha (Response) | 15.1% |

Olhando a evolução das campanhas, a Campanha 2 foi a pior da série com apenas 1.4% de aceitação, enquanto a última campanha atingiu 15.1%, mais que o dobro de qualquer outra. Esse padrão pode indicar aprendizado ao longo do tempo, melhora na segmentação ou uma oferta mais alinhada ao perfil da base. A Campanha 2 merece investigação específica para entender o que a diferenciou negativamente das demais.

Clientes sem parceiro respondem significativamente melhor: solteiros (22,6%) e divorciados (20,8%) têm taxa de aceitação quase duas vezes maior que casados (11,4%) e pessoas que vivem juntas (10,5%).

### Atividade da Base

1.080 clientes estão inativos (49% da base), enquanto 1.132 são ativos (51%). A base está praticamente dividida ao meio, o que confirma que o critério de corte na média de Recency foi adequado.

---

## Recomendações

Com base nos dados analisados, algumas ações merecem atenção do time de marketing:

Quase metade da base está inativa há mais de 50 dias. Uma campanha de reativação direcionada a esse grupo, com foco em vinhos e carnes (categorias de maior gasto), pode recuperar receita sem custo de aquisição.

Clientes solteiros e divorciados respondem quase o dobro às campanhas. Segmentar comunicações por estado civil aumentaria a eficiência do investimento, concentrando esforços onde o retorno é historicamente maior.

O canal digital já ocupa o segundo lugar em volume de compras. Investir na experiência web para o público 51-60 anos pode aumentar o volume total sem canibalizar a loja física.

Clientes sem filhos ou adolescentes em casa apresentam maior gasto médio em todas as faixas de renda. Esse grupo é o mais responsivo para ofertas de ticket alto, independentemente do nível de renda.

---

## Premissas e Limitações

Critério de cliente ativo/inativo: clientes com Recency acima de 50 dias foram classificados como inativos, com base na média de Recency da base (49 dias, arredondado para 50). Em contexto real, esse critério seria definido junto ao time de CRM.

Categorias inválidas em Marital_Status: os valores Absurd e YOLO foram agrupados como "Outros/Não Informado" por não representarem estados civis válidos. O valor Alone foi mapeado para Single por similaridade semântica. Em produção, esses casos seriam verificados na fonte dos dados antes de qualquer tratamento.

Outliers removidos: 3 registros com Year_Birth anterior a 1900 e 1 registro com Income de 666.666 foram removidos por inconsistência. A remoção foi baseada em análise exploratória com MIN/MAX e ordenação.

Limitação de canal x valor: o dataset não permite calcular receita por canal de compra. Os valores monetários estão registrados por categoria de produto, não por canal, o que limitou essa análise a volume de transações.

Grupo "Outros/Não Informado": a taxa de aceitação de 50% desse grupo representa apenas 4 clientes e não tem relevância estatística. Foi reportado por completude, mas não utilizado nas recomendações.
