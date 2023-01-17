		<cfquery name="ADD_BUG" datasource="#dsn_dev#">
		INSERT INTO BUG_REPORT 
							(
							<cfif isdefined("attributes.company") and len(attributes.company)>
							WORKCUBE_ID,
							WORKCUBE_USERNAME,
							WORKCUBE_SURNAME,
							WORKCUBE_COMPANY,
							</cfif>
							BUG_CIRCUIT,
							BUG_FUSEACTION,
							BUG_HEAD,
							BUG_BODY,
							<cfif isdefined("session.ww.userkey") and session.ww.userkey contains 'C'>
							RECORD_CON,
							<cfELSEif isdefined("session.ww.userkey") and session.ww.userkey contains 'P'>
							RECORD_PAR,
							</cfif>
							RECORD_DATE,
							RECORD_IP
							)
					VALUES
						(
							<cfif isdefined("attributes.company") and len(attributes.company)>
							'#attributes.WORKCUBE_ID#',
							'#attributes.NAME#',
							'#attributes.SURNAME#',
							'#attributes.COMPANY#',
							</cfif>
							'#attributes.BUG_CIRCUIT#',					
							'#attributes.BUG_FUSEACTION#',				
							'#attributes.BUG_HEAD#',		
							'#attributes.BUG_BODY#',	
							<cfif isdefined("session.ww.userkey")>
							#SESSION.WW.USERID#,
							</cfif>
							#NOW()#,
							'#CGI.REMOTE_ADDR#'
							)
		</cfquery>
		
<cfquery datasource="#dsn_dev#" name="get_bug">
SELECT 
	BUG_HEAD
FROM
	BUG_REPORT
WHERE
	BUG_STATUS_ID IS NOT NULL
	AND
	(
	BUG_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.bug_head#%">
	<cfif len(attributes.BUG_FUSEACTION)>
	OR
	BUG_FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.BUG_FUSEACTION#%">
	</cfif>
	)
</cfquery>

<cfif get_bug.recordcount gt 0>
<cflocation url="#request.self#?fuseaction=objects2.bug&keyword=#attributes.bug_head#&ok=1&send=1" addtoken="No">
<cfelse>
<cflocation url="#request.self#?fuseaction=objects2.add_bug&ok=1" addtoken="No">	
</cfif>
