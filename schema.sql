-- Hapus tabel jika sudah ada sebelumnya
DROP TABLE IF EXISTS returns CASCADE;
DROP TABLE IF EXISTS borrowing_details CASCADE;
DROP TABLE IF EXISTS borrowings CASCADE;
DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. Table Users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(20) DEFAULT 'warga',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Table User Profiles (Relasi 1:1 dengan Users)
CREATE TABLE user_profiles (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    full_name VARCHAR(100) NOT NULL,
    nik VARCHAR(16) NOT NULL UNIQUE,
    phone_number VARCHAR(15),
    address TEXT
);

-- 3. Table Categories
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- 4. Table Items (Inventaris Desa)
CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    category_id INT REFERENCES categories(id) ON DELETE SET NULL,
    item_name VARCHAR(100) NOT NULL,
    total_quantity INT NOT NULL DEFAULT 1,
    available_quantity INT NOT NULL DEFAULT 1,
    condition VARCHAR(50) DEFAULT 'Baik'
);

-- 5. Table Borrowings (Peminjaman)
CREATE TABLE borrowings (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    borrow_date DATE NOT NULL,
    return_date DATE NOT NULL,
    status VARCHAR(30) DEFAULT 'menunggu',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Table Borrowing Details (Relasi M:N Borrowings & Items)
CREATE TABLE borrowing_details (
    id SERIAL PRIMARY KEY,
    borrowing_id INT REFERENCES borrowings(id) ON DELETE CASCADE,
    item_id INT REFERENCES items(id) ON DELETE CASCADE,
    quantity INT NOT NULL DEFAULT 1
);

-- 7. Table Returns (Pengembalian)
CREATE TABLE returns (
    id SERIAL PRIMARY KEY,
    borrowing_id INT UNIQUE REFERENCES borrowings(id) ON DELETE CASCADE,
    processed_by INT REFERENCES users(id),
    actual_return_date DATE NOT NULL,
    penalty_amount NUMERIC(10, 2) DEFAULT 0.00,
    notes TEXT
);

-- Data Awal
INSERT INTO categories (category_name, description) VALUES 
('Peralatan Acara', 'Tenda, kursi, meja, dan panggung'),
('Elektronik & Sound', 'Microphone, speaker, dan proyektor');

INSERT INTO items (category_id, item_name, total_quantity, available_quantity, condition) VALUES 
(1, 'Tenda Hajatan 4x6m', 10, 10, 'Baik'),
(1, 'Kursi Plastik Futura', 100, 100, 'Baik'),
(2, 'Sound System Portable 500W', 2, 2, 'Baik');

INSERT INTO users (username, email, role) VALUES 
('budi_desa', 'budi@gmail.com', 'warga'),
('pak_rt', 'rt01@desa.go.id', 'pengelola');

INSERT INTO user_profiles (user_id, full_name, nik, phone_number, address) VALUES 
(1, 'Budi Santoso', '3201123456780001', '081234567890', 'RT 01 RW 02 Desa A'),
(2, 'Pak RT Rahmat', '3201123456780002', '089876543210', 'RT 01 RW 01 Desa A');