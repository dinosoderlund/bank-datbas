USE master;
GO
IF DB_ID('Bank_Databas') IS NULL
BEGIN
    CREATE DATABASE Bank_Databas;
END
GO

USE Bank_Databas;
GO

---------------------------------------------------
-- TABLES
---------------------------------------------------
CREATE TABLE Customer(
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender CHAR(1),
    PersonalNumber CHAR(12),
    BirthDate DATE,
    Address VARCHAR(100),
    ZipCode VARCHAR(10),
    City VARCHAR(50),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100)
);

CREATE TABLE Account(
    AccountID INT PRIMARY KEY,
    AccountType VARCHAR(50),
    CreatedDate DATE,
    Balance DECIMAL(15,2),
    Currency CHAR(3)
);

CREATE TABLE Disposition(
    DispositionID INT PRIMARY KEY,
    CustomerID INT,
    AccountID INT,
    DispositionType VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Card(
    CardID INT PRIMARY KEY,
    DispositionID INT,
    ExpirationDate DATE,
    CVV CHAR(3),
    CardNumber CHAR(16),
    CardType VARCHAR(20),
    FOREIGN KEY (DispositionID) REFERENCES Disposition(DispositionID)
);

CREATE TABLE Loan(
    LoanID INT PRIMARY KEY,
    CustomerID INT,
    LoanAmount DECIMAL(15,2),
    InterestRate DECIMAL(5,2),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE LoanPayment(
    LoanPaymentID INT PRIMARY KEY,
    LoanID INT,
    Amount DECIMAL(15,2),
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
);

CREATE TABLE BankTransaction(
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATETIME,
    Amount DECIMAL(15,2),
    TransactionType VARCHAR(20),
    TransactionDescription VARCHAR(255),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE SavingGoal(
    SavingGoalID INT PRIMARY KEY,
    AccountID INT,
    GoalAmount DECIMAL(15,2),
    CurrentSaved DECIMAL(15,2),
    Deadline DATE,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE StandingOrder(
    OrderID INT PRIMARY KEY,
    AccountID INT,
    TargetAccount INT,
    Amount DECIMAL(15,2),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Branch(
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100),
    Address VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE Employee(
    EmployeeID INT PRIMARY KEY,
    BranchID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(50),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);

CREATE TABLE EmployeeLogin(
    EmployeeLoginID INT PRIMARY KEY,
    EmployeeID INT,
    Username VARCHAR(50),
    PasswordHash VARCHAR(255),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE AuditLogin(
    AuditID INT PRIMARY KEY,
    EmployeeLoginID INT,
    LoginTime DATETIME,
    Action VARCHAR(100),
    IPAddress VARCHAR(45),
    FOREIGN KEY (EmployeeLoginID) REFERENCES EmployeeLogin(EmployeeLoginID)
);

CREATE TABLE Invoice(
    InvoiceID INT PRIMARY KEY,
    CustomerID INT,
    AccountID INT,
    Amount DECIMAL(15,2),
    DueDate DATE,
    IsPaid BIT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Role(
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR(50)
);

CREATE TABLE Login(
    LoginID INT PRIMARY KEY,
    CustomerID INT,
    RoleID INT,
    Username VARCHAR(50),
    PasswordHash VARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID)
);

CREATE TABLE Session(
    SessionID INT PRIMARY KEY,
    LoginID INT,
    LoginTime DATETIME,
    LogoutTime DATETIME,
    DeviceInfo VARCHAR(255),
    FOREIGN KEY (LoginID) REFERENCES Login(LoginID)
);

CREATE TABLE Service(
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100),
    ServiceDescription VARCHAR(255),
    Fee DECIMAL(15,2)
);

CREATE TABLE CustomerService(
    CustomerServiceID INT PRIMARY KEY,
    CustomerID INT,
    ServiceID INT,
    StartDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID)
);

-- NOTE: TEXT is deprecated -> use VARCHAR(MAX)
CREATE TABLE Notification(
    NotificationID INT PRIMARY KEY,
    CustomerID INT,
    Message VARCHAR(MAX),
    TimeStamp DATETIME,
    IsRead BIT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

---------------------------------------------------
-- SEED DATA
---------------------------------------------------
-- Customers
INSERT INTO Customer (CustomerID, FirstName, LastName, Gender, PersonalNumber, BirthDate, Address, ZipCode, City, PhoneNumber, Email) VALUES
(1,'Anna','Svensson','F','199001010135','1990-01-01','Ichigo Street 1','12345','Stockholm','0701234512','anna@example.com'),
(2,'Johan','Karlsson','M','198507254321','1985-07-25','bagi Street 3','23145','Göteborg','0731223511','johan@example.com'),
(3,'Caroline','Söderström','F','199001011234','1990-01-01','Elmargo Street 1','32345','Malmö','0701212567','Caroline@example.com'),
(4,'Björn','Bang','M','198507254111','1985-07-25','Leoirch Street 3','67890','Göteborg','0720234527','Björn@example.com'),
(5,'Diana','Lamo','F','199101015555','1991-01-01','Garom Street 1','32411','Skåne','0701254867','Diana@example.com'),
(6,'James','Bames','M','199302254321','1993-02-25','Breich Street 3','21890','Uppland','0731214507','James@example.com'),
(7,'Dennis','Svensson','M','20001045555','2000-01-04','Eelo Street 1','13245','Uppsala','0703234527','Dennis@example.com'),
(8,'Dino','Svensson','M','200503254321','2005-03-25','Barmo Street 3','35690','Barkaby','0741630932','Dino@example.com'),
(9,'Alvin','Norrder','M','200102015325','2001-02-01','Elmo Street 1','20345','Sollentuna','0701235547','Alvin@example.com'),
(10,'Pontus','Bmbin','M','199805254321','1998-05-25','Birgu Street 3','21890','Häggvik','0732224157','Pontus@example.com');

-- Accounts
INSERT INTO Account (AccountID, AccountType, CreatedDate, Balance, Currency) VALUES
(1,'Savings','2023-03-01',25000.00,'SEK'),
(2,'Current','2024-03-02',100.00,'SEK'),
(3,'Savings','2020-02-03',25.00,'SEK'),
(4,'Current','2021-07-04',10.00,'SEK'),
(5,'Savings','2018-02-05',2500000.00,'SEK'),
(6,'Current','2015-07-06',13251.00,'SEK'),
(7,'Savings','2016-06-07',321.00,'SEK'),
(8,'Current','2020-03-08',100.00,'SEK'),
(9,'Savings','2020-02-09',2500012.00,'SEK'),
(10,'Current','2025-01-02',12523.00,'SEK');

-- Disposition
INSERT INTO Disposition (DispositionID, CustomerID, AccountID, DispositionType) VALUES
(1,1,1,'OWNER'),
(2,2,2,'Joint'),
(3,3,3,'Joint'),
(4,4,4,'Joint'),
(5,5,5,'Joint'),
(6,6,6,'Joint'),
(7,7,7,'OWNER'),
(8,8,8,'OWNER'),
(9,9,9,'OWNER'),
(10,10,10,'OWNER');

-- Roles
INSERT INTO Role (RoleID, RoleName) VALUES
(1,'Private Customer'),
(2,'Business Customer'),
(3,'Admin'),
(4,'Customer Support'),
(5,'Manager'),
(6,'Investor'),
(7,'Private Customer'),
(8,'Private Customer'),
(9,'Business Customer'),
(10,'Admin');

-- Services
INSERT INTO Service (ServiceID, ServiceName, ServiceDescription, Fee) VALUES
(1,'Internetbanking','Access to online banking',0.00),
(2,'Premium Debit Card','Premium debit card offering many benefits',25.00),
(3,'Mobile Banking','Access to mobile banking through a phone',0.00),
(4,'Mobile Banking','Premium Access to mobile banking through a phone',0.00),
(5,'Mobile Banking','Access to mobile banking through a phone',0.00),
(6,'Mobile Banking','Access to mobile banking through a phone',0.00),
(7,'Internetbanking','Access to online banking',0.00),
(8,'Premium Debit Card','Premium debit card offering many benefits',25.00),
(9,'Internetbanking','Access to online banking',0.00),
(10,'Internet Banking','Access to online banking',0.00);

-- Cards
INSERT INTO Card (CardID, DispositionID, ExpirationDate, CVV, CardNumber, CardType) VALUES
(1,1,'2027-12-30','123','4111010111111111','Visa'),
(2,2,'2026-05-26','456','5500200200000004','Mastercard'),
(3,3,'2028-01-23','133','4111111011131311','Visa'),
(4,4,'2023-11-19','226','5500000300000304','Mastercard'),
(5,5,'2028-10-17','353','4311011011111111','Visa'),
(6,6,'2021-02-15','916','5504005007000804','Mastercard'),
(7,7,'2022-12-12','613','4615114113112111','Visa'),
(8,8,'2023-03-12','106','5501000100100204','Mastercard'),
(9,9,'2024-01-11','013','4191811711511211','Visa'),
(10,10,'2029-02-10','216','5502003005060704','Mastercard');

-- Loans
INSERT INTO Loan (LoanID, CustomerID, LoanAmount, InterestRate, StartDate, EndDate, Status) VALUES
(1,1,20000.00,3.5,'2023-01-01','2028-01-01','Active'),
(2,2,170000.00,2.1,'2022-06-01','2032-06-01','Active'),
(3,3,19000.00,3.3,'2023-01-01','2028-01-01','Active'),
(4,4,1500000.00,1.9,'2022-06-01','2032-06-01','Active'),
(5,5,200000.00,0.5,'2023-01-01','2028-01-01','Active'),
(6,6,1000.00,1.5,'2022-06-01','2032-06-01','Active'),
(7,7,3000.00,1.5,'2023-01-01','2028-01-01','Active'),
(8,8,151200.00,1.4,'2022-06-01','2032-06-01','Active'),
(9,9,2100.00,2.5,'2023-01-01','2028-01-01','Active'),
(10,10,510500.00,1.9,'2022-06-01','2032-06-01','Active');

-- Loan Payments
INSERT INTO LoanPayment (LoanPaymentID, LoanID, Amount, PaymentMethod) VALUES
(1,1,1200.00,'Autogiro'),
(2,2,100.00,'Card'),
(3,3,1200.00,'Autogiro'),
(4,4,3100.00,'Card'),
(5,5,2000.00,'Autogiro'),
(6,6,2100.00,'Card'),
(7,7,1700.00,'Card'),
(8,8,10900.00,'Card'),
(9,9,1000.00,'Autogiro'),
(10,10,100.00,'Card');

-- Transactions
INSERT INTO BankTransaction (TransactionID, AccountID, TransactionDate, Amount, TransactionType, TransactionDescription) VALUES
(1,1,'2024-05-01 10:00:00',-1200.00,'Loan payment','Payment of loan'),
(2,2,'2024-05-01 12:30:00',11000.00,'Deposit','Salary'),
(3,3,'2024-05-01 10:00:00',-200.00,'Transfer','Transfer to unknown account'),
(4,4,'2024-05-01 12:30:00',1000.00,'Deposit','Salary'),
(5,5,'2024-05-01 10:00:00',-1500.00,'Loan Payment','ICA Maxi'),
(6,6,'2024-05-01 12:30:00',-11200.00,'Investment','Investment in GEFORCE'),
(7,7,'2024-05-01 10:00:00',12100.00,'Deposit','Salary'),
(8,8,'2024-05-01 12:30:00',-100.00,'Withdrawal','Atm Withdrawal'),
(9,9,'2024-05-01 10:00:00',10200.00,'Deposit','Salary'),
(10,10,'2024-05-01 12:30:00',-100.00,'Fee','Unknown');

-- SavingGoal
INSERT INTO SavingGoal (SavingGoalID, AccountID, GoalAmount, CurrentSaved, Deadline) VALUES
(1,1,0.00,250.00,'2025-12-31'),
(2,2,2100.00,250100.00,'2030-05-25'),
(3,3,300.00,15010.00,'2031-11-21'),
(4,4,60.00,750010.00,'2032-03-22'),
(5,5,2040.00,35030.00,'2055-02-20'),
(6,6,550.00,250030.00,'2026-01-19'),
(7,7,1300.00,55030.00,'2025-10-16'),
(8,8,53400.00,652000.00,'2028-10-15'),
(9,9,100.00,95500.00,'2025-11-11'),
(10,10,150.00,15000.00,'2026-05-05');

-- StandingOrder
INSERT INTO StandingOrder (OrderID, AccountID, TargetAccount, Amount, StartDate, EndDate) VALUES
(1,1,1,500.00,'2024-02-10','2025-12-01'),
(2,2,2,100.00,'2023-05-01',NULL),
(3,3,3,200.00,'2023-06-05','2025-11-01'),
(4,4,4,300.00,'2023-01-05',NULL),
(5,5,5,400.00,'2023-01-06','2027-10-01'),
(6,6,6,500.00,'2022-01-05',NULL),
(7,7,7,600.00,'2022-02-04','2026-07-01'),
(8,8,8,700.00,'2022-05-03',NULL),
(9,9,9,800.00,'2021-12-02','2026-05-01'),
(10,10,10,100.00,'2022-10-01',NULL);

-- Invoice
INSERT INTO Invoice (InvoiceID, CustomerID, AccountID, Amount, DueDate, IsPaid) VALUES
(1,1,1,299.00,'2025-01-12',0),
(2,2,2,199.00,'2026-05-16',1),
(3,3,3,2199.00,'2025-02-15',0),
(4,4,4,1319.00,'2025-01-10',1),
(5,5,5,61.00,'2027-01-01',0),
(6,6,6,142.00,'2025-04-12',1),
(7,7,7,219.00,'2023-06-13',0),
(8,8,8,1399.00,'2020-01-25',1),
(9,9,9,259.00,'2015-02-27',0),
(10,10,10,659.00,'2016-03-05',1);

-- Login
INSERT INTO Login (LoginID, CustomerID, RoleID, Username, PasswordHash) VALUES
(1,1,1,'anna.Svensson','$a$10$QjZT8YpQYf2rzkqlTwBhFu6CUIo6i08oFqj5JhjL3dFxx8T3Uq6Su'),
(2,2,2,'Johan.Karlsson','$3a$10$7ZXgQnZzOwjQwojsGeVXReZGqVoQ7aS/JUNHa.snx.CP.2l8bD7pi'),
(3,3,3,'Caroline.Söderström','6cb75f652a9b52798eb6cf2201057c73e67e8e3c5c91e8d599416d472a823d02'),
(4,4,4,'Björn.Bang','fe01b1a663aef84ecae8f0ec84b27f5d216fb0e3641faee7d55373420863b8c2'),
(5,5,5,'Diana.Lamo','8d969eef6ecad3c29a3a629280e686cf0a4b1eaf88c0196b32b017b83fa9fe61'),
(6,6,6,'James.Bames','e10adc3949ba59abbe56e057f20f883e'),
(7,7,7,'Dennis.Svensson','d8578edf8458ce06fbc5bb3b1ee4e9b097f3a09e8ac99d415cf9b58c78a151de7'),
(8,8,8,'Dino.Svensson','5f4dcc3b5aa765d61d8327deb882cf99'),
(9,9,9,'Alvin.Norrder','$2a$10$A9yHwKFlmuM9Zm.VuON57.VvA7Y.KWy3ItP2z2ds7h4o2zLBgXyZy'),
(10,10,10,'Pontus.Bmbin','8d969eef6ecad3c29a3a629280e686cf0a4b1eaf88c0196b32b017b83fa9fe61');

-- Session (note: some rows have Logout < Login; your metrics view filters them)
INSERT INTO Session (SessionID, LoginID, LoginTime, LogoutTime, DeviceInfo) VALUES
(1,1,'2024-04-18 08:00:00','2024-04-18 10:32:00','iPhone 10'),
(2,2,'2024-01-19 09:00:00','2024-01-19 09:31:00','PC Windows 10'),
(3,3,'2024-02-20 08:00:00','2024-02-20 09:25:00','iPhone 11'),
(4,4,'2024-03-21 09:00:00','2024-03-21 10:10:00','PC Windows 10'),
(5,5,'2024-05-22 08:00:00','2024-05-22 08:15:00','iPhone 9'),
(6,6,'2024-10-23 09:00:00','2024-10-23 10:10:00','PC Windows 13'),
(7,7,'2024-11-25 08:00:00','2024-11-25 09:12:00','Samsung Galaxy S9'),
(8,8,'2024-12-21 09:00:00','2024-12-21 10:23:00','PC Windows 10'),
(9,9,'2024-11-28 08:00:00','2024-11-28 09:21:00','Macbook'),
(10,10,'2024-10-02 09:00:00','2024-10-02 10:30:00','PC Windows 11');

-- Customer services
INSERT INTO CustomerService (CustomerServiceID, CustomerID, ServiceID, StartDate, Status) VALUES
(1,1,1,'2024-02-01','Active'),
(2,2,2,'2023-10-01','In Progress'),
(3,3,3,'2024-11-01','Completed'),
(4,4,4,'2023-12-05','Active'),
(5,5,5,'2024-10-01','Active'),
(6,6,6,'2023-05-01','In Progress'),
(7,7,7,'2024-02-01','In Progress'),
(8,8,8,'2023-12-01','Completed'),
(9,9,9,'2024-03-01','Active'),
(10,10,10,'2023-11-01','In Progress');

-- Notifications
INSERT INTO Notification (NotificationID, CustomerID, Message, TimeStamp, IsRead) VALUES
(1,1,'New invoice available.','2024-05-20 10:00:00',0),
(2,2,'Balance updated','2024-05-25 05:00:00',1),
(3,3,'Your payment is due soon','2024-10-01 10:00:00',0),
(4,4,'Login Successful','2024-11-01 10:00:00',1),
(5,5,'Login failed','2024-12-01 11:00:00',0),
(6,6,'New invoice available.','2024-01-01 11:00:00',1),
(7,7,'Balance updated','2024-03-01 11:00:00',0),
(8,8,'New invoice available','2024-11-01 12:00:00',1),
(9,9,'Balance updated.','2024-01-02 10:00:00',0),
(10,10,'Login Successful.','2024-03-01 11:00:00',1);

---------------------------------------------------
-- LOG ANALYSIS (event table + views)
---------------------------------------------------
IF OBJECT_ID('dbo.CustomerAudit') IS NULL
BEGIN
  CREATE TABLE dbo.CustomerAudit(
    CustomerAuditID INT IDENTITY(1,1) PRIMARY KEY,
    LoginID INT NOT NULL,
    EventTime DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    Action VARCHAR(50) NOT NULL,        -- LOGIN_SUCCESS, LOGIN_FAILURE, CLICK, LOGOUT
    IPAddress VARCHAR(45) NULL,
    CONSTRAINT FK_CustomerAudit_Login FOREIGN KEY (LoginID) REFERENCES dbo.Login(LoginID),
    CONSTRAINT CHK_CustomerAudit_Action CHECK (Action IN ('LOGIN_SUCCESS','LOGIN_FAILURE','CLICK','LOGOUT'))
  );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CustomerAudit_Login_Time')
  CREATE INDEX IX_CustomerAudit_Login_Time ON dbo.CustomerAudit(LoginID, EventTime);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CustomerAudit_Action_Time')
  CREATE INDEX IX_CustomerAudit_Action_Time ON dbo.CustomerAudit(Action, EventTime);
GO

-- Sessions view: pair each login with nearest following logout
CREATE OR ALTER VIEW dbo.v_Sessions AS
WITH logins AS (
  SELECT CustomerAuditID, LoginID, EventTime AS LoginTime
  FROM dbo.CustomerAudit
  WHERE Action = 'LOGIN_SUCCESS'
),
logouts AS (
  SELECT LoginID, EventTime AS LogoutTime
  FROM dbo.CustomerAudit
  WHERE Action = 'LOGOUT'
)
SELECT
  l.LoginID,
  l.LoginTime,
  (SELECT MIN(o.LogoutTime)
   FROM logouts o
   WHERE o.LoginID = l.LoginID
     AND o.LogoutTime > l.LoginTime) AS LogoutTime
FROM logins l;
GO

-- Metrics view
CREATE OR ALTER VIEW dbo.v_SessionMetrics AS
SELECT 
  s.LoginID,
  s.LoginTime,
  s.LogoutTime,
  DATEDIFF(SECOND, s.LoginTime, s.LogoutTime) AS session_seconds
FROM dbo.v_Sessions s
WHERE s.LogoutTime IS NOT NULL
  AND s.LogoutTime >= s.LoginTime
  AND DATEDIFF(DAY, s.LoginTime, s.LogoutTime) < 1;
GO

-- Anomalies
CREATE OR ALTER VIEW dbo.v_SessionAnomalies AS
SELECT *,
  CASE 
    WHEN session_seconds < 20 THEN 'TOO_SHORT'
    WHEN session_seconds > 8*3600 THEN 'TOO_LONG'
  END AS anomaly_type
FROM dbo.v_SessionMetrics
WHERE session_seconds < 20 OR session_seconds > 8*3600;
GO

-- Failure bursts
CREATE OR ALTER VIEW dbo.v_FailureBursts AS
WITH fails AS (
  SELECT IPAddress, EventTime
  FROM dbo.CustomerAudit
  WHERE Action = 'LOGIN_FAILURE'
)
SELECT f1.IPAddress, f1.EventTime,
       (SELECT COUNT(*)
        FROM fails f2
        WHERE f2.IPAddress = f1.IPAddress
          AND f2.EventTime BETWEEN DATEADD(MINUTE,-5,f1.EventTime) AND f1.EventTime) AS fails_5min
FROM fails f1
WHERE (SELECT COUNT(*)
       FROM fails f2
       WHERE f2.IPAddress = f1.IPAddress
         AND f2.EventTime BETWEEN DATEADD(MINUTE,-5,f1.EventTime) AND f1.EventTime) >= 5;
GO

-- Top users by time (sort in SELECT, not in the view)
CREATE OR ALTER VIEW dbo.v_TopUsersByTime AS
SELECT LoginID, SUM(session_seconds)/3600.0 AS hours_total
FROM dbo.v_SessionMetrics
GROUP BY LoginID;
GO

-- Sessions per day
CREATE OR ALTER VIEW dbo.v_SessionsByDay AS
SELECT CAST(LoginTime AS DATE) AS date, COUNT(*) AS sessions
FROM dbo.v_SessionMetrics
GROUP BY CAST(LoginTime AS DATE);
GO

-- Average session seconds
CREATE OR ALTER VIEW dbo.v_AvgSessionSeconds AS
SELECT AVG(session_seconds) AS avg_session_seconds
FROM dbo.v_SessionMetrics;
GO

---------------------------------------------------
-- QUICK VERIFY (will show data once producer runs)
---------------------------------------------------
SELECT TOP 10 * FROM dbo.CustomerAudit ORDER BY CustomerAuditID DESC;
SELECT TOP 10 * FROM dbo.v_Sessions ORDER BY LoginTime DESC;
SELECT TOP 10 * FROM dbo.v_SessionMetrics ORDER BY LoginTime DESC;
SELECT TOP 10 * FROM dbo.v_SessionAnomalies ORDER BY LoginTime DESC;
SELECT TOP 10 * FROM dbo.v_TopUsersByTime ORDER BY hours_total DESC;
SELECT TOP 10 * FROM dbo.v_SessionsByDay ORDER BY d DESC;
SELECT * FROM dbo.v_AvgSessionSeconds;
