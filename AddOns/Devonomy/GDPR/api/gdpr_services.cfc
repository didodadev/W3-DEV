<cfcomponent rest="true" restpath="/gdprService">
 
    <cffunction name="setPermission" access="remote" returntype="string" httpmethod="POST" restpath="setPermission">
        <cfargument name="type" type="string" required="yes" restargsource="form"/>
        <cfargument name="id" type="numeric" required="yes" restargsource="form"/>
        <!--- izin onayını ilgili tabloya yaz --->
        <cfreturn "yazıldı">
    </cffunction>
    <cffunction name="getPermission" access="remote" httpmethod="GET" returntype="string" restpath="getPermission/{type}-{id}">
        <cfargument name="type" type="string" required="yes" restargsource="Path"/>
        <cfargument name="id" type="string" required="yes" restargsource="Path"/>
        <!--- onay durumuna bak ve datayı dön --->
        <cfreturn "getPermission verisi">
        
    </cffunction>
</cfcomponent>
