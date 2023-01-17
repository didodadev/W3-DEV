<cfquery name="GET_ANALYSES" datasource="#DSN#">
	SELECT 
		ANALYSIS_ID,
		ANALYSIS_HEAD,
		ANALYSIS_OBJECTIVE,
		IS_ACTIVE,
		IS_PUBLISHED,
		RECORD_DATE
	FROM 
		MEMBER_ANALYSIS
	WHERE
		IS_ACTIVE = 1 AND
		IS_PUBLISHED = 1 AND
        ANALYSIS_ID IN (
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
		<cfif isdefined("session.pp.company_category")>
			ANALYSIS_PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%">
		<cfelseif isdefined("session.ww.consumer_category")>
			ANALYSIS_CONSUMERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ww.consumer_category#%">
        <cfelse>
        	1 = 1
		</cfif>
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
	<cfif get_analyses.recordcount>
		<cfoutput query="get_analyses">
	  		<tr <cfif currentrow mod 2>class="color-row"<cfelse>class="color-list"</cfif> style="height:20px;">
				<td>
					<a href="#request.self#?fuseaction=objects2.dsp_analyses&analysis_id=#get_analyses.analysis_id#<cfif isdefined('attributes.company_id')>&company_id=#attributes.company_id#</cfif>"><b>#analysis_head# </b></a><br/>
                    #analysis_objective#
                    <br/><br/>
				</td>
	  		</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" style="height:20px;">
	  		<td>&nbsp;&nbsp;&nbsp;<cf_get_lang_main no='72.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>
