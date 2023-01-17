<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfquery name="ADD_OFFTIMES" datasource="#dsn#">
	INSERT INTO 
    	<cfif fusebox.circuit eq 'settings'>
		SETUP_GENERAL_OFFTIMES
		<cfelse>
		SETUP_GENERAL_OFFTIMES_SATURDAY
		</cfif>
	(
        OFFTIME_NAME,
        START_DATE,
        FINISH_DATE,
		IS_HALFOFFTIME,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
    VALUES
    (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.offtime_name#">,
        #attributes.startdate#,
        #attributes.finishdate#,
		<cfif isdefined('attributes.is_halfofftime')>1<cfelse>NULL</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        #session.ep.userid#
    )	
</cfquery>
<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.form_add_offtimes" addtoken="no">
