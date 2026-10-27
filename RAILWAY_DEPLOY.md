# ResellerBot — Railway

## Deploy
1. Push this project to your private GitHub repository.
2. In Railway, create a project and deploy the GitHub repository.
3. Add a Railway **Volume** mounted at `/app/data`.
4. Add environment variables from your previous `.env` in Railway Variables. Do not set `DATABASE_URL` unless you need to override the default; the start script uses the mounted volume at `/app/data/bot.db`.
5. Deploy. The start script copies `data-seed/bot.db` to the volume only on the first run. If `/app/data/bot.db` already exists, it is never overwritten.
6. Railway runs `bash scripts/railway-start.sh` automatically through `railway.json`.

## Existing database
The original SQLite database is preserved as `data-seed/bot.db`. The first start copies it into the persistent volume. Do not delete the seed file until you have confirmed the Railway bot starts with the expected existing data.

## Environment variables
Copy the values from your existing `.env` into Railway Variables, especially:
- `BOT_TOKEN`
- `ADMIN_TELEGRAM_IDS`
- `XUI_BASE_URL`
- `XUI_API_TOKEN` (or `XUI_USERNAME` and `XUI_PASSWORD`)
- `XUI_SUB_PUBLIC_URL`
- `XUI_VERIFY_SSL`
- `XUI_DEFAULT_INBOUND_IDS`
- `XUI_AUTO_VISION_FLOW`
- `XUI_AUTO_RESELLER_GROUP`
- Other optional settings used by your project

`DATABASE_URL` defaults to `sqlite+aiosqlite:////app/data/bot.db` so SQLite uses the Railway Volume.

## Important
- This package intentionally does not include `.env` or `.git` metadata.
- The included database was checked with SQLite `PRAGMA integrity_check` and returned `ok`.
- For any future database migration, take a backup first.
