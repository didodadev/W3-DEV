<!--- 
    Author: Uğur Hamurpet
    Date: 28/08/2021
--->

<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset my_id = session.ep.userid?:''>

    <cffunction name="get_visitor" returntype="any" access="public">
        <cfargument name="enc_key" type="string" required="true" />

        <cfquery name="get_visitor" datasource="#DSN#">
            SELECT * FROM WRK_MESSAGE_VISITOR WHERE ENC_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.enc_key#">
        </cfquery>
        <cfreturn get_visitor>
    </cffunction>

    <cffunction name="finish_chatflow" returntype="any" access="remote" returnFormat="JSON">
        <cfargument name="enc_key" type="string" required="true" />

        <cfset response = StructNew() />
    
        <cftry>
            <cfquery name="finish_chatflow" datasource="#DSN#">
                UPDATE WRK_MESSAGE_VISITOR SET STATUS = 0 WHERE ENC_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.enc_key#">
            </cfquery>

            <cfset response = { status: true } />

            <cfcatch type = "any">
                <cfset response = { status: false } />
            </cfcatch>
        </cftry>
        <cfreturn replace( serializeJSON( response ), '//', '' )>
    </cffunction>

    <cffunction name="get_visitors_message" returntype="any" access="public">
        <cfquery name="get_visitors_message" datasource="#DSN#">
            SELECT
                WMV.ENC_KEY,
                WMV.VISITOR_KEY,
                WMV.VISITOR_NAME, 
                WMV.VISITOR_SURNAME, 
                WMV.VISITOR_ID, 
                MAX(WM.SEND_DATE) AS SENDDATE, 
                (SELECT TOP 1 WMS.MESSAGE FROM WRK_MESSAGE AS WMS WHERE WMS.ENC_KEY = WMV.ENC_KEY ORDER BY WRK_MESSAGE_ID DESC) AS LASTMESSAGE
            FROM WRK_MESSAGE_VISITOR AS WMV
            INNER JOIN WRK_MESSAGE AS WM ON WMV.ENC_KEY = WM.ENC_KEY
            WHERE WMV.EMPLOYEE_ID = #my_id#
            GROUP BY WMV.ENC_KEY, WMV.VISITOR_KEY, WMV.VISITOR_NAME, WMV.VISITOR_SURNAME, WMV.VISITOR_ID
            ORDER BY SENDDATE DESC
        </cfquery>
        <cfreturn get_visitors_message>
    </cffunction>


</cfcomponent>