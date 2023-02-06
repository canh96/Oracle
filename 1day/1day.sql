--
-- ����Ŭ 12���� �̻���ʹ� �Ʒ��� �����ؾ� 
-- �Ϲ����� ���� �ۼ��� ������
--Alter session set "_ORACLE_SCRIPT"=true;
--
---- ���� ������ ���� �ѹ� ����
---- ���� ���� ���ϸ� �Ʒ�ó�� ������ �ۼ��ؾ���
--Create User c##buasn_06 Identified by dbdb;
--
---- 1. ����� �����ϱ�
--Create User busan_06
--    Identified By dbdb;
--
---- �н����� �����ϱ�
--Alter User busan_06
--    Identified By �����н�����;
--    
---- ����� �����ϱ�
--Drop User busan_06;
--    
---- 2. ���Ѻο��ϱ�
--Grant Connect, Resource, DBA To busan_06;
--
---- ���� ȸ���ϱ�
--Revoke DBA From busan_06;

--
CREATE TABLE  lprod (
lprod_id   number(5) NOT NULL,           -- ��ǰ�з��ڵ�
lprod_gu  char(4)     NOT NULL,            -- ��ǰ�з�
lprod_nm  varchar2(40) NOT NULL,        -- ��ǰ�з��� 
Constraint pk_lprod Primary Key (lprod_gu)
);

Select *
From lprod;

INSERT INTO lprod (lprod_id, lprod_gu,lprod_nm)
VALUES (1, 'P101', '��ǻ����ǰ') ;
INSERT INTO lprod (lprod_id, lprod_gu,lprod_nm)
VALUES (1, 'P102', '��ǻ����ǰ') ;

select lprod_gu, lprod_nm
From lprod;

commit;
rollback;

-- ȸ������ ���̺�
Select *
From member;

--�ֹ��������� ���̺�
Select *
From cart;

--��ǰ���� ���̺�
Select *
From prod;

-- ��ǰ�з����� ���̺�
Select *
From lprod;

-- �ŷ�ó���� ���̺�
Select *
From buyer;

-- �԰��ǰ����(���) ���̺�
Select *
From buyprod;

--ȸ�����̺��� ȸ�����̵�, ȸ���̸� ��ȸ�ϱ�..
Select mem_id, mem_name
From member;

--��ǰ�ڵ�� ��ǰ�� ��ȸ�ϱ�..
Select prod_id, prod_name
From prod;

-- ��ǰ�ڵ�, ��ǰ��, �Ǹűݾ� ��ȸ�ϱ�
-- ��, �Ǹűݾ�=�ǸŰ� * 55 �� ����ؼ� ��ȸ�մϴ�.
-- �Ǹűݾ��� 4�鸸 �̻��� �����͸� ��ȸ�ϱ�...
-- ������ �Ǹűݾ��� �������� ��������
-- select > from ���̺� > where > �÷���ȸ > order by
Select prod_id, prod_name,
        (prod_sale * 55) as sale
From prod
Where (prod_sale * 55) >= 4000000
Order By sale Desc;

-- ��ǰ�������� ��äó�ڵ�(���޾�ü)�� ��ȸ�� �ּ���...
-- ��, �ߺ��� �����ϰ� ��ȸ���ּ���..
Select Distinct prod_buyer
From prod;

-- ��ǰ�߿� �ǸŰ����� 17������ ��ǰ ��ȸ�ϱ�..
Select prod_id, prod_sale
From prod
Where prod_sale = 170000;

-- ��ǰ�߿� �ǸŰ����� 17������ �ƴ� ��ǰ ��ȸ�ϱ�..
Select prod_id, prod_sale
From prod
Where prod_sale != 170000;

-- ��ǰ�߿� �ǸŰ����� 17���� �̻��̰� 20���� ������ ��ǰ ��ȸ�ϱ�..
Select prod_id, prod_sale
From prod
Where prod_sale >= 170000
  And prod_sale <= 200000;

-- ��ǰ�߿� �ǸŰ����� 17���� �̻� �Ǵ� 20���� ������ ��ǰ ��ȸ�ϱ�..
Select prod_id, prod_sale
From prod
Where prod_sale >= 170000
  or prod_sale <= 200000;

-- ��ǰ �ǸŰ����� 10���� �̻� �̰�,,
-- ��ǰ �ŷ�ó(���޾�ü) �ڵ尡 P30203 �Ǵ� P10201 �� 
-- ��ǰ�ڵ�, �ǸŰ���, ���޾�ü �ڵ� ��ȸ�ϱ�...
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

--�ѹ��� �ֹ��� ���� ���� ȸ�� ���̵�, �̸��� ��ȸ�� �ּ���..
Select mem_id, mem_name
From member
Where mem_id Not In (Select Distinct cart_member 
                        From cart);

-- ��ǰ�з� �߿� ��ǰ������ ���� �з��ڵ常 ��ȸ�� �ּ���..
Select lprod_gu
From lprod
Where lprod_gu Not In (Select Distinct prod_lgu
                    From prod);

-- ȸ���� ���� �߿� 75����� �ƴ� ȸ�����̵�, ���� ��ȸ�ϱ�..
-- ������ ���� ���� ��������
Select * from member
Where mem_bir Not Between '1975-01-01' And '1975-12-31';

-- ȸ�� ���̵� a001�� ȸ���� �ֹ��� ��ǰ�ڵ带 ��ȸ�� �ּ���..
-- ��ȸ�÷��� ȸ�����̵�, ��ǰ�ڵ�
Select Distinct cart_member, cart_prod
From cart
Where cart_member = 'a001'; 

Select Distinct cart_member, cart_prod
From cart
Where cart_member In (Select mem_id 
                       From member 
                       Where mem_id = 'a001')












