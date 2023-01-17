<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfif isdefined("attributes.id")>
	<cfset attributes.cheque_payroll_id = attributes.id>
</cfif>
<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfquery name="GET_PERIOD" datasource="#DSN#">
		SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>

<cfinclude template="../query/get_money_rate.cfm">
<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT 
    	PAYROLL_NO,
        COMPANY_ID,
        PAYROLL_CASH_ID,
        PAYROLL_REVENUE_DATE,
        PAYROLL_REV_MEMBER,
        PAYROLL_TOTAL_VALUE,
        RECORD_EMP,
        RECORD_DATE
    FROM 
    	VOUCHER_PAYROLL 
    WHERE 
        PAYROLL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.type#"> AND
        <cfif url.type eq 98>
	        PAYROLL_NO IN (SELECT PAPER_NO FROM CARI_ROWS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.type#">)        
        <cfelse>
	        ACTION_ID IN (SELECT VOUCHER_PAYROLL_ID FROM VOUCHER WHERE VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">)
		</cfif>
</cfquery>
<cfquery name="GET_VOUCHER_DETAIL" datasource="#db_adres#">
	SELECT
		VOUCHER.VOUCHER_NO,
        VOUCHER.VOUCHER_DUEDATE,
        VOUCHER.VOUCHER_VALUE,
        VOUCHER.CURRENCY_ID,
        VOUCHER.OTHER_MONEY_VALUE,
        VOUCHER.OTHER_MONEY
	FROM
		VOUCHER_HISTORY,
		VOUCHER
	WHERE
		<!---VOUCHER_HISTORY.PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND  --->
        VOUCHER.VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND
		VOUCHER.VOUCHER_ID = VOUCHER_HISTORY.VOUCHER_ID
</cfquery>

<hgroup class="finance_display">
    <h3>
		<cfif url.type eq 98>
            <cf_get_lang dictionary_id ='35584.Senet Çıkış Bordrosu (Ciro)'>
        <cfelseif url.type eq 101>
            <cf_get_lang dictionary_id ='35585.Senet  Çıkış İade Bordrosu'>
        <cfelseif url.type eq 97>
            <cf_get_lang dictionary_id ='58010.Senet Giriş Bordrosu'>
        <cfelseif url.type eq 108>
            <cf_get_lang dictionary_id ='58921.Senet Giriş İade Bordrosu'>
        </cfif>
    </h3>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='50202.Bordro No'></label>
            <span>: <cfif  len(get_action_detail.payroll_no) ><cfoutput>#get_action_detail.payroll_no#</cfoutput></cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58607.Firma'></label>
            <span>: <cfoutput>#get_par_info(get_action_detail.company_id,1,1,0)#</cfoutput></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57520.Kasa'></label>
            <span>: 
            	  <cfset cash_id=get_action_detail.payroll_cash_id>
                  <cfinclude template="../query/get_action_cash.cfm">
                  <cfoutput>#get_action_cash.cash_name#</cfoutput>
            </span>
        </div>
    </div>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='57742.Tarih'></label>
            <span>: <cfoutput>#dateformat(get_action_detail.payroll_revenue_date,'dd/mm/yyyy')#</cfoutput></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='58586.İşlem Yapan'></label>
            <span>: <cfoutput>#get_emp_info(get_action_detail.payroll_rev_member,0,0)#</cfoutput></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57483.Kayıt'></label>
            <span>: 
				<cfif isDefined('session.pp.userid') and len(get_action_detail.record_date)>
                    <cfoutput>#get_emp_info(get_action_detail.record_emp,0,0)#&nbsp;#dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#</cfoutput>
                <cfelseif isDefined('session.ww.userid') and len(get_action_detail.record_date)>
                    <cfoutput>#get_emp_info(get_action_detail.record_emp,0,0)#&nbsp;#dateformat(date_add('h',session.ww.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.ww.time_zone,get_action_detail.record_date),'HH:MM')#</cfoutput>                
                </cfif>
            </span>
        </div>
    </div>
    <div class="clear_area"></div>
    <table class="objects2_list">
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='58502.Senet No'></th>
                <th><cf_get_lang dictionary_id='57521.Banka'></th>
                <th><cf_get_lang dictionary_id='57453.Şube'></th>
                <th><cf_get_lang dictionary_id='57640.Vade'></th>
                <th><cf_get_lang dictionary_id='35578.İşlem Para Br'></th>
                <th><cf_get_lang dictionary_id='58177.Sistem Para Br'></th>
            </tr>
        </thead>
        <tbody>
        	<cfoutput query="get_voucher_detail">
                <tr class="odd">
                   <td>#voucher_no#</td>
                    <td></td>
                    <td></td>
                    <td>#dateformat(voucher_duedate,'dd/mm/yyyy')#</td>
                    <td>#tlformat(voucher_value)# #currency_id#</td>
                    <td>#tlformat(other_money_value)# #other_money#</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
    <div class="clear_area"></div>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58645.Nakit'></label><span>: </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='58007.Çek'></label><span>: <cfoutput>#TLFormat(get_action_detail.payroll_total_value)# #get_money_rate.money#</cfoutput></span>
        </div>
    </div>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='50233.Tahsil Eden'></label><span>: <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#get_emp_info(attributes.emp_id,0,0)#</cfoutput></cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57492.Toplam'></label><span>: <cfoutput>#TLFormat(get_action_detail.payroll_total_value)# #get_money_rate.money#</cfoutput></span>
        </div>
    </div>
</hgroup>
