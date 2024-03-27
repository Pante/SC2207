CREATE TABLE user_account (
  id INT IDENTITY(1, 1) PRIMARY KEY,
  name VARCHAR(MAX),
  gender VARCHAR(MAX) CHECK (gender IN ('male', 'female', 'others')),
  date_of_birth DATE
);

CREATE TABLE related (
  user_1_id INT REFERENCES user_account(id) ON DELETE CASCADE,
  user_2_id INT REFERENCES user_account(id) ON DELETE CASCADE CHECK (user_1_id != related.user_2_id),

  type VARCHAR(MAX) NOT NULL, -- TODO: add type constraints

  PRIMARY KEY (user_1_id, user_2_id)
);


CREATE TABLE mall_management_company (
  id INT IDENTITY(1, 1) PRIMARY KEY,
  address VARCHAR(MAX) NOT NULL
);

CREATE TABLE mall (
  id INT IDENTITY(1, 1) PRIMARY KEY,
  company_id INT REFERENCES mall_management_company(id) ON DELETE CASCADE,

  address VARCHAR(MAX) NOT NULL,
  number_of_shops INT NOT NULL CHECK (0 < number_of_shops)
);


CREATE TABLE shop (
  id INT IDENTITY(1, 1) PRIMARY KEY,
  mall_id INT REFERENCES mall(id) ON DELETE CASCADE,
  type VARCHAR(MAX) NOT NULL -- TODO: add type constraints
);

CREATE TABLE shop_transaction (
  shop_id int REFERENCES shop(id) ON DELETE CASCADE,
  user_id int REFERENCES user_account(id) ON DELETE CASCADE,

  amount_spent DECIMAL(19, 4) NOT NULL,
  started_at DATETIME2 NOT NULL,
  ended_at DATETIME2 NOT NULL CHECK (started_at < ended_at),

  PRIMARY KEY (shop_id, user_id, started_at)
);


CREATE TABLE restaurant_chain (
  id INT IDENTITY(1, 1) PRIMARY KEY,
  address VARCHAR(MAX) NOT NULL
);

CREATE TABLE restaurant_outlet (
  id INT IDENTITY(1, 1) PRIMARY KEY,
  mall_id INT REFERENCES mall(id) ON DELETE CASCADE,
  restaurant_id INT REFERENCES restaurant_chain(id) ON DELETE CASCADE
);

-- Renamed from "Dine" in FDs to align with shop_transaction.
CREATE TABLE restaurant_transaction (
  restaurant_outlet_id int REFERENCES restaurant_outlet(id) ON DELETE CASCADE,
  user_id int REFERENCES user_account(id) ON DELETE CASCADE,

  amount_spent DECIMAL(19, 4) NOT NULL,
  started_at DATETIME2 NOT NULL,
  ended_at DATETIME2 NOT NULL CHECK (started_at < ended_at),

  PRIMARY KEY (restaurant_outlet_id, user_id, started_at)
);


CREATE TABLE complaint (
  id INT IDENTITY(1, 1) PRIMARY KEY,
  text VARCHAR(MAX) NOT NULL,
  status VARCHAR(MAX) NOT NULL CHECK (status IN ('pending', 'being handled', 'addressed')),
  filled_at DATETIME2 NOT NULL
);

CREATE TABLE complaint_on_shop (
  complaint_id INT REFERENCES complaint(id) ON DELETE CASCADE,
  shop_id INT REFERENCES shop(id) ON DELETE CASCADE,

  PRIMARY KEY (complaint_id, shop_id)
);

CREATE TABLE complaint_on_restaurant_outlet (
  complaint_id INT REFERENCES complaint(id) ON DELETE CASCADE,
  restaurant_outlet_id INT REFERENCES restaurant_outlet(id) ON DELETE CASCADE,

  PRIMARY KEY (complaint_id, restaurant_outlet_id)
);


CREATE TABLE voucher_validity_period (
  issued_at DATETIME2 PRIMARY KEY,
  expire_at DATETIME2 NOT NULL CHECK (issued_at < expire_at),
);

