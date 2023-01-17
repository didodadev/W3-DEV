<cfquery name="GET_STUFF" datasource="#dsn#">
	SELECT STUFF_ID, STUFF_NAME FROM SETUP_OFFICE_STUFF ORDER BY STUFF_NAME 
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box  title="#getLang('','',32591)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>	
		<thead><tr><th><cf_get_lang dictionary_id='32591.Büro Yazılımları'></th></tr></thead>
			<tbody>
				<cfif get_stuff.recordcount>
				  <cfoutput query="get_stuff">
					<tr>
					  <td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#stuff_id#,'#stuff_name#')">#stuff_name#</a></td>
					</tr>
				  </cfoutput>
				  <cfelse>
					<tr >
						<td colspan="2" ><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				  	</tr>
				</cfif>
			</tbody>
		
	</cf_grid_list>
</cf_box>
<script type="text/javascript">
function gonder(stuff_id,stuff_name)
{
	var kontrol =0;
	uzunluk=<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==stuff_id){
			kontrol=1;
		}
	}
	if(kontrol==0){
		<cfif isDefined("attributes.field_name")>
			x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = stuff_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = stuff_name;
		</cfif>
		}
}
</script>
