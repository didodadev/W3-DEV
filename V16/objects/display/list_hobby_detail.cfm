<cfinclude template="../query/get_hobby.cfm">
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33333.Hobiler'></cfsavecontent>
<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th class="form-title" width="178"><cf_get_lang dictionary_id='33333.Hobiler'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_hobby.recordcount>
			<cfoutput query="get_hobby">
				<tr height="20" onClick="this.bgColor='CCCCCC'" class="color-row">
					<td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#hobby_id#,'#hobby_name#')">#hobby_name#</a></td>
				</tr>
			  </cfoutput>
			<cfelse>
				<tr class="color-row">
					<td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
<script type="text/javascript">
function gonder(hobby_id,hobby_name)
{
	var kontrol =0;
	uzunluk=<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++)
	{
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==hobby_id)
		{
			kontrol=1;
		}
}

if(kontrol==0){
	<cfif isDefined("attributes.field_name")>
		x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = hobby_id;
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = hobby_name;
	</cfif>
	}
}
</script>
