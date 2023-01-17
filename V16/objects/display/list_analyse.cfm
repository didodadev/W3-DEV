<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfset url_str = "">
<cfif isdefined("attributes.field_id")>
<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.camp_id")>
	<cfset url_str = "#url_str#&camp_id=#attributes.camp_id#">
</cfif>
<cfquery name="GET_ANALYSIS" datasource="#dsn#">
	SELECT 
		ANALYSIS_ID,
		ANALYSIS_HEAD,
		IS_ACTIVE,
		IS_PUBLISHED,
		RECORD_EMP,
		RECORD_DATE
	FROM 
		MEMBER_ANALYSIS
	WHERE
		IS_ACTIVE = 1 AND 
		IS_PUBLISHED = 1
		<cfif len(attributes.keyword)>
		AND
		(
			ANALYSIS_HEAD LIKE '%#attributes.keyword#%' OR
			ANALYSIS_OBJECTIVE LIKE '%#attributes.keyword#%'
		)
		</cfif>
</cfquery>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_analysis.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
$(document).ready(function(){

    $( "#keyword" ).focus();

});
	function gonder(id,name)
	{
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
		</cfif>
		
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Üye Analiz Formları',29913)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search" action="#request.self#?fuseaction=objects.popup_list_analyse" method="post">
			<cf_box_search more="0">
				<cfif not isdefined("attributes.camp_id")>
					<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
					<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
				</cfif>
				<div class="form-group" id="keyword">
					<cfinput type="hidden" name="is_form_submitted" value="1">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='29764.Form'></th>
					<th><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
					<th width="65"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th width="50"><cf_get_lang dictionary_id='57756.Durum'></th>
					<th width="90"><cf_get_lang dictionary_id='33348.Yayın Durumu'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_analysis.recordcount>
				<cfoutput query="get_analysis" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<tr>
				<td>
				<cfif not isdefined("attributes.camp_id")>
					<a href="javascript://" onClick="gonder('#analysis_id#','#trim(analysis_head)#');" class="tableyazi">#analysis_head#</a>
				<cfelse>
					<a href="#request.self#?fuseaction=objects.emptypopup_add_camp_analyse&camp_id=#attributes.camp_id#&analysis_id=#analysis_id#" class="tableyazi">#analysis_head#</a>
				</cfif>
				</td>
				<td><cfif len(record_emp)>
							#get_emp_info(record_emp,0,1)#
						</cfif></td>
				<td>#dateformat(record_date,dateformat_style)#</td>
				<td><cfif is_active is 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.pasif'></cfif></td>
				<td><cfif is_published is 1><cf_get_lang dictionary_id='32779.Yayınlanıyor'><cfelse><cf_get_lang dictionary_id='32793.Yayınlanmıyor'></cfif></td>
				</tr>
				</cfoutput>
				<cfelse>
				<tr>
					<td colspan="6"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></td>
				</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
			</cfif>
			<cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="objects.popup_list_analyse#url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>

