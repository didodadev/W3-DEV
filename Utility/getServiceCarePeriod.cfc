<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Semih Bozal	
Analys Date : 25/05/2016			Dev Date	: 25/05/2016		
Description :
	Bu utility bakım planı periyodunu getirir applicationStart methodunda create edilir.
	
Patameters : Yok.

Used : getServiceCarePeriod.periodQuery();
----------------------------------------------------------------------->
<cfcomponent>
	<cfset lang1 = application.langArrayAll['ITEM_#session.ep.language#'][41776]>
    <cfset lang2 = '15' &' '& application.langArrayAll['ITEM_#session.ep.language#'][41777]>
    <cfset lang3 = application.langArrayAll['ITEM_#session.ep.language#'][41778]>
    <cfset lang4 = '2' &' '& application.langArrayAll['ITEM_#session.ep.language#'][41778]>
    <cfset lang5 = '3' &' '& application.langArrayAll['ITEM_#session.ep.language#'][41778]>
    <cfset lang6 = '4' &' '& application.langArrayAll['ITEM_#session.ep.language#'][41778]>
    <cfset lang7 = '6' &' '&application.langArrayAll['ITEM_#session.ep.language#'][41778]>
    <cfset lang8 = application.langArrayAll['ITEM_#session.ep.language#'][41779]>
    <cfset lang9 = '5' &' '& application.langArrayAll['ITEM_#session.ep.language#'][41779]>
    
    <cffunction name="get" access="public" returntype="query">
       <cfscript> 
		periodQuery = QueryNew("PERIOD_ID,PERIOD_NAME","integer,VarChar");
		for(i=1;i<=9;i++)
		{
			QueryAddRow(periodQuery,1);
			QuerySetCell(periodQuery,"PERIOD_ID",i,i);
			QuerySetCell(periodQuery,"PERIOD_NAME",evaluate('lang#i#'),i);
		}
        </cfscript>
		<cfreturn periodQuery>
	</cffunction>
</cfcomponent>