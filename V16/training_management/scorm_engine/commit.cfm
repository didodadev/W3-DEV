<cfinclude template="core.cfm">

<cfif SESSION_IS_GUEST eq true>
	<cfoutput>true</cfoutput>
    <cfabort>
</cfif>

<cfloop collection="#form#" item="i">
	<cfset tempVarName = lCase(i)>
	<cfif len(tempVarName) gt 4 and left(tempVarName, 4) is "data">
    	<cfset tempVarName = right(tempVarName, len(tempVarName) - 5)>
        <cfset tempVarName = left(tempVarName, len(tempVarName) - 1)>
		<cfset writeElement(scoID: form.scoID, varName: tempVarName, varValue: form[i])>
    </cfif>
</cfloop>

<cfoutput>true</cfoutput>
