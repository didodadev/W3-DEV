<cfquery name="get_period_year1" datasource="#DSN#">
	SELECT 
		PERIOD_YEAR 
	FROM  
		SETUP_PERIOD
	WHERE
		PERIOD_ID = #attributes.from_cmp#
</cfquery>
<cfset f_pyear = get_period_year1.PERIOD_YEAR>	<!--- emirler aktarılacak şirketin period yılı --->
<cfset f_cmp = attributes.source_company>	<!--- emirler aktarılacak şirket id --->
<cfset f_period = attributes.from_cmp>	<!--- emirler aktarılacak şirketin periodu--->
<cfquery name="get_period_year2" datasource="#DSN#">
	SELECT 
		PERIOD_YEAR 
	FROM  
		SETUP_PERIOD
	WHERE
		PERIOD_ID = #attributes.to_cmp#
</cfquery>
<cfset t_pyear = get_period_year2.PERIOD_YEAR>	<!--- emirlerin aktarılacağı şirketin period yılı --->
<cfset t_cmp = attributes.target_company>		<!--- emirlerin aktarılacağı şirket id --->
<cfset t_period = attributes.to_cmp>	<!--- emirlerin aktarılacağı şirketin periodu --->
<!--- tablo gelen veriye göre belirlenir --->
<cfset db_out = '#DSN#_#f_pyear#_#f_cmp#'> 
<cfset db_in = '#DSN#_#t_pyear#_#t_cmp#'>
<cfscript>
	if (database_type is 'MSSQL') {
		db_out = '#DSN#_#f_pyear#_#f_cmp#';
		db_in = '#DSN#_#t_pyear#_#t_cmp#';
	}
	else if (database_type is 'DB2') {
		db_out = '#DSN#_#f_cmp#_#right(f_pyear,2)#';
		db_in = '#DSN#_#t_cmp#_#right(t_pyear,2)#';
	}
</cfscript>
<cfquery name="DB_CONTROL_OUT" datasource="#DSN#">
	SELECT 
		PERIOD_YEAR 
	FROM  
		SETUP_PERIOD
	WHERE
		PERIOD_YEAR = #f_pyear# AND 
		OUR_COMPANY_ID = #f_cmp#
</cfquery>

<cfquery name="DB_CONTROL_IN" datasource="#DSN#">
	SELECT 
		PERIOD_YEAR 
	FROM  
		SETUP_PERIOD
	WHERE
		PERIOD_YEAR = #t_pyear# AND 
		OUR_COMPANY_ID = #t_cmp#
</cfquery>

<cfquery name="ref_control" datasource="#DSN#">
	SELECT
		TO_CMP_ID
	FROM
		BANK_ORDERS_COPY_REF
	WHERE	
		TO_CMP_ID = #t_cmp#
		AND FROM_CMP_ID = #f_cmp#
		AND TO_PERIOD_ID = #t_period#
		AND FROM_PERIOD_ID = #f_period#
