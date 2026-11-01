import { Activity, ArrowUpRight, CloudSun, Gauge, MapPin, Radio, Wind } from 'lucide-react';
import { CollaboratorSection } from './CollaboratorSection.jsx';
import { FlightSchedule } from './FlightSchedule.jsx';
import { describeWeatherCode } from '../lib/weather.js';

function DataLine({ label, value, icon: Icon }) {
  return (
    <div className="data-line">
      <span className="data-icon"><Icon size={15} /></span>
      <span className="data-label">{label}</span>
      <strong>{value || 'Não informado'}</strong>
    </div>
  );
}

function WeatherCard({ weather }) {
  if (weather.loading) return <div className="weather-card weather-muted"><CloudSun size={18} /> Consultando condições locais...</div>;
  if (weather.error) return <div className="weather-card weather-muted"><CloudSun size={18} /> {weather.error}</div>;
  const current = weather.data;
  return (
    <section className="weather-card">
      <div className="weather-heading"><CloudSun size={17} /><span>CONDIÇÃO LOCAL</span><small>AGORA</small></div>
      <div className="weather-main">
        <strong>{Math.round(current.temperature_2m)}°</strong>
        <span>{describeWeatherCode(current.weather_code)}</span>
      </div>
      <div className="weather-details">
        <span><Wind size={13} /> {Math.round(current.wind_speed_10m)} km/h</span>
        <span><Activity size={13} /> {Math.round(current.relative_humidity_2m)}% umid.</span>
      </div>
      <small className="weather-credit">Fonte: Open-Meteo</small>
    </section>
  );
}

export function AirportPanel({ airport, weather }) {
  const isRegional = Boolean(airport.aisweb);
  const aisweb = airport.aisweb;
  const icao = aisweb?.icao_aisweb ?? airport.icao;

  return (
    <aside className="airport-panel">
      <div className="panel-heading">
        <div><span className="eyebrow">PAINEL DE GESTÃO</span><h1>Aeroportos Regionais</h1></div>
      </div>

      <div className="airport-identity">
        <div className="airport-codes">
          <span>{icao}</span><b>{airport.iata}</b>
          {isRegional && <strong className={`airport-class airport-class-${airport.apClass.toLowerCase().replace('-', '')}`}>{airport.apClass}</strong>}
        </div>
        <h2>{airport.cidade}<span> · {airport.uf}</span></h2>
        <p>{airport.aeroporto}</p>
        <div className="airport-location"><MapPin size={14} /> {airport.regiao} <span>·</span> {airport.perfil}</div>
        {isRegional && <CollaboratorSection airportIata={airport.iata} />}
        {isRegional && <div className="investment">INVESTIMENTO ESTIMADO <strong>{(airport.investimento_estimado_brl / 1_000_000).toLocaleString('pt-BR', { maximumFractionDigits: 1 })} mi</strong></div>}
      </div>

      <WeatherCard weather={weather} />
      {isRegional && <FlightSchedule airportIcao={icao} />}

      <section className="data-section">
        <div className="section-title"><span>INFORMAÇÕES AISWEB</span><a href="https://aisweb.decea.mil.br/" target="_blank" rel="noreferrer" aria-label="Abrir AISWEB"><ArrowUpRight size={14} /></a></div>
        {isRegional ? (
          <>
            <DataLine label="Pista" value={`${aisweb.pista.designadores} · ${aisweb.pista.comprimento_m.toLocaleString('pt-BR')} × ${aisweb.pista.largura_m} m`} icon={Gauge} />
            <DataLine label="Pavimento / PCN" value={`${aisweb.pista.tipo_piso}${aisweb.pista.pcn ? ` · ${aisweb.pista.pcn}` : ''}`} icon={Activity} />
            <DataLine label="Elevação" value={`${aisweb.elevacao_m} m (${aisweb.elevacao_ft} ft)`} icon={MapPin} />
            <DataLine label="Operação" value={`${aisweb.operacao.regras} · ${aisweb.operacao.periodo}`} icon={CloudSun} />
            <DataLine label="Comunicação" value={`${aisweb.comunicacao.designador} · ${aisweb.comunicacao.frequencia_mhz} MHz`} icon={Radio} />
            <div className="aisweb-code">ICAO AISWEB <strong>{aisweb.icao_aisweb}</strong><span>CIAD {aisweb.ciad}</span></div>
          </>
        ) : (
          <p className="gru-note">O terminal GRU é exibido como referência da concessão. A base local AISWEB contém as fichas dos 12 aeroportos regionais.</p>
        )}
      </section>

    </aside>
  );
}