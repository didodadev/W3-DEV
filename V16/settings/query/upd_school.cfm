<cfquery name="UPD_SCHOOL" datasource="#dsn#">
	UPDATE 
		SETUP_SCHOOL 
	SET 
		SCHOOL_NAME= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TITLE#">,	
        SCHOOL_TYPE = #attributes.school_type#,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.title_detail#">,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	WHERE 
		SCHOOL_ID=#SCHOOL_ID#
</cfquery>
<script type="text/javascript">
	<cfif isDefined("attributes.draggable") and attributes.draggable eq 1>
        closeBoxDraggable('upd_school_box');
        location.reload();
    <cfelse>
        wrk_opener_reload();
        self.close();
    </cfif>
</script>
