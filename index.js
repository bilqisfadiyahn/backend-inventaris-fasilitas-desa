const express = require('express');
const cors = require('cors');
require('dotenv').config();
const pool = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

// 1. GET ALL ITEMS
app.get('/api/items', async (req, res) => {
    try {
        const result = await pool.query('SELECT i.*, c.category_name FROM items i LEFT JOIN categories c ON i.category_id = c.id ORDER BY i.id ASC');
        res.status(200).json({ success: true, data: result.rows });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// 2. GET ITEM BY ID
app.get('/api/items/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM items WHERE id = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: 'Barang tidak ditemukan' });
        }
        res.status(200).json({ success: true, data: result.rows[0] });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// 3. POST CREATE ITEM
app.post('/api/items', async (req, res) => {
    try {
        const { category_id, item_name, total_quantity, available_quantity, condition } = req.body;
        const result = await pool.query(
            'INSERT INTO items (category_id, item_name, total_quantity, available_quantity, condition) VALUES ($1, $2, $3, $4, $5) RETURNING *',
            [category_id, item_name, total_quantity, available_quantity, condition || 'Baik']
        );
        res.status(201).json({ success: true, message: 'Barang berhasil ditambahkan', data: result.rows[0] });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// 4. PUT UPDATE ITEM
app.put('/api/items/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { category_id, item_name, total_quantity, available_quantity, condition } = req.body;
        const result = await pool.query(
            'UPDATE items SET category_id = $1, item_name = $2, total_quantity = $3, available_quantity = $4, condition = $5 WHERE id = $6 RETURNING *',
            [category_id, item_name, total_quantity, available_quantity, condition, id]
        );
        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: 'Barang tidak ditemukan' });
        }
        res.status(200).json({ success: true, message: 'Barang berhasil diperbarui', data: result.rows[0] });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

// 5. DELETE ITEM
app.delete('/api/items/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('DELETE FROM items WHERE id = $1 RETURNING *', [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ success: false, message: 'Barang tidak ditemukan' });
        }
        res.status(200).json({ success: true, message: 'Barang berhasil dihapus' });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});