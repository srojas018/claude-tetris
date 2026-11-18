---
name: clima
description: Consulta el clima actual y el pronóstico de 3 días de Sabaneta, Antioquia (ubicación por defecto) o de una ciudad indicada. Úsala cuando el usuario pregunte por el clima, el tiempo, la temperatura, si va a llover, o invoque /clima.
argument-hint: "[ciudad opcional]"
allowed-tools: Bash(bash .claude/skills/clima/clima.sh:*)
---

# Clima local

Obtiene el clima usando el servicio público wttr.in (no requiere API key).

## Pasos

1. Ejecuta el script del proyecto:
   - Por defecto (Sabaneta, Antioquia): `bash .claude/skills/clima/clima.sh`
   - Ciudad concreta (si el usuario la indicó, p. ej. `$ARGUMENTS`): `bash .claude/skills/clima/clima.sh "Bogota"`
2. Responde en español con un resumen breve: ubicación, condición, temperatura y sensación térmica, humedad, viento y el pronóstico de los próximos días. Destaca si hay probabilidad alta de lluvia (≥ 50 %) o índice UV alto (≥ 8).
3. Para Sabaneta, wttr.in puede mostrar "Itagui" como ubicación (estación vecina); preséntalo como el clima de Sabaneta.

## Notas

- Si el script falla (sin red o wttr.in caído), informa el error; no inventes datos.
- Sin argumento siempre se consulta Sabaneta, Antioquia; no se usa la IP.
