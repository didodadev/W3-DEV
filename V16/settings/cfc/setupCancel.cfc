<cfcomponent>
	<cffunction name="addCancelTypeFnc" access="public" returntype="any">
    
    	<cfargument name="cancel_type" type="string" required="yes">
		<cfargument name="cancel_name" type="string" required="yes" default="">
		<cfargument name="cancel_detail" type="string" required="no" default="">
		<cfargument name="is_active" type="numeric" required="no" default="1">
		
		<cfquery name="Add_Cancel_Type" datasource="#this.dsn3#">
			INSERT INTO
				SETUP_CANCEL_TYPE
			(
                CANCEL_TYPE,
                CANCEL_NAME,
                CANCEL_DETAIL,
                IS_ACTIVE,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP
			)
			VALUES
			(
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cancel_type#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cancel_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cancel_detail#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,	
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.userid#">
			)
            
		</cfquery>
    
    </cffunction>
    
    <cffunction name="updCancelTypeFnc" access="public" returntype="any">
    
    	<cfargument name="cancel_id" type="numeric" required="yes" default="0">
		<cfargument name="cancel_type" type="string" required="yes" default="CREDIT_CARD">
		<cfargument name="cancel_name" type="string" required="yes" default="">
		<cfargument name="cancel_detail" type="string" required="no" default="">
		<cfargument name="is_active" type="numeric" required="no" default="1">
    
    	<cfquery name="Upd_Cancel_Type" datasource="#this.dsn3#">
    		UPDATE 
				SETUP_CANCEL_TYPE
			SET 
				CANCEL_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cancel_type#">,
                CANCEL_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cancel_name#">,
				CANCEL_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cancel_detail#">,
				IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,			
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.userid#">	 
			WHERE 
				CANCEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cancel_id#">
    	</cfquery>
        
    </cffunction>
    
    <cffunction name="getCancelTypeFnc" access="public" returntype="query">
    	<cfargument name="cancel_id" type="any" required="no" default="">
        <cfargument name="cancel_type" type="string" required="no" default="">
        <cfargument name="is_active" type="string" required="no" default="">
        
		<cfquery name="Get_Cancel_Type" datasource="#this.dsn3#">
			SELECT 
                CANCEL_ID,
                CANCEL_NAME, 
                CANCEL_TYPE, 
                CANCEL_DETAIL, 
                IS_ACTIVE , 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP
    		FROM 
    			SETUP_CANCEL_TYPE
                 
    		WHERE 
            	1 = 1
				<cfif len(arguments.cancel_id)>
	    			AND CANCEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cancel_id#">
                </cfif>
                <cfif len(arguments.cancel_type)>
	    			AND CANCEL_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cancel_type#">
                </cfif>
                <cfif len(arguments.is_active)>
	    			AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">
                </cfif>
            ORDER BY 
    			CANCEL_TYPE,CANCEL_NAME
		</cfquery>
		<cfreturn Get_Cancel_Type>
    </cffunction>


</cfcomponent>
