<cfsetting showdebugoutput="no">
<cfquery name="get_organizations" datasource="#dsn#">
    SELECT
		ORGANIZATION_ID,
		ORGANIZATION_HEAD,
    	ORGANIZATION_PLACE,
		START_DATE,
		FINISH_DATE   
    FROM
        ORGANIZATION 
    WHERE
	<cfif isdefined("attributes.project_id")>
		PROJECT_ID = #attributes.project_id#
	<cfelseif isdefined("attributes.camp_id")>
		CAMPAIGN_ID = #attributes.camp_id#
	</cfif>
</cfquery>
<cf_ajax_list>
	<cfform name="organizations" method="post" action="">
    <thead>
		<tr>
			<th style="width:20px;"><cf_get_lang dictionary_id='57487.No'></th>
			<th style="width:50px"><cf_get_lang dictionary_id='29510.Olay'></th>
			<th style="width:150px;"><cf_get_lang dictionary_id='58664.Yeri'></th>
			<th style="width:150px"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
			<th style="width:150px"><cf_get_lang dictionary_id='57502.Bitiş'></th>
			<th style="width:15px;"></th>
			<th style="width:15px;"></th> 
		</tr>
     </thead>
     <tbody>
		<cfif get_organizations.recordcount>
			<cfoutput query="get_organizations">
				<tr>
					<div id="organization_div_#organization_id#">
					<td>#currentrow#</td>
					<td>
						<a href="#request.self#?fuseaction=campaign.list_organization&event=upd&org_id=#organization_id#" class="tableyazi">#organization_head#</a>
					</td>
					<td>#organization_place#</td>
					<td>
						<cfset start_date_ = date_add("h",session.ep.time_zone,start_date)>
                    	#dateformat(start_date_,dateformat_style)# #timeformat(start_date_,timeformat_style)#
                    </td>
					<td>
                    	<cfset finish_date_ = date_add("h",session.ep.time_zone,finish_date)>
                    	#dateformat(finish_date_,dateformat_style)# #timeformat(finish_date_,timeformat_style)#
                    </td>
					<td><a href="#request.self#?fuseaction=campaign.list_organization&event=upd&<cfif isdefined("attributes.project_id")>prj_id=#attributes.project_id#<cfelseif isdefined("attributes.camp_id")>camp_id=#attributes.camp_id#</cfif>&org_id=#organization_id#"><img src="/images/update_list.gif" border="0"></a></td>
					<td><a href="javascript://" onClick="delete_organization(#organization_id#);"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id ='57463.sil'>"></a></td> 
					</div>  
				</tr>
		   </cfoutput>
		<cfelse>
			<tr>
				<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
   </cfform>
  </tbody>
</cf_ajax_list>
<script type="text/javascript">
function delete_organization(organization_id)
{
	if(confirm("<cf_get_lang dictionary_id='60067.Organizasyon Silinecek'>! <cf_get_lang dictionary_id ='48488.Emin misiniz?'>"))
	{
		div_id = 'organization_div_'+organization_id;
		var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=campaign.emptypopup_del_organization&org_id='+organization_id;
		AjaxPageLoad(send_address,div_id,0);
	}
	else
	{
		return false;
	}
}
</script>  
