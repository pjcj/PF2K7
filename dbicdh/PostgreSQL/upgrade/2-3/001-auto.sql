-- Convert schema '/home/spechtan/workspace/PF2K7/script/../dbicdh/_source/deploy/2/001-auto.yml' to '/home/spechtan/workspace/PF2K7/script/../dbicdh/_source/deploy/3/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE "users" DROP COLUMN "enneagram3";

;

COMMIT;

