import { describe, expect, it } from 'vitest';
import { parseCoordinate } from './coordinates.js';

describe('parseCoordinate', () => {
  it('converts southern and western AISWEB coordinates to negative decimals', () => {
    expect(parseCoordinate('09° 24\' 04" S')).toBeCloseTo(-9.4011, 4);
    expect(parseCoordinate('038° 15\' 04" W')).toBeCloseTo(-38.2511, 4);
  });

  it('keeps northern and eastern coordinates positive', () => {
    expect(parseCoordinate('12° 30\' 00" N')).toBe(12.5);
    expect(parseCoordinate('045° 00\' 00" E')).toBe(45);
  });

  it('rejects values that do not follow the AISWEB coordinate format', () => {
    expect(() => parseCoordinate('coordenada indisponível')).toThrow('Coordenada inválida');
  });
});