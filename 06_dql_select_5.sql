## set operators
# 두개 이상의 select를 결합

SELECT menu_code,
       menu_name,
       menu_price,
       category_code,
       orderable_status
FROM tbl_menu
WHERE category_code = 10
UNION #####################3 합집합
SELECT menu_code,
       menu_name,
       menu_price,
       category_code,
       orderable_status
FROM tbl_menu
WHERE menu_price < 9000;

SELECT
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    category_code = 10
intersect  ########### 교집합
SELECT
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    menu_price < 9000;

SELECT
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    category_code = 10
union all ############### 중복 모두 유지
SELECT
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    menu_price < 9000;

# MINUS : 차집합 == 교집합제거

SELECT
    a.menu_code,
    a.menu_name,
    a.menu_price,
    a.category_code,
    a.orderable_status
FROM
    tbl_menu a
LEFT JOIN (SELECT # 1, 2, 3, 4, 10, 12, 13, 17, 21)
		menu_code,
		menu_name,
		menu_price,
		category_code,
		orderable_status
	FROM
		tbl_menu
	WHERE
		menu_price < 9000) b on (a.menu_code = b.menu_code)
WHERE
    a.category_code = 10 AND
    b.menu_code IS NULL;

# SUBQUERY
-- 1. 일반
-- 2. 상관
-- 3. 인라인뷰(파생)

select category_code
from tbl_menu
where menu_name = '민트미역국'; # 4번

# 메뉴 카테고리가 4번인 메뉴
select *
from tbl_menu
where category_code = 4;


# subquery 이용
# 민트 미역국과 같은 카테고리 메뉴 조회


select
    category_code
from
    tbl_menu
where category_code =
      (select
           *
       from
           tbl_menu
       where
           category_code = 4); # 서브 쿼리

# 메뉴 테이블 '민트미역국' 보다 비싼 메뉴
select
    menu_name
from
    tbl_menu
where menu_price >
      (select
           menu_price
       from
           tbl_menu
       where
           menu_name = '민트미역국') # 서브 쿼리
order by
    menu_price desc;


# 다중행 단일열 서브쿼리
# -> 여러개의 값을 반환

# tbl_category에서 ref_... 값이 1인 카테고리 코드를 찾아
# 메뉴테이블에서 같은 카테고리의 메뉴를 모두 조회

select
    menu_name,
    category_code
from
    tbl_menu
where
    category_code in
    (
        select
            category_code
        from
            tbl_category
        where
            ref_category_code = 1
        );

/*
4번 카테고리 메뉴 중 가장 비싸메뉴
*/


# 2. tbl_menu : 카테고리 코드별 가장 비싼 메뉴
select
    *
from
    tbl_menu main
where
    menu_price in (
        select
            max(menu_price)
        from
            tbl_menu sub
        group by
            category_code
        )
order by
    category_code asc;

select
    *
from
    tbl_menu main
where
    menu_price in (
        select
            max(menu_price)
        from
            tbl_menu sub
        where
            sub.category_code = main.category_code
        )
order by
    category_code asc;

select
    *
from
    tbl_menu main
where
    menu_price >
        (select
            avg(menu_price)
        from
            tbl_menu sub
        where
            sub.category_code = main.category_code
        )
order by
    category_code asc;

# 스칼라 서브 쿼리 : select에서 사용하는 결과 값이 1개인 서브 쿼리

select
    menu_name,
    category_code,
    (select category_name
     from tbl_category c
     where m.category_code = c.category_code) category_name
from
    tbl_menu m;

# from 에 작성된 서브쿼리 (INLINE VIEW) : 서브쿼리 결과 집합을 테이블 처럼 사용

select
    *
from(
    select
        m.menu_code,
        m.menu_name,
        c.category_name

    from
        tbl_menu m
    join
        tbl_category c
on
            m.category_code = c.category_code
    ) as joined
where
    category_name = '한식';

select
    *
from(
    select
        m.menu_code as 메뉴코드,
        m.menu_name as 메뉴명,
        c.category_name as 카테고리명 # 별칭 사용 시 메인 쿼리에서 기존 이름을 인식 할 수 없음, 대신 별칭으로 변경해서 사용 가능
    from
        tbl_menu m
    join
        tbl_category c
on
            m.category_code = c.category_code
    ) as joined
where
    카테고리명 = '한식';

-- =================================================================================
-- CTE (Common Table Expression) : 인라인 뷰로 사용할 서브쿼리를 별도의 테이블 변수에 저장하고, 사용할 수 있게 함
/* 작성법
   with 변수명 as (서브 쿼리)
   select *
   from 변수명
 */
with menu_view as (
    select
        m.menu_code as 메뉴코드,
        m.menu_name as 메뉴명,
        c.category_name as 카테고리명 # 별칭 사용 시 메인 쿼리에서 기존 이름을 인식 할 수 없음, 대신 별칭으로 변경해서 사용 가능
    from
        tbl_menu m
    join
        tbl_category c
on
            m.category_code = c.category_code
    )
select
    *
from
    menu_view
where
    카테고리명 = '한식';