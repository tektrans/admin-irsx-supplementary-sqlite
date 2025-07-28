#!make
include .env
export

output/database.sqlite:
	rm -rfv output

	mysql2sqlite \
		-f output/database.sqlite \
		--mysql-host ${MYSQL_HOST} \
		--mysql-port ${MYSQL_PORT} \
		--mysql-database ${MYSQL_DATABASE} \
		--mysql-user ${MYSQL_USER} \
		--mysql-password `cat password.txt` \
		--collation NOCASE \
		--mysql-tables provinces cities districts

	sqlite3 output/database.sqlite \
		"\
		CREATE INDEX idx_cities_parent ON cities(province_id, city_id); \
		CREATE INDEX idx_districts_parent ON districts(province_id, city_id, district_id); \
		CREATE INDEX idx_cities_parent_name ON cities(province_id, city_name); \
		CREATE INDEX idx_districts_parent_name ON districts(province_id, city_id, district_name); \
		VACUUM;\
		"

clean:
	rm -rfv output
