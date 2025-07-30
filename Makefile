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
		--mysql-tables provinces cities districts areadomisili kelompokharga

	sqlite3 output/database.sqlite \
		"\
		ALTER TABLE areadomisili RENAME COLUMN IdAreaDomisili TO id_area_domisili; \
		ALTER TABLE areadomisili RENAME COLUMN NamaAreaDomisili TO nama_area_domisili; \
		\
		ALTER TABLE cities ADD COLUMN city_name_prefix_with_type VARCHAR(300) NULL COLLATE NOCASE; \
		UPDATE cities SET city_name_prefix_with_type = type || ' ' || city_name; \
		\
		CREATE INDEX idx_province_name ON provinces(province_name); \
		CREATE INDEX idx_cities_parent ON cities(province_id, city_id); \
		CREATE INDEX idx_cities_parent_name ON cities(province_id, city_name); \
		CREATE INDEX idx_cities_parent_name_prefix_with_type ON cities(province_id, city_name_prefix_with_type); \
		CREATE INDEX idx_districts_parent ON districts(city_id, district_id); \
		CREATE INDEX idx_districts_parent_name ON districts(city_id, district_name); \
		CREATE INDEX idx_areadomisili_name ON areadomisili(nama_area_domisili); \
		CREATE INDEX idx_kelompokharga_name ON kelompokharga(nama); \
		\
		VACUUM;\
		"
