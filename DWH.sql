-- Buat database DWH
CREATE DATABASE DWH;

-- Gunakan database DWH
\c DWH;

-- Buat tabel DimCustomer
CREATE TABLE DimCustomer (
    CustomerID SERIAL PRIMARY KEY,
    CustomerName VARCHAR(30),
    Address VARCHAR(50),
    CityName VARCHAR(30),
    Age INTEGER,
    Gender VARCHAR(6),
    Email VARCHAR(30)
);

-- Buat tabel DimAccount
CREATE TABLE DimAccount (
    AccountID SERIAL PRIMARY KEY,
    CustomerID INTEGER REFERENCES DimCustomer(CustomerID) ON DELETE CASCADE,
    AccountType VARCHAR(20),
    Balance INTEGER,
    DateOpened DATE,
    Status VARCHAR(20)
);

-- Buat tabel DimBranch
CREATE TABLE DimBranch (
    BranchID SERIAL PRIMARY KEY,
    BranchName VARCHAR(30),
    BranchLocation VARCHAR(30)
);

-- Buat tabel FactTransaction
CREATE TABLE FactTransaction (
    TransactionID SERIAL PRIMARY KEY,
    AccountID INTEGER REFERENCES DimAccount(AccountID) ON DELETE CASCADE,
    BranchID INTEGER REFERENCES DimBranch(BranchID) ON DELETE CASCADE,
    TransactionDate DATE,
    Amount INTEGER,
    TransactionType VARCHAR(20)
);




CREATE OR REPLACE FUNCTION DailyTransaction(
    start_date DATE,
    end_date DATE
)
RETURNS TABLE (
    transaction_date DATE,
    total_transactions INTEGER,
    total_amount INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        transactiondate AS transaction_date,
        COUNT(*)::INTEGER AS total_transactions,  
        SUM(amount)::INTEGER AS total_amount      
    FROM facttransaction
    WHERE transactiondate BETWEEN start_date AND end_date
    GROUP BY transactiondate
    ORDER BY transactiondate;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM DailyTransaction('2024-01-18', '2024-01-20');


DROP FUNCTION dailytransaction(date,date)


CREATE OR REPLACE FUNCTION BalancePerCustomer(
    customer_name VARCHAR
)
RETURNS TABLE (
    customername VARCHAR,
    accounttype VARCHAR,
    balance INTEGER,
    currentbalance INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.customername,
        a.accounttype,
        a.balance,
        (a.balance + 
        COALESCE(SUM(
            CASE 
                WHEN t.transactiontype = 'Deposit' THEN t.amount 
                ELSE -t.amount 
            END
        ), 0))::INTEGER AS currentbalance
    FROM dimaccount a
    JOIN dimcustomer c ON a.customerid = c.customerid
    LEFT JOIN facttransaction t ON a.accountid = t.accountid
    WHERE c.customername ILIKE '%' || customer_name || '%'
    AND a.status = 'active'
    GROUP BY c.customername, a.accounttype, a.balance;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM BalancePerCustomer('Shelly');


DROP FUNCTION IF EXISTS BalancePerCustomer(VARCHAR);
