export const collaborators = [
  { name: 'Adilton', role: 'Supervisor', airportIata: 'ARX' },
  { name: 'Alessandro Paiva', role: 'Supervisor', airportIata: 'BVH' },
  { name: 'Andeilton Silva', role: 'AVSEC', airportIata: 'PBQ' },
  { name: 'André Chaves', role: 'Supervisor', airportIata: 'LEC' },
  { name: 'Andrey', role: 'AVSEC', airportIata: 'PAF' },
  { name: 'Avelino Luiz', role: 'AVSEC', airportIata: 'ARX' },
  { name: 'Camilo Neto', role: 'AVSEC', airportIata: 'NSR' },
  { name: 'Diane', role: 'AVSEC', airportIata: 'SET' },
  { name: 'Edna Lima', role: 'Supervisora', airportIata: 'BRB' },
  { name: 'Fabio de Souza', role: 'AVSEC', airportIata: 'BVH' },
  { name: 'Graciliano Neto', role: 'Supervisor', airportIata: 'OAL' },
  { name: 'Henrique Carvalho', role: 'Supervisor', airportIata: 'AUX' },
  { name: 'Henrique Cruz', role: 'Supervisor', airportIata: 'PBQ' },
  { name: 'Humberto', role: 'Supervisor', airportIata: 'QGP' },
  { name: 'Ian Erasmo', role: 'Supervisor', airportIata: 'NSR' },
  { name: 'José Lins', role: 'Supervisor', airportIata: 'JAO' },
  { name: 'Josias Lemos', role: 'AVSEC', airportIata: 'LEC' },
  { name: 'Lucas Luz', role: 'AVSEC', airportIata: 'QGP' },
  { name: 'Maycon', role: 'AVSEC', airportIata: 'OAL' },
  { name: 'Paulo Vinicius', role: 'AVSEC', airportIata: 'BRB' },
  { name: 'Pedro', role: 'Supervisor', airportIata: 'PAF' },
  { name: 'Sandoval Reis', role: 'Supervisor', airportIata: 'SET' },
  { name: 'Valdonnilson', role: 'AVSEC', airportIata: 'AUX' },
];

export function collaboratorsForAirport(airportIata) {
  return collaborators.filter((collaborator) => collaborator.airportIata === airportIata);
}
