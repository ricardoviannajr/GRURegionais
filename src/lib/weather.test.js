import { describe, expect, it } from 'vitest';
import { describeWeatherCode } from './weather.js';

describe('describeWeatherCode', () => {
  it('returns a Portuguese description for known weather codes', () => {
    expect(describeWeatherCode(0)).toBe('Céu limpo');
    expect(describeWeatherCode(95)).toBe('Trovoada');
  });

  it('falls back for unknown weather codes', () => {
    expect(describeWeatherCode(999)).toBe('Condição não informada');
  });
});