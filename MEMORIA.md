# Ponto de Controle de Desenvolvimento: GRURegionais

STATUS: PAINEL WEB REGIONAL IMPLEMENTADO

## Contexto e Objetivo
- Coleta e estruturação de dados aeronáuticos oficiais dos 12 aeroportos regionais (Programa AmpliAR / GRU Airport) via base pública do DECEA / AISWEB.
- Resolução e validação cadastral de códigos ICAO, pistas, cabeceiras, PCN, frequências de comunicação e regras de operação.

## Decisões Técnicas e Entregas
- Criado diretório `docs/aisweb/` com a base aeronáutica oficial:
  - `aerodromos_aisweb.json`: Dataset padronizado contendo dados de pista, PCN, coordenadas, elevação, órgãos ATS/CINDACTA e frequências de rádio.
  - `01_fichas_aeronauticas_aisweb.md`: Relatório técnico executivo com tabela comparativa de pistas, fichas individuais e notas de padronização ICAO (Barreirinhas SSRS vs SBRR; São Raimundo Nonato SWKQ vs SWSR; Porto Alegre do Norte SDH2 vs SWPQ).
- Atualizado `docs/ampliar/aeroportos_dados.json` com mapeamento cruzado (`icao_aisweb`).
- Atualizado `README.md` com a nova estrutura de documentação e tabela de referência.

## Próximos Passos
- Validar a interface no navegador e alinhar o modo de persistência antes do uso multiusuário em pasta compartilhada.
- O painel estático usa React/Vite, base local AISWEB, clima Open-Meteo e tiles Esri World Street Map.
- Clique no fundo do mapa não altera a ficha; sem controle para deixá-la vazia; ao selecionar GRU, aparece orientação neutra sem dados do terminal.
- Título “Cobertura nacional” deslocado para não sobrepor os controles de zoom.
- Cabeçalho do painel agora usa “Aeroportos Regionais”, sem selo de contagem.
- Classificação dos regionais: AP-0 (SBUF, SWKQ, SDH2) em amarelo; demais AP-1 em vermelho, no mapa e ao lado de ICAO/IATA.
- Colaboradores reposicionados para aparecerem imediatamente acima do investimento estimado.
- Cadastro de 23 colaboradores com lotação/função identificadas e exibidas por aeroporto; Humberto e Lucas Luz em Garanhuns, Pedro em Paulo Afonso.
- Cadastro de 17 trechos aéreos na seção “Voos”, antes do AISWEB; cada ficha mostra apenas trechos associados ao ICAO e mantém a lista vazia sem voos. Horários sem data informada.
- Por ser um painel estático sem autenticação, itinerários, dados pessoais e detalhes operacionais sensíveis do DOCX não são incluídos.
- Popup alterna a camada do mapa entre ruas Esri e imagem de satélite, centralizando o aeroporto; tile de Paulo Afonso validado com HTTP 200.
- Corrigida colisão entre ícone lucide `Map` e o construtor global `Map` no módulo do mapa; teste de importação evita falha de inicialização.
- Cabeçalho usa `docs/docs_gru/gruregionais.png` como wordmark oficial.
- Marcadores do mapa exibem etiquetas ICAO fixas, priorizando o código oficial AISWEB.
- Legenda dos marcadores regionais simplificada para “Regionais”.
- Rodapé sem contagem redundante; layout bloqueia rolagem da página e mantém rolagem vertical no painel lateral em telas estreitas.
- A ficha não inclui edição de status ou observações; o painel permanece dedicado a AISWEB, equipe, investimento e clima.
- `npm test`, `npm run build` e `npm audit` aprovados após atualização do Vitest.
