# Loom & Lane POS

A full-stack point-of-sale workspace for a textile retailer. It includes a staff billing counter and a role-protected admin workspace for products, team members, suppliers, sales, returns, and reports.

## Technology

- **Frontend:** React 18, Vite, Tailwind CSS, Recharts, Lucide
- **Backend:** Ruby on Rails 8 JSON API, JWT authentication
- **Database:** PostgreSQL
- **Deployment:** Render Blueprint (separate static frontend, API, and PostgreSQL services)

## Run locally

Requirements: Ruby 3.4.2, PostgreSQL, Node.js 20 or newer.

1. Create a PostgreSQL role/database matching `backend/config/database.yml`, or set `DATABASE_URL`.
2. In `backend/`, run `bundle install`, `bin/rails db:prepare`, and `bin/rails db:seed`.
3. Start the API with `cd backend && bin/rails server`.
4. In another terminal, run `cd frontend && npm ci && npm run dev`.
5. Open <http://localhost:5173>. Vite proxies `/api` requests to Rails at `localhost:3000`.

For a different local API host, set `VITE_API_PROXY` in the frontend environment. For a separately hosted frontend, set `VITE_API_BASE_URL` to the API origin and set `FRONTEND_ORIGINS` in Rails to the frontend origin.

## Demo accounts

Run `bin/rails db:seed` to create or reset these demo accounts and sample textile inventory:

| Role | Email | Password |
| --- | --- | --- |
| Admin | `admin@loomandlane.demo` | `LoomAdmin!2026` |
| Staff | `cashier@loomandlane.demo` | `Cashier!2026` |

These are public review credentials. Do not use them for a real store.

## Portals

- Staff billing and admin workspace: frontend root URL
- Mobile admin layout: append `/admin/mobile` to the frontend URL (the same pages become a narrow, mobile-style workspace)
- API health check: backend `/up`

## Main workflows

- Create bills using cash, UPI, or card; apply a discount; print a receipt; stock is decremented in the same database transaction.
- Manage products, staff accounts, and supplier records as an admin.
- Process a return against the original bill. The API caps return quantity at the amount sold, calculates the refund using the original sale price, and restores stock transactionally.
- Review the sales/refunds cashbook ledger, revenue, discount, payment-method, and low-stock reports.
- Use the Help Centre for searchable, role-aware guides. Answers are matched from verified POS workflows and unknown questions receive a safe fallback; no LLM or external AI API is required.

## Deploy on Render

The root `render.yaml` defines two web services and one PostgreSQL database. Connect the repository to Render as a Blueprint and deploy the resources. The frontend is a separate static site; its rewrite rule supports direct navigation to `/admin/mobile`. The Rails API uses the configured `DATABASE_URL` and seeds demo records during build.

If Render assigns a different public hostname to either web service, update `VITE_API_BASE_URL` on the static site and `FRONTEND_ORIGINS` on the API service, then redeploy. The current Blueprint uses Render's free plans for review. Free web services sleep when idle, and a free Postgres database expires after 30 days; upgrade the database plan for a longer-lived review environment.

## Notes

- The demo uses a single store and INR pricing. Returns are limited to 30 days; change this policy for the business. Tax is currently zero; add a store-specific rate before production use.
- Billing records cash/card/UPI payment type. It does not connect to a payment processor.
- Demo accounts are created by the idempotent seed script; seeds should be reviewed before use in a real environment.
