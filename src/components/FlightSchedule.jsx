import { ArrowRight } from 'lucide-react';
import { flightsForAirport } from '../data/flights.js';

export function FlightSchedule({ airportIcao }) {
  const airportFlights = flightsForAirport(airportIcao);

  return (
    <section className="flight-section">
      <div className="section-title"><span>VOOS INFORMADOS</span><small>SEM DATA</small></div>
      <ul className="flight-list">
        {airportFlights.map((flight, index) => (
          <li className="flight-row" key={`${flight.number}-${flight.departure}-${index}`}>
            <div className="flight-route">
              <span>{flight.origin[0]} <small>{flight.origin[1]}</small></span>
              <ArrowRight size={13} />
              <span>{flight.destination[0]} <small>{flight.destination[1]}</small></span>
            </div>
            <div className="flight-info">
              <span><strong>{flight.number}</strong> · {flight.airline}</span>
              <time>{flight.departure}–{flight.arrival}</time>
            </div>
            <small className="flight-aircraft">{flight.aircraft}</small>
          </li>
        ))}
      </ul>
    </section>
  );
}