CREATE TABLE voucher (
  id INT IDENTITY(1, 1) PRIMARY KEY,

  description VARCHAR(MAX) NOT NULL,
  status VARCHAR(MAX) NOT NULL CHECK (status in ('allocated', 'redeemed', 'expired')),

  issued_at DATETIME2 REFERENCES voucher_validity_period(issued_at) ON DELETE CASCADE
);

CREATE TABLE purchase_voucher (
  id INT PRIMARY KEY REFERENCES voucher(id) ON DELETE CASCADE,
  user_id INT REFERENCES user_account(id) ON DELETE CASCADE,

  -- Assumption: Purchase voucher's discount is a percentage.
  percentage_discount DECIMAL(5, 2) NOT NULL CHECK (0.0 < percentage_discount AND percentage_discount <= 100.0),
  used_at DATETIME2,
);

CREATE TABLE dine_voucher (
  id INT PRIMARY KEY REFERENCES voucher(id) ON DELETE CASCADE,
  user_id INT REFERENCES user_account(id) ON DELETE CASCADE,

  -- Assumption: Dine voucher's discount is a fixed cash amount.
  cash_discount DECIMAL(5, 2) NOT NULL CHECK (0.0 < cash_discount),
  used_at DATETIME2,
);

CREATE TABLE group_voucher (
  id INT PRIMARY KEY REFERENCES voucher(id) ON DELETE CASCADE,
  user_id INT REFERENCES user_account(id) ON DELETE CASCADE,

  group_size INT NOT NULL CHECK (0 < group_size),
  -- Assumption: Group voucher's discount is a fixed cash amount.
  group_cash_discount DECIMAL(5, 2) NOT NULL CHECK (0.0 < group_cash_discount),
  used_at DATETIME2,
);


-- TODO: This is split into two relations during lab 3 but the two relations feel a little odd.
CREATE TABLE day_package (
  id INT IDENTITY(1, 1) PRIMARY KEY,
  user_id INT REFERENCES user_account(id) ON DELETE CASCADE,
  voucher_id INT REFERENCES voucher(id) ON DELETE CASCADE,

  description VARCHAR(MAX) NOT NULL,
);

CREATE TABLE day_package_mall (
  day_package_id INT REFERENCES day_package(id) ON DELETE CASCADE,
  mall_id INT REFERENCES mall(id) ON DELETE CASCADE,

  PRIMARY KEY (day_package_id, mall_id)
);

CREATE TABLE day_package_restaurant_outlet (
  day_package_id INT REFERENCES day_package(id) ON DELETE CASCADE,
  restaurant_outlet_id INT REFERENCES restaurant_outlet(id) ON DELETE CASCADE,

  PRIMARY KEY (day_package_id, restaurant_outlet_id)
);

CREATE TABLE day_package_voucher (
  id INT PRIMARY KEY REFERENCES voucher(id) ON DELETE CASCADE,
  day_package_id INT REFERENCES day_package(id) ON DELETE CASCADE,

  -- Assumption: Day package voucher's discount is a fixed cash amount.
  cash_discount DECIMAL(5, 2) NOT NULL CHECK (0.0 < cash_discount),
);


CREATE TABLE recommendation (
  id INT IDENTITY(1, 1) PRIMARY KEY,
  day_package_id INT REFERENCES day_package(id) ON DELETE CASCADE,
  mall_id INT REFERENCES mall(id) ON DELETE CASCADE,
  outlet_id INT REFERENCES restaurant_outlet(id) ON DELETE CASCADE,

  issued_at DATETIME2 NOT NULL,
  expired_at DATETIME2 NOT NULL,
);

CREATE TABLE recommendation_user_account (
  recommendation_id INT REFERENCES recommendation(id) ON DELETE CASCADE,
  user_id INT REFERENCES user_account(id) ON DELETE CASCADE,

  PRIMARY KEY (recommendation_id, user_id)
);