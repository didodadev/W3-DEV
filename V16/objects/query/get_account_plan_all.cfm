<cfif isdefined('attributes.db_source')>
	<cfif database_type is "MSSQL">
		<cfset db_source="#dsn#_#attributes.period_year#_#attributes.db_source#">
	<cfelseif database_type is "DB2">
		<cfset db_source="#dsn#_#attributes.db_source#_#Right(Trim(attributes.period_year),2)#">
	</cfif>
<cfelse>
	<cfset db_source=DSN2>
</cfif>

<cfstoredproc procedure="get_account_plan" datasource="#db_source#">
	<cfif isdefined("is_xml_remainder")>
    	<cfif is_xml_remainder eq 1 >
        	<cfprocparam cfsqltype="cf_sql_bit" value="1">
		<cfelse>
        	<cfprocparam cfsqltype="cf_sql_bit" value="0">
        </cfif>
    <cfelse>
    	<cfprocparam cfsqltype="cf_sql_bit" value="1">
    </cfif>
    <cfif isdefined("attributes.account_code") and len(attributes.account_code)>
   		<cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.account_code#">
    <cfelse>
    	<cfprocparam cfsqltype="cf_sql_varchar" value="">
    </cfif>
    <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.startrow#">
    <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.maxrows#">
    <cfprocresult name="account_plan">
</cfstoredproc>


<!--- <cfquery name="ACCOUNT_PLAN" DATASOURCE="#db_source#">
	SELECT
		*
	FROM
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_ID IS NOT NULL
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
            AND 
            (
            ACCOUNT_CODE LIKE '#attributes.keyword#%'
			<cfif session.ep.our_company_info.is_ifrs eq 1>
                OR IFRS_CODE LIKE '#attributes.keyword#%'
            </cfif>
            <!--- Hesap adina gore arama kaldirildi 20140509 --->
			<!--- <cfif len(attributes.keyword) gt 1>
                    OR ACCOUNT_NAME LIKE '%#attributes.keyword#%'
            </cfif> --->
            )
        </cfif>
        <!--- Hesap adina gore arama filtre alanı eklendi 20140520 --->
        <cfif isDefined("attributes.accountname") and len(attributes.accountname)>
         AND( ACCOUNT_NAME LIKE '%#attributes.accountname#%')
        </cfif>
    ORDER BY
		ACCOUNT_CODE
</cfquery>

 --->