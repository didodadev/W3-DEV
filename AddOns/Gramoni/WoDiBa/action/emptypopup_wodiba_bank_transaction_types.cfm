<!---
    File: emptypopup_wodiba_bank_transaction_types.cfm
    Author: Gramoni-Cagla <cagla.kara@gramoni.com>
    Date: 04.01.2020
    Controller:
    Description:
        End Date değeri ile sistemde eşleşen bir kayıt mevcut ise wodiba transaction type kaydına tayin edilecek şekilde düzenleme yapıldı.
    History:
        
--->

<cfscript>
    include "../cfc/Functions.cfc";
    end_date=GetWodibaBankTransactionDateType();
    if(end_date.recordcount)
    {
        day=Day(end_date.END_DATE)-1;
        end_date.END_DATE.setDay(day);
        from_date = dateFormat(end_date.END_DATE,'YYYY-mm-dd');
        getAll=0;
    }
    else
    {
        from_date = '1900-01-01';
        getAll=1;
    }
    cfhttp (url="http://catalyst.gramoni.com/AddOns/Gramoni/WoDiBa/cfc/Functions.cfc?method=GetWodibaBankTransactionTypeService&FromDate=#from_date#&GetAll=#getAll#",method="GET",result="return_list")
    {
        cfhttpparam(name="Content-Type",value="application/json",type="header");
    }
    return_list=replace(return_list.filecontent,'//""//',"",'All');
	return_list=replace(return_list,'//""',"",'All');
	return_list=replace(return_list,'//',"",'All');

    if(isJSON(return_list)){
    return_data=deserializeJSON(return_list);
        for (i = 1; i <= arrayLen(return_data); i++) {
                return_list_type=GetWodibaBankTransactionType(Transaction_Uid=return_data[i].TRANSACTION_UID);
                if(return_list_type.recordcount eq 0)
                {
                    AddWodibaBankTransaction(
                        Transaction_Uid:return_data[i].TRANSACTION_UID,
                        Transaction_Code:return_data[i].TRANSACTION_CODE,
                        Transaction_Code2:return_data[i].TRANSACTION_CODE2,
                        Process_Type:return_data[i].PROCESS_TYPE,
                        Description_1:return_data[i].DESCRIPTION_1,
                        Description_2:return_data[i].DESCRIPTION_2,
                        In_Out:return_data[i].IN_OUT,
                        Bank_Code:return_data[i].BANK_CODE
                    );
                }
                else
                {
                    UpdateWodibaBankTransaction(
                        Transaction_Uid:return_data[i].TRANSACTION_UID,
                        Process_Type:return_data[i].PROCESS_TYPE,
                        Description_1:return_data[i].DESCRIPTION_1,
                        Description_2:return_data[i].DESCRIPTION_2,
                        In_Out:return_data[i].IN_OUT
                    );
                }
            }
    }
</cfscript>