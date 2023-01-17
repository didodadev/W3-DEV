<cfquery name="get_period" datasource="#DSN#">
   SELECT TOP 1 * FROM SETUP_PERIOD
</cfquery>
<cfif not get_period.recordcount>
	<cfquery name="get_comp" datasource="#DSN#">
	   SELECT NICK_NAME FROM OUR_COMPANY WHERE COMP_ID = 1
	</cfquery>	
	<cfset attributes.PERIOD_DATE="01/01/#year(now())#">
	<cfset attributes.process_date="01/01/#year(now())#">
	<cfset attributes.start_date="01/01/#year(now())#">
	<cfset attributes.finish_date="31/12/#year(now())#">
	<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="INS_PERIOD" datasource="#DSN#">
			INSERT INTO 
				SETUP_PERIOD
				(
					PERIOD_ID,
					PERIOD,
					PERIOD_YEAR,
					IS_INTEGRATED,
					OUR_COMPANY_ID,
					PERIOD_DATE,
					START_DATE,
					FINISH_DATE,
					PROCESS_DATE,
					OTHER_MONEY,
					STANDART_PROCESS_MONEY,
                    INVENTORY_CALC_TYPE,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
				) 
			VALUES 
				(
					1,
					'#get_comp.nick_name# - #year(now())#',
					#year(now())#,
					1,
					1,
					<cfqueryparam value = "#attributes.period_date#" CFSQLType = "cf_sql_timestamp">,
					<cfqueryparam value = "#attributes.start_date#" CFSQLType = "cf_sql_timestamp">,
					<cfqueryparam value = "#attributes.finish_date#" CFSQLType = "cf_sql_timestamp">,
					<cfqueryparam value = "#attributes.process_date#" CFSQLType = "cf_sql_timestamp">,
					<cfqueryparam value = "#standart_process_other_money#" CFSQLType = "cf_sql_nvarchar">,
					<cfqueryparam value = "#standart_process_money#" CFSQLType = "cf_sql_nvarchar">,
                    3,
					<cfqueryparam value = "#NOW()#" CFSQLType = "cf_sql_timestamp">,
					<cfqueryparam value = "#CGI.REMOTE_ADDR#" CFSQLType = "cf_sql_nvarchar">,
					1
				)
		</cfquery>
		<cfquery name="ADD_SETUP_MONEY" datasource="#DSN#">
			INSERT INTO 
				SETUP_MONEY
				(
					MONEY,MONEY_NAME,CURRENCY_CODE,RATE1,RATE2,RATEPP2,RATEPP3,RATEWW2,RATEWW3,MONEY_STATUS,PERIOD_ID,RECORD_DATE,RECORD_EMP,RECORD_IP,COMPANY_ID
				)
			VALUES
				(
					'#standart_process_money#','#standart_process_money#','#standart_process_money#',1,1,1,1,1,1,1,1,#now()#,1,'#CGI.REMOTE_ADDR#',1
				)
		</cfquery>
		<cfquery name="ADD_SETUP_MONEY" datasource="#DSN#">
			INSERT INTO 
				SETUP_MONEY
				(
					MONEY,MONEY_NAME,CURRENCY_CODE,RATE1,RATE2,RATEPP2,RATEPP3,RATEWW2,RATEWW3,MONEY_STATUS,PERIOD_ID,RECORD_DATE,RECORD_EMP,RECORD_IP,COMPANY_ID
				)
			VALUES
				(
					'#standart_process_other_money#','#standart_process_other_money#','#standart_process_other_money#',1,1.55,1,1.55,1,1.55,1,1,#now()#,1,'#CGI.REMOTE_ADDR#',1
				)
		</cfquery>
	</CFTRANSACTION>
	</CFLOCK>
</cfif>
