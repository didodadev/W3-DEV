<cfcomponent>
    <cfset serviceUrl = "http://catsvc.debian.aos/tr/etka">
    <cffunction name="GetMainGroupList" type="any">
        <cfargument name="vin" type="string">
        <cfhttp url="#serviceUrl#/#trim(vin)#/main-groups" result="result" method="GET"></cfhttp>
        <cfset response = deserializeJSON(result.filecontent)>
        <cfif response.status == "fail">
            <cfreturn arrayNew(1)>
        <cfelse>
            <cfreturn response.data.main_groups>
        </cfif>
    </cffunction>
    <cffunction name="GetSubGroupList" type="any">
        <cfargument name="vin" type="string">
        <cfargument name="mainGroup" type="string">
        <cfhttp url="#serviceUrl#/#trim(vin)#/#mainGroup#/subgroups" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.subgroups>
    </cffunction>
    <cffunction name="GetUnitList" type="any">
        <cfargument name="vin" type="string">
        <cfargument name="subGroup" type="string">
        <cfhttp url="#serviceUrl#/#trim(vin)#/#subGroup#/units" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.units>
    </cffunction>
    <cffunction name="GetTypeInfo" type="any">
        <cfargument name="vin" type="string">
        <cfhttp url="#serviceUrl#/#trim(vin)#/type-info" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.type_info>
    </cffunction>
    <cffunction name="GetUnitPartList" type="any">
        <cfargument name="vin" type="string">
        <cfargument name="unit_id" type="string">
        <cfhttp url="#serviceUrl#/#trim(vin)#/#unit_id#/unit-parts" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.parts>
    </cffunction>
    <cffunction name="GetUnit" type="any">
        <cfargument name="vin" type="string">
        <cfargument name="unit_id" type="string">
        <cfhttp url="#serviceUrl#/#trim(vin)#/#unit_id#/unit-info" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.unit_info>
    </cffunction>
    <cffunction name="GetSubUnitList" type="any">
        <cfargument name="vin" type="string">
        <cfargument name="unit_id" type="string">
        <cfhttp url="#serviceUrl#/#trim(vin)#/#unit_id#/subunits" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.subunits>
    </cffunction>
</cfcomponent>