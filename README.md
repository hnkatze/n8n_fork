# n8n Fork — Deploy en Railway

Deploy de n8n self-hosted en Railway para el stack de automatizaciones SaaS.

## Stack

- **n8n** (imagen oficial `n8nio/n8n:latest`)
- **Postgres** managed por Railway (plugin built-in)
- **HTTPS** automático con dominio de Railway
- **Encryption key** persistente para credenciales

## Deploy paso a paso

### 1. Crear proyecto en Railway

1. Entrá a [railway.app](https://railway.app) → **New Project**
2. **Deploy from GitHub repo** → seleccioná `hnkatze/n8n_fork`
3. Railway detecta el `Dockerfile` y arranca el build

### 2. Agregar Postgres

1. En el proyecto → **New → Database → Add PostgreSQL**
2. Se crea automáticamente con variables `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`

### 3. Configurar variables de entorno del servicio n8n

Copiar desde `.env.example`. En Railway → service n8n → **Variables**:

| Variable | Valor |
|----------|-------|
| `N8N_ENCRYPTION_KEY` | Generar con `openssl rand -hex 32` — **NO lo pierdas** |
| `N8N_HOST` | `${{RAILWAY_PUBLIC_DOMAIN}}` |
| `WEBHOOK_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}/` |
| `N8N_PROTOCOL` | `https` |
| `N8N_PORT` | `5678` |
| `N8N_LISTEN_ADDRESS` | `0.0.0.0` |
| `DB_TYPE` | `postgresdb` |
| `DB_POSTGRESDB_HOST` | `${{Postgres.PGHOST}}` |
| `DB_POSTGRESDB_PORT` | `${{Postgres.PGPORT}}` |
| `DB_POSTGRESDB_DATABASE` | `${{Postgres.PGDATABASE}}` |
| `DB_POSTGRESDB_USER` | `${{Postgres.PGUSER}}` |
| `DB_POSTGRESDB_PASSWORD` | `${{Postgres.PGPASSWORD}}` |
| `GENERIC_TIMEZONE` | `America/Tegucigalpa` |
| `TZ` | `America/Tegucigalpa` |
| `N8N_SECURE_COOKIE` | `true` |
| `N8N_RUNNERS_ENABLED` | `true` |

Railway auto-interpola las variables `${{Postgres.VAR}}` del plugin de Postgres. No tenés que copiar los valores a mano.

### 4. Generar un dominio público

Service n8n → **Settings → Networking → Generate Domain**

Railway te da algo tipo `n8n-production-abc.up.railway.app`. Ese valor reemplaza donde dice `your-app.up.railway.app` en las variables anteriores (o usá la referencia `${{RAILWAY_PUBLIC_DOMAIN}}`).

### 5. Redeploy

Después de setear variables, Railway redeploya solo. Vas a ver logs en tiempo real.

### 6. Primer login

Abrí la URL pública → crear cuenta owner. Listo, tu n8n está en producción con HTTPS.

## Recordatorio crítico

**`N8N_ENCRYPTION_KEY`** cifra todas las credenciales guardadas en n8n (OpenAI, Telegram, etc). Si la perdés, perdés acceso a todas esas credenciales y tenés que re-ingresarlas. **Guardala en tu password manager.**

## Costos esperados

| Uso | Costo/mes |
|-----|-----------|
| Hobby plan (incluye $5 credits) | Gratis hasta agotar credits |
| Pro plan | $20 + consumo real |
| n8n + Postgres pequeño | ~$5-15/mo real |

## Arquitectura futura (cuando crezcas)

```
Railway (compute)          Supabase (data multi-tenant)
┌─────────────┐            ┌──────────────────────┐
│   n8n       │            │  Postgres + RLS      │
│   workflows │───────────▶│  tablas compartidas  │
│             │            │  con tenant_id       │
└─────────────┘            └──────────────────────┘
```

En este repo solo vive la infra de n8n. La data de negocio (appointments, cases, intakes) migrará a Supabase cuando superes 10-20 clientes.

## Desarrollo local

Para desarrollo local usá el `docker-compose.yml` del proyecto `empren`. Este repo es solo para el deploy en Railway.

## Licencia

MIT — este repo solo configura n8n, n8n mismo tiene su propia licencia (Sustainable Use License).
