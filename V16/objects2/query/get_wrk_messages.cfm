<cfquery name="GET_WRK_MESSAGES" datasource="#DSN#">
	SELECT 
		SENDER_ID,
		SEND_DATE,
		MESSAGE,
		ROOM_ID ,
		SENDER_TYPE,
		IS_CHAT
	FROM 
		WRK_MESSAGE 
	WHERE 
		<cfif isDefined('session.ep.userid')>
            RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND RECEIVER_TYPE = 0
        <cfelseif isDefined('session.pp.userid')>
            RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND RECEIVER_TYPE = 1
        <cfelseif isDefined('session.ww.userid')>
            RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND RECEIVER_TYPE = 2
        <cfelseif isDefined('session.pda.userid')>
            RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#"> AND RECEIVER_TYPE = 0
        <cfelse>
            1 = 0
        </cfif> 
</cfquery>
