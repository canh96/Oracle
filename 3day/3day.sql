--3day
--[��ȸ ��� ����]
-- ��ǰ�з� �߿� '����'�� ���Ե� ��ǰ�� ������ ȸ�� ��ȸ�ϱ�
-- ȸ�����̵�, ȸ���̸� ��ȸ�ϱ�.
-- ��, ��ǰ�� �Ｚ���ڰ� ���Ե� ��ǰ�� ������ ȸ��...
--     �׸���, ȸ���� ��̰� ������ ȸ��..

-- 1. ���̺� ã��
--   - ���õ� �÷����� �Ҽ� ã��
--   - lprod, cart, member, prod 

-- 2. ���̺� ���� ���� ã��
--   - ERD���� ����� ������� PK�� FK�÷� �Ǵ�,
--   - ������ ���� ������ ������ �� �ִ� �÷� ã��
--   - lprod_gu = prod_lgu
--   - prod_id = cart_prod
--   - cart_member = mem_id

-- 3. �ۼ� ���� ���ϱ�
--   - ��ȸ�ϴ� �÷��� ���� ���̺��� ���� ��..1����..
--   - 1���� ���̺���� ERD ������� �ۼ�..
--   - ������ : �ش� �÷��� ���� ���̺��� ���� ó��..

--member > cart > prod > lprod

Select mem_id, mem_name
From member
Where mem_like = '����'
  And mem_id In (
    Select cart_member
    From cart
    Where cart_prod In (
        Select prod_id
        From prod
        Where prod_name Like '%�Ｚ����%'
          And prod_lgu In (
            Select lprod_gu
            From lprod
            Where lprod_nm Like '%����%')));






-- [����]
-- ������ ȸ���� ������ ��ǰ�� ���� 
-- �ŷ�ó ������ Ȯ���Ϸ��� �մϴ�.
-- �ŷ�ó�ڵ�, �ŷ�ó��, ����(���� or ��õ...), �ŷ�ó ��ȭ��ȣ ��ȸ
-- ��, ��ǰ�з��� �߿� ĳ�־� �ܾ ���Ե� ��ǰ�� ���ؼ���...
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
        Where lprod_nm Like '%ĳ�־�%')
      And prod_id In (
        Select cart_prod
        From cart
        Where cart_member In (
            Select mem_id
            From member
            Where mem_name = '������')));


-- ������ ȸ���� ������ ��ǰ �߿�
-- ��ǰ�з��� ���ڰ� ���ԵǾ� �ְ�,
-- �ŷ�ó�� ������ ������ 
-- ��ǰ�ڵ�, ��ǰ�� ��ȸ�ϱ�..
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
    Where lprod_nm Like '%����%')
  And prod_buyer In (
    Select buyer_id
    From buyer
    Where Substr(buyer_add1, 1, 2)='����');



-- ��ǰ�ڵ庰 ���ż����� ���� �ִ밪, �ּҰ�, ��հ�, �հ�, ���� ��ȸ�ϱ�.
-- ��ȸ�÷� ��ǰ�ڵ�, �ִ밪, �ּҰ�, ��հ�, �հ�, ����
-- 1. cart
-- <Group ���� >
-- �����Լ��� �Ϲ��÷�(�Լ��� ����� �÷� ����)�� ���ÿ� ���� ��쿡��
-- ������ �Ϲ��÷��� Group By���� �־��־�� �մϴ�.
Select cart_prod, Max(cart_qty) as mqty,
        Min(cart_qty) as mqty, Round(Avg(cart_qty), 2) as aqty,
        Sum(cart_qty) as sqty, Count(cart_qty) as cqty
From cart
Group By cart_prod;

Select * 
From cart;

Select * 
From lprod;


--������ 2005�⵵7��11���̶� �����ϰ� ��ٱ������̺� �߻��� 
--  �߰��ֹ���ȣ�� �˻� �Ͻÿ� ? 
-- ��ȸ �÷� : ���� ������ �ֹ���ȣ, �߰��ֹ���ȣ
--1. cart
select Max(cart_no) as mno, Max(cart_no)+1 as mpno
From cart
Where Substr(cart_no, 1, 8) = '20050711';

