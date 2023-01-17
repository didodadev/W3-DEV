<cfif isDefined("attributes.is_del") and Len(attributes.is_del)>
	<cfquery name="del_guarantycat_time" datasource="#dsn#">
		DELETE FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.time_id#">
	</cfquery>
	<cflocation url="#request.self#?fuseaction=settings.form_guarantycat_time" addtoken="no">
<cfelse>
	<cfif isDefined("attributes.time_id") and Len(attributes.time_id)>
		<cfquery name="upd_guarantycat_time" datasource="#dsn#">
			UPDATE
				SETUP_GUARANTYCAT_TIME
			SET
				GUARANTYCAT_TIME = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guarantycat_time#">,
				GUARANTYCAT_TIME_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(attributes.guarantycat_time_detail eq '',true,false)#" value="#attributes.guarantycat_time_detail#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			WHERE
				GUARANTYCAT_TIME_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.time_id#">
		</cfquery>
		<cfset get_guarantycat_time.identitycol = attributes.time_id>
	<cfelse>
		<cfquery name="add_guarantycat_time" datasource="#dsn#" result="get_guarantycat_time">
			INSERT INTO
				SETUP_GUARANTYCAT_TIME
			(
				GUARANTYCAT_TIME,
				GUARANTYCAT_TIME_DETAIL,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guarantycat_time#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(attributes.guarantycat_time_detail eq '',true,false)#" value="#attributes.guarantycat_time_detail#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
	</cfif>
	<cflocation url="#request.self#?fuseaction=settings.form_guarantycat_time&time_id=#get_guarantycat_time.identitycol#" addtoken="no">
</cfif>
