<cfquery name="UPD_MONEY" datasource="#dsn#">
	UPDATE 
		TEXTILE_SETUP_MONEY 
	SET
		RATE1 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.rate1#">,
		RATE2 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount#">,
		RATE3 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount2#">,
		RATEPP2 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountpp#">,
		RATEPP3 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountpp2#">,
		RATEWW2 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountww#">,
		RATEWW3 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountww2#">,
		EFFECTIVE_PUR = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount3#">,
		EFFECTIVE_SALE = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount4#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY = '#attributes.money#'
</cfquery>
<cfquery name="ADD_MONEY" datasource="#dsn#">
	INSERT INTO 
		TEXTILE_MONEY_HISTORY
		(
			MONEY,
			RATE1,
			RATE2,
			RATE3,
			RATEPP2,
			RATEPP3,
			RATEWW2,
			RATEWW3,
			EFFECTIVE_PUR,
			EFFECTIVE_SALE,
			VALIDATE_DATE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			PERIOD_ID,
			COMPANY_ID
		) 
	VALUES 
		(
			'#attributes.money#',
			#attributes.rate1#,
			#attributes.amount#,
			#attributes.amount2#,
			#attributes.amountpp#,
			#attributes.amountpp2#,
			#attributes.amountww#,
			#attributes.amountww2#,
			#attributes.amount3#,
			#attributes.amount4#,
			#CreateODBCDateTime('#year(now())#-#month(now())#-#day(now())#')#,
			#now()#,
			#session.ep.userid#,
			'#CGI.REMOTE_ADDR#',
			#session.ep.period_id#,
			#session.ep.company_id#
		)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
