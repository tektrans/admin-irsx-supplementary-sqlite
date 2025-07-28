#!make
include .env
export

SQLITE_FILE ?= output/irsx-geography.sqlite

optimizer: ${SQLITE_FILE}
	sqlite3 ${SQLITE_FILE} "CREATE INDEX idx_cities_parent ON cities(province_id, city_id)" && \
	sqlite3 ${SQLITE_FILE} "CREATE INDEX idx_districts_parent ON districts(province_id, city_id, district_id)" && \
	sqlite3 ${SQLITE_FILE} "CREATE INDEX idx_cities_parent_name ON cities(province_id, city_name)" && \
	sqlite3 ${SQLITE_FILE} "CREATE INDEX idx_districts_parent_name ON districts(province_id, city_id, district_name)" && \
	sqlite3 ${SQLITE_FILE} "VACUUM"

${SQLITE_FILE}: output
	rm -fv ${SQLITE_FILE}
	mysql2sqlite \
		-f ${SQLITE_FILE} \
		--mysql-host ${MYSQL_HOST} \
		--mysql-port ${MYSQL_PORT} \
		--mysql-database ${MYSQL_DATABASE} \
		--mysql-user ${MYSQL_USER} \
		--mysql-password `cat password.txt` \
		--collation NOCASE \
		--mysql-tables provinces cities districts

output:
	mkdir output

clean:
	rm -rfv output
