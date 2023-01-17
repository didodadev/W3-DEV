<!---
    File: 
    Author: 
    Date: 
    Description:
		
--->
<cfcomponent displayname="güvenlik için" output="false">
    <cffunction name="init" access="public" returntype="boolean">
       
        <cfreturn  this.checkPermission() />
    </cffunction>

    <cffunction name="checkPermission" access="private" returntype="boolean">
        
        <cfreturn true />
    </cffunction>
</cfcomponent>
