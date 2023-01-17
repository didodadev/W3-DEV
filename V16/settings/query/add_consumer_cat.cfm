<cf_xml_page_edit fuseact="settings.form_add_consumer_categories">
<cfif is_risk_limit_required eq 1 and isdefined('attributes.risk_limit') and Len(attributes.risk_limit)>
	<cfscript>attributes.risk_limit = filterNum(attributes.risk_limit);</cfscript>
</cfif>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfif isdefined("attributes.is_default")>
			<cfquery name="UPD_CATS" datasource="#DSN#">
				UPDATE CONSUMER_CAT SET IS_DEFAULT = 0
			</cfquery>
		</cfif>
		<cfquery name="INSCONSUMERCATEGORY" datasource="#DSN#" result="MAX_ID">
			INSERT INTO 
				CONSUMER_CAT
                (
                    IS_ACTIVE,
                    POSITION_CODE,
                    CONSCAT,
                    IS_INTERNET,
                    IS_PREMIUM,
                    HIERARCHY,
                    MIN_CONSCAT_ID,
                    MAX_CONSCAT_ID,
                    IS_DEFAULT,
                    IS_REF_ORDER,
                    IS_REF_RECORD,
                    IS_INTERNET_DENIED,
                    SHORT_NAME,
                    <cfif isdefined('attributes.risk_limit') and is_risk_limit_required eq 1>RISK_LIMIT,</cfif>
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE
                ) 
                VALUES 
                (
                    <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.position_code") and len(attributes.position_code)>#attributes.position_code#<cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#conscat#">,
                    <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.is_premium")>1<cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#hierarchy#">,
                    <cfif isdefined('attributes.min_cons_cat') and len(attributes.min_cons_cat)>#attributes.min_cons_cat#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.max_cons_cat') and len(attributes.max_cons_cat)>#attributes.max_cons_cat#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.is_default")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.is_ref_order")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.is_ref_record")>1<cfelse>0</cfif>,
                    <cfif isdefined("attributes.is_internet_denied")>1<cfelse>0</cfif>,
                    <cfif len(attributes.short_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.short_name#"><cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.risk_limit') and is_risk_limit_required eq 1>#attributes.risk_limit#,</cfif>
                    #session.ep.userid#,
                    '#cgi.remote_addr#',
                    #now()#
                )
		</cfquery>
        <cfif isdefined("attributes.is_internet") and attributes.is_internet eq 1>
            <cfquery name="GET_MENU_" datasource="#DSN#">
                SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL AND IS_ACTIVE = 1
            </cfquery>
            <cfoutput query="get_menu_">
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
                            #max_id.identitycol#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes["menu_#menu_id#"]#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Consumer">
                        )	
                    </cfquery>
                </cfif>
            </cfoutput>
		</cfif>
		<!--- iliskili sirketler yazılıyor --->
		<cfif isdefined("attributes.our_company_ids") and listlen(attributes.our_company_ids)>
			<cfloop from="1" to="#listlen(attributes.our_company_ids)#" index="i">
					<cfquery name="ADD_OUR_CONSUMER_CAT" datasource="#DSN#">
						INSERT INTO
							CONSUMER_CAT_OUR_COMPANY
                            (
                                CONSCAT_ID,
                                OUR_COMPANY_ID
                            )				
                            VALUES
                            (
                                #max_id.identitycol#,
                                #listgetat(attributes.our_company_ids,i)#
                            )
					</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<!--- iliskili sirketler yazılıyor --->
<cflocation url="#request.self#?fuseaction=settings.form_add_consumer_categories" addtoken="no">
