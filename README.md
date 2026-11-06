# Sistem Informasi Inventaris dan Peminjaman Fasilitas Desa (Backend REST API)

Proyek backend REST API ini dirancang untuk mengelola data inventaris dan peminjaman fasilitas milik desa (seperti tenda, kursi, sound system, dan proyektor) secara terstruktur, akurat, dan transparan.

## Entitas Database (7 Tabel)

Database `desa_db` menggunakan PostgreSQL yang terdiri dari 7 tabel saling berelasi:
1. `users` - Data akun pengguna (Warga & Pengelola).
2. `user_profiles` - Data profil detail pengguna (NIK, No. HP, Alamat).
3. `categories` - Kategori inventaris barang desa.
4. `items` - Data barang inventaris desa.
5. `borrowings` - Transaksi utama peminjaman barang.
6. `borrowing_details` - Rincian item dan jumlah yang dipinjam.
7. `returns` - Catatan pengembalian barang dan denda.

## Fitur REST API (CRUD Items)

- **POST** `/api/items` - Menambahkan data barang inventaris baru.
- **GET** `/api/items` - Menampilkan seluruh daftar barang inventaris beserta kategorinya.
- **GET** `/api/items/:id` - Menampilkan detail satu barang berdasarkan ID.
- **PUT** `/api/items/:id` - Memperbarui data barang inventaris berdasarkan ID.
- **DELETE** `/api/items/:id` - Menghapus data barang inventaris dari database.

## Spesifikasi Teknologi

- **Runtime & Framework:** Node.js, Express.js
- **Database:** PostgreSQL (`pg` pool)
- **Environment & Tools:** dotenv, cors, Postman
