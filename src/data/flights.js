export const flights = [
  { origin: ['Confins', 'SBCF'], destination: ['Aracati', 'SBAC'], airline: 'Azul', aircraft: 'Embraer E195-E2', number: 'AD 2580', departure: '09:15', arrival: '12:05' },
  { origin: ['Aracati', 'SBAC'], destination: ['Fortaleza', 'SBFZ'], airline: 'Azul', aircraft: 'Embraer E195-E2', number: 'AD 2580', departure: '12:40', arrival: '13:25' },
  { origin: ['Fortaleza', 'SBFZ'], destination: ['Aracati', 'SBAC'], airline: 'Azul', aircraft: 'Embraer E195-E2', number: 'AD 2580', departure: '13:35', arrival: '14:15' },
  { origin: ['Aracati', 'SBAC'], destination: ['Confins', 'SBCF'], airline: 'Azul', aircraft: 'Embraer E195-E2', number: 'AD 2580', departure: '14:30', arrival: '17:20' },
  { origin: ['Confins', 'SBCF'], destination: ['Lençóis', 'SBLE'], airline: 'Azul', aircraft: 'ATR 72-600', number: 'AD 4295', departure: '08:35', arrival: '11:00' },
  { origin: ['Lençóis', 'SBLE'], destination: ['Salvador', 'SBSV'], airline: 'Azul', aircraft: 'ATR 72-600', number: 'AD 4249', departure: '11:30', arrival: '12:30' },
  { origin: ['Salvador', 'SBSV'], destination: ['Lençóis', 'SBLE'], airline: 'Azul', aircraft: 'ATR 72-600', number: 'AD 4295', departure: '11:45', arrival: '13:00' },
  { origin: ['Lençóis', 'SBLE'], destination: ['Confins', 'SBCF'], airline: 'Azul', aircraft: 'ATR 72-600', number: 'AD 4249', departure: '13:30', arrival: '15:50' },
  { origin: ['Cuiabá', 'SBCY'], destination: ['Vilhena', 'SBVH'], airline: 'Azul', aircraft: 'Embraer E195-E2 / ATR 72-600', number: 'AD 2638', departure: '12:10', arrival: '13:20' },
  { origin: ['Vilhena', 'SBVH'], destination: ['Cuiabá', 'SBCY'], airline: 'Azul', aircraft: 'Embraer E195-E2 / ATR 72-600', number: 'AD 2639', departure: '14:05', arrival: '15:10' },
  { origin: ['Cuiabá', 'SBCY'], destination: ['Cacoal', 'SSKW'], airline: 'Azul', aircraft: 'Embraer E195-E2 / ATR 72-600', number: 'AD 2650', departure: '12:20', arrival: '13:50' },
  { origin: ['Cacoal', 'SSKW'], destination: ['Cuiabá', 'SBCY'], airline: 'Azul', aircraft: 'Embraer E195-E2 / ATR 72-600', number: 'AD 2651', departure: '14:25', arrival: '15:45' },
  { origin: ['Recife', 'SBRF'], destination: ['Serra Talhada', 'SNHS'], airline: 'Azul Conecta', aircraft: 'Cessna C208B Grand Caravan', number: 'AD 5362', departure: '09:00', arrival: '10:40' },
  { origin: ['Serra Talhada', 'SNHS'], destination: ['Araripina', 'SNAB'], airline: 'Azul Conecta', aircraft: 'Cessna C208B Grand Caravan', number: 'AD 5362', departure: '11:05', arrival: '12:10' },
  { origin: ['Araripina', 'SNAB'], destination: ['Recife', 'SBRF'], airline: 'Azul Conecta', aircraft: 'Cessna C208B Grand Caravan', number: 'AD 5362', departure: '12:40', arrival: '15:15' },
  { origin: ['Recife', 'SBRF'], destination: ['Garanhuns', 'SNGN'], airline: 'Azul Conecta', aircraft: 'Cessna C208B Grand Caravan', number: 'AD 5102', departure: '14:35', arrival: '15:35' },
  { origin: ['Garanhuns', 'SNGN'], destination: ['Recife', 'SBRF'], airline: 'Azul Conecta', aircraft: 'Cessna C208B Grand Caravan', number: 'AD 5103', departure: '16:05', arrival: '17:05' },
];

export function flightsForAirport(icao) {
  return flights.filter(({ origin, destination }) => origin[1] === icao || destination[1] === icao);
}