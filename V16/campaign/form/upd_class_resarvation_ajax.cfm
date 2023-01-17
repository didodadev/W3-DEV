<cfsetting showdebugoutput="no">
<cfquery name="CLASS_ASSETP" datasource="#dsn#">
	SELECT 
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP,
		ASSET_P_RESERVE.ASSETP_RESID,
		ASSET_P_RESERVE.STARTDATE,
		ASSET_P_RESERVE.FINISHDATE
	FROM 
		ASSET_P,
		ASSET_P_RESERVE
	WHERE
		ASSET_P_RESERVE.ORGANIZATION_ID = #attributes.ORGANIZATION_ID# AND
		ASSET_P_RESERVE.ASSETP_ID = ASSET_P.ASSETP_ID
</cfquery>
<cf_ajax_list>
<cfif CLASS_ASSETP.recordcount>
	<cfoutput query="class_assetp">
		<tr>
			<td>#assetp#</td>
			<td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# #Timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)# - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# #Timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#</td>
			<td class="text-center" width="30"><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_form_upd_assetp_reserve&ASSETP_RESID=#ASSETP_RESID#&ASSETP_ID=#ASSETP_ID#');"><i class="fa fa-pencil"></i></a></td>
			<td class="text-center"><a href="#request.self#?fuseaction=agenda.del_event_assetp&ASSETP_RESID=#ASSETP_RESID#"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='47593.Rezervasyonu İptal Et'>"></i></a></td>
		</tr>
	</cfoutput>
<cfelse>
		<tr>
			<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>							
		</cfif>
</cf_ajax_list>
