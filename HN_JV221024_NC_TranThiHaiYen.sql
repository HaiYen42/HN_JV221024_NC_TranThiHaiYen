create database quanlybanhang4;
use quanlybanhang4;
-- Bai 1: Tạo CSDL 
create table customers(
customer_id varchar(4) primary key,
name varchar(100) not null,
email varchar(100) not null unique,
phone varchar(25) not null unique,
address varchar(255) not null
);
create table orders(
order_id varchar(4) primary key,
customer_id varchar(4) not null,
order_date datetime not null,
total_amount double not null,
foreign key(customer_id) references customers(customer_id)
);
create table products(
product_id varchar(4) primary key,
name varchar(255) not null,
description text,
price double not null,
status bit(1) not null
);
create table orders_details(
order_id varchar(4),
product_id varchar(4),
primary key(order_id, product_id),
quantity int(11) not null,
price double not null,
foreign key(order_id) references orders(order_id),
foreign key(product_id) references products(product_id)
);
-- Bài 2: Thêm dữ liệu
insert into customers(customer_id, name, email, phone, address)
values("C001", "Nguyễn Trung Mạnh", "manhnt@gmail.com", "984756322", "Cầu Giấy, Hà Nội"),
("C002", "Hồ Hải Nam", "namhh@gmail.com", "984875926", "Ba Vì, Hà Nội"),
("C003", "Tô Ngọc Vũ", "vutn@gmail.com", "904725784", "Mộc Châu, Sơn La"),
("C004", "Phạm Ngọc Anh", "anhpn@gmail.com", "984635365", "Vinh, Nghệ An"),
("C005", "Trương Minh Cường", "cuongtm@gmail.com", "989735624", "Hai Bà Trưng, Hà Nội");   

insert into products(product_id, name, description, price, status)
values("P001", "Iphone 13 ProMax", "Bản 512 GB, xanh lá", 22999999,1),
("P002", "Dell Vostro V3510", "Core i5, Ram 8GB", 14999999,1),
("P003", "Macbook Pro M2", "8CPU 10GPU 8GB 256GB", 28999999,1),
("P004", "Apple Watch Ultra", "Titanium Palpine Loop Small", 18999999, 1),
("P005", "Airpods 2 2022", "Spatial Audio", 4090000,1);   

