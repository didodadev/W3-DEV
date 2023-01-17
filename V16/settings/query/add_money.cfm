<cfquery name="MONEY_CHECK" datasource="#dsn#">
	SELECT 
		MONEY 
	FROM 
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY = '#ListFirst(attributes.money)#'
</cfquery>
<cfif not money_check.recordcount>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="INSMONEY" datasource="#dsn#" result="MAX_ID">
				INSERT INTO 
					SETUP_MONEY
                (
                    MONEY,
					MONEY_NAME,
					MONEY_SYMBOL,
                    CURRENCY_CODE,
                    RATE1,
                    RATE2,
                    RATE3,
                    MONEY_STATUS,	
                    COMPANY_ID,
                    PERIOD_ID,
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
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListLast(attributes.money)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListFirst(attributes.money)#">,
					<cfif len(attributes.money_symbol)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_symbol#"><cfelse>NULL</cfif>,
                    <cfif ListLast(attributes.money) eq 'TL'>'TRY'<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#ListLast(attributes.money)#"></cfif>,
                    #attributes.rate1#,
                    #attributes.rate2#,
                    #attributes.rate3#,
                    1,
                    #session.ep.company_id#,
                    #session.ep.period_id#,
                    #now()#,
                    #session.ep.userid#,
                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    #attributes.ratepp2#,
                    #attributes.ratepp3#,
                    #attributes.rateww2#,
                    #attributes.rateww3#,
                    #attributes.efectiveAlis#,
                    #attributes.efectiveSatis#
                    
                )
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
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListLast(attributes.money)#">,
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
		</cftransaction>
	</cflock>
	<script>
        location.href= document.referrer;
    </script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='702.Girdiğiniz Para Birimi Zaten Kullanılıyor ! Lütfen Düzeltin !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