-- ȸ�����̺��� ȸ����ü�� ���ϸ��� ���, ���ϸ��� �հ�,
-- �ְ� ���ϸ���, �ּ� ���ϸ���,�ο����� �˻��Ͻÿ� ? 
Select Round(Avg(mem_mileage), 2) as am, Sum(mem_mileage) as sm,
        Max(mem_mileage) as mm, Min(mem_mileage) as mim,
        Count(mem_mileage) as cm
From member;

-- [����]
-- ��ǰ���̺��� �ŷ�ó�ڵ庰, ��ǰ�з��ڵ庰��,
-- �ǸŰ��� ���� �ְ�, �ּ�, �ڷ��, ���, �հ踦 ��ȸ�� �ּ���..
-- ������ �ڷ���� �������� ��������
-- �߰���, �ŷ�ó��, ��ǰ�з��� ��ȸ..
-- �� �հ谡 100 �̻��� ��
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
WHERE buyer_charger LIKE '��%';

UPDATE buyer SET buyer_charger = ''
WHERE buyer_charger LIKE '��%';

Select buyer_charger
From buyer
Where buyer_charger is Null;

SELECT buyer_name, 
      NVL(buyer_charger, '����') as charger
FROM buyer;

    
SELECT prod_lgu,
        DECODE( SUBSTR(prod_lgu, 1,2),  
                  'P1', '��ǻ��/���� ��ǰ', 
                  'P2' , '�Ƿ�', 
                  'P3' ,'��ȭ',   
                  '��Ÿ' ) as lgu_nm
FROM prod;



SELECT prod_id, prod_name, prod_lgu
FROM prod
WHERE EXISTS ( 
    SELECT *
    FROM lprod
    WHERE lprod_gu = prod_lgu);

SELECT  *  FROM lprod, prod;
SELECT  *  FROM lprod CROSS JOIN prod;

-- Inner Join ����
-- PK�� FK�� �־�� �մϴ�.
-- �������� ���� : PK = FK
-- ���������� ���� : From���� ���õ� (���̺��� ���� - 1��)

--��ǰ���̺��� ��ǰ�ڵ�, ��ǰ��, �з����� ��ȸ.
-- 1. prod, lprod
-- 2. 1prod_lgu = lprod_gu
-- 3. lprod > prod
-- <�Ϲݹ��>
Select prod_id, prod_name, lprod_nm, buyer_name, cart_qty, mem_name
From lprod, prod, buyer, cart, member
--�������ǽ�
Where lprod_gu = prod_lgu
  And buyer_id = prod_buyer
  And prod_id = cart_prod
  And mem_id = cart_member
  And mem_id = 'a001';

-- <ǥ�ع��>
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
               
--��ǰ���̺��� ��ǰ�ڵ�, ��ǰ��, �з���, �ŷ�ó��,
--�ŷ�ó�ּҸ� ��ȸ.
--1) �ǸŰ����� 10���� ���� �̰�
--2) �ŷ�ó �ּҰ�  �λ��� ��츸 ��ȸ
-- �Ϲݹ��, ǥ�ع��..��� �غ���..

--1.���̺� ã��.
--  prod, lprod, buyer
--2.�������ǽ� ã��
--  prod_lgu = lprod_gu
--  prod_buyer = buyer_id
--3.���� ���ϱ�..

Select prod_id, prod_name, lprod_nm, buyer_name
From prod, lprod, buyer
Where prod_lgu = lprod_gu
  And prod_buyer = buyer_id
  And prod_sale <= 100000
  And buyer_add1 Like '�λ�%';

Select prod_id, prod_name, lprod_nm, buyer_name
From prod Inner Join lprod
            On(prod_lgu = lprod_gu
               And prod_sale <= 100000)
          Inner Join buyer
            On(prod_buyer = buyer_id
            And buyer_add1 Like '�λ�%');

--[����]
--��ǰ�з���, ��ǰ��, ��ǰ����, ���Լ���, �ֹ�����, �ŷ�ó���� ��ȸ
-- ��, ��ǰ�з� �ڵ尡 P101, P201, P301�� ��
--     ���Լ����� 15�� �̻��� ��
--     ���￡ ��� �ִ� ȸ�� �߿� ������ 1974����� ȸ��
-- ������ ȸ�����̵� ���� ��������, ���Լ��� ���� ��������
-- �Ϲݹ��, ǥ�ع��..

--������ 3���� �����
--����.txt�� ����.txt ���� ���Ϸ� ����
--���۵���̺� > ���Ǿ� > oracle > 
--          "��������" ������ [����.txt] ���ϸ� ����













