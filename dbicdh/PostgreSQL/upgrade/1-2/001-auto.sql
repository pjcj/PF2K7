-- Convert schema '/home/spechtan/workspace/PF2K7/script/../dbicdh/_source/deploy/1/001-auto.yml' to '/home/spechtan/workspace/PF2K7/script/../dbicdh/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE users ADD COLUMN enneagram3 integer DEFAULT 0 NOT NULL;

;

COMMIT;

