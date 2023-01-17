<cfquery name="UPDCOMPANYCAT" datasource="#DSN#">
	UPDATE 
		COMPANY_CAT 
	SET 
		COMPANYCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#companycat#">, 
		DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		COMPANYCAT_TYPE = <cfif isdefined("attributes.comp_type")>#attributes.comp_type#<cfelse>NULL</cfif>,
		IS_VIEW = <cfif isdefined('attributes.is_view')>1<cfelse>0</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.companycat_id#">
</cfquery>

<cfquery name="DEL_SITE_DOMAIN" datasource="#DSN#">
	DELETE FROM CATEGORY_SITE_DOMAIN WHERE CATEGORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.companycat_id#">
</cfquery>
<cfif isdefined("attributes.is_view") and attributes.is_view eq 1>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS 
	</cfquery>
    <cfif get_company.recordcount>
		<cfoutput query="get_company">
            <cfif isdefined("attributes.menu_#menu_id#")>
                <cfquery name="ADD_CATEGORY_SITE_DOMAIN" datasource="#DSN#">
                    INSERT INTO
                        CATEGORY_SITE_DOMAIN
                        (
                            CATEGORY_ID,		
                            MENU_ID,
                            MEMBER_TYPE
                        )
                    VALUES
                        (
                            #attributes.companycat_id#,
                            '#attributes["menu_#menu_id#"]#',
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Company">
                        )	
                </cfquery>
            </cfif>
        </cfoutput>
    </cfif>
</cfif>

<cfquery name="DEL_COMPANY_CAT_OUR_COMPANY" datasource="#DSN#">
	DELETE FROM COMPANY_CAT_OUR_COMPANY WHERE COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.companycat_id#">
</cfquery>


<cfif isdefined("attributes.our_company_ids") and listlen(attributes.our_company_ids)>
	<cfloop list="#attributes.our_company_ids#" index="m">
		<cfquery name="ADD_COMPANY_CAT_OUR_COMPANY" datasource="#DSN#">
			INSERT INTO
				COMPANY_CAT_OUR_COMPANY
			(
				COMPANYCAT_ID,
				OUR_COMPANY_ID
			)	
			VALUES
			(
				#attributes.companycat_id#,
				#m#
			)
		</cfquery>
	</cfloop>
</cfif>
<script>

	location.href=document.referrer;

</script>