<cfset xfa.fuseac = attributes.fuseaction>
<cfset xfa.fuseac2 = "hr.emptypopup_empapp_quiz">
<cfset xfa.fuseac3 = "hr.popup_emp_upd_test_time">
<cfset url_str = "">
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.is_form_generators")>
	<cfset url_str = "#url_str#&is_form_generators=#attributes.is_form_generators#">
</cfif> 
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfquery name="get_detail_survey" datasource="#dsn#">
	SELECT 
		SURVEY_MAIN_ID,
		SURVEY_MAIN_HEAD,
		SURVEY_MAIN_DETAILS 
	FROM 
		SURVEY_MAIN 
	WHERE
	1=1 
	<cfif isDefined("attributes.type") and len(attributes.type)>
		AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type#">
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND SURVEY_MAIN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
	</cfif> 
	ORDER BY RECORD_DATE DESC
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_detail_survey.recordcount#"> 
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="29744.Değerlendirme Formları"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform method="post" action="#request.self#?fuseaction=#xfa.fuseac##url_str#" name="list_generators">
        	<cf_box_search>
				<div class="form-group" id="item-keyword">
				   <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Keyword',47046)#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_generators' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
        </cfform>
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="25"><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang dictionary_id='29764.Form'></th>
					<th><cf_get_lang dictionary_id="57771.Detay"></th>
					<th width="1%"><a <cfif fuseaction contains 'popup'>target="_blank"</cfif> href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_detail_survey_report&event=Add&action_type=6,7,10,14"><img src="/images/plus_list.gif" border="0"></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_detail_survey.recordcount>
				<cfoutput query="get_detail_survey" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<tr>
						<td>#currentrow#</td>
						<td>
							<cfif isdefined("is_form_generators")>
								<a href="##" class="tableyazi"  onClick="add_quiz(#survey_main_id#,'#survey_main_head#')">#survey_main_head#</a>
							<cfelse>
								<a href="#request.self#?fuseaction=#xfa.fuseac2#&quiz_id=#survey_main_id#<cfif IsDefined('attributes.empapp_id')>&empapp_id=#attributes.empapp_id#</cfif>" class="tableyazi">#survey_main_head#</a>
							</cfif>
						</td>
						<td>#survey_main_details#</td>
						<!-- sil -->
						<td><!--- <a href="#request.self#?fuseaction=#xfa.fuseac2#&survey_main_id=#survey_main_id#"><img src="/images/update_list.gif" border="0"></a> ---></td>
						<!-- sil -->
					</tr>
				</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="7"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.empapp_id")>
			<cfset url_str = "#url_str#&empapp_id=#attributes.empapp_id#">
		</cfif>
		<cfif isdefined("attributes.type")>
			<cfset url_str = "#url_str#&type=#attributes.type#">
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging 
				page="#attributes.page#"  
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#xfa.fuseac##url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function add_quiz(id,name)
	{
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
