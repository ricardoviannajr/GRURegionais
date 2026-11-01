# Ponto de Controle de Desenvolvimento: GRURegionais

STATUS: DADOS AISWEB E INFRAESTRUTURA AERONÁUTICA CONSOLIDADOS

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
- Desenvolver scripts em `src/` para análise comparativa de capacidade de pista vs perfil de frota (ATR-72, E195, B737).
