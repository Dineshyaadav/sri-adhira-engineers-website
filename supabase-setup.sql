-- Run this SQL in Supabase Dashboard > SQL Editor after creating your project.
-- This allows public visitors to READ only published projects. Only the owner email can manage projects and files.
-- Ensure you create an Auth user with email sriadhiraengineers@gmail.com, and disable public sign-ups.

create extension if not exists pgcrypto;

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) <= 100),
  service text not null,
  status text not null default 'Ongoing' check (status in ('Ongoing','Completed')),
  location text,
  description text,
  media_url text not null,
  media_path text not null,
  media_type text not null check (media_type in ('image','video')),
  is_published boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.projects enable row level security;
grant select on public.projects to anon, authenticated;
grant insert, update, delete on public.projects to authenticated;

drop policy if exists "Published projects are public" on public.projects;
create policy "Published projects are public" on public.projects
  for select to anon using (is_published = true);

drop policy if exists "Owner can read all projects" on public.projects;
create policy "Owner can read all projects" on public.projects
  for select to authenticated using ((auth.jwt() ->> 'email') = 'sriadhiraengineers@gmail.com');

drop policy if exists "Owner can insert projects" on public.projects;
create policy "Owner can insert projects" on public.projects
  for insert to authenticated with check ((auth.jwt() ->> 'email') = 'sriadhiraengineers@gmail.com');

drop policy if exists "Owner can update projects" on public.projects;
create policy "Owner can update projects" on public.projects
  for update to authenticated using ((auth.jwt() ->> 'email') = 'sriadhiraengineers@gmail.com') with check ((auth.jwt() ->> 'email') = 'sriadhiraengineers@gmail.com');

drop policy if exists "Owner can delete projects" on public.projects;
create policy "Owner can delete projects" on public.projects
  for delete to authenticated using ((auth.jwt() ->> 'email') = 'sriadhiraengineers@gmail.com');

-- First create a PUBLIC Storage bucket named project-media in Dashboard > Storage.
-- Set allowed MIME types: image/jpeg, image/png, image/webp, image/avif, video/mp4, video/webm.
-- Recommended file limit: 40 MB. Public bucket means media URLs are publicly viewable by design.
drop policy if exists "Public can view project media" on storage.objects;
create policy "Public can view project media" on storage.objects
  for select using (bucket_id = 'project-media');

drop policy if exists "Owner can upload project media" on storage.objects;
create policy "Owner can upload project media" on storage.objects
  for insert to authenticated with check (bucket_id = 'project-media' and (auth.jwt() ->> 'email') = 'sriadhiraengineers@gmail.com');

drop policy if exists "Owner can delete project media" on storage.objects;
create policy "Owner can delete project media" on storage.objects
  for delete to authenticated using (bucket_id = 'project-media' and (auth.jwt() ->> 'email') = 'sriadhiraengineers@gmail.com');
