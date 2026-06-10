create user skn_ai@'%' identified by '1234'; # 계정 생성

# MySQL에서는 DB와 schema를 같은 의미로 사용
create database menudb; # DB(저장 공간 파일) == schema(데이터 베이스 구조)

create schema employeedb;

show databases;

grant all privileges on menudb.* to skn_ai@'%'; # 권한 부여
grant all privileges on employeedb.* to skn_ai@'%'; # 권한 부여

show grants for skn_ai@'%';