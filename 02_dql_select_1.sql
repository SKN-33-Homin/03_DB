/*
SQL (Structured Query Language)
- 구조화(조건) 된 질의 언어
- RDBMS에서 저장된 데이터를 관리, 조작하거나 DB 구조를 제어할 때 사용하는 언어

## SQL 종류
- DQL(Data Query Language)          : 데이터 질의어, 검색/조회, SELECT
- DML(Data Manipulation Language)   : 데이터 조작어, 삽입/수정/삭제, INSERT, UPDATE, DELETE
- DDL(Data Definition Language)     : 데이터 정의어
- DCL(Data Control Language)        : 데이터 제어어
- TCL(Transaction Control Language) : 트랜젝션 제어어
 */

-- ================================================================================================================

# DQL구조
/*
    * select 컬럼명 (5)  -- 필수
    * from 테이블 (1)  -- 필수
    - where 조건절(필터링) (2)
    - group by 그룹핑 (3)
    - having 조건절(그룹핑에 대해 필터링) (4)
    order by 정렬기준 (6)
    limit 행수제한 (7)

    1. SELECT : 조회하고자 하는 컬럼명을 기술함. 여러개를 기술하고자 하면 쉼표(,)로 구분하고 모든 컬럼 조회시 '*'을 사용
    2. FROM : 조회 대상 컬럼이 포함된 테이블명을 기술
    3. WHERE :
        행을 선택하는 조건을 기술함.
        여러 개의 제한 조건을 포함할 수 있으며, 각각의 제한 조건은 논리 연산자로 연결함
        제한조건을 만족시키는 행들만 Result Set에 포함됨
    4. ORDER BY : 정렬할 컬럼을 기준으로 오름/내림차순 지정
    5. GROUP BY : 행을 그룹핑함
    6. HAVING : 그룹핑된 행을 선택하는 조건을 기술함
*/

# tbl_menu의 모든(*) column(열) 조회

select
    menu_price, menu_name
from
    tbl_menu;

#연산 기능 사용
# 메뉴명, 가격, 부가세(10%), 부가세 포함 전체 가격

select
    menu_name,
    menu_price,
    menu_price * 0.1,
    menu_price + (menu_price * 0.1)
from
    tbl_menu;

-- ===============
-- ResultSet : SELECT 조회 결과 행의 집합

# column 명 변경 : column명 as 별칭 : ResultSet의 컬럼명 별칭

select
    menu_name as 메뉴명,
    menu_price as '메뉴 가격',
    menu_price * 0.1 부가세, # as 생략 가능
    menu_price + (menu_price * 0.1) "총 금액"
from
    tbl_menu;

## 산술 연산

select
    1 + 2,
    2 * 3,
    4/3,
    4-1,
    4 div 3, # //
    4 mod 3; # %

# 문자열 연결(이어쓰기) : 산술 연산은 숫자 또는 날짜

select
    menu_name as 메뉴명,
    concat(menu_price, '원') as '메뉴 가격(원)',
    concat(menu_name, ' : ', menu_price, '원') as '메뉴명 : 메뉴 가격(원)'
from
    tbl_menu;

# 중복 제거 (DISTINCT)
# - 지정된 컬럼의 중복 값 행 제거

select
    distinct category_code
from
    tbl_menu;

-- ===============================================
# order by : 조회 결과 종렬 순서 지정, 특정 컬럼을 기준으로 오름차순(asc)|내림차순(desc), 기준이 여럿 존재할 경우 그룹 정렬 실행

# 메뉴 테이블 오름차순
select
    menu_name as 메뉴명,
    menu_price 가격
from
    tbl_menu
order by
    menu_price asc;

# 메뉴 테이블 내림차순
select
    menu_name as 메뉴명,
    menu_price 가격
from
    tbl_menu
order by
    menu_price desc;

# 정렬 - 문자열 (유니코드순), 날짜(과거 - 미래순)

# 메뉴명 오름차순
select
    menu_name as 메뉴명,
    menu_price 가격
from
    tbl_menu
order by
    메뉴명 asc;

# 메뉴명 내림차순
select
    menu_name as 메뉴명,
    menu_price 가격
from
    tbl_menu
order by
    메뉴명 desc;

# select 절에 작성되지 않은 컬럼을 정렬 기준으로 사용 가능

# price 기준 오름차순 정렬
select
    menu_name as 메뉴명
from
    tbl_menu
order by
   menu_price asc;

#price 기준 내림차순
select
    menu_name as 메뉴명
from
    tbl_menu
order by
   menu_price desc;

# 기준으로 삼은 값이 여러개일 때 자동 그룹화 정렬
# 메뉴 - 메뉴명, 가격, 카테고리 - 카테고리 오름, 가격 내림
/*
 카테고리 오름 그룹 정렬
 그룹화 코드 내에서 가격 내림 정렬
 */
select
    menu_name as 메뉴명,
    category_code as '카테고리 코드',
    menu_price as 가격
from
    tbl_menu
order by
   category_code asc,
   menu_price desc;

