<cfparam name="url.fromagenda" default="0">
<cflock timeout="20">
	<cftransaction>
		<!--- Tekrar eden olaylari silmek istediginde. --->
		<cfif isdefined('attributes.del_repeat')>
			<cfquery name="get_event_repeat" datasource="#dsn#">
				SELECT EVENT_ID FROM EVENT WHERE LINK_ID IN (#attributes.link_id#) AND EVENT_ID <> #attributes.event_id#
			</cfquery>
			<cfset attributes.EVENT_ID = ValueList(get_event_repeat.EVENT_ID,',')>
		</cfif>
		<!--- olay rezervasyonları sil --->
		<cfquery name="get_event_head" datasource="#dsn#">
			SELECT EVENT_HEAD,EVENT_STAGE FROM EVENT WHERE EVENT_ID IN (#attributes.event_id#)
		</cfquery>
		<cfquery name="DEL_EVENT_RESERVATIONS" datasource="#dsn#">
			DELETE FROM
				ASSET_P_RESERVE
			WHERE
				EVENT_ID IN (#attributes.EVENT_ID#)
		</cfquery>	
		<cfquery name="DEL_EVENT_RESULT" datasource="#dsn#">
			DELETE FROM
				EVENT_RESULT
			WHERE
				EVENT_ID IN (#attributes.EVENT_ID#)
		</cfquery>
		<!--- olay sil --->
		<cfquery name="DEL_EVENT" datasource="#dsn#">
			DELETE FROM
				EVENT
			WHERE
				EVENT_ID IN (#attributes.EVENT_ID#)
		</cfquery>	
		<cfquery name="DEL_EVENT_RELATIONS" datasource="#dsn#">
			DELETE FROM
				EVENTS_RELATED
			WHERE
				EVENT_ID IN (#attributes.EVENT_ID#)
		</cfquery>
		<cfif listlen(attributes.event_id) gt 1>
			<cf_add_log  log_type="-1" action_id="#listfirst(attributes.event_id)#" action_name="Ajanda - Olay Silindi. #get_event_head.event_head#" process_stage="#get_event_head.event_stage#">
		<cfelse>
			<cf_add_log  log_type="-1" action_id="#attributes.event_id#" action_name="Ajanda - Olay Silindi. #get_event_head.event_head#" process_stage="#get_event_head.event_stage#">
		</cfif>
	</cftransaction>
</cflock>
<cfif isdefined("attributes.project_id") or isdefined("attributes.opp_id") or isdefined("attributes.offer_id") or isdefined("attributes.action_id")>
	<script language="JavaScript">
	 wrk_opener_reload();
	 window.close();
	</script>
<cfelse>
	<cfif isdefined('attributes.del_repeat') or isdefined('attributes.is_popup')>
		<script language="JavaScript">
			 wrk_opener_reload();
			 window.close();
		</script>
	<cfelse>
		<cfif url.fromagenda eq "0">
			<script>	
				window.location='<cfoutput>#request.self#?fuseaction=agenda.view_daily</cfoutput>'
			</script>
		<cfelse>
			<script language="javascript">
				//BURASI "OLAY TAKVİMİ" İLE İLGİLİ
				try{ // Eğer ilk satır hata verirse ki olay takviminden gelirse hata vermez. o zaman çalışmaz
					wrk_opener_reload();
					window.close();
				}catch(err){}			
			</script>		
		</cfif>
	</cfif>
</cfif>
<script language="JavaScript">
	wrk_opener_reload();
	window.close();
</script>