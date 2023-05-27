--Fiyatı 30 dan büyük kaç ürün var?

Select SUM(units_in_stock) from products where unit_price > 30

--Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele

Select LOWER(product_name) from products

--Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır 

Select CONCAT(first_name,' ',last_name) as full_name  from employees

--Region alanı NULL olan kaç tedarikçim var? 

Select count(*) from employees where region IS NULL

--a.Null olmayanlar?

Select count(*) from employees 	where region  IS NOT NULL

--Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.

Select CONCAT('TR',UPPER(product_name)) as new_productname from products

--a.Fiyatı 20den küçük ürünlerin adının başına TR ekle

Select CONCAT('TR',product_name) as new_name from products where unit_price<20

--En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

Select  product_name, unit_price from Products ORDER BY unit_price DESC

--En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

Select  product_name, unit_price from Products ORDER BY unit_price DESC limit 10

--Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.

Select product_name,unit_price from products where unit_price > ( Select AVG(unit_price) from products )

--Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.

Select SUM(unit_price*units_in_stock) from products

--Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.

Select COUNT(*) FILTER (where discontinued = 0) AS active, COUNT(*) FILTER (where discontinued = 1) AS discontinued from products

--Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.

Select product_name,category_name  from products p 	inner join categories con p.category_id=c.category_id

--Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.

Select DISTINCT category_name, AVG(unit_price) as average from products p inner join categories c on c.category_id=p.category_id GROUP BY category_name

--En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?

Select product_name,category_name,unit_price  from products p inner join categories c on c.category_id=p.category_id where unit_price=(Select MAX(unit_price) from products)

--En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı 

Select category_name,contact_name,product_name from products p inner join suppliers s on s.supplier_id=p.supplier_id inner join categories c on p.category_id=c.category_id where units_on_order=(Select MAX(units_on_order) from products)
		
--Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.

Select product_id, product_name, company_name,phone from products p inner join suppliers s on p.supplier_id = s.supplier_id where p.units_in_stock = 0

--1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı

Select ship_address, first_name, last_name from orders o inner join employees e on o.employee_id = e.employee_id where EXTRACT(YEAR from order_date) = 1998 and EXTRACT(MONTH from order_date) = 3

--1997 yılı şubat ayında kaç siparişim var?

Select COUNT(*) from orders where EXTRACT(YEAR from order_date) = 1997 and EXTRACT(MONTH from order_date) = 2

--London şehrinden 1998 yılında kaç siparişim var?

Select COUNT(*) from orders o inner join customers c on o.customer_id = c.customer_id where City = 'London' and EXTRACT(YEAR from order_date) = 1998

--1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası

Select contact_name, phone from customers c inner join orders o on c.customer_id = o.customer_id where EXTRACT(YEAR from order_date) = 1997

--Taşıma ücreti 40 üzeri olan siparişlerim 

Select *from orders where freight > 40

--Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı

Select ship_city, contact_name from orders o inner join customers c on o.customer_id = c.customer_id where freight >= 40

--1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),

Select order_date, ship_city, CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS full_name from orders o inner join employees e on o.employee_id = e.employee_id where EXTRACT(YEAR from order_date) = 1997
 
--1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )

Select contact_name, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Phone, '(', ''), ')', ''), ' ', ''), '-', ''), '.', ''), '+', '') AS phone from customers where EXISTS (Select 1 from orders where customers.customer_id = orders.customer_id AND EXTRACT(YEAR from order_date) = 1997);

--Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad 

Select first_name, last_name,contact_name,order_date from orders o inner join customers c on o.customer_id = c.customer_id inner join employees e on o.employee_id = e.employee_id

--Geciken siparişlerim?

Select * from orders where shipped_date > required_date

--Geciken siparişlerimin tarihi, müşterisinin adı

Select contact_name,shipped_date from orders o inner join customers c on o.customer_id = c.customer_id where shipped_date > required_date

--10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi 

Select product_name, category_name, quantity from order_details o inner join products p on o.product_id = p.product_id inner join categories c on p.category_id = c.category_id where order_id = 10248

--10248 nolu siparişin ürünlerinin adı , tedarikçi adı 

Select product_name,company_name from order_details o inner join products p ON o.product_id = p.product_id inner join suppliers s on p.supplier_id = s.supplier_id where order_id = 10248

