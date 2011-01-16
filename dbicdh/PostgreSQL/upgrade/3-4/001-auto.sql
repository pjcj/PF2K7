-- Convert schema '/home/spechtan/workspace/PF2K7/script/../dbicdh/_source/deploy/3/001-auto.yml' to '/home/spechtan/workspace/PF2K7/script/../dbicdh/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE roles ALTER COLUMN role TYPE character varying(32);
ALTER TABLE roles ALTER COLUMN role SET DEFAULT NULL;
ALTER TABLE users ALTER COLUMN email TYPE character varying(64);

;
ALTER TABLE users ALTER COLUMN name TYPE character varying(64);

;
ALTER TABLE users ALTER COLUMN town TYPE character varying(64);

;
ALTER TABLE users ALTER COLUMN country TYPE character varying(64);

;
ALTER TABLE users ALTER COLUMN motto1 TYPE character varying(256);

;
ALTER TABLE users ALTER COLUMN motto2 TYPE character varying(256);

;
ALTER TABLE users ALTER COLUMN username TYPE character varying(64);

;
ALTER TABLE users ALTER COLUMN password TYPE character varying(64);

;
ALTER TABLE users ALTER COLUMN likes TYPE character varying(256);

;
ALTER TABLE users ALTER COLUMN dislikes TYPE character varying(256);

;
ALTER TABLE users ALTER COLUMN gps TYPE character varying(16);

;

COMMIT;

