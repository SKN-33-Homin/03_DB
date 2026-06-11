# 그룹 함수 : 그룹의 통계를 반환하는 함수
# sum(), avg(), max(), min(), count()

# sum(column 명) - NULL(빈 칸)은 계산에서 제외

select
    sum(menu_price)
from
    tbl_menu;

select
    avg(menu_price)
from
    tbl_menu
# 카테고리 가격 10
where
    category_code = 10;

select
    max(menu_price) 최댓값,
    min(menu_price) 최솟값
from
    tbl_menu;

# select 1 + NULL; # NULL은 더할 수 없음(NULL != 0)

# 합계, 평균 : 숫자 데이터에서만 적용 가능
# 최대, 최소 : 위의 자료형 외에도 문자(아스키), 날짜(00000000~99999999) 적용 가능

select
    max(menu_name), min(menu_name)
from
    tbl_menu

# count(* | column 명) : 행의 개수
# count(*) : 모든 행(시작과 끝, NULL 포함)
# count(column) : 해당 열의 NULL을 제외한 행의 개수

select
    count(*),
    count(ref_category_code)
from
    tbl_category;

-- ==================================================
-- group by : 지정된 컬럼 값이 일치하는 행을 그룹화

select
    category_code,
    count(*), # 각 그룹 별 행의 개수
    sum(menu_price) # 각 그룹별 연산
from
    tbl_menu
group by
    category_code; # 각 그룹끼리 묶음

select
    ref_category_code
    # category_menu : 그룹화 되지 않은 컬럼은 오류
from
    tbl_category
group by
    ref_category_code; # NULL 또한 하나의 그룹으로 묶임

select
    category_code,
    orderable_status,
    count(orderable_status)
from
    tbl_menu
group by
    category_code,
    orderable_status # 그룹 내 하위 그룹 생성
order by
    category_code asc;

-- ============================
-- where + group by : 필터링 후 True 행들 그룹화

## 메뉴 테이블 내 카테고리별 개수, 합계
## 메뉴 가격 10,000원 이상인 메뉴만

select
    category_code,
    sum(menu_price),
    count(*)
from
    tbl_menu
where
    menu_price >= 10000
group by
    category_code;

# 메뉴 테이블에서 주문이 가능한 메뉴 중 카테고리 코드가 4, 10인 메뉴의 카테고리 개수
select
    c.category_name
from
    tbl_menu m
oin
    tbl_category c
on
m.category_code = c.category_code
where
    m.orderable_status = 'Y'
and
    m.category_code in (4, 10)
group by
    c.category_name


-- =================================================
-- having : group by를 통해 만들어진 그룹에 대한 조건 설정
-- 작성시 항상 그룹 함수가 포함

## 메뉴 테이블에서 카테고리 별 메뉴 개수가 2개 이상인 카테고리 번호, 개수 출력

select
    category_code,
    count(*)
from
    tbl_menu
group by
    category_code
having
    count(*) != 1

## 카테고리 테이블에서 부모 카테고리(ref_...) 별로 개수가 3개 이상에서 번호, 개수, 번호 오름차순

select
    ref_category_code,
    count(*)
from
    tbl_category
group by
    ref_category_code
having
    count(*) > 2
order by
    ref_category_code asc




select
    ref_category_code,
    count(*)
from
    tbl_category
group by
    ref_category_code
having
    count(*) > 2
and
    ref_category_code is not NULL
order by
    ref_category_code asc
limit
    1;

-- =====================================================
-- build in fuction
-- =====================================================



