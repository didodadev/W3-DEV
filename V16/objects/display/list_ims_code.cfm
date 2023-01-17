<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.plate_code" default="">
<cfparam name="attributes.ims_code_ids" default="0">
<cfparam name="attributes.related_ids" default="0">
<cfset url_string = "">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_IMS_CODE" datasource="#DSN#">
		SELECT
			IMS_CODE_ID,
			IMS_CODE,
			IMS_CODE_NAME
		FROM
			SETUP_IMS_CODE
		WHERE
			IMS_CODE_ID IS NOT NULL
			<cfif len(attributes.keyword)>
			AND
				(
				IMS_CODE LIKE '%#attributes.keyword#%' OR
				IMS_CODE_NAME LIKE '%#attributes.keyword#%'
				)
			</cfif>
			<cfif len(attributes.plate_code) and attributes.plate_code neq 'undefined'>AND (IMS_CODE LIKE '#attributes.plate_code#%' OR IMS_CODE LIKE '99%')</cfif>
		ORDER BY
			IMS_CODE
	</cfquery>
<cfelse>
	<cfset get_ims_code.recordcount = 0>
</cfif>

<cfparam name="attributes.totalrecords" default='#get_ims_code.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.modal_id" default=''>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script language="JavaScript">
$(document).ready(function(){

    $( "#keyword" ).focus();

});
function gonder(id,name)
{
   <cfif isDefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
	</cfif>
	<cfif isDefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Mikro Bölge Kodları',33342)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_ims" action="#request.self#?fuseaction=objects.popup_list_ims_code#url_string#" method="post">
			<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
			<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
			<input type="hidden" name="plate_code" id="plate_code" value="<cfif isdefined("attributes.plate_code") and len(attributes.plate_code)><cfoutput>#attributes.plate_code#</cfoutput></cfif>">
			<cf_box_search more="0">
				<div class="form-group" id="form_submitted">
					<cfinput type="hidden" name="form_submitted" value="1">
					<cfinput type="Text" maxlength="50" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" name="keyword">
					</div>
					<div class="form-group small">
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı!',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_ims' , #attributes.modal_id#)"),DE(""))#">
					<input type="hidden" name="is_submitted" id="is_submitted" value="1">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>		
					<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='52400.IMS Kod Numarası'></th>
					<th><cf_get_lang dictionary_id='52254.IMS'> <cf_get_lang dictionary_id ='42529.Bölge Adı'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_ims_code.recordcount>
				  <cfoutput query="get_ims_code" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" onClick="gonder('#ims_code_id#','#ims_code# #ims_code_name#')">#ims_code#</a></td>
						<td>#ims_code_name#</td>
					</tr>		
				  </cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_string = "#url_string#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif isdefined("field_id")>
			<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
		</cfif>
		<cfif isdefined("field_name")>
			<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
		</cfif>
		<cfif isdefined("keyword")>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.il_id")>
			<cfset url_string = "#url_string#&il_id=#attributes.il_id#">
		</cfif>
		<cfif isdefined("attributes.plate_code")>
			<cfset url_string ="#url_string#&plate_code=#attributes.plate_code#">
		</cfif>
		<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
			<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
		</cfif>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="objects.popup_list_ims_code#url_string#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>