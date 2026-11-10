
-- =====================================================
-- PERSONAL FINANCE TRACKER
-- DATABASE SCHEMA
-- PostgreSQL
-- =====================================================

-- =====================================================
-- 1. USERS TABLE
-- =====================================================

CREATE TABLE users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE
        NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 2. CATEGORIES TABLE
-- =====================================================

CREATE TABLE categories (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(10) NOT NULL,

    -- Each category belongs to an existing user.
    CONSTRAINT fk_categories_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE RESTRICT,

    -- Prevent duplicate category names for the same user.
    CONSTRAINT unique_category_per_user
        UNIQUE (user_id, name),

    -- Only allow income or expense categories.
    CONSTRAINT check_category_type
        CHECK (type IN ('INCOME', 'EXPENSE')),

    -- Required for the composite transaction foreign key.
    CONSTRAINT unique_user_category_type
        UNIQUE (user_id, id, type)
);


-- =====================================================
-- 3. TRANSACTIONS TABLE
-- =====================================================

CREATE TABLE transactions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    category_id BIGINT,
    type VARCHAR(10) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    description VARCHAR(255),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE
        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Each transaction belongs to an existing user.
    CONSTRAINT fk_transactions_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE RESTRICT,

    -- If a category is selected, it must:
    -- 1. Exist.
    -- 2. Belong to the same user.
    -- 3. Have the same type as the transaction.
    --
    -- category_id can be NULL, allowing uncategorised
    -- transactions.
    CONSTRAINT fk_transactions_category
        FOREIGN KEY (user_id, category_id, type)
        REFERENCES categories(user_id, id, type)
        ON DELETE RESTRICT,

    -- Transaction amounts must be positive.
    CONSTRAINT check_transaction_amount
        CHECK (amount > 0),

    -- Only allow income or expense transactions.
    CONSTRAINT check_transaction_type
        CHECK (type IN ('INCOME', 'EXPENSE'))
);


-- =====================================================
-- 4. TRANSACTION INDEX
-- =====================================================

-- Helps find a user's transactions within date ranges.
CREATE INDEX idx_transactions_user_date
    ON transactions (user_id, transaction_date);


-- =====================================================
-- END OF DATABASE SCHEMA
-- =====================================================

