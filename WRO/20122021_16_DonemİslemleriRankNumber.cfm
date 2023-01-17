<!-- Description : dönem işlemlerinin öncelik sırasına göre sıralanması...
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    update WRK_OBJECTS set  RANK_NUMBER = 7 where FULL_FUSEACTION = 'settings.otv_rate_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 8 where FULL_FUSEACTION = 'settings.oiv_rate_transfer'

    update WRK_OBJECTS set  RANK_NUMBER = 9 where FULL_FUSEACTION = 'settings.bsmv_rate_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 10 where FULL_FUSEACTION = 'settings.withholding_tax_rate_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 11 where FULL_FUSEACTION = 'settings.product_period_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 12 where FULL_FUSEACTION = 'settings.project_period_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 13 where FULL_FUSEACTION = 'settings.department_branch_account_transfer_all'
    update WRK_OBJECTS set  RANK_NUMBER = 14 where FULL_FUSEACTION = 'settings.location_period_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 15 where FULL_FUSEACTION = 'settings.cash_transfer'

    update WRK_OBJECTS set  RANK_NUMBER = 17 where FULL_FUSEACTION = 'settings.employee_account_transfer_all'
    update WRK_OBJECTS set  RANK_NUMBER = 18 where FULL_FUSEACTION = 'settings.form_close_cari'
    update WRK_OBJECTS set  RANK_NUMBER = 19 where FULL_FUSEACTION = 'settings.form_close_cari_consumer'
    update WRK_OBJECTS set  RANK_NUMBER = 20 where FULL_FUSEACTION = 'settings.form_close_cari_employee'
    update WRK_OBJECTS set  RANK_NUMBER = 21 where FULL_FUSEACTION = 'settings.form_cheque_copy'
    update WRK_OBJECTS set  RANK_NUMBER = 22 where FULL_FUSEACTION = 'settings.form_voucher_copy'
    update WRK_OBJECTS set  RANK_NUMBER = 23 where FULL_FUSEACTION = 'settings.endorsement_cheque_copy'
    update WRK_OBJECTS set  RANK_NUMBER = 24 where FULL_FUSEACTION = 'settings.endorsement_voucher_copy'
    update WRK_OBJECTS set  RANK_NUMBER = 25 where FULL_FUSEACTION = 'bank.form_bank_order_copy'	
    update WRK_OBJECTS set  RANK_NUMBER = 26 where FULL_FUSEACTION = 'settings.stock_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 27 where FULL_FUSEACTION = 'settings.stock_age_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 28 where FULL_FUSEACTION = 'settings.consignment_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 29 where FULL_FUSEACTION = 'settings.financial_tables_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 30 where FULL_FUSEACTION = 'settings.workstations_account_transfer'
    update WRK_OBJECTS set  RANK_NUMBER = 31 where FULL_FUSEACTION = 'settings.form_muhasebe_devir'
    update WRK_OBJECTS set  RANK_NUMBER = 32 where FULL_FUSEACTION = 'settings.form_add_acc_close_card'
</querytag>