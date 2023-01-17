<cftransaction>
    <cflock name="#createuuid()#" TIMEOUT="20">
        <cfquery name="ADD_COMPANY_CAT" datasource="#DSN#" result="MAX_ID">
            INSERT INTO 
                COMPANY_CAT
				(
					COMPANYCAT,
					DETAIL,
					COMPANYCAT_TYPE,
					IS_VIEW,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				) 
				VALUES 
				(
					'#attributes.companycat#',
					<cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
					#attributes.comp_type#,
					<cfif isdefined('attributes.is_view')>1<cfelse>0</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
        </cfquery>
        <cfif isdefined("attributes.is_view") and attributes.is_view eq 1>
            <cfquery name="get_menu_" datasource="#DSN#">
                SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL AND IS_ACTIVE = 1
            </cfquery>
            <cfif get_menu_.recordcount>
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
                                '#attributes["menu_#menu_id#"]#',
                                'Company'
                            )	
                        </cfquery>
                    </cfif>
                </cfoutput>
            </cfif>
        </cfif>
    </cflock>
</cftransaction>

<!--- iliskili sirketler yazılıyor --->
<cfif isdefined("attributes.our_company_ids") and listlen(attributes.our_company_ids)>
	<cfloop from="1" to="#listlen(attributes.our_company_ids)#" index="i">
			<cfquery name="ADD_OUR_COMPANY_CAT" datasource="#DSN#">
				INSERT INTO
					COMPANY_CAT_OUR_COMPANY
				(
					COMPANYCAT_ID,
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
<!--- iliskili sirketler yazılıyor --->
<cflocation url="#request.self#?fuseaction=settings.form_add_company_cat" addtoken="no">
