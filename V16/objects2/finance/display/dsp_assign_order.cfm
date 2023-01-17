<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfquery name="GET_PERIOD" datasource="#DSN#">
		SELECT 
			PERIOD_ID, 
			PERIOD, 
			PERIOD_YEAR, 
			IS_INTEGRATED, 
			OUR_COMPANY_ID, 
			PERIOD_DATE, 
			OTHER_MONEY,
			STANDART_PROCESS_MONEY, 
			RECORD_DATE, 
			RECORD_IP, 
			RECORD_EMP, 
			UPDATE_DATE, 
			UPDATE_IP, 
			UPDATE_EMP,
			IS_LOCKED, 
			PROCESS_DATE 
		FROM 
			SETUP_PERIOD 
		WHERE 
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfif get_period.recordcount>
		<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
	<cfelse>
		<cfset db_adres = "#dsn2#">
	</cfif>
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>

<cfquery name="GET_ORDER" datasource="#db_adres#">
	SELECT 
		BON.BANK_ORDER_TYPE,
        BON.COMPANY_ID,
        BON.ACCOUNT_ID,
        BON.ACTION_VALUE,
        BON.ACTION_MONEY,
        BON.ACTION_DATE,
        BON.RECORD_EMP,
        BON.RECORD_DATE,
        BON.RECORD_PAR,
        BON.PAYMENT_DATE,
		BB.BANK_NAME,
		BB.BANK_BRANCH_NAME,
		A.ACCOUNT_NO
	FROM 
		BANK_ORDERS BON,
		#dsn3_alias#.ACCOUNTS AS A,
		#dsn3_alias#.BANK_BRANCH AS BB
	WHERE 		
		A.ACCOUNT_ID = BON.ACCOUNT_ID AND
		A.ACCOUNT_BRANCH_ID=BB.BANK_BRANCH_ID AND
		<cfif isdefined("attributes.id")>
			BON.BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		<cfelse>
			BON.BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_order_id#">
		</cfif>
</cfquery>

<hgroup class="finance_display">
    <h3><cf_get_lang no='1055.Banka Talimatı'></h3>
    <cfoutput query="get_order">
        <div class="area_colmn">
            <label><cf_get_lang no='1056.İşlem Adı'></label>
            <span>: <cfif bank_order_type eq 260><cf_get_lang_main no='755.Giden Banka Talimatı'><cfelseif bank_order_type eq 251><cf_get_lang_main no='753.Gelen Banka Talimatı'></cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='107.Cari Hesap'></label>
            <span>: #get_par_info(get_order.company_id,1,1,0)#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='109.Banka'></label>
            <span>: 
            	<cfif len(get_order.account_id)>
                    <cfquery name="GET_ACCOUNT" datasource="#DSN3#">
                        SELECT
                            ACCOUNT_NAME,
                            <cfif session_base.period_year lt 2009>
                                CASE WHEN(ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID
                            <cfelse>
                                ACCOUNT_CURRENCY_ID
                            </cfif>
                        FROM
                            ACCOUNTS
                        WHERE
                            ACCOUNT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order.account_id#">
                    </cfquery>
                    <cfoutput>#get_account.account_name# - #get_account.account_currency_id#</cfoutput>
                </cfif>
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='261.Tutar'></label>
            <span>: #TLFormat(get_order.action_value)# #get_order.action_money#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='1439.Ödeme Tarihi'></label>
            <span>: #dateformat(get_order.action_date,'dd/mm/yyyy')#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='467.İşlem Tarihi'></label>
            <span>: #dateformat(get_order.action_date,'dd/mm/yyyy')#</span>
        </div>
    </cfoutput>
    <cfif len(get_order.record_emp)>
        <div class="area_colmn">
            <label><cf_get_lang_main no='71.Kayıt'> </label>
            <span>: 
				<cfoutput>
                    #get_emp_info(get_order.record_emp,0,0)# - #dateformat(date_add('h',session_base.time_zone,get_order.record_date),'dd/mm/yyyy')#&nbsp;#timeformat(date_add('h',session_base.time_zone,get_order.record_date),'HH:MM')#
                </cfoutput>            
            </span>
        </div>
    <cfelseif len(get_order.record_par)>
        <div class="area_colmn">
            <label><cf_get_lang_main no='71.Kayıt'> </label>
            <span>: 
           		<cfoutput>
                    #get_par_info(get_order.record_par,0,-1,0)# - #dateformat(date_add('h',session_base.time_zone,get_order.record_date),'dd/mm/yyyy')#&nbsp;#timeformat(date_add('h',session_base.time_zone,get_order.record_date),'HH:MM')#
                </cfoutput>
            </span>
        </div>
	</cfif>
    <div class="area_colmn">
        <input type="button"  onClick="self.close();" value="<cf_get_lang_main no='141.Kapat'>">
    </div>    
</hgroup>

