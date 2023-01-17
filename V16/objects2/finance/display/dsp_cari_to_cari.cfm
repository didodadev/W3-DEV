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
        ACTION_DATE,
        ACTION_VALUE,
        ACTION_CURRENCY_ID,
        ACTION_DETAIL,
        OTHER_CASH_ACT_VALUE,
        OTHER_MONEY,
        TO_CMP_ID,
        TO_CONSUMER_ID,
        FROM_CMP_ID,
        FROM_CONSUMER_ID, 
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
		UPDATE_DATE
	FROM 
		CARI_ACTIONS 
	WHERE 
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND 
		<cfif isdefined("session.pp.company_id")>
			(FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
		<cfelseif isdefined("session.ww.userid")>
			(FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">)
		</cfif>
</cfquery>

<hgroup class="finance_display">
    <h3><cf_get_lang dictionary_id ='29567.Cari Virman'></h3>
    <cfoutput>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='61806.İşlem Tipi'></label>
        <span>: #get_credit.action_name#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='57742.Tarih'></label>
        <span>: #DateFormat(get_credit.action_date,'dd/mm/yyyy')#</span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='56955.Borçlu Hesap'></label>
        <span>: 
			<cfif len(get_credit.to_cmp_id)>
                #get_par_info(get_credit.to_cmp_id,1,1,0)#
            <cfelseif len(get_credit.to_consumer_id)>
                #get_cons_info(get_credit.to_consumer_id,0,0)#
            </cfif>
        </span>
    </div>
    <div class="area_colmn">
        <label><cf_get_lang dictionary_id ='34115.Alacaklı Hesap'></label>
       	<span>: 
        	<cfif len(get_credit.from_cmp_id)>
                #get_par_info(get_credit.from_cmp_id,1,1,0)#
            <cfelseif len(get_credit.from_consumer_id)>
                #get_cons_info(get_credit.from_consumer_id,0,0)#
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
        <label><cf_get_lang dictionary_id ='57629.Açıklama'></label>
        <span>: #get_credit.action_detail#</span>
    </div>
    <cfif len(get_credit.record_emp)>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='57483.Kayıt'> </label>
            <span>: 
            	<cfif isDefined('session.pp.userid')>
                	#get_emp_info(get_credit.update_emp,0,0)#&nbsp;#dateformat(date_add('h',session.pp.time_zone,get_credit.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_credit.record_date),'HH:MM')#
                <cfelseif isDefined('session.ww.userid')>
                	#get_emp_info(get_credit.update_emp,0,0)#&nbsp;#dateformat(date_add('h',session.ww.time_zone,get_credit.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_credit.record_date),'HH:MM')#                
                </cfif>
            </span>
        </div>
        <cfif len(get_credit.update_emp)>
            <div class="area_colmn">
                <label><cf_get_lang dictionary_id ='29437.Son Güncelleyen'> </label>
                <span>: 
                	<cfif isDefined('session.pp.userid')> 
                    	#get_emp_info(get_credit.update_emp,0,0)# - #dateformat(date_add('h',session.pp.time_zone,get_credit.update_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_credit.update_date),'HH:MM')#
                    <cfelseif isDefined('session.ww.userid')>
                    	#get_emp_info(get_credit.update_emp,0,0)# - #dateformat(date_add('h',session.ww.time_zone,get_credit.update_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.ww.time_zone,get_credit.update_date),'HH:MM')#                    
                    </cfif>
                </span>
            </div>
        </cfif>
    </cfif>
<!---     <div class="area_colmn">
        <input type="button"  onClick="self.close();" value="Kapat">
    </div> --->
    </cfoutput>
</hgroup>
