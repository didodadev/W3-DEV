<!--- bu sayfa myhome include icindede var orada da update ediniz... --->
<cfif not isdefined("attributes.TO_DAY")>
	<cfset attributes.TO_DAY=date_add('h',session.ep.time_zone,now())>
<cfelseif isdefined("attributes.fromHome")>
	<cfset attributes.TO_DAY = date_add('d',-1,now())>
	<cfset attributes.TO_DAY = date_add('h',-session.ep.time_zone-timeformat(now(),'HH'),attributes.TO_DAY)>
</cfif>

<cfquery name="GET_POSITION_CODE" datasource="#dsn#">
	SELECT 
		POSITION_CODE,
		PARENT_ID,
		RESPONSE_ID
	FROM 
		PAGE_WARNINGS 
	WHERE
		POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
		IS_PARENT = 0	
	GROUP BY
	 	PARENT_ID,POSITION_CODE,RESPONSE_ID
</cfquery>

<cfset parent_ids = ''>
<cfloop query="GET_POSITION_CODE">
	<cfquery name="GET_MAX_RESPONSE_ID" datasource="#dsn#">
		SELECT 
			MAX(RESPONSE_ID) AS max_response_id
		FROM 
			PAGE_WARNINGS 
		WHERE
			PARENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#parent_id#">
	</cfquery>
	<cfif RESPONSE_ID eq GET_MAX_RESPONSE_ID.max_response_id>
		<cfset parent_ids = parent_ids & PARENT_ID & ','>
	</cfif>
</cfloop>
<cfif Len(parent_ids)>
	<cfset parent_ids = Left(parent_ids,Len(parent_ids) - 1)>
</cfif>

<cfquery name="GET_POSITION_CODE" datasource="#dsn#">
	SELECT 
		POSITION_CODE,
		PARENT_ID
	FROM 
		PAGE_WARNINGS 
	WHERE
	<cfif len(parent_ids)>
		W_ID IN (#parent_ids#)
	<cfelse>
		W_ID = -1	
	</cfif>
		AND IS_ACTIVE = 1
		AND LAST_RESPONSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#">
		AND LAST_RESPONSE_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.to_day)#">
	GROUP BY
	 	PARENT_ID,POSITION_CODE
</cfquery>

<cfquery name="GET_DAILY_PAGE_WARNINGS" datasource="#dsn#">
	SELECT 
		W_ID,
		SMS_WARNING_DATE,
		EMAIL_WARNING_DATE,
		LAST_RESPONSE_DATE,
		WARNING_DESCRIPTION,
		WARNING_HEAD 
	FROM 
		PAGE_WARNINGS AS WARNINGS
	WHERE
		POSITION_CODE = #SESSION.EP.POSITION_CODE# AND	
		RESPONSE_ID = (SELECT MAX(RESPONSE_ID) FROM PAGE_WARNINGS WHERE PARENT_ID = WARNINGS.PARENT_ID )	
		AND IS_PARENT = 1
		AND LAST_RESPONSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#">
		AND LAST_RESPONSE_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.to_day)#">
		AND IS_ACTIVE = 1
		<cfif GET_POSITION_CODE.RecordCount>
			OR W_ID IN (#ValueList(GET_POSITION_CODE.PARENT_ID,',')#)
		</cfif>
	ORDER BY 
		W_ID
</cfquery>
