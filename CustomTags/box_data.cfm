<cfparam name="attributes.asname">
<cfparam name="attributes.function">
<cfparam name="attributes.columns" default="">
<cfparam name="attributes.conditions" default="">

<cfif thisTag.executionMode eq "start">
    <cfset conditions_struct = structNew()>
    <cfif len(attributes.conditions)>
        <cfset conditions_array = listToArray(attributes.conditions, "&")>
        <cfloop array="#conditions_array#" item="e" index="i">
            <cftry>
                <cfif isdefined("caller."&listLast(e, "="))>
                    <cfset conditions_struct[listFirst(e, "=")] = evaluate("caller."&listLast(e, "="))>
                <cfelseif isdefined(listLast(e, "="))>
                    <cfset conditions_struct[listFirst(e, "=")] = evalueate(listLast(e, "="))>
                <cfelse>
                    <cfset conditions_struct[listFirst(e, "=")] = listLast(e, "=")>
                </cfif>
                <cfcatch>
                    <cfset conditions_struct[listFirst(e, "=")] = listLast(e, "=")>
                </cfcatch>
            </cftry>
        </cfloop>
    </cfif>
    <cfif find(":", attributes.function)>
        <cfset funct_object = listFirst(attributes.function, ":")>
        <cfif find(".", funct_object)>
            <cfset funct_name = listLast(attributes.function, ":")>
            <cfset funct_instance = createObject("component", funct_object)>
            <cfset caller[attributes.asname] = evaluate("funct_instance.#funct_name#(argumentCollection= conditions_struct)")>
        <cfelse>
            <cfset caller[attributes.asname] = evaluate("caller.#funct_name#(argumentCollection= conditions_struct)")>
        </cfif>
    </cfif>
</cfif>