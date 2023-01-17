<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 19/05/2016			Dev Date	: 19/05/2016		
Description :
	Bu utility iletisim yöntemlerini getirir applicationStart methodunda create edilir.
	
Patameters :
		isDefault : 1/0 default olarak seçilmiş iletişim yöntemlerini getirir değer gönderilmez ise tüm iletişim yöntemleri gelir.

Used : getComMethod.get(isDefault:1);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
		<cfargument name="isDefault" type="any" default="" required="no">
        
		<cfquery name="get" datasource="#dsn#">
            SELECT 
            	COMMETHOD_ID,
                COMMETHOD,
                IS_DEFAULT 
            FROM 
            	SETUP_COMMETHOD 
            <cfif len(arguments.isDefault)>
                WHERE
                    IS_DEFAULT = #arguments.isDefault#
            </cfif>
            ORDER BY 
            	COMMETHOD
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>