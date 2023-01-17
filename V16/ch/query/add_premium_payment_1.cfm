<cfquery name="ADD_MLM_PAY" datasource="#DSN2#" result="MAX_ID">
	INSERT INTO
		INVOICE_MULTILEVEL_PAYMENT
	(
		PROCESS_TYPE,
		PROCESS_CAT_ID,
		ACTION_DATE,
		PAYMENT_DATE,
		CAMPAIGN_ID,
		STOPPAGE_RATE_ID,
		EXPENSE_CENTER_ID,
		EXPENSE_ITEM_ID,
		ACCOUNT_ID,
		PREMIUM_TYPE,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
	)
	VALUES
	(
		#process_type_premium#,
		#attributes.process_cat#,
		#attributes.action_date#,
		#attributes.payment_date#,
		#attributes.camp_id#,
		<cfif len(attributes.stoppage_rate)>#listlast(attributes.stoppage_rate,';')#<cfelse>NULL</cfif>,
		<cfif len(attributes.expense_center_id_2) and len(attributes.expense_center_2)>#attributes.expense_center_id_2#<cfelse>NULL</cfif>,
		<cfif len(attributes.expense_item_id_2) and len(attributes.expense_item_name_2)>#attributes.expense_item_id_2#<cfelse>NULL</cfif>,
		<cfif len(attributes.form_account_id)>#listgetat(attributes.form_account_id,1,';')#<cfelse>NULL</cfif>,
		#attributes.premium_type#,
		#now()#,
		'#cgi.remote_addr#',
		#session.ep.userid#
	)
</cfquery>

<cfset get_max_id_pre.max_id = max_id.identitycol>

<cfquery name="get_startdate" datasource="#dsn2#">
	SELECT CAMP_STARTDATE FROM #dsn3_alias#.CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
