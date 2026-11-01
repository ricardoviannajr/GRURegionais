import { useEffect, useState } from 'react';
import { RadioTower } from 'lucide-react';
import { AirportPanel } from './components/AirportPanel.jsx';
import { RegionalMap } from './components/RegionalMap.jsx';
import { allAirports, airports } from './data/airports.js';
import { fetchWeather } from './lib/weather.js';
import brandLogo from '../docs/docs_gru/gruregionais.png';

export function App() {
  const [selectedId, setSelectedId] = useState(airports[0].id);
  const [weather, setWeather] = useState({ loading: true, data: null, error: '' });
  const selectedAirport = allAirports.find((airport) => airport.id === selectedId) ?? null;

  useEffect(() => {
    if (!selectedAirport) {
      setWeather({ loading: false, data: null, error: '' });
      return undefined;
    }

    const controller = new AbortController();
    setWeather({ loading: true, data: null, error: '' });
    fetchWeather(selectedAirport, controller.signal)
      .then((data) => setWeather({ loading: false, data, error: '' }))
      .catch((error) => {
        if (error.name !== 'AbortError') {
          setWeather({ loading: false, data: null, error: 'Clima indisponível. Verifique a conexão.' });
        }
      });
    return () => controller.abort();
  }, [selectedAirport]);

  return (
    <main className="app-shell">
      <header className="topbar">
        <div className="brand-lockup">
          <img className="brand-logo" src={brandLogo} alt="GRU Regionais" />
        </div>
        <div className="network-status"><RadioTower size={15} /> <span>12 AEROPORTOS</span><i /></div>
      </header>

      <section className="workspace">
        {selectedAirport?.aisweb ? (
          <AirportPanel
            airport={selectedAirport}
            weather={weather}
          />
        ) : (
          <aside className="airport-panel airport-panel-empty" aria-label="Ficha do aeroporto">
            <span>Selecione um aeroporto regional no mapa.</span>
          </aside>
        )}
        <RegionalMap
          airports={allAirports}
          selectedId={selectedId}
          weather={weather}
          onSelect={setSelectedId}
        />
      </section>
      <footer className="app-footer">
        <span>GESTÃO DE AEROPORTOS REGIONAIS</span>
      </footer>
    </main>
  );
}