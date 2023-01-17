
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
        <cfquery name="UPD_ANALYSIS" datasource="#DSN#">
            UPDATE
                MEMBER_ANALYSIS
            SET
                COMMENT1 = <cfif len(attributes.comment1)>#sql_unicode()#'#attributes.comment1#'<cfelse>NULL</cfif>,
                COMMENT2 = <cfif len(attributes.comment2)>#sql_unicode()#'#attributes.comment2#'<cfelse>NULL</cfif>, 
                COMMENT3 = <cfif len(attributes.comment3)>#sql_unicode()#'#attributes.comment3#'<cfelse>NULL</cfif>,
                COMMENT4 = <cfif len(attributes.comment4)>#sql_unicode()#'#attributes.comment4#'<cfelse>NULL</cfif>,
                COMMENT5 = <cfif len(attributes.comment5)>#sql_unicode()#'#attributes.comment5#'<cfelse>NULL</cfif>, 
		        DETAIL = <cfif isdefined('attributes.detail') and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
                PRODUCT_ID = <cfif len(attributes.analysis_product_id)>#attributes.analysis_product_id#<cfelse>NULL</cfif>,
                SCORE1 = <cfif len(attributes.score1)>#attributes.score1#<cfelse>NULL</cfif>,
                SCORE2 = <cfif len(attributes.score2)>#attributes.score2#<cfelse>NULL</cfif>,
                SCORE3 = <cfif len(attributes.score3)>#attributes.score3#<cfelse>NULL</cfif>,
                SCORE4 = <cfif len(attributes.score4)>#attributes.score4#<cfelse>NULL</cfif>,
                SCORE5 = <cfif len(attributes.score5)>#attributes.score5#<cfelse>NULL</cfif>,
                ANALYSIS_PARTNERS = <cfif isdefined("attributes.analysis_partners")>',#attributes.analysis_partners#,'<cfelse>NULL</cfif>, 
                ANALYSIS_CONSUMERS = <cfif isdefined("attributes.analysis_consumers")>',#attributes.analysis_consumers#,'<cfelse>NULL</cfif>,
                ANALYSIS_RIVALS = <cfif isDefined("attributes.analysis_rivals")>1<cfelse>0</cfif>,
                ANALYSIS_OBJECTIVE = <cfif len(attributes.analysis_objective)>#sql_unicode()#'#attributes.analysis_objective#'<cfelse>NULL</cfif>,
                IS_ACTIVE = <cfif isDefined("attributes.is_active")>1<cfelse>0</cfif>,
                IS_PUBLISHED = <cfif isDefined("attributes.is_published")>1<cfelse>0</cfif>,
                ANALYSIS_AVERAGE = #attributes.analysis_average#, 
                TOTAL_POINTS = #attributes.total_points#,
                ANALYSIS_HEAD = #sql_unicode()#'#attributes.analysis_head#',
                LANGUAGE_SHORT = <cfif len(attributes.language_short)>'#attributes.language_short#'<cfelse>NULL</cfif>,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = '#cgi.remote_addr#',
                ANALYSIS_STAGE = #attributes.process_stage#,
                GOOGLE_FORMS_URL = <cfif isDefined('google_form_url') and len(google_form_url)><cfqueryparam cfsqltype="cf_sql_varchar" value="#google_form_url#"><cfelse>NULL</cfif>
            WHERE
                ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#">
        </cfquery>

        <cfquery name="DEL_SITE_DOMAIN" datasource="#DSN#">
            DELETE FROM ANALYSIS_SITE_DOMAIN WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#">
        </cfquery>
        <cfif isdefined("attributes.is_published") and len(attributes.is_published)>
            <cfquery name="GET_COMPANY" datasource="#DSN#">
                select SITE_ID, DOMAIN   FROM PROTEIN_SITES
            </cfquery>
            <cfoutput query="get_company">
                <cfif isdefined("attributes.menu_#SITE_ID#")>
                    <cfquery name="ADD_ANALYSIS_SITE_DOMAIN" datasource="#DSN#">
						INSERT INTO
							ANALYSIS_SITE_DOMAIN
							(
								ANALYSIS_ID,		
								MENU_ID
							)
							VALUES
							(
								#attributes.analysis_id#,
								'#attributes["menu_#SITE_ID#"]#'
							)		
                    </cfquery>
                </cfif>
            </cfoutput>
        </cfif>

        <cf_workcube_process 
            is_upd='1' 
            old_process_line='#attributes.old_process_line#'
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='MEMBER_ANALYSIS'
            action_column='ANALYSIS_ID'
            action_id='#attributes.analysis_id#'
            action_page='#request.self#?fuseaction=member.analysis&analysis_id=#attributes.analysis_id#'
            warning_description='ÜYE ANALİZ FORMLARI'>
	</cftransaction>
</cflock>
<script type="text/javascript">
    window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=member.list_analysis&event=upd&analysis_id=<cfoutput>#attributes.analysis_id#</cfoutput>';
</script>
