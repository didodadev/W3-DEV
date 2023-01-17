<cfparam name="attributes.sorttype" default="">

<cfswitch expression = "#attributes.sorttype#">
	<cfcase value="solution">   
		<cfset data = deSerializeJSON(attributes.solutions)>
		<cfoutput>
			<cfloop index="ind" from="1" to="#arrayLen(data)#">
				<cfquery name="updSorter" datasource="#dsn#" result="r">
					UPDATE
						WRK_SOLUTION
					SET 
						RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[ind]['value']#">
					WHERE
						WRK_SOLUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[ind]['solutionId']#">
				</cfquery>
			</cfloop>
		</cfoutput>
	</cfcase>	
	<cfcase value="familie">
		<cfset data = deSerializeJSON(attributes.familie)>
		<cfoutput>
			<cfloop index="ind" from="1" to="#arrayLen(data)#">
				<cfquery name="updSorter" datasource="#dsn#" result="r">
					UPDATE
						WRK_FAMILY
					SET 
						RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[ind]['value']#">
					WHERE
						WRK_FAMILY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[ind]['familieId']#">
				</cfquery>
			</cfloop>
		</cfoutput>
	</cfcase>	
	<cfcase value="module">
		<cfset data = deSerializeJSON(attributes.module)>
		<cfoutput>
			<cfloop index="ind" from="1" to="#arrayLen(data)#">
				<cfquery name="updSorter" datasource="#dsn#" result="r">
					UPDATE
						WRK_MODULE
					SET 
						RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[ind]['value']#">
					WHERE
						MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[ind]['moduleId']#">
				</cfquery>
			</cfloop>
		</cfoutput>
	</cfcase>	
	<cfcase value="object">   
		<cfset data = deSerializeJSON(attributes.object)>
		<cfoutput>
			<cfloop index="ind" from="1" to="#arrayLen(data)#">
				<cfquery name="updSorter" datasource="#dsn#" result="r">
					UPDATE
						WRK_OBJECTS
					SET 
						RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[ind]['value']#">
					WHERE
						WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[ind]['objectId']#">
				</cfquery>
			</cfloop>
		</cfoutput>
	</cfcase>	
	<cfdefaultcase>
    	default
    </cfdefaultcase>	
</cfswitch>
<cfdirectory action="list" directory="#upload_folder#personal_settings" name="personalFiles" filter="*.json">
<cfoutput query="personalFiles">
	<cffile action="delete" file="#upload_folder#personal_settings\#personalFiles.name#">
</cfoutput>