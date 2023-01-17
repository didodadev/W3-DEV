<cfparam name="attributes.sorttype" default="">
<cfswitch expression = "#attributes.sorttype#">
    
	<cfcase value="task">   
		<cfset data = deSerializeJSON(attributes.object)>
		<cfoutput>
			<cfloop index="ind" from="1" to="#arrayLen(data)#">
				<cfquery name="updSorter" datasource="#dsn#" result="r">
					UPDATE
						WRK_IMPLEMENTATION_STEP
					SET 
						RANK_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[ind]['value']#">
					WHERE
						WRK_IMPLEMENTATION_STEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#data[ind]['objectId']#">
				</cfquery>
			</cfloop>
		</cfoutput>
	</cfcase>	
	<cfdefaultcase>
    	default
    </cfdefaultcase>	
</cfswitch>
