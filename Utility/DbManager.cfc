<cfcomponent>
    <cffunction  name="CreateEmptyColumnTask" access="remote" returntype="any">
        <cfset sDate=posdateresult=DateAdd("d",1,Now())>
        <cfset sTime=CreateTime(3,0,0)>
        <cfset funcUrl="http://" & "#cgi.server_name#" & "/Utility/DatabaseInfo.cfc?method=EmptyColumnInsert">
        <cfschedule
        action="update"
        task="EmptyColumnDataTask"
        operation="HTTPRequest"
        startDate="#sDate#"
        startTime="#sTime#"
        url=#funcUrl#
        interval="once" />
        <cfreturn '{ "SUCCESS" : true }'>
    </cffunction>
</cfcomponent>