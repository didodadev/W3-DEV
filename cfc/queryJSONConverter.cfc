<!--- 
    File: queryJSONConverter.cfm
    Author: Botan KAYĞAN <botankaygan@workcube.com>
    Date: 21.08.2019
    Controller: -
    Description: JSON olarak verilen sorgu sonucunu düzenleyerek, data alanındaki index numarasını kolon isimleriyle değiştirir.
--->
<cfcomponent>
    <cffunction name = "returnData" access = "public">
        <cfargument name="queryData" type="string" required="yes">
        <cfset structQueryData = deserializeJson(queryData)>
        <cfset data = ArrayNew(1)> 

        <cfloop index = "i" from = "1" to = "#ArrayLen(structQueryData.DATA)#">
            <cfset row = StructNew()>
            <cfset data[i] = row>
            <cfloop index = "j" from = "1" to = "#ArrayLen(structQueryData.COLUMNS)#">
                <cftry>
                    <cfset data[i]["#structQueryData.COLUMNS[j]#"] = structQueryData.DATA[i][j] >
                <cfcatch type="any">
                    <cfset data[i]["#structQueryData.COLUMNS[j]#"] = '' >
                </cfcatch>
                </cftry>
            </cfloop>
        </cfloop>

        <cfreturn data>
    </cffunction>
</cfcomponent>