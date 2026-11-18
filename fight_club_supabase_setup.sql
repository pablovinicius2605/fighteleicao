-- CONFIGURAÇÃO SUPABASE — Fight Pesquisa
-- 1) Crie um projeto no Supabase.
-- 2) No painel, habilite Authentication > Providers > Anonymous Sign-Ins.
-- 3) Cole este SQL no SQL Editor e execute.
-- 4) No HTML, substitua SUPABASE_URL e SUPABASE_ANON_KEY pelos dados de Project Settings > API.
-- A tabela guarda uma resposta por usuário anônimo autenticado.
-- O placar público expõe apenas totais agregados, nunca as respostas individuais.

create table if not exists public.fc_poll_receipts (
  id bigint generated always as identity primary key,
  user_id uuid not null unique references auth.users(id) on delete cascade,
  choice text not null check (choice in ('25','83','nulo')),
  created_at timestamptz not null default now()
);

alter table public.fc_poll_receipts enable row level security;

drop policy if exists "insert own poll response" on public.fc_poll_receipts;
create policy "insert own poll response"
on public.fc_poll_receipts for insert to authenticated
with check (auth.uid() = user_id);

-- O frontend não envia user_id: preenchemos com a identidade autenticada.
create or replace function public.fc_set_poll_user_id()
returns trigger language plpgsql security invoker as $$
begin
  new.user_id := auth.uid();
  return new;
end;
$$;

drop trigger if exists fc_poll_set_user_id on public.fc_poll_receipts;
create trigger fc_poll_set_user_id
before insert on public.fc_poll_receipts
for each row execute function public.fc_set_poll_user_id();

-- Nenhuma leitura direta da tabela é concedida ao público.
revoke all on public.fc_poll_receipts from anon, authenticated;
grant insert (choice) on public.fc_poll_receipts to authenticated;

create or replace function public.fc_poll_totals()
returns json
language sql
security definer
set search_path = ''
as $$
  select json_build_object(
    '25', count(*) filter (where choice = '25'),
    '83', count(*) filter (where choice = '83'),
    'nulo', count(*) filter (where choice = 'nulo')
  )
  from public.fc_poll_receipts;
$$;

revoke all on function public.fc_poll_totals() from public;
grant execute on function public.fc_poll_totals() to anon, authenticated;


create or replace function public.fc_has_voted()
returns boolean
language sql
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.fc_poll_receipts
    where user_id = auth.uid()
  );
$$;

revoke all on function public.fc_has_voted() from public;
grant execute on function public.fc_has_voted() to authenticated;
