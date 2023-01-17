<cfsetting showdebugoutput="no">
<cfquery name="GET_LANGS" datasource="#dsn#">
	SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
</cfquery>

<cfquery datasource="#dsn#">
	DELETE FROM 
		SETUP_LANGUAGE_INFO 
	WHERE 
		<cfif attributes.c_type eq 1>
			COMPANY_ID = #session.ep.company_id# AND
		<cfelseif  attributes.c_type eq 2>
			PERIOD_ID = #session.ep.period_id# AND
		</cfif>
		UNIQUE_COLUMN_ID = #attributes.c_id_value# AND
		COLUMN_NAME = '#attributes.c_name#' AND
		TABLE_NAME = '#attributes.t_name#'
</cfquery>
<cfloop query="get_langs">
	<cfset item_ = wrk_eval("attributes.deger_#get_langs.language_short#")>
    <cfif len(item_)>
        <cfquery name="insert_lang" datasource="#dsn#">
            INSERT INTO
                SETUP_LANGUAGE_INFO
            (
                TABLE_NAME,
                COLUMN_NAME,
                UNIQUE_COLUMN_ID,
                LANGUAGE,
                COMPANY_ID,
                PERIOD_ID,
                ITEM
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.t_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.c_name#">,
                #attributes.c_id_value#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#LANGUAGE_SHORT#">,
                <cfif attributes.c_type eq 1>#session.ep.company_id#<cfelse>NULL</cfif>,
                <cfif attributes.c_type eq 2>#session.ep.period_id#<cfelse>NULL</cfif>,
                #sql_unicode()#'#trim(item_)#'
            )
        </cfquery>	
    </cfif>
</cfloop>

<script type="text/javascript">
	location.href = document.referrer;
</script>