</cfquery>
<cfif ref_control.recordcount>
	<cfquery name="sirket1" datasource="#dsn#">
		SELECT
			COMPANY_NAME
		FROM
			OUR_COMPANY
		WHERE
			COMP_ID=#t_cmp#
	</cfquery>
	<cfquery name="sirket2" datasource="#dsn#">
		SELECT
			COMPANY_NAME
		FROM
			OUR_COMPANY
		WHERE
			COMP_ID=#f_cmp#
	</cfquery>
	<script type="text/javascript">
		alert("<cfoutput>#sirket2.company_name#</cfoutput> <cf_get_lang dictionary_id='63029.şirketinin'> <cfoutput>#f_pyear#</cfoutput> <cf_get_lang dictionary_id='63030.döneminden'> <cfoutput>#sirket1.company_name#</cfoutput>  <cf_get_lang dictionary_id='63029.şirketinin'>  <cfoutput>#t_pyear#</cfoutput><cf_get_lang dictionary_id='63031.dönemine daha önce aktarım yapılmıştır'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif DB_CONTROL_OUT.recordcount and DB_CONTROL_IN.recordcount>
	<cfquery name="get_bank_orders" datasource="#db_out#">
		SELECT
			*
		FROM
			BANK_ORDERS
		WHERE
			PAYMENT_DATE >= #CREATEODBCDATETIME('#f_pyear#-01-01')#
			AND	IS_PAID <> 1
	</cfquery>	
	<cfset order_list = valuelist(get_bank_orders.BANK_ORDER_ID,',')>
	<cfif len(order_list)>
		<cflock name="#CREATEUUID()#" timeout="20">
			<cftransaction>	
				<cfloop list="#order_list#" index="i">
					<cfquery name="get_current_order" dbtype="query">
						SELECT * FROM get_bank_orders WHERE BANK_ORDER_ID = #i#
					</cfquery>
					<cfquery name="add_" datasource="#db_in#">
						INSERT INTO BANK_ORDERS 
						(
							PAYMENT_DATE,
							BANK_ORDER_TYPE_ID,
							BANK_ORDER_TYPE,
							RECORD_DATE,
							RECORD_IP,
							RECORD_EMP,
							UPDATE_DATE,
							UPDATE_EMP,
							UPDATE_IP,				
							ACCOUNT_ID,
							COMPANY_ID,
							EMPLOYEE_ID,
							CONSUMER_ID,
							PARTNER_ID,
							TO_ACCOUNT_ID,
							ACTION_DATE,
							ACTION_VALUE,
							ACTION_MONEY,
							PROJECT_ID,
							OTHER_MONEY_VALUE,
							OTHER_MONEY,
							RELATED_ACTION_ID,
							RELATED_ACTION_TYPE_ID,
							ACTION_DETAIL,
							ASSETP_ID,
							IS_PAID,
							SERI_NO			
						)
						VALUES
						(
							<cfif len(get_current_order.PAYMENT_DATE)>#CREATEODBCDATETIME(get_current_order.PAYMENT_DATE)#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.BANK_ORDER_TYPE_ID)>#get_current_order.BANK_ORDER_TYPE_ID#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.BANK_ORDER_TYPE)>#get_current_order.BANK_ORDER_TYPE#,<cfelse>NULL,</cfif>
							#CREATEODBCDATETIME(get_current_order.RECORD_DATE)#,
							'#get_current_order.RECORD_IP#',
							<cfif len(get_current_order.RECORD_EMP)>#get_current_order.RECORD_EMP#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.UPDATE_DATE)>#CREATEODBCDATETIME(get_current_order.UPDATE_DATE)#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.UPDATE_EMP)>#get_current_order.UPDATE_EMP#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.UPDATE_IP)>'#get_current_order.UPDATE_IP#',<cfelse>NULL,</cfif>				
							<cfif len(get_current_order.ACCOUNT_ID)>#get_current_order.ACCOUNT_ID#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.COMPANY_ID)>#get_current_order.COMPANY_ID#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.EMPLOYEE_ID)>#get_current_order.EMPLOYEE_ID#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.CONSUMER_ID)>#get_current_order.CONSUMER_ID#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.PARTNER_ID)>#get_current_order.PARTNER_ID#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.TO_ACCOUNT_ID)>#get_current_order.TO_ACCOUNT_ID#,<cfelse>NULL,</cfif>
							#CREATEODBCDATETIME(get_current_order.ACTION_DATE)#,
							#get_current_order.ACTION_VALUE#,
							'#get_current_order.ACTION_MONEY#',
							<cfif len(get_current_order.PROJECT_ID)>#get_current_order.PROJECT_ID#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.OTHER_MONEY_VALUE)>#get_current_order.OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.OTHER_MONEY)>'#get_current_order.OTHER_MONEY#',<cfelse>NULL,</cfif>							
							<cfif len(get_current_order.RELATED_ACTION_ID)>#get_current_order.RELATED_ACTION_ID#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.RELATED_ACTION_TYPE_ID)>#get_current_order.RELATED_ACTION_TYPE_ID#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.ACTION_DETAIL)>'#get_current_order.ACTION_DETAIL#',<cfelse>NULL,</cfif>
							<cfif len(get_current_order.ASSETP_ID)>#get_current_order.ASSETP_ID#,<cfelse>NULL,</cfif>
							<cfif len(get_current_order.IS_PAID)>#get_current_order.IS_PAID#,<cfelse>NULL,</cfif>
							'#get_current_order.SERI_NO#'
						)
					</cfquery>
					<cfquery name="add_money" datasource="#db_in#">
						INSERT INTO BANK_ORDER_MONEY
						(
							MONEY_TYPE,
							ACTION_ID,
							RATE2,
							RATE1,
							IS_SELECTED
						)
							SELECT
								MONEY_TYPE,
								ACTION_ID,
								RATE2,
								RATE1,
								IS_SELECTED
							FROM
								#db_out#.BANK_ORDER_MONEY
							WHERE
								ACTION_ID = #i#
					</cfquery>
				</cfloop>
				<cfquery name="add_copy" datasource="#db_in#">
					INSERT INTO 
						#dsn_alias#.BANK_ORDERS_COPY_REF
					(
						TO_CMP_ID,
						FROM_CMP_ID,
						TO_PERIOD_ID,
						FROM_PERIOD_ID
					)
					VALUES
					(
						#t_cmp#,
						#f_cmp#,
						#t_period#,
						#f_period#
					)
				</cfquery>
				<cfquery name="GET_" datasource="#db_in#">
					SELECT 
						sysobjects.NAME TABLE_NAME,
						syscolumns.NAME COLUM_NAME
					FROM 
						syscolumns,
						sysobjects
					WHERE
						sysobjects.id=syscolumns.id AND
						syscolumns.xusertype IN (231,99,35,167)	AND 
						sysobjects.xtype='U' AND sysobjects.name<>'dtproperties' AND SUBSTRING(sysobjects.name,1,1) <> '_'
						AND sysobjects.NAME IN('BANK_ORDER_MONEY','BANK_ORDERS')
					ORDER BY
						sysobjects.NAME
				</cfquery> 
				<cfoutput query="GET_">
					<cfquery name="GET1" datasource="#db_in#">
						SELECT #COLUM_NAME# FROM #TABLE_NAME# WHERE  #COLUM_NAME# = 'YTL'
					</cfquery>
					<cfif GET1.RECORDCOUNT>
						<cfquery name="upd_" datasource="#db_in#">
							UPDATE #TABLE_NAME#  SET #COLUM_NAME# = 'TL' WHERE #COLUM_NAME# = 'YTL'
						</cfquery>
					</cfif>
				</cfoutput>
			</cftransaction>
		</cflock>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='52427.Aktarım Tamamlandı'>!");
				location.href = document.referrer;
		</script>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='49066.Aktarılacak Banka Talimatı Yok'>!");
				location.href = document.referrer;
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='49067.Seçtiğiniz Dönemler Arasında Aktarım Yapamazsınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