--3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

Select product_name,quantity from order_details od inner join products p on od.product_id = p.product_id inner join orders o on od.order_id = o.order_id where employee_id = 3 and EXTRACT(YEAR from order_date) = 1997

--1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

Select orders.employee_id,CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name from orders JOIN employees ON orders.employee_id = employees.employee_id JOIN order_details ON orders.order_id = order_details.order_id where DATE_PART('YEAR', orders.order_date) = 1997 GROUP BY orders.employee_id, employees.first_name, employees.last_name HAVING SUM(order_details.quantity) = (Select MAX(total_quantity)from (Select SUM(order_details.quantity) AS total_quantity from orders JOIN order_details ON orders.order_id = order_details.order_id where DATE_PART('YEAR', orders.order_date) = 1997 GROUP BY orders.employee_id) AS subquery

--1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

Select orders.employee_id, CONCAT(employees.first_name, ' ', employees.last_name) AS employee_name from orders JOIN employees ON orders.employee_id = employees.employee_id JOIN order_details ON orders.order_id = order_details.order_id where DATE_PART('YEAR', orders.order_date) = 1997 GROUP BY orders.employee_id, employees.first_name, employees.last_name HAVING SUM(order_details.quantity) = (Select MAX(total_quantity)from (Select SUM(order_details.quantity) AS total_quantity from orders JOIN order_details ON orders.order_id = order_details.order_id where DATE_PART('YEAR', orders.order_date) = 1997 GROUP BY orders.employee_id) AS subquery

--En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

Select product_name,unit_price, category_name from products p inner join categories c on p.category_id = c.category_id where unit_price = ( Select MAX(unit_price) from products )
	
--Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

Select first_name, last_name , order_date, order_id from orders o inner join employees e on o.employee_id = e.employee_id ORDER BY order_date

--SON 5 siparişimin ortalama fiyatı ve orderid nedir?

Select AVG(order_details.unit_price) AS average_price,orders.order_id from orders JOIN order_details ON orders.order_id = order_details.order_id GROUP BY orders.order_id ORDER BY orders.order_id DESC LIMIT 5;

--Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

Select product_name, category_name, SUM(quantity) from order_details od inner join orders o on od.order_id = o.order_id inner join products p on od.product_id = p.product_id inner join categories c ON p.category_id = c.category_id where EXTRACT(MONTH from order_date) = 1 GROUP BY product_name, category_name

--Ortalama satış miktarımın üzerindeki satışlarım nelerdir? 

Select *from order_details od where quantity>(select AVG(quantity) from order_details) ORDER BY od.quantity DESC

--En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı 

Select p.product_name, c.category_name, s.company_name from (Select od.product_id, SUM(od.quantity) AS Total from order_details od GROUP BY od.product_id ORDER BY Total DESC LIMIT 1) AS top INNER JOIN products p on top.product_id = p.product_id inner join categories c on p.category_id = c.category_id inner join suppliers s on p.supplier_id = s.supplier_id

--Kaç ülkeden müşterim var

Select COUNT(DISTINCT Country) from Customers

--3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

Select e.employee_id, SUM(od.quantity * od.unit_price) AS Total from order_details od inner join orders o on od.order_id = o.order_id inner join employees  e on o.employee_id = e.employee_id where e.employee_id = 3 AND o.order_date >= '1997-01-01' GROUP BY e.employee_id

--10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi 

Select product_name, category_name, quantity from order_details od inner join products p on od.product_id = p.product_id inner join categories c on p.category_id = c.category_id where od.order_id = 10248
	
--10248 nolu siparişin ürünlerinin adı , tedarikçi adı 

Select product_name, company_name from order_details od inner join products p on od.product_id = p.product_id inner join suppliers s on p.supplier_id = s.supplier_id where od.order_id = 10248

--3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

Select product_name, quantity from order_details od inner join products p on od.product_id = p.product_id inner join orders o on od.order_id = o.order_id where o.employee_id = 3 AND EXTRACT(YEAR from o.order_date) = 1997
	
--1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

Select first_name, last_name ,o.employee_id from orders o inner join employees e on o.employee_id = e.employee_id where EXTRACT(YEAR from o.order_date) = 1997 GROUP BY o.employee_id, e.first_name, e.last_name ORDER BY COUNT(*) DESC LIMIT 1

--1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

Select first_name, last_name , employee_sales.employee_id from (Select o.employee_id, COUNT(*) AS Total from orders o where EXTRACT(YEAR from o.order_date) = 1997 GROUP BY o.employee_id ORDER BY Total DESC LIMIT 1) AS employee_sales inner join employees e on employee_sales.employee_id = e.employee_id

-- En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

Select product_name, unit_price, category_name from products p inner join categories c on p.category_id = c.category_id ORDER BY p.unit_price DESC LIMIT 1

--Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

Select first_name,last_name , order_date, order_id from orders o inner join employees e on o.employee_id = e.employee_id ORDER BY order_date
	
--SON 5 siparişimin ortalama fiyatı ve orderid nedir? 

Select AVG(od.unit_price) AS Average, o.order_idfrom order_details od inner join orders o on od.order_id = o.order_id GROUP BY o.order_id ORDER BY o.order_id DESC LIMIT 5

--Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

Select product_name, category_name, SUM(quantity) from order_details od inner join orders o on od.order_id = o.order_id inner join products p on od.product_id = p.product_id inner join categories c on p.category_id = c.category_id where EXTRACT(MONTH from order_date) = 1 GROUP BY product_name, category_name

--Ortalama satış miktarımın üzerindeki satışlarım nelerdir? 

Select *from order_details od where quantity>(select AVG(quantity) from order_details) ORDER BY od.quantity DESC --aynısı 47

--En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı 

Select product_name, MAX(units_on_order) as adet from products GROUP BY product_name ORDER BY product_name

--Kaç ülkeden müşterim var

Select COUNT(DISTINCT Country) from Customers

--Hangi ülkeden kaç müşterimiz var

Select country,count(*) as Number from customers GROUP BY country 

--3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

Select e.employee_id, SUM(od.quantity * od.unit_price) AS TotalSales from order_details od inner join orders o ON od.order_id= o.order_id inner join employees e ON o.employee_id = e.employee_id where e.employee_id = 3 AND o.order_date >= '01-01-2020' GROUP BY e.employee_id;

--10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?

Select SUM(quantity * unit_price) AS TotalRevenue from order_details od INNER JOIN orders o on od.order_id = o.order_id where product_id = 10 and order_date >= CURRENT_DATE 

--Hangi çalışan şimdiye kadar  toplam kaç sipariş almış..?

Select employee_id,first_name,last_name,(Select COUNT(order_id) from orders where employee_id= x.employee_id) from employees as x

--91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun

Select company_name,address,order_id from customers c LEFT JOIN orders o on c.customer_id=o.customer_id where order_id is null

--Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri

Select  company_name, contact_name,city,address,country from customers where country='Brazil'

--Brezilya’da olmayan müşteriler

Select  company_name, contact_name,city,address,country from customers where country!='Brazil'

--Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

Select * from customers where country IN ('Spain', 'France', 'Germany');

--Faks numarasını bilmediğim müşteriler

Select * from customers where fax IS NULL;

--Londra’da ya da Paris’de bulunan müşterilerim

Select * from customers where city IN ('London', 'Paris');

--Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler

Select * from customers where city = 'Mexico D.F' AND contact_title = 'owner';

--C ile başlayan ürünlerimin isimleri ve fiyatları

Select product_name, unit_pricefrom products where product_name LIKE 'C%';

--Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri

Select first_name AS "Ad", last_name AS "Soyad", birth_date AS "Doğum Tarihi" from employees where first_name LIKE 'A%';

--İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları

Select company_name AS "Şirket Adı" from customers where company_name LIKE '%Restaurant%';

--50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları

Select product_name AS "Ürün Adı", unit_price AS "Fiyat" from products where unit_price BETWEEN 50 AND 100;

--1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri

Select order_id AS "Sipariş ID", order_date AS "Sipariş Tarihi" from orders where order_date BETWEEN '1996-07-01' AND '1996-12-31';

--Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

Select * from customers where country IN ('Spain', 'France', 'Germany');

--Faks numarasını bilmediğim müşteriler

Select * from customerswhere fax IS NULL;