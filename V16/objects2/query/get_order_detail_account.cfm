<cfquery name="GET_GENERAL_PROM" datasource="#DSN3#" maxrows="1">
	SELECT 
		COMPANY_ID, 
		LIMIT_VALUE, 
		DISCOUNT, 
		AMOUNT_DISCOUNT, 
		PROM_ID,
		LIMIT_CURRENCY
	FROM 
		PROMOTIONS 
	WHERE 
		PROM_STATUS = 1 AND 
		PROM_TYPE = 0 AND 
		LIMIT_TYPE <> 1 AND 
		LIMIT_VALUE IS NOT NULL AND 
		DISCOUNT IS NOT NULL AND 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN STARTDATE AND FINISHDATE
	ORDER BY
		PROM_ID DESC
</cfquery>
<cfquery name="GET_BANK" datasource="#DSN3#">
	SELECT
		<cfif session_base.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		ACCOUNTS.ACCOUNT_NO,
		ACCOUNTS.ACCOUNT_BRANCH_ID,
        ACCOUNTS.ACCOUNT_OWNER_CUSTOMER_NO,
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		ACCOUNTS.BRANCH_CODE,
		BANK_BRANCH.BANK_ID,
		BANK_BRANCH.BANK_BRANCH_NAME,
		SETUP_BANK_TYPES.BANK_NAME
	FROM
		ACCOUNTS,
		BANK_BRANCH,
		#DSN#.SETUP_BANK_TYPES
	WHERE
		BANK_BRANCH.BANK_ID = SETUP_BANK_TYPES.BANK_ID AND
		ACCOUNTS.IS_INTERNET=1 AND
		ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND
		(ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money#"> OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
		<cfif isdefined('session.pp.userid')>
			AND ACCOUNTS.IS_PARTNER = 1
		<cfelseif isdefined('session.ww.userid')>
			AND ACCOUNTS.IS_PUBLIC = 1
		</cfif>
</cfquery>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_CREDIT" datasource="#DSN#">
		SELECT MONEY, PAYMETHOD_ID, SHIP_METHOD_ID, OPEN_ACCOUNT_RISK_LIMIT, IS_INSTALMENT_INFO, REVMETHOD_ID FROM COMPANY_CREDIT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
	</cfquery>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="GET_CREDIT" datasource="#DSN#">
		SELECT MONEY, PAYMETHOD_ID, 0 SHIP_METHOD_ID, OPEN_ACCOUNT_RISK_LIMIT, 0 IS_INSTALMENT_INFO, REVMETHOD_ID FROM COMPANY_CREDIT WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
</cfif>
<cfif isDefined('get_credit.revmethod_id') and len(get_credit.revmethod_id)>
	<cfquery name="GET_DUE_DAY" datasource="#DSN#">
		SELECT DUE_DAY FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit.revmethod_id#">
	</cfquery>
</cfif>
<cfquery name="GET_SHIPMETHOD" datasource="#DSN#">
	SELECT 
    	SHIP_METHOD_ID,
        SHIP_METHOD,SHIP_DAY 
    FROM 
    	SHIP_METHOD 
    WHERE 
    	IS_INTERNET = 1
</cfquery>

<cfif session_base.language neq 'tr'>
	<cfquery name="GET_FOR_SHIP_METS" dbtype="query">
    	SELECT 
        	* 
        FROM 
        	GET_ALL_FOR_LANGS 
        WHERE 
        	TABLE_NAME = 'SHIP_METHOD' AND 
            COLUMN_NAME = 'SHIP_METHOD' 
    </cfquery>
</cfif>

<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_COMPANY_RISK" datasource="#DSN2#">
		SELECT TOTAL_RISK_LIMIT,BAKIYE,CEK_ODENMEDI,SENET_ODENMEDI,CEK_KARSILIKSIZ,SENET_KARSILIKSIZ FROM COMPANY_RISK WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
	<cfif isdefined("attributes.is_not_use_risk") and attributes.is_not_use_risk eq 1>
		<cfquery name="GET_COMPANY_BAKIYE" datasource="#DSN2#">
			SELECT ISNULL(ROUND(SUM(BORC-ALACAK),2),0) TOTAL_BAKIYE FROM CARI_ROWS_TOPLAM WHERE DUE_DATE < #createodbcdatetime(dateadd('d',-1,now()))# AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<cfif isdefined("attributes.use_risk_limit") and len(attributes.use_risk_limit)>
			<cfset get_company_bakiye.total_bakiye = get_company_bakiye.total_bakiye - attributes.use_risk_limit>
		</cfif>
	<cfelse>
		<cfset get_company_bakiye.total_bakiye = 0>
	</cfif>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="GET_COMPANY_RISK" datasource="#DSN2#">
		SELECT TOTAL_RISK_LIMIT,BAKIYE,CEK_ODENMEDI,SENET_ODENMEDI,CEK_KARSILIKSIZ,SENET_KARSILIKSIZ FROM CONSUMER_RISK WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
	<cfif isdefined("attributes.is_not_use_risk") and attributes.is_not_use_risk eq 1>
		<cfquery name="GET_COMPANY_BAKIYE" datasource="#dsn2#">
			SELECT ISNULL(ROUND(SUM(BORC-ALACAK),2),0) TOTAL_BAKIYE FROM CARI_ROWS_CONSUMER WHERE ACTION_TYPE_ID <> 41 AND ((DUE_DATE < #createodbcdatetime(dateadd('d',-1,now()))# AND ACTION_TYPE_ID IN(40,53)) OR (ACTION_TYPE_ID NOT IN(40,53))) AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfquery>
		<cfif isdefined("attributes.use_risk_limit") and len(attributes.use_risk_limit)>
			<cfset get_company_bakiye.total_bakiye = get_company_bakiye.total_bakiye - attributes.use_risk_limit>
		</cfif>
	<cfelse>
		<cfset get_company_bakiye.total_bakiye = 0>
	</cfif>
<cfelse>
	<cfset get_company_bakiye.recordcount = 0>
	<cfset get_company_bakiye.total_bakiye = 0>
</cfif>

<!--- BK 20140220 Son iki yila ait kontroller yapilacak. Altta ORDERS tablosu icinde son iki yila bakilacak.--->
<cfquery name="GET_PER_COMP_" datasource="#DSN#">
	SELECT
		PERIOD_YEAR
	FROM
		SETUP_PERIOD
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#"> AND
        (PERIOD_YEAR  = YEAR(GETDATE()) OR PERIOD_YEAR  = (YEAR(GETDATE())-1))
</cfquery>

<cfset list_period_year=valuelist(get_per_comp_.period_year,',')>

<cfquery name="GET_ORDER_BAKIYE" datasource="#DSN3#">
	SELECT
		ISNULL(SUM(NETTOTAL),0) NETTOTAL
	FROM
		ORDERS
	WHERE
		ORDER_STATUS = 1 AND
		ISNULL(IS_MEMBER_RISK,1) = 1 AND <!--- riske dahil olan siparisler alınıyor. --->
		((PURCHASE_SALES = 1 AND ORDER_ZONE=0) OR (PURCHASE_SALES=0 AND ORDER_ZONE=1)) AND
        YEAR(ORDER_DATE) IN(#list_period_year#) <!--- son iki yilin siparisleri --->
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
            AND COMPANY_ID = #attributes.company_id#
        <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
            AND CONSUMER_ID = #attributes.consumer_id#
        </cfif>
        <cfif listlen(list_period_year,',')>
            AND ORDER_ID NOT IN
            (
                <cfloop list="#list_period_year#" index="per_year_ind">
                    SELECT OS.ORDER_ID FROM ORDERS_SHIP OS,#dsn#_#per_year_ind#_#int_comp_id#.INVOICE_SHIPS AS I_S WHERE OS.SHIP_ID=I_S.SHIP_ID AND OS.ORDER_ID=ORDERS.ORDER_ID
                    UNION
                    SELECT BO.ORDER_ID FROM #dsn#_#per_year_ind#_#int_comp_id#.BANK_ORDERS AS BO WHERE BO.ORDER_ID=ORDERS.ORDER_ID
                    <cfif listlast(list_period_year,',') neq per_year_ind>UNION</cfif>
                </cfloop>
            )
        </cfif>
</cfquery>
<cfquery name="GET_HAVALE" datasource="#DSN#" maxrows="1"><!--- standart ödeme yöntemlernden uygun havale ödeme yöntemi alınır --->
	SELECT 
		PAYMETHOD_ID,
		PAYMETHOD,
		DUE_DAY,
		FIRST_INTEREST_RATE 
	FROM 
		SETUP_PAYMETHOD 
	WHERE 
		IN_ADVANCE = 100 AND<!--- peşinat oranı ---> 
		DUE_DAY = 0 AND<!--- vade gün ---> 
		PAYMENT_VEHICLE = 3 <!--- ödeme aracı havale --->
		<cfif isdefined('session.pp.userid')>
			AND IS_PARTNER = 1
		<cfelse>
			AND IS_PUBLIC = 1
		</cfif>
</cfquery>
<cfif isdefined('attributes.is_door_paymethod_multiple') and attributes.is_door_paymethod_multiple eq 1>
	<cfquery name="GET_DOOR_PAYMETHOD" datasource="#DSN#"><!--- eğer kapıda ödeme birden fazlasından seçilecekse --->
		SELECT 
			PAYMETHOD_ID,
			PAYMETHOD,
			DUE_DAY,
			FIRST_INTEREST_RATE 
		FROM 
			SETUP_PAYMETHOD 
		WHERE 
			IN_ADVANCE = 100 AND<!--- peşinat oranı ---> 
			DUE_DAY = 0 AND<!--- vade gün ---> 
			PAYMENT_VEHICLE = 7 <!--- ödeme aracı kapıda ödeme --->
			<cfif isdefined('session.pp.userid')>
				AND IS_PARTNER = 1
			<cfelse>
				AND IS_PUBLIC = 1
			</cfif>
	</cfquery>
<cfelse>
	<cfquery name="GET_DOOR_PAYMETHOD" datasource="#DSN#" maxrows="1"><!--- standart ödeme yöntemlernden uygun kapıda ödeme yöntemi alınır --->
		SELECT 
			PAYMETHOD_ID,
			PAYMETHOD,
			DUE_DAY,
			FIRST_INTEREST_RATE 
		FROM 
			SETUP_PAYMETHOD 
		WHERE 
			IN_ADVANCE = 100 AND<!--- peşinat oranı ---> 
			DUE_DAY = 0 AND<!--- vade gün ---> 
			PAYMENT_VEHICLE = 7 <!--- ödeme aracı kapıda ödeme --->
			<cfif isdefined('session.pp.userid')>
				AND IS_PARTNER = 1
			<cfelse>
				AND IS_PUBLIC = 1
			</cfif>
	</cfquery>
</cfif>
<cfif isDefined("attributes.campaign_id") and len(attributes.campaign_id)>
	<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
		SELECT
			ACCOUNTS.ACCOUNT_ID,
			ACCOUNTS.ACCOUNT_NAME,
			<cfif session_base.period_year lt 2009>
				CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
			<cfelse>
				ACCOUNTS.ACCOUNT_CURRENCY_ID,
			</cfif>
			CPT.PAYMENT_TYPE_ID,
			CPT.FIRST_INTEREST_RATE,
			CPT.CARD_NO,
			CPT.CARD_IMAGE,
			CPT.CARD_IMAGE_SERVER_ID,
			CPT.POS_TYPE,
			CPT.SERVICE_RATE,
			CPT.NUMBER_OF_INSTALMENT, 
			CP.SERVICE_COMM_MULTIPLIER COMMISSION_MULTIPLIER,
			CPT.COMMISSION_MULTIPLIER_DSP,
			CPT.DUEDATE,
			CPT.VFT_CODE
		FROM
			ACCOUNTS ACCOUNTS,
			CREDITCARD_PAYMENT_TYPE CPT,
			CAMPAIGN_PAYMETHODS CP
		WHERE
			CP.PAYMETHOD_ID = CPT.PAYMENT_TYPE_ID AND
			CP.COMMISSION_RATE IS NOT NULL AND
			CP.CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#"> AND
			CP.USED_IN_CAMPAIGN = 1 AND
			(ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money#"> OR ACCOUNT_CURRENCY_ID = 'TL') AND
			ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
			CPT.IS_ACTIVE = 1 AND
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and get_credit.IS_INSTALMENT_INFO neq 1>
				(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				CPT.IS_PARTNER = 1 AND
			<cfelse>
				CPT.IS_PUBLIC = 1 AND
			</cfif>
			CPT.POS_TYPE IS NOT NULL<!---Sanal pos tipleri bilgisi--->
		ORDER BY
			CARD_NO
	</cfquery>
<cfelse>	
	<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
		SELECT
			ACCOUNTS.ACCOUNT_ID,
			ACCOUNTS.ACCOUNT_NAME,
			<cfif session_base.period_year lt 2009>
				CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
			<cfelse>
				ACCOUNTS.ACCOUNT_CURRENCY_ID,
			</cfif>
			CPT.PAYMENT_TYPE_ID,
			CPT.FIRST_INTEREST_RATE,
			CPT.CARD_NO,
			CPT.CARD_IMAGE,
			CPT.CARD_IMAGE_SERVER_ID,
			CPT.POS_TYPE,
			CPT.SERVICE_RATE,
			CPT.NUMBER_OF_INSTALMENT, 
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				CPT.COMMISSION_MULTIPLIER,
				CPT.COMMISSION_MULTIPLIER_DSP,
			<cfelse>
				CPT.PUBLIC_COMMISSION_MULTIPLIER COMMISSION_MULTIPLIER,
				CPT.PUBLIC_COM_MULTIPLIER_DSP COMMISSION_MULTIPLIER_DSP,
			</cfif>
			CPT.DUEDATE,
			CPT.VFT_CODE
		FROM
			ACCOUNTS ACCOUNTS,
			CREDITCARD_PAYMENT_TYPE CPT
		WHERE
			(ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money#"> OR ACCOUNT_CURRENCY_ID = 'TL') AND
			ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
			CPT.IS_ACTIVE = 1 AND
			ISNULL(CPT.IS_SPECIAL,0) <> 1 AND
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and get_credit.IS_INSTALMENT_INFO neq 1>
				(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				CPT.IS_PARTNER = 1 AND
			<cfelse>
				CPT.IS_PUBLIC = 1 AND
			</cfif>
			CPT.POS_TYPE IS NOT NULL<!---Sanal pos tipleri bilgisi--->
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			UNION ALL
				SELECT
					ACCOUNTS.ACCOUNT_ID,
					ACCOUNTS.ACCOUNT_NAME,
					<cfif session_base.period_year lt 2009>
						CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
					<cfelse>
						ACCOUNTS.ACCOUNT_CURRENCY_ID,
					</cfif>
					CPT.PAYMENT_TYPE_ID,
					CPT.FIRST_INTEREST_RATE,
					CPT.CARD_NO,
					CPT.CARD_IMAGE,
					CPT.CARD_IMAGE_SERVER_ID,
					CPT.POS_TYPE,
					CPT.SERVICE_RATE,
					CPT.NUMBER_OF_INSTALMENT, 
					<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
						CPT.COMMISSION_MULTIPLIER,
						CPT.COMMISSION_MULTIPLIER_DSP,
					<cfelse>
						CPT.PUBLIC_COMMISSION_MULTIPLIER COMMISSION_MULTIPLIER,
						CPT.PUBLIC_COM_MULTIPLIER_DSP COMMISSION_MULTIPLIER_DSP,
					</cfif>
					CPT.DUEDATE,
					CPT.VFT_CODE
				FROM
					ACCOUNTS ACCOUNTS,
					CREDITCARD_PAYMENT_TYPE CPT
				WHERE
					(ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money#"> OR ACCOUNT_CURRENCY_ID = 'TL') AND
					ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
					CPT.IS_ACTIVE = 1 AND
					CPT.IS_SPECIAL = 1 AND<!--- ödeme yöntemi özelse ve bu üye seçili üye listesindense ve ödeme yöntemi geçerlilk süresindeyse..AE --->
					CPT.PAYMENT_TYPE_ID IN (SELECT CC_PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE_MEMBER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND (#now()# BETWEEN START_DATE AND DATEADD(day,1,FINISH_DATE))) AND
					<cfif isdefined("attributes.company_id") and len(attributes.company_id) and get_credit.IS_INSTALMENT_INFO neq 1>
						(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
					</cfif>
					<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
						CPT.IS_PARTNER = 1 AND
					<cfelse>
						CPT.IS_PUBLIC = 1 AND
					</cfif>
					CPT.POS_TYPE IS NOT NULL<!---Sanal pos tipleri bilgisi--->
		</cfif>
		ORDER BY
			CARD_NO
	</cfquery>
</cfif>
