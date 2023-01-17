<cfcomponent>
	<cffunction name="init" returntype="UserData">
    	<cfargument name="dsn" required="yes" />
        <cfset variables.dsn = dsn />
        <cfreturn this />
    </cffunction>
    
    <cffunction name="GetThumbnailUrl" access="public" returntype="string">
    	<cfargument name="UserType" type="string" required="yes" />
        <cfargument name="UserId" type="numeric" required="yes" />
    	<cfargument name="Photo" type="string" required="yes" />
        <cfset var thumbUrl = "" />
    	
        <cfreturn thumbUrl />
    </cffunction>
    
	<cffunction name="GetUserData" access="public" returntype="struct">
		<cfargument name="UserType" type="string" required="yes" />
        <cfargument name="UserId" type="numeric" required="yes" />
		<cfset var UserData = StructNew() />
        <cfset var GET_USER = 0 />
       	<cfif arguments.UserType eq "consumer">
            <cfquery name="GET_USER" datasource="#dsn#">
                SELECT * FROM CONSUMER WHERE CONSUMER_ID = #arguments.userid#
            </cfquery>
            <cfset UserData.UserId = GET_USER.CONSUMER_ID />
            <cfset UserData.Name = GET_USER.CONSUMER_NAME & " " & GET_USER.CONSUMER_SURNAME />
            <cfset UserData.RecordDate = GET_USER.RECORD_DATE />
            <cfset UserData.Photo = GET_USER.PICTURE />
            <cfset UserData.PhotoServerId = GET_USER.PICTURE_SERVER_ID />
            <cfset UserData.UserType = arguments.UserType />
            
         <cfelseif arguments.UserType eq "employee">
         	<cfquery name="GET_USER" datasource="#dsn#">
                SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = #arguments.userid#
            </cfquery>            
            <cfset UserData.UserId = GET_USER.EMPLOYEE_ID />
            <cfset UserData.Name = GET_USER.EMPLOYEE_NAME & " " & GET_USER.EMPLOYEE_SURNAME />
            <cfset UserData.RecordDate = GET_USER.RECORD_DATE />
            <cfset UserData.Photo = GET_USER.PHOTO />
            <cfset UserData.PhotoServerId = GET_USER.PHOTO_SERVER_ID />
            <cfset UserData.UserType = arguments.UserType />
            
         <cfelseif arguments.UserType eq "partner">
         	<cfquery name="GET_USER" datasource="#dsn#">
                SELECT * FROM COMPANY_PARTNER WHERE PARTNER_ID = #arguments.userid#
            </cfquery>            
            <cfset UserData.UserId = GET_USER.PARTNER_ID />
            <cfset UserData.Name = GET_USER.COMPANY_PARTNER_NAME & " " & GET_USER.COMPANY_PARTNER_SURNAME />
            <cfset UserData.RecordDate = GET_USER.RECORD_DATE />
            <cfset UserData.Photo = GET_USER.PHOTO />
            <cfset UserData.PhotoServerId = GET_USER.PHOTO_SERVER_ID />
            <cfset UserData.UserType = arguments.UserType />
         </cfif>
		<cfreturn UserData />
	</cffunction>
</cfcomponent>
