<cfquery name="UPD_MONEY" datasource="#dsn#">
	UPDATE 
		SETUP_MONEY 
	SET
		RATE1 = <cfif len(attributes.rate1)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.rate1#"><cfelse>NULL</cfif>,
		RATE2 = <cfif len(attributes.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount#"><cfelse>NULL</cfif>,
		RATE3 = <cfif len(attributes.amount2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount2#"><cfelse>NULL</cfif>,
		RATEPP2 = <cfif len(attributes.amountpp)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountpp#"><cfelse>NULL</cfif>,
		RATEPP3 = <cfif len(attributes.amountpp2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountpp2#"><cfelse>NULL</cfif>,
		RATEWW2 = <cfif len(attributes.amountww)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountww#"><cfelse>NULL</cfif>,
		RATEWW3 = <cfif len(attributes.amountww2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountww2#"><cfelse>NULL</cfif>,
		EFFECTIVE_PUR = <cfif len(attributes.amount3)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount3#"><cfelse>NULL</cfif>,
		EFFECTIVE_SALE = <cfif len(attributes.amount4)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount4#"><cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY = '#attributes.money#'
</cfquery>
<cfquery name="ADD_MONEY" datasource="#dsn#">
	INSERT INTO 
		MONEY_HISTORY
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
			<cfif len(attributes.money)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.money#"><cfelse>NULL</cfif>,
			<cfif len(attributes.rate1)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.rate1#"><cfelse>NULL</cfif>,
			<cfif len(attributes.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount#"><cfelse>NULL</cfif>,
			<cfif len(attributes.amount2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount2#"><cfelse>NULL</cfif>,
			<cfif len(attributes.amountpp)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountpp#"><cfelse>NULL</cfif>,
			<cfif len(attributes.amountpp2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountpp2#"><cfelse>NULL</cfif>,
			<cfif len(attributes.amountww)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountww#"><cfelse>NULL</cfif>,
			<cfif len(attributes.amountww2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amountww2#"><cfelse>NULL</cfif>,
			<cfif len(attributes.amount3)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount3#"><cfelse>NULL</cfif>,
			<cfif len(attributes.amount4)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount4#"><cfelse>NULL</cfif>,
			#CreateODBCDateTime('#year(now())#-#month(now())#-#day(now())#')#,
			#now()#,
			#session.ep.userid#,
			'#CGI.REMOTE_ADDR#',
			#session.ep.period_id#,
			#session.ep.company_id#
		)
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		location.reload();
	</cfif>
</script>
