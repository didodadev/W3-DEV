<cfcomponent>
    <cffunction name="UPDATE_PAPER">
        <cfargument name="paper_type" required="yes">
        <cfargument name="dsn3" default="">

        <cftransaction>
            <cf_papers paper_type="#arguments.paper_type#">
            <!--- Belge numarasi update ediliyor. --->
            <cfquery name="UPD_GEN_PAP" datasource="#dsn3#">
                UPDATE 
                    GENERAL_PAPERS
                SET
                    SUBSCRIPTION_NUMBER = #paper_number#
                WHERE
                    SUBSCRIPTION_NUMBER IS NOT NULL
            </cfquery>
        </cftransaction>
        <cfset paper = structNew()>
        <cfset paper.paper_code = paper_code>
		<cfset paper.paper_number = paper_number>
		<cfset paper.paper_full = paper_full>
        <cfreturn paper>
    </cffunction>

    <cffunction name="GET_PAPER_NUMBER_CODE">
        <cfargument name="dsn3" default="">

        <cfquery name="Get_Paper_Number_Code" datasource="#dsn3#">
            SELECT SUBSCRIPTION_NUMBER FROM GENERAL_PAPERS WHERE SUBSCRIPTION_NUMBER IS NOT NULL
        </cfquery>
        <cfreturn Get_Paper_Number_Code>
    </cffunction>
</cfcomponent>