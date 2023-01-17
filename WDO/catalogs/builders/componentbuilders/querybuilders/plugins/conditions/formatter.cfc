<cfcomponent>
    <cffunction name="leftConditionFormatter" access="public" returntype="string">
        <cfargument name="field" type="struct">
        <cfargument name="cond" type="string">
        <cfargument name="otherfield" type="struct">
        <cfreturn "%s">
    </cffunction>
    <cffunction name="rightConditionFormatter" access="public" returntype="string">
        <cfargument name="field" type="struct">
        <cfargument name="cond" type="string">
        <cfargument name="otherfield" type="struct">
        <cfreturn "%s">
    </cffunction>
    <cffunction name="conditionFormatter" access="public" returntype="string">
        <cfargument name="field" type="struct">
        <cfargument name="cond" type="string">
        <cfargument name="otherfield" type="struct">
        <cfargument name="side" type="string">
        <cfscript>
            if (side eq "left")
            {
                formatter = leftConditionFormatter;
            }
            else
            {
                formatter = rightConditionFormatter;
            }
        </cfscript>
        <cfreturn formatter(field, cond, otherfield)>
    </cffunction>
</cfcomponent>