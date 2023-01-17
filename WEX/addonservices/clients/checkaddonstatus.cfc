<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="get_trial_status">
        <cfargument name="product_id" default="">
        
        <cfhttp url="https://wex.workcube.com/wex.cfm/addons/checktrial?product_id=#arguments.product_id#" result="resp_checktrial"></cfhttp>
        <!--- servere gidecek ekstra server bilgileri (license key vs ile tanımlama) --->
        <cfset resp_result = deserializeJSON( resp_checktrial.filecontent )>

        <cfobject name="data_addons" type="component" component="WEX.addonservices.data.addons">

        <cfif resp_result.check eq "trial">
            <cfset data_addons.add_trial(arguments.product_id)>
            <cfreturn 1>
        <cfelseif resp_result.check eq "prod">
            <cfset data_addons.add_prod(arguments.product_id)>
            <cfreturn 1>
        <cfelse>
            <cfreturn 0>
        </cfif>
    </cffunction>

</cfcomponent>