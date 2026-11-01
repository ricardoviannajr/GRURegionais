import { collaboratorsForAirport } from '../data/collaborators.js';

export function CollaboratorSection({ airportIata }) {
  const airportStaff = collaboratorsForAirport(airportIata);

  return (
    <section className="collaborator-section">
      <div className="section-title"><span>COLABORADORES</span><span>{airportStaff.length}</span></div>
      {airportStaff.length ? (
        <ul className="collaborator-list">
          {airportStaff.map((collaborator) => (
            <li className="collaborator-row" key={collaborator.name}>
              <strong>{collaborator.name}</strong>
              <span>{collaborator.role}</span>
            </li>
          ))}
        </ul>
      ) : (
        <p className="collaborator-empty">Nenhum colaborador identificado para este aeroporto.</p>
      )}
    </section>
  );
}