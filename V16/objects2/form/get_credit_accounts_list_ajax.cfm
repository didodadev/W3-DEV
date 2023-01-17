<cfsetting showdebugoutput="no">
<!--- limit aşımında tek çekim kredi kartlarının gelmesi gerekiyor. --->
<cfscript>
	if(isDefined("session.ep"))
		int_comp_id = session_base.company_id;
	else
		int_comp_id = session_base.our_company_id;
	int_period_id = session_base.period_id;
	int_money = session_base.money;
	int_money2 = session_base.other_money;
</cfscript>
<cfif isdefined('attributes.is_basis_of_receiving') and attributes.is_basis_of_receiving eq 1>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_COMPANY_RISK" datasource="#dsn2#">
			SELECT TOTAL_RISK_LIMIT,BAKIYE,CEK_ODENMEDI,SENET_ODENMEDI,CEK_KARSILIKSIZ,SENET_KARSILIKSIZ FROM COMPANY_RISK WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfquery name="GET_COMPANY_RISK" datasource="#dsn2#">
			SELECT TOTAL_RISK_LIMIT,BAKIYE,CEK_ODENMEDI,SENET_ODENMEDI,CEK_KARSILIKSIZ,SENET_KARSILIKSIZ FROM CONSUMER_RISK WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfquery>
	<cfelse>
		<cfset get_company_risk.recordcount = 0>
	</cfif>
	<cfquery name="GET_PER_COMP_" datasource="#DSN#">
		SELECT
			PERIOD_YEAR
		FROM
			SETUP_PERIOD
		WHERE
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
	</cfquery>
	<cfset list_period_year=valuelist(get_per_comp_.period_year,',')>
	<!--- <cfquery name="GET_ORDER_BAKIYE" datasource="#DSN3#">  LS HATALI, PERFORMANS SORUNLU VE COMPANY_ID NEDEN CEKILDIGI ANLASILMADIGI ICIN KAPATILDI 05.09.2013
		SELECT 
			SUM(NETTOTAL) NETTOTAL, 
			COMPANY_ID 
		FROM 
			ORDERS 
		WHERE 
			ORDER_STATUS = 1 AND
			ISNULL(IS_MEMBER_RISK,1) = 1 AND <!--- riske dahil olan siparisler alınıyor. --->
			((PURCHASE_SALES = 1 AND ORDER_ZONE=0) OR (PURCHASE_SALES=0 AND ORDER_ZONE=1))
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
				AND IS_PAID <> 1
			<cfif listlen(list_period_year,',')>
				AND
				<cfloop list="#list_period_year#" index="per_year_ind">
					ORDER_ID NOT IN (SELECT OS.ORDER_ID FROM ORDERS_SHIP OS,#dsn#_#per_year_ind#_#int_comp_id#.INVOICE_SHIPS AS I_S WHERE OS.SHIP_ID=I_S.SHIP_ID AND OS.ORDER_ID=ORDERS.ORDER_ID)
					AND ORDER_ID NOT IN (SELECT BO.ORDER_ID FROM #dsn#_#per_year_ind#_#int_comp_id#.BANK_ORDERS AS BO WHERE BO.ORDER_ID=ORDERS.ORDER_ID)
					<cfif listlast(list_period_year,',') neq per_year_ind>AND</cfif>
				</cfloop>
			</cfif>
		GROUP BY 
			COMPANY_ID
	</cfquery> --->
	<cfquery name="GET_ORDER_BAKIYE" datasource="#DSN3#">
		SELECT 
			SUM(NETTOTAL) NETTOTAL
		FROM 
			ORDERS 
		WHERE 
			ORDER_STATUS = 1 AND
			ISNULL(IS_MEMBER_RISK,1) = 1 AND <!--- riske dahil olan siparisler alınıyor. --->
			((PURCHASE_SALES = 1 AND ORDER_ZONE=0) OR (PURCHASE_SALES=0 AND ORDER_ZONE=1))
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
				AND IS_PAID <> 1
			<cfif listlen(list_period_year,',')>
				AND ORDER_ID NOT IN ( 
				<cfloop list="#list_period_year#" index="per_year_ind">
					SELECT OS.ORDER_ID FROM ORDERS_SHIP OS,#dsn#_#per_year_ind#_#int_comp_id#.INVOICE_SHIPS AS I_S WHERE OS.SHIP_ID=I_S.SHIP_ID AND OS.ORDER_ID=ORDERS.ORDER_ID)
					UNION 
                    SELECT BO.ORDER_ID FROM #dsn#_#per_year_ind#_#int_comp_id#.BANK_ORDERS AS BO WHERE BO.ORDER_ID=ORDERS.ORDER_ID
					<cfif listlast(list_period_year,',') neq per_year_ind>UNION</cfif>
				</cfloop>
                )
			</cfif>
	</cfquery>    
</cfif>
<cfif isDefined("attributes.campaign_id") and len(attributes.campaign_id)>
	<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
		SELECT DISTINCT OCPR.POS_ID,
			ACCOUNTS.ACCOUNT_ID,
			ACCOUNTS.ACCOUNT_NAME,
			<cfif session_base.period_year lt 2009>
				CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
			<cfelse>
				ACCOUNTS.ACCOUNT_CURRENCY_ID,
			</cfif>
			CPT.PAYMENT_TYPE_ID,
			ISNULL(CPT.FIRST_INTEREST_RATE,0) AS FIRST_INTEREST_RATE,
			CPT.CARD_NO,
			CPT.CARD_IMAGE,
			CPT.CARD_IMAGE_SERVER_ID,
			OCPR.POS_ID POS_TYPE,
			CPT.SERVICE_RATE,
			CPT.NUMBER_OF_INSTALMENT, 
			CP.SERVICE_COMM_MULTIPLIER COMMISSION_MULTIPLIER,
			CPT.COMMISSION_MULTIPLIER_DSP,
			CPT.DUEDATE,
			CPT.VFT_CODE,
			CPT.VFT_RATE,
			OCPR.IS_SECURE
		FROM
			ACCOUNTS ACCOUNTS,
			CREDITCARD_PAYMENT_TYPE CPT,
			CAMPAIGN_PAYMETHODS CP,
			#dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
		WHERE
			CP.PAYMETHOD_ID = CPT.PAYMENT_TYPE_ID AND
			CP.COMMISSION_RATE IS NOT NULL AND
			CP.CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#"> AND
			CP.USED_IN_CAMPAIGN = 1 AND
			(ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money#"> OR ACCOUNT_CURRENCY_ID = 'TL') AND
			ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
			OCPR.POS_ID = CPT.POS_TYPE AND
			CPT.IS_ACTIVE = 1 AND
			<cfif isDefined('attributes.is_ins_pay') and attributes.is_ins_pay eq 1>
                CPT.NUMBER_OF_INSTALMENT = 0 AND
            </cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and attributes.is_instalment_info neq 1>
				(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				CPT.IS_PARTNER = 1 AND
				<!--- ACCOUNTS.IS_PARTNER = 1 AND --->
			<cfelse>
				CPT.IS_PUBLIC = 1 AND
				<!--- ACCOUNTS.IS_PUBLIC = 1 AND --->
			</cfif>
			CPT.POS_TYPE IS NOT NULL AND<!---Sanal pos tipleri bilgisi--->
			CPT.POS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_type_id#">
			<cfif isdefined("attributes.credit_card_bank_payment_list") and len(attributes.credit_card_bank_payment_list)>
				AND (ISNULL(CPT.IS_PROM_CONTROL,0) = 0 OR CPT.PAYMENT_TYPE_ID IN (#attributes.credit_card_bank_payment_list#))
			<cfelse>
				AND ISNULL(CPT.IS_PROM_CONTROL,0) = 0
			</cfif>
			<!--- Odeme Yonteminde tanimlanan public minimum tutar kontrolu yapiliyor GA 05032013--->
            AND ISNULL(CPT.PUBLIC_MIN_AMOUNT,0) <= #attributes.nettotal#
	UNION ALL
		SELECT
			 DISTINCT OCPR.POS_ID,
			0 AS ACCOUNT_ID,
			OCPR.POS_NAME AS ACCOUNT_NAME,
			'#session_base.money#' AS ACCOUNT_CURRENCY_ID,
			CPT.PAYMENT_TYPE_ID,
			ISNULL(CPT.FIRST_INTEREST_RATE,0) AS FIRST_INTEREST_RATE,
			CPT.CARD_NO,
			CPT.CARD_IMAGE,
			CPT.CARD_IMAGE_SERVER_ID,
			OCPR.POS_ID POS_TYPE,
			CPT.SERVICE_RATE,
			CPT.NUMBER_OF_INSTALMENT, 
			CP.SERVICE_COMM_MULTIPLIER COMMISSION_MULTIPLIER,
			CPT.COMMISSION_MULTIPLIER_DSP,
			CPT.DUEDATE,
			CPT.VFT_CODE,
			CPT.VFT_RATE,
			OCPR.IS_SECURE
		FROM
			CREDITCARD_PAYMENT_TYPE CPT,
			CAMPAIGN_PAYMETHODS CP,
			#dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
		WHERE
			CP.PAYMETHOD_ID = CPT.PAYMENT_TYPE_ID AND
			CP.COMMISSION_RATE IS NOT NULL AND
			CP.CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#"> AND
			CP.USED_IN_CAMPAIGN = 1 AND
			OCPR.POS_ID = CPT.POS_TYPE AND
			CPT.IS_ACTIVE = 1 AND
			<cfif isDefined('attributes.is_ins_pay') and attributes.is_ins_pay eq 1>
                CPT.NUMBER_OF_INSTALMENT = 0 AND
            </cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and attributes.is_instalment_info neq 1>
				(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				CPT.IS_PARTNER = 1 AND
			<cfelse>
				CPT.IS_PUBLIC = 1 AND
			</cfif>
				CPT.COMPANY_ID IS NOT NULL AND
				CPT.POS_TYPE IS NOT NULL AND<!---Sanal pos tipleri bilgisi--->
				CPT.POS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_type_id#">
			<cfif isdefined("attributes.credit_card_bank_payment_list") and len(attributes.credit_card_bank_payment_list)>
				AND (ISNULL(CPT.IS_PROM_CONTROL,0) = 0 OR CPT.PAYMENT_TYPE_ID IN(#attributes.credit_card_bank_payment_list#))
			<cfelse>
				AND ISNULL(CPT.IS_PROM_CONTROL,0) = 0
			</cfif>
			<!--- Odeme Yonteminde tanimlanan public minimum tutar kontrolu yapiliyor GA 05032013--->
            AND ISNULL(CPT.PUBLIC_MIN_AMOUNT,0) <= #attributes.nettotal# 
		ORDER BY
			CARD_NO
	</cfquery>
<cfelse>	
	<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
		SELECT DISTINCT OCPR.POS_ID,
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
			OCPR.POS_ID POS_TYPE,
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
			CPT.VFT_CODE,
			CPT.VFT_RATE,
			OCPR.IS_SECURE
		FROM
			ACCOUNTS ACCOUNTS,
			CREDITCARD_PAYMENT_TYPE CPT,
			#dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
		WHERE
			(ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money#"> OR ACCOUNT_CURRENCY_ID = 'TL') AND
			ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
			OCPR.POS_ID = CPT.POS_TYPE AND
			CPT.IS_ACTIVE = 1 AND
			ISNULL(CPT.IS_SPECIAL,0) <> 1 AND
			<cfif isDefined('attributes.is_ins_pay') and attributes.is_ins_pay eq 1>
                CPT.NUMBER_OF_INSTALMENT = 0 AND
            </cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and attributes.is_instalment_info neq 1>
				(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				CPT.IS_PARTNER = 1 AND
				<!--- ACCOUNTS.IS_PARTNER = 1 AND --->
			<cfelse>
				CPT.IS_PUBLIC = 1 AND
				<!--- ACCOUNTS.IS_PUBLIC = 1 AND --->
			</cfif>
				CPT.POS_TYPE IS NOT NULL AND<!---Sanal pos tipleri bilgisi--->
				CPT.POS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_type_id#">
			<cfif isdefined("attributes.credit_card_bank_payment_list") and len(attributes.credit_card_bank_payment_list)>
				AND (ISNULL(CPT.IS_PROM_CONTROL,0) = 0 OR CPT.PAYMENT_TYPE_ID IN(#attributes.credit_card_bank_payment_list#))
			<cfelse>
				AND ISNULL(CPT.IS_PROM_CONTROL,0) = 0
			</cfif>    
			<!--- Odeme Yonteminde tanimlanan public minimum tutar kontrolu yapiliyor GA 05032013--->
            AND ISNULL(CPT.PUBLIC_MIN_AMOUNT,0) <= #attributes.nettotal#
	UNION ALL
		SELECT
			DISTINCT OCPR.POS_ID,
			0 AS ACCOUNT_ID,
			OCPR.POS_NAME AS ACCOUNT_NAME,
			'#session_base.money#' AS ACCOUNT_CURRENCY_ID,
			CPT.PAYMENT_TYPE_ID,
			CPT.FIRST_INTEREST_RATE,
			CPT.CARD_NO,
			CPT.CARD_IMAGE,
			CPT.CARD_IMAGE_SERVER_ID,
			OCPR.POS_ID POS_TYPE,
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
			CPT.VFT_CODE,
			CPT.VFT_RATE,
			OCPR.IS_SECURE
		FROM
			CREDITCARD_PAYMENT_TYPE CPT,
			CAMPAIGN_PAYMETHODS CP,
			#dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
		WHERE
			OCPR.POS_ID = CPT.POS_TYPE AND
			CPT.IS_ACTIVE = 1 AND
			ISNULL(CPT.IS_SPECIAL,0) <> 1 AND
			<cfif isDefined('attributes.is_ins_pay') and attributes.is_ins_pay eq 1>
                CPT.NUMBER_OF_INSTALMENT = 0 AND
            </cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and attributes.is_instalment_info neq 1>
				(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				CPT.IS_PARTNER = 1 AND
			<cfelse>
				CPT.IS_PUBLIC = 1 AND
			</cfif>
				CPT.COMPANY_ID IS NOT NULL AND
				CPT.POS_TYPE IS NOT NULL AND<!---Sanal pos tipleri bilgisi--->
				CPT.POS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_type_id#">
			<cfif isdefined("attributes.credit_card_bank_payment_list") and len(attributes.credit_card_bank_payment_list)>
				AND (ISNULL(CPT.IS_PROM_CONTROL,0) = 0 OR CPT.PAYMENT_TYPE_ID IN (#attributes.credit_card_bank_payment_list#))
			<cfelse>
				AND ISNULL(CPT.IS_PROM_CONTROL,0) = 0
			</cfif>
			<!--- Odeme Yonteminde tanimlanan public minimum tutar kontrolu yapiliyor GA 05032013--->
            AND ISNULL(CPT.PUBLIC_MIN_AMOUNT,0) <= #attributes.nettotal#
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		UNION ALL
			SELECT DISTINCT OCPR.POS_ID,
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
				OCPR.POS_ID POS_TYPE,
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
				CPT.VFT_CODE,
				CPT.VFT_RATE,
				OCPR.IS_SECURE
			FROM
				ACCOUNTS ACCOUNTS,
				CREDITCARD_PAYMENT_TYPE CPT,
				#dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
			WHERE
				(ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money#"> OR ACCOUNT_CURRENCY_ID = 'TL') AND
				ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
				OCPR.POS_ID = CPT.POS_TYPE AND
				CPT.IS_ACTIVE = 1 AND
				CPT.IS_SPECIAL = 1 AND<!--- ödeme yöntemi özelse ve bu üye seçili üye listesindense ve ödeme yöntemi geçerlilk süresindeyse..AE --->
				CPT.PAYMENT_TYPE_ID IN (SELECT CC_PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE_MEMBER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND (#now()# BETWEEN START_DATE AND DATEADD(day,1,FINISH_DATE))) AND
				<cfif isDefined('attributes.is_ins_pay') and attributes.is_ins_pay eq 1>
                    CPT.NUMBER_OF_INSTALMENT = 0 AND
                </cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and attributes.is_instalment_info neq 1>
					(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                    CPT.IS_PARTNER = 1 AND
                    <!--- ACCOUNTS.IS_PARTNER = 1 AND --->
                <cfelse>
                    CPT.IS_PUBLIC = 1 AND
                    <!--- ACCOUNTS.IS_PUBLIC = 1 AND --->
				</cfif>
					CPT.POS_TYPE IS NOT NULL AND<!---Sanal pos tipleri bilgisi--->
					CPT.POS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_type_id#">
				<cfif isdefined("attributes.credit_card_bank_payment_list") and len(attributes.credit_card_bank_payment_list)>
					AND (ISNULL(CPT.IS_PROM_CONTROL,0) = 0 OR CPT.PAYMENT_TYPE_ID IN(#attributes.credit_card_bank_payment_list#))
				<cfelse>
					AND ISNULL(CPT.IS_PROM_CONTROL,0) = 0
				</cfif>
				<!--- Odeme Yonteminde tanimlanan public minimum tutar kontrolu yapiliyor GA 05032013--->
                AND ISNULL(CPT.PUBLIC_MIN_AMOUNT,0) <= #attributes.nettotal#
		UNION ALL
			SELECT
				DISTINCT OCPR.POS_ID,
				0 AS ACCOUNT_ID,
				OCPR.POS_NAME AS ACCOUNT_NAME,
				'#session_base.money#' AS ACCOUNT_CURRENCY_ID,
				CPT.PAYMENT_TYPE_ID,
				CPT.FIRST_INTEREST_RATE,
				CPT.CARD_NO,
				CPT.CARD_IMAGE,
				CPT.CARD_IMAGE_SERVER_ID,
				OCPR.POS_ID POS_TYPE,
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
				CPT.VFT_CODE,
				CPT.VFT_RATE,
				OCPR.IS_SECURE
			FROM
				CREDITCARD_PAYMENT_TYPE CPT,
				#dsn_alias#.OUR_COMPANY_POS_RELATION OCPR
			WHERE
				OCPR.POS_ID = CPT.POS_TYPE AND
				CPT.IS_ACTIVE = 1 AND
				CPT.IS_SPECIAL = 1 AND<!--- ödeme yöntemi özelse ve bu üye seçili üye listesindense ve ödeme yöntemi geçerlilk süresindeyse..AE --->
				CPT.PAYMENT_TYPE_ID IN (SELECT CC_PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE_MEMBER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND (#now()# BETWEEN START_DATE AND DATEADD(day,1,FINISH_DATE))) AND
				<cfif isDefined('attributes.is_ins_pay') and attributes.is_ins_pay eq 1>
                    CPT.NUMBER_OF_INSTALMENT = 0 AND
                </cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and attributes.is_instalment_info neq 1>
					(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
					CPT.IS_PARTNER = 1 AND
				<cfelse>
					CPT.IS_PUBLIC = 1 AND
				</cfif>
				CPT.COMPANY_ID IS NOT NULL AND
				CPT.POS_TYPE IS NOT NULL AND<!---Sanal pos tipleri bilgisi--->
				CPT.POS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_type_id#">
				<cfif isdefined("attributes.credit_card_bank_payment_list") and len(attributes.credit_card_bank_payment_list)>
					AND (ISNULL(CPT.IS_PROM_CONTROL,0) = 0 OR CPT.PAYMENT_TYPE_ID IN(#attributes.credit_card_bank_payment_list#))
				<cfelse>
					AND ISNULL(CPT.IS_PROM_CONTROL,0) = 0
				</cfif>
				<!--- Odeme Yonteminde tanimlanan public minimum tutar kontrolu yapiliyor GA 05032013--->
                AND ISNULL(CPT.PUBLIC_MIN_AMOUNT,0) <= #attributes.nettotal#
		</cfif>
			ORDER BY
				CARD_NO
	</cfquery>
</cfif>

<table>
	<tr class="txtbold">
		<td width="200"><cf_get_lang_main no ='1104.Ödeme Yöntemi'></td>
		<cfif (isdefined("attributes.is_view_commision") and attributes.is_view_commision eq 1) or not isdefined("attributes.is_view_commision")>
			<td width="100"  style="text-align:right;"><cf_get_lang no ='1013.Komisyon Oranı'></td>
		</cfif>
		<td width="50"  style="text-align:right;"><cf_get_lang_main no='1453.Çarpan'></td>
		<cfif (isdefined("attributes.is_view_multiplier") and attributes.is_view_multiplier eq 1) or not isdefined("attributes.is_view_multiplier")>
			<td width="90"  style="text-align:right;"><cf_get_lang no ='1011.Taksit Tutarı'></td>
		</cfif>
		<td width="90"  style="text-align:right;"><cf_get_lang_main no='1737.Toplam Tutar'></td>
		<cfif attributes.type_ eq 1>
			<td id="credit_card_display" style="display:none;"></td>
		<cfelse>
			<td id="lim_credit_card_display" style="display:none;"></td>
		</cfif>
		<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1>
			<td width="80"  style="text-align:right;">VFT Oranı</td>
			<td width="120"  style="text-align:right;">VFT - Toplam Tutar</td>
		</cfif>
	</tr>
	<cfif get_accounts.recordcount>
		<cfoutput query="get_accounts">
			<tr>
				<td>
				<cfif attributes.type_ eq 1>
					<input type="radio" name="action_to_account_id" id="action_to_account_id" class="radio_frame" onclick="get_paymnt_type_info_on(#currentrow#,<cfif len(first_interest_rate)>#first_interest_rate#<cfelse>0</cfif>,0);" value="#account_id#;#account_currency_id#;#payment_type_id#;#pos_type#;0;#number_of_instalment#;#first_interest_rate#;#is_secure#" <cfif isDefined("attributes.paymethod_id_com") and attributes.paymethod_id_com eq payment_type_id>checked</cfif>>
				<cfelse>
					<input type="radio" name="lim_action_to_account_id" id="lim_action_to_account_id" class="radio_frame"  onclick="get_paymnt_type_info_on(#currentrow#,<cfif len(first_interest_rate)>#first_interest_rate#<cfelse>0</cfif>,1);" value="#account_id#;#account_currency_id#;#payment_type_id#;#pos_type#;0;#number_of_instalment#;#first_interest_rate#;#is_secure#" <cfif isDefined("attributes.paymethod_id_com") and attributes.paymethod_id_com eq payment_type_id>checked</cfif>>
				</cfif>
				<cfif len(card_image)><cf_get_server_file output_file="finance/#card_image#" output_server="#card_image_server_id#" output_type="0"></cfif> #CARD_NO# <cfif len(first_interest_rate) and first_interest_rate gt 0><b>(% #first_interest_rate# İndirim)</b></cfif></td>
				<cfif isdefined("attributes.is_view_commision") and attributes.is_view_commision eq 1>
					<cfif isDefined("session.pp")><td  style="text-align:right;">%<cfif len(commission_multiplier_dsp)>#TLFormat(commission_multiplier_dsp)#<cfelse>0</cfif></td></cfif>
						<td  style="text-align:right;">%<cfif len(commission_multiplier)>#TLFormat(commission_multiplier)#<cfelse>0</cfif></td>
				</cfif>
				<cfif (isdefined("attributes.is_view_multiplier") and attributes.is_view_multiplier eq 1) or not isdefined("attributes.is_view_multiplier")>
					<cfif attributes.type_ eq 1>
						<td style="text-align:right;" id="kredi_taksit_tutar_#currentrow#"></td>
					<cfelse>
						<td style="text-align:right;" id="lim_kredi_taksit_tutar_#currentrow#"></td>
					</cfif>
				</cfif>
				<cfif attributes.type_ eq 1>
					<td class="formbold" id="kredi_toplam_tutar_#currentrow#" style="text-align:right;"></td>
				<cfelse>
					<td id="lim_kredi_toplam_tutar_#currentrow#" style="text-align:right;"></td>
				</cfif>
				<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1>
					<td id="vft_rate_#currentrow#" style="text-align:right;"></td>
					<td class="formbold" id="vft_kredi_taksit_tutar_#currentrow#" style="text-align:right;"></td>
				</cfif>
			</tr>
		</cfoutput>
	</cfif>
</table>
<script type="text/javascript">
	function kredi_karti_hesapla()
	{
		tum_toplam_kdvli = document.getElementById('tum_toplam_kdvli').value;
		tum_toplam_komisyonsuz = document.getElementById('tum_toplam_komisyonsuz').value;
		my_temp_tutar = document.getElementById('my_temp_tutar').value;
		my_temp_tutar_price_standart = document.getElementById('my_temp_tutar_price_standart').value;
		indirim_orani = document.getElementById('kredi_karti_indirim_orani').value;
	
		<cfoutput query="get_accounts">
			<cfif len(vft_code)><!--- vft li işlemlerde komisyonlu tutarlar gönderilmez bankaya,vft kendisi hesaplama yapar --->
				main_total = tum_toplam_komisyonsuz;
				<cfif len(commission_multiplier) and commission_multiplier gt 0>
					main_total_dsp = parseFloat(tum_toplam_komisyonsuz) + parseFloat(tum_toplam_komisyonsuz * #commission_multiplier#/100);
				<cfelse>
					main_total_dsp = main_total;
				</cfif>
			<cfelseif len(commission_multiplier) and commission_multiplier gt 0>
				main_total_dsp = parseFloat(tum_toplam_komisyonsuz) + parseFloat(tum_toplam_komisyonsuz * #commission_multiplier#/100);
				main_total = main_total_dsp;
			<cfelse>
				main_total = tum_toplam_komisyonsuz;
				main_total_dsp = tum_toplam_komisyonsuz;
			</cfif>
			<cfif len(number_of_instalment) and number_of_instalment neq 0>
				taksit_tutar = main_total_dsp / #number_of_instalment#;
				if(document.getElementById('lim_sales_credit'))
					lim_taksit_tutar = document.getElementById('lim_sales_credit').value / #number_of_instalment#;
			<cfelse>
				taksit_tutar = main_total_dsp;
				if(document.getElementById('lim_sales_credit'))
					lim_taksit_tutar = document.getElementById('lim_sales_credit').value;
			</cfif>
			<cfif len(first_interest_rate)>
				main_total = main_total - parseFloat(tum_toplam_komisyonsuz * #first_interest_rate#/100);
				main_total_dsp = main_total;
				<cfif len(number_of_instalment) and number_of_instalment neq 0>
					taksit_tutar = main_total_dsp / #number_of_instalment#;
				<cfelse>
					taksit_tutar = main_total_dsp;
				</cfif>
			</cfif>
			<cfif (isdefined("attributes.is_view_multiplier") and attributes.is_view_multiplier eq 1) or not isdefined("attributes.is_view_multiplier")>
				if(isDefined('kredi_taksit_tutar_#currentrow#'))
					kredi_taksit_tutar_#currentrow#.innerHTML = <cfif len(number_of_instalment) and number_of_instalment neq 0>'#number_of_instalment# x' + </cfif> commaSplit(wrk_round(taksit_tutar));
				if(isDefined('lim_kredi_taksit_tutar_#currentrow#') && document.getElementById('lim_sales_credit'))
					lim_kredi_taksit_tutar_#currentrow#.innerHTML = <cfif len(number_of_instalment) and number_of_instalment neq 0>'#number_of_instalment# x' + </cfif> commaSplit(wrk_round(lim_taksit_tutar));
			</cfif>
				if(isDefined('kredi_toplam_tutar_#currentrow#'))
					kredi_toplam_tutar_#currentrow#.innerHTML = commaSplit(wrk_round(main_total_dsp));
				if(isDefined('lim_kredi_taksit_tutar_#currentrow#') && document.getElementById('lim_sales_credit'))
					lim_kredi_toplam_tutar_#currentrow#.innerHTML = commaSplit(wrk_round(document.getElementById('lim_sales_credit').value));	
				<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1 and len(VFT_RATE)>
					vft_rt = #vft_rate#;
					vft_rate_#currentrow#.innerHTML = '%';
					vft_rate_#currentrow#.innerHTML += vft_rt;
					vft_kredi_taksit_tutar_#currentrow#.innerHTML = commaSplit(wrk_round(main_total_dsp) + wrk_round(main_total_dsp * vft_rt/100));
				</cfif>
				<cfif len(VFT_CODE)>
					if(parseFloat('#attributes.claim_info#') <= parseFloat(main_total))
						document.getElementById('sales_credit').value = wrk_round(parseFloat(main_total-'#attributes.claim_info#'));
					else
						document.getElementById('sales_credit').value = wrk_round(main_total);
					document.getElementById('sales_credit_old').value = wrk_round(main_total);
				<cfelse>
					if(parseFloat('#attributes.claim_info#') <= parseFloat(tum_toplam_kdvli))
						document.getElementById('sales_credit').value = wrk_round(parseFloat(tum_toplam_kdvli-'#attributes.claim_info#'));
					else
						document.getElementById('sales_credit').value = wrk_round(main_total_dsp);
					document.getElementById('sales_credit_old').value = wrk_round(tum_toplam_kdvli);
				</cfif>
				if(parseFloat('#attributes.claim_info#') <= parseFloat(tum_toplam_kdvli)){
					document.getElementById('sales_credit_dsp').value =  commaSplit(wrk_round(parseFloat(tum_toplam_kdvli-'#attributes.claim_info#')));}
				else
					document.getElementById('sales_credit_dsp').value =  commaSplit(wrk_round(tum_toplam_kdvli));
				
				document.getElementById('sales_credit_old').value = wrk_round(tum_toplam_kdvli);
		</cfoutput>
		if(indirim_orani > 0)
		{
			tutar1 = document.getElementById('sales_credit').value;
			tutar2 = filterNum(document.getElementById('sales_credit_dsp').value);
			document.getElementById('sales_credit').value = wrk_round(tutar1 - (tutar1 * indirim_orani / 100));
			document.getElementById('sales_credit_dsp').value = commaSplit(wrk_round(tutar2 - (tutar2 * indirim_orani / 100)));
		}
		<cfif isdefined('attributes.is_basis_of_receiving') and attributes.is_basis_of_receiving eq 1>
			var memberBakiye_ = <cfoutput>#get_company_risk.bakiye#</cfoutput>;
			var xx = memberBakiye_ <cfif len(get_order_bakiye.nettotal)>+ <cfoutput>#get_order_bakiye.nettotal#</cfoutput></cfif>;
			if(xx < 0)
			{
				var amount_paid_ = parseFloat(document.getElementById('sales_credit').value -  Math.abs(xx));
				if(amount_paid_ > 0)
				{
					document.getElementById('sales_credit').value = wrk_round(amount_paid_);
					document.getElementById('sales_credit_dsp').value = commaSplit(wrk_round(amount_paid_));
					document.getElementById('order_payment_value').value = wrk_round(amount_paid_,2);
				}
				else
				{
					document.getElementById('sales_credit').value = 0;
					document.getElementById('sales_credit_dsp').value = 0;
					document.getElementById('order_payment_value').value = 0;
				}
			}
			else
				document.getElementById('order_payment_value').value = wrk_round(document.getElementById('sales_credit').value);
		</cfif>
	}
	
	function get_paymnt_type_info_on(siram,indirim,limit_info)
	{
		if(isDefined('kredi_toplam_tutar_' + siram + ''))
			my_tutar_ =  document.getElementById('kredi_toplam_tutar_'+siram).innerHTML;
		if(isDefined('lim_kredi_taksit_tutar_' + siram + ''))
			my_tutar_ =  document.getElementById('lim_kredi_taksit_tutar_'+siram).innerHTML;	
					
		document.getElementById('sales_credit_dsp').value = my_tutar_;
		document.getElementById('sales_credit').value = filterNum(my_tutar_);
		
		document.getElementById('_show_joker_vada_').innerHTML = '';
		document.getElementById('joker_vada_control').value = 0;

		open_joker_vada();
		if(limit_info == 0)
		{
			my_temp_tutar = document.getElementById('my_temp_tutar').value;
			my_temp_tutar_price_standart = document.getElementById('my_temp_tutar_price_standart').value;
			document.getElementById('kredi_karti_indirim_orani').value = indirim;
			return get_paymnt_type_info(siram,my_temp_tutar,my_temp_tutar_price_standart,0);
		}
		else
		{
			return get_paymnt_type_info(siram,my_temp_tutar,my_temp_tutar_price_standart,1);
		}
	}
	
	function get_paymnt_type_info(sira,tutar,tutar_price_standard,limit_info)
	{
		document.getElementById('account_recordcount').value = '<cfoutput>#get_accounts.recordcount#</cfoutput>'
		if(limit_info == 0)
		{
			<cfif get_accounts.recordcount eq 1>
				paym_type_id = document.getElementById('action_to_account_id').value.split(';')[2];
			<cfelse>
				paym_type_id = document.list_basketww.action_to_account_id[sira-1].value.split(';')[2];
			</cfif>
	
			var new_sql = get_payment_hesapla(<cfif isdefined("attributes.company_id") and len(attributes.company_id)>1<cfelse>0</cfif>,paym_type_id);
			var get_comp_prod = wrk_safe_query(new_sql,'dsn3',0,paym_type_id);
			bb = get_comp_prod.COMMISSION_MULTIPLIER;
			if(get_comp_prod.COMMISSION_MULTIPLIER != '' && get_comp_prod.COMMISSION_MULTIPLIER > 0 && get_comp_prod.COMMISSION_STOCK_ID != '' && get_comp_prod.COMMISSION_PRODUCT_ID != '')
			{
				document.satir_gonder.price_catid_2.value = -2;
				var aa_temp = wrk_round((tutar * get_comp_prod.COMMISSION_MULTIPLIER)/100);
				var aa_temp_price_standard = wrk_round((tutar_price_standard * get_comp_prod.COMMISSION_MULTIPLIER)/100);
				document.satir_gonder.price.value = wrk_round((aa_temp*100)/(100 + parseFloat(get_comp_prod.TAX)));
				document.satir_gonder.price_old.value = '';
				document.satir_gonder.istenen_miktar.value = 1;
				document.satir_gonder.sid.value = get_comp_prod.COMMISSION_STOCK_ID; 
				document.satir_gonder.price_kdv.value = aa_temp;
				document.satir_gonder.price_money.value = '<cfoutput>#session_base.money#</cfoutput>';
				document.satir_gonder.price_standard_money.value = '<cfoutput>#session_base.money#</cfoutput>';
				document.satir_gonder.prom_id.value = '';
				document.satir_gonder.prom_discount.value = '';
				document.satir_gonder.prom_amount_discount.value = '';
				document.satir_gonder.prom_cost.value = '';
				document.satir_gonder.prom_free_stock_id.value = '';
				document.satir_gonder.prom_stock_amount.value = 1;
				document.satir_gonder.prom_free_stock_amount.value = 1;
				document.satir_gonder.prom_free_stock_price.value = 0;
				document.satir_gonder.prom_free_stock_money.value = '';
				document.satir_gonder.is_commission.value = 1;
				document.satir_gonder.is_cargo.value = 0;
				document.satir_gonder.paymethod_id_com.value = paym_type_id;
				//son kullanici
				document.satir_gonder.price_standard.value = wrk_round((aa_temp_price_standard*100)/(100 + parseFloat(get_comp_prod.TAX)));
				document.satir_gonder.price_standard_kdv.value = aa_temp_price_standard;
				<cfif isdefined('attributes.order_from_basket_express') and attributes.order_from_basket_express eq 1>
					<cfoutput>
						<cfif isdefined('attributes.consumer_id')>
							document.satir_gonder.consumer_id.value = '#attributes.consumer_id#';
						<cfelse>
							document.satir_gonder.company_id.value = '#attributes.company_id#';
							document.satir_gonder.partner_id.value = '#attributes.partner_id#';
						</cfif>
						document.satir_gonder.order_from_basket_express.value = 1;
					</cfoutput>
				</cfif>
				<cfif isdefined("attributes.xml_reload") and attributes.xml_reload eq 1>
					satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row';
					AjaxFormSubmit('satir_gonder','credit_card_display',1,'','',sepet_adres_,'sale_basket_rows_list');
				</cfif>
			}
			else
			{
				<cfif get_accounts.recordcount eq 1>
					if(list_basketww.action_to_account_id.value.split(';')[3] == 9 && list_basketww.action_to_account_id.value.split(';')[5] != undefined && list_basketww.action_to_account_id.value.split(';')[5] > 0)
					{//pos type i alır,Yapıkredi taksitlide işlem olur sadece
						joker_info.style.display='';
						document.list_basketww.joker_vada.checked = true;//joker vada seçili gelsin
					}
					else
					{
						joker_info.style.display='none';
						document.list_basketww.joker_vada.checked = false;
					}
				<cfelse>
					if(document.list_basketww.action_to_account_id[sira-1].value.split(';')[3] == 9 && document.list_basketww.action_to_account_id[sira-1].value.split(';')[5] != undefined && document.list_basketww.action_to_account_id[sira-1].value.split(';')[5] > 0)
					{//pos type i alır,Yapıkredi taksitlide işlem olur sadece
						joker_info.style.display='';
						document.list_basketww.joker_vada.checked = true;//joker vada seçili gelsin
					}
					else
					{
						joker_info.style.display='none';
						document.list_basketww.joker_vada.checked = false;
					}
				</cfif>
				<cfif isdefined("attributes.xml_reload") and attributes.xml_reload eq 1>
					adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww&is_delete_info=1&paymethod_id_com=';
					<cfif get_accounts.recordcount eq 1>
						adres_ += document.list_basketww.action_to_account_id.value.split(';')[2];
					<cfelse>
						adres_ += document.list_basketww.action_to_account_id[sira-1].value.split(';')[2];
					</cfif>
					adres_ += '&is_from_credit=1';
					AjaxPageLoad(adres_,'sale_basket_rows_list','1','Hesaplanıyor!');
					//window.location.href='#request.self#?fuseaction=objects2.emptypopup_del_basketww&is_delete_info=1&paymethod_id_com='+eval('list_basketww.action_to_account_id[sira-1]').value.split(';')[2]+'';
				</cfif>
			}
			return pay_type_general(paym_type_id,0);
		}
		else
		{
			<cfif get_accounts.recordcount eq 1>
				paym_type_id = list_basketww.lim_action_to_account_id.value.split(';')[2];
			<cfelseif get_accounts.recordcount neq 0>
				if(document.list_basketww.lim_action_to_account_id[sira-1] != undefined)
					paym_type_id = document.list_basketww.lim_action_to_account_id[sira-1].value.split(';')[2];
				else if(list_basketww.lim_action_to_account_id.value != undefined)
					paym_type_id = list_basketww.lim_action_to_account_id.value.split(';')[2];
			</cfif>
			return pay_type_general(paym_type_id,1);
		}
	}
	kredi_karti_hesapla();
</script>
<cfabort>
