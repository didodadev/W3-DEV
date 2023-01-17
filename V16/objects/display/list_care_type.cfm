<!--- Bu popup gelen asset_id ve bakım tipine göre Bakım Tiplerini listeler. --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfquery name="GET_CARE_TYPE" datasource="#DSN#">
	SELECT
    	DISTINCT <!--- #69486 numaralı iş gereği eklendi --->
		ASSET_CARE_CAT.ASSET_CARE_ID,
		ASSET_CARE_CAT.ASSET_CARE,
		ASSET_P_CAT.ASSETP_CAT,
		ASSET_CARE_CAT.IS_YASAL
	FROM
		ASSET_CARE_CAT,
		ASSET_P,
		ASSET_P_CAT
	WHERE
    	<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)><!--- #69486 numaralı iş gereği eklendi --->
		ASSET_P.ASSETP_ID = #attributes.asset_id# AND
        </cfif>
		<cfif isdefined("attributes.is_yasal")>
			ASSET_CARE_CAT.IS_YASAL = #attributes.is_yasal# AND
		</cfif>
		<!--- ASSET_CARE_CAT.IS_YASAL = #attributes.is_yasal# AND --->
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P_CAT.ASSETP_CATID = ASSET_CARE_CAT.ASSETP_CAT
 		<cfif len(attributes.keyword)> AND ASSET_CARE_CAT.ASSET_CARE LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_care_type.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<script type="text/javascript">
function gonder(id,name)
{
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
<cfset url_str = "">
<cfset url_str = "#url_str#&field_id=#field_id#">
<cfset url_str = "#url_str#&field_name=#field_name#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='33671.Bakım Tipleri'></cfsavecontent>
	<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_asset" method="post" action="#request.self#?fuseaction=objects.popup_list_care_type&#url_str#">
			<cf_box_search>
				<input type="hidden" name="asset_id" id="asset_id" value="<cfif isdefined("attributes.asset_id")><cfoutput>#attributes.asset_id#</cfoutput></cfif>">
				<cfif isdefined("attributes.is_yasal")>
					<input type="hidden" name="is_yasal" id="is_yasal" value="<cfoutput>#attributes.is_yasal#</cfoutput>">
				</cfif>	
				<div class="form-group">		
				<cfsavecontent variable="filter"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>		
					<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#filter#">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1," required="yes">
				</div>
				<div class="form-group">
					<cf_wrk_search_button  button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_asset' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
			<tr>
				<th><cf_get_lang dictionary_id='33170.Varlık Kategorisi'></th>
				<th><cf_get_lang dictionary_id='33171.Bakım Tipi'></th>
			</tr>
			</thead>
			<tbody>
			<cfif get_care_type.recordcount>
				<cfoutput query="get_care_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#assetp_cat#</td>
					<td><a href="javascript://" onClick="gonder('#asset_care_id#','#asset_care#')" class="tableyazi">#asset_care#</a></td>
				</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>
			</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
			<cfset url_str = "#url_str#&asset_id=#attributes.asset_id#">
			</cfif>
			<cfif isdefined("attributes.is_yasal")and len(attributes.is_yasal)>
			<cfset url_str = "#url_str#&is_yasal=#attributes.is_yasal#">
			</cfif>
			<cfif isdefined("attributes.draggable")and len(attributes.draggable)>
			<cfset url_str = "#url_str#&draggable=#attributes.draggable#">
			</cfif>
			<table width="99%" border="0" cellpadding="0" cellspacing="0" height="35" align="center">
			<tr>
				<td><cf_pages page="#attributes.page#"
						maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
							adres="objects.popup_list_care_type&#url_str#">
			</td>
			<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			</tr>
			</table>
		</cfif>
	</cf_box>
</div>
