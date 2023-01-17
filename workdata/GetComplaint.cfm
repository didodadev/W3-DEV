<!--- 
	amac            : gelen complaint parametresine göre complaint_id,complaint bilgisini getirmek
	parametre adi   : complaint
	Yazan           : Melek KOCABEY
	Tarih           : 20191125
 --->
<cffunction name="GetComplaint" access="public" returnType="query" output="no">
	<cfargument name="complaint" required="yes" type="string">
	<cfargument name="extraparam" default="">
	<cfargument name="assurance_id" default="">
		<cfquery name="GetComplaint" datasource="#DSN#">
			SELECT
                COMPLAINT,
                COMPLAINT_ID
			FROM
                SETUP_COMPLAINTS SC LEFT JOIN SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS SHATT ON SC.COMPLAINT_ID = SHATT.SETUP_COMPLAINT_ID
			WHERE
            	1=1 AND
				COMPLAINT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.complaint#%">
				<cfif len(arguments.assurance_id)>AND SHATT.ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#"></cfif>
			ORDER BY
                COMPLAINT
		</cfquery>
	<cfreturn GetComplaint>
</cffunction>
