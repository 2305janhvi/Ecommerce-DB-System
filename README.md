# 🛒 Scalable E-commerce Database System (PostgreSQL)

This project demonstrates a robust database architecture for an E-commerce platform using PostgreSQL. It focuses on data integrity, automation through triggers, and advanced relational mapping.

## 🚀 Key Features
- **Relational Schema:** Optimized 3rd Normal Form (3NF) design with 5 core tables.
- **Automated Inventory Management:** Real-time stock updates using PostgreSQL **Triggers and Functions**.
- **Data Integrity:** Implementation of `CHECK` constraints, `UNIQUE` keys, and `FOREIGN KEY` relationships (Cascades).
- **Business Insights:** Complex JOIN queries to track sales performance and customer behavior.

## 📊 Database Architecture
The system consists of the following entities:
- `Users`: Customer profiles.
- `Products`: Item details with stock tracking.
- `Categories`: Product classification.
- `Orders`: Transaction records.
- `Order_Items`: Junction table for many-to-many relationship between Orders and Products.



## ⚡ Technical Highlights
### 1. Automatic Stock Deduction
I implemented a PL/pgSQL function that automatically reduces product stock whenever a new item is added to an order.
```sql
-- Trigger logic example
CREATE TRIGGER trigger_update_stock
AFTER INSERT ON order_items
FOR EACH ROW EXECUTE FUNCTION update_stock_after_order();
