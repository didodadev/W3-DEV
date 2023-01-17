<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>	
		<cfquery name="ADD_ANALYSIS" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				MEMBER_ANALYSIS
			(
				PRODUCT_ID,
				SCORE1, 
				SCORE2, 
				SCORE3, 
				SCORE4, 
				SCORE5, 
				COMMENT1, 
				COMMENT2, 
				COMMENT3, 
				COMMENT4, 
				COMMENT5, 
				DETAIL,
				ANALYSIS_PARTNERS, 
				ANALYSIS_CONSUMERS,  
				ANALYSIS_OBJECTIVE,  
				IS_ACTIVE,
				IS_PUBLISHED,
				ANALYSIS_AVERAGE, 
				TOTAL_POINTS, 
				ANALYSIS_HEAD,
				LANGUAGE_SHORT,
				RECORD_EMP, 
				RECORD_DATE, 
				RECORD_IP,
                ANALYSIS_STAGE,
				GOOGLE_FORMS_URL		
			)
			VALUES
			(
				<cfif len(attributes.analysis_product_id)>#attributes.analysis_product_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.score1)>#attributes.score1#<cfelse>NULL</cfif>,
				<cfif len(attributes.score2)>#attributes.score2#<cfelse>NULL</cfif>,
				<cfif len(attributes.score3)>#attributes.score3#<cfelse>NULL</cfif>,
				<cfif len(attributes.score4)>#attributes.score4#<cfelse>NULL</cfif>,
				<cfif len(attributes.score5)>#attributes.score5#<cfelse>NULL</cfif>,
				<cfif len(attributes.comment1)>#sql_unicode()#'#attributes.comment1#'<cfelse>NULL</cfif>,
				<cfif len(attributes.comment2)>#sql_unicode()#'#attributes.comment2#'<cfelse>NULL</cfif>,
				<cfif len(attributes.comment3)>#sql_unicode()#'#attributes.comment3#'<cfelse>NULL</cfif>,
				<cfif len(attributes.comment4)>#sql_unicode()#'#attributes.comment4#'<cfelse>NULL</cfif>,
				<cfif len(attributes.comment5)>#sql_unicode()#'#attributes.comment5#'<cfelse>NULL</cfif>,
				<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.analysis_partners")>',#attributes.analysis_partners#,'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.analysis_consumers")>',#attributes.analysis_consumers#,'<cfelse>NULL</cfif>,
				<cfif len(attributes.analysis_objective)>#sql_unicode()#'#attributes.analysis_objective#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.is_active")>1<cfelse>0</cfif>,
				<cfif isDefined("attributes.is_published")>1<cfelse>0</cfif>,
				#attributes.analysis_average#, 
				#attributes.total_points#, 
				#sql_unicode()#'#attributes.analysis_head#', 
				<cfif len(attributes.language_short)>'#attributes.language_short#'<cfelse>NULL</cfif>,
				#session.ep.userid#, 
				#now()#,
				'#cgi.remote_addr#',
                #attributes.process_stage#,
				<cfif isDefined('google_form_url') and len(google_form_url)><cfqueryparam cfsqltype="cf_sql_varchar" value="#google_form_url#"><cfelse>NULL</cfif>
			)
		</cfquery>
        
       	<cfif isdefined("attributes.is_published")>
			<cfquery name="GET_COMPANY" datasource="#DSN#">
				SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL AND IS_ACTIVE = 1
			</cfquery>
			<cfquery name="GET_SITES" datasource="#DSN#">
				SELECT SITE_ID,DOMAIN,COMPANY FROM PROTEIN_SITES WHERE DOMAIN IS NOT NULL AND PROTEIN_SITES.STATUS = 1
			</cfquery>
			<cfoutput query="get_sites">
				<cfif isdefined("attributes.menu_#site_id#")>
					<cfquery name="ADD_ANALYSIS_SITE_DOMAIN" datasource="#DSN#">
						INSERT INTO
							ANALYSIS_SITE_DOMAIN
							(
								ANALYSIS_ID,		
								MENU_ID
							)
							VALUES
							(
								#max_id.identitycol#,
								#attributes["menu_#site_id#"]#
							)	
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>

        <cf_workcube_process 
            is_upd='1' 
            old_process_line='0'
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='MEMBER_ANALYSIS'
            action_column='ANALYSIS_ID'
            action_id='#max_id.identitycol#'
			action_page='#request.self#?fuseaction=member.list_analysis&event=analysis&analysis_id=#max_id.identitycol#'
			warning_description='ÜYE ANALİZ FORMLARI'>
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.href = '<cfoutput>#request.self#?fuseaction=member.list_analysis&event=upd&analysis_id=#max_id.identitycol#</cfoutput>';
</script>
