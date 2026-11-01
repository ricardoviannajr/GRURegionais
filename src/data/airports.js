import regionalData from '../../docs/ampliar/aeroportos_dados.json';
import aiswebData from '../../docs/aisweb/aerodromos_aisweb.json';
import { parseCoordinate } from '../lib/coordinates.js';

const ap0Codes = new Set(['SBUF', 'SWKQ', 'SDH2']);

export const airports = regionalData.map((regional) => {
  const aisweb = aiswebData.find((airport) => airport.id === regional.id);
  return {
    ...regional,
    aisweb,
    apClass: ap0Codes.has(aisweb.icao_aisweb) ? 'AP-0' : 'AP-1',
    latitude: parseCoordinate(aisweb.coordenadas.latitude),
    longitude: parseCoordinate(aisweb.coordenadas.longitude),
  };
});

export const gruAirport = {
  id: 'gru',
  aeroporto: 'Aeroporto Internacional de São Paulo/Guarulhos',
  cidade: 'Guarulhos',
  uf: 'SP',
  regiao: 'Sudeste',
  icao: 'SBGR',
  iata: 'GRU',
  latitude: -23.4356,
  longitude: -46.4731,
  perfil: 'Hub internacional e sede da concessão GRU Airport',
};

export const allAirports = [...airports, gruAirport];