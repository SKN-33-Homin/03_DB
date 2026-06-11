-- =====================================================
-- build in function(외장 함수)
-- =====================================================

select ASCII('A'), char(97); # ASCII 코드 이용

select bit_length(123), char_length(123), length('ㄱ'), length('기'), length('김'), length(13); # 길이 반환

select
    menu_name,
    char_length(menu_name),
    length(menu_name), # 영어는 1byte, 한글은 3byte : 컴퓨터에서 표시하는 방법 중 한글은 자음, 모음, 받침 사용
                       # UTF-8 : 모든 문자를 1byte(8bit)로 표시
    bit_length(menu_name)
from
    tbl_menu;


# INSTR : 기존 문자열에서 부분 문자열의 시작 위치 검색

select  instr('사과딸기바나나', '딸기'); # 위치 반환 (첫 순서 1)
select  instr('사과딸기바나나', '포도'); # 없을 경우 0으로 반환

# 메뉴 테이블에서 메뉴명에 마늘이 포함된 것 찾기
select
    *
from
    tbl_menu
where
    menu_name like '%마늘%';

select
    *
from
    tbl_menu
where
    instr(menu_name, '마늘'); # > 0;


/*
LPAD: 문자열을 길이만큼 왼쪽으로 늘린 후에 빈 곳을 문자열로 채운다.
RPAD: 문자열을 길이만큼 오른쪽으로 늘린 후에 빈 곳을 문자열로 채운다.
*/

SELECT LPAD('왼쪽', 6, '@'), RPAD('오른쪽', 6 ,'@');

select
    substring('안녕하세요 반갑습니다.', 7, 2),
    substring('안녕하세요 반갑습니다.', 7),
    substring('안녕하세요 반갑습니다.', instr('안녕하세요 반갑습니다.', '반갑'));

/*
CEILING(숫자), FLOOR(숫자), ROUND(숫자)
CEILING: 올림값 반환
FLOOR: 내림값 반환
ROUND: 반올림값 반환
TRUNCATE(number, n) : n번째 버림값 반환
 */

SELECT CEILING(1234.56), FLOOR(1234.56), ROUND(1234.56), truncate(1234.56, 0);

select
    ceiling(-1.5),
    FLOOR(-1.5),
    ROUND(-1.5),
    truncate(-1.5, 0);

select
    truncate(1234.56, 1), # 1234.5
    truncate(1234.56, 0), # 1234
    truncate(1234.56, -1); # 1230

select
    rand(), # 0 ~ 0.999...
    rand(),
    rand(),
    rand();

select
   ceiling( rand() * 45 + 1),
   ceiling( rand() * 45 + 1),
   ceiling( rand() * 45 + 1),
   ceiling( rand() * 45 + 1),
   ceiling( rand() * 45 + 1),
   ceiling( rand() * 45 + 1);

-- =================================================
# 날짜 관련 함수

/*
NOW(): 현재 날짜
ADDDATE(date, 일수): 날짜를 기준으로 차이를 더함
SUBDATE(date, 일수): 날짜를 기준으로 날짜를 뺌
 */

select
    now(),
    adddate(now(), 1),
    subdate(now(), 1),
    adddate(now(), INTERVAL 1 MONTH),
    subdate(now(), INTERVAL 1 MONTH);

select DATEDIFF('2026-11-20', now());
SELECT ADDDATE('2023-05-31', INTERVAL 30 DAY), ADDDATE('2023-05-31', INTERVAL 6 MONTH);
SELECT SUBDATE('2023-05-31', INTERVAL 30 DAY), SUBDATE('2023-05-31', INTERVAL 6 MONTH);

-- ====================
-- extract : date에서 해당 단위 추춯
-- year, quarter, month, week, day, hour, minute, second

select
    now(),
    extract(year from now()),
    extract(month from now()),
    extract(week from now());

select str_to_date('21/02/25', '%y/%m/%d');

# date_format(datetime, 형식문자열) -> 문자열
select
    date_format(now(), '%y/%m/%d'),
    date_format(now(), '%Y/%m/%d'),
    date_format(now(), '%h:%i');

# str_to_date(문자열, 형식문자열) -> datetime
select
    str_to_date('25/04/21', '%y/%m/%d'),
    str_to_date('2025/04/21', '%Y/%m/%d'),
    cast('2025/04/21' as date); -- 날짜시간형식 유추가 가능한 경우

# 기타함수
# null처리 함수 - ifnull(값, null일때 값)
select
    ifnull(ref_category_code, '미지정') ref_category_code
from
    tbl_category;

# 삼항연산처리 - if(조건식, 참일때 값, 거짓일때 값)
select
    isnull(category_code),
    if(isnull(category_code), '미지정', category_code) category_code
from
    tbl_menu;

select
    menu_name,
    menu_price,
    if(menu_price < 10000, '싼', '비싼') price_clf
from
    tbl_menu;


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
UNION #########################################################
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