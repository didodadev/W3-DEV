<!-- Description : Masraf fişinde muhasebe de ACTION_TABLE kolonuna masraf fişi tablosunun set edilmesi
Developer: Melek KOCABEY
Company : Workcube
Destination: PERIOD -->
<querytag>
    UPDATE ACCOUNT_CARD SET ACTION_TABLE = 'EXPENSE_ITEM_PLANS' WHERE ACTION_TYPE = 120 AND ACTION_TABLE IS NULL
</querytag>