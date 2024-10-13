SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

ALTER TABLE play_store_apps
--DROP COLUMN currency,
--DROP COLUMN install_count,
--DROP COLUMN category
DROP COLUMN size;

ALTER TABLE app_store_apps
--DROP COLUMN currency,
DROP COLUMN size_bytes; 

SELECT *
FROM play_store_apps

--Play Store has category and install count, but not App Store