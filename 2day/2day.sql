--2day

-- 회원정보 전체 조회
Select *
From member;

-- 취미가 "수영"인 회원들 중에 
-- 마일리지의 값이 1000 이상인 
-- 회원아이디, 회원이름, 회원취미, 회원마일리지 조회
-- 정렬은 회원이름 기준 오름차순
Select mem_id, mem_name, mem_like, mem_mileage
From member
Where mem_like = '수영'
  And mem_mileage >= 1000
Order By mem_name Asc;

-- 김은대 회원과 동일한 취미를 가지는
-- 회원 아이디, 회원이름, 회원취미 조회하기...
Select mem_like
From member
Where mem_name = '김은대';

Select mem_id, mem_name, mem_like
From member
Where mem_like = (Select mem_like
                    From member
                    Where mem_name = '김은대');
                    
-- 주문내역이 있는 회원에 대한 정보를 조회하려고 합니다.
-- 회원아이디, 회원이름, 주문번호, 주문수량 조회하기
Select cart_member, cart_no, cart_qty,
        (Select mem_name 
         From member
         Where mem_id = cart_member) as name
From cart;

-- 주문내역이 있는 회원에 대한 정보를 조회하려고 합니다.
-- 회원아이디, 회원이름, 주문번호, 주문수량, 상품명 조회하기
Select cart_member, cart_no, cart_qty,
        (Select mem_name 
         From member
         Where mem_id = cart_member) as name,
         (Select prod_name
          From prod
          Where prod_id = cart_prod) as p_name
From cart;

-- a001 회원이 주문한 상품에 대한
-- 상품분류코드, 상품분류명 조회하기..
Select lprod_gu, lprod_nm
From lprod
Where lprod_gu In (Select prod_lgu
                    From prod
                    Where prod_id In (Select cart_prod
                                        From cart
                                        Where cart_member = 'a001'));


-- 이쁜이 라는 회원이 주문한 상품 중에
-- 상품분류코드가 P201이고, 
-- 거래처코드가 P20101인 
-- 상품코드, 상품명을 조회해 주세요..
Select prod_id, prod_name
From prod
Where prod_lgu = 'P201'
  And prod_buyer = 'P20101'
  And prod_id In (
        Select cart_prod
        From cart
        Where cart_member In (
                Select mem_id
                From member
                Where mem_name = '이쁜이'));
                
                
-- 서브쿼리(SubQuery) 정리
--(방법1) Select 조회 컬럼 대신에 사용하는 경우
--   : 단일컬럼의 단일행만 조회 가능

--(방법2) Where 절에 사용하는 경우
--   In () : 단일컬럼의 단일행 또는 다중행 조회 가능 
--   =     : 단일컬럼의 단일행만 조회 가능



SELECT '<' || TRIM('     A A A     ') || '>'  TRIM1,
        '<' || TRIM(LEADING 'a' FROM 'aaAaBaAaa') || '>'  TRIM2, 
        '<' || TRIM( 'a' FROM 'aaAaBaAaa') || '>'  TRIM3
FROM dual;


--  상품테이블의 상품명의 4째 자리부터  2글자가  '칼라' 인 상품의
--  상품코드, 상품명을 검색하시오 ?
Select Substr(prod_name, 4, 2) as subNm
From prod
Where Substr(prod_name, 4, 2) = '칼라' ;

-- 회원테이블의 회원성명 중 '이＇씨 성을 ? ＇리＇씨 성으 로 치환 검색하시오 ? 
-- 성씨를 바꾼 후  이름 조회..
Select replace(substr(mem_name, 1, 1), '이', '리') || 
                substr(mem_name, 2, 2)
From member;

-- 상품분류 중에 '전자'가 포함된 상품을 구매한 회원 조회하기
-- 회원아이디, 회원이름 조회하기.
-- 단, 상품명에 삼성전자가 포함된 상품을 구매한 회원...
--     그리고, 회원의 취미가 수영인 회원..
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



-- 회원 테이블의 마일리지를 12로 나눈 값을 검색
--   (소수3째자리 반올림, 절삭)
SELECT mem_mileage, (mem_mileage / 12),
       ROUND(mem_mileage / 12, 2),
       TRUNC(mem_mileage / 12, 2)
FROM member;

-- 회원조회, 남자=1, 여자=0 으로 조회
Select mem_id, mem_name, mem_regno1, mem_regno2,
       Mod(substr(mem_regno2, 1, 1) , 2) as sex
From member;


--- 회원테이블의 생일과 12000일째 되는 날을 검색하시오 ?
Select mem_bir, mem_bir + 12000
From member;

Select round(sysdate, 'YYYY'),
        round(sysdate, 'q')
From dual;

