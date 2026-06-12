-- ===================================
-- DML
-- ===================================
-- DML(Data Manipulation Language)
-- Data를 조작(삽입, 수정, 삭제, 조회)하기 위해 사용하는 언어
-- Data를 이용하려는 사용자와 DB사이의 인터페이스를 직접적으로 제공하는 언어로써 가장 많이 사용됨
-- INSERT, UPDATE, DELETE, SELECT(DQL)

# INSERT
-- 새로운 행을 추가하는 구문이다.
-- 테이블의 행의 수가 증가한다.
-- insert요청시 처리된 행의 수가 반환된다. (PyCharm에서 Service뷰-Output탭에서 확인이 가능)

# 문법
-- 1. INSERT INTO <테이블명> VALUES (입력데이터1, 입력데이터2, ... );
-- 2. INSERT INTO <테이블명>(컬럼명1,컬럼명2,...) VALUES (입력데이터1, 입력데이터2, ... );`
--      - null을 허용하는 컬럼은 생략가능하다(생략되면 null값이 대입)
--      - not null인 컬럼은 생략할 수 없다.(단, default값이 지정되면 생략가능)
-- 3. INSERT INTO <테이블명>(컬럼명1,컬럼명2,...) VALUES
--      (입력데이터1, 입력데이터2, ... ), (입력데이터1, 입력데이터2, ... ), ... ;

# 행(record) 추가
# - 제약조건에 위배되는 컬럼값이 하나라도 있으면 추가할 수 없다.
# - not null컬럼에는 null값이 있을 수 없다.
# - pk, unique컬럼에는 중복값이 들어갈 수 없다.
# - fk컬럼 참조하는 컬럼 이외의 값을 들어갈 수 없다.
# - check컬럼 제시된 도메인외의 값을 들어갈 수 없다.

-- 1. 칼럼에 맞춰 순서대로 작성 - 내부의 null 값은 자동 대임 (숫자만 가능)

INSERT INTO tbl_menu VALUES (null, '바나나해장국', 9500, 4, 'Y');

select * from tbl_menu;

desc tbl_menu; # descript

-- 2. NULL 값 대입 방법 and 원하는 컬럼에 정보 삽입

INSERT INTO tbl_menu(menu_name, menu_price, category_code, orderable_status)
VALUES ('초콜릿죽', 6500, 7, 'Y');

select * from tbl_menu;

-- 2. 다중 데이터 대입 방법

INSERT INTO
    tbl_menu
VALUES
    (null, '참치맛아이스크림', 1700, 12, 'Y'),
    (null, '멸치맛아이스크림', 1500, 11, 'Y'),
    (null, '소시지맛커피', 2500, 8, 'Y');

select * from tbl_menu;

-- ================================
-- update : 기존 행의 컬럼 값 수정, 바꾸고 싶은 컬럼 값이 존재하는 행을 잘 찾아야함
/*
update 테이블명 set column명 = 값, column명 = 값, column명 = 값, column명 = 값, ... where 조건

 */

select
    *
from
    tbl_menu;

## 19번 가격 1,000원 인상

update
    tbl_menu
set
    menu_price = menu_price + 1000 # 업데이트 내에선 대입 연산으로 작용
where
    menu_code = 19;

select *
from tbl_menu;

## 한식 가격 모두 인상

update
    tbl_menu
set
    menu_price = menu_price + 500 # 업데이트 내에선 대입 연산으로 작용
where
    category_code = (
        select
            category_code
        from
            tbl_category
        where
            category_name = '한식'
        );

select *
from tbl_menu;

-- ==============================================
-- delete : 지정된 행 삭제
/*
delete
from 테이블명
where 조건
*/

delete
from tbl_menu
where menu_code = 27;

select *
from tbl_menu;

delete
from tbl_menu
where menu_code > 21;

select *
from tbl_menu;


-- =====================================
-- replace : insert + update (upsert)
-- 새로운 데이터를 테이블에 삽입할 때 식별자(pk) 컬럼 값이 중복이 없을 경우 insert, 있을 경우 update

/*
 REPLACE INTO 테이블명
 VALUES (입력 데이터1, 입력 데이터2, ...)
 */

replace into tbl_menu
values (100, '참기름커피', 3000, 8, 'Y');

select * from tbl_menu;

replace into tbl_menu
values (100, '소주맛커피', 5000, 8, 'Y');

select * from tbl_menu;

-- ===================================================================================================

