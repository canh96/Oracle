--2day

-- ȸ������ ��ü ��ȸ
Select *
From member;

-- ��̰� "����"�� ȸ���� �߿� 
-- ���ϸ����� ���� 1000 �̻��� 
-- ȸ�����̵�, ȸ���̸�, ȸ�����, ȸ�����ϸ��� ��ȸ
-- ������ ȸ���̸� ���� ��������
Select mem_id, mem_name, mem_like, mem_mileage
From member
Where mem_like = '����'
  And mem_mileage >= 1000
Order By mem_name Asc;

-- ������ ȸ���� ������ ��̸� ������
-- ȸ�� ���̵�, ȸ���̸�, ȸ����� ��ȸ�ϱ�...
Select mem_like
From member
Where mem_name = '������';

Select mem_id, mem_name, mem_like
From member
Where mem_like = (Select mem_like
                    From member
                    Where mem_name = '������');
                    
-- �ֹ������� �ִ� ȸ���� ���� ������ ��ȸ�Ϸ��� �մϴ�.
-- ȸ�����̵�, ȸ���̸�, �ֹ���ȣ, �ֹ����� ��ȸ�ϱ�
Select cart_member, cart_no, cart_qty,
        (Select mem_name 
         From member
         Where mem_id = cart_member) as name
From cart;

-- �ֹ������� �ִ� ȸ���� ���� ������ ��ȸ�Ϸ��� �մϴ�.
-- ȸ�����̵�, ȸ���̸�, �ֹ���ȣ, �ֹ�����, ��ǰ�� ��ȸ�ϱ�
Select cart_member, cart_no, cart_qty,
        (Select mem_name 
         From member
         Where mem_id = cart_member) as name,
         (Select prod_name
          From prod
          Where prod_id = cart_prod) as p_name
From cart;

-- a001 ȸ���� �ֹ��� ��ǰ�� ����
-- ��ǰ�з��ڵ�, ��ǰ�з��� ��ȸ�ϱ�..
Select lprod_gu, lprod_nm
From lprod
Where lprod_gu In (Select prod_lgu
                    From prod
                    Where prod_id In (Select cart_prod
                                        From cart
                                        Where cart_member = 'a001'));


-- �̻��� ��� ȸ���� �ֹ��� ��ǰ �߿�
-- ��ǰ�з��ڵ尡 P201�̰�, 
-- �ŷ�ó�ڵ尡 P20101�� 
-- ��ǰ�ڵ�, ��ǰ���� ��ȸ�� �ּ���..
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
                Where mem_name = '�̻���'));
                
                
-- ��������(SubQuery) ����
--(���1) Select ��ȸ �÷� ��ſ� ����ϴ� ���
--   : �����÷��� �����ุ ��ȸ ����

--(���2) Where ���� ����ϴ� ���
--   In () : �����÷��� ������ �Ǵ� ������ ��ȸ ���� 
--   =     : �����÷��� �����ุ ��ȸ ����



SELECT '<' || TRIM('     A A A     ') || '>'  TRIM1,
        '<' || TRIM(LEADING 'a' FROM 'aaAaBaAaa') || '>'  TRIM2, 
        '<' || TRIM( 'a' FROM 'aaAaBaAaa') || '>'  TRIM3
FROM dual;


--  ��ǰ���̺��� ��ǰ���� 4° �ڸ�����  2���ڰ�  'Į��' �� ��ǰ��
--  ��ǰ�ڵ�, ��ǰ���� �˻��Ͻÿ� ?
Select Substr(prod_name, 4, 2) as subNm
From prod
Where Substr(prod_name, 4, 2) = 'Į��' ;

-- ȸ�����̺��� ȸ������ �� '�̣��� ���� ? �������� ���� �� ġȯ �˻��Ͻÿ� ? 
-- ������ �ٲ� ��  �̸� ��ȸ..
Select replace(substr(mem_name, 1, 1), '��', '��') || 
                substr(mem_name, 2, 2)
From member;

-- ��ǰ�з� �߿� '����'�� ���Ե� ��ǰ�� ������ ȸ�� ��ȸ�ϱ�
-- ȸ�����̵�, ȸ���̸� ��ȸ�ϱ�.
-- ��, ��ǰ�� �Ｚ���ڰ� ���Ե� ��ǰ�� ������ ȸ��...
--     �׸���, ȸ���� ��̰� ������ ȸ��..
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



-- ȸ�� ���̺��� ���ϸ����� 12�� ���� ���� �˻�
--   (�Ҽ�3°�ڸ� �ݿø�, ����)
SELECT mem_mileage, (mem_mileage / 12),
       ROUND(mem_mileage / 12, 2),
       TRUNC(mem_mileage / 12, 2)
