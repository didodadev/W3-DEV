<!---iş istasyonu detay İlişkili Fiziki varlıklar --->
<cf_get_lang_set module_name="prod">
<cfsetting showdebugoutput="no">
<cf_ajax_list>
	<thead>
        <tr>
            <th width="15"><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='36342.Varlık Adı'></th>
            <th width="90"><cf_get_lang dictionary_id='36646.Varlık Tipi'></th>
            <cfif fusebox.circuit neq 'assetcare'>
            <th>&nbsp;
            </th>
            </cfif>      
        </tr>
    </thead>
    <tbody>
	<cfquery name="get_relation_physical_asset" datasource="#dsn#">
		SELECT 
			ASSET_P.ASSETP_ID, 
			ASSET_P.ASSETP, 
			ASSET_P.SERIAL_NO, 
			ASSET_P.ASSETP_STATUS, 
			ASSET_P.STATUS,ASSET_P_CAT.ASSETP_CAT ,
			RELATION_PHYSICAL_ASSET_STATION.STATION_ID	
		FROM 
			ASSET_P, 
			ASSET_P_CAT, 
			RELATION_PHYSICAL_ASSET_STATION 
		WHERE 
			ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND 
			ASSET_P.ASSETP_ID = RELATION_PHYSICAL_ASSET_STATION.PHYSICAL_ASSET_ID AND 
			RELATION_PHYSICAL_ASSET_STATION.STATION_ID = #attributes.station_id#
	</cfquery>
	<cfoutput query="get_relation_physical_asset">
		<tr id="asset_#ASSETP_ID#">
			<td><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#ASSETP_ID#" class="tableyazi" target="_blank">#currentrow#</a></td>
			<td><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#ASSETP_ID#" class="tableyazi" target="_blank">#assetp#</a></td>
			<td>#assetp_cat#</td>
			<cfif fusebox.circuit neq 'assetcare'>
			<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='60534.İlişkili Fiziki varlık silinecektir.'> <cf_get_lang dictionary_id='48488.Emin misiniz?'></cfsavecontent>
			<a href="javascript://" onClick="javascript:if(confirm('<cfoutput>#message#</cfoutput>')) {AjaxPageLoad('#request.self#?fuseaction=prod.emptypopup_del_physical_relation&asset_id=#get_relation_physical_asset.assetp_id#&station_id=#get_relation_physical_asset.station_id#&is_ajax_del','asset_#ASSETP_ID#',0,'Siliniyor');gizle(asset_#ASSETP_ID#);} else return false;"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id='57463.sil'>"></a>
			</td>
			</cfif>
		</tr>
	</cfoutput>
    </tbody>
</cf_ajax_list>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
