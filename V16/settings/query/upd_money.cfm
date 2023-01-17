<cfquery name="MONEY_CHECK" datasource="#dsn#">
	SELECT 
		MONEY 
	FROM 
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY = '#ListFirst(attributes.money)#' AND 
		MONEY_ID <> #attributes.money_id#
</cfquery>
<cfif not money_check.recordcount>
	<cfquery name="UPD_MONEY" datasource="#dsn#">
		UPDATE 
			SETUP_MONEY 
		SET 
			<cfif ((rate2 neq 1) or (rate1 neq 1)) and isdefined("ACCOUNT_950")>
				ACCOUNT_950 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACCOUNT_950#">,
				PER_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.per_account#">,
 			</cfif>		
			MONEY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListFirst(attributes.money)#">,
			MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListLast(attributes.money)#">,
			MONEY_SYMBOL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_symbol#" null="#not len(attributes.money_symbol)#">,
			CURRENCY_CODE = <cfif ListLast(attributes.money) eq 'TL'>'TRY'<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#ListLast(attributes.money)#"></cfif>,
			RATE1 = #attributes.rate1#,
			RATE2 = #attributes.rate2#,
			RATE3 = #attributes.rate3#,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			RATEPP2 = #attributes.ratepp2#,
			RATEPP3 = #attributes.ratepp3#,
			RATEWW2 = #attributes.rateww2#,
			RATEWW3 = #attributes.rateww3#,
            EFFECTIVE_PUR =#attributes.efectiveAlis#,
            EFFECTIVE_SALE =#attributes.efectiveSatis#
		WHERE 
			MONEY_ID = #attributes.money_id# AND
			COMPANY_ID = #session.ep.company_id# AND
			PERIOD_ID = #session.ep.period_id# 
	</cfquery>
	<cfquery name="INSMONEY" datasource="#dsn#">
		INSERT INTO 
			MONEY_HISTORY
			(
				MONEY,
				COMPANY_ID,
				PERIOD_ID,
				RATE1,
				RATE2,
				RATE3,
				VALIDATE_DATE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				RATEPP2,
				RATEPP3,
				RATEWW2,
				RATEWW3,
                EFFECTIVE_PUR,
                EFFECTIVE_SALE
			) 
		VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ListFirst(attributes.money)#">,
				#session.ep.company_id#,
				#session.ep.period_id#,
				#attributes.rate1#,
				#attributes.rate2#,
				#attributes.rate3#,
				#CreateODBCDateTime('#year(now())#-#month(now())#-#day(now())#')#,
				#now()#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#attributes.ratepp2#,
				#attributes.ratepp3#,
				#attributes.rateww2#,
				#attributes.rateww3#,
                #attributes.efectiveAlis#,
                #attributes.efectiveSatis#
			)
	</cfquery>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='702.Girdiğiniz Para Birimi Zaten Kullanılıyor ! Lütfen Düzeltin !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<script>
	location.href = document.referrer;
</script>