insert into orders(order_id, customer_id, total_amount, order_date)
values("H001", "C001", 52999997, "2023-2-22"),
("H002", "C001", 80999997, "2023-3-11"),
("H003", "C002", 54359998, "2023-1-22"),
("H004", "C003", 102999995, "2023-3-14"),
("H005", "C003", 80999997, "2022-3-12"),
("H006", "C004", 110449994, "2023-2-1"),
("H007", "C004", 79999996, "2023-3-29"),
("H008", "C005", 29999998, "2023-2-14"),
("H009", "C005", 28999999, "2023-1-10"),
("H010", "C005", 149999994, "2023-4-1");
select * from orders_details;
insert into orders_details(order_id, product_id, price, quantity)
values("H001", "P002", 14999999,1),
("H001","P004", 18999999,2),
("H002", "P001", 22999999,1),
("H002","P003", 28999999,2),
("H003", "P004", 18999999,2),
("H003", "P005", 4090000,4),
("H004", "P002", 14999999,3),
("H004", "P003", 28999999,2),
("H005","P001", 22999999,1),
("H005", "P003", 28999999,2),
("H006", "P005", 4090000,5),
("H006", "P002", 14999999, 6),
("H007", "P004", 18999999,3),
("H007", "P001", 22999999,1),
("H008", "P002", 14999999,2),
("H009", "P003", "28999999",1),
("H010", "P003", 28999999,2),
("H010", "P001", 22999999,4);
-- Bài 3: Truy vấn dữ liệu
-- 3.1 Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
select name, email, phone, address from customers
-- 3.2 Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng).
select customers.name, customers.phone, customers.address
from customers
join orders on customers.customer_id = orders.customer_id
where orders.order_date >= "2023-3-1" and orders.order_date < "2023-4-1";
-- 3.3 Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 
-- (thông tin bao gồm tháng và tổng doanh thu ). 
select  sum(total_amount) as "Total Amount ", month(order_date) as "Month"
from orders
where year(order_date) = "2023"
group by month(order_date);
-- 3.4  Thống kê những người dùng không mua hàng trong tháng 2/2023 
-- (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại)
select customers.name, customers.email, customers.phone, customers.address
from customers
left join orders on customers.customer_id = orders.customer_id
where orders.order_date >= "2023-3-1" or orders.order_date < "2023-02-1";
-- 3. 5 Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 
-- (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra)
select * from products;
select products.name, products.product_id, sum(orders_details.quantity) as "Total quantity"
from orders_details
join products on products.product_id = orders_details.product_id
join orders on orders.order_id = orders_details.order_id
where orders.order_date >= "2023-03-1" and orders.order_date < "2023-04-01"
group by products.name;
-- 3.6 Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu 
-- (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
select customers.customer_Id, customers.name, sum(orders.total_amount) as "Total Amount "
from customers
join orders on customers.customer_Id = orders.customer_Id
where year(orders.order_date) = "2023"
group by customer_id
order by sum(orders.total_amount) desc;
-- 3.7 Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên 
-- (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) 
select customers.name, orders.total_amount, orders.order_date, sum(orders_details.quantity) as "Total quantity"
from orders
join customers on customers.customer_id = orders.customer_id
join orders_details on orders.order_id = orders_details.order_id
group by orders.order_id
having sum(orders_details.quantity) >=5;

-- Bài 4: Tạo View, Procedure
-- 4.1 Tạo VIEW lấy các thông tin hoá đơn bao gồm : 
-- Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn 
CREATE VIEW View_customers AS
SELECT customers.name, customers.phone, customers.address, orders.total_amount, orders.order_date 
FROM customers
join orders on customers.customer_id = orders.customer_id;
select * from View_customers; 
-- 4.2 Tạo VIEW hiển thị thông tin khách hàng gồm : 
-- tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt.
create view customer_infor as
SELECT customers.name, customers.address, customers.phone, count(orders.order_id) as "Total orders"
from customers
join orders on customers.customer_id = orders.customer_id
group by customers.customer_id;
-- 4.3 Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm.
create view products_infor as
select products.name, products.description, products.price, sum(orders_details.quantity) as "Total order quantity"
from products
join orders_details on products.product_id = orders_details.product_id
group by products.product_id;
select * from products_infor;
-- 4.4 Đánh Index cho trường `phone` và `email` của bảng Customer. 
CREATE INDEX index_name
ON customers (phone, email);
-- 4.5 Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng
DELIMITER //
CREATE PROCEDURE findAllCustomers(IN customer_id varchar(4))
BEGIN
  SELECT * FROM customers
  where customers.customer_id = customer_id;
END //
DELIMITER ;
call findAllCustomers("C001");
-- 4.6  Tạo PROCEDURE lấy thông tin của tất cả sản phẩm
DELIMITER //
CREATE PROCEDURE findAllProducts(IN product_id varchar(4))
BEGIN
  SELECT * FROM products
  where products.product_id= product_id;
END //
DELIMITER ;
call findAllProducts("P001");
-- 4.7 Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
DELIMITER //
CREATE PROCEDURE findAllOrders(IN customer_id varchar(4))
BEGIN
  SELECT * FROM orders
  where orders.customer_id= customer_id;
END //
DELIMITER ;
call findAllOrders("C002");
-- 4.8 Tạo PROCEDURE tạo mới một đơn hàng với các 
-- tham số là mã khách hàng, tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. 
	DELIMITER //
CREATE PROCEDURE createOrder(IN order_id varchar(4), customer_id varchar(4), order_date datetime, total_amount double)
BEGIN
  insert into orders(order_id,customer_id, order_date,total_amount)
  values(order_id,customer_id, order_date,total_amount);
END //
DELIMITER ;
call createOrder("H011", "C003", "2023-4-22", 12000000);
-- 4.9 Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm 
-- trong khoảng thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. 
	DELIMITER //
CREATE PROCEDURE findOrderQuantity(IN begin_date datetime, end_date datetime)
BEGIN
 select sum(orders_details.quantity) as "Total Quantity", products.name, orders.order_date
from orders_details
join products on orders_details.product_id=  products.product_id
join orders on orders.order_id = orders_details.order_id 
group by products.product_id
having orders.order_date >= begin_date and orders.order_date <= end_date;
END //
DELIMITER ;
call findOrderQuantity("2023-2-22", "2023-3-11");
call findOrderQuantity("2023-2-22", "2023-3-9");

-- 4.10 Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra 
-- theo thứ tự giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê

DELIMITER //
CREATE PROCEDURE quantityOfProduct(month int, year int)
BEGIN
select products.name, month(orders.order_date) as "Month", sum(orders_details.quantity) as "Total Quantity "
 from orders_details
join products on orders_details.product_id=  products.product_id
join orders on orders.order_id = orders_details.order_id 
where month(orders.order_date) = month and year(orders.order_date) = year
group by month(orders.order_date);
END //
DELIMITER ;
call quantityOfProduct(4,2023);
call quantityOfProduct(3,2023);