-- - 생일이 3월인 회원을 검색하시오?
Select mem_id, mem_bir
From member
Where Extract(Month From mem_bir) = 3;


SELECT '[' || CAST('Hello' AS CHAR(30)) || ']' "형변환"
FROM dual;

SELECT '[' || CAST('Hello' AS VARCHAR(30)) || ']' "형변환"
FROM dual;

-- 0000-00-00, 0000/00/00,  0000.00.00, 00000000, 
--   00-00-00,   00/00/00,    00.00.00
SELECT CAST('1997/12/25' AS DATE) FROM dual;


--상품테이블에서 상품입고일을 '2008-09-28' 형식으로 나오게 검색하시오 
Select prod_insdate, to_char(prod_insdate, 'yyyy-mm-dd')
From prod;

--김은대님은 1976년 1월 출생이고 태어난 요일은  목요일 
Select mem_name || '님은 ' || to_char(mem_bir, 'yyyy') || '년 '
        || to_char(mem_bir, 'mm') || '월 출생이고 태어난 요일은 '
        || to_char(mem_bir, 'day')
From member;

SELECT  TO_CHAR( 1234.6, '99,999.00'),
        TO_CHAR( 1234.6, '9999.99'),
        TO_CHAR( 1234.6, '999,999,999,999.99')
FROM dual;

SELECT  TO_CHAR( 1234.6, 'L9999.00PR'),
        TO_CHAR( -1234.6, 'L9999.99PR')
FROM dual;


-- 계정 잠금 해제
Alter User 사용자계정 Account Unlock;


-- 여자인 회원이 구매한 상품 중에
-- 상품분류에 전자가 포함되어 있고,
-- 거래처의 지역이 서울인 
-- 상품코드, 상품명 조회하기..
Select prod_id, prod_name
From prod
Where prod_id In (
    Select cart_prod
    From cart
    Where cart_member In (
        Select mem_id
        From member
        Where Mod(Substr(mem_regno2, 1, 1), 2) = 0))
 And prod_lgu In (
    Select lprod_gu
    From lprod
    Where lprod_nm Like '%전자%')
 And prod_buyer In (
    Select buyer_id
    From buyer
    Where Substr(buyer_add1, 1, 2) = '서울');


SELECT Round(AVG(DISTINCT prod_cost), 2) as rnd_1, 
        Round(AVG(All prod_cost) ,2) as rnd_2,
        Round(AVG(prod_cost), 2) as rnd_3
FROM prod;

SELECT COUNT(DISTINCT prod_cost), COUNT(All prod_cost),
       COUNT(prod_cost), COUNT(*)
FROM prod;

SELECT COUNT(DISTINCT mem_mileage), COUNT(All mem_mileage),
       COUNT(mem_mileage), COUNT(*)
FROM member;


SELECT mem_job, 
      COUNT(mem_job), COUNT(*) 
FROM member
GROUP BY mem_job;

--그룹(집계)함수만 사용하는 경우에는
--  - Group By 절을 사용하지 않아도 됨..
--조회할 일반컬럼이 사용되는 경우에는 Group By절을 사용해야 합니다.
-- - Group by 절에는 조회에 사용된 일반컬럼은 무조건 넣어 줍니다.
-- - 함수를 사용한 경우에는 함수를 사용한 원형 그대로를 넣어 줍니다.
--Order By절에 사용하는 일반컬럼 또는 함수를 이용한 컬럼은
-- - 무조건 Group By절에 넣어 줍니다.
--sum(), avg(), min(), max(), count()
Select mem_job, mem_like, 
        count(mem_job) as cnt1, count(*) as cnt2
From member
Where mem_mileage > 10
  And mem_mileage > 10
Group By mem_job, mem_like, mem_id
Order By cnt1, mem_id Desc;


-- 수영을 취미로하는 회원들이
-- 주로 구매하는 상품에 대한 정보를 조회하려고 합니다.
-- 상품명별로 count 집계합니다.
-- 조회컬럼, 상품명, 상품 count
-- 정렬은 상품코드를 기준으로 내림차순.
Select prod_name, count(prod_name) as cnt_name
From prod
Where prod_id In (
    Select cart_prod
    From cart 
    Where cart_member In (
        Select mem_id
        From member
        Where mem_like = '수영'))
Group By prod_name, prod_id 
Order By prod_id Desc;


Select cart_prod
From cart 
Where cart_member In (
    Select mem_id
    From member
    Where mem_like = '수영');









Select prod_name, count(prod_name) as cnt_name
From prod
Where prod_id In (
        Select cart_prod
        From cart
        Where cart_member In (
                Select mem_id
                From member
                Where mem_like = '수영'))
Group By prod_name, prod_id
Order By prod_id Desc;







