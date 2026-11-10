# Personal Finance Tracker – Database Design

## 1. Overview

The Personal Finance Tracker uses PostgreSQL as its relational database management system (RDBMS).

The database stores user accounts, transaction categories and financial transactions. It is designed to keep financial information organised, accurate and secure.

The database contains three main tables:

- `users`
- `categories`
- `transactions`

Each table has a primary key to uniquely identify its records. Foreign keys connect the tables and maintain relationships between them.

## 2. Database Tables

### 2.1 Users Table

The `users` table stores information about registered users.

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| id | BIGINT | Primary Key, Identity | Unique user ID |
| name | VARCHAR(100) | NOT NULL | User's name |
| email | VARCHAR(255) | NOT NULL, UNIQUE | User's email address |
| password_hash | VARCHAR(255) | NOT NULL | Securely hashed password |
| created_at | TIMESTAMP WITH TIME ZONE | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Account creation date and time |

**Purpose:**

This table stores account information. Each user has a unique ID, which is used to connect their categories and transactions to their account.

Passwords are stored as hashes rather than plain text to improve account security.

### 2.2 Categories Table

The `categories` table stores the categories created by each user.

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| id | BIGINT | Primary Key, Identity | Unique category ID |
| user_id | BIGINT | Foreign Key, NOT NULL | Identifies the category owner |
| name | VARCHAR(100) | NOT NULL | Category name |
| type | VARCHAR(10) | NOT NULL, CHECK | INCOME or EXPENSE |

**Purpose:**

Categories help users organise their financial transactions.

Examples of income categories:
- Salary
- Freelance
- Other Income

Examples of expense categories:
- Food
- Transport
- Shopping
- Bills
- Entertainment

Each category belongs to one user.

The combination of `user_id` and `name` must be unique, which prevents the same user from creating duplicate category names.

The category type is restricted to either `INCOME` or `EXPENSE` using a CHECK constraint.

### 2.3 Transactions Table

The `transactions` table stores the income and expenses recorded by users.

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| id | BIGINT | Primary Key, Identity | Unique transaction ID |
| user_id | BIGINT | Foreign Key, NOT NULL | Identifies the transaction owner |
| category_id | BIGINT | Foreign Key, NULL allowed | Identifies the transaction category |
| type | VARCHAR(10) | NOT NULL, CHECK | INCOME or EXPENSE |
| amount | NUMERIC(12,2) | NOT NULL, CHECK | Transaction amount |
| description | VARCHAR(255) | Optional | Additional transaction details |
| transaction_date | DATE | NOT NULL | Date of the transaction |
| created_at | TIMESTAMP WITH TIME ZONE | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Record creation date and time |

**Purpose:**

This table records money coming into and going out of a user's account.

The transaction type must be either `INCOME` or `EXPENSE`.

The amount must be greater than zero. The `NUMERIC(12,2)` data type is used to store financial values accurately to two decimal places.

The category is optional because users should be able to record transactions without selecting a category.

## 3. Relationships Between Tables

The database uses the following relationships:

**Users and Categories – One-to-Many**

One user can have multiple categories, but each category belongs to one user.

**Users and Transactions – One-to-Many**

One user can have multiple transactions, but each transaction belongs to one user.

**Categories and Transactions – One-to-Many**

One category can be connected to multiple transactions. A transaction can have one category or no category.

### Relationship Diagram

```text
USERS
-----
id (PK)
 |
 | 1
 |
 |--------------------|
 |                    |
 | many               | many
 |                    |
CATEGORIES         TRANSACTIONS
----------         ------------
id (PK)            id (PK)
user_id (FK)       user_id (FK)
name               category_id (FK, optional)
type               type
                   amount
                   description
                   transaction_date
                   created_at
```

## 4. Primary Keys and Foreign Keys

**Primary Keys (PK)**

A primary key uniquely identifies each record in a table.

For example, the `id` column in the users table identifies each registered user.

**Foreign Keys (FK)**

A foreign key connects one table to another by referencing its primary key or a suitable unique key.

For example, `user_id` in the transactions table references `id` in the users table.

