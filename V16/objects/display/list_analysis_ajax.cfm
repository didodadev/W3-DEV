<cfsetting showdebugoutput="no">
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT IS_MULTI_ANALYSIS_RESULT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfif len(attributes.partner_id)>
	<cfquery name="GET_CATID" datasource="#DSN#">
		SELECT 
			C.COMPANYCAT_ID MEMBER_CAT_ID
		FROM
			COMPANY_PARTNER CP,
			COMPANY C 
		WHERE 
			CP.COMPANY_ID = C.COMPANY_ID AND
			CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
	</cfquery>
	<cfquery name="GET_MEMBER_ANALYSIS" datasource="#DSN#">
		SELECT 
			ANALYSIS_ID,
			ANALYSIS_HEAD,
			ANALYSIS_PARTNERS,
			GOOGLE_FORMS_URL	
		FROM 
			MEMBER_ANALYSIS
		WHERE
			<cfif isdefined("attributes.result_status") and attributes.result_status eq 1>
				IS_ACTIVE = 1 AND
			<cfelseif isdefined("attributes.result_status") and attributes.result_status eq 0>
				IS_ACTIVE = 0 AND
			<cfelseif not isdefined("attributes.result_status")>
				IS_ACTIVE = 1 AND
			</cfif>
			IS_PUBLISHED = 1 AND
			ANALYSIS_PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_catid.member_cat_id#,%">
	</cfquery>
<cfelseif len(attributes.consumer_id)>
	<cfquery name="GET_CATID" datasource="#DSN#">
		SELECT 
			CONSUMER_CAT_ID MEMBER_CAT_ID
		FROM
			CONSUMER
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
	<cfquery name="GET_MEMBER_ANALYSIS" datasource="#DSN#">
		SELECT 
			ANALYSIS_ID,
			ANALYSIS_HEAD,
			ANALYSIS_PARTNERS,
			GOOGLE_FORMS_URL	
		FROM 
			MEMBER_ANALYSIS
		WHERE
			<cfif isdefined("attributes.result_status") and attributes.result_status eq 1>
				IS_ACTIVE = 1 AND
			<cfelseif isdefined("attributes.result_status") and attributes.result_status eq 0>
				IS_ACTIVE = 0 AND
			<cfelseif not isdefined("attributes.result_status")>
				IS_ACTIVE = 1 AND
			</cfif>
			IS_PUBLISHED = 1 AND
			ANALYSIS_CONSUMERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_catid.member_cat_id#,%">
	</cfquery>
<!--- Kurumsal yada bireysel uye yoksa --->
<cfelseif len(attributes.rival_id)>
	<cfquery name="GET_MEMBER_ANALYSIS" datasource="#DSN#">
		SELECT 
			ANALYSIS_ID,
			ANALYSIS_HEAD,
			ANALYSIS_PARTNERS,
			GOOGLE_FORMS_URL	
		FROM 
			MEMBER_ANALYSIS
		WHERE
			<cfif isdefined("attributes.result_status") and attributes.result_status eq 1>
				IS_ACTIVE = 1 AND
			<cfelseif isdefined("attributes.result_status") and attributes.result_status eq 0>
				IS_ACTIVE = 0 AND
			<cfelseif not isdefined("attributes.result_status")>
				IS_ACTIVE = 1 AND
			</cfif>
			IS_PUBLISHED = 1 AND
			ANALYSIS_RIVALS = 1
	</cfquery>
<cfelse>
	<cfset get_member_analysis.recordcount = 0>
</cfif>
<cfif get_member_analysis.recordcount>
	<cfquery name="GET_MEMBER_ANALYSIS_RESULT_ALL" datasource="#DSN#">
		SELECT
			RESULT_ID,
			PARTNER_ID,	
			ANALYSIS_ID
		FROM	
			MEMBER_ANALYSIS_RESULTS
		WHERE
		<cfif len(attributes.partner_id)>
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"> AND
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		<cfelseif len(attributes.consumer_id)>
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<!--- sadece uye detayindan kaydedilen sonuclar --->
		<cfif attributes.action_type eq 'MEMBER'>
			AND OPPORTUNITY_ID IS NULL
			AND OFFER_ID IS NULL
			AND PROJECT_ID IS NULL
		<!--- sadece firsat detayindan kaydedilen sonuclar --->
		<cfelseif attributes.action_type eq 'OPPORTUNITY'>
			AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">		
			AND OPPORTUNITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
		<!--- sadece teklif detayindan kaydedilen sonuclar --->
		<cfelseif attributes.action_type eq 'OFFER'>
			AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">		
			AND OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
		<cfelseif attributes.action_type eq 'PROJECT'>
			AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
		<cfelseif attributes.action_type eq 'RIVAL'>
			RIVAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
		</cfif>
		ORDER BY
			RESULT_ID DESC
	</cfquery>
