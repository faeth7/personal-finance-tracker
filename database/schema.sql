-- ==========================================
-- PERSONAL FINANCE TRACKER
-- DATABASE SCHEMA
-- ==========================================

-- 1. USERS TABLE
CREATE TABLE users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- 2. CATEGORIES TABLE
CREATE TABLE categories (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(10) NOT NULL,

    CONSTRAINT fk_categories_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE RESTRICT,

    CONSTRAINT unique_category_per_user
        UNIQUE (user_id, name),

    CONSTRAINT check_category_type
        CHECK (type IN ('INCOME', 'EXPENSE')),

    CONSTRAINT unique_user_category_pair
        UNIQUE (user_id, id)
);


-- 3. TRANSACTIONS TABLE
CREATE TABLE transactions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    category_id BIGINT,
    type VARCHAR(10) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    description VARCHAR(255),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transactions_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_transactions_category
        FOREIGN KEY (user_id, category_id)
        REFERENCES categories(user_id, id)
        ON DELETE RESTRICT,

    CONSTRAINT check_transaction_amount
        CHECK (amount > 0),

    CONSTRAINT check_transaction_type
        CHECK (type IN ('INCOME', 'EXPENSE'))
);


-- 4. TRANSACTION INDEX
CREATE INDEX idx_transactions_user_date
    ON transactions (user_id, transaction_date);
