--상품테이블과 상품분류테이블에서 상품분류코드가 'P101'인 것에 대한
--상품분류코드(상품테이블에 있는 칼럼), 상품명, 상품분류명을 조회해 주세요.
--정렬은 상품아이디로 내림차순...

SELECT prod_lgu, prod_name, lprod_nm
from prod, lprod
where prod_lgu = lprod_gu
and prod_lgu = 'P101'
order by prod_name desc;
--
select prod_lgu, prod_name, lprod_nm
from prod inner join lprod
on(prod_lgu = lprod_gu and prod_lgu = 'P101')
order by prod_name desc;

--김형모 회원이 구매한 상품에 대한
--거래처 정보를 확인하려고 합니다.
--거래처코드, 거래처명, 회원거주지역(서울 or  인천...)조회
--단 상품분류명 중에 캐주얼 단어가 포함된 제품에 대해서만...
select buyer_id, buyer_name, substr(mem_add1,1,2)
from buyer,member,cart,prod,lprod
where buyer_id=prod_buyer
and lprod_gu =prod_lgu
and cart_prod=prod_id
and cart_member = mem_id
and mem_name = '김형모'
and lprod_nm like '%캐주얼%';

--상품분류명에 '전자'가 포함된 상품을 구매한 회원 조회하기
--회원아이디, 회원이름, 상품분류명 조회하기.
--단, 상품명에 삼성전자가 포함된 상품을 구매한 회원과...
--회원의 취미가 수영인 회원
select mem_id, mem_name, lprod_nm
from member,cart,prod,lprod
where mem_id=cart_member
    and mem_like ='수영'
and cart_prod =prod_id
    and prod_name like '삼성전자%'
and prod_lgu =lprod_gu
    and lprod_nm like '전자%'
;

--상품분류테이블과 상품테이블과 거래처테이블과 장바구니 테이블 사용..
--상품분류코드가 'p101'인 것을 조회
--그리고, 정렬은 상품분류명을 기준으로 내림차순,
--            상품아이디를 기준으로 오름차순 하세요..
--상품분류명, 상품아이디, 상품판매가, 거래처담당자, 회원아이디,
--주문수량을 조회..
select lprod_nm, prod_name, prod_sale, mem_id,cart_qty
from lprod, prod, buyer, cart, member
where lprod_gu = prod_lgu
and lprod_gu = 'P101'
and prod_buyer = buyer_id
and prod_id = cart_prod
and cart_member = mem_id
order by prod_id asc , lprod_nm desc;

select lprod_nm, prod_name, prod_sale, mem_id,cart_qty
from lprod inner join prod
on(lprod_gu = prod_lgu and lprod_gu = 'P101')
 inner join buyer 
on(prod_buyer = buyer_id)
 inner join cart 
on(prod_id = cart_prod)
 inner join member
on(cart_member = mem_id)
order by prod_id asc , lprod_nm desc;

--상품코드별 구매수량에 대한 최댓값, 최소값,평균값,합계,갯수 조회하기,
--단, 상품명에 삼성이 포함된 상품을 구매한 회원에 대해서만
--조회컬럼 상품코드, 최댓밗, 최소값, 평균값, 합계, 갯수
select prod_id, max(cart_qty)as max, min(cart_qty)as min,
    round(avg(cart_qty),2)as avg, sum(cart_qty)as sum, count(cart_qty) as count 

from prod, cart
where prod_id = cart_prod

and  prod_name like '삼성%'
group by prod_id
;

--거래처코드 및 상품분류코드별로,
---판매가에 대한 최고, 최소, 자료수, 평균, 합계를 조회해 주세요.
--조회컬ㄹ럼, 거래처코드, 거래처명, 상품분류코드, 상품분류명,
            --판매가에 대한 최고, 최소, 자료수, 평균, 합꼐
--정렬은 평균을 기준으로 내림차순
--단, 판매가의 평균이 100이상인 것
select buyer_id, prod_name,lprod_gu,lprod_nm,
max(prod_sale), min(prod_sale), count(prod_sale), avg(prod_sale) as avg, sum(prod_sale)
from buyer,lprod, prod
where buyer_lgu = lprod_gu
and lprod_gu = prod_lgu
group by buyer_id, prod_name, lprod_gu, lprod_nm
having avg(prod_sale) >=100
order by avg desc;


--거래처별로 group 지어서 매입금액의 합을 검색하고자 합니다...
--조건은 상품입고테이블의 2005년도 1월의 매입일자(입고일자)인것들...
--매입금액 = 매입 수량 * 매입금액..
--조회컬럼 : 거래처코드, 거래처명, 매입금액의 합 
--(매입금액의 합이 null인 경우 0으로 조회)
--정렬은 거래처 코드 및 거래처명을 기준으로 내림차순

select buyer_id, buyer_name , nvl(sum(buy_qty * buy_cost),0)as buy_cost
from buyer, prod,buyprod
where buyer_id = prod_buyer
and prod_id = buy_prod
and buy_date between '05/01/01' and '05/01/31'
group by buyer_id, buyer_name
order by buyer_id desc,buyer_name desc;

select substr(buy_date,1,5) 
from buyprod;

--거래처별로 group 지어서 매입금액의 합을 계산하여
--매입금액의 합이 1천만원이 이상인 상품코드, 상품명르 검색하고자 합니다..
--조건은 상품입고테이블의 2005년도 1월의 매입일자(입고일자)인것들...
--매입금액 = 매입수량* 매입금액..
--(매입금액의 합이 null인 경우 0으로 조회)
--조회컬럼 : 상품코드 , 상품명
--정렬은 상품명을 기준으로 오름차순

select prod_id, prod_name
from prod, buyprod
where prod_id = buy_prod
and buy_date between '05/01/01' and '05/01/31'
having sum(nvl(buy_qty * buy_cost,0)) >=10000000
group by prod_id,prod_name
order by prod_name asc;