-- Insert data into user_account table
INSERT INTO user_account (date_of_birth, name, gender,phone_number)
VALUES
('1980-01-01', 'John Doe', 'Male', '+6591234567'),
('1990-02-02', 'Jane Doe', 'Female', '+6591234568'),
('2000-03-03', 'Jim Doe', 'Male','+6591234569'),
('1970-04-04', 'Jill Doe', 'Female','+6591234570'),
('1985-05-05', 'Jack Doe', 'Male', '+6591234571');

INSERT INTO related (user_1_id, user_2_id, type)
VALUES
(1, 2, 'family');

INSERT INTO mall_management_company (address)
VALUES
('123 Main St'),
('456 Oak St'),
('789 Pine St'),
('321 Elm St'),
('654 Maple St');

INSERT INTO mall ( company_id, address, number_of_shops)
VALUES
( 1, '123 Mall St', 20),
( 2, '456 Mall St', 30),
( 3, '789 Mall St', 40),
( 4, '321 Mall St', 50),
( 5, '654 Mall St', 60);

INSERT INTO shop ( mall_id, type)
VALUES
( 1, 'clothing'),
( 2, 'electronics'),
( 3, 'grocery'),
( 4, 'home goods'),
( 5, 'bookstore'),
( 1, 'electronics'),
( 1, 'bookstore'),
( 1, 'home goods');

INSERT INTO shop_transaction (shop_id, user_id, amount_spent, started_at, ended_at)
VALUES
(1, 1, 100.00, '2023-02-01 09:00:00', '2023-02-01 10:00:00'),
(2, 2, 200.00, '2023-02-09 10:00:00', '2023-02-09 11:00:00'),
(3, 3, 300.00, '2023-03-03 11:00:00', '2023-03-03 12:00:00'),
(4, 4, 400.00, '2023-04-04 12:00:00', '2023-04-04 13:00:00'),
(5, 5, 500.00, '2023-05-05 13:00:00', '2023-05-05 14:00:00'),
-- Rows for Query 4.
(1, 1, 101.00, '2023-12-01 00:00:00', '2023-12-01 01:00:00'),
(1, 1, 102.00, '2023-12-02 00:00:00', '2023-12-02 01:00:00'),
(1, 1, 111.00, '2024-01-01 00:00:00', '2024-01-01 01:00:00'),

(2, 2, 201.00, '2023-12-01 00:00:00', '2023-12-01 01:00:00'),
(2, 2, 202.00, '2023-12-02 00:00:00', '2023-12-02 01:00:00'),
(2, 2, 222.00, '2024-01-01 00:00:00', '2024-01-01 01:00:00'),
---- Test that only compulsive shoppers are included.
(3, 3, 333.00, '2023-12-01 00:00:00', '2023-12-01 01:00:00');
;

INSERT INTO restaurant_chain (address)
VALUES
('123 Restaurant St'),
('456 Restaurant St'),
('789 Restaurant St'),
( '321 Restaurant St'),
('654 Restaurant St');

INSERT INTO restaurant_outlet (mall_id, restaurant_id)
VALUES
( 1, 1),
( 2, 2),
( 3, 3),
( 4, 4),
( 5, 5),
(1, 2),
( 1, 4);

INSERT INTO restaurant_transaction (restaurant_outlet_id, user_id, amount_spent, started_at, ended_at)
VALUES
(1, 1, 50.00, '2023-02-16 12:00:00', '2023-02-16 13:00:00'),
(1, 1, 40.00, '2023-02-09 12:00:00','2023-02-09 14:00:00'),
(2, 2, 60.00, '2023-02-02 13:00:00', '2023-02-02 14:00:00'),
(3, 3, 70.00, '2023-03-03 14:00:00', '2023-03-03 15:00:00'),
(4, 4, 80.00, '2023-04-04 15:00:00', '2023-04-04 16:00:00'),
(5, 5, 90.00, '2023-05-05 16:00:00', '2023-05-05 17:00:00'),
(6, 1, 50.00, '2023-01-01 12:00:00', '2023-01-01 13:30:00'), -- User 1 visited all 3 restaurants in mall 1
(7, 1, 30.00, '2023-02-01 18:00:00', '2023-02-01 19:15:00'),
(6, 2, 60.00, '2023-04-01 11:00:00', '2023-04-01 12:45:00'), -- User 2 visited only 1 restaurant in mall 1 and the only one in mall 2
-- Rows for Query 4.
(1, 1, 103.00, '2023-12-01 00:00:00', '2023-12-01 01:00:00'),
(1, 1, 104.00, '2023-12-02 00:00:00', '2023-12-02 01:00:00'),
(1, 1, 105.00, '2023-12-03 00:00:00', '2023-12-03 01:00:00'),
(1, 1, 111.00, '2024-01-01 00:00:00', '2024-01-01 01:00:00'), -- Test that rows outside date range is not included.