This ensures that a transaction cannot belong to a user who does not exist.

## 5. Data Validation and Integrity

The database uses constraints to prevent invalid information from being stored.

### 5.1 Unique Constraints

- Each user must have a unique email address.
- A user cannot create two categories with the same name.
- Categories also have a unique combination of `user_id`, `id` and `type` to support transaction validation.

### 5.2 Check Constraints

The database uses CHECK constraints to validate information.

- Category type must be `INCOME` or `EXPENSE`.
- Transaction type must be `INCOME` or `EXPENSE`.
- Transaction amount must be greater than zero.

### 5.3 Transaction and Category Type Validation

Every transaction must have a type, even when no category is selected.

If a transaction has a category, its type must match the category's type.

For example:

| Transaction Type | Category | Category Type | Result |
|---|---|---|---|
| INCOME | Salary | INCOME | Allowed |
| EXPENSE | Food | EXPENSE | Allowed |
| INCOME | Food | EXPENSE | Rejected |
| EXPENSE | Salary | INCOME | Rejected |
| INCOME | No category | N/A | Allowed |

PostgreSQL enforces this using a composite foreign key involving:

- `user_id`
- `category_id`
- `type`

The categories table has a matching unique constraint on these columns.

This prevents users from assigning income transactions to expense categories and vice versa.

### 5.4 Financial Data Accuracy

The database uses `NUMERIC(12,2)` instead of FLOAT or DOUBLE for financial amounts.

This avoids common floating-point precision problems when storing and calculating money.

### 5.5 User Data Protection

The database uses foreign keys to ensure that categories and transactions reference existing users.

The backend will also enforce user ownership so that users can only access their own financial information.

## 6. Deletion Rules

The database uses `ON DELETE RESTRICT` on its foreign keys.

This prevents a record from being deleted when other records still depend on it.

For example:

- A user cannot be deleted while they have categories or transactions.
- A category cannot be deleted while transactions still reference it.

This protects financial history from accidental deletion.

The application will need a deliberate account-closure process to handle a user's data safely.

## 7. Database Indexing

The database includes an index on the transactions table:

`idx_transactions_user_date`

It uses the following columns:

```sql
CREATE INDEX idx_transactions_user_date
    ON transactions (user_id, transaction_date);
```

**Purpose:**

The most common database query will involve finding a user's transactions within a particular date range.

For example, displaying all transactions for one user during a specific month.

The index helps PostgreSQL find these records more efficiently.

Additional indexes may be introduced later if testing shows they are needed.

## 8. Security Considerations

The database and backend will work together to protect financial information.

Security measures include:

- Passwords will be stored as secure hashes, not plain text.
- Each transaction and category will be connected to its owner.
- Users will only be able to access their own financial records.
- Database constraints will prevent invalid relationships.
- Database credentials will be stored in environment variables rather than committed to GitHub.
- The backend will validate user input before saving information.

## 9. Database Design Decisions

| Decision | Reason |
|---|---|
| PostgreSQL | Reliable relational database |
| BIGINT primary keys | Provides unique record identification |
| NUMERIC(12,2) | Accurate financial values |
| Optional category_id | Allows uncategorised transactions |
| Transaction type column | Identifies income and expenses independently of categories |
| Composite foreign key | Ensures transaction and category types match |
| UNIQUE constraints | Prevent duplicate records |
| CHECK constraints | Restrict invalid values |
| ON DELETE RESTRICT | Protects financial records |
| Transaction date index | Improves date-based transaction searches |

## 10. Future Improvements

The database may be extended as the project develops.

Possible improvements include:

- Monthly budgeting.
- Savings goals.
- Recurring transactions.
- Financial reports and summaries.
- Multiple currencies.
- Improved account management.
- Additional indexes based on application performance.

These features will be considered during later development stages.

## 11. Conclusion

The database is designed to provide a structured and reliable way to store personal financial information.

It uses three main tables connected through primary and foreign keys. Constraints help maintain accurate financial records, while indexing supports efficient transaction searches.

The design also allows uncategorised transactions while ensuring that income and expense types remain consistent with selected categories.