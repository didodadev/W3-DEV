<cfquery name="get_stores_rival" datasource="#dsn#">
		SELECT 
		ACTIVITY_TYPE_ID, ACTIVITY_TYPE 
	FROM 
		SETUP_ACTIVITY_TYPES ORDER BY ACTIVITY_TYPE DESC
		</cfquery>
		<cfparam name="attributes.modal_id" default="">
<script type="text/javascript">
	function gonder(activity_id,activity_name)
	{
	var kontrol =0;
	uzunluk=<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==activity_id){
			kontrol=1;
		}
	}
if(kontrol==0){
			<cfif isDefined("attributes.field_name")>
			x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = activity_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = activity_name;
		</cfif>
	}
}
</script>
<cf_box  title="#getLang('','',51319)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>	
		<thead><tr><th><cf_get_lang dictionary_id='43218.Aktivite'></th></tr></thead>
			<tbody>
				<cfif get_stores_rival.recordcount>
				<cfoutput query="get_stores_rival">
				<tr id=#currentrow# >
						<td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#ACTIVITY_TYPE_ID#,'#ACTIVITY_TYPE#')">#ACTIVITY_TYPE#</a></td>
					</tr>		
			</cfoutput>
			<cfelse>
			<tr >
				<td colspan="4" ><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>

