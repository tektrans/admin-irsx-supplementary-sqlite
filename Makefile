#!make
include .env
export

all:
	rm -rfv output
	mkdir output
	mysql2sqlite \
		-f output/database.sqlite \
		--mysql-host ${MYSQL_HOST} \
		--mysql-port ${MYSQL_PORT} \
		--mysql-database ${MYSQL_DATABASE} \
		--mysql-user ${MYSQL_USER} \
		--mysql-password `cat password.txt` \
		--collation NOCASE \
		--mysql-tables provinces cities districts areadomisili

	sqlite3 output/database.sqlite \
		"\
		ALTER TABLE areadomisili RENAME COLUMN IdAreaDomisili TO id_area_domisili; \
		ALTER TABLE areadomisili RENAME COLUMN NamaAreaDomisili TO nama_area_domisili; \
		CREATE INDEX idx_cities_parent ON cities(province_id, city_id); \
		CREATE INDEX idx_districts_parent ON districts(province_id, city_id, district_id); \
		CREATE INDEX idx_cities_parent_name ON cities(province_id, city_name); \
		CREATE INDEX idx_districts_parent_name ON districts(province_id, city_id, district_name); \
		VACUUM;\
		"
