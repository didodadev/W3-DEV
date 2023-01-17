<cfcomponent>
    <cfset serviceUrl = "http://catsvc.debian.aos/tr/etka">
    <cffunction name="GetMainGroupList" type="any">
        <cfargument name="make" type="string">
        <cfargument name="market" type="string">
        <cfargument name="model" type="string">
        <cfargument name="epis_type" type="string">
        <cfhttp url="#serviceUrl#/#make#/#market#/#model#/#epis_type#/main-groups" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.main_groups>
    </cffunction>
    <cffunction name="GetSubGroupList" type="any">
        <cfargument name="make" type="string">
        <cfargument name="market" type="string">
        <cfargument name="model" type="string">
        <cfargument name="epis_type" type="string">
        <cfargument name="mainGroup" type="string">
        <cfhttp url="#serviceUrl#/#make#/#market#/#model#/#epis_type#/#mainGroup#/subgroups" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.main_groups>
    </cffunction>
    <cffunction name="GetUnitList" type="any">
        <cfargument name="make" type="string">
        <cfargument name="market" type="string">
        <cfargument name="model" type="string">
        <cfargument name="epis_type" type="string">
        <cfargument name="subGroup" type="string">
        <cfhttp url="#serviceUrl#/#make#/#market#/#model#/#epis_type#/#subGroup#/units" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.main_groups>
    </cffunction>
    <cffunction name="GetTypeInfo" type="any">
        <cfargument name="make" type="string">
        <cfargument name="market" type="string">
        <cfargument name="model" type="string">
        <cfargument name="epis_type" type="string">
        <cfhttp url="#serviceUrl#/#make#/#market#/#model#/#epis_type#/type-info" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.type_info>
    </cffunction>
    <cffunction name="GetUnitPartList" type="any">
        <cfargument name="make" type="string">
        <cfargument name="market" type="string">
        <cfargument name="model" type="string">
        <cfargument name="epis_type" type="string">
        <cfargument name="unit_id" type="string">
        <cfhttp url="#serviceUrl#/#make#/#market#/#model#/#epis_type#/#unit_id#/unit-parts" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.parts>
    </cffunction>
    <cffunction name="GetUnit" type="any">
        <cfargument name="make" type="string">
        <cfargument name="market" type="string">
        <cfargument name="model" type="string">
        <cfargument name="epis_type" type="string">
        <cfargument name="unit_id" type="string">
        <cfhttp url="#serviceUrl#/#make#/#market#/#model#/#epis_type#/#unit_id#/unit-info" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.unit_info>
    </cffunction>
    <cffunction name="GetSubUnitList" type="any">
        <cfargument name="make" type="string">
        <cfargument name="market" type="string">
        <cfargument name="model" type="string">
        <cfargument name="epis_type" type="string">
        <cfargument name="unit_id" type="string">
        <cfhttp url="#serviceUrl#/#make#/#market#/#model#/#epis_type#/#unit_id#/subunits" result="result" method="GET"></cfhttp>
        <cfreturn deserializeJSON(result.Filecontent).data.subunits>
    </cffunction>
</cfcomponent>