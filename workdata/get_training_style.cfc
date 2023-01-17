<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="get_training_style" datasource="#dsn#">
                SELECT * FROM SETUP_TRAINING_STYLE
            </cfquery>
          <cfreturn get_training_style>
    </cffunction>
</cfcomponent>
