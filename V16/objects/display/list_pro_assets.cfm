<cfinclude template="../query/get_assetp_cats_reserve.cfm">
<cfif isdefined("attributes.is_form_submitted")>
    <cfinclude template="../query/get_assetps_reserve.cfm">
<cfelse>
	<cfset get_assetps_reserve.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.asset_catid" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.is_form_submitted")>
	<cfparam name="attributes.totalrecords" default='#get_assetps_reserve.recordcount#'>
<cfelse>
	<cfset get_assetps_reserve.recordcount = 0>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfset adres = "">
<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
	<cfset adres = "#adres#&project_id=#attributes.project_id#">
</cfif>
<cfif isDefined('attributes.work_id') and len(attributes.work_id)>
	<cfset adres = "#adres#&work_id=#attributes.work_id#">
</cfif>
<cfif isDefined('attributes.prod_order_id') and len(attributes.prod_order_id)>
	<cfset adres = "#adres#&prod_order_id=#attributes.prod_order_id#">
</cfif>
<cfif isDefined('attributes.class_id') and len(attributes.class_id)>
	<cfset adres = "#adres#&class_id=#attributes.class_id#">
</cfif>
<cfif isDefined('attributes.event_id') and len(attributes.event_id)>
	<cfset adres = "#adres#&event_id=#attributes.event_id#">
</cfif>
<cfif isDefined('attributes.field_id') and len(attributes.field_id)>
	<cfset adres = "#adres#&field_id=#attributes.field_id#">
</cfif>
<cfif isDefined('attributes.field_name') and len(attributes.field_name)>
	<cfset adres = "#adres#&field_name=#attributes.field_name#">
</cfif>
<cfif isDefined('attributes.startdate_temp') and len(attributes.startdate_temp)>
	<cfset adres = "#adres#&startdate_temp=#attributes.startdate_temp#">
</cfif>
<cfif isDefined('attributes.finishdate_temp') and len(attributes.finishdate_temp)>
	<cfset adres = "#adres#&finishdate_temp=#attributes.finishdate_temp#">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
<cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='30004.Fiziki Varlıklar'></cfsavecontent>
	<cf_box title="#message#">
		<cfform name="search_asset" action="#request.self#?fuseaction=objects.popup_list_pro_assets#adres#" method="post">
			<cf_box_search more="0">
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="item-keyword">
					<select name="asset_catid" id="asset_catid">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_assetp_cats_reserve">
							<option value="#assetp_catid#" <cfif attributes.asset_catid eq assetp_catid>selected</cfif>>#assetp_cat#</option>
						</cfoutput>
					</select>
				</div>	
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_asset' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><a href="javascript://"><i class="icon-check" title="<cf_get_lang dictionary_id='32932.Kaynak Rezerve Edin'> !"></i></a></th>
					<th><cf_get_lang dictionary_id='29452.Varlık'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
					<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
					<th width="20"><a href="javascript://"><i class="fa fa-history"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_assetps_reserve.recordcount>
					<cfoutput query="get_assetps_reserve" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset attributes.assetp_id = assetp_id>
						<cfinclude template="../query/get_assetp_reserve.cfm">
						<tr>
							<td>
							<cfif get_assetp_reserve.recordcount neq 1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_assetp_reserve&assetp_id=#assetp_id#<cfif isDefined("attributes.project_id")>&project_id=#attributes.project_id#</cfif><cfif isDefined("attributes.work_id")>&work_id=#attributes.work_id#</cfif><cfif isDefined("attributes.prod_order_id")>&prod_order_id=#attributes.prod_order_id#</cfif><cfif isDefined("attributes.class_id")>&class_id=#attributes.class_id#</cfif><cfif isDefined('attributes.startdate_temp') and len(attributes.startdate_temp)>&STARTDATE_TEMP=#attributes.STARTDATE_TEMP#&FINISHDATE_TEMP=#attributes.FINISHDATE_TEMP#</cfif>','small');"><i class="icon-check" title="<cf_get_lang dictionary_id='32932.Kaynak Rezerve Edin'> !"></i></a>
							<cfelse>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_assetp_reserve&assetp_id=#assetp_id#<cfif isDefined("attributes.project_id")>&project_id=#attributes.project_id#</cfif><cfif isDefined("attributes.work_id")>&work_id=#attributes.work_id#</cfif><cfif isDefined("attributes.prod_order_id")>&prod_order_id=#attributes.prod_order_id#</cfif><cfif isDefined("attributes.class_id")>&class_id=#attributes.class_id#</cfif><cfif isDefined('attributes.startdate_temp') and len(attributes.startdate_temp)>&STARTDATE_TEMP=#attributes.STARTDATE_TEMP#&FINISHDATE_TEMP=#attributes.FINISHDATE_TEMP#</cfif>','small');"><i class="icon-remove" title="<cf_get_lang dictionary_id='32931.Kaynak Şu anda Müsait Değil'> !"></i></a>
							</cfif>
							</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_assetp_info&assetp_id=#assetp_id#','project')" >#assetp#</a> </td>
							<td>#assetp_cat#</td>
							
							<td>#zone_name# / #branch_name# / #department_head#</td>
							<td><cfif len(POSITION_CODE)>#get_emp_info(POSITION_CODE,1,0)#</cfif></td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_asset_reserve_history&asset_id=#get_assetps_reserve.assetp_id#','list');"><i class="fa fa-history" title="<cf_get_lang dictionary_id='32455.Rezervasyon Tarihçe'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
			<cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
		</cfif>
		<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
			<cfset adres = "#adres#&project_id=#attributes.project_id#">
		</cfif>
		<cfif isDefined('attributes.work_id') and len(attributes.work_id)>
			<cfset adres = "#adres#&work_id=#attributes.work_id#">
		</cfif>
		<cfif isDefined('attributes.prod_order_id') and len(attributes.prod_order_id)>
			<cfset adres = "#adres#&prod_order_id=#attributes.prod_order_id#">
		</cfif>
		<cfif isDefined('attributes.class_id') and len(attributes.class_id)>
			<cfset adres = "#adres#&class_id=#attributes.class_id#">
		</cfif>
		<cfif isDefined('attributes.event_id') and len(attributes.event_id)>
			<cfset adres = "#adres#&event_id=#attributes.event_id#">
		</cfif>
		<cfif isDefined('attributes.field_id') and len(attributes.field_id)>
			<cfset adres = "#adres#&field_id=#attributes.field_id#">
		</cfif>
		<cfif isDefined('attributes.field_name') and len(attributes.field_name)>
			<cfset adres = "#adres#&field_name=#attributes.field_name#">
		</cfif>
		<cfif isDefined('attributes.startdate_temp') and len(attributes.startdate_temp)>
			<cfset adres = "#adres#&startdate_temp=#attributes.startdate_temp#">
		</cfif>
		<cfif isDefined('attributes.finishdate_temp') and len(attributes.finishdate_temp)>
			<cfset adres = "#adres#&finishdate_temp=#attributes.finishdate_temp#">
		</cfif>
		<cfif isDefined('attributes.asset_catid') and len(attributes.asset_catid)>
			<cfset adres = "#adres#&asset_catid=#attributes.asset_catid#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_list_pro_assets#adres#">
				
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
function asset_care(id,assetp)
{
	<cfif isdefined("attributes.field_id")>
		window.opener.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		window.opener.<cfoutput>#field_name#</cfoutput>.value = assetp;
	</cfif>
	window.close();
}
</script>
