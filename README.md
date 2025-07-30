# admin-irsx-supplementary-sqlite
Salin tabel provinces, cities,districts dan beberapa tabel lain dari database mysql IRSX ke dalam format sqlite3.

- [admin-irsx-supplementary-sqlite](#admin-irsx-supplementary-sqlite)
  - [Cara pakai](#cara-pakai)
    - [Install requirements](#install-requirements)
    - [File .env](#file-env)
    - [File password.txt](#file-passwordtxt)
    - [Eksekusi](#eksekusi)
  - [Tabel-tabel](#tabel-tabel)
    - [Tabel "areadomisili"](#tabel-areadomisili)
    - [Tabel "cities"](#tabel-cities)
    - [Tabel "districts"](#tabel-districts)
    - [Tabel "kelompokharga"](#tabel-kelompokharga)
    - [Tabel "provinces"](#tabel-provinces)

## Cara pakai

### Install requirements

```shell
pip install -r requirements.txt
```

### File .env
Buat file ".env" yang berisi konfigurasi.
Contoh dapat dilihat di file "[sample.env](sample.env)".

### File password.txt
Buat file "password.txt" yang berisi password mysql.

### Eksekusi

```shell
make
```

File hasil akan dibuat di "output/database.sqlite".

## Tabel-tabel

Tabel-tabel kami modifikasi untuk memudahkan penggunaan, diantaranya adalah
perubahan nama nama kolom dan penambahan kolom baru.

Untuk detail lebih silahkan lihat penjelasan masing-masing tabel di bawah
atau lebih lengkapnya dapat dilihat di file "[Makefile](Makefile)".

### Tabel "areadomisili"

Tabel ini berisi pilihan-pilihan "Cluster" yang ada di menu pendaftaran reseller.

```sql
CREATE TABLE IF NOT EXISTS "areadomisili" (
        "id_area_domisili" INTEGER NOT NULL DEFAULT '0' ,
        "nama_area_domisili" VARCHAR(100) NULL  COLLATE NOCASE,
        "koordinat" TEXT NULL  COLLATE NOCASE,
        PRIMARY KEY ("id_area_domisili")
);
```

Ada beberapa perubahan nama kolom di tabel ini.
Dari sebelumnya kolom di mysql bernama "IdAreaDomisili", kami ubah menjadi "id_area_domisili".
Selain itu juga kami mengubah nama kolom "NamaAreaDomisili" menjadi "nama_area_domisili".

### Tabel "cities"
```sql
CREATE TABLE IF NOT EXISTS "cities" (
        "city_id" INTEGER NOT NULL  ,
        "province_id" INTEGER NOT NULL  ,
        "city_name" VARCHAR(191) NOT NULL  COLLATE NOCASE,
        "type" VARCHAR(100) NULL  COLLATE NOCASE,
        "postal_code" INTEGER NULL  ,
        "created_by" INTEGER NOT NULL  ,
        "updated_by" INTEGER NOT NULL  ,
        "deleted_by" INTEGER NULL  ,
        "deleted_at" DATETIME NULL  ,
        "created_at" DATETIME NULL  ,
        "updated_at" DATETIME NULL  , 
        "city_name_prefix_with_type" VARCHAR(300) NULL COLLATE NOCASE ,
        PRIMARY KEY ("city_id")
);
CREATE INDEX idx_cities_parent ON cities(province_id, city_id);
CREATE INDEX idx_cities_parent_name ON cities(province_id, city_name);
CREATE INDEX idx_cities_parent_name_prefix_with_type ON cities(province_id, city_name_prefix_with_type);
```

Ada penambahan kolom "city_name_prefix_with_type" untuk nama lengkap kabupaten/kota untuk membedakan
kabupaten/kota yang memiliki nama sama tetapi tipe kabupaten/kota berbeda.

### Tabel "districts"
```sql
CREATE TABLE IF NOT EXISTS "districts" (
        "district_id" INTEGER NOT NULL  ,
        "province_id" INTEGER NOT NULL  ,
        "city_id" INTEGER NOT NULL  ,
        "district_name" VARCHAR(191) NOT NULL  COLLATE NOCASE,
        "created_by" INTEGER NOT NULL  ,
        "updated_by" INTEGER NOT NULL  ,
        "deleted_by" INTEGER NULL  ,
        "deleted_at" DATETIME NULL  ,
        "created_at" DATETIME NULL  ,
        "updated_at" DATETIME NULL  ,
        PRIMARY KEY ("district_id")
);
CREATE INDEX idx_districts_parent ON districts(city_id, district_id);
CREATE INDEX idx_districts_parent_name ON districts(city_id, district_name);
```
### Tabel "kelompokharga"

Tabel ini berisi pilihan-pilihan "priceplan" yang ada di menu pendaftaran reseller.

```sql
CREATE TABLE IF NOT EXISTS "kelompokharga" (
        "idkelompokharga" INTEGER PRIMARY KEY AUTOINCREMENT,
        "nama" VARCHAR(50) NOT NULL DEFAULT '' COLLATE NOCASE,
        "keterangan" VARCHAR(200) NULL DEFAULT '' COLLATE NOCASE,
        "smspromo" INTEGER NULL DEFAULT '0' ,
        "poin" INTEGER NULL DEFAULT '0' ,
        "mlm" INTEGER NULL DEFAULT '0' ,
        "maxlevel" INTEGER NULL DEFAULT '0' ,
        "tiket" INTEGER NULL DEFAULT '1' ,
        "mintiket" DOUBLE NULL DEFAULT '300000' ,
        "maxselisih" INTEGER NULL DEFAULT '1000' ,
        "jeniskomisimlm" INTEGER NULL DEFAULT '0' ,
        "issms" INTEGER NULL DEFAULT '1' ,
        "isim" INTEGER NULL DEFAULT '1' ,
        "ishttp" INTEGER NULL DEFAULT '1' ,
        "isapp" INTEGER NULL DEFAULT '1'
);
CREATE INDEX idx_kelompokharga_name ON kelompokharga(nama);
```

### Tabel "provinces"
```sql
CREATE TABLE IF NOT EXISTS "provinces" (
        "province_id" INTEGER NOT NULL  ,
        "province_name" VARCHAR(191) NOT NULL  COLLATE NOCASE,
        "created_by" INTEGER NULL  ,
        "updated_by" INTEGER NULL  ,
        "deleted_by" INTEGER NULL  ,
        "deleted_at" DATETIME NULL  ,
        "created_at" DATETIME NULL  ,
        "updated_at" DATETIME NULL  ,
        PRIMARY KEY ("province_id")
);
CREATE UNIQUE INDEX "provinces_province_name_unique" ON "provinces" ("province_name");
CREATE INDEX idx_province_name ON provinces(province_name);
```
