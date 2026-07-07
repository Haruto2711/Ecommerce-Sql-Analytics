# Ecommerce SQL Analytics

This repository contains SQL scripts for database design and analysis of a retail e-commerce system (G-Shop). It includes schema definitions, sample transactional data, and solutions to various business requests.

## Project Structure

- **Data/**
  - `create_ecommerce_tables_and_data.sql`: Setup script containing table definitions (Customers, Products, Orders, OrderDetails) and sample records.
- **Analytics_Tasks/**
  - **Business_Requests/**
    - `01_customer_and_product_insights.sql`: SQL queries addressing requests from Marketing, Merchandising, and Customer Support.

## Database Schema

The database consists of 4 main tables:
- **Customers**: Customer profiles (Age, Gender, City, JoinDate).
- **Products**: Inventory and pricing (Category, Price, Stock).
- **Orders**: Transaction records and statuses.
- **OrderDetails**: Line items for each order (Quantity, UnitPrice).

## Business Requests Solved

1. **Ticket #101 (Marketing)**: Filter male customers in Ho Chi Minh City for targeted promotions.
2. **Ticket #102 (Merchandising)**: Extract shoe products under $150 for inventory clearance.
3. **Ticket #103 (Customer Service)**: Retrieve the top 3 oldest customers for a loyalty program.
4. **Ticket #104 (Customer Service)**: Search customers by name pattern to assist with account recovery.