(2, 2, 203.00, '2023-12-01 00:00:00', '2023-12-01 01:00:00'),
(2, 2, 204.00, '2023-12-02 00:00:00', '2023-12-02 01:00:00'),
(2, 2, 205.00, '2023-12-03 00:00:00', '2023-12-03 01:00:00'),
(3, 2, 206.00, '2023-12-03 00:00:00', '2023-12-03 01:00:00'),
(2, 2, 222.00, '2024-01-01 00:00:00', '2024-01-01 01:00:00'), -- Test that rows outside date range is not included.
(3, 3, 333.00, '2023-12-01 00:00:00', '2023-12-01 01:00:00'); -- Test that only compulsive shoppers are included.

INSERT INTO complaint ( text, status, filled_at)
VALUES
('The service was poor', 'pending', '2023-01-01 14:00:00'),
('The food was not good', 'being handled', '2023-02-02 15:00:00'),
( 'The prices are too high', 'addressed', '2023-03-03 16:00:00'),
( 'The shop was dirty', 'pending', '2023-04-04 17:00:00'),
( 'The staff was rude', 'being handled', '2023-05-05 18:00:00');

INSERT INTO complaint_on_shop (complaint_id, shop_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO complaint_on_restaurant_outlet (complaint_id, restaurant_outlet_id)
VALUES
(4, 3),
(5, 5);

INSERT INTO voucher_validity_period(issued_at, expire_at)
VALUES
('2024-04-01 11:00:00', '2024-06-01 11:00:00'),
('2023-02-01 11:00:00', '2023-05-01 11:00:00'),
('2023-01-01 11:00:00', '2023-04-01 11:00:00'),
('2024-04-02 11:00:00', '2024-06-02 11:00:00'),
('2023-02-02 11:00:00', '2023-05-02 11:00:00'),
('2023-02-03 11:00:00', '2023-06-03 11:00:00'),
('2023-02-09 11:00:00', '2023-07-09 11:00:00');


-- Insert data into voucher table
INSERT INTO voucher ( description, status, issued_at)
VALUES
( 'Voucher 1', 'allocated','2024-04-01 11:00:00'),
( 'Voucher 2', 'redeemed','2023-02-01 11:00:00'),
('Voucher 3', 'expired','2023-01-01 11:00:00'),
('Voucher 4', 'allocated','2024-04-02 11:00:00'),
('Voucher 5', 'redeemed','2023-02-02 11:00:00'),
( 'Voucher 6', 'redeemed','2023-02-03 11:00:00'),
('Voucher 7', 'redeemed','2023-02-09 11:00:00');


-- Insert data into purchase_voucher table
INSERT INTO purchase_voucher (id, user_id, percentage_discount, used_at)
VALUES
(2, 2, 15.0, '2023-02-09 11:00:00');

-- Insert data into dine_voucher table
INSERT INTO dine_voucher (id, user_id, cash_discount, used_at)
VALUES
(5, 1, 5.0, '2023-02-16 13:00:00');

-- Insert data into group_voucher table
INSERT INTO group_voucher (id, user_id, group_size, group_cash_discount, used_at)
VALUES
(6, 3, 2, 5.0, '2023-02-11 13:00:00');

-- Insert data into day_package table
INSERT INTO day_package (user_id, voucher_id, description)
VALUES
( 1, 7, 'Day package 1'),
( 2, 4, 'Day package 2');

-- Insert data into day_package_mall table
INSERT INTO day_package_mall (day_package_id, mall_id)
VALUES
(1, 1);

-- Insert data into day_package_restaurant_outlet table
INSERT INTO day_package_restaurant_outlet (day_package_id, restaurant_outlet_id)
VALUES
(2, 1);

-- Insert data into day_package_voucher table
INSERT INTO day_package_voucher(id, day_package_id, cash_discount)
VALUES
(7, 1, 5.0),
(4, 2, 10.0);

-- Insert data into recommendation table
INSERT INTO recommendation ( day_package_id, issued_at, expired_at)
VALUES
( 1, '2023-02-09 11:00:00', '2023-07-09 11:00:00'),
( 2, '2024-04-02 11:00:00', '2023-06-02 11:00:00');

-- Insert data into recommendation_user_account table
INSERT INTO recommendation_user_account (recommendation_id, user_id)
VALUES
(1, 1),
(2, 2);

