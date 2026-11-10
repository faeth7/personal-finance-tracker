# Personal Finance Tracker – Database Design

## 1. Overview

The Personal Finance Tracker will use a relational PostgreSQL database to store user accounts, transaction categories and financial transactions.

The database will contain three main tables:

- `users` – stores registered user information.
- `categories` – stores income and expense categories belonging to users.
- `transactions` – stores users' income and expenses.

Each table will have a primary key, and foreign keys will connect related records.

---

## 2. Users Table

The `users` table stores information about registered users.

### Columns

| Column | Data type | Required? | Description |
|---|---|---|---|
| id | BIGINT | Yes | Primary key and unique user ID. |
| name | VARCHAR(100) | Yes | User's full name. |
| email | VARCHAR(255) | Yes | User's email address. Must be unique. |
| password_hash | VARCHAR(255) | Yes | Securely hashed password. |
| created_at | TIMESTAMP WITH TIME ZONE | Yes | Date and time the account was created. |

### Rules
- `id` is the primary key.
- Email addresses must be unique.
- All columns must contain a value.
- Passwords must be hashed before being stored.

---

## 3. Categories Table

The `categories` table stores categories created for each user.

### Columns

| Column | Data type | Required? | Description |
|---|---|---|---|
| id | BIGINT | Yes | Primary key and unique category ID. |
| user_id | BIGINT | Yes | Foreign key referencing users.id. |
| name | VARCHAR(100) | Yes | Name of the category. |
| type | VARCHAR(10) | Yes | Category type: INCOME or EXPENSE. |

### Examples

| id | user_id | name | type |
|---|---|---|---|
| 1 | 1 | Salary | INCOME |
| 2 | 1 | Food | EXPENSE |
| 3 | 2 | Freelance | INCOME |
| 4 | 2 | Transport | EXPENSE |

### Rules
- `id` is the primary key.
- `user_id` is a foreign key referencing `users.id`.
- A user cannot have two categories with the same name.
- Category names must be unique for each user using `UNIQUE (user_id, name)`.
- The `type` column must only accept `INCOME` or `EXPENSE`.
- Categories must belong to an existing user.

---

## 4. Transactions Table

The `transactions` table stores each user's financial transactions.

### Columns

| Column | Data type | Required? | Description |
|---|---|---|---|
| id | BIGINT | Yes | Primary key and unique transaction ID. |
| user_id | BIGINT | Yes | Foreign key referencing users.id. |
| category_id | BIGINT | No | Foreign key referencing the user's category. |
| amount | NUMERIC(12,2) | Yes | Financial transaction amount. |
| description | VARCHAR(255) | No | Optional transaction description. |
| transaction_date | DATE | Yes | Date the transaction happened. |
| created_at | TIMESTAMP WITH TIME ZONE | Yes | Date and time the transaction was recorded. |

### Examples

| id | user_id | category_id | amount | description |
|---|---|---|---|---|
| 1 | 1 | 2 | 12.50 | Lunch |
| 2 | 1 | 1 | 900.00 | Monthly income |
| 3 | 2 | 4 | 35.00 | Bus tickets |

### Rules
- `id` is the primary key.
- `user_id` is a foreign key referencing `users.id`.
- `category_id` is optional, allowing uncategorised transactions.
- If a category is selected, it must belong to the same user as the transaction.
- Amounts must be greater than zero.
- Amounts use `NUMERIC(12,2)` to avoid floating-point precision problems.
- Income or expense type is determined by the selected category.
- A transaction must belong to an existing user.

---

## 5. Relationships

The database will use one-to-many relationships.

- One user can have many categories.
- One user can have many transactions.
- One category can have many transactions.
- Each category belongs to one user.
- Each transaction belongs to one user.
- Each transaction can have one category or no category.

### Entity Relationship Diagram

```text
USERS
-----
PK id
   name
   email
   password_hash
   created_at
   |
   | 1
   |
   |------< Many
   |
CATEGORIES
----------
PK id
FK user_id
   name
   type
   |
   | 1
   |
   |------< Many
   |
TRANSACTIONS
------------
PK id
FK user_id
FK category_id (optional)
   amount
   description
   transaction_date
   created_at
```

---

## 6. Preventing Users from Accessing Other Users' Categories

A transaction must never use a category belonging to another user.

For example, Aisha (user 1) must not be able to use a category belonging to Tom (user 2).

We will use two layers of protection:

### 6.1 Service Layer Validation

Before saving a transaction, the Java Service layer will check that the selected category belongs to the logged-in user.

If the category belongs to another user, the application will reject the request.

### 6.2 Database-Level Protection

PostgreSQL will use a composite foreign key.

The `categories` table will have a unique constraint on:

`UNIQUE (user_id, id)`

The `transactions` table will reference:

`FOREIGN KEY (user_id, category_id) REFERENCES categories(user_id, id)`

This ensures that the transaction's user and category belong together.

If `category_id` is NULL, the transaction can be saved without a category.

Using both methods provides additional protection against incorrect data.

---

## 7. Deleting Categories

We will use `ON DELETE RESTRICT` for the category relationship.

This means:
- A category cannot be deleted while transactions are using it.
- Users must move those transactions to another category or remove their category references first.
- Once no transactions use the category, it can be deleted.

We will not use `ON DELETE CASCADE` for categories because deleting a category should never automatically delete financial transactions.

This protects the user's financial history.

---

## 8. Default Categories

When a new user registers, the application will automatically create some default categories.

### Income categories
- Salary
- Freelance
- Other Income

### Expense categories
- Food
- Transport
- Shopping
- Bills
- Entertainment

Each default category will belong to the newly registered user.

Users will also be able to create their own categories.

Default categories will be created by the backend during registration.

---

## 9. Database Constraints and Rules

The database will enforce the following rules:

1. Every table must have a primary key.
2. Email addresses must be unique.
3. Foreign keys must reference existing records.
4. Category names must be unique for each user.
5. Category types must only accept INCOME or EXPENSE.
6. Transaction amounts must be greater than zero.
7. Required columns must use NOT NULL.
8. Transactions cannot reference another user's category.
9. Categories cannot be deleted while transactions still reference them.
10. Transaction amounts must use an accurate decimal data type.

---

## 10. Security Rules

These rules will be enforced by the Spring Boot backend rather than relying only on the database:

- Passwords must be securely hashed using a suitable algorithm such as Argon2 or bcrypt.
- Users must only access their own financial information.
- The backend must validate requests before saving information.
- The logged-in user's identity must determine transaction ownership, not an untrusted user ID supplied by the frontend.
- Users must not be able to access or modify another user's transactions or categories.

---

## 11. Design Decisions

| Decision | Reason |
|---|---|
| PostgreSQL | Provides reliable relational data storage. |
| Three main tables | Separates users, categories and transactions. |
| Primary and foreign keys | Connects records and maintains data integrity. |
| Categories belong to users | Allows users to create their own categories. |
| Composite foreign key | Prevents transactions using another user's categories. |
| ON DELETE RESTRICT | Protects financial transaction history. |
| NUMERIC(12,2) | Stores financial amounts accurately. |
| Optional category_id | Allows transactions without a category. |
| Unique category names per user | Prevents duplicate categories. |

## 12. Initial Project Scope

The first database version will support:

- User account information.
- Income and expense categories.
- Adding and storing transactions.
- Connecting transactions to their owners and categories.
- Basic financial data retrieval.

More advanced features, such as budgets, savings goals and financial reports, will be introduced in later development stages.