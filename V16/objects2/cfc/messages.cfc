<!--- ADD MESSAGE --->
<cfcomponent>
	<cffunction name="addMessage" access="public" returntype="string">
    <cfargument name="mail" type="string" required="no">
    <cfargument name="mail_head" type="string" required="no">
    <cfargument name="mail_content" type="string" required="no">
    <cfargument name="empapp_id" type="numeric">
    <cfargument name="record_date" type="date" required="yes" default="#now()#">
        <cfquery name="ADD_MESSAGE" datasource="#this.DSN#">
            INSERT INTO 
                EMPLOYEES_APP_MAILS
                (
                EMPAPP_MAIL,
                MAIL_HEAD,
                MAIL_CONTENT,
                EMPAPP_ID,
                RECORD_DATE
                )
            VALUES
                (	
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mail#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mail_head#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mail_content#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.cp.userid#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                )
        </cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.my_messages">
	</cffunction> 
<!---UPD MESSAGES--->    
    <cffunction name="updMessage" access="public" returntype="any">
    <cfargument name="empapp_mail_id" type="numeric" required="yes">
    <cfargument name="is_read" type="any" default="">
    <cfargument name="is_deleted" type="any" default="">
    
        <cfquery name="upd_message" datasource="#DSN#">
            UPDATE
            	EMPLOYEES_APP_MAILS
            SET
            	<cfif len(arguments.is_read)>
            		IS_READ = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_read#">
            	<cfelse>
            		IS_DELETED = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_deleted#">		
            	</cfif>
            WHERE
            	EMPAPP_MAIL_ID = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.empapp_mail_id#">
        </cfquery>
    </cffunction>
<!--- DELETE MESSAGE --->
    <cffunction name="delMessage" access="public" returntype="any">
    <cfargument name="emp_app_mail_id" type="numeric" required="yes">    
        <cfquery name="del_message" datasource="#DSN#">
        	DELETE FROM MESSAGES WHERE MSG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_app_mail_id#">
        </cfquery>
    </cffunction>
</cfcomponent>
	
	
		
			
