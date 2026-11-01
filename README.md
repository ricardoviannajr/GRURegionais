# GRURegionais - Gestão e Dados dos 12 Aeroportos do Programa AmpliAR (GRU Airport)

Repositório dedicado à estruturação de dados, documentação técnica, parâmetros aeronáuticos e acompanhamento da concessão e modernização dos 12 aeroportos regionais incorporados pela **GRU Airport** no âmbito do **Programa AmpliAR** (Ministério de Portos e Aeroportos / ANAC).

---

## 📌 Contexto Rápido
No âmbito da primeira rodada do **Programa AmpliAR** (Portaria MPOR nº 373/2025), a concessionária do Aeroporto Internacional de Guarulhos (**GRU Airport**) assumiu um lote de 12 aeroportos regionais estratégicos com investimento estimado em infraestrutura direta de **R$ 630,5 milhões** (pacote contratual de ~R$ 731,6 milhões).

---

## 📁 Estrutura de Documentação

### 1. Programa AmpliAR e Concessão (`docs/ampliar/`)
- [`01_visao_geral_ampliar_gru.md`](docs/ampliar/01_visao_geral_ampliar_gru.md): Visão executiva, modelo do leilão B3, regras de reequilíbrio contratual e tabela comparativa consolidada.
- [`02_fichas_tecnicas_aeroportos.md`](docs/ampliar/02_fichas_tecnicas_aeroportos.md): Detalhamento individual dos 12 aeroportos (códigos ICAO/IATA, vocações regionais, investimentos e intervenções prioritárias).
- [`03_marco_regulatorio_fontes.md`](docs/ampliar/03_marco_regulatorio_fontes.md): Portarias, acórdãos do TCU, resoluções da ANAC e fontes governamentais.
- [`aeroportos_dados.json`](docs/ampliar/aeroportos_dados.json): Base de dados estruturada em JSON com metadados para consumo por scripts e dashboards.

### 2. Informações Aeronáuticas Oficiais (`docs/aisweb/`)
- [`01_fichas_aeronauticas_aisweb.md`](docs/aisweb/01_fichas_aeronauticas_aisweb.md): Parâmetros aeronáuticos oficiais do AISWEB/DECEA (dimensões de pista, PCN, elevação, regras de voo, telecomunicações e notas de padronização de códigos ICAO).
- [`aerodromos_aisweb.json`](docs/aisweb/aerodromos_aisweb.json): Dataset completo em JSON com dados operacionais oficiais do DECEA/ROTAER.

---

## 🛫 Os 12 Aeroportos Concedidos

| # | Aeroporto | UF | ICAO AISWEB | IATA | Investimento Previsto |
|---|---|:---:|:---:|:---:|:---:|
| 1 | **Paulo Afonso** | BA | `SBUF` | PAF | R$ 106,2 M |
| 2 | **Lençóis (Horácio de Mattos)** | BA | `SBLE` | LEC | R$ 80,2 M |
| 3 | **Vilhena (Brig. Camarão)** | RO | `SBVH` | BVH | R$ 74,6 M |
| 4 | **Barreirinhas** | MA | `SSRS` | BRB | R$ 58,1 M |
| 5 | **Araguaína** | TO | `SWGN` | AUX | R$ 55,5 M |
| 6 | **São Raimundo Nonato (Serra da Capivara)** | PI | `SWKQ` | NSR | R$ 55,5 M |
| 7 | **Cacoal (Cap. do Café)** | RO | `SSKW` | OAL | R$ 49,8 M |
| 8 | **Aracati (Dragão do Mar / Canoa Quebrada)** | CE | `SBAC` | ARX | R$ 43,1 M |
| 9 | **Serra Talhada (Santa Magalhães)** | PE | `SNHS` | SET | R$ 40,5 M |
| 10 | **Porto Alegre do Norte** | MT | `SDH2` | PBQ | R$ 25,3 M |
| 11 | **Garanhuns** | PE | `SNGN` | QGP | R$ 22,1 M |
| 12 | **Araripina** | PE | `SNAB` | JAO | R$ 19,6 M |
