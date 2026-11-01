import { useEffect, useMemo, useState } from 'react';
import { MapContainer, Marker, Popup, TileLayer, useMap } from 'react-leaflet';
import L from 'leaflet';
import { LocateFixed, Map as MapIcon, MapPinned, Satellite } from 'lucide-react';
import { describeWeatherCode } from '../lib/weather.js';

const markerIcons = new Map();

function getAirportIcon(code, apClass, selected) {
  const markerClass = apClass ? `marker-${apClass.toLowerCase().replace('-', '')}` : 'marker-gru';
  const selectedClass = selected ? ' marker-selected' : '';
  const key = `${markerClass}:${selectedClass}:${code}`;
  if (!markerIcons.has(key)) {
    markerIcons.set(key, L.divIcon({
      className: 'airport-marker-wrap',
      html: `<span class="airport-marker ${markerClass}${selectedClass}">${code}</span>`,
      iconSize: [46, 26],
      iconAnchor: [23, 13],
    }));
  }
  return markerIcons.get(key);
}

function MapFocus({ airport, bounds }) {
  const map = useMap();
  useEffect(() => {
    const focusSelected = () => {
      if (airport) map.flyTo([airport.latitude, airport.longitude], 6, { duration: 0.7 });
      else map.fitBounds(bounds, { padding: [50, 50] });
    };
    document.addEventListener('map-focus-selected', focusSelected);
    return () => document.removeEventListener('map-focus-selected', focusSelected);
  }, [airport, bounds, map]);
  useEffect(() => {
    const focusAirport = (event) => {
      const { latitude, longitude } = event.detail ?? {};
      if (Number.isFinite(latitude) && Number.isFinite(longitude)) {
        map.setView([latitude, longitude], 13, { animate: false });
      }
    };
    document.addEventListener('map-focus-airport', focusAirport);
    return () => document.removeEventListener('map-focus-airport', focusAirport);
  }, [map]);
  return null;
}

function MapLegend() {
  return (
    <div className="map-legend">
      <span><i className="legend-dot" /> Regionais</span>
      <span><i className="legend-dot legend-gru" /> GRU Airport</span>
    </div>
  );
}

function PopupContent({ airport, weather, isRegional, satellite, onToggleSatellite }) {
  return (
    <div className="popup-content">
      <span className="popup-code">{airport.aisweb?.icao_aisweb ?? airport.icao} <b>·</b> {airport.iata}</span>
      <strong>{airport.cidade}</strong>
      <span>{airport.aeroporto}</span>
      {isRegional && <small>Pista {airport.aisweb.pista.designadores} · {airport.aisweb.pista.comprimento_m.toLocaleString('pt-BR')} m</small>}
      {weather.data && <small className="popup-weather">{Math.round(weather.data.temperature_2m)}° · {describeWeatherCode(weather.data.weather_code)}</small>}
      {weather.loading && <small>Consultando clima...</small>}
      {weather.error && <small>Clima indisponível</small>}
      <button
        className="popup-layer-button"
        type="button"
        onClick={(event) => {
          event.stopPropagation();
          onToggleSatellite(airport);
        }}
      >
        {satellite ? <MapIcon size={14} /> : <Satellite size={14} />}
        {satellite ? 'Voltar ao mapa de ruas' : 'Ver imagem de satélite'}
      </button>
    </div>
  );
}

export function RegionalMap({ airports, selectedId, weather, onSelect }) {
  const [satellite, setSatellite] = useState(false);
  const selected = airports.find((airport) => airport.id === selectedId);
  const airportBounds = useMemo(
    () => L.latLngBounds(airports.map((airport) => [airport.latitude, airport.longitude])),
    [airports],
  );

  function toggleSatellite(airport) {
    setSatellite((current) => !current);
    onSelect(airport.aisweb ? airport.id : 'gru');
    document.dispatchEvent(new CustomEvent('map-focus-airport', {
      detail: { latitude: airport.latitude, longitude: airport.longitude },
    }));
  }

  return (
    <section className="map-panel" aria-label="Mapa dos aeroportos">
      <div className="map-heading">
        <div><MapPinned size={17} /><span>COBERTURA NACIONAL</span></div>
        <button type="button" title="Centralizar aeroporto selecionado" aria-label="Centralizar aeroporto selecionado" onClick={() => document.dispatchEvent(new CustomEvent('map-focus-selected'))}><LocateFixed size={16} /></button>
      </div>
      <MapContainer bounds={airportBounds} boundsOptions={{ padding: [50, 50] }} scrollWheelZoom className="regional-map">
        {satellite ? (
          <TileLayer
            key="satellite"
            attribution="Source: Esri, Vantor, Earthstar Geographics, and the GIS User Community"
            url="https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
          />
        ) : (
          <TileLayer
            key="streets"
            attribution="Tiles &copy; Esri, HERE, Garmin, FAO, NOAA, USGS, OpenStreetMap contributors, and the GIS User Community"
            url="https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}"
          />
        )}
        <MapFocus airport={selected} bounds={airportBounds} />
        {airports.map((airport) => {
          const isRegional = Boolean(airport.aisweb);
          const icao = airport.aisweb?.icao_aisweb ?? airport.icao;
          return (
            <Marker
              key={airport.id}
              position={[airport.latitude, airport.longitude]}
              icon={getAirportIcon(icao, isRegional ? airport.apClass : null, airport.id === selectedId)}
              title={`${icao} · ${airport.apClass ?? ''} · ${airport.aeroporto} (${airport.iata})`}
              bubblingMouseEvents={false}
              eventHandlers={{
                click: (event) => {
                  onSelect(isRegional ? airport.id : 'gru');
                },
              }}
            >
              <Popup><PopupContent airport={airport} weather={weather} isRegional={isRegional} satellite={satellite} onToggleSatellite={toggleSatellite} /></Popup>
            </Marker>
          );
        })}
      </MapContainer>
      {selected && <div className="map-caption"><span><i /> {selected.cidade}, {selected.uf}</span><span>{selected.aisweb?.icao_aisweb ?? selected.icao} · {selected.iata}</span></div>}
      <MapLegend />
    </section>
  );
}