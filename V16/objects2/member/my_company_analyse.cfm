<cfsetting showdebugoutput="no">
<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT 
		CP.PARTNER_ID
	FROM 
		COMPANY_PARTNER CP, 
		COMPANY C
	WHERE 
		CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND 
		CP.COMPANY_ID = C.COMPANY_ID AND
		COMPANY_PARTNER_STATUS=1
	ORDER BY
		CP.COMPANY_PARTNER_NAME
</cfquery>
<cfif len(attributes.cpid)>
	<cfquery name="GET_PARTNER_ANALYSES" datasource="#DSN#">
		SELECT 
			MEMBER_ANALYSIS.ANALYSIS_ID,
			MEMBER_ANALYSIS.ANALYSIS_HEAD,
			MEMBER_ANALYSIS.ANALYSIS_PARTNERS,
			MEMBER_ANALYSIS.TOTAL_POINTS
		FROM 
			MEMBER_ANALYSIS,
			COMPANY,
			COMPANY_CAT
		WHERE
			MEMBER_ANALYSIS.IS_ACTIVE = 1 AND
			MEMBER_ANALYSIS.IS_PUBLISHED = 1 AND
            MEMBER_ANALYSIS.ANALYSIS_ID IN (
                                SELECT 
                                    ANALYSIS_ID 
                                FROM 
                                    ANALYSIS_SITE_DOMAIN 
                                WHERE 
                                    MENU_ID = <cfif isDefined('session.pp.menu_id')>
                                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#">
                                                 <cfelse>
                                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#">
                                                 </cfif>
            				) AND
			COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
			COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID		
	</cfquery>
	<div class="table-responsive-lg">
		<table class="table">
			<cfif get_partner_analyses.recordcount  and get_partner.recordcount>
				<cfoutput query="get_partner_analyses">
					<cfquery name="GET_PARTNER_ANALYSIS_RESULT" datasource="#DSN#" maxrows="1">
						SELECT 
							USER_POINT 
						FROM 
							MEMBER_ANALYSIS_RESULTS
						WHERE 
							ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner_analyses.analysis_id#">
							AND PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner.partner_id#"> ORDER BY RESULT_ID DESC				
					</cfquery>
					<tr> 
						<td><a href="#request.self#?fuseaction=objects2.dsp_analyses&analysis_id=#analysis_id#&company_id=#attributes.cpid#" class="tableyazi">#analysis_head#<cfif get_partner_analysis_result.recordcount> - #get_partner_analysis_result.user_point#/#get_partner_analyses.total_points#</cfif></a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr> 
					<td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</table>
	</div>
</cfif>