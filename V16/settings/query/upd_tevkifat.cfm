<cfquery name="UPDTAX" datasource="#DSN3#">
	UPDATE 
		SETUP_TEVKIFAT
	SET 
		DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>'-'</cfif>,
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
		STATEMENT_RATE = <cfif len(attributes.statement_rate_numerator) and len(attributes.statement_rate_denominator)>1-(#wrk_round(attributes.statement_rate_numerator/attributes.statement_rate_denominator,8)#)<cfelse>#attributes.statement_rate#</cfif>,
        TAX_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.tax_code)#">,
        TAX_CODE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.tax_code)#">,
        TEVKIFAT_CODE = <cfif len(attributes.tevkifat_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.tevkifat_code,';')#"><cfelse>NULL</cfif>,
        TEVKIFAT_CODE_NAME = <cfif len(attributes.tevkifat_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.tevkifat_code,';')#"><cfelse>NULL</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		STATEMENT_RATE_NUMERATOR = <cfif len(attributes.statement_rate_numerator)>#attributes.statement_rate_numerator#<cfelse>NULL</cfif>,
		STATEMENT_RATE_DENOMINATOR = <cfif len(attributes.statement_rate_denominator)>#attributes.statement_rate_denominator#<cfelse>NULL</cfif>
	WHERE
		TEVKIFAT_ID = #attributes.tevkifat_id#
</cfquery>
<cfquery name="DELETE_ROW" datasource="#DSN3#">
	DELETE SETUP_TEVKIFAT_ROW WHERE TEVKIFAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tevkifat_id#">
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
                #attributes.tevkifat_id#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tevkifat_code#sayac#")#'>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tevkifat_beyan_code#sayac#")#'>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tevkifat_code_pur#sayac#")#'>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.tevkifat_beyan_code_pur#sayac#")#'>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value='#Evaluate("attributes.tax#sayac#")#'>
            )
		</cfquery>
	</cfif>
</cfloop>
<cflocation url="#request.self#?fuseaction=settings.form_upd_tevkifat&ID=#attributes.tevkifat_id#" addtoken="no">
