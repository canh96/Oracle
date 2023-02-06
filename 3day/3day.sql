--3day
--[조회 방법 정리]
-- 상품분류 중에 '전자'가 포함된 상품을 구매한 회원 조회하기
-- 회원아이디, 회원이름 조회하기.
-- 단, 상품명에 삼성전자가 포함된 상품을 구매한 회원...
--     그리고, 회원의 취미가 수영인 회원..

-- 1. 테이블 찾기
--   - 제시된 컬럼들의 소속 찾기
--   - lprod, cart, member, prod 

-- 2. 테이블 간의 관계 찾기
--   - ERD에서 연결된 순서대로 PK와 FK컬럼 또는,
--   - 성격이 같은 값으로 연결할 수 있는 컬럼 찾기
--   - lprod_gu = prod_lgu
--   - prod_id = cart_prod
--   - cart_member = mem_id

-- 3. 작성 순서 정하기
--   - 조회하는 컬럼이 속한 테이블이 가장 밖..1순위..
--   - 1순위 테이블부터 ERD 순서대로 작성..
--   - 조건은 : 해당 컬럼이 속한 테이블에서 조건 처리..

--member > cart > prod > lprod

Select mem_id, mem_name
From member
Where mem_like = '수영'
  And mem_id In (
    Select cart_member
    From cart
    Where cart_prod In (
        Select prod_id
        From prod
        Where prod_name Like '%삼성전자%'
          And prod_lgu In (
            Select lprod_gu
            From lprod
            Where lprod_nm Like '%전자%')));






-- [문제]
-- 김형모 회원이 구매한 상품에 대한 
-- 거래처 정보를 확인하려고 합니다.
-- 거래처코드, 거래처명, 지역(서울 or 인천...), 거래처 전화번호 조회
-- 단, 상품분류명 중에 캐주얼 단어가 포함된 제품에 대해서만...
-- 1. mnember, cart, buyer, lprod, prod
-- 2, mem_id = cart_member
--    cart_prod = prod_id
--    prod_buyer = buyer_id
--    prod_lgu = lprod_gu
-- 3. 
Select buyer_id, buyer_name, substr(buyer_add1, 1, 2) as addr1,
        buyer_comtel
From buyer
Where buyer_id In (
    Select prod_buyer
    From prod
    Where prod_lgu In (
        Select lprod_gu
        From lprod
        Where lprod_nm Like '%캐주얼%')
      And prod_id In (
        Select cart_prod
        From cart
        Where cart_member In (
            Select mem_id
            From member
            Where mem_name = '김형모')));


-- 여자인 회원이 구매한 상품 중에
-- 상품분류에 전자가 포함되어 있고,
-- 거래처의 지역이 서울인 
-- 상품코드, 상품명 조회하기..
--1. member, cart, lprod, buyer, prod
--2, mem_id = cart_member
--   cart_prod = prod_id
--   prod_lgu = lprod_gu
--   prod_buyer = buyer_id
--3. prod > cart > member
--   prod > lprod
--   prod > buyer
Select prod_id, prod_name
From prod
Where prod_id In (
    Select cart_prod
    From cart
    Where cart_member In (
        Select mem_id
        From member
        Where Mod(Substr(mem_regno2, 1, 1), 2)=0))
  And prod_lgu In (
    Select lprod_gu
    From lprod
    Where lprod_nm Like '%전자%')
  And prod_buyer In (
    Select buyer_id
    From buyer
    Where Substr(buyer_add1, 1, 2)='서울');



-- 상품코드별 구매수량에 대한 최대값, 최소값, 평균값, 합계, 갯수 조회하기.
-- 조회컬럼 상품코드, 최대값, 최소값, 평균값, 합계, 갯수
-- 1. cart
-- <Group 조건 >
-- 집계함수와 일반컬럼(함수를 사용한 컬럼 포함)이 동시에 사용된 경우에는
-- 무조건 일반컬럼은 Group By절에 넣어주어야 합니다.
Select cart_prod, Max(cart_qty) as mqty,
        Min(cart_qty) as mqty, Round(Avg(cart_qty), 2) as aqty,
        Sum(cart_qty) as sqty, Count(cart_qty) as cqty
From cart
Group By cart_prod;

Select * 
From cart;

Select * 
From lprod;


--오늘이 2005년도7월11일이라 가정하고 장바구니테이블에 발생될 
--  추가주문번호를 검색 하시오 ? 
-- 조회 컬럼 : 현재 마지막 주문번호, 추가주문번호
--1. cart
select Max(cart_no) as mno, Max(cart_no)+1 as mpno
From cart
Where Substr(cart_no, 1, 8) = '20050711';

-- 회원테이블의 회원전체의 마일리지 평균, 마일리지 합계,
-- 최고 마일리지, 최소 마일리지,인원수를 검색하시오 ? 
Select Round(Avg(mem_mileage), 2) as am, Sum(mem_mileage) as sm,
        Max(mem_mileage) as mm, Min(mem_mileage) as mim,
        Count(mem_mileage) as cm
