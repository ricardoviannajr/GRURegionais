import { describe, expect, it } from 'vitest';
import { airports, allAirports } from './airports.js';

describe('airport dataset', () => {
  it('combines all regional airports with the GRU reference marker', () => {
    expect(airports).toHaveLength(12);
    expect(allAirports).toHaveLength(13);
    expect(allAirports.every(({ latitude, longitude }) => Number.isFinite(latitude) && Number.isFinite(longitude))).toBe(true);
  });

  it('keeps the AISWEB ICAO code when the concession dataset has a different code', () => {
    expect(airports.find(({ iata }) => iata === 'BRB').aisweb.icao_aisweb).toBe('SSRS');
    expect(airports.find(({ iata }) => iata === 'NSR').aisweb.icao_aisweb).toBe('SWKQ');
    expect(airports.find(({ iata }) => iata === 'PBQ').aisweb.icao_aisweb).toBe('SDH2');
  });

  it('classifies only SBUF, SWKQ, and SDH2 as AP-0', () => {
    expect(airports.filter(({ apClass }) => apClass === 'AP-0').map(({ aisweb }) => aisweb.icao_aisweb)).toEqual(['SBUF', 'SWKQ', 'SDH2']);
    expect(airports.filter(({ apClass }) => apClass === 'AP-1')).toHaveLength(9);
  });
});