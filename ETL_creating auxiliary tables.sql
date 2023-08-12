USE master;
CREATE DATABASE auxiliary;
GO

USE auxiliary;

CREATE TABLE swieta(data DATE PRIMARY KEY, swieto varchar(100), wolne BIT);
CREATE TABLE wakacje(start DATE, koniec DATE, rodzaj VARCHAR(500), PRIMARY KEY(start,koniec));

USE master;
GO
select * from swieta
select * from wakacje
DROP TABLE swieta;
DROP TABLE wakacje;
DROP TABLE auxiliary;