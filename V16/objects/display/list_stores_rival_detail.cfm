<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_rival_list.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_rival_list.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function gonder(r_comp_id,rival_name)
{
	var kontrol =0;
	uzunluk=<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
	if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==r_comp_id)
	{
		kontrol=1;
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	

}
if(kontrol==0)
{
	<cfif isDefined("attributes.field_name")>
		x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = r_comp_id;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = rival_name;
	</cfif>
	}
}
</script>
<cf_box  title="#getLang('','',32582)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="list_rival" method="post" action="#request.self#?fuseaction=objects.popup_list_stores_rival_detail">
		<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
		<cf_box_search>
			<div class="form-group" id="item-keyword">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
				<cfinput type="text" tabindex="1" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50"  placeholder="#message#">
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" tabindex="3" name="maxrows" id="maxrows" required="yes" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" >
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_rival' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
	<thead>
		<tr>
			<th width="30"><cf_get_lang dictionary_id='57487.No'></tth>
			<th><cf_get_lang dictionary_id='32583.Rakip Adı'></tth>
			</tr>
		</thead>
		<tbody>	
			<cfif get_rival_list.recordcount>
				<cfoutput query="get_rival_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" class="tableyazi"  onClick="gonder(#r_id#,'#rival_name#')">#rival_name#</a></td>
					</tr>
				</cfoutput>
			<cfelse>
			<tr>
				<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
			</cfif>
		<tbody>	
	</cf_grid_list>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cfset url_str=''>
		<cfset url_str="url_str&field_name=#attributes.field_name#">
		<cfif len(attributes.keyword)>
			<cfset url_str="&url_str&keyword=#attributes.keyword#">
		</cfif>
		<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
			<cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
		</cfif>
		<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_list_stores_rival_detail&#url_str#" 
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>



