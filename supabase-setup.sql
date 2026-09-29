-- YK Monster Collection: Supabase setup
-- 1) Create your admin user in Supabase Authentication > Users.
-- 2) Replace YOUR_ADMIN_EMAIL below with the exact email used for that account.
-- 3) Run this entire script in Supabase SQL Editor.
-- 4) NEVER put a secret/service_role key in config.js.

create table if not exists public.monsters (
  id bigint primary key,
  name text not null,
  family text not null default 'Other',
  kerala boolean not null default false,
  order_to_kerala boolean not null default false,
  price numeric,
  source text,
  photo text,
  collected boolean not null default false,
  notes text,
  size text default '',
  country text default '',
  design text default '',
  barcode text default '',
  sku text default '',
  package_type text default 'Can',
  release_year text default '',
  promotional boolean not null default false,
  special_packaging text default '',
  variant_key text default ''
);

alter table public.monsters enable row level security;

grant select on public.monsters to anon, authenticated;
grant insert, update, delete on public.monsters to authenticated;
revoke insert, update, delete on public.monsters from anon;

drop policy if exists "public read monsters" on public.monsters;
drop policy if exists "authenticated write monsters" on public.monsters;
drop policy if exists "admin insert monsters" on public.monsters;
drop policy if exists "admin update monsters" on public.monsters;
drop policy if exists "admin delete monsters" on public.monsters;

create policy "public read monsters"
on public.monsters
for select
to anon, authenticated
using (true);

create policy "admin insert monsters"
on public.monsters
for insert
to authenticated
with check ((select auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL');

create policy "admin update monsters"
on public.monsters
for update
to authenticated
using ((select auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL')
with check ((select auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL');

create policy "admin delete monsters"
on public.monsters
for delete
to authenticated
using ((select auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL');
