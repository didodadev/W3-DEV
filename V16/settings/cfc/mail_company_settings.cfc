<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="InsertTemplate" access="public" returnType="any">
        <cfargument name="template_name" type="string" default="">
        <cfargument name="template_subject" type="string" default="">
        <cfargument name="template_content" type="string" default="">
        <cfquery name="ADD_MAIL_TEMPLATES" datasource="#dsn#" result="result">
            INSERT INTO
                WRK_MAIL_TAMPLATES
                (
                    TEMPLATE_NAME,
                    TEMPLATE_SUBJECT,
                    TEMPLATE_CONTENT,
                    RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_subject#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_content#">,
                    #session.ep.userid#,
					'#cgi.remote_addr#',
					#now()#
                )
        </cfquery>
        <cfset response = result>
		<cfreturn response>
    </cffunction>

        <cffunction name="InsertMailRecipientList" access="public" returnType="any">
            <cfargument name="list_name" type="string" default="">
            <cfargument name="list_file" type="string" default="">
            <cfquery name="ADD_MAIL_RECIPIENT_LIST" datasource="#dsn#" result="result">
                INSERT INTO
                    WRK_MAIL_RECIPIENT_LIST
                    (
                        LIST_NAME,
                        LIST_FILE,
                        RECORD_EMP,
                        RECORD_IP,
                        RECORD_DATE
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.list_name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.list_file#">,
                        #session.ep.userid#,
                        '#cgi.remote_addr#',
                        #now()#
                    )
            </cfquery>
            <cfset response = result>
            <cfreturn response>
    </cffunction>

    <cffunction  name="UpdateTemplate" access="public">
        <cfargument name="template_id">
        <cfargument name="template_name" type="string" default="">
        <cfargument name="template_subject" type="string" default="">
        <cfargument name="template_content" type="string" default="">
        <cfquery name="UPD_MAIL_TEMPLATES" datasource="#dsn#">
            UPDATE
                WRK_MAIL_TAMPLATES
            SET
                TEMPLATE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_name#">,
                TEMPLATE_SUBJECT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_subject#">,
                TEMPLATE_CONTENT =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_content#">,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = '#cgi.remote_addr#',
                UPDATE_DATE= #now()#
            WHERE
				TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TEMPLATE_ID#">
        </cfquery>
    </cffunction>

    <cffunction name="SelectRecipientList" access="public">
        <cfquery name="GET_MAIL_RECIPIENT_LIST" datasource="#dsn#">
            SELECT 
				*
			FROM
				WRK_MAIL_RECIPIENT_LIST
			WHERE
                1=1
                <cfif isDefined('arguments.list_id') and len(arguments.list_id)>AND list_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.list_id#"></cfif>
                <cfif isDefined('arguments.list_name') and len(arguments.list_name)>AND list_name LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.list_name#%"></cfif> 
                <cfif isDefined('arguments.list_file') and len(arguments.list_file)>AND list_file LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.list_file#%"></cfif> 
        </cfquery>
        <cfreturn GET_MAIL_RECIPIENT_LIST>
    </cffunction>

    <cffunction name="SelectTemplates" access="public">
        <cfquery name="GET_MAIL_TEMPLATES" datasource="#dsn#">
            SELECT 
				*
			FROM
				WRK_MAIL_TAMPLATES
			WHERE
                1=1
                <cfif isDefined('arguments.template_id') and len(arguments.TEMPLATE_ID)>AND TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TEMPLATE_ID#"></cfif>
                <cfif isDefined('arguments.template_name') and len(arguments.template_name)>AND TEMPLATE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.TEMPLATE_NAME#%"></cfif> 
        </cfquery>
        <cfreturn GET_MAIL_TEMPLATES>
    </cffunction>

    <cffunction name="InsertMailContent" access="public" returnType="any">
        <cfargument name="delivery_name" type="string" default="">
        <cfargument name="subject" type="string" default="">
        <cfargument name="sender_email" type="string" default="">
        <cfargument name="seen_name" type="string" default="">
        <cfargument name="return_address" type="string" default="">
        <cfargument name="template_name" type="string" default="">
        <cfargument name="mail_list" type="string" default="">
        <cfargument name="startdate" type="date" default="">
        <cfargument name="str_first_hour" default="">
        <cfargument name="str_first_minute" default="">
        <cfargument name="str_second_hour" default="">
        <cfargument name="str_second_minute" default="">
        <cfargument name="is_monday" default="">
        <cfargument name="is_tuesday" default="">
        <cfargument name="is_wednesday" default="">
        <cfargument name="is_thursday" default="">
        <cfargument name="is_friday" default="">
        <cfargument name="is_saturday" default="">
        <cfargument name="is_sunday" default="">
        <cfargument name="finishdate" type="date" default="">
        <cfargument name="fns_hour" default="">
        <cfargument name="fns_minute" default="">
        <cfquery name="ADD_MAIL_CONTENT" datasource="#dsn#" result="result">
            INSERT INTO
                WRK_MAIL_CONTENT
                (
                    DELIVERY_NAME,
                    SUBJECT,
                    SENDER_EMAIL,
                    SEEN_NAME,
                    RETURN_ADDRESS,
                    TEMPLATE_NAME,
                    MAIL_LIST,
                    STARTDATE,
                    STR_FIRST_HOUR,
                    STR_FIRST_MINUTE,
                    STR_SECOND_HOUR,
                    STR_SECOND_MINUTE,
                    IS_MONDAY,
                    IS_TUESDAY,
                    IS_WEDNESDAY,
                    IS_THURSDAY,
                    IS_FRIDAY,
                    IS_SATURDAY,
                    IS_SUNDAY,
                    FINISHDATE,
                    FNS_HOUR,
                    FNS_MINUTE,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE
                )
            VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sender_email#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.seen_name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.return_address#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mail_list#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.str_first_hour#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.str_first_minute#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.str_second_hour#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.str_second_minute#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_monday#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_tuesday#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_wednesday#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_thursday#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_friday#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_saturday#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_sunday#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fns_hour#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fns_minute#">,
                    #session.ep.userid#,
					'#cgi.remote_addr#',
					#now()#
                )
        </cfquery>
        <cfset response = result>
		<cfreturn response>
    </cffunction>

    <cffunction name="SelectMailContent" access="public">
        <cfargument name="delivery_id" type="numeric">
        <cfargument name="delivery_name" type="string" default="">
        <cfargument name="subject" type="string" default="">
        <cfargument name="sender_email" type="string" default="">
        <cfargument name="seen_name" type="string" default="">
        <cfargument name="return_address" type="string" default="">
        <cfargument name="template_name" type="string" default="">
        <cfargument name="mail_list" type="string" default="">
        <cfargument name="startdate" default="">
        <cfargument name="str_first_hour" default="">
        <cfargument name="str_first_minute" default="">
        <cfargument name="str_second_hour" default="">
        <cfargument name="str_second_minute" default="">
        <cfargument name="is_monday" default="">
        <cfargument name="is_tuesday" default="">
        <cfargument name="is_wednesday" default="">
        <cfargument name="is_thursday" default="">
        <cfargument name="is_friday" default="">
        <cfargument name="is_saturday" default="">
        <cfargument name="is_sunday" default="">
        <cfargument name="finishdate" default="">
        <cfargument name="fns_hour" default="">
        <cfargument name="fns_minute" default="">
        <cfquery name="GET_MAIL_CONTENT" datasource="#dsn#">
            SELECT 
                *
            FROM
                WRK_MAIL_CONTENT
            WHERE
                1=1
                <cfif isDefined('arguments.DELIVERY_ID') and len(arguments.DELIVERY_ID)>AND DELIVERY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DELIVERY_ID#"></cfif>
                <cfif isDefined('arguments.DELIVERY_NAME') and len(arguments.DELIVERY_NAME)>AND DELIVERY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.DELIVERY_NAME#%"></cfif>
        </cfquery>
        <cfreturn GET_MAIL_CONTENT>
    </cffunction>

</cfcomponent>