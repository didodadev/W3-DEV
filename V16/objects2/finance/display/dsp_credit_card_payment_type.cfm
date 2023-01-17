<cfset attributes.var_type = '2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfquery name="GET_CREDIT" datasource="#DSN3#">
	SELECT 
    	SALES_CREDIT,
		STORE_REPORT_DATE,
        ACTION_FROM_COMPANY_ID,
        CONSUMER_ID,
        ACTION_DETAIL,
        ACTION_TO_ACCOUNT_ID,
        OTHER_CASH_ACT_VALUE,
        OTHER_MONEY,
        RECORD_EMP,
        RECORD_PAR
	FROM 
		CREDIT_CARD_BANK_PAYMENTS 
	WHERE 
		CREDITCARD_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND 
        (
			<cfif isdefined("session.pp.company_id")>
				ACTION_FROM_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
				ACTION_TO_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
			<cfelseif isdefined("session.ww.userid")>
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfif>
		)
</cfquery>

<hgroup class="finance_display">
    <h3><cf_get_lang_main no='424.Kredi Kartı Tahsilat'></h3>
    <cfoutput>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='330.Tarih'></label>
        <span>: #dateformat(get_credit.store_report_date,'dd/mm/yyyy')#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='240.Hesap'></label>
        <span>: 
        	<cfset account_id=get_credit.action_to_account_id>
            <cfinclude template="../query/get_action_account.cfm">
            #get_action_account.account_name# Hesabına
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='1195.Firma'></label>
        <span>: 
        	<cfif len(get_credit.action_from_company_id)>
                #get_par_info(get_credit.action_from_company_id,1,1,0)#
            <cfelse>
                #get_cons_info(get_credit.consumer_id,0,0)#
            </cfif>&nbsp;<cf_get_lang dictionary_id ='35541.Hesabından'>
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='261.Tutar'></label>
        <span>: #TLFormat(get_credit.sales_credit)# #get_action_account.account_currency_id#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='644.Dövizli Tutar'></label>
        <span>: #TLFormat(get_credit.other_cash_act_value)# #get_credit.other_money#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='217.Açıklama'></label>
        <span>: #get_credit.action_detail#</span>
    </div>
    <cfif len(get_credit.record_emp)>
        <div class="area_colmn">
            <label><cf_get_lang_main no='71.Kayıt'> </label>
            <span>: #get_emp_info(get_credit.record_emp,0,0)#</span>
        </div>
    <cfelseif len(get_credit.record_par)>
        <div class="area_colmn">
            <label><cf_get_lang_main no='71.Kayıt'> </label>
            <span>: #get_par_info(get_credit.record_par,0,-1,0)#</span>
        </div>    
    </cfif>
    </cfoutput>
<!---     <div class="area_colmn">
        <input type="button"  onclick="self.close();" value="<cf_get_lang_main no='141.Kapat'>">
    </div> --->
</hgroup>


