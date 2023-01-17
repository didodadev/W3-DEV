<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
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

<cfquery name="GET_CARI_OPEN_ROW" datasource="#db_adres#">
	SELECT 
		CR.ACTION_CURRENCY_ID,
		CR.CARI_ACTION_ID,
		CR.ACTION_NAME,
		CR.PROCESS_CAT, 
		CR.TO_CMP_ID, 
		CR.FROM_CMP_ID, 
		CR.FROM_CONSUMER_ID,
		CR.TO_CONSUMER_ID,
		CR.ACTION_VALUE,
		CR.OTHER_CASH_ACT_VALUE,
		CR.OTHER_MONEY,
		CR.DUE_DATE,
		CR.ACTION_DATE,
		CR.ACTION_VALUE_2,
		CR.ACTION_CURRENCY_2,
		<cfif isdefined("session.pp.company_id")>
			C.FULLNAME
		<cfelseif isdefined("session.ww.userid")>
			C.CONSUMER_NAME,
			C.CONSUMER_SURNAME
		</cfif>
	FROM 
		CARI_ROWS CR,
		<cfif isdefined("session.pp.company_id")>
			#dsn_alias#.COMPANY C
		<cfelseif isdefined("session.ww.userid")>
			#dsn_alias#.CONSUMER C
		</cfif>
	WHERE		
		CR.ACTION_TYPE_ID=40
		AND CR.CARI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cari_act_id#">
		<cfif isdefined("session.pp.company_id")>
			AND (CR.FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR CR.TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
			AND (CR.FROM_CMP_ID = C.COMPANY_ID OR CR.TO_CMP_ID = C.COMPANY_ID)
		<cfelseif isdefined("session.ww.userid")> 
			AND (CR.FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR CR.TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">)
			AND (CR.FROM_CONSUMER_ID = C.CONSUMER_ID OR CR.TO_CONSUMER_ID = C.CONSUMER_ID)
		</cfif>
</cfquery>

<cfinclude template="../query/get_money_rate.cfm">
<hgroup class="finance_display">
    <h3><cf_get_lang_main no='75.Açılış/Devir Fişi'></h3>
    <cfoutput query="get_cari_open_row">
        <div class="area_colmn">
            <label><cf_get_lang_main no='240.Hesap'></label>
            <span>:
                <cfif isdefined("session.pp.company_id")>
                    #fullname#
                <cfelseif isdefined("session.ww.userid")>
                    #consumer_name# #consumer_surname#
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='217.Açıklama'></label>
            <span>: #action_name#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='467.İşlem Tarihi'></label>
            <span>: #dateformat(action_date,'dd/mm/yyyy')#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='1439.Ödeme Tarihi'></label>
            <span>: #dateformat(due_date,'dd/mm/yyyy')#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='175.Borç'></label>
            <span>: 
            	#TLFormat(action_value,2)#&nbsp;
				<cfif isdefined("session.pp.money")>
                    #session.pp.money#
                <cfelseif isdefined("session.ww.money")>
                    #session.ww.money#
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='176.Alacak'></label>
            <span>: 
            	#TLFormat(action_value,2)#&nbsp;
				<cfif isdefined("session.pp.money")>
                    #session.pp.money#
                <cfelseif isdefined("session.ww.money")>
                    #session.ww.money#
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='1493.Sistem Dövizi'></label>
            <span>: 
				<cfif len(get_cari_open_row.action_value_2)>#TLFormat(get_cari_open_row.action_value_2,2)#</cfif>
				<cfif isdefined("session.pp.money2") and len(session.pp.money2)>
                    &nbsp;#session.pp.money2#
                <cfelseif isdefined("session.ww.money2") and len(session.ww.money2)>
                    &nbsp;#session.ww.money2#
                </cfif>
            </span>
        </div>
   <!---      <div class="area_colmn">
            <input type="button"  onClick="self.close();" value="<cf_get_lang_main no='141.Kapat'>">
        </div> --->
    </cfoutput>
</hgroup>

