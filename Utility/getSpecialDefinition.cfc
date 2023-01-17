<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 19/05/2016			Dev Date	: 19/05/2016		
Description :
	Bu utility özel tanımlar parametrelerini getirir applicationStart methodunda create edilir.
	
Patameters :
		specialDefinitionType : 1 = Tahsilat
								2 = Ödeme
								3 = Servis
								4 = Yazışma
								5 = Etkileşim
								6 = Proje
								7 = İş
								8 = Forum
								9 = Kurumsal Üye
								10 = Bireyel Üye
								11 = Disiplin İşlemleri
								12 = Call Center-Başvuru
								
		 değerlerini alır.

Used : getSpecialDefinition.get(specialDefinitionType:1);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="specialDefinitionType" type="numeric" default="0" required="no">
        
		<cfquery name="get" datasource="#DSN#">
            SELECT 
            	SPECIAL_DEFINITION_ID,
                SPECIAL_DEFINITION 
            FROM 
            	SETUP_SPECIAL_DEFINITION 
            WHERE 
            	SPECIAL_DEFINITION_TYPE = #arguments.specialDefinitionType# 
            ORDER BY 
            	SPECIAL_DEFINITION
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>