<cfelse>
	<cfset get_member_analysis_result_all.recordcount = 0>
</cfif>

<cfif get_member_analysis.recordcount gte 10>
	<cfset my_height = 225>
<cfelseif get_member_analysis.recordcount lt 10>
	<cfset my_height = get_member_analysis.recordcount*25>
<cfelse>
	<cfset my_height = 15>
</cfif>

<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='62147.Analiz Adı'></th>
			<th class="text-center"><a><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='29779.Analiz Sonucu'>"></i></a></th>
			<th class="text-center"><a><i class="fa fa-copy" title="<cf_get_lang dictionary_id='57476.Kopyala'>"></i></a></th>
			<cfif get_member_analysis.recordcount and len(GET_MEMBER_ANALYSIS.GOOGLE_FORMS_URL)>
				<th class="text-center"><a><i class="fa fa-file-text-o" title="<cf_get_lang dictionary_id='65133.Google Forms'>"></i></a></th>
			</cfif>
		</tr>
	</thead>
<tbody>
<cfif get_member_analysis.recordcount>
	<cfloop query="get_member_analysis">
		<!--- Ilgili analize ait tum sonuclar bulunur --->
		<cfquery name="GET_MEMBER_ANALYSIS_RESULT" dbtype="query">
			SELECT 
				RESULT_ID,
				ANALYSIS_ID
			FROM 
				GET_MEMBER_ANALYSIS_RESULT_ALL
			WHERE 
				ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member_analysis.analysis_id#">
		</cfquery>
		<cfif get_member_analysis_result.recordcount>
		<cfoutput query="get_member_analysis_result">
			<cfquery name="GET_MEMBER_ANALYSIS_RESULT_ROW" dbtype="query">
				SELECT 
					RESULT_ID 
				FROM 
					GET_MEMBER_ANALYSIS_RESULT_ALL
				WHERE 
					RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_member_analysis_result.result_id#">
			</cfquery>
			<tr>
				<td>
					<cfif attributes.is_analysis_link eq 1>
						<a href="#request.self#?fuseaction=member.list_analysis&event=det&analysis_id=#analysis_id#" class="tableyazi">#left(get_member_analysis.analysis_head[get_member_analysis.currentrow],30)#<cfif len(get_member_analysis.analysis_head[get_member_analysis.currentrow]) gt 30>...</cfif></a>
					<cfelse>
						#left(get_member_analysis.analysis_head[get_member_analysis.currentrow],30)#<cfif len(get_member_analysis.analysis_head[get_member_analysis.currentrow]) gt 30>...</cfif>
					</cfif>
				</td>
				<td width="15" class="text-center" nowrap="nowrap">
					<!--- eger analize sonuc girilmis ise --->
					<cfif get_member_analysis_result_row.recordcount>
						<cfif len(attributes.partner_id)>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=upd-result&action_type=#attributes.action_type#&analysis_id=#analysis_id#&result_id=#get_member_analysis_result.result_id#&member_type=partner&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a> 
						<cfelseif len(attributes.consumer_id)>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=upd-result&action_type=#attributes.action_type#&analysis_id=#analysis_id#&result_id=#get_member_analysis_result.result_id#&member_type=consumer&consumer_id=#attributes.consumer_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a> 
						<cfelseif len(attributes.rival_id)>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=upd-result&action_type=#attributes.action_type#&analysis_id=#analysis_id#&result_id=#get_member_analysis_result.result_id#&member_type=rival&rival_id=#attributes.rival_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a>
						</cfif>
					<cfelse>
						<cfif len(attributes.partner_id)>
							<cfif not listfindnocase(denied_pages,'member.popup_analysis_results_only_member')><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=add-result&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&analysis_id=#get_member_analysis.analysis_id[get_member_analysis.currentrow]#&member_type=partner&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfif>
						<cfelse>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.popup_add_member_analysis_result&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&analysis_id=#get_member_analysis.analysis_id[get_member_analysis.currentrow]#&member_type=consumer&consumer_id=#attributes.consumer_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a>
						</cfif>
					</cfif>	
				</td>
				<cfif get_member_analysis_result_row.recordcount>
					<td width="15" class="text-center" nowrap="nowrap">
						<cfif len(attributes.partner_id)>
							<cfif get_our_company_info.is_multi_analysis_result eq 1>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.popup_add_member_analysis_result&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&analysis_id=#analysis_id#&member_type=partner&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#&result_id=#get_member_analysis_result.result_id#');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='57476.Kopyala'>"></i></a>
							</cfif>
						<cfelseif len(attributes.consumer_id)>
							<cfif get_our_company_info.is_multi_analysis_result eq 1>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.popup_add_member_analysis_result&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&analysis_id=#analysis_id#&member_type=consumer&consumer_id=#attributes.consumer_id#&result_id=#get_member_analysis_result.result_id#');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='57476.Kopyala'>"></i></a>
							</cfif>
						<cfelseif len(attributes.rival_id)>
							<cfif get_our_company_info.is_multi_analysis_result eq 1>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.popup_add_member_analysis_result&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&analysis_id=#analysis_id#&member_type=rival&rival_id=#attributes.rival_id#&result_id=#get_member_analysis_result.result_id#');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='57476.Kopyala'>"></i></a>
							</cfif>
						</cfif>
					</td>
				</cfif>
				<cfif len(GET_MEMBER_ANALYSIS.GOOGLE_FORMS_URL)>
					<td class="text-center"><a href="#GET_MEMBER_ANALYSIS.GOOGLE_FORMS_URL#" target="_blank"><i class="fa fa-file-text-o" title="<cf_get_lang dictionary_id='65133.Google Forms'>"></i></a></td>
				</cfif>
			</tr>
		</cfoutput>
		<cfelse>
		<!--- Ilgili analize ait sonuc yoksa --->
			<cfoutput>
			<tr>
				<td>
					<cfif attributes.is_analysis_link eq 1>
						<a href="#request.self#?fuseaction=member.list_analysis&event=det&analysis_id=#analysis_id#" class="tableyazi">#left(get_member_analysis.analysis_head,30)#<cfif len(get_member_analysis.analysis_head) gt 30>...</cfif></a>
					<cfelse>
						#left(get_member_analysis.analysis_head,30)#<cfif len(get_member_analysis.analysis_head) gt 30>...</cfif>
					</cfif>
				</td>
				<td width="15" class="text-center">
					<cfif len(attributes.partner_id)>
						<cfif not listfindnocase(denied_pages,'member.popup_analysis_results_only_member')><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=add-result&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&analysis_id=#get_member_analysis.analysis_id#&member_type=partner&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfif>
					<cfelseif len(attributes.consumer_id)>
						<cfif not listfindnocase(denied_pages,'member.popup_analysis_results_only_member')><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=add-result&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&analysis_id=#get_member_analysis.analysis_id#&member_type=consumer&consumer_id=#attributes.consumer_id#');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfif>
					<cfelseif len(attributes.rival_id)>
						<cfif not listfindnocase(denied_pages,'member.popup_analysis_results_only_member')><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=add-result&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&analysis_id=#get_member_analysis.analysis_id#&member_type=rival&rival_id=#attributes.rival_id#');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfif>
					</cfif>
				</td>
				<cfif len(GET_MEMBER_ANALYSIS.GOOGLE_FORMS_URL)>
					<td class="text-center"><a href="#GET_MEMBER_ANALYSIS.GOOGLE_FORMS_URL#" target="_blank"><i class="fa fa-file-text-o" title="<cf_get_lang dictionary_id='65133.Google Forms'>"></i></a></td>
				</cfif>
			</tr>
			</cfoutput>
		</cfif>
	</cfloop>
<cfelse>
	<tr>
		<td colspan="2"><cf_get_lang dictionary_id='57484.Kayit Yok'></td>
	</tr>		
</cfif>
</tbody>
</cf_ajax_list>
