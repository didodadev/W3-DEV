<!--- FBS 20101224 Teminatlar Tarihce --->

<cfquery name="get_securefund_history" datasource="#dsn#">
	SELECT 
    	CSH.SECUREFUND_HISTORY_ID, 
        CSH.SECUREFUND_ID, 
        CSH.SECUREFUND_STATUS,
        CSH.SECUREFUND_CAT_ID, 
        CSH.ACTION_TYPE_ID, 
        CSH.ACTION_CAT_ID, 
        CSH.OUR_COMPANY_ID, 
        CSH.COMPANY_ID,
        CSH.CONSUMER_ID, 
        CSH.ACTION_VALUE, 
        CSH.COMMISSION_RATE, 
        CSH.SECUREFUND_TOTAL, 
        CSH.GIVE_TAKE, 
        CSH.MONEY_CAT, 
        CSH.EXPENSE_TOTAL, 
        CSH.MONEY_CAT_EXPENSE, 
        CSH.BANK_BRANCH_ID, 
        CSH.BANK, 
        CSH.BANK_BRANCH, 
        CSH.REALESTATE_DETAIL, 
        CSH.START_DATE, 
        CSH.FINISH_DATE, 
        CSH.SECUREFUND_FILE, 
        CSH.BRANCH_ID, 
        CSH.PROCESS_CAT, 
        CSH.SECUREFUND_FILE_SERVER_ID,
        CSH.GIVEN_ACC_CODE, 
        CSH.TAKEN_ACC_CODE, 
        CSH.ACTION_PERIOD_ID, 
        CSH.PROJECT_ID, 
        CSH.CREDIT_LIMIT, 
        CSH.CONTRACT_ID, 
        CSH.OFFER_ID, 
        CSH.UPDATE_DATE, 
        CSH.UPDATE_EMP, 
        ISNULL(CSH.UPDATE_DATE,CSH.H_RECORD_DATE) UPDATE_DATE1,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS UPDATE_NAME ,
        CSH.UPDATE_IP	,
        SPC.PROCESS_CAT_ID,
        SPC. PROCESS_CAT
    FROM 
    	COMPANY_SECUREFUND_HISTORY  CSH
        LEFT JOIN #dsn_alias#.EMPLOYEES E ON CSH.UPDATE_EMP = E.EMPLOYEE_ID
        LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON CSH.ACTION_CAT_ID =SPC.PROCESS_CAT_ID
    WHERE 
	    CSH.SECUREFUND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.securefund_id#"> 
    ORDER BY 
    	CSH.SECUREFUND_HISTORY_ID DESC
</cfquery>
 <cfset temp_ = 0>
 <cfsavecontent variable="message"><cf_get_lang dictionary_id="58689.Teminat"> <cf_get_lang dictionary_id="57473.Tarihçe"></cfsavecontent>
<cf_popup_box title="#message#">		
 <cfoutput query="get_securefund_history">
                 <cfset temp_ = temp_ +1>
                <cf_seperator id="history_#temp_#" header="#dateformat(update_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,update_date1),timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
    <cf_medium_list id="history_#temp_#" style="display:none">
        <thead>
            <tr>
                <th width="50"><cf_get_lang dictionary_id='57756.Durum'></th>
                <th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
                <th width="90"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
                <th width="90"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                <th width="70" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                <th width="85" style="text-align:right;"><cf_get_lang dictionary_id ='58791.Komisyon'>%</th>
                <th><cf_get_lang dictionary_id='57891.Güncelleyen'></th>
                <th><cf_get_lang dictionary_id='57703.Güncelleme'></th>
            </tr>
        </thead>
        <tbody>
			 <cfif get_securefund_history.recordcount>
              
                <tr >
                    <td><cfif get_securefund_history.securefund_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                    <td>#PROCESS_CAT#</td>
                    <td>#DateFormat(start_date,dateformat_style)#</td>
                    <td>#DateFormat(finish_date,dateformat_style)#</td>
                    <td style="text-align:right;">#TLFormat(action_value)#</td>
                    <td style="text-align:right;">#TLFormat(commission_rate)#</td>
                    <td>#update_name#</td>
                    <td>#DateFormat(update_date,dateformat_style)# #TimeFormat(DateAdd('h',session.ep.time_zone,update_date),timeformat_style)#</td>
                </tr>
                
            <cfelse>
                <tr>
                    <td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_medium_list>
    </cfoutput>
</cf_popup_box>
