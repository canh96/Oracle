--
-- 오라클 12버전 이상부터는 아래를 실행해야 
-- 일반적인 구분 작성이 가능함
--Alter session set "_ORACLE_SCRIPT"=true;
--
---- 위에 실행은 최초 한번 실행
---- 위에 실행 안하면 아래처럼 구문을 작성해야함
--Create User c##buasn_06 Identified by dbdb;
--
---- 1. 사용자 생성하기
--Create User busan_06
--    Identified By dbdb;
--
---- 패스워드 수정하기
--Alter User busan_06
--    Identified By 수정패스워드;
--    
---- 사용자 삭제하기
--Drop User busan_06;
--    
---- 2. 권한부여하기
--Grant Connect, Resource, DBA To busan_06;
--
---- 권한 회수하기
--Revoke DBA From busan_06;

--
CREATE TABLE  lprod (
lprod_id   number(5) NOT NULL,           -- 상품분류코드
lprod_gu  char(4)     NOT NULL,            -- 상품분류
lprod_nm  varchar2(40) NOT NULL,        -- 상품분류명 
Constraint pk_lprod Primary Key (lprod_gu)
);

Select *
From lprod;

INSERT INTO lprod (lprod_id, lprod_gu,lprod_nm)
VALUES (1, 'P101', '컴퓨터제품') ;
INSERT INTO lprod (lprod_id, lprod_gu,lprod_nm)
VALUES (1, 'P102', '컴퓨터제품') ;

select lprod_gu, lprod_nm
From lprod;

commit;
rollback;

-- 회원정보 테이블
Select *
From member;

--주문내역관리 테이블
Select *
From cart;

--상품정보 테이블
Select *
From prod;

-- 상품분류정보 테이블
Select *
From lprod;

-- 거래처정보 테이블
Select *
From buyer;

-- 입고상품정보(재고) 테이블
Select *
From buyprod;

--회원테이블에서 회원아이디, 회원이름 조회하기..
Select mem_id, mem_name
From member;

--상품코드와 상품명 조회하기..
Select prod_id, prod_name
From prod;

-- 상품코드, 상품명, 판매금액 조회하기
-- 단, 판매금액=판매가 * 55 로 계산해서 조회합니다.
-- 판매금액이 4백만 이상인 데이터만 조회하기...
-- 정렬은 판매금액을 기준으로 내림차순
-- select > from 테이블 > where > 컬럼조회 > order by
Select prod_id, prod_name,
        (prod_sale * 55) as sale
From prod
Where (prod_sale * 55) >= 4000000
Order By sale Desc;

-- 상품정보에서 거채처코드(공급업체)를 조회해 주세요...
-- 단, 중복을 제거하고 조회해주세요..
Select Distinct prod_buyer
From prod;

-- 상품중에 판매가격이 17만원인 상품 조회하기..
Select prod_id, prod_sale
From prod
Where prod_sale = 170000;

-- 상품중에 판매가격이 17만원이 아닌 상품 조회하기..
Select prod_id, prod_sale
From prod
Where prod_sale != 170000;

-- 상품중에 판매가격이 17만원 이상이고 20만원 이하인 상품 조회하기..
Select prod_id, prod_sale
From prod
Where prod_sale >= 170000
  And prod_sale <= 200000;

-- 상품중에 판매가격이 17만원 이상 또는 20만원 이하인 상품 조회하기..
Select prod_id, prod_sale
From prod
Where prod_sale >= 170000
  or prod_sale <= 200000;

-- 상품 판매가격이 10만원 이상 이고,,
-- 상품 거래처(공급업체) 코드가 P30203 또는 P10201 인 
-- 상품코드, 판매가격, 공급업체 코드 조회하기...
Select prod_id, prod_sale, prod_buyer
From prod
Where prod_sale >= 100000
  And (prod_buyer = 'P30203'
        Or prod_buyer = 'P10201');

Select prod_id, prod_sale, prod_buyer
From prod
Where prod_sale >= 100000
  And prod_buyer not in ('P30203', 'P10201');


Select Distinct prod_buyer
From prod
Order by prod_buyer Asc;

Select *
From buyer
Where buyer_id Not In (Select Distinct prod_buyer
                    From prod);

--한번도 주문한 적이 없는 회원 아이디, 이름을 조회해 주세요..
Select mem_id, mem_name
From member
Where mem_id Not In (Select Distinct cart_member 
                        From cart);

-- 상품분류 중에 상품정보에 없는 분류코드만 조회해 주세요..
Select lprod_gu
From lprod
Where lprod_gu Not In (Select Distinct prod_lgu
                    From prod);

-- 회원의 생일 중에 75년생이 아닌 회원아이디, 생일 조회하기..
-- 정렬은 생일 기준 내림차순
Select * from member
Where mem_bir Not Between '1975-01-01' And '1975-12-31';

-- 회원 아이디가 a001인 회원이 주문한 상품코드를 조회해 주세요..
-- 조회컬럼은 회원아이디, 상품코드
Select Distinct cart_member, cart_prod
From cart
Where cart_member = 'a001'; 

Select Distinct cart_member, cart_prod
From cart
Where cart_member In (Select mem_id 
                       From member 
                       Where mem_id = 'a001')