# WHERE 행 필터링
# - 각행별로 제시한 조건을 검사하고, TRUE인 행만 결과집합에 포함시킨다.

# WHERE 비교 연산자
-- 표현식 사이의 관계를 비교하기 위해 사용하고, 비교 결과는 논리 결과중에 하나 (TRUE/FALSE/NULL)가 됨
-- 단, 비교하는 두 컬럼 값/표현식은 서로 동일한 데이터 타입이어야 함

-- --------------------------------------------------------------------------------
-- 연산자                    설명
-- --------------------------------------------------------------------------------
-- =                        같다
-- >,<                        크다/작다
-- >=,<=                    크거나 같다/작거나 같다
-- <>,!=                    같지 않다 (^= 없음)
-- BETWEEN AND                특정 범위에 포함되는지 비교
-- LIKE / NOT LIKE            문자 패턴 비교
-- IS NULL / IS NOT NULL      NULL 여부 비교
-- IN / NOT IN                비교 값 목록에 포함/미포함 되는지 여부 비교
-- --------------------------------------------------------------------------------

# WHERE 논리 연산자
-- 여러 개의 제한 조건 결과를 하나의 논리결과로 만들어 줌 (&&,|| 사용불가)
-- AND &&    여러 조건이 동시에 TRUE일 경우에만 TRUE 값 반환
-- OR ||    여러 조건들 중에 어느 하나의 조건만 TRUE이면 TRUE값 반환
-- NOT !    조건에 대한 반대값으로 반환(NULL은 예외)
-- XOR        두 값이 같으면 거짓, 두 값이 다르면 참

# 메뉴 테이블에서 가격이 13000원 이상인 메뉴의 코드, 메뉴명, 가격 조회(내림차순)
select
    category_code 코드,
    menu_name as 메뉴명,
    menu_price as 가격
from
    tbl_menu
where
    menu_price >= 13000
order by
    menu_price desc;

#메뉴 테이블에서 코드 10인 메뉴를 코드, 이름, 가격 오름차순 조회
select
    category_code 코드,
    menu_name as 메뉴명,
    menu_price as 가격
from
    tbl_menu
where
    category_code = 10
order by
    menu_price asc;

#메뉴 테이블에서 10,000원 이상 20,000원 이하 메뉴명, 가격, 카테고리 (가격 내림차순 정렬)
select
    category_code 코드,
    menu_name as 메뉴명,
    menu_price as 가격
from
    tbl_menu
where
    # 20000 >= menu_price and 10000 <= menu_price
    menu_price between 10000 and 20000 # 이상 이하
order by
    menu_price desc;

# 반대
select
    category_code 코드,
    menu_name as 메뉴명,
    menu_price as 가격
from
    tbl_menu
where
    # 20000 < menu_price or 10000 > menu_price
    menu_price not between 10000 and 20000 # not 이상 이하 == 미만 초과
order by
    menu_price desc;

# 메뉴 테이블에서 칵테고리 코드가 4, 6, 10의 메뉴켱, 코드 오름차순

select
    category_code 코드,
    menu_name as 메뉴명
from
    tbl_menu
where
#     category_code = 4
#     or
#     category_code = 6
#     or
#     category_code = 10
    category_code in (4, 6, 10) # not in 제외
order by
    menu_price asc;

#like : 믄자열 패턴 검사 기호(와일드 카드 : %, _)사용
# % : 포함, 0개 이상
# _ : 문자 1칸

select
    menu_name as 메뉴명
from
    tbl_menu
where
    # 첫글자가 '아'으로 시작하는
    # menu_name like '아%'

    # '밥'으로 끝나는
    #  menu_name like '%밥'

    # 중간에 '마늘' 포함
    # menu_name like '%마늘%'

    # 5글자 단어
    menu_name like '_____';

-- =========================
-- NULL 여부 파악하기

# NULL : 저장된 데이터 없음

#카테고리 테이블에서 ref_category_code가 NULL인 행 조회
select
    category_code
from
    tbl_category
where
    # ref_category_code = null; null = 비어있음은 같지않음 다음 코드는 null을 찾는거
    ref_category_code is NULL; # 비어있는가 여부를 불음

-- =============================================================================
# limit : 조회 결과 중 지정된 크기 만큼의 행만 조회
# limit offset(숫자만큼 행 제외, 기본값 0),number_of_row(최대 보여줄 행 수, 기본 값 전체 행 수)

select * from tbl_menu limit 5;
select * from tbl_menu limit 1,5;
select * from tbl_menu limit 5,10;

#페이징 처리(단위별 묶음) 시 사용

# 메뉴 테이블을 이용해서 메뉴판 생성 시 4개 메뉴씩
select *
from tbl_menu
order by  menu_code desc
limit
    0, 4;

select *
from tbl_menu
order by  menu_code desc
limit
    4, 4;

select *
from tbl_menu
order by  menu_code desc
limit
    8, 4;

select *
from tbl_menu
order by  menu_code desc
limit
    12, 4;

select *
from tbl_menu
order by  menu_code desc
limit
    16, 4;

select *
from tbl_menu
order by  menu_code desc
limit
    20, 4;










