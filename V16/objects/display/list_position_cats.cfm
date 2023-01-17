<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfscript>
	url_string = '';
	if (isdefined('attributes.field_td')) url_string = '#url_string#&field_td=#attributes.field_td#';
	if (isdefined('attributes.is_noclose')) url_string = '#url_string#&is_noclose=#attributes.is_noclose#';
	if (isdefined("attributes.field_id")) url_string = "#url_string#&field_id=#attributes.field_id#";
	if (isdefined("attributes.field_cat")) url_string = "#url_string#&field_cat=#attributes.field_cat#";
	if (isdefined("attributes.field_cat_id")) url_string = "#url_string#&field_cat_id=#attributes.field_cat_id#";
	url_string = "#url_string#&is_form_submitted=1";
</cfscript>
<cfinclude template="../query/get_position_cats.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_position_cats.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function add_pos(cat_id,name)
{
<cfif isdefined("attributes.field_td")>
	<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.field_td#</cfoutput>.innerHTML += "<table class='label'><tr><td></td><td>"+name+"</td></tr></table>";
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value += "," + cat_id + ",";
</cfif>
<cfif isdefined("attributes.field_cat")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_cat#</cfoutput>.value = name;
</cfif>
<cfif isdefined("attributes.field_cat_id")>
	<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_cat_id#</cfoutput>.value = cat_id;
</cfif>
<cfif not isdefined("attributes.is_noclose")>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</cfif>
}
</script>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Pozisyon Tipleri',57779)#" scroll="0" collapsable="1" resize="1"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword ="url_string"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=objects.popup_list_position_cats#url_string#" method="post" name="search">
			<cf_box_search>
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>

		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_position_cats.recordcount and form_varmi eq 1>
					<cfoutput query="get_position_cats" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td><a href="javascript://" onClick="add_pos('#POSITION_CAT_ID#','#POSITION_CAT#');" class="tableyazi">#POSITION_CAT#</a></td>
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		
		<cfscript>
			if (isdefined('attributes.keyword') and len(attributes.keyword)) url_string = '#url_string#&keyword=#attributes.keyword#&is_form_submitted=1';
		</cfscript>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif form_varmi eq 1>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="objects.popup_list_position_cats#url_string#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			</cfif>
		</cfif>
</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
