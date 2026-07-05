FROM n8nio/n8n:2.28.6

ENV NODE_ENV=production \
    N8N_PORT=5678 \
    N8N_PROTOCOL=https \
    N8N_METRICS=false \
    N8N_DIAGNOSTICS_ENABLED=false \
    N8N_RUNNERS_ENABLED=true \
    GENERIC_TIMEZONE=America/Tegucigalpa \
    TZ=America/Tegucigalpa

EXPOSE 5678

CMD ["n8n", "start"]