From member;

-- [문제]
-- 상품테이블에서 거래처코드별, 상품분류코드별로,
-- 판매가에 대한 최고, 최소, 자료수, 평균, 합계를 조회해 주세요..
-- 정렬은 자료수를 기준으로 내림차순
-- 추가로, 거래처명, 상품분류명도 조회..
-- 단 합계가 100 이상인 것
--1, prod
Select prod_buyer, prod_lgu,
        Max(prod_sale) as ms, Min(prod_sale) as mis,
       Count(prod_sale) as cs, Avg(prod_sale) as asl,
       Sum(prod_sale) sum_s,
       (Select Distinct buyer_name
        From buyer
        Where buyer_id = prod_buyer) as bname,
       (Select Distinct lprod_nm
        From lprod
        Where lprod_gu = prod_lgu) as bname
From prod
Group By prod_buyer, prod_lgu
Having Sum(prod_sale) >= 100
Order By cs Desc;




UPDATE buyer SET buyer_charger = NULL
WHERE buyer_charger LIKE '김%';

UPDATE buyer SET buyer_charger = ''
WHERE buyer_charger LIKE '성%';

Select buyer_charger
From buyer
Where buyer_charger is Null;

SELECT buyer_name, 
      NVL(buyer_charger, '없다') as charger
FROM buyer;

    
SELECT prod_lgu,
        DECODE( SUBSTR(prod_lgu, 1,2),  
                  'P1', '컴퓨터/전자 제품', 
                  'P2' , '의류', 
                  'P3' ,'잡화',   
                  '기타' ) as lgu_nm
FROM prod;



SELECT prod_id, prod_name, prod_lgu
FROM prod
WHERE EXISTS ( 
    SELECT *
    FROM lprod
    WHERE lprod_gu = prod_lgu);

SELECT  *  FROM lprod, prod;
SELECT  *  FROM lprod CROSS JOIN prod;

-- Inner Join 조건
-- PK와 FK가 있어야 합니다.
-- 관계조건 성립 : PK = FK
-- 관계조건의 갯수 : From절에 제시된 (테이블의 갯수 - 1개)

--상품테이블에서 상품코드, 상품명, 분류명을 조회.
-- 1. prod, lprod
-- 2. 1prod_lgu = lprod_gu
-- 3. lprod > prod
-- <일반방식>
Select prod_id, prod_name, lprod_nm, buyer_name, cart_qty, mem_name
From lprod, prod, buyer, cart, member
--관계조건식
Where lprod_gu = prod_lgu
  And buyer_id = prod_buyer
  And prod_id = cart_prod
  And mem_id = cart_member
  And mem_id = 'a001';

-- <표준방식>
Select prod_id, prod_name, lprod_nm, buyer_name, cart_qty, mem_name
From lprod Inner Join prod
            On(lprod_gu = prod_lgu)
           Inner Join buyer
            On(buyer_id = prod_buyer)
           Inner Join cart
            On(prod_id = cart_prod)
           Inner Join member
            On(mem_id = cart_member
               And mem_id = 'a001');
               
--상품테이블에서 상품코드, 상품명, 분류명, 거래처명,
--거래처주소를 조회.
--1) 판매가격이 10만원 이하 이고
--2) 거래처 주소가  부산인 경우만 조회
-- 일반방식, 표준방식..모두 해보기..

--1.테이블 찾기.
--  prod, lprod, buyer
--2.관계조건식 찾기
--  prod_lgu = lprod_gu
--  prod_buyer = buyer_id
--3.순서 정하기..

Select prod_id, prod_name, lprod_nm, buyer_name
From prod, lprod, buyer
Where prod_lgu = lprod_gu
  And prod_buyer = buyer_id
  And prod_sale <= 100000
  And buyer_add1 Like '부산%';

Select prod_id, prod_name, lprod_nm, buyer_name
From prod Inner Join lprod
            On(prod_lgu = lprod_gu
               And prod_sale <= 100000)
          Inner Join buyer
            On(prod_buyer = buyer_id
            And buyer_add1 Like '부산%');

--[문제]
--상품분류명, 상품명, 상품색상, 매입수량, 주문수량, 거래처명을 조회
-- 단, 상품분류 코드가 P101, P201, P301인 것
--     매입수량이 15개 이상인 것
--     서울에 살고 있는 회원 중에 생일이 1974년생인 회원
-- 정렬은 회원아이디 기준 내림차순, 매입수량 기준 오름차순
-- 일반방식, 표준방식..

--팀별로 3문제 만들기
--문제.txt와 정답.txt 각각 파일로 저장
--구글드라이브 > 강의안 > oracle > 
--          "문제제출" 폴더에 [문제.txt] 파일만 제출













