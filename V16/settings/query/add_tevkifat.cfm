<cfquery name="INSTAX" datasource="#dsn3#" result="MAX_ID">
	INSERT INTO 
		SETUP_TEVKIFAT 
        (
            STATEMENT_RATE,
            DETAIL,
            TAX_CODE,
            TAX_CODE_NAME,
            IS_ACTIVE,
            RECORD_IP,
            RECORD_DATE,
            RECORD_EMP,
            STATEMENT_RATE_NUMERATOR,
            STATEMENT_RATE_DENOMINATOR,
            TEVKIFAT_CODE,
            TEVKIFAT_CODE_NAME
        )
         VALUES 
        (    
            <cfif len(attributes.statement_rate_numerator) and len(attributes.statement_rate_denominator)>1-(#wrk_round(attributes.statement_rate_numerator/attributes.statement_rate_denominator,8)#)<cfelse>#attributes.statement_rate#</cfif>,
            <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>'-'</cfif>,
            '#listfirst(attributes.tax_code)#',
            '#listlast(attributes.tax_code)#',
            <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			'#cgi.remote_addr#',
            #now()#,
            #session.ep.userid#,
            <cfif len(attributes.statement_rate_numerator)>#attributes.statement_rate_numerator#<cfelse>NULL</cfif>,
            <cfif len(attributes.statement_rate_denominator)>#attributes.statement_rate_denominator#<cfelse>NULL</cfif>,
			<cfif len(attributes.tevkifat_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.tevkifat_code,';')#"><cfelse>NULL</cfif>,
            <cfif len(attributes.tevkifat_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.tevkifat_code,';')#"><cfelse>NULL</cfif>
        )
</cfquery>
<cfloop from="1" to="#attributes.record_num#" index="sayac">
	<cfif Evaluate("row_kontrol#sayac#") eq 1>
		<cfquery name="ADD_ROW" datasource="#DSN3#">
			INSERT INTO 
				SETUP_TEVKIFAT_ROW
			(
				TEVKIFAT_ID,
				TEVKIFAT_CODE,
				TEVKIFAT_BEYAN_CODE,
				TEVKIFAT_CODE_PUR,
				TEVKIFAT_BEYAN_CODE_PUR,
				TAX
			) 
			VALUES 
			(
				#MAX_ID.IDENTITYCOL#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tevkifat_code#sayac#")#'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tevkifat_beyan_code#sayac#")#'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tevkifat_code_pur#sayac#")#'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tevkifat_beyan_code_pur#sayac#")#'>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value='#Evaluate("attributes.tax#sayac#")#'>
			)
		</cfquery>
	</cfif>
</cfloop>
<cflocation url="#request.self#?fuseaction=settings.form_add_tevkifat" addtoken="no">
