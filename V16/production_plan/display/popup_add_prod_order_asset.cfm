<cfsetting showdebugoutput="yes">
<cfquery name="get_det_po" datasource="#dsn3#">
	SELECT START_DATE,FINISH_DATE FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfquery name="get_asset_prod_order" datasource="#dsn#">
	SELECT STARTDATE, FINISHDATE, PROD_ORDER_ID, ASSETP_ID, ASSETP_RESID FROM ASSET_P_RESERVE WHERE PROD_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30004.Fiziki Varlıklar'></cfsavecontent>
<cf_box title="#message#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
    	<thead>
            <tr>
                <th><cf_get_lang dictionary_id ='57420.Varlıklar'></th>
                <th><cf_get_lang dictionary_id ='36709.Rezervasyon'></th>
                <th></th>
                <th align="center" width="15"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pro_assets&prod_order_id=#url.id#&starthate_temp=#get_det_po.start_date#&finishdate_temp=#get_det_po.finish_date# </cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='58496.Olay Ekle'>" border="0" align="absmiddle"></i></a></th>
            </tr>
        </thead>
        <tbody>
			<cfif get_asset_prod_order.recordcount>
                <cfoutput query="get_asset_prod_order">
                    <tr class="color-row">
                        <cfquery name="get_assetp_name" datasource="#dsn#">
                            SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_prod_order.assetp_id#">
                        </cfquery>
                        <td><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#assetp_id#" class="tableyazi" target="_blank">#get_assetp_name.assetp#</a></td>
                        <td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)#&nbsp;(#Timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#) - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)#&nbsp;(#Timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#)</td>
                        <td width="1%">
                            <a href="javascript:windowopen('#request.self#?fuseaction=objects.popup_form_upd_assetp_reserve&assetp_resid=#assetp_resid#&assetp_id=#assetp_id#&prod_order_id=#attributes.id#','small');"><img src="/images/update_list.gif" border="0" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36713.Varlık Rezervasyonunu Siliyorsunuz Emin misiniz'></cfsavecontent>
                        <td width="1%"><a href="##" onClick="javascript:if (confirm('#message#')) windowopen('#request.self#?fuseaction=prod.emptypopup_del_asset_prod_order&id=#url.id#&assetp_id=#get_assetp_name.assetp_id #','small'); else return;"><img src="/images/delete_list.gif"  border="0" title="<cf_get_lang dictionary_id='38180.Notu Sil'>"></a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr class="color-row">
                    <td colspan="4" height="20"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                </tr>
			</cfif>
        </tbody>
	</cf_grid_list>
</cf_box>
