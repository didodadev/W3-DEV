<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfquery name="GET_CREDIT" datasource="#DSN3#">
	SELECT 
    	ACTION_DATE,
        ACCOUNT_ID,
        ACTION_TO_COMPANY_ID,
        CONS_ID,
        TOTAL_COST_VALUE,
        OTHER_COST_VALUE,
        OTHER_MONEY,
        DETAIL,
        RECORD_EMP,
        RECORD_DATE
	FROM 
		CREDIT_CARD_BANK_EXPENSE 
	WHERE 
		CREDITCARD_EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		<cfif isdefined("session.pp.company_id")>
			AND ACTION_TO_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		<cfelseif isdefined("session.ww.userid")> 
			AND CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>
</cfquery>

<hgroup class="finance_display">
    <h3><cf_get_lang_main no ='425.Kredi Kartı Ödeme'></h3>
    <cfoutput>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='330.Tarih'></label>
        <span>: #dateformat(get_credit.action_date,'dd/mm/yyyy')#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='240.Hesap'></label>
        <span>: 
			<cfset account_id=get_credit.account_id>
            <cfinclude template="../query/get_action_account.cfm">
            #get_action_account.account_name# Hesabından
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='1195.Firma'></label>
        <span>: 
        	<cfif len(get_credit.action_to_company_id)>
                #get_par_info(get_credit.action_to_company_id,1,1,0)#
            <cfelse>
                #get_cons_info(get_credit.cons_id,0,0)#
            </cfif>&nbsp;Hesabına
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='261.Tutar'></label>
       	<span>: #TLFormat(get_credit.total_cost_value)# #get_action_account.account_currency_id#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='644.Dövizli Tutar'></label>
        <span>: #TLFormat(get_credit.other_cost_value)# #get_credit.other_money#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang_main no ='217.Açıklama'></label>
        <span>: #get_credit.detail#</span>
    </div>
    <cfif len(get_credit.record_emp)>
        <div class="area_colmn">
            <label><cf_get_lang_main no='71.Kayıt'> </label>
            <span>: 
            	#get_emp_info(get_credit.record_emp,0,0)#
				<cfif isdefined("session.pp.time_zone")>
                    &nbsp;#DateFormat(date_add('h',session.pp.time_zone,get_credit.record_date),'dd/mm/yyyy')# 
                    #TimeFormat(date_add('h',session.pp.time_zone,get_credit.record_date),'HH:MM')#
                <cfelseif isdefined("session.ww.time_zone")> 
                    &nbsp;#DateFormat(date_add('h',session.ww.time_zone,get_credit.record_date),'dd/mm/yyyy')# 
                    #TimeFormat(date_add('h',session.ww.time_zone,get_credit.record_date),'HH:MM')#
                </cfif>
            </span>
        </div>
    </cfif>
    </cfoutput>
    <div class="area_colmn">
        <input type="button"  onclick="self.close();" value="<cf_get_lang_main no='141.Kapat'>">
    </div>
</hgroup>
