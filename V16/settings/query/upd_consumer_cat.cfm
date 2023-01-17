<cf_xml_page_edit fuseact="settings.form_add_consumer_categories">
<cfif is_risk_limit_required eq 1 and isdefined('attributes.risk_limit') and Len(attributes.risk_limit)>
	<cfscript>attributes.risk_limit = filterNum(attributes.risk_limit);</cfscript>
</cfif>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfif isdefined("attributes.is_default")>
			<cfquery name="UPDA_CATS" datasource="#DSN#">
				UPDATE CONSUMER_CAT SET IS_DEFAULT = 0
			</cfquery>
		</cfif>
		<cfquery name="UPDCONSUMERCATEGORY" datasource="#DSN#"> 
			UPDATE 
				CONSUMER_CAT 
			SET	
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				POSITION_CODE = <cfif isdefined("attributes.position_code") and len(attributes.position_code)>#attributes.position_code#<cfelse>NULL</cfif>,
				CONSCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONSCAT#">,
				IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
				IS_PREMIUM = <cfif isdefined("attributes.is_premium")>1<cfelse>0</cfif>,
				SHORT_NAME = <cfif len(attributes.short_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.short_name#"><cfelse>NULL</cfif>,
				HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HIERARCHY#">,
				MIN_CONSCAT_ID = <cfif len(attributes.min_cons_cat)>#attributes.min_cons_cat#<cfelse>NULL</cfif>,
				MAX_CONSCAT_ID = <cfif len(attributes.max_cons_cat)>#attributes.max_cons_cat#<cfelse>NULL</cfif>,
				IS_DEFAULT = <cfif isdefined("attributes.is_default")>1<cfelse>0</cfif>,
				IS_REF_ORDER = <cfif isdefined("attributes.is_ref_order")>1<cfelse>0</cfif>,
                IS_REF_RECORD = <cfif isdefined("attributes.is_ref_record")>1<cfelse>0</cfif>,
				IS_INTERNET_DENIED = <cfif isdefined("attributes.is_internet_denied")>1<cfelse>0</cfif>,
				<cfif is_risk_limit_required eq 1>RISK_LIMIT = <cfif len(attributes.risk_limit)>#attributes.risk_limit#,<cfelse>0,</cfif></cfif>
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#conscat_id#">
		</cfquery> 
    	<cfquery name="DEL_SITE_DOMAIN" datasource="#DSN#">
			DELETE FROM CATEGORY_SITE_DOMAIN WHERE CATEGORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#conscat_id#">
		</cfquery>
		<cfif isdefined("attributes.is_internet") and attributes.is_internet eq 1>
            <cfquery name="GET_COMPANY" datasource="#DSN#">
                SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS 
            </cfquery>
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
                            #conscat_id#,
                            #attributes["menu_#menu_id#"]#,
                            'Consumer'
                        )	
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
		<cfquery name="DEL_CONSUMER_CAT_OUR_COMPANY" datasource="#DSN#">
			DELETE FROM CONSUMER_CAT_OUR_COMPANY WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.conscat_id#">
		</cfquery>
		<cfif isdefined("attributes.our_company_ids") and listlen(attributes.our_company_ids)>
			<cfloop list="#attributes.our_company_ids#" index="m">
				<cfquery name="ADD_CONSUMER_CAT_OUR_COMPANY" datasource="#DSN#">
					INSERT INTO
						CONSUMER_CAT_OUR_COMPANY
					(
						CONSCAT_ID,
						OUR_COMPANY_ID
					)	
					VALUES
					(
						#attributes.conscat_id#,
						#m#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>	

<script>
	location.href=document.referrer;
</script>
