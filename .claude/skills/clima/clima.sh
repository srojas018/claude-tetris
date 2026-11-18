#!/usr/bin/env bash
# Obtiene el clima actual y el pronóstico de 3 días desde wttr.in (sin API key).
# Uso: clima.sh [ciudad]   — sin argumento usa Sabaneta, Antioquia (Colombia).
set -euo pipefail

LUGAR="${1:-Sabaneta, Antioquia, Colombia}"
# Codifica espacios para la URL (ej. "Ciudad de Mexico" -> "Ciudad+de+Mexico")
LUGAR_URL="${LUGAR//,/}"; LUGAR_URL="${LUGAR_URL// /+}"

JSON="$(curl -fsS -m 15 "https://wttr.in/${LUGAR_URL}?format=j1&lang=es")" || {
  echo "Error: no se pudo contactar wttr.in" >&2
  exit 1
}

CLIMA_JSON="$JSON" python3 -I - <<'PY'
import json, os
d = json.loads(os.environ['CLIMA_JSON'])
c = d["current_condition"][0]
a = d.get("nearest_area", [{}])[0]
def v(o, k): return (o.get(k) or [{"value": ""}])[0]["value"]
desc = v(c, "lang_es") or v(c, "weatherDesc")
lugar = ", ".join(x for x in (v(a, "areaName"), v(a, "region"), v(a, "country")) if x)
print(f"Ubicación:    {lugar}")
print(f"Condición:    {desc}")
print(f"Temperatura:  {c['temp_C']} °C (sensación {c['FeelsLikeC']} °C)")
print(f"Humedad:      {c['humidity']} %")
print(f"Viento:       {c['windspeedKmph']} km/h {c['winddir16Point']}")
print(f"Precipitación: {c['precipMM']} mm")
print(f"Índice UV:    {c['uvIndex']}")
print(f"Observado:    {c.get('localObsDateTime') or (c.get('observation_time', '') + ' UTC')}")
print()
print("Pronóstico:")
for dia in d.get("weather", []):
    lluvia = max(int(h.get("chanceofrain", 0)) for h in dia.get("hourly", [])) if dia.get("hourly") else 0
    print(f"  {dia['date']}: mín {dia['mintempC']} °C / máx {dia['maxtempC']} °C, prob. lluvia máx {lluvia} %")
PY
