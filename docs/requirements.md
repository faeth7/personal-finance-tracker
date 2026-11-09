# Personal Finance Tracker – Requirements

## 1. Project Overview

The Personal Finance Tracker is a web application designed to help users manage their personal finances. Users will be able to record their income and expenses, organise transactions into categories, create monthly budgets and monitor their savings goals.

The application will include a dashboard displaying important financial information, such as total income, total expenses and remaining balance. It will also help users understand their spending habits through financial summaries and charts.

The main aim of the application is to make managing money easier by providing users with a simple, secure and organised way to track their finances and make better financial decisions.

## 2. User Personas

### Persona 1 – Aisha (University Student)

- **Age:** 20
- **Occupation:** University student
- **Financial situation:** Receives student finance and earns additional income from a part-time job.
- **Main problem:** Struggles to manage irregular income and keep track of everyday spending.
- **Needs:** Wants to record expenses, monitor monthly spending and avoid exceeding her budget.
- **Main goal:** Manage her money effectively throughout the academic year.

### Persona 2 – Tom (Young Professional)

- **Age:** 25
- **Occupation:** Graduate working full-time.
- **Financial situation:** Receives a regular monthly salary and wants to save money.
- **Main problem:** Finds it difficult to understand where his money goes each month.
- **Needs:** Wants to monitor his income and expenses, set savings goals and track his progress.
- **Main goal:** Build better financial habits and save money towards future goals.

## 3. User Stories

User stories describe features from the perspective of the people who will use the application. Each story has a priority based on its importance to the project.

1. **Must** As a user, I want to create an account and log in so that my financial information is protected.

2. **Must** As Aisha, I want to record my income so that I can keep track of money received from student finance and my part-time job.

3. **Must** As Aisha, I want to record my expenses so that I can monitor how much money I spend.

4. **Must** As a user, I want to edit a transaction so that I can correct incorrect financial information.

5. **Must** As a user, I want to delete a transaction so that I can remove records added by mistake.

6. **Must** As Tom, I want to organise transactions into categories so that I can understand where my money goes.

7. **Must** As a user, I want to view my total income, expenses and remaining balance so that I can understand my financial situation.

8. **Must** As a user, I want my financial information to remain private so that other users cannot access my records.

9. **Should** As Aisha, I want to create monthly budgets so that I can control my spending and avoid exceeding my limits.

10. **Should** As Tom, I want to set savings goals so that I can work towards specific financial targets.

11. **Should** As a user, I want to search and filter transactions by date and category so that I can find specific financial records.

12. **Should** As Tom, I want to view basic charts showing my spending by category so that I can identify where most of my money goes.

13. **Could** As a user, I want to export my financial reports as CSV files so that I can keep an external record of my finances.

14. **Could** As Aisha, I want to receive notifications when I am approaching my monthly budget limit so that I can adjust my spending.

## 4. MoSCoW Priorities

MoSCoW is a prioritisation method used to decide which features are most important for the application.

### 4.1 Must Have

These features are essential for the first working version of the application.

- Users must be able to create an account and log in.
- Users must be able to add income and expense transactions.
- Users must be able to edit and delete transactions.
- Users must be able to organise transactions into categories.
- Users must be able to view their total income, expenses and remaining balance.
- Users must only be able to access their own financial information.

### 4.2 Should Have

These features are important and should be included if development time allows.

- Users should be able to create and manage monthly budgets.
- Users should be able to create and monitor savings goals.
- Users should be able to search and filter transactions.
- Users should be able to view monthly financial summaries.
- Users should be able to view basic charts showing spending by category.

### 4.3 Could Have

These features would improve the application but are not essential for its initial release.

- Users could export financial reports as CSV files.
- Users could receive notifications when approaching their budget limits.
- Users could view advanced interactive charts and graphs.

## 5. Non-Functional Requirements

Non-functional requirements describe how well the application should operate, including its security, performance, usability and accessibility.

### 5.1 Security

- User passwords must be securely hashed and never stored as plain text.
- Users must only be able to access their own financial information.
- The application must validate user input to prevent invalid or malicious data.
- User authentication must be required before accessing private financial information.

### 5.2 Performance

- The dashboard should load within 3 seconds under normal operating conditions.
- The transaction API should return a response within 500 milliseconds when retrieving up to 1,000 transactions under normal testing conditions.
- The application should support at least 50 simultaneous users without significant performance problems.

### 5.3 Usability

- Users should be able to add a new transaction in no more than 4 clicks or taps after logging in.
- The main dashboard must display income, expenses and remaining balance clearly.
- The application must use consistent navigation, buttons and layouts throughout its pages.

### 5.4 Accessibility

- The application must support keyboard navigation for all main features.
- Text and background colours must have sufficient contrast to make information readable.
- All important buttons and form fields must have clear labels.

## 6. Project Scope

The initial version of the Personal Finance Tracker will focus on personal income and expense tracking, transaction management, user accounts, financial summaries and basic budgeting features.

The project will initially prioritise the essential features before introducing more advanced functionality.

Features such as advanced interactive charts, CSV exports and budget notifications may be developed in later stages.

## 7. Assumptions and Constraints

- The application will initially use GBP (£) as its main currency.
- Each account will belong to one individual user.
- Users will manually enter their income and expenses. Automatic bank account integration will not be included in the initial version.
- The initial version will not support multiple currencies or currency conversion.
- The application will be developed as a web application using Java, Spring Boot and PostgreSQL for the backend.
- Development will be completed as an individual portfolio project, so features will be prioritised according to available development time.
