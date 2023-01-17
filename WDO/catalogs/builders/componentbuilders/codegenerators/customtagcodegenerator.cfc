<cfcomponent extends="WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator">
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="data" type="any">
        <cfargument name="prefix" type="string" default="">
        <cfscript>
            code = "<c" & 'fsavecontent variable="' & prefix & data.name & '">' & crlf();
            code = code & "<c" & 'foutput>' & crlf();
            code = code & "<c" & 'f_' & data.tag & " " & data.formula & ">" & crlf();
            code = code & "</c" & 'foutput>' & crlf();
            code = code & "</c" & 'fsavecontent>';
        </cfscript>
        <cfreturn code>
    </cffunction>
</cfcomponent>