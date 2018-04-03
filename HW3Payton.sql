--Homework 3
--Duncan Scott Martinson
--John Payton
--Database Systems
--Dr. Lisa Ball
--Fall '17
--Due 10/17

PRAGMA foreign_keys=ON;

-- dot-commands (command line utility):
--    http://www.w3resource.com/sqlite/sqlite-dot-commands.php
-- insert blank between column values in SELECT statments
.separator ' '

-- to insert a blank line for readability, try:
-- Method 1: select(" "); This works in version 3.7.8
-- Method 2: some versions allow .print '' to produce
--           a blank line in your output
--           for readability. A stackoverflow.com page say
--           " the .print was not implemented until 3.7.15"
.header ON
.mode column
.width 25 25 10

DROP TABLE IF EXISTS SUPPLIES;
DROP TABLE IF EXISTS INCLUDES;
DROP TABLE IF EXISTS ORDERS;
DROP TABLE IF EXISTS TOTAL_BALANCE;
DROP TABLE IF EXISTS SUBS;
DROP TABLE IF EXISTS CUSTOMERS;
DROP TABLE IF EXISTS ITEMS;

DROP TRIGGER IF EXISTS balanceTrigInsert;
DROP TRIGGER IF EXISTS balanceTrigUpdate;
DROP TRIGGER IF EXISTS balanceTrigDelete;
-- Add an ITEMS table so foreign keys work
-- make sure data types for fk and references column match!

--Create ITEMS table
create table ITEMS
   (ItemName varchar(25),
    primary key (ItemName)
    );

--Insert values
insert into ITEMS values('Brie');
insert into ITEMS values('Evian');
insert into ITEMS values('Perrier');
insert into ITEMS values('Peanuts');
insert into ITEMS values('Escargot');
insert into ITEMS values('Macadamias');
SELECT * FROM items;

.print

-- From stackexchange
-- Primary key fields should be declared as not null
-- (this is non-standard as the definition of a primary key is that
-- it must be unique and not null). But below is a good practice for
-- all multi-column primary keys in any DBMS.

--Create SUPPLIES table
create table SUPPLIES
   (Name varchar(25) NOT NULL,
    Item varchar(25) NOT NULL,
    Price money,
    primary key (Name,Item),
    CONSTRAINT fk_item
      foreign key (Item)
      references ITEMS(ItemName)
      on delete cascade
      on update cascade
    );
--Insert values
insert into SUPPLIES values("Acme", "Brie", 3.49);
insert into SUPPLIES values("Acme", "Perrier", 1.19);
insert into SUPPLIES values("Acme", "Macadamias", 0.06);
insert into SUPPLIES values("Acme", "Escargot", 0.25);
insert into SUPPLIES values("Ace", "Peanuts", 0.02);
insert into SUPPLIES values("Ajax", "Brie", 3.98);
insert into SUPPLIES values("Ajax", "Perrier", 1.09);
--This next line violates the foreign key constraint, Endive isnt in items table
insert into SUPPLIES values("Ajax", "Endive", 0.69);
select * from SUPPLIES;
.print

--Create INCLUDES table
--We put the check constraint on Quantity so that no customer could order
-- a zero amount of an item, that would be pointless.
create table INCLUDES
   (OrderNo varchar(4) NOT NULL,
    Item varchar(25) NOT NULL,
    Quantity int,
    primary key (OrderNo,Item),
    check (Quantity > 0)
    CONSTRAINT fk_item
      foreign key (Item)
      references ITEMS(ItemName)
      on delete cascade
      on update cascade
    );


--Insert values
insert into INCLUDES values(1024, "Brie", 3);
insert into INCLUDES values(1024, "Perrier", 6);
insert into INCLUDES values(1025, "Brie", 5);
insert into INCLUDES values(1025, "Escargot", 12);
--This next line violates the foreign key constraint, again with Endive
insert into INCLUDES values(1025, "Endive", 1);
insert into INCLUDES values(1026, "Macadamias", 2048);
select * from INCLUDES;
.print ''

--Create TOTAL_BALANCE table
create table TOTAL_BALANCE
  (value money default 0,
  primary key(value));

insert into TOTAL_BALANCE default values;

--Create Customer table
create table CUSTOMERS
  (name text NOT NULL,
  address text,
  balance money,
  primary key (name)

);
--5) Triggers for total balance
--On insert
create trigger balanceTrigInsert
  after insert on CUSTOMERS
  begin
    update TOTAL_BALANCE
    set value = (select SUM(balance) from CUSTOMERS);
  end;

--on update
create trigger balanceTrigUpdate
    after update on CUSTOMERS
    begin
      update TOTAL_BALANCE
      set value = (select SUM(balance) from CUSTOMERS);
    end;

--on delete
create trigger balanceTrigDelete
    after delete on CUSTOMERS
    begin
      update TOTAL_BALANCE
      set value = (select SUM(balance) from CUSTOMERS);
    end;

--Insert values into the customer table to activate the triggers
insert into CUSTOMERS values("Zack Zebra", "74 Family Way" , -200.00);
insert into CUSTOMERS values("Judy Giraffe", "153 Lois Lane", -50.00);
insert into CUSTOMERS values("Ruth Rino", "21 Rocky Road", 43.00);
select * from CUSTOMERS;
.print ''

--Show they work
select * from TOTAL_BALANCE;
.print

--Create orders table
create table ORDERS
  (OrderNo int(4) NOT NULL,
  OrderDate varchar(5),
  Customer text,
  primary key(OrderNo)
  CONSTRAINT fk_cust
    foreign key(Customer)
    references CUSTOMERS(name)
    on delete cascade
    on update cascade
);
--Insert values
insert into ORDERS values(1024, "Jan 3", "Zack Zebra");
insert into ORDERS values(1025, "Jan 3", "Ruth Rino");
insert into ORDERS values(1026, "Jan 4", "Zack Zebra");
select * from ORDERS;
.print ''

--Create subs table
create table SUBS
  (item text NOT NULL,
    itemSub text NOT NULL,
    primary key(item, itemSub)
    CONSTRAINT fk_item
      foreign key (item)
      references ITEMS(ItemName)
      on delete cascade
      on update cascade
    CONSTRAINT fk_sub
      foreign key (itemSub)
      references ITEMS(ItemName)
      on delete cascade
      on update cascade
  );

--insert values
insert into SUBS values('Macadamias', 'Peanuts');
insert into SUBS values('Perrier', 'Evian');
select * from Subs;
.print




--3)
--a.
select name, address
from Customers
where balance < (select balance
                 from CUSTOMERS
                 where name = 'Judy Giraffe');

.print
--b.
select Item,Price
from SUPPLIES
where Item in (select Item
               from SUPPLIES
               group by ITEM having count(*)>1)
order by Item,Price;

.print
--4)
--a.
.print 'Inserting an entry with a null name...'
insert into SUPPLIES values(null,'Brie',2.00);
select * from Supplies;
.print

--b.
.print 'Inserting an entry with a quantity of zero to the Includes table...'
insert into INCLUDES values(1024, 'Escargot', 0);
select * from INCLUDES;
.print

--c.
.print 'Deleting Zack Zebra from Customer table...'
delete from Customers
  where name = 'Zack Zebra';

select * from Customers;
.print
select * from Orders;
.print
select * from TOTAL_BALANCE;
.print

--d.
.print 'Changing Brie to tofu in Item table...'
update ITEMS
  set ItemName = 'tofu'
  where ItemName = 'Brie';

select * from Items;
.print
select * from Supplies;
.print
select * from Includes;
.print
