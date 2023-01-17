<cfif isDefined('attributes.my_members') and attributes.my_members eq -1 and isDefined('get_my_team') and get_my_team.recordcount>
	<cfquery name="GET_MY_TEAM_1" dbtype="query">
    	SELECT
        	*
        FROM
        	GET_MY_TEAM
        WHERE
        	TYPE = 1
    </cfquery> 
	<cfquery name="GET_MY_TEAM_CC" dbtype="query">
    	SELECT
        	*
        FROM
        	GET_MY_TEAM
        WHERE
        	TYPE = 2
    </cfquery> 
</cfif>
<cfquery name="GET_WORKS" datasource="#DSN#">
	<cfif isDefined('attributes.my_members') and attributes.my_members eq -1>
    	<cfif isDefined('get_my_team') and get_my_team.recordcount>
            SELECT
                DISTINCT
                	PW.OUTSRC_PARTNER_ID,
                    PW.PROJECT_EMP_ID,
                    PW.WORK_ID,
                    PW.PROJECT_ID,
                    PW.WORK_HEAD,
                    PW.WORK_CAT_ID,
                    PW.WORK_CURRENCY_ID,
                    PTR.STAGE,
                    SP.PRIORITY,
                    PW.TARGET_START,
                    PW.TARGET_FINISH,
                    PW.RECORD_DATE,
                    PW.UPDATE_DATE
                FROM 
                    PRO_WORKS PW,
                    PROCESS_TYPE_ROWS PTR,
                    SETUP_PRIORITY SP
                WHERE
                    PW.WORK_PRIORITY_ID = SP.PRIORITY_ID AND
                    PTR.PROCESS_ROW_ID= PW.WORK_CURRENCY_ID AND
                    <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                    	PW.WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
                    </cfif>
                    <cfif isDefined('attributes.work_status') and len(attributes.work_status) and attributes.work_status neq 2>
                        PW.WORK_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_status#"> AND
                    </cfif>	
					<cfif isDefined('attributes.pro_work_cat') and len(attributes.pro_work_cat)>
                        PW.WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_work_cat#"> AND
                    </cfif>	                    
                    <cfif isDefined('attributes.service_id') and len(attributes.service_id)>
                        PW.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
                    <cfelseif isDefined('attributes.subscription_id') and len(attributes.subscription_id)>
                        PW.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                    <cfelseif isDefined('attributes.project_id') and len(attributes.project_id)>
                        PW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND             
                        (
                            PW.PROJECT_EMP_ID IN (#ValueList(get_my_team_1.userid,',')#) OR
                           	PW.WORK_ID IN (SELECT WORK_ID FROM PRO_WORKS_CC WHERE CC_EMP_ID IN (#ValueList(get_my_team_1.userid,',')#)) 
                            <cfif get_my_team_cc.recordcount>
                                OR
                                PW.OUTSRC_PARTNER_ID IN (#ValueList(get_my_team_cc.userid,',')#) OR
                                PW.WORK_ID IN (SELECT WORK_ID FROM PRO_WORKS_CC WHERE CC_PAR_ID IN (#ValueList(get_my_team_cc.userid,',')#))
                            </cfif>
                        )
                    <cfelse>
                        (
                            PW.PROJECT_EMP_ID IN (#ValueList(get_my_team_1.userid,',')#) OR
                           	PW.WORK_ID IN (SELECT WORK_ID FROM PRO_WORKS_CC WHERE CC_EMP_ID IN (#ValueList(get_my_team_1.userid,',')#))
                            <cfif get_my_team_cc.recordcount>
                             	OR
                                PW.OUTSRC_PARTNER_ID IN (#ValueList(get_my_team_cc.userid,',')#) OR
                                PW.WORK_ID IN (SELECT WORK_ID FROM PRO_WORKS_CC WHERE CC_PAR_ID IN (#ValueList(get_my_team_cc.userid,',')#))
                            </cfif>
                        )
                    </cfif>
            	<cfelseif get_emps.recordcount>
                   SELECT
                        DISTINCT
                            PW.PROJECT_EMP_ID,
                            PW.WORK_ID,
                            PW.PROJECT_ID,
                            PW.WORK_HEAD,
                    		PW.WORK_CAT_ID,
                    		PW.WORK_CURRENCY_ID,
                            PTR.STAGE,
                            SP.PRIORITY,
                            PW.TARGET_START,
                            PW.TARGET_FINISH,
                            PW.RECORD_DATE,
                            PW.UPDATE_DATE
                        FROM 
                            PRO_WORKS PW,
                            PROCESS_TYPE_ROWS PTR,
                            SETUP_PRIORITY SP
                        WHERE
                            PW.WORK_PRIORITY_ID = SP.PRIORITY_ID AND
                            PTR.PROCESS_ROW_ID= PW.WORK_CURRENCY_ID AND
							<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                                PW.WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
                            </cfif>
                            <cfif isDefined('attributes.work_status') and len(attributes.work_status) and attributes.work_status neq 2>
                                PW.WORK_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_status#"> AND
                            </cfif>	
							<cfif isDefined('attributes.pro_work_cat') and len(attributes.pro_work_cat)>
                                PW.WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_work_cat#"> AND
                            </cfif>	
							<cfif isDefined('attributes.service_id') and len(attributes.service_id)>
                                PW.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
                            <cfelseif isDefined('attributes.subscription_id') and len(attributes.subscription_id)>
                                PW.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                            <cfelseif isDefined('attributes.project_id') and len(attributes.project_id)>
                                PW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND             
                                (
                                    PW.PROJECT_EMP_ID IN (#ValueList(get_emps.employee_id,',')#) OR
                                    PW.WORK_ID IN (SELECT WORK_ID FROM PRO_WORKS_CC WHERE CC_EMP_ID IN (#ValueList(get_emps.employee_id,',')#))
                                ) 
                            <cfelse>
                                (
                                    PW.PROJECT_EMP_ID IN (#ValueList(get_emps.employee_id,',')#)
                                )
                            </cfif>
                 <cfelse>
                 	SELECT
                        PW.PROJECT_EMP_ID,
                        PW.WORK_ID,
                        PW.PROJECT_ID,
                        PW.WORK_HEAD,
                        PW.WORK_CAT_ID,
                        PW.WORK_CURRENCY_ID,
                        PTR.STAGE,
                        SP.PRIORITY,
                        PW.TARGET_START,
                        PW.TARGET_FINISH
                    FROM 
                        PRO_WORKS PW,
                        PROCESS_TYPE_ROWS PTR,
                        SETUP_PRIORITY SP
                    WHERE
                        PW.WORK_PRIORITY_ID = SP.PRIORITY_ID AND
                        PTR.PROCESS_ROW_ID= PW.WORK_CURRENCY_ID AND
						<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                            PW.WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
                        </cfif>
                        <cfif isDefined('attributes.work_status') and len(attributes.work_status) and attributes.work_status neq 2>
                            PW.WORK_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_status#"> AND
                        </cfif>	
						<cfif isDefined('attributes.pro_work_cat') and len(attributes.pro_work_cat)>
                            PW.WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_work_cat#"> AND
                        </cfif>	
						<cfif isDefined('attributes.service_id') and len(attributes.service_id)>
                            PW.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
                        <cfelseif isDefined('attributes.subscription_id') and len(attributes.subscription_id)>
                            PW.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                        <cfelseif isDefined('attributes.project_id') and len(attributes.project_id)>
                            PW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">  
                        <cfelse>
                            (
                                PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
                            )
                        </cfif>
                 
                 </cfif>
	<cfelseif isDefined('attributes.my_members') and len(attributes.my_members)>
        SELECT
            DISTINCT
                PW.PROJECT_EMP_ID,
                PW.WORK_ID,
                PW.PROJECT_ID,
                PW.WORK_HEAD,
                PW.WORK_CAT_ID,
                PW.WORK_CURRENCY_ID,
                PTR.STAGE,
                SP.PRIORITY,
                PW.TARGET_START,
                PW.TARGET_FINISH,
                PW.RECORD_DATE,
                PW.UPDATE_DATE
            FROM 
                PRO_WORKS PW,
                PROCESS_TYPE_ROWS PTR,
        		SETUP_PRIORITY SP
            WHERE
    			PW.WORK_PRIORITY_ID = SP.PRIORITY_ID AND
            	PTR.PROCESS_ROW_ID= PW.WORK_CURRENCY_ID AND
				<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                    PW.WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
                </cfif>
                <cfif isDefined('attributes.work_status') and len(attributes.work_status) and attributes.work_status neq 2>
                    PW.WORK_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_status#"> AND
                </cfif>	
                <cfif isDefined('attributes.pro_work_cat') and len(attributes.pro_work_cat)>
                    PW.WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_work_cat#"> AND
                </cfif>	
				<cfif isDefined('attributes.service_id') and len(attributes.service_id)>
                    PW.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
                <cfelseif isDefined('attributes.subscription_id') and len(attributes.subscription_id)>
                    PW.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#"> AND
                <cfelseif isDefined('attributes.project_id') and len(attributes.project_id)>
                    PW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">  AND  
                <cfelseif attributes.my_members neq -2>
                    (
                        PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.my_members#">
                    ) AND
                </cfif>
                1 = 1
	<cfelse>
       SELECT
            DISTINCT
                PW.PROJECT_EMP_ID,
                PW.WORK_ID,
                PW.PROJECT_ID,
                PW.WORK_HEAD,
                PW.WORK_CAT_ID,
                PW.WORK_CURRENCY_ID,
                PTR.STAGE,
                SP.PRIORITY,
                PW.TARGET_START,
                PW.TARGET_FINISH,
                PW.RECORD_DATE,
                PW.UPDATE_DATE
            FROM 
                PRO_WORKS PW,
                PROCESS_TYPE_ROWS PTR,
                SETUP_PRIORITY SP
            WHERE
                PW.WORK_PRIORITY_ID = SP.PRIORITY_ID AND
                PTR.PROCESS_ROW_ID= PW.WORK_CURRENCY_ID AND               
				<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                    PW.WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
                </cfif>
                <cfif isDefined('attributes.work_status') and len(attributes.work_status) and attributes.work_status neq 2>
                    PW.WORK_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_status#"> AND
                </cfif>	
                <cfif isDefined('attributes.pro_work_cat') and len(attributes.pro_work_cat)>
                    PW.WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_work_cat#"> AND
                </cfif>	
				<cfif isDefined('attributes.service_id') and len(attributes.service_id)>
                    PW.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
                <cfelseif isDefined('attributes.subscription_id') and len(attributes.subscription_id)>
                    PW.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#"> AND
                <cfelseif isDefined('attributes.project_id') and len(attributes.project_id)>
                    PW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">   AND 
                <cfelse>
                    (
                        PW.PROJECT_EMP_ID IN (#ValueList(get_emps.employee_id,',')#)
                    ) AND
                </cfif>
                1 = 1
	</cfif>
    <cfif isDefined('attributes.sort_type') and len(attributes.sort_type)>
        ORDER BY
            <cfif isDefined('attributes.sort_type') and attributes.sort_type eq 1>
                PW.RECORD_DATE DESC
            <cfelseif  isDefined('attributes.sort_type') and attributes.sort_type eq 2>
                PTR.STAGE DESC        
            <cfelseif  isDefined('attributes.sort_type') and attributes.sort_type eq 3>
                PW.UPDATE_DATE DESC    
            </cfif>        
    </cfif>
</cfquery>
