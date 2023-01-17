<cfquery name="INS_OFFER_PLUS" datasource="#dsn#">
	INSERT INTO
		EVENTS_RELATED
	(
		ACTION_ID,
		ACTION_SECTION,
		EVENT_ID,
		COMPANY_ID	,
		EVENT_TYPE<!--- 1 İSE ajanda , 2 ise ziyaret planı --->	,
		EVENT_ROW_ID
	)		
	VALUES
	(
		#ATTRIBUTES.ACTION_ID#,
		'#ATTRIBUTES.ACTION_SECTION#',
		#ATTRIBUTES.EVENT_ID#,
		<cfif isdefined("session.ep.company_id")>
		#session.ep.company_id#
		<cfelse>
		#session.pp.our_company_id#
		</cfif>	,
		<cfif isdefined("attributes.type")>#attributes.type#<cfelse>1</cfif>,
		<cfif isdefined("attributes.event_row_id")>#attributes.event_row_id#<cfelse>NULL</cfif>
	)
</cfquery>
<cfif ATTRIBUTES.ACTION_SECTION is 'PROJECT_ID'>
	<cfquery name="UPD_EVENT" datasource="#dsn#">
		UPDATE
			EVENT
		SET
			PROJECT_ID = #ATTRIBUTES.ACTION_ID#
		WHERE
			EVENT_ID = #ATTRIBUTES.EVENT_ID#
	</cfquery>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_get_related_events_' );
	</cfif>
</script>
