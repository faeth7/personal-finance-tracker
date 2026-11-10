# Personal Finance Tracker – Database Design

## 1. Users Table

Stores information about registered users.

**users**
- `id` – Primary key
- `name` – User's full name
- `email` – User's email address (must be unique)
- `password_hash` – Securely hashed password
- `created_at` – Account creation date and time

## 2. Categories Table

Stores the categories created by each user.

**categories**
- `id` – Primary key
- `user_id` – Foreign key referencing users.id
- `name` – Category name
- `type` – Income or expense

Examples: Food, Transport, Salary and Shopping.

## 3. Transactions Table

Stores each user's financial transactions.

**transactions**
- `id` – Primary key
- `user_id` – Foreign key referencing users.id
- `category_id` – Foreign key referencing categories.id
- `amount` – Transaction amount (NUMERIC(12,2))
- `description` – Transaction description
- `transaction_date` – Date the transaction happened
- `created_at` – Date and time the transaction was recorded

The transaction's income or expense type is determined by its category.

## 4. Relationships

- One user can have many transactions.
- One user can have many categories.
- One category can have many transactions.
- Each transaction belongs to one user and one category.

## 5. Database Rules

- Every table must have a primary key.
- Email addresses must be unique.
- Foreign keys must reference existing records.
- Transaction amounts must be greater than zero.
- Users must only access their own financial information.
- Passwords must be securely hashed before being stored.