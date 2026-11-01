import { describe, expect, it } from 'vitest';
import { flights, flightsForAirport } from './flights.js';

describe('flight schedule', () => {
  it('includes all 17 supplied flight legs', () => {
    expect(flights).toHaveLength(17);
  });

  it('shows only legs connected to the selected airport', () => {
    expect(flightsForAirport('SBAC')).toHaveLength(4);
    expect(flightsForAirport('SBLE')).toHaveLength(4);
    expect(flightsForAirport('SNHS')).toHaveLength(2);
    expect(flightsForAirport('SBUF')).toHaveLength(0);
  });

  it('returns no flight legs for airports absent from the supplied schedule', () => {
    expect(flightsForAirport('SBUF')).toHaveLength(0);
    expect(flightsForAirport('SWGN')).toHaveLength(0);
  });

  it('preserves the supplied operator, aircraft, flight number, and times', () => {
    expect(flightsForAirport('SNGN')).toEqual([
      expect.objectContaining({ airline: 'Azul Conecta', aircraft: 'Cessna C208B Grand Caravan', number: 'AD 5102', departure: '14:35', arrival: '15:35' }),
      expect.objectContaining({ airline: 'Azul Conecta', aircraft: 'Cessna C208B Grand Caravan', number: 'AD 5103', departure: '16:05', arrival: '17:05' }),
    ]);
  });
});