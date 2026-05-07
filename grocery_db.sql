create database grocery_db;

USE grocery_db;

CREATE TABLE products (
  id BIGINT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL,
  price DECIMAL(12,2) NOT NULL,
  cost_price DECIMAL(12,2) NOT NULL,
  stock DECIMAL(12,3) NOT NULL DEFAULT 0,
  stock_unit ENUM('unit','kg') NOT NULL DEFAULT 'unit',
  sale_mode ENUM('unit','weight') NOT NULL DEFAULT 'unit',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE sales_staff (
  id BIGINT PRIMARY KEY,
  staff_id VARCHAR(50) NOT NULL UNIQUE,
  pin VARCHAR(50) NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  login_count INT NOT NULL DEFAULT 0,
  last_login_at DATETIME NULL
);

CREATE TABLE admin_accounts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(100) NOT NULL UNIQUE,
  pin VARCHAR(50) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sales (
  id VARCHAR(50) PRIMARY KEY,
  date DATE NOT NULL,
  created_at DATETIME NOT NULL,
  customer_name VARCHAR(255) NOT NULL DEFAULT 'Walk-in',
  customer_phone VARCHAR(50) NOT NULL DEFAULT '-',
  customer_email VARCHAR(255) NOT NULL DEFAULT '-',
  sales_person_name VARCHAR(255) NOT NULL DEFAULT 'Unknown Staff',
  sales_person_id VARCHAR(50) NOT NULL DEFAULT '-',
  payment_method VARCHAR(100) NOT NULL,
  discount_percent DECIMAL(5,2) NOT NULL DEFAULT 0,
  subtotal DECIMAL(14,2) NOT NULL,
  total DECIMAL(14,2) NOT NULL,
  total_cost DECIMAL(14,2) NOT NULL,
  profit DECIMAL(14,2) NOT NULL,
  customer_review TEXT,
  customer_rating TINYINT NOT NULL DEFAULT 5
);

CREATE TABLE sale_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  sale_id VARCHAR(50) NOT NULL,
  product_id BIGINT NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  category VARCHAR(100),
  qty DECIMAL(14,3) NOT NULL,
  qty_base DECIMAL(14,3) NOT NULL,
  unit VARCHAR(10) NOT NULL,
  price DECIMAL(12,2) NOT NULL,
  cost_price DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (sale_id) REFERENCES sales(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE purchase_orders (
  id VARCHAR(50) PRIMARY KEY,
  date DATE NOT NULL,
  supplier VARCHAR(255) NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  category VARCHAR(100),
  qty DECIMAL(14,3) NOT NULL,
  unit_cost DECIMAL(12,2) NOT NULL,
  total_cost DECIMAL(14,2) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customer_feedback (
  id VARCHAR(50) PRIMARY KEY,
  customer VARCHAR(255) NOT NULL,
  review TEXT NOT NULL,
  rating TINYINT NOT NULL,
  date DATE NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE return_requests (
  id VARCHAR(50) PRIMARY KEY,
  receipt_id VARCHAR(50) NOT NULL,
  sale_id VARCHAR(50) NOT NULL,
  product_id BIGINT NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  category VARCHAR(100),
  qty DECIMAL(14,3) NOT NULL,
  unit VARCHAR(10) NOT NULL,
  qty_base DECIMAL(14,3) NOT NULL,
  sold_qty_base DECIMAL(14,3) NOT NULL,
  reason TEXT NOT NULL,
  refund_amount DECIMAL(14,2) NOT NULL,
  status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  requested_by_staff_id VARCHAR(50) NOT NULL,
  requested_by_staff_name VARCHAR(255) NOT NULL,
  requested_at DATETIME NOT NULL,
  reviewed_at DATETIME NULL,
  reviewed_by VARCHAR(255) NULL,
  reviewed_note TEXT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (sale_id) REFERENCES sales(id)
);

CREATE TABLE low_stock_notifications (
  id VARCHAR(50) PRIMARY KEY,
  product_id BIGINT NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  category VARCHAR(100),
  stock DECIMAL(14,3) NOT NULL,
  resolved BOOLEAN NOT NULL DEFAULT FALSE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at DATETIME NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE suppliers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(128) NOT NULL UNIQUE,
  contact VARCHAR(128) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE supplier_products (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  supplier_id BIGINT NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  category VARCHAR(64) NOT NULL,
  cost_price DECIMAL(10,2) NOT NULL DEFAULT 0,
  stock_add INT NOT NULL DEFAULT 20,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

INSERT INTO suppliers (id, name, contact)
VALUES
  (1, 'Dairy Supplier', '0312-1111111'),
  (2, 'Fresh Farm Supplier', '0312-2222222'),
  (3, 'Meat Supplier', '0312-3333333'),
  (4, 'Dry Goods Supplier', '0312-4444444'),
  (5, 'Household Essentials Supplier', '0312-5555555');

INSERT INTO supplier_products (
  supplier_id,
  product_name,
  category,
  cost_price,
  stock_add,
  created_at
)
VALUES
  (1, 'Cheese 200g', 'Dairy', 300.00, 20, NOW()),
  (1, 'Butter 200g', 'Dairy', 340.00, 20, NOW()),
  (2, 'Banana', 'Fruits', 110.00, 40, NOW()),
  (2, 'Tomato 1kg', 'Vegetables', 95.00, 30, NOW()),
  (3, 'Beef 1kg', 'Meat', 990.00, 12, NOW()),
  (4, 'Flour 10kg', 'Dry Goods', 1250.00, 16, NOW()),
  (5, 'Shampoo Small', 'Household Essentials', 120.00, 50, NOW()),
  (5, 'Shampoo Medium', 'Household Essentials', 170.00, 30, NOW()),
  (5, 'Shampoo Large', 'Household Essentials', 220.00, 20, NOW());

INSERT INTO products (
  id,
  name,
  category,
  price,
  cost_price,
  stock,
  stock_unit,
  sale_mode
)
VALUES
  (1001, 'Cheese 200g', 'Dairy', 420.00, 300.00, 20, 'unit', 'unit'),
  (1002, 'Butter 200g', 'Dairy', 480.00, 340.00, 20, 'unit', 'unit'),
  (1003, 'Banana', 'Fruits', 190.00, 110.00, 40, 'kg', 'weight'),
  (1004, 'Tomato 1kg', 'Vegetables', 140.00, 95.00, 30, 'kg', 'weight'),
  (1005, 'Beef 1kg', 'Meat', 1480.00, 990.00, 12, 'kg', 'weight'),
  (1006, 'Flour 10kg', 'Dry Goods', 1750.00, 1250.00, 16, 'unit', 'unit'),
  (1007, 'Shampoo Small', 'Household Essentials', 180.00, 120.00, 50, 'unit', 'unit'),
  (1008, 'Shampoo Medium', 'Household Essentials', 260.00, 170.00, 30, 'unit', 'unit'),
  (1009, 'Shampoo Large', 'Household Essentials', 340.00, 220.00, 20, 'unit', 'unit');
  
ALTER TABLE purchase_orders
  ADD COLUMN supplier_id BIGINT NULL AFTER supplier,
  ADD CONSTRAINT fk_purchase_orders_supplier
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id);

DELIMITER //
CREATE PROCEDURE sp_add_product(
  IN in_id BIGINT,
  IN in_name VARCHAR(255),
  IN in_category VARCHAR(100),
  IN in_price DECIMAL(12,2),
  IN in_cost_price DECIMAL(12,2),
  IN in_stock DECIMAL(14,3),
  IN in_sale_mode ENUM('unit','weight')
)
BEGIN
  INSERT INTO products (id, name, category, price, cost_price, stock, stock_unit, sale_mode)
  VALUES (
    in_id,
    in_name,
    in_category,
    in_price,
    in_cost_price,
    in_stock,
    IF(in_sale_mode = 'weight', 'kg', 'unit'),
    in_sale_mode
  );
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_update_product(
  IN in_id BIGINT,
  IN in_name VARCHAR(255),
  IN in_category VARCHAR(100),
  IN in_price DECIMAL(12,2),
  IN in_cost_price DECIMAL(12,2),
  IN in_stock DECIMAL(14,3),
  IN in_sale_mode ENUM('unit','weight')
)
BEGIN
  UPDATE products
  SET
    name = COALESCE(NULLIF(in_name, ''), name),
    category = COALESCE(NULLIF(in_category, ''), category),
    price = COALESCE(in_price, price),
    cost_price = COALESCE(in_cost_price, cost_price),
    stock = COALESCE(in_stock, stock),
    sale_mode = COALESCE(in_sale_mode, sale_mode),
    stock_unit = IF(COALESCE(in_sale_mode, sale_mode) = 'weight', 'kg', 'unit'),
    updated_at = CURRENT_TIMESTAMP
  WHERE id = in_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_delete_product(IN in_id BIGINT)
BEGIN
  DELETE FROM products WHERE id = in_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_create_sales_staff(
  IN in_id BIGINT,
  IN in_staff_id VARCHAR(50),
  IN in_pin VARCHAR(50),
  IN in_name VARCHAR(255)
)
BEGIN
  INSERT INTO sales_staff (id, staff_id, pin, name)
  VALUES (in_id, in_staff_id, in_pin, in_name);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_remove_sales_staff(IN in_staff_id VARCHAR(50))
BEGIN
  DELETE FROM sales_staff WHERE staff_id = in_staff_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_restock_from_supplier(
  IN in_po_id VARCHAR(50),
  IN in_date DATE,
  IN in_supplier VARCHAR(255),
  IN in_product_name VARCHAR(255),
  IN in_category VARCHAR(100),
  IN in_qty DECIMAL(14,3),
  IN in_unit_cost DECIMAL(12,2),
  IN in_sell_price DECIMAL(12,2)
)
BEGIN
  DECLARE existing_id BIGINT;
  SELECT id INTO existing_id
  FROM products
  WHERE LOWER(name) = LOWER(in_product_name)
  LIMIT 1;

  IF existing_id IS NOT NULL THEN
    UPDATE products
    SET stock = stock + in_qty,
        cost_price = in_unit_cost,
        price = in_sell_price
    WHERE id = existing_id;
  ELSE
    INSERT INTO products (id, name, category, price, cost_price, stock, stock_unit, sale_mode)
    VALUES (
      UNIX_TIMESTAMP(CURRENT_TIMESTAMP)*1000,
      in_product_name,
      in_category,
      in_sell_price,
      in_unit_cost,
      in_qty,
      IF(in_category IN ('Meat','Fruits','Vegetables'),'kg','unit'),
      IF(in_category IN ('Meat','Fruits','Vegetables'),'weight','unit')
    );
    SET existing_id = LAST_INSERT_ID();
  END IF;

  INSERT INTO purchase_orders (id, date, supplier, product_name, category, qty, unit_cost, total_cost)
  VALUES (in_po_id, in_date, in_supplier, in_product_name, in_category, in_qty, in_unit_cost, in_qty * in_unit_cost);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_create_sale(
  IN in_sale_id VARCHAR(50),
  IN in_date DATE,
  IN in_created_at DATETIME,
  IN in_customer_name VARCHAR(255),
  IN in_customer_phone VARCHAR(50),
  IN in_customer_email VARCHAR(255),
  IN in_sales_person_name VARCHAR(255),
  IN in_sales_person_id VARCHAR(50),
  IN in_payment_method VARCHAR(100),
  IN in_discount_percent DECIMAL(5,2),
  IN in_subtotal DECIMAL(14,2),
  IN in_total DECIMAL(14,2),
  IN in_total_cost DECIMAL(14,2),
  IN in_profit DECIMAL(14,2),
  IN in_customer_review TEXT,
  IN in_customer_rating TINYINT
)
BEGIN
  INSERT INTO sales (
    id, date, created_at, customer_name, customer_phone, customer_email,
    sales_person_name, sales_person_id, payment_method,
    discount_percent, subtotal, total, total_cost, profit,
    customer_review, customer_rating
  ) VALUES (
    in_sale_id, in_date, in_created_at, in_customer_name, in_customer_phone, in_customer_email,
    in_sales_person_name, in_sales_person_id, in_payment_method,
    in_discount_percent, in_subtotal, in_total, in_total_cost, in_profit,
    in_customer_review, in_customer_rating
  );
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_add_customer_feedback(
  IN in_id VARCHAR(50),
  IN in_customer VARCHAR(255),
  IN in_review TEXT,
  IN in_rating TINYINT,
  IN in_date DATE
)
BEGIN
  INSERT INTO customer_feedback (id, customer, review, rating, date)
  VALUES (in_id, in_customer, in_review, in_rating, in_date);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_create_return_request(
  IN in_id VARCHAR(50),
  IN in_receipt_id VARCHAR(50),
  IN in_sale_id VARCHAR(50),
  IN in_product_id BIGINT,
  IN in_product_name VARCHAR(255),
  IN in_category VARCHAR(100),
  IN in_qty DECIMAL(14,3),
  IN in_unit VARCHAR(10),
  IN in_qty_base DECIMAL(14,3),
  IN in_sold_qty_base DECIMAL(14,3),
  IN in_reason TEXT,
  IN in_refund_amount DECIMAL(14,2),
  IN in_requested_by_staff_id VARCHAR(50),
  IN in_requested_by_staff_name VARCHAR(255),
  IN in_requested_at DATETIME
)
BEGIN
  INSERT INTO return_requests (
    id, receipt_id, sale_id, product_id, product_name, category,
    qty, unit, qty_base, sold_qty_base, reason, refund_amount,
    requested_by_staff_id, requested_by_staff_name, requested_at
  )
  VALUES (
    in_id, in_receipt_id, in_sale_id, in_product_id, in_product_name, in_category,
    in_qty, in_unit, in_qty_base, in_sold_qty_base, in_reason, in_refund_amount,
    in_requested_by_staff_id, in_requested_by_staff_name, in_requested_at
  );
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_approve_return_request(
  IN in_request_id VARCHAR(50),
  IN in_reviewed_by VARCHAR(255),
  IN in_reviewed_note TEXT,
  IN in_reviewed_at DATETIME
)
BEGIN
  UPDATE return_requests
  SET status = 'approved',
      reviewed_by = in_reviewed_by,
      reviewed_note = in_reviewed_note,
      reviewed_at = in_reviewed_at
  WHERE id = in_request_id AND status = 'pending';
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_reject_return_request(
  IN in_request_id VARCHAR(50),
  IN in_reviewed_by VARCHAR(255),
  IN in_reviewed_note TEXT,
  IN in_reviewed_at DATETIME
)
BEGIN
  UPDATE return_requests
  SET status = 'rejected',
      reviewed_by = in_reviewed_by,
      reviewed_note = in_reviewed_note,
      reviewed_at = in_reviewed_at
  WHERE id = in_request_id AND status = 'pending';
END;
//
DELIMITER ;

CREATE VIEW vw_daily_dashboard AS
SELECT
  CURDATE() AS report_date,
  COUNT(DISTINCT s.id) AS sales_count,
  COALESCE(SUM(s.total), 0) AS total_revenue,
  COALESCE(SUM(s.profit), 0) -
    COALESCE((SELECT SUM(refund_amount)
              FROM return_requests rr
              WHERE rr.status = 'approved'
                AND DATE(rr.reviewed_at) = CURDATE()), 0) AS total_profit,
  COALESCE((SELECT SUM(refund_amount)
            FROM return_requests rr
            WHERE rr.status = 'approved'
              AND DATE(rr.reviewed_at) = CURDATE()), 0) AS return_loss,
  COALESCE(SUM(CASE WHEN s.profit < 0 THEN ABS(s.profit) ELSE 0 END), 0) +
    COALESCE((SELECT SUM(refund_amount)
              FROM return_requests rr
              WHERE rr.status = 'approved'
                AND DATE(rr.reviewed_at) = CURDATE()), 0) AS total_loss
FROM sales s
WHERE s.date = CURDATE();

CREATE VIEW vw_low_stock_products AS
SELECT
  p.id,
  p.name,
  p.category,
  p.stock,
  p.stock_unit,
  p.sale_mode
FROM products p
WHERE p.stock < 15;

CREATE VIEW vw_return_requests AS
SELECT
  rr.id,
  rr.receipt_id,
  rr.sale_id,
  rr.product_id,
  rr.product_name,
  rr.category,
  rr.qty,
  rr.unit,
  rr.status,
  rr.requested_at,
  rr.reviewed_at,
  rr.reviewed_by
FROM return_requests rr;

CREATE VIEW vw_sales_by_staff AS
SELECT
  sales_person_id,
  sales_person_name,
  COUNT(*) AS receipts,
  SUM(total) AS total_sales,
  SUM(profit) AS total_profit
FROM sales
GROUP BY sales_person_id, sales_person_name;

DELIMITER //
CREATE TRIGGER trg_sale_item_after_insert
AFTER INSERT ON sale_items
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock = stock - NEW.qty_base
  WHERE id = NEW.product_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_return_request_after_update
AFTER UPDATE ON return_requests
FOR EACH ROW
BEGIN
  IF OLD.status = 'pending' AND NEW.status = 'approved' THEN
    UPDATE products
    SET stock = stock + NEW.qty_base
    WHERE id = NEW.product_id;
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_product_low_stock_after_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
  IF NEW.stock < 15 AND OLD.stock >= 15 THEN
    INSERT INTO low_stock_notifications (
      id, product_id, product_name, category, stock, created_at
    ) VALUES (
      CONCAT('ALERT-', UNIX_TIMESTAMP(CURRENT_TIMESTAMP), '-', NEW.id),
      NEW.id,
      NEW.name,
      NEW.category,
      NEW.stock,
      CURRENT_TIMESTAMP
    );
  END IF;
END;
//
DELIMITER ;

-- to view all the tables
SELECT * FROM products;
SELECT * FROM sales_staff;
SELECT * FROM admin_accounts;
SELECT * FROM sales;
SELECT * FROM sale_items;
SELECT * FROM purchase_orders;
SELECT * FROM customer_feedback;
SELECT * FROM return_requests;
SELECT * FROM low_stock_notifications;
SELECT * FROM suppliers;
SELECT * FROM supplier_products;

