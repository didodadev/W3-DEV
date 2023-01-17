<cfquery name="INSEVENTCAT" datasource="#DSN#">
 	INSERT INTO 
    	EVENT_CAT
    (
        EVENTCAT,
        COLOUR,
        IS_VIP,
        IS_RD_SSK,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
  	) 
    VALUES 
    (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.eventcat#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.colour#">,
        <cfif isdefined("attributes.is_vip")>1<cfelse>0</cfif>,
        <cfif isDefined("attributes.is_rd_ssk") and len(attributes.is_rd_ssk)>1<cfelse>0</cfif>,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_event_cat" addtoken="no">
