<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.ZONE_NAME=replacelist(attributes.ZONE_NAME,list,list2)>
<cfif not isDefined("FORM.ZONE_STATUS")>
	<cfset FORM.ZONE_STATUS = 0>
</cfif>
<cfquery name="ZONE" datasource="#dsn#" result="MAXID">
	INSERT
	INTO
		ZONE
		(	
			ZONE_NAME,
			ZONE_DETAIL,
			ZONE_STATUS,
			IS_ORGANIZATION,
			<cfif len(attributes.ADMIN1_POSITION_CODE) and len(attributes.admin1_position)>ADMIN1_POSITION_CODE,</cfif>
			<cfif len(attributes.ADMIN2_POSITION_CODE) and len(attributes.admin2_position)>ADMIN2_POSITION_CODE,</cfif>
			<cfif len(attributes.ZONE_TELCODE)>ZONE_TELCODE,</cfif>
			<cfif len(attributes.ZONE_TEL1)>ZONE_TEL1,</cfif>
			<cfif len(attributes.ZONE_TEL2)>ZONE_TEL2,</cfif>
			<cfif len(attributes.ZONE_TEL3)>ZONE_TEL3,</cfif>
			<cfif len(attributes.ZONE_FAX)>ZONE_FAX,</cfif>
			ZONE_EMAIL, 
			ZONE_ADDRESS, 
			POSTCODE, 
			COUNTY, 
			CITY,
			COUNTRY,
			HIERARCHY,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
	VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ZONE_NAME#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ZONE_DETAIL#">,
			<cfif isDefined("attributes.ZONE_STATUS")>1,<cfelse>0,</cfif>
			<cfif isDefined("attributes.IS_ORGANIZATION")>1,<cfelse>0,</cfif>
			<cfif len(attributes.ADMIN1_POSITION_CODE) and len(attributes.admin1_position)>#attributes.ADMIN1_POSITION_CODE#,</cfif>
			<cfif len(attributes.ADMIN2_POSITION_CODE) and len(attributes.admin2_position)>#attributes.ADMIN2_POSITION_CODE#,</cfif>
			<cfif len(attributes.ZONE_TELCODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ZONE_TELCODE#">,</cfif>
			<cfif len(attributes.ZONE_TEL1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ZONE_TEL1#">,</cfif>
			<cfif len(attributes.ZONE_TEL2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ZONE_TEL2#">,</cfif>
			<cfif len(attributes.ZONE_TEL3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ZONE_TEL3#">,</cfif>
			<cfif len(attributes.ZONE_FAX)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ZONE_FAX#">,</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ZONE_EMAIL#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ZONE_ADDRESS#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.POSTCODE#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.COUNTY#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CITY#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.COUNTRY#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HIERARCHY#">,
			#SESSION.EP.USERID#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			#NOW()#
		)
</cfquery>
<cfquery name="GET_ID" datasource="#DSN#">
  SELECT MAX(ZONE_ID) AS MAX_ID FROM ZONE 
</cfquery>
<cfset attributes.actionId = MAXID.IdentityCol>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_zones&event=upd&id=#MAXID.IdentityCol#</cfoutput>';
</script>
