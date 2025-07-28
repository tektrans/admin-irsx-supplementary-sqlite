# irsx-geography-to-sqlite3
Salin tabel provinces, cities, dan districts database IRSX ke dalam format sqlite3.

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
