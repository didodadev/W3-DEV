<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.ZONE_NAME=replacelist(attributes.ZONE_NAME,list,list2)>
<cfif not isDefined("FORM.ZONE_STATUS")>
	<cfset FORM.ZONE_STATUS = 0>
</cfif>
<cfquery name="ZONE" datasource="#dsn#">
	UPDATE
		ZONE
	SET 
		ZONE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ZONE_NAME#">,
		ZONE_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ZONE_DETAIL#">,
		ZONE_STATUS = <cfif isDefined("attributes.ZONE_STATUS")>1,<cfelse>0,</cfif>
		IS_ORGANIZATION = <cfif isDefined("attributes.IS_ORGANIZATION")>1,<cfelse>0,</cfif>
		<cfif len(attributes.admin1_position) and len(attributes.ADMIN1_POSITION_CODE)>ADMIN1_POSITION_CODE = #ADMIN1_POSITION_CODE#,<cfelse>ADMIN1_POSITION_CODE = NULL,</cfif>
		<cfif len(attributes.admin2_position) and len(attributes.ADMIN2_POSITION_CODE)>ADMIN2_POSITION_CODE = #ADMIN2_POSITION_CODE#,<cfelse>ADMIN2_POSITION_CODE = NULL,</cfif>
		<cfif len(attributes.ZONE_TELCODE)>ZONE_TELCODE =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#ZONE_TELCODE#">,<cfelse>ZONE_TELCODE = NULL,</cfif>
		<cfif len(attributes.ZONE_TEL1)>ZONE_TEL1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ZONE_TEL1#">,<cfelse>ZONE_TEL1 = NULL,</cfif>
		<cfif len(attributes.ZONE_TEL2)>ZONE_TEL2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ZONE_TEL2#">,<cfelse>ZONE_TEL2 = NULL,</cfif>
		<cfif len(attributes.ZONE_TEL3)>ZONE_TEL3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ZONE_TEL3#">,<cfelse>ZONE_TEL3 = NULL,</cfif>
		<cfif len(attributes.ZONE_FAX)>ZONE_FAX = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ZONE_FAX#">,<cfelse>ZONE_FAX = NULL,</cfif>
		ZONE_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ZONE_EMAIL#">,
		ZONE_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ZONE_ADDRESS#">, 
		POSTCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#POSTCODE#">,
		COUNTY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#COUNTY#">,
		CITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CITY#">,
		COUNTRY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#COUNTRY#">,
		HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HIERARCHY#">,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	WHERE 
		ZONE_ID = #attributes.id#
</cfquery>
<cf_add_log  log_type="0" action_id="#attributes.id#" action_name="#attributes.ZONE_NAME#">
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_zones&event=upd&id=#attributes.id#</cfoutput>';
</script>