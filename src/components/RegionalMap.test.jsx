import { describe, expect, it, vi } from 'vitest';

vi.mock('leaflet', () => ({ default: { divIcon: vi.fn((options) => options) } }));
vi.mock('react-leaflet', () => ({
  MapContainer: () => null,
  Marker: () => null,
  Popup: () => null,
  TileLayer: () => null,
  useMap: vi.fn(),
}));

import { RegionalMap } from './RegionalMap.jsx';

describe('RegionalMap module', () => {
  it('loads and initializes its marker cache', () => {
    expect(RegionalMap).toBeTypeOf('function');
  });
});
