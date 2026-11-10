CREATE TABLE users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE categories (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(10) NOT NULL,

    CONSTRAINT fk_categories_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT unique_category_per_user
        UNIQUE (user_id, name),

    CONSTRAINT check_category_type
        CHECK (type IN ('INCOME', 'EXPENSE')),

    CONSTRAINT unique_user_category_pair
        UNIQUE (user_id, id)
);


CREATE TABLE transactions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    category_id BIGINT,
    amount NUMERIC(12,2) NOT NULL,
    description VARCHAR(255),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transactions_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_transactions_category
        FOREIGN KEY (user_id, category_id)
        REFERENCES categories(user_id, id)
        ON DELETE RESTRICT,

    CONSTRAINT check_transaction_amount
        CHECK (amount > 0)
);
