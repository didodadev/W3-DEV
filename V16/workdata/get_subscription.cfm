<!--- select_list parametresi 1 olduğunda consumer ve partner çalışanlarını düşürebiliyoruz,2 olduğunda sadece sistem nosunu düşürebiliyoruz. --->
<cffunction name="get_subscription" access="public" returntype="query" output="no">
    <cfargument name="subscription" required="yes" type="string">
    <cfargument name="maxrows" required="yes" type="string" default="">
    <cfargument name="select_list" required="no" type="string" default="1,2">
    <cfargument name="company_id" required="no" type="numeric" default="1">
    <cfargument name="is_special_code" required="no" type="numeric" default="0">
    <cfargument name="is_subscription_no" required="no" type="numeric" default="1">
    <cfargument name="is_company_partner" required="no" type="numeric" default="1">
            
        <cfquery name="GET_SUBS" datasource="#DSN3#">
        <cfif arguments.select_list eq 1>
              SELECT 	
                    'partner' as MEMBER_TYPE,
                    <cfif isDefined('arguments.is_company_partner') and arguments.is_company_partner eq 1>
						<cfif database_type is 'MSSQL'>
                            CP.COMPANY_PARTNER_NAME+ ' ' + CP.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,
                        <cfelseif database_type is 'DB2'>
                            CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME AS MEMBER_NAME,	
                        </cfif>
	                    CP.COMPANY_ID,
                    </cfif>
                    NULL CONSUMER_ID,
		    		SC.BRANCH_ID,
                    <cfif isDefined('arguments.is_company_partner') and arguments.is_company_partner eq 1>
                        CP.PARTNER_ID AS MEMBER_ID,
                        CP.PARTNER_ID,
                    </cfif>
                    C.FULLNAME,
		    		SC.SPECIAL_CODE,
                    SC.SUBSCRIPTION_ID,
                    SC.SUBSCRIPTION_NO,
                    SC.SUBSCRIPTION_HEAD,
                    SC.COMPANY_ID,
                    SC.PARTNER_ID,
                    SC.CONSUMER_ID,
                    SC.SUBSCRIPTION_TYPE_ID,
                    SC.SUBSCRIPTION_STAGE,
                    SC.SHIP_ADDRESS,
                    SST.SUBSCRIPTION_TYPE,
					SC.PROJECT_ID,
                    SC.SUBSCRIPTION_ADD_OPTION_ID,
					(SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = SC.PROJECT_ID) PROJECT_HEAD
                FROM
                    SUBSCRIPTION_CONTRACT SC,
                    SETUP_SUBSCRIPTION_TYPE SST,
                    <cfif isDefined('arguments.is_company_partner') and arguments.is_company_partner eq 1>
                    	#dsn_alias#.COMPANY_PARTNER CP,
                   	</cfif>
                    #dsn_alias#.COMPANY C
                WHERE
                    SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID AND
                    <cfif isDefined('arguments.is_company_partner') and arguments.is_company_partner eq 1>
	                    SC.COMPANY_ID = CP.COMPANY_ID AND
					</cfif> 
                    SC.COMPANY_ID = C.COMPANY_ID AND
                    <cfif isDefined('arguments.company_id') and len(arguments.company_id)>
                    	SC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                    </cfif> 
                    SC.IS_ACTIVE = 1 AND
                    (
                    	<cfif isDefined('arguments.is_special_code') and arguments.is_special_code eq 1>
                        	SC.SPECIAL_CODE LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.subscription#%"> OR
                        </cfif>
                        <cfif isDefined('arguments.is_subscription_no') and arguments.is_subscription_no eq 1>
	                        SC.SUBSCRIPTION_NO LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.subscription#%"> OR
						</cfif> 
                        SC.SUBSCRIPTION_HEAD LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.subscription#%">
                    )
                UNION ALL
                SELECT	
                    'consumer' AS MEMBER_TYPE,
                    <cfif isDefined('arguments.is_company_partner') and arguments.is_company_partner eq 1>
						<cfif database_type is 'MSSQL'>
                        C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME AS MEMBER_NAME,
                        <cfelseif database_type is 'DB2'>
                        C.CONSUMER_NAME || ' ' || C.CONSUMER_SURNAME AS MEMBER_NAME,	
                        </cfif>                    
                        NULL COMPANY_ID,
                    </cfif>
                    C.CONSUMER_ID,
		    		SC.BRANCH_ID,
                    <cfif isDefined('arguments.is_company_partner') and arguments.is_company_partner eq 1>
	                    C.CONSUMER_ID MEMBER_ID,
    	                NULL PARTNER_ID,
    				</cfif>
                    NULL FULLNAME,
                    SC.SPECIAL_CODE,
                    SC.SUBSCRIPTION_ID,
                    SC.SUBSCRIPTION_NO,
                    SC.SUBSCRIPTION_HEAD,
                    SC.COMPANY_ID,
                    SC.PARTNER_ID,
                    SC.CONSUMER_ID,
                    SC.SUBSCRIPTION_TYPE_ID,
                    SC.SUBSCRIPTION_STAGE,
                    SC.SHIP_ADDRESS,
                    SST.SUBSCRIPTION_TYPE,
					SC.PROJECT_ID,
                    SC.SUBSCRIPTION_ADD_OPTION_ID,
					(SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = SC.PROJECT_ID) PROJECT_HEAD
                FROM
                    SUBSCRIPTION_CONTRACT SC,
                    SETUP_SUBSCRIPTION_TYPE SST,
                    #dsn_alias#.CONSUMER C
                WHERE
                    SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID AND
                    SC.CONSUMER_ID=C.CONSUMER_ID AND
                    SC.IS_ACTIVE = 1  AND
                    (
                        SC.SUBSCRIPTION_NO LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.subscription#%"> OR
                        SC.SUBSCRIPTION_HEAD LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subscription#%"> 
                    ) 
				ORDER BY
					SUBSCRIPTION_NO
           </cfif>
           <cfif arguments.select_list eq 2>
                 SELECT
                        '' AS MEMBER_TYPE,
						'' AS MEMBER_NAME,	
						'' AS COMPANY_ID,
						NULL CONSUMER_ID,
						'' AS MEMBER_ID,
						'' AS PARTNER_ID,
						'' AS FULLNAME,
						SC.SUBSCRIPTION_ID,
						SC.SUBSCRIPTION_NO,
						SC.SUBSCRIPTION_HEAD,
						SC.COMPANY_ID,
						SC.PARTNER_ID,
						SC.CONSUMER_ID,
						SC.BRANCH_ID,
						SC.SUBSCRIPTION_TYPE_ID,
						SC.SUBSCRIPTION_STAGE,
						SC.SHIP_ADDRESS,
						SST.SUBSCRIPTION_TYPE,
						SC.PROJECT_ID,
                        SC.SUBSCRIPTION_ADD_OPTION_ID,
						(SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = SC.PROJECT_ID) PROJECT_HEAD
                    FROM
                        SUBSCRIPTION_CONTRACT SC,
                        SETUP_SUBSCRIPTION_TYPE SST
                    WHERE
                        SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID AND
                        SC.IS_ACTIVE = 1 AND
                        (
                            SC.SUBSCRIPTION_NO LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subscription#%"> OR
                            SC.SUBSCRIPTION_HEAD LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subscription#%"> 
                        ) 
            ORDER BY
                SUBSCRIPTION_NO
		   </cfif>
        </cfquery>
<cfreturn get_subs>
</cffunction>

