<cfquery name="get_position" datasource="#dsn#">
	SELECT 
		POSITION_ID, 
		POSITION_NAME 
	FROM 
		SETUP_CUSTOMER_POSITION 
	ORDER BY 
		POSITION_NAME 
</cfquery>
<cfparam name="attributes.modal_id" default="">
<script type="text/javascript">
	function gonder(position_id,position_name)
	{
	var kontrol =0;
	uzunluk=<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++){
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==position_id){
			kontrol=1;
		}
	}
	
	if(kontrol==0){
		<cfif isDefined("attributes.field_name")>
			x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = position_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = position_name;
		</cfif>
		}
	}
</script>
<cf_box  title="#getLang('','',33334)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>	
		<thead><tr><th><cf_get_lang dictionary_id='33334.Müşterinin Genel Konumu'></th></tr></thead>
		<tbody>
			<cfif get_position.recordcount>
				<cfoutput query="get_position">
					<tr>
						<td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#position_id#,'#position_name#')">#position_name#</a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		
	</tbody>
	</cf_grid_list>
</cf_box>



