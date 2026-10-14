-- Demo data cho TTP local testing
-- Chạy sau migration 20261014_ai_crop_analysis.sql

INSERT INTO tenant (id, name)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'TTP Global')
ON CONFLICT (id) DO NOTHING;

INSERT INTO organization (id, tenant_id, name)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'TTP Agriculture')
ON CONFLICT (id) DO NOTHING;

INSERT INTO farmer (id, tenant_id, organization_id, name, phone, email, address)
VALUES
  ('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Nguyễn Văn A', '0900000001', 'a@example.com', '{"province":"Long An","district":"Cần Đước","village":"Vĩnh Hòa"}'::jsonb)
ON CONFLICT (id) DO NOTHING;

INSERT INTO farm (id, tenant_id, farmer_id, name, total_area_ha)
VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Farm A', 5.2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO field (id, tenant_id, farm_id, farmer_id, name, area_ha, geom, centroid)
VALUES
  (
    '33333333-3333-3333-3333-333333333333',
    '11111111-1111-1111-1111-111111111111',
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '22222222-2222-2222-2222-222222222222',
    'Vườn SR 01',
    2.5,
    ST_GeomFromText('POLYGON((106.6500 10.7700, 106.6700 10.7700, 106.6700 10.7900, 106.6500 10.7900, 106.6500 10.7700))', 4326),
    ST_GeomFromText('POINT(106.6600 10.7800)', 4326)
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO season (id, tenant_id, field_id, farmer_id, crop, variety, planted_at, expected_harvest_at, status)
VALUES
  (
    '44444444-4444-4444-4444-444444444444',
    '11111111-1111-1111-1111-111111111111',
    '33333333-3333-3333-3333-333333333333',
    '22222222-2222-2222-2222-222222222222',
    'sầu riêng',
    'DV1',
    '2026-05-15',
    '2026-12-20',
    'active'
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO product (id, tenant_id, sku, name, manufacturer, pack_size, unit)
VALUES
  ('55555555-5555-5555-5555-555555555555', '11111111-1111-1111-1111-111111111111', 'FUL-GROW-2X', 'Ful-Grow 2X', 'TTP', '2 bao', 'bao'),
  ('66666666-6666-6666-6666-666666666666', '11111111-1111-1111-1111-111111111111', 'ABC-PEST-01', 'ABC Pesticide', 'Local', '1 lít', 'lít')
ON CONFLICT (id) DO NOTHING;

INSERT INTO activity (id, tenant_id, season_id, field_id, farmer_id, activity_type, product_id, product_name, quantity, unit, cost, occurred_at, meta)
VALUES
  (
    '77777777-7777-7777-7777-777777777777',
    '11111111-1111-1111-1111-111111111111',
    '44444444-4444-4444-4444-444444444444',
    '33333333-3333-3333-3333-333333333333',
    '22222222-2222-2222-2222-222222222222',
    'fertilizer',
    '55555555-5555-5555-5555-555555555555',
    'Ful-Grow 2X',
    2,
    'bao',
    1800000,
    '2026-09-24T00:00:00Z',
    '{"note":"Bón lần 2"}'::jsonb
  ),
  (
    '88888888-8888-8888-8888-888888888888',
    '11111111-1111-1111-1111-111111111111',
    '44444444-4444-4444-4444-444444444444',
    '33333333-3333-3333-3333-333333333333',
    '22222222-2222-2222-2222-222222222222',
    'pesticide',
    '66666666-6666-6666-6666-666666666666',
    'ABC Pesticide',
    1,
    'lít',
    1200000,
    '2026-09-28T00:00:00Z',
    '{"note":"Phun kháng nấm"}'::jsonb
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO observation (id, tenant_id, season_id, field_id, farmer_id, reported_at, symptom, severity, note, image_url)
VALUES
  (
    '99999999-9999-9999-9999-999999999999',
    '11111111-1111-1111-1111-111111111111',
    '44444444-4444-4444-4444-444444444444',
    '33333333-3333-3333-3333-333333333333',
    '22222222-2222-2222-2222-222222222222',
    '2026-10-12T08:00:00Z',
    'vàng lá',
    'medium',
    'Lá vàng nhiều, chậm lớn',
    'https://storage.example.com/images/leaf-001.jpg'
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO disease_case (id, tenant_id, season_id, field_id, farmer_id, observation_id, diagnosis, recommendation, status, assigned_to)
VALUES
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    '11111111-1111-1111-1111-111111111111',
    '44444444-4444-4444-4444-444444444444',
    '33333333-3333-3333-3333-333333333333',
    '22222222-2222-2222-2222-222222222222',
    '99999999-9999-9999-9999-999999999999',
    'Có khả năng vàng lá do thiếu đạm',
    'Bón Ful-Grow 2X 2 bao/ha và theo dõi 7-14 ngày',
    'open',
    NULL
  )
ON CONFLICT (id) DO NOTHING;

INSERT INTO harvest (id, tenant_id, season_id, field_id, farmer_id, harvested_at, quantity, unit, revenue)
VALUES
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    '11111111-1111-1111-1111-111111111111',
    '44444444-4444-4444-4444-444444444444',
    '33333333-3333-3333-3333-333333333333',
    '22222222-2222-2222-2222-222222222222',
    '2026-12-15T00:00:00Z',
    4.5,
    'tấn',
    120000000
  )
ON CONFLICT (id) DO NOTHING;
