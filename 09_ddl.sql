-- DDL : 데이터 베이스 스키마를 CREATE, UPDATE(전체 수정), MODIFY(부분 수정), ALTER(구조 변경), DELETE 존재
--       DDL 구문은 실행 즉시 DB에 반영
--       주의 사항 : DML 구문 수행 시 Transaction에 담김, 그런데 중간에 DDL 부문 사용 시 commit됨

### create table
/*
 create table [if not exists] 테이블 명(
 column 1 자료형 [옵션 : 제약 조건|pk에 대한 auto increment] [default value] [comment],
 column 2 자료형 [옵션 : 제약 조건] [default value] [comment], # 2번째 줄부턴 auto increment 없음
 column 3 자료형 [옵션 : 제약 조건] [default value] [comment],
 ...
 );
 */

create table product(
    id int primary key auto_increment comment '제품식별코드',#pk 추가
    name varchar(100) not null comment '사용법',
    price int not null default 0 comment '상품가격',
    created_at datetime default current_timestamp comment '상품등록일시'
);

show create table product;

desc product;

select *
from information_schema.TABLES
where TABLE_SCHEMA = 'menudb'
and
    TABLE_NAME = 'product';

# product table에 insert

insert into product(name)
values ('텀블러');
insert into product(name, price)
values ('머그컵', 5000);

select * from product;

commit;

-- ===========
-- 제약 조건 (constraint) : 테이블 컬럼에 붙어 INSERT, UPDATE 시 각 컬럼에 기록되는 값에 대한 조건을 설정하는 방법
-- 데이터 무결성 보장을 위한 목정
-- 종류 : NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK

select *
from information_schema.TABLE_CONSTRAINTS
where CONSTRAINT_SCHEMA = 'menudb'
and
    TABLE_NAME = 'product';

# not null : 지정된 컴러의 값은 null 불가
# unique : 중복 불가

DROP TABLE IF EXISTS user_unique;

CREATE TABLE IF NOT EXISTS user_unique (
    user_no INT NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL UNIQUE, # 컬럼 레벨 제약 조건
    email VARCHAR(255)
    # ,UNIQUE (phone) #테이블 레벨 제약 조건
) ENGINE=INNODB;

INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com');

SELECT * FROM user_unique;

# unique 위배 -> phone 값 변경
# not null -> null 값 제거

INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(3, 'user3' , 'pass03', '이순신', '남', '010-888-8888', 'lee222@gmail.com');

# phone 값 변경 하여 unique 제약 조건 해결
SELECT * FROM user_unique;

# primary key (식별자) : 테이블 내 구분을 위한 식별자 역할에 추가
# not null + unique : 중복 되지 않는 값 필수 입력
# pk는 테이블 내 한번만 적용 가능하며 여러 컬럼을 묶어서 복합키로 설정 가능

DROP TABLE IF EXISTS user_primarykey;

CREATE TABLE IF NOT EXISTS user_primarykey (
--     user_no INT PRIMARY KEY,
    user_no INT,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    PRIMARY KEY (user_no)
) ENGINE=INNODB;

INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com');

SELECT * FROM user_primarykey;

desc user_primarykey;

# INSERT INTO user_primarykey
# (user_no, user_id, user_pwd, user_name, gender, phone, email)
# VALUES
# (null, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');

# INSERT INTO user_primarykey
# (user_no, user_id, user_pwd, user_name, gender, phone, email)
# VALUES
# (2, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');

# foreign key : 참조 된 다른 테이블에서 제공 하는 값만 사용가능
-- 참조 무결성을 위배하지 않기 위해 사용
-- 참조는 다른 테의블의 pk 또는 unique 컬럼만 참조 가능
-- 부모 테이블 : 참조를 당해서 컬럼 값을 제공하는 테이블
-- 자식 테이블 : 참조를 통해 다른 테이블의 컬럼 값을 사용하는 테이블

DROP TABLE IF EXISTS user_grade;

CREATE TABLE IF NOT EXISTS user_grade (
    grade_code INT NOT NULL UNIQUE,
    grade_name VARCHAR(255) NOT NULL
) ENGINE=INNODB;

INSERT INTO user_grade
VALUES
(10, '일반회원'),
(20, '우수회원'),
(30, '특별회원');

SELECT * FROM user_grade;

DROP TABLE IF EXISTS user_foreignkey1;

CREATE TABLE IF NOT EXISTS user_foreignkey1 (
    user_no INT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    grade_code INT ,
    FOREIGN KEY (grade_code)
		REFERENCES user_grade (grade_code)
) ENGINE=INNODB;

INSERT INTO user_foreignkey1
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com', 10),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com', 20);

SELECT * FROM user_foreignkey1;

#부모 값에 없는 데이터 참조 시 오류
# INSERT INTO user_foreignkey1
# (user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
# VALUES
# (3, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com', 50);

SELECT * FROM user_foreignkey1;

DROP TABLE IF EXISTS user_foreignkey2;

CREATE TABLE IF NOT EXISTS user_foreignkey2 (
    user_no INT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    grade_code INT ,
    FOREIGN KEY (grade_code)
		REFERENCES user_grade (grade_code)
        ON UPDATE SET NULL
        ON DELETE SET NULL
) ENGINE=INNODB;

INSERT INTO user_foreignkey2
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com', 10),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com', 20);

SELECT * FROM user_foreignkey2;

# 참조 제공 중에 변경 및 삭제 불가능
# update|delete set null : 만약 변경, 삭제 할 경우 자식의 경우 null로 변경
# update|delete cascade : 자식 테이블에서 참조 값이 포함된 모든 행을 연쇄적으로 삭제

DROP TABLE IF EXISTS user_foreignkey1;

# 부모테이블 값 수정
UPDATE user_grade
SET grade_code = 50
WHERE grade_code = 10;

-- 자식 테이블의 grade_code가 10이 었던 회원의 grade_code값이 NULL이 된 것을 확인
SELECT * FROM user_foreignkey2;


## check : 컬럼에 삽입할 값 조건 설정
DROP TABLE IF EXISTS user_check;

CREATE TABLE IF NOT EXISTS user_check (
    user_no INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3) CHECK (gender IN ('남','여')),
    age INT CHECK (age >= 19)
) ENGINE=INNODB;

INSERT INTO user_check
VALUES
    (null, '홍길동', '남', 25),
    (null, '이순신', '남', 33);

SELECT * FROM user_check;

# gender 위반
INSERT INTO user_check
VALUES (null, '안중근', '남성', 27);

# 나이 제한 위반
INSERT INTO user_check
VALUES (null, '유관순', '여', 17);


# alter 테이블 수정
-- alter table 테이블명 [서브명령어] ....
-- add 컬럼/제약조건 추가
-- drop 컬럼/제약조건 삭제
-- modify 컬럼 자료형/not null/기본값 변경
-- change 컬럼명 변경
-- rename 테이블명 변경

select * from product;

alter table product
add description varchar(255)
not null
default '설명 없음'
after price;

select * from product;

alter table product
drop description; # 참조 중엔 특정 문법 없이 불가

select * from product;

## 제약 조건 추가
alter table product
add unique (name);

desc product;

## 제약 조건 삭제
alter table product
drop name;

desc product;

# modify : not null은 modify만 가능

alter table product
modify name varchar(100) not null;

alter table product
change name product_name varchar(100) not null;

desc product;

## drop : 버림

drop table if exists product;

desc product



