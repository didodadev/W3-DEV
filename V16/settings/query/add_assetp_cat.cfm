<cfquery name="ADD_ASSETP_CAT" datasource="#DSN#">
	INSERT INTO
		ASSET_P_CAT
	(
		ASSETP_CAT,
		ASSETP_RESERVE,
		IT_ASSET,
		MOTORIZED_VEHICLE,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	 ) 
	 VALUES 
	 (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.assetp_cat#">,
		<cfif isdefined("attributes.assetp_reserve")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.it_asset")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.motorized_vehicle")>1<cfelse>0</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		#now()#,
		#session.ep.userid#
	 )
</cfquery>
<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.add_assetp_cat" addtoken="no">
