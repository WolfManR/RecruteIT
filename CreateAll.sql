create database TestDb
go

use TestDb
go

create table dbo.Product
(
ID uniqueidentifier primary key not null,
Name nvarchar(255) unique not null,
Description nvarchar(max) null
)
go

create nonclustered index IX_Product_Name on dbo.Product(Name)
go

create table dbo.ProductVersion
(
ID uniqueidentifier primary key not null default newid(),
ProductID uniqueidentifier not null,
Name nvarchar(255) not null,
Description nvarchar(max) null,
CreatingDate datetime not null default getdate(),
Width float not null check(Width >= 0),
Height float not null check(Height >= 0),
Length float not null check(Length >= 0),

constraint FK_ProductVersion_Product foreign key (ProductID) references dbo.Product(ID) on delete cascade
)
go

create nonclustered index IX_ProductVersion_Name on dbo.ProductVersion(Name)
go

create nonclustered index IX_ProductVersion_CreatingDate on dbo.ProductVersion(CreatingDate)
go

create nonclustered index IX_ProductVersion_Width on dbo.ProductVersion(Width)
go

create nonclustered index IX_ProductVersion_Height on dbo.ProductVersion(Height)
go

create nonclustered index IX_ProductVersion_Length on dbo.ProductVersion(Length)
go

create table dbo.EventLog
(
ID uniqueidentifier primary key not null default newid(),
EventDate datetime not null default getdate(),
Description nvarchar(max) null,
)
go

create nonclustered index IX_EventLog_EventDate on dbo.EventLog(EventDate)
go

create trigger trg_Product_Inserted
on dbo.Product
after insert
as
	insert into dbo.EventLog(Description)
	select 'Product Inserted ' + e.Name 
	from INSERTED as e

go

create trigger trg_Product_Updated
on dbo.Product
after update
as
	insert into dbo.EventLog(Description)
	select 'Product Updated ' + e.Name 
	from INSERTED as e

go

create trigger trg_Product_Deleted
on dbo.Product
after delete
as
	insert into dbo.EventLog(Description)
	select 'Product Deleted ' + e.Name 
	from DELETED as e

go

create trigger trg_ProductVersion_Inserted
on dbo.ProductVersion
after insert
as
	insert into dbo.EventLog(Description)
	select 'ProductVersion Inserted ' + e.Name 
	from INSERTED as e

go

create trigger trg_ProductVersion_Updated
on dbo.ProductVersion
after update
as
	insert into dbo.EventLog(Description)
	select 'ProductVersion Updated ' + e.Name 
	from INSERTED as e

go

create trigger trg_ProductVersion_Deleted
on dbo.ProductVersion
after delete
as
	insert into dbo.EventLog(Description)
	select 'ProductVersion Deleted ' + e.Name 
	from DELETED as e

go

create procedure FindProductsVersions
	@ProductName nvarchar(255),
	@ProductVersionName nvarchar(255),
	@MininmumProductVolume float,
	@MaximumProductVolume float
as
	select distinct pv.ID as ProductVersionID, p.Name as ProductName, pv.Name as ProductVersionName, pv.Width, pv.Length, pv.Height
	from dbo.Product as p, dbo.ProductVersion as pv
	where p.ID = pv.ProductID 
	and p.Name like '%' + @ProductName + '%'
	and pv.Name like '%' + @ProductVersionName + '%'
	and (pv.Width * pv.Height * pv.Length) between @MininmumProductVolume and @MaximumProductVolume

go

insert into dbo.Product(ID, Name, Description)
values
('178F6FBA-3A1E-4F60-83D0-9B1C6430459C', 'Fish', 'The Nagasaki Lander'),
('F2C24D34-AA30-4677-B355-3F9241EEEA1B', 'Soap', 'Ergonomic executive'),
('81F72E9C-FA11-4545-9CD3-857351B2036D', 'Chips', 'Andy shoes are designed'),
('D3E46981-E35B-4636-ADD9-D295610B65A5', 'Salad', 'Carbonite web goalkeeper'),
('BDE7395D-08B9-4136-B49F-AFE5AB1AD6E9', 'Bike', 'Ergonomic executive chair'),
('F0244487-465B-42F4-99E6-E424D9694D94', 'Table', 'Andy shoes are designed'),
('B4EB6FC3-B87E-4740-B467-4D0FF219EE4B', 'Shirt', 'New range of formal')

go

insert into dbo.ProductVersion(ProductID, Name, Description, Width, Height, Length)
values
('178F6FBA-3A1E-4F60-83D0-9B1C6430459C', 'Soaked Fish', 'The Nagasaki Lander is the trademarked', 4, 5, 6),
('178F6FBA-3A1E-4F60-83D0-9B1C6430459C', 'Blury Fish', 'Andy shoes are designed to keeping in mind', 3, 5, 6),
('F2C24D34-AA30-4677-B355-3F9241EEEA1B', 'Ball', 'New range of formal shirts are designed', 10, 6, 45),
('81F72E9C-FA11-4545-9CD3-857351B2036D', 'Bike', 'Andy shoes are designed to keeping in mind', 6, 7, 9),
('D3E46981-E35B-4636-ADD9-D295610B65A5', 'Fish', 'Carbonite web goalkeeper gloves', 2, 4, 3),
('BDE7395D-08B9-4136-B49F-AFE5AB1AD6E9', 'Chicken', 'The Football Is Good For Training', 1, 2, 1),
('F0244487-465B-42F4-99E6-E424D9694D94', 'Pizza', 'New range of formal', 5, 5, 4),
('F0244487-465B-42F4-99E6-E424D9694D94', 'Pizza', 'The Apollotech B340', 7, 1, 5),
('B4EB6FC3-B87E-4740-B467-4D0FF219EE4B', 'Towels', 'The beautiful range', 8, 4, 2)

go

-- Because we already add test data there exist point to add auto generating key value for product table
alter table dbo.Product add constraint df_primaryKey default newid() for ID;
go