FROM member;

-- ȸ����ȸ, ����=1, ����=0 ���� ��ȸ
Select mem_id, mem_name, mem_regno1, mem_regno2,
       Mod(substr(mem_regno2, 1, 1) , 2) as sex
From member;


--- ȸ�����̺��� ���ϰ� 12000��° �Ǵ� ���� �˻��Ͻÿ� ?
Select mem_bir, mem_bir + 12000
From member;

Select round(sysdate, 'YYYY'),
        round(sysdate, 'q')
From dual;

-- - ������ 3���� ȸ���� �˻��Ͻÿ�?
Select mem_id, mem_bir
From member
Where Extract(Month From mem_bir) = 3;


SELECT '[' || CAST('Hello' AS CHAR(30)) || ']' "����ȯ"
FROM dual;

SELECT '[' || CAST('Hello' AS VARCHAR(30)) || ']' "����ȯ"
FROM dual;

-- 0000-00-00, 0000/00/00,  0000.00.00, 00000000, 
--   00-00-00,   00/00/00,    00.00.00
SELECT CAST('1997/12/25' AS DATE) FROM dual;


--��ǰ���̺��� ��ǰ�԰����� '2008-09-28' �������� ������ �˻��Ͻÿ� 
Select prod_insdate, to_char(prod_insdate, 'yyyy-mm-dd')
From prod;

--��������� 1976�� 1�� ����̰� �¾ ������  ����� 
Select mem_name || '���� ' || to_char(mem_bir, 'yyyy') || '�� '
        || to_char(mem_bir, 'mm') || '�� ����̰� �¾ ������ '
        || to_char(mem_bir, 'day')
From member;

SELECT  TO_CHAR( 1234.6, '99,999.00'),
        TO_CHAR( 1234.6, '9999.99'),
        TO_CHAR( 1234.6, '999,999,999,999.99')
FROM dual;

SELECT  TO_CHAR( 1234.6, 'L9999.00PR'),
        TO_CHAR( -1234.6, 'L9999.99PR')
FROM dual;


-- ���� ��� ����
Alter User ����ڰ��� Account Unlock;


-- ������ ȸ���� ������ ��ǰ �߿�
-- ��ǰ�з��� ���ڰ� ���ԵǾ� �ְ�,
-- �ŷ�ó�� ������ ������ 
-- ��ǰ�ڵ�, ��ǰ�� ��ȸ�ϱ�..
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
    Where lprod_nm Like '%����%')
 And prod_buyer In (
    Select buyer_id
    From buyer
    Where Substr(buyer_add1, 1, 2) = '����');


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

--�׷�(����)�Լ��� ����ϴ� ��쿡��
--  - Group By ���� ������� �ʾƵ� ��..
--��ȸ�� �Ϲ��÷��� ���Ǵ� ��쿡�� Group By���� ����ؾ� �մϴ�.
-- - Group by ������ ��ȸ�� ���� �Ϲ��÷��� ������ �־� �ݴϴ�.
-- - �Լ��� ����� ��쿡�� �Լ��� ����� ���� �״�θ� �־� �ݴϴ�.
--Order By���� ����ϴ� �Ϲ��÷� �Ǵ� �Լ��� �̿��� �÷���
-- - ������ Group By���� �־� �ݴϴ�.
--sum(), avg(), min(), max(), count()
Select mem_job, mem_like, 
        count(mem_job) as cnt1, count(*) as cnt2
From member
Where mem_mileage > 10
  And mem_mileage > 10
Group By mem_job, mem_like, mem_id
Order By cnt1, mem_id Desc;


-- ������ ��̷��ϴ� ȸ������
-- �ַ� �����ϴ� ��ǰ�� ���� ������ ��ȸ�Ϸ��� �մϴ�.
-- ��ǰ���� count �����մϴ�.
-- ��ȸ�÷�, ��ǰ��, ��ǰ count
-- ������ ��ǰ�ڵ带 �������� ��������.
Select prod_name, count(prod_name) as cnt_name
From prod
Where prod_id In (
    Select cart_prod
    From cart 
    Where cart_member In (
        Select mem_id
        From member
        Where mem_like = '����'))
Group By prod_name, prod_id 
Order By prod_id Desc;


Select cart_prod
From cart 
Where cart_member In (
    Select mem_id
    From member
    Where mem_like = '����');









Select prod_name, count(prod_name) as cnt_name
From prod
Where prod_id In (
        Select cart_prod
        From cart
        Where cart_member In (
                Select mem_id
                From member
                Where mem_like = '����'))
Group By prod_name, prod_id
Order By prod_id Desc;







