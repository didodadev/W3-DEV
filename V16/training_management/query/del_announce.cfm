<!--- <cfquery name="control" datasource="#dsn#" maxrows="1">
	SELECT 
        EMPLOYEE_ID, 
        CLASS_ID, 
        ANNOUNCE_ID, 
        CONTENT_ID
    FROM 
    	TRAINING_REQUEST_ROWS 
    WHERE 
    	ANNOUNCE_ID = #attributes.announce_id#
</cfquery> --->
<cfset gd = createObject("component","V16.training_management.cfc.announce")/>
<cfset control = gd.THECONTROL(ANNOUNCE_ID:attributes.announce_id)/>
<cfif control.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='523.Bu Duyuruya Talep Yapılmış, Silemezsiniz'> !");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cflock timeout="60">
		<cftransaction>
			<cfset DEL_RELATED_CONT = gd.DELETEANNOUNCE(ANNOUNCE_ID:attributes.announce_id)/>
			<!--- <cfquery name="DEL_RELATED_CONT" datasource="#dsn#">
				DELETE 
				FROM
					TRAINING_CLASS_ANNOUNCEMENTS 
				WHERE 
					ANNOUNCE_ID = #attributes.announce_id#
			</cfquery> --->
			<cf_add_log  log_type="-1" action_id="#attributes.announce_id#" action_name="#attributes.head#">
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		opener.location='<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.list_class_announcements';
		window.close();
	</script>
</cfif>

