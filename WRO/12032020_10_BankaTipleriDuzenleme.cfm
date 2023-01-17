<!-- Description : Banka Hesaplarında Hesap Tipleri text tutuluyordu, int olacak şekilde düzenlendi
Developer: İlker Altındal
Company : Workcube
Destination: Company -->
<querytag>
      UPDATE ACCOUNTS SET ACCOUNT_TYPE = 1 WHERE ACCOUNT_TYPE = 'Kredili'
      UPDATE ACCOUNTS SET ACCOUNT_TYPE = 2 WHERE ACCOUNT_TYPE = 'Ticari'
</querytag>