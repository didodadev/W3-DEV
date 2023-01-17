<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfquery name="GET_PERIOD" datasource="#DSN#">
		SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfif get_period.recordcount>
		<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
	<cfelse>
		<cfset db_adres = "#dsn2#">
	</cfif>
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>

<cfquery name="GET_CREDIT" datasource="#db_adres#">
	SELECT 
    	ACTION_NAME, 
        FROM_CMP_ID, 
        TO_CMP_ID, 
        FROM_CONSUMER_ID, 
        TO_CONSUMER_ID,
        ACTION_VALUE,
        ACTION_CURRENCY_ID,
        OTHER_CASH_ACT_VALUE,
        OTHER_MONEY,
        ACTION_DETAIL,
        ACTION_DATE,
        RECORD_EMP,
        ACTION_ACCOUNT_CODE,
        RECORD_DATE 
    FROM 
    	CARI_ACTIONS 
    WHERE 
    	ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>

<hgroup class="finance_display">
    <h3><cf_get_lang dictionary_id ='57587.Borç'> / <cf_get_lang dictionary_id ='57848.Alacak Dekontu'></h3>
    <cfoutput>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id = '61806.İşlem Tipi'></label>
        <span>: #get_credit.action_name#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='58607.Firma'></label>
        <span>: 
			<cfif len(get_credit.from_cmp_id)>
                #get_par_info(get_credit.from_cmp_id,1,1,0)#
            <cfelseif len(get_credit.to_cmp_id)>
                #get_par_info(get_credit.to_cmp_id,1,1,0)#
            <cfelseif len(get_credit.from_consumer_id)>
                #get_cons_info(get_credit.from_consumer_id,0,0)#
            <cfelseif len(get_credit.to_consumer_id)>
                #get_cons_info(get_credit.to_consumer_id,0,0)#
            </cfif>
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='57673.Tutar'></label>
        <span>: #TLFormat(get_credit.action_value)# #get_credit.action_currency_id#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='58056.Dövizli Tutar'></label>
        <span>: #TLFormat(get_credit.other_cash_act_value)# #get_credit.other_money#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></label>
        <span>: #get_credit.action_account_code#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='57742.Tarih'></label>
        <span>: #dateformat(get_credit.action_date,'dd/mm/yyyy')#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='57629.Açıklama'></label>
        <span>: #get_credit.action_detail#</span>
    </div>
    <cfif len(get_credit.record_emp)>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='57483.Kayıt'> </label>
            <span>: 
                #get_emp_info(get_credit.record_emp,0,0)#
                <cfif isdefined('session.ep')>
                    &nbsp;#dateformat(date_add('h',session.ep.time_zone,get_credit.record_date),'dd/mm/yyyy')# 
                    #timeformat(date_add('h',session.ep.time_zone,get_credit.record_date),'HH:MM')#
                <cfelseif isDefined('session.pp.userid')>
                    &nbsp;#dateformat(date_add('h',session.pp.time_zone,get_credit.record_date),'dd/mm/yyyy')# 
                    #timeformat(date_add('h',session.pp.time_zone,get_credit.record_date),'HH:MM')#
                <cfelseif isDefined('session.ww.userid')>
                    &nbsp;#dateformat(date_add('h',session.ww.time_zone,get_credit.record_date),'dd/mm/yyyy')# 
                    #timeformat(date_add('h',session.ww.time_zone,get_credit.record_date),'HH:MM')#
                </cfif>
            </span>
        </div>
    </cfif>
    </cfoutput>
<!---     <div class="area_colmn">
        <input type="button"  onclick="self.close();" value="<cf_get_lang_main no='141.Kapat'>">
    </div> --->
</hgroup>
