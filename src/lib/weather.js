const weatherDescriptions = {
  0: 'Céu limpo',
  1: 'Predominantemente limpo',
  2: 'Parcialmente nublado',
  3: 'Nublado',
  45: 'Neblina',
  48: 'Neblina com geada',
  51: 'Garoa leve',
  53: 'Garoa moderada',
  55: 'Garoa intensa',
  61: 'Chuva leve',
  63: 'Chuva moderada',
  65: 'Chuva intensa',
  71: 'Neve leve',
  73: 'Neve moderada',
  75: 'Neve intensa',
  80: 'Pancadas leves',
  81: 'Pancadas moderadas',
  82: 'Pancadas fortes',
  95: 'Trovoada',
  96: 'Trovoada com granizo leve',
  99: 'Trovoada com granizo forte',
};

export function describeWeatherCode(code) {
  return weatherDescriptions[code] ?? 'Condição não informada';
}

export async function fetchWeather(airport, signal) {
  const url = new URL('https://api.open-meteo.com/v1/forecast');
  url.search = new URLSearchParams({
    latitude: airport.latitude,
    longitude: airport.longitude,
    current: 'temperature_2m,relative_humidity_2m,precipitation,weather_code,wind_speed_10m,wind_direction_10m',
    timezone: 'America/Sao_Paulo',
  });
  const response = await fetch(url, { signal });
  if (!response.ok) throw new Error('Não foi possível consultar o clima agora.');
  const data = await response.json();
  return data.current;
}