</cfquery>
<cfquery name="GET_ALL_PREMIUM" datasource="#DSN2#">
	SELECT
		INV.INVOICE_MULTILEVEL_PREMIUM_ID,
		(INV.PREMIUM_SYSTEM_TOTAL - ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0)) AS PREMIUM_SYSTEM_TOTAL,
		INV.PREMIUM_DATE,
		INV.CAMPAIGN_ID,
		INV.INVOICE_ID,
		INV.CONSUMER_ID,
		INV.PREMIUM_LINE,
		INV.PREMIUM_RATE,
		INV.INVOICE_TOTAL,
		I.NETTOTAL,
		INV.INVOICE_ID,
		INV.PREMIUM_SYSTEM_MONEY,
		INV.CONSUMER_REFERENCE_CODE,
		INV.REF_CONSUMER_ID,
		I.INVOICE_CAT,
		1 AS KONTROL,
		ISNULL((SELECT SUM(IR.GROSSTOTAL) FROM INVOICE_ROW IR,#dsn3_alias#.PRODUCT P WHERE IR.INVOICE_ID = I.INVOICE_ID AND P.PRODUCT_ID = IR.PRODUCT_ID AND P.IS_INVENTORY = 0),0) INVENT_TOTAL,
		(SELECT SUM(IR.GROSSTOTAL) FROM INVOICE_ROW IR,#dsn3_alias#.PRODUCT P WHERE IR.INVOICE_ID = I.INVOICE_ID AND P.PRODUCT_ID = IR.PRODUCT_ID AND P.IS_INVENTORY = 1) OTHER_TOTAL,
		ISNULL((SELECT TOP 1 BG.BLOCK_GROUP_PERMISSIONS FROM #dsn_alias#.COMPANY_BLOCK_REQUEST CBL,#dsn_alias#.BLOCK_GROUP BG WHERE CBL.CONSUMER_ID= INV.CONSUMER_ID AND CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND CBL.BLOCK_START_DATE <= #now()# AND (CBL.BLOCK_FINISH_DATE IS NULL OR CBL.BLOCK_FINISH_DATE >= #now()#) ORDER BY CBL.BLOCK_START_DATE DESC),0) AS BLOCK_STATUS
	FROM
		INVOICE_MULTILEVEL_PREMIUM INV,
		INVOICE I,
		CARI_ROWS CR
	WHERE
		INV.CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
		ROUND(PREMIUM_SYSTEM_TOTAL,2) <> ROUND(ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0),2) AND
		INV.INVOICE_ID = I.INVOICE_ID AND
		I.INVOICE_ID = CR.ACTION_ID AND
		I.INVOICE_CAT = CR.ACTION_TYPE_ID AND
		INV.PREMIUM_STATUS = 1 AND
		<cfif isdefined("attributes.checked_value") or attributes.is_checked_value_by_single eq 0>
			INV.CONSUMER_ID IN(#attributes.checked_value#) AND
		<cfelseif isdefined("attributes.checked_value2")>
			INV.CONSUMER_ID IN(#attributes.checked_value2#) AND
		<cfelseif  isdefined("attributes.checked_value") and  isdefined("attributes.checked_value2")>
			(INV.CONSUMER_ID IN(#attributes.checked_value#) OR INV.CONSUMER_ID IN(#attributes.checked_value2#)) AND
		</cfif>
		INV.REF_CONSUMER_ID IS NOT NULL AND
		INV.PREMIUM_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.premium_type#">
	
	UNION ALL
	
	SELECT
		INV.INVOICE_MULTILEVEL_PREMIUM_ID,
		ROUND((INV.PREMIUM_SYSTEM_TOTAL - ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0)),2) AS PREMIUM_SYSTEM_TOTAL,
		INV.PREMIUM_DATE,
		INV.CAMPAIGN_ID,
		INV.INVOICE_ID,
		INV.CONSUMER_ID,
		INV.PREMIUM_LINE,
		INV.PREMIUM_RATE,
		INV.INVOICE_TOTAL,
		I.NETTOTAL,
		INV.INVOICE_ID,
		INV.PREMIUM_SYSTEM_MONEY,
		INV.CONSUMER_REFERENCE_CODE,
		INV.REF_CONSUMER_ID,
		I.INVOICE_CAT,
		0 AS KONTROL,
		ISNULL((SELECT SUM(IR.GROSSTOTAL) FROM INVOICE_ROW IR,#dsn3_alias#.PRODUCT P WHERE IR.INVOICE_ID = I.INVOICE_ID AND P.PRODUCT_ID = IR.PRODUCT_ID AND P.IS_INVENTORY = 0),0) INVENT_TOTAL,
		(SELECT SUM(IR.GROSSTOTAL) FROM INVOICE_ROW IR,#dsn3_alias#.PRODUCT P WHERE IR.INVOICE_ID = I.INVOICE_ID AND P.PRODUCT_ID = IR.PRODUCT_ID AND P.IS_INVENTORY = 1) OTHER_TOTAL,
		ISNULL((SELECT TOP 1 BG.BLOCK_GROUP_PERMISSIONS FROM #dsn_alias#.COMPANY_BLOCK_REQUEST CBL,#dsn_alias#.BLOCK_GROUP BG WHERE CBL.CONSUMER_ID= INV.CONSUMER_ID AND CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND CBL.BLOCK_START_DATE <= #now()# AND (CBL.BLOCK_FINISH_DATE IS NULL OR CBL.BLOCK_FINISH_DATE >= #now()#) ORDER BY CBL.BLOCK_START_DATE DESC),0) AS BLOCK_STATUS
	FROM
		INVOICE_MULTILEVEL_PREMIUM INV,
		INVOICE I,
		CARI_ROWS CR
	WHERE
		INV.CAMPAIGN_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
		INV.CAMPAIGN_ID IN(SELECT C.CAMP_ID FROM #dsn3_alias#.CAMPAIGNS C WHERE C.CAMP_STARTDATE < #createodbcdatetime(get_startdate.camp_startdate)#) AND
		ROUND(PREMIUM_SYSTEM_TOTAL,2) <> ROUND(ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0),2) AND
		INV.INVOICE_ID = I.INVOICE_ID AND
		I.INVOICE_ID = CR.ACTION_ID AND
		I.INVOICE_CAT = CR.ACTION_TYPE_ID AND
		INV.PREMIUM_STATUS = 1 AND
		<cfif isdefined("attributes.checked_value") or attributes.is_checked_value_by_single eq 0>
			INV.CONSUMER_ID IN(#attributes.checked_value#) AND
		<cfelseif isdefined("attributes.checked_value2")>
			INV.CONSUMER_ID IN(#attributes.checked_value2#) AND
		<cfelseif  isdefined("attributes.checked_value") and  isdefined("attributes.checked_value2")>
			(INV.CONSUMER_ID IN(#attributes.checked_value#) OR INV.CONSUMER_ID IN(#attributes.checked_value2#)) AND
		</cfif>
		INV.REF_CONSUMER_ID IS NOT NULL AND
		INV.PREMIUM_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.premium_type#">
	
	UNION ALL
	
	SELECT
		INV.INVOICE_MULTILEVEL_PREMIUM_ID,
		(INV.PREMIUM_SYSTEM_TOTAL - ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0)) AS PREMIUM_SYSTEM_TOTAL,
		INV.PREMIUM_DATE,
		INV.CAMPAIGN_ID,
		INV.INVOICE_ID,
		INV.CONSUMER_ID,
		INV.PREMIUM_LINE,
		INV.PREMIUM_RATE,
		INV.INVOICE_TOTAL,
		INV.INVOICE_TOTAL NETTOTAL,
		INV.INVOICE_ID,
		INV.PREMIUM_SYSTEM_MONEY,
		INV.CONSUMER_REFERENCE_CODE,
		INV.REF_CONSUMER_ID,
		0 INVOICE_CAT,
		1 AS KONTROL,
		0 INVENT_TOTAL,
		INV.INVOICE_TOTAL OTHER_TOTAL,
		ISNULL((SELECT TOP 1 BG.BLOCK_GROUP_PERMISSIONS FROM #dsn_alias#.COMPANY_BLOCK_REQUEST CBL,#dsn_alias#.BLOCK_GROUP BG WHERE CBL.CONSUMER_ID= INV.CONSUMER_ID AND CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND CBL.BLOCK_START_DATE <= #now()# AND (CBL.BLOCK_FINISH_DATE IS NULL OR CBL.BLOCK_FINISH_DATE >= #now()#) ORDER BY CBL.BLOCK_START_DATE DESC),0) AS BLOCK_STATUS
	FROM
		INVOICE_MULTILEVEL_PREMIUM INV
	WHERE
		INV.CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
		INV.INVOICE_ID = 0 AND
		ROUND(PREMIUM_SYSTEM_TOTAL,2) <> ROUND(ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0),2) AND
		INV.PREMIUM_STATUS = 1 AND
		<cfif isdefined("attributes.checked_value") or attributes.is_checked_value_by_single eq 0>
			INV.CONSUMER_ID IN(#attributes.checked_value#) AND
		<cfelseif isdefined("attributes.checked_value2")>
			INV.CONSUMER_ID IN(#attributes.checked_value2#) AND
		<cfelseif  isdefined("attributes.checked_value") and  isdefined("attributes.checked_value2")>
			(INV.CONSUMER_ID IN(#attributes.checked_value#) OR INV.CONSUMER_ID IN(#attributes.checked_value2#)) AND
		</cfif>
		INV.PREMIUM_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.premium_type#"> AND
		INV.CONSUMER_ID <> 1
	<cfif not isdefined("attributes.is_control_invoice")>
		AND INV.REF_CONSUMER_ID IS NOT NULL
	</cfif>		
	
	UNION ALL
	
	SELECT
		INV.INVOICE_MULTILEVEL_PREMIUM_ID,
		ROUND((INV.PREMIUM_SYSTEM_TOTAL - ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0)),2) AS PREMIUM_SYSTEM_TOTAL,
		INV.PREMIUM_DATE,
		INV.CAMPAIGN_ID,
		INV.INVOICE_ID,
		INV.CONSUMER_ID,
		INV.PREMIUM_LINE,
		INV.PREMIUM_RATE,
		INV.INVOICE_TOTAL,
		INV.INVOICE_TOTAL NETTOTAL,
		INV.INVOICE_ID,
		INV.PREMIUM_SYSTEM_MONEY,
		INV.CONSUMER_REFERENCE_CODE,
		INV.REF_CONSUMER_ID,
		0 INVOICE_CAT,
		0 AS KONTROL,
		0 INVENT_TOTAL,
		INV.INVOICE_TOTAL OTHER_TOTAL,
		ISNULL((SELECT TOP 1 BG.BLOCK_GROUP_PERMISSIONS FROM #dsn_alias#.COMPANY_BLOCK_REQUEST CBL,#dsn_alias#.BLOCK_GROUP BG WHERE CBL.CONSUMER_ID= INV.CONSUMER_ID AND CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND CBL.BLOCK_START_DATE <= #now()# AND (CBL.BLOCK_FINISH_DATE IS NULL OR CBL.BLOCK_FINISH_DATE >= #now()#) ORDER BY CBL.BLOCK_START_DATE DESC),0) AS BLOCK_STATUS
	FROM
		INVOICE_MULTILEVEL_PREMIUM INV
	WHERE
		INV.CAMPAIGN_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
		INV.INVOICE_ID = 0 AND
		INV.CAMPAIGN_ID IN(SELECT C.CAMP_ID FROM #dsn3_alias#.CAMPAIGNS C WHERE C.CAMP_STARTDATE < #createodbcdatetime(get_startdate.camp_startdate)#) AND
		ROUND(PREMIUM_SYSTEM_TOTAL,2) <> ROUND(ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0),2) AND
		INV.PREMIUM_STATUS = 1 AND
		<cfif isdefined("attributes.checked_value") or attributes.is_checked_value_by_single eq 0>
			INV.CONSUMER_ID IN(#attributes.checked_value#) AND
		<cfelseif isdefined("attributes.checked_value2")>
			INV.CONSUMER_ID IN(#attributes.checked_value2#) AND
		<cfelseif  isdefined("attributes.checked_value") and  isdefined("attributes.checked_value2")>
			(INV.CONSUMER_ID IN(#attributes.checked_value#) OR INV.CONSUMER_ID IN(#attributes.checked_value2#)) AND
		</cfif>
		INV.REF_CONSUMER_ID IS NOT NULL AND
		INV.PREMIUM_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.premium_type#"> AND
		INV.CONSUMER_ID <> 1
</cfquery>
<cfset total_payment_amount = 0>
<cfset total_stoppage_amount = 0>
<cfset total_amount = 0>
<cfoutput query="get_all_premium">
	<cfset gross_total = 0>
	<cfif not isdefined("attributes.is_control_invoice")>
		<cfif invoice_id gt 0>
			<cfquery name="GET_OPEN_INVOICE" datasource="#DSN2#">
				SELECT 
					(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID),0)) AS OPEN_VALUE
				FROM
					CARI_ROWS
				WHERE
					(CARI_ROWS.FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#"> OR CARI_ROWS.TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#">) AND 
					(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID),0) > 0) AND
					ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_id#"> AND 
					ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_cat#"> AND
					DUE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">
			</cfquery>
		<cfelse>
			<cfquery name="GET_OPEN_INVOICE" datasource="#DSN2#">
				SELECT 
					(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID AND CARI_ACTION_ID = CARI_ROWS.CARI_ACTION_ID),0)) AS OPEN_VALUE
				FROM
					CARI_ROWS
				WHERE
					(CARI_ROWS.FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#"> OR CARI_ROWS.TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#">) AND
					(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID AND CARI_ACTION_ID = CARI_ROWS.CARI_ACTION_ID),0) > 0) AND
					ACTION_ID = -1 AND 
					ACTION_TYPE_ID = 40 AND
					DUE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">
			</cfquery>
		</cfif>
		<cfif get_open_invoice.recordcount and invoice_total gt 0>
			<cfset gross_total = get_open_invoice.open_value>
		</cfif>
	</cfif>
	<cfif invent_total neq 0 and gross_total neq 0 and gross_total eq get_all_premium.nettotal>
		<cfset gross_total = gross_total - invent_total>
	</cfif>
	<cfset premium_value_ = (premium_system_total-(gross_total * premium_rate / 100))>
	<cfif len(attributes.stoppage_rate)>
		<cfset premium_amount = ((premium_value_- (listfirst(attributes.stoppage_rate,';')*premium_value_/100)))>
		<cfset stopaj_amount = ((premium_value_*listfirst(attributes.stoppage_rate,';')/100))>
	<cfelse>
		<cfset premium_amount = premium_value_>
		<cfset stopaj_amount = 0>
	</cfif>
	<cfquery name="ADD_MLM_PAY" datasource="#DSN2#">
		INSERT INTO
			INVOICE_MULTILEVEL_PAYMENT_ROWS
		(
			INV_PAYMENT_ID,
			INV_PREMIUM_ID,
			PAY_AMOUNT,
			STOPPAGE_AMOUNT,
			CONSUMER_ID
		)
		VALUES
		(
			#MAX_ID.IDENTITYCOL#,
			#INVOICE_MULTILEVEL_PREMIUM_ID#,
			#premium_amount#,
			#stopaj_amount#,
			#consumer_id#
		)
	</cfquery>	
	<cfset total_payment_amount = total_payment_amount + premium_amount>
	<cfset total_stoppage_amount = total_stoppage_amount + stopaj_amount>
	<cfset total_amount = total_amount + premium_amount + stopaj_amount>
</cfoutput>
