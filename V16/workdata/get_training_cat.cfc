<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="get_training_cat" datasource="#dsn#">
            SELECT * FROM TRAINING_CAT
        </cfquery>
		<cfreturn get_training_cat>
    </cffunction>
</cfcomponent>
