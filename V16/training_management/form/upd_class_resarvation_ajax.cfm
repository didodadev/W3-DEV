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
		ASSET_P_RESERVE.CLASS_ID = #attributes.CLASS_ID# AND
		ASSET_P_RESERVE.ASSETP_ID = ASSET_P.ASSETP_ID
</cfquery>
<!--- <cfinclude template="../query/get_class_assetp.cfm"> --->
<cf_ajax_list>
<cfif CLASS_ASSETP.recordcount>
	<cfoutput query="class_assetp">
	<tr>
				<td>#assetp#</td>
				<td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# #Timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)# - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# #Timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#</td>
				<td align="center" width="30"><a href="javascript:windowopen('#request.self#?fuseaction=objects.popup_form_upd_assetp_reserve&ASSETP_RESID=#ASSETP_RESID#&ASSETP_ID=#ASSETP_ID#','small');">
					<i class="fa fa-pencil" border="0" ></i></a><a href="#request.self#?fuseaction=agenda.del_event_assetp&ASSETP_RESID=#ASSETP_RESID#"><i class="fa fa-minus" title="<cf_get_lang no='23.Rezervi İptal Et'>" border="0" ></i></a></td>
				<!---<td align="center"></td>--->	
			</tr>
	</cfoutput>
<cfelse>
		<tr>
			<td colspan="3">&nbsp;<cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>							
		</cfif>
</cf_ajax_list>
