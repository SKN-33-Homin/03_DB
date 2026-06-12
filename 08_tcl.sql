-- TCL
-- 트랜젝션 제어언어 : COMMIT, ROLLBACK, SAVEPOINT 등

# 트랜젝션 : 한번에 수행 될 DML 논리적 작업 단위
-- 하나의 트랜젝션을 이용해서 관련 작업을 한번에 완료 또는 취소 할 수 있게 하기 위해 사용

# 원자성
-- 원자성은 트랜잭션에 포함된 작업이 전부 성공하거나 전부 실패해야 한다는 원칙이다.
-- 예를 들어 계좌이체는 다음 두 작업이 함께 처리되어야 한다.
-- 즉, 원자성은 All or Nothing 원칙이다.

set autocommit  = on;
set autocommit  = off;

# commit : DML로 인한 변경 사항(Transaction)을 DB에 반영
# rollback : DML로 인한 변경 사항(Transaction)을 취소

# 트랜젝션 시작 : 이후 DML 변경 사항을 저장
start transaction; # 시작, 종료는 COMMIT 또는 ROLLBACK, AUTOCOMMIT이 활성화 상태에서도 사용 가능

select *
from tbl_menu
where menu_code = 21;

# 판매 가능 여부 'Y' -> 'N'

update tbl_menu set orderable_status = 'N' where menu_code = 21;

# copmmit 전 수정 내용을 select 시 반영 된 거 처럼 보이는 이유 - 반영 전이지만 Transaction을 보여줌
select *
from tbl_menu
where menu_code = 21;

rollback; #변경 취소

select *
from tbl_menu
where menu_code = 21;

delete
from tbl_menu
where menu_code = 20;

insert into tbl_menu values (null, '테스트', 3000, 5, 'N');

select *
from tbl_menu;

rollback; #변경 취소

select *
from tbl_menu;

delete
from tbl_menu
where menu_code = 100;

commit;

select *
from tbl_menu;

rollback; #변경 취소

select *
from tbl_menu;

-- ========================================== 일관성
-- 일관성은 트랜잭션 실행 전과 실행 후에 데이터베이스가 정해진 규칙을 만족하는 상태를 유지해야 한다는 원칙이다.
-- 예를 들어 다음과 같은 규칙이 있다고 가정할 수 있다.
-- 즉, 일관성은 정상 상태에서 정상 상태로 이동해야 한다는 의미이다.

-- ======================================= 격리성
-- 격리성은 여러 트랜잭션이 동시에 실행되더라도 각각의 트랜잭션이 서로에게 부정확한 영향을 주지 않도록 보장하는 원칙이다.
-- 예를 들어 두 사용자가 동시에 같은 상품의 재고를 수정한다면, 한쪽의 작업이 다른 쪽 작업에 잘못 섞이지 않도록 제어해야 한다.
-- 데이터베이스는 이를 위해 잠금, MVCC, 트랜잭션 격리 수준 등을 사용한다.
-- MySQL의 기본 트랜잭션 격리 수준은 일반적으로 **REPEATABLE READ**이다.
-- 현재 격리 수준은  `SELECT @@transaction_isolation;` 확인할 수 있다.
-- 즉, 격리성은 동시에 실행되는 트랜잭션들이 서로 충돌하지 않도록 제어하는 성질이다.

-- ======================================= 지속성
-- 지속성은 트랜잭션이 COMMIT 된 후에는 그 결과가 데이터베이스에 영구적으로 반영되어야 한다는 원칙이다.
-- COMMIT 이후에는 데이터베이스 서버가 재시작되거나 장애가 발생하더라도 완료된 트랜잭션의 결과는 보존되어야 한다.
-- 데이터베이스는 이를 위해 로그 파일 등을 사용하여 장애 발생 시 데이터를 복구할 수 있도록 한다.
-- `즉, 지속성은 **한 번 확정된 데이터는 사라지지 않아야 한다**는 의미이다.`











