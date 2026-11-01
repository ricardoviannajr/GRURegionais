import { describe, expect, it } from 'vitest';
import { airports } from './airports.js';
import { collaborators, collaboratorsForAirport, collaboratorsWithoutAirport } from './collaborators.js';

describe('collaborator directory', () => {
  it('includes all collaborator records with an identified airport', () => {
    expect(collaborators).toHaveLength(23);
    expect(collaborators.every(({ airportIata, role }) => airportIata && role)).toBe(true);
  });

  it('maps assigned collaborators to the corresponding airport IATA code', () => {
    expect(collaboratorsForAirport('ARX').map(({ name }) => name)).toEqual(['Adilton', 'Avelino Luiz']);
    expect(collaboratorsForAirport('PBQ').map(({ name }) => name)).toEqual(['Andeilton Silva', 'Henrique Cruz']);
    expect(collaboratorsForAirport('PAF').map(({ name }) => name)).toEqual(['Andrey', 'Pedro']);
    expect(collaboratorsForAirport('QGP').map(({ name }) => name)).toEqual(['Humberto', 'Lucas Luz']);
  });

  it('uses only IATA codes present in the airport directory', () => {
    const airportCodes = new Set(airports.map(({ iata }) => iata));
    expect(collaborators.filter(({ airportIata }) => airportIata).every(({ airportIata }) => airportCodes.has(airportIata))).toBe(true);
  });
});