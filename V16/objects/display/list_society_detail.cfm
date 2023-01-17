<cfquery name="get_society" datasource="#dsn#">
	SELECT SOCIETY_ID,SOCIETY FROM SETUP_SOCIAL_SOCIETY ORDER BY SOCIETY
</cfquery>

<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Sosyal Güvenlik Kurumları','32562')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
      	<cf_grid_list >
			<thead><tr><th><cf_get_lang dictionary_id='58485.Şirket Adı'></th></tr></thead>
			<tbody>
				<cfif get_society.recordcount>
					<cfoutput query="get_society">
						<tr id=#currentrow# >
							<td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#society_id#,'#society#','#currentrow#')">#society#</a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td height="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
			</tbody>
      	</cf_grid_list>
</cf_box>

<script type="text/javascript">
function gonder(society_id,society,id)
{
	var kontrol =0;
	uzunluk=<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++)
	{
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==society_id)
		{
			kontrol=1;
		}
	}
	
	if(kontrol==0){
		<cfif isDefined("attributes.field_name")>
			x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>. <cfoutput>#attributes.field_name#</cfoutput>.options[x].value = society_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = society;
		</cfif>
		}
}
</script>
