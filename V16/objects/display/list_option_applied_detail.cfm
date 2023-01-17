<cfquery name="GET_OPS" datasource="#dsn#">
	SELECT PREFERENCE_REASON_ID, PREFERENCE_REASON FROM SETUP_RIVAL_PREFERENCE_REASONS ORDER BY PREFERENCE_REASON
</cfquery>
<cfparam name="attributes.modal_id" default="">
<script type="text/javascript">
	function gonder(paymethod_id,paymethod)
	{
	var kontrol =0;
	uzunluk=<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
	for(i=0;i<uzunluk;i++)
		{
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[i].value==paymethod_id){
			kontrol=1;
		}
	}
	
	if(kontrol==0){
		<cfif isDefined("attributes.field_name")>
			x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = paymethod_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = paymethod;
		</cfif>
		}
	}
</script>

<cf_box title="#getLang('','',33166)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>	
		<thead><tr><th><cf_get_lang dictionary_id='33166.Tercih Nedenleri'></th></tr></thead>
		<tbody>
			<cfif get_ops.recordcount>
				<cfoutput query="get_ops">
					<tr id=#currentrow#  >
					<td width="178"><a href="javascript://" class="tableyazi"  onClick="gonder(#preference_reason_id#,'#preference_reason#')">#preference_reason#</a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="2" ><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
