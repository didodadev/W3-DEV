<cfinclude template="core.cfm">

<cfif SESSION_IS_GUEST eq true>
	<cfoutput>true</cfoutput>
    <cfabort>
</cfif>

<!-- Get version -->
<cfset scoVer = readElement(scoID: form.scoID, varName: PARAM_NAME_VERSION)>

<!-- Get total time -->
<cfset totalTime = readElement(scoID: form.scoID, varName: getVarName(tag: "totalTime", version: scoVer))>
<cfif len(totalTime) eq 0><cfset totalTime = "00:00:00"></cfif>

<!-- Convert total time to seconds -->
<cfset totalSeconds = listGetAt(totalTime, 1, ":") * 3600 + listGetAt(totalTime, 2, ":") * 60 + listGetAt(totalTime, 3, ":")>

<cfset sessionTime = readElement(scoID: form.scoID, varName: getVarName(tag: "sessionTime", version: scoVer))>
<cfif len(sessionTime) eq 0><cfset sessionTime = "00:00:00"></cfif>
<cfset sessionTime = transformTime(sessionTime)>

<!-- Convert session time to seconds -->
<cfset totalSeconds += listGetAt(sessionTime, 1, ":") * 3600 + listGetAt(sessionTime, 2, ":") * 60 + listGetAt(sessionTime, 3, ":")>

<!-- Set total time -->
<cfset totalTimeH = int(totalSeconds / 3600)>
<cfset totalTimeM = int((totalSeconds - (totalTimeH * 3600)) / 60)>
<cfset totalTimeS = int(totalSeconds - (totalTimeH * 3600) - (totalTimeM * 60))>
<cfif len(totalTimeH) lt 2><cfset totalTimeH = "0#totalTimeH#"></cfif>
<cfif len(totalTimeM) lt 2><cfset totalTimeM = "0#totalTimeM#"></cfif>
<cfif len(totalTimeS) lt 2><cfset totalTimeS = "0#totalTimeS#"></cfif>
<cfset totalTime = "#totalTimeH#:#totalTimeM#:#totalTimeS#">

<!-- Write total time -->
<cfset writeElement(scoID: form.scoID, varName: getVarName(tag: "totalTime", version: scoVer), varValue: totalTime)>

<!-- Update comment count -->
<cfif scoVer eq "1.3">
	<cfset varNameComments = getVarName(tag: "comments", version: scoVer)>
    <cfset varNameCommentCount = getVarName(tag: "commentCount", version: scoVer)>
    <cfquery name="get_comment_count" datasource="#APPLICATION_DB#">
        SELECT * FROM #TABLE_SCO_DATA# WHERE VAR_NAME LIKE '#varNameComments#%%comment%' AND SCO_ID = <cfqueryparam value="#form.scoID#" cfsqltype="cf_sql_bigint"> AND USER_TYPE = <cfqueryparam value="#Evaluate(SESSION_USER_TYPE)#" cfsqltype="cf_sql_integer"> AND USER_ID = <cfqueryparam value="#Evaluate(SESSION_USER_ID)#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset writeElement(scoID: form.scoID, varName: varNameCommentCount, varValue: get_comment_count.recordCount)>
</cfif>

<cfoutput>true</cfoutput>
