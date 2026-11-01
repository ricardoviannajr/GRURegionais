export function parseCoordinate(value) {
  const match = value.match(/(\d+)°\s*(\d+)'\s*(\d+(?:\.\d+)?)"?\s*([NSEW])/i);
  if (!match) throw new Error(`Coordenada inválida: ${value}`);

  const [, degrees, minutes, seconds, hemisphere] = match;
  const magnitude = Number(degrees) + Number(minutes) / 60 + Number(seconds) / 3600;
  return /[SW]/i.test(hemisphere) ? -magnitude : magnitude;
}