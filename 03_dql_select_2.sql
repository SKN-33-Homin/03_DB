-- =============================
-- JOIN
-- =============================
-- 두개 이상의 테이블의 레코드를 연결해서 가상테이블(relation) 생성
-- 연관성을 가지고 있는 컬럼을 기준(데이터)으로 조합

# relation을 생성하는 2가지 방법
-- 1. join : 특정컬럼 기준으로 행과 행을 연결한다. (가로)
-- 2. union : 컬럼과 컬럼을 연결한다.(세로)
-- join은 두 테이블의 행사이의 공통된 데이터를 기준으로 **선을 연결해서** 새로운 하나의 행을 만든다.

# JOIN 구분
-- 1. Equi JOIN : 일반적으로 사용하는 Equality Condition(=)에 의한 조인
-- 2. Non-Equi JOIN : 동등조건(=)이 아닌 BETWEEN AND, IS NULL, IS NOT NULL, IN, NOT IN, !=  등으로 사용.

# EQUI JOIN 구분
-- 1. INNER JOIN(내부 조인) : 교집합 (일반적으로 사용하는 JOIN)
-- 2. OUTER JOIN(외부 조인) : 합집합
        -- LEFT (OUTER) JOIN (왼쪽 외부 조인)
        -- RIGHT (OUTER) JOIN (오른쪽 외부 조인)
-- 3. CROSS JOIN
-- 4. SELF JOIN(자가 조인)
-- 5. MULTIPLE JOIN(다중 조인)

-- =========
# inner join
-- 교집합 반환 : 특정 컴럼값이 같은 행만 join

# tbl_menu, tbl_category join
# join 조건 : 카테고리 값이 같은 행끼리 join

select
    *
from
    tbl_menu a # 별칭 a
inner join
    tbl_category b
on
    a.category_code = b.category_code;

# 메뉴명, 가격, 카테고리 테이블 내림차순
select
    b.menu_name,
    b.menu_price,
    a.category_name
from
    tbl_category a
join
    tbl_menu b
on a.category_code = b.category_code
order by
    a.category_code desc;

-- ===========================================================
-- OUTER JOIN : 좌|우측 기준 모든 행을 relation에 포함

# left (outer) join

insert into tbl_menu(menu_name, menu_price, category_code, orderable_status)
values('초콜릿 덮밥', 10000, 7, 'Y');

commit;

select *
from tbl_menu;


select
    EMP_NAME,
    ENT_DATE,
    EMP_ID,
    EMAIL
from
    employee;


select
    *
from
    employee a
join
    department b
on
    a.DEPT_CODE = b.DEPT_ID
order by
    a.EMP_ID asc;

# inner join : Employee(23행), Department(9행) - > 결과(21행) : 내부 값이 null일 경우 join 결과에서 제외된다.


# left (outer) join : left에 작성된 모든 행이 relation으로 연결, 빈 칸은 NULL로 표시,
# 남는 행은 마지막에 추가(inner join 결과 + 사용되지 않은 행)


select
    *
from
    employee a
left join
    department b
on
    a.DEPT_CODE = b.DEPT_ID;

select
    *
from
    employee a
right join
    department b
on
    a.DEPT_CODE = b.DEPT_ID;


git init
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/SKN-33-Homin/03_DB.git
git push -u origin main