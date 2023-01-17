<cfsetting showdebugoutput="no">
<cfquery name="INSSCHOOL" datasource="#dsn#">
	INSERT INTO 
		SETUP_SCHOOL
	(
		SCHOOL_NAME,
        SCHOOL_TYPE,
		DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TITLE#">,
        #attributes.school_type#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TITLE_DETAIL#">,
		#SESSION.EP.USERID#,
		#NOW()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	)
</cfquery>
<cfif isdefined('attributes.is_js_func')>
    <cfquery name="get_max" datasource="#dsn#">
        SELECT MAX(SCHOOL_ID) AS  MAX_ID FROM SETUP_SCHOOL
    </cfquery>
    <cfset _MAX_ID_ = get_max.MAX_ID>
    <script type="text/javascript">
        <cfoutput>
            document.consumer_education.edu4_id.options[0] = new Option('#attributes.TITLE#',#_MAX_ID_#);
            document.consumer_education.edu4_id.value =#_MAX_ID_#;
        </cfoutput>
    </script>
<cfelse>
    <script type="text/javascript">
        <cfif isDefined("attributes.draggable") and attributes.draggable eq 1>
            closeBoxDraggable('add_school_box');
            location.reload();
        <cfelse>
            wrk_opener_reload();
            self.close();
        </cfif>
    </script> 
</cfif>