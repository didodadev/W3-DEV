<!---E.A 17.07.2012 select ifadeleriyle alaklı çalışma yapıldı.--->
<!---E.Y 22.08.2012 queryparam ifadeleri eklendi.--->
<cfscript>
	if(isdefined("cc_emp_ids")) s_emps = ListSort(cc_emp_ids,"Numeric","Desc") ; else s_emps ='';
	if(isdefined("cc_par_ids")) s_pars =  ListSort(cc_par_ids,"Numeric", "Desc") ; else s_pars ='';
	if(isdefined("cc_cons_ids")) s_cons = ListSort(cc_cons_ids,"Numeric", "Desc") ; else s_cons ='';
	if(isdefined("cc_grp_ids")) s_grps = ListSort(cc_grp_ids,"Numeric", "Desc") ; else s_grps ='';
	if(isdefined("cc_wgrp_ids")) s_wrkgroups =  ListSort(cc_wgrp_ids,"Numeric", "Desc"); else s_wrkgroups ='';
	if(isdefined("to_emp_ids")) j_emps = ListSort(to_emp_ids,"Numeric", "Desc"); else j_emps ='';	
	if(isdefined("attributes.to_par_ids")) j_pars =  ListSort(TO_PAR_IDS,"Numeric", "Desc"); else j_pars ='';
	if(isdefined("to_cons_ids")) j_cons = ListSort(to_cons_ids,"Numeric", "Desc") ; else j_cons ='';
	if(isdefined("to_grp_ids")) j_grps = ListSort(to_grp_ids,"Numeric", "Desc") ; else j_grps ='';
	if(isdefined("to_wgrp_ids")) j_wrkgroups =  ListSort(to_wgrp_ids,"Numeric", "Desc"); else j_wrkgroups ='';	
</cfscript>

<!---maile katılımcı eklemek için kullanılır --->
<cfset attributes.participant=''>
<cfif len(s_emps)>
	 <cfquery name="GET_EMPS" datasource="#DSN#">
        SELECT 
        	EMPLOYEE_EMAIL,
            EMPLOYEE_ID,
          	EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS NAME,
            POSITION_NAME
        FROM 
            EMPLOYEE_POSITIONS
        WHERE
        	EMPLOYEE_ID IN (#s_emps#) AND NOT (EMPLOYEE_EMAIL IS NULL OR EMPLOYEE_EMAIL = '')
        ORDER BY
        	EMPLOYEE_NAME,
            EMPLOYEE_SURNAME,
            POSITION_NAME
    </cfquery>
      <cfif GET_EMPS.recordcount and not len(get_emps.employee_email)>
        <cfquery name="GET_EMPS" datasource="#DSN#">
            SELECT 
                EMPLOYEES_DETAIL.EMAIL_SPC EMPLOYEE_EMAIL,
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME +' '+ EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS NAME,
                EMPLOYEE_POSITIONS.POSITION_NAME
            FROM 
                EMPLOYEE_POSITIONS LEFT JOIN EMPLOYEES_DETAIL
                ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID
            WHERE
                EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#s_emps#) 
                AND NOT (EMPLOYEES_DETAIL.EMAIL_SPC IS NULL OR EMPLOYEES_DETAIL.EMAIL_SPC = '')
            ORDER BY
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.POSITION_NAME
        </cfquery>
     </cfif>
</cfif>

<cfif len(s_pars)>
	<cfquery name="GET_PARS" datasource="#DSN#">
        SELECT 
            COMPANY_PARTNER_EMAIL,
            COMPANY_PARTNER_NAME +' '+COMPANY_PARTNER_SURNAME AS NAME,
            (SELECT NICKNAME FROM COMPANY C WHERE C.COMPANY_ID=COMPANY_PARTNER.COMPANY_ID) NICKNAME
        FROM  
        	COMPANY_PARTNER  
        WHERE 
        	PARTNER_ID IN(#s_pars#)
        ORDER BY
        	COMPANY_PARTNER_NAME,
            COMPANY_PARTNER_SURNAME,
            NICKNAME
    </cfquery>
</cfif>
<cfif len(s_cons)>
	<cfquery name="S_COMPS" datasource="#DSN#">
         SELECT 
            CONSUMER_EMAIL,
            CONSUMER_NAME +' '+ CONSUMER_SURNAME AS NAME  
         FROM 
            CONSUMER 
         WHERE 
            CONSUMER_ID IN(#s_cons#) AND NOT (CONSUMER_EMAIL IS NULL OR CONSUMER_EMAIL = '')
         ORDER BY
         	CONSUMER_NAME,
            CONSUMER_SURNAME
    </cfquery>
</cfif>
<cfif len(j_emps)>
	<cfquery name="EMPS" datasource="#DSN#">
        SELECT 
            1 AS TYPE,
            EMPLOYEE_EMAIL,
            EMPLOYEE_ID,
            EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME  +'('+POSITION_NAME+')' AS NAME,
            POSITION_NAME,
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME
        FROM 
            EMPLOYEE_POSITIONS
        WHERE 
            EMPLOYEE_ID IN (#j_emps#) AND
           (EMPLOYEE_EMAIL IS NULL OR EMPLOYEE_EMAIL = '') AND
            IS_MASTER = 1
     UNION ALL
       SELECT 
            2 AS TYPE,
            EMPLOYEE_EMAIL,
            EMPLOYEE_ID,
            EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME +'('+POSITION_NAME+')'  AS NAME,
            POSITION_NAME,
            EMPLOYEE_NAME,
            EMPLOYEE_SURNAME
        FROM 
            EMPLOYEE_POSITIONS
        WHERE 
            EMPLOYEE_ID IN (#j_emps#) AND
           (EMPLOYEE_EMAIL IS NOT NULL OR EMPLOYEE_EMAIL <> '') AND
            IS_MASTER = 1
        ORDER BY
            NAME
    </cfquery>
    <cfif emps.recordcount and not len(emps.employee_email)>
        <cfquery name="EMPS" datasource="#DSN#">
            SELECT 
                2 AS TYPE,
                EMPLOYEES_DETAIL.EMAIL_SPC EMPLOYEE_EMAIL,
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME +' '+ EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME  +'('+POSITION_NAME+')' AS NAME,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
            FROM 
                EMPLOYEE_POSITIONS LEFT JOIN EMPLOYEES_DETAIL
                ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID
            WHERE 
                EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#j_emps#) AND
                EMPLOYEE_POSITIONS.IS_MASTER = 1
        </cfquery>
    </cfif>
    <cfset attributes.participant=listappend(attributes.participant,listdeleteduplicates(valuelist(emps.name,','),','))>
</cfif>
<cfif len(j_pars)>
    <cfquery name="PARS" datasource="#DSN#">
        SELECT 
            1 AS TYPE,
            COMPANY_PARTNER_EMAIL,
            COMPANY_PARTNER_NAME +' '+COMPANY_PARTNER_SURNAME +'('+NICKNAME+')'  AS NAME,
            C.NICKNAME
        FROM  
            COMPANY_PARTNER,
            COMPANY C
        WHERE 
            C.COMPANY_ID=COMPANY_PARTNER.COMPANY_ID
            AND COMPANY_PARTNER.PARTNER_ID IN(#j_pars#)
            AND (COMPANY_PARTNER_EMAIL IS NULL OR COMPANY_PARTNER_EMAIL = '')
        UNION ALL
        SELECT 
           2 AS TYPE,
           COMPANY_PARTNER_EMAIL,
           COMPANY_PARTNER_NAME +' '+COMPANY_PARTNER_SURNAME +'('+NICKNAME+')'  AS NAME,
           C.NICKNAME
        FROM  
            COMPANY_PARTNER,
            COMPANY C
        WHERE 
            C.COMPANY_ID=COMPANY_PARTNER.COMPANY_ID
            AND COMPANY_PARTNER.PARTNER_ID IN(#j_pars#)
            AND (COMPANY_PARTNER_EMAIL IS NOT NULL OR COMPANY_PARTNER_EMAIL <> '')
         ORDER BY
            NAME
    </cfquery>
    <cfset attributes.participant=listappend(attributes.participant,listdeleteduplicates(valuelist(pars.name,','),','))>
</cfif>
<cfif len(j_cons)>
	 <cfquery name="COMPS" datasource="#DSN#">
         SELECT 
         	1 AS TYPE,
            CONSUMER_EMAIL,
            CONSUMER_NAME +' '+CONSUMER_SURNAME AS NAME,
            CONSUMER_NAME,
            CONSUMER_SURNAME
         FROM 
            CONSUMER 
         WHERE 
             CONSUMER_ID IN(#j_cons#) AND
            (CONSUMER_EMAIL IS NULL OR CONSUMER_EMAIL = '')
	  UNION ALL
         SELECT
         	2 AS TYPE, 
            CONSUMER_EMAIL,
            CONSUMER_NAME +' '+CONSUMER_SURNAME AS NAME,
            CONSUMER_NAME,
            CONSUMER_SURNAME
         FROM 
            CONSUMER 
         WHERE 
             CONSUMER_ID IN(#j_cons#) AND
            (CONSUMER_EMAIL IS NOT NULL OR CONSUMER_EMAIL <> '')
         ORDER BY
         	 NAME  
    </cfquery>
    <cfset attributes.participant=listappend(attributes.participant,listdeleteduplicates(valuelist(comps.name,','),','))>
</cfif>
<cfset branch_list = ''>
<cfif isdefined("attributes.row_count")>
	<cfloop from="1" to="#listlast(attributes.row_count,',')#" index="i">
		<cfif not listfind(branch_list,evaluate('attributes.branch_id#i#')) and len(evaluate('attributes.branch_id#i#'))>
			<cfset branch_list=listappend(branch_list,evaluate('attributes.branch_id#i#'))>
		</cfif>
	</cfloop>
</cfif>
<cfset int_emp_list="">
<cfset cc_emp_list="">
<cfquery name="GET_TO_EMP" datasource="#DSN#">
	SELECT EVENT_TO_POS AS TO_EMP, EVENT_CC_POS AS CC_EMP FROM EVENT WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>
<cfif get_to_emp.recordcount and len(get_to_emp.to_emp)>
	<cfset int_emp_list = ListSort(get_to_emp.TO_EMP,"numeric","asc")>
</cfif>
<cfif get_to_emp.recordcount and len(get_to_emp.cc_emp)>
	<cfset cc_emp_list = ListSort(get_to_emp.CC_EMP,"numeric","asc")>
</cfif>
<cfset cmps="">
<cfif len(j_pars)>
    <cfloop list="#j_pars#" index="i">
        <cfquery name="GET_CMP" datasource="#DSN#">
            SELECT
                COMPANY.COMPANY_ID
            FROM
                COMPANY,
                COMPANY_PARTNER
            WHERE
                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                COMPANY_PARTNER.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
        </cfquery>
        <cfif not listfind(cmps,get_cmp.company_id)>
            <cfset cmps=listappend(cmps,get_cmp.company_id)>
        </cfif>
    </cfloop>
</cfif>
<cfquery name="get_process_stage" datasource="#dsn#" maxrows="1">
	SELECT
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.time_cost%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_EVENT" datasource="#DSN#">
			UPDATE 
				EVENT SET 
				<cfif isDefined("attributes.valid") and len(attributes.valid)>
                    <cfif attributes.valid eq 0>
                        <cfif isDefined("session.agenda_userid")>
                        <!--- BASKASINDA --->
                            <cfif session.agenda_user_type is "E">
								<!--- EMP --->
                                VALID_EMP = #session.ep.userid#,
                                VALID = 0,
                                VALID_DATE = #createodbcdatetime(now())#,
                            <cfelseif session.agenda_user_type is "P">
	                            <!--- EMP --->
                                VALID_PAR_ID = #session.ep.userid#,
                                VALID_PAR = 0,
                                VALID_PAR_DATE = #createodbcdatetime(now())#,
                            </cfif>
                        <cfelse>
                        	<!--- KENDINDE --->
                            VALID_EMP = #session.ep.userid#,
                            VALID = 0,
                            VALID_DATE = #createodbcdatetime(now())#,
                        </cfif>
                    <cfelseif attributes.valid eq 1>
                        <cfif isDefined("session.agenda_userid")>
                        	<!--- BAŞKASİNDA --->
                            <cfif session.agenda_user_type is "E">
								<!--- EMP --->
                                VALID_EMP = #session.ep.userid#,
                                VALID = 1,
                                VALID_DATE = #createodbcdatetime(now())#,
                            <cfelseif session.agenda_user_type is "P">
								<!--- PAR --->
                                VALID_PAR_ID = #session.ep.userid#,
                                VALID_PAR = 1,
                                VALID_PAR_DATE = #createodbcdatetime(now())#,
                            </cfif>
                        <cfelse>
                        <!--- KENDINDE --->
                            VALID_EMP = #session.ep.userid#,
                            VALID = 1,
                            VALID_DATE = #createodbcdatetime(now())#,
                        </cfif>
                    </cfif>
                <cfelseif isDefined("validator_id")>
                    <cfif len(validator_id) and len(validator)>
                        <cfif validator_type eq "employee">
                            VALIDATOR_POSITION_CODE = #validator_id#,
                            VALIDATOR_PAR = NULL,
                        <cfelseif validator_type eq "partner">
                            VALIDATOR_POSITION_CODE = NULL,
                            VALIDATOR_PAR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#validator_id#">,
                        </cfif>
                    <cfelseif isdefined("session.ep.userid")>
                        VALIDATOR_POSITION_CODE = NULL,
                        VALIDATOR_PAR = NULL,
                        VALID = 1,
                        VALID_DATE = #createodbcdatetime(now())#,
                        VALID_EMP = #session.ep.userid#,
                    <cfelseif isdefined("session.pp.userid")>
                        VALIDATOR_POSITION_CODE = NULL,
                        VALIDATOR_PAR = #session.pp.userid#,
                        VALID = 1,
                        VALID_DATE = #createodbcdatetime(now())#,
                        VALID_EMP = NULL,
                    </cfif>
              	</cfif>
				<cfif len(j_emps)>
                    EVENT_TO_POS=<cfqueryparam cfsqltype="cf_sql_varchar" value=",#j_emps#,">,
                <cfelse>
                    EVENT_TO_POS=NULL,
                </cfif>
                <cfif len(j_pars)>
                    EVENT_TO_PAR=<cfqueryparam cfsqltype="cf_sql_varchar" value=",#j_pars#,">,
                <cfelse>
                    EVENT_TO_PAR=NULL,
                </cfif>
                <cfif len(j_cons)>
                    EVENT_TO_CON=<cfqueryparam cfsqltype="cf_sql_varchar" value=",#j_cons#,">,
                <cfelse>
                    EVENT_TO_CON=NULL,
                </cfif>
                <cfif len(j_grps)>
                    EVENT_TO_GRP=<cfqueryparam cfsqltype="cf_sql_varchar" value=",#j_grps#,">,
                <cfelse>
                    EVENT_TO_GRP=NULL,
                </cfif>
                <cfif len(j_wrkgroups)>
                    EVENT_TO_WRKGROUP=<cfqueryparam cfsqltype="cf_sql_varchar" value=",#j_wrkgroups#,">,
                <cfelse>
                    EVENT_TO_WRKGROUP=NULL,
                </cfif>
                <cfif len(s_emps)>
                    EVENT_CC_POS=<cfqueryparam cfsqltype="cf_sql_varchar" value=",#s_emps#,">,
                <cfelse>
                    EVENT_CC_POS=NULL,
                </cfif>
                <cfif len(s_pars)>
                    EVENT_CC_PAR=<cfqueryparam cfsqltype="cf_sql_varchar" value=",#s_pars#,">,
                <cfelse>
                    EVENT_CC_PAR=NULL,
                </cfif>
                <cfif len(s_cons)>
                    EVENT_CC_CON =<cfqueryparam cfsqltype="cf_sql_varchar" value=",#s_cons#,">,
                <cfelse>
                    EVENT_CC_CON =NULL,
                </cfif>
                <cfif len(s_grps)>
                    EVENT_CC_GRP=<cfqueryparam cfsqltype="cf_sql_varchar" value=",#s_grps#,">,
                <cfelse>
                    EVENT_CC_GRP=NULL,
                </cfif>
                <cfif len(s_wrkgroups)>
                    EVENT_CC_WRKGROUP=<cfqueryparam cfsqltype="cf_sql_varchar" value=",#s_wrkgroups#,">,
                <cfelse>
                    EVENT_CC_WRKGROUP=NULL,
                </cfif>
				<cfif isDefined("session.agenda_userid")>
                <!--- BAŞKASİNDA --->
                    <cfif session.agenda_user_type IS "P">
						<!--- PAR --->
                        UPDATE_PAR = #session.ep.userid#,
                    <cfelseif session.agenda_user_type IS "E">
						<!--- EMP --->
                        UPDATE_EMP = #session.ep.userid#,
                    </cfif>
                <cfelseif isdefined("session.ep.userid")>
	                <!--- KENDINDE --->
                    UPDATE_EMP = #session.ep.userid#,
                <cfelseif isdefined("session.pp.userid")>
                    UPDATE_PAR = #session.pp.userid#,
                </cfif>
				IS_INTERNET = <cfif isdefined('attributes.is_internet') and attributes.is_internet eq 1>1<cfelse>0</cfif>,
				IS_GOOGLE_CAL = <cfif isdefined('attributes.is_google_cal') and attributes.is_google_cal eq 1>1<cfelse>0</cfif>,
				<cfif isDefined("attributes.view_to_all")>
                    VIEW_TO_ALL=1,
                    IS_WIEW_BRANCH = NULL,
                    IS_WIEW_DEPARTMENT = NULL,
                    IS_VIEW_COMPANY = NULL,
                <cfelseif isDefined("attributes.is_wiew_branch")>
                    VIEW_TO_ALL=0,
                    IS_WIEW_BRANCH = #attributes.is_wiew_branch#,
                    IS_WIEW_DEPARTMENT = NULL,
                    IS_VIEW_COMPANY = NULL,
                <cfelseif isDefined("attributes.is_wiew_department")>
                    VIEW_TO_ALL=0,
                    IS_WIEW_BRANCH = NULL,
                    IS_WIEW_DEPARTMENT = #attributes.is_wiew_department#,
                    IS_VIEW_COMPANY = NULL,
                <cfelseif isDefined("attributes.is_view_comp")>
                    VIEW_TO_ALL=0,
                    IS_WIEW_BRANCH = NULL,
                    IS_WIEW_DEPARTMENT = NULL,
                    IS_VIEW_COMPANY = #attributes.is_view_comp#,
                <cfelse>
                    VIEW_TO_ALL=NULL,
                    IS_WIEW_BRANCH = NULL,
                    IS_WIEW_DEPARTMENT = NULL,
                    IS_VIEW_COMPANY = NULL,
                </cfif>
				<cfif len(attributes.warning_start)>
                    WARNING_START = #attributes.warning_start#,
                <cfelse>
                    WARNING_START = NULL,
                </cfif>
                <cfif not len(link_id)>
                    LINK_ID = NULL,
                <cfelse>
                    LINK_ID = #link_id#, 
                </cfif>
                <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
                    PROJECT_ID = #attributes.project_id#,
                <cfelse>
                    PROJECT_ID = NULL,
                </cfif>	
                <cfif isdefined("attributes.camp_id")  and isdefined("attributes.camp_name")>	
                    <cfif len(attributes.camp_id) and len(attributes.camp_name)>CAMP_ID = #attributes.camp_id#,<cfelse>CAMP_ID = NULL,</cfif>
                </cfif>
				<cfif isdefined("attributes.link_update") and attributes.link_update eq 1 and len(LINK_ID)>
					<!--- toplu guncellemede tarihler update edilmez --->
				<cfelse>
					STARTDATE = #attributes.startdate#, 
					FINISHDATE = #attributes.finishdate#, 
				</cfif>
				WARNING_EMAIL = #attributes.email_alert_day#, 
				WARNING_SMS = <cfif session.ep.our_company_info.sms eq 1>#attributes.sms_alert_day#,<cfelse>NULL, </cfif>
				EVENTCAT_ID = #attributes.eventcat_id#, 
				EVENT_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.event_head#">,
				EVENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.event_detail#">,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				<cfif isdefined("attributes.event_place") and len(attributes.event_place)>
					EVENT_PLACE_ID = #attributes.event_place#,
				<cfelse>
					EVENT_PLACE_ID = NULL,
				</cfif>
				EVENT_STAGE =<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				EVENT_TO_BRANCH = <cfif isdefined('branch_list') and len(branch_list)><cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_list#"><cfelse>NULL</cfif>,
				WORK_ID = <cfif isdefined("attributes.work_id") and len(attributes.work_id) and len(attributes.work_head)>#attributes.work_id#<cfelse>NULL</cfif>,
                ONLINE_MEET_LINK = <cfif isdefined("attributes.place_online") and len(attributes.place_online)>'#attributes.place_online#'<cfelse>NULL</cfif>
		  WHERE
				EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
				<cfif isdefined("attributes.link_update") and attributes.link_update eq 1 and len(link_id)>
					OR LINK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#link_id#">
				</cfif>
		</cfquery>
		<cfif isdefined("attributes.link_update") and attributes.link_update eq 1 and len(link_id)>
			<cfquery name="UPD_EVENT" datasource="#DSN#">
                UPDATE 
                    EVENT
                SET
                    STARTDATE = #attributes.startdate#,
                    FINISHDATE = #attributes.finishdate#
                WHERE
                    EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
			</cfquery>
		</cfif>
        <!--- Çoklu şirket seçimi yetkisi --->
        <cfquery name="DEL_COMP" datasource="#DSN#">
            DELETE FROM EVENT_COMPANY WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
        </cfquery>
        <cfif isdefined("attributes.agenda_company") and isdefined("attributes.is_view_comp")>
            <cfloop list="#attributes.agenda_company#" index="cc">
                <cfquery name="ADD_COMP" datasource="#DSN#">
                    INSERT INTO EVENT_COMPANY
                    (
                        EVENT_ID,
                        COMPANY_ID
                    )
                    VALUES
                    (
                        #attributes.event_id#,
                        #cc#
                    )
                </cfquery> 
            </cfloop>
        </cfif>
		<!--- site tanimlari internette goster --->
		<cfquery name="DEL_SITE_DOMAIN" datasource="#DSN#">
			DELETE FROM EVENT_SITE_DOMAIN WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
		</cfquery>
		<cfif isdefined("attributes.is_internet") and attributes.is_internet eq 1>
			<cfquery name="GET_COMPANY" datasource="#DSN#">
				SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS 
			</cfquery>
			<cfoutput query="get_company">
				<cfif isdefined("attributes.menu_#menu_id#")>
					<cfquery name="ADD_EVENT_SITE_DOMAIN" datasource="#DSN#">
						INSERT INTO
							EVENT_SITE_DOMAIN
							(
								EVENT_ID,
								MENU_ID
							)
						VALUES
							(
								#attributes.event_id#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes['menu_#menu_id#']#">
							)	
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
		<cfscript>
			structdelete(session.agenda,"event#attributes.event_id#");
		</cfscript>
		<cfquery name="GET_LIST_EVENT_RELATED" datasource="#DSN#">
			SELECT EVENT_ID FROM EVENTS_RELATED WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#"> AND ACTION_SECTION = 'PROJECT_ID'
		</cfquery>
		<cfif get_list_event_related.recordcount>
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
				<cfquery name="UPD_EVENT_RELATED" datasource="#DSN#">
					UPDATE
						EVENTS_RELATED 
					SET
						ACTION_ID = #attributes.project_id#,
						ACTION_SECTION = 'PROJECT_ID',
						COMPANY_ID = <cfif isdefined("session.ep.company_id")>#session.ep.company_id#<cfelse>#session.pp.our_company_id#</cfif>
					WHERE
						EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
						AND ACTION_SECTION = 'PROJECT_ID'
				</cfquery>
			<cfelse>
				<cfquery name="DELETE_EVENT_RELATED" datasource="#DSN#">
					DELETE FROM EVENTS_RELATED WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#"> AND ACTION_SECTION = 'PROJECT_ID'
				</cfquery>
			</cfif>
		<cfelse>
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
				<cfquery name="INS_EVENT_RELATED" datasource="#DSN#">
					INSERT INTO
						EVENTS_RELATED
					(
						ACTION_ID,
						ACTION_SECTION,
						EVENT_ID,
						COMPANY_ID		
					)		
					VALUES
					(
                        #attributes.project_id#,
                        'PROJECT_ID',
                        #attributes.event_id#,
                        <cfif isdefined("session.ep.company_id")>
                        	#session.ep.company_id#
                        <cfelse>
                        	#session.pp.our_company_id#
                        </cfif>
					)
				</cfquery>
			</cfif>
		</cfif>
		<!--- FA20070226 zaman harcamasi ekleniyor --->
		<cfif len(j_emps)>
			<cfif not (isdefined("attributes.total_time_hour") and len(attributes.total_time_hour))>
				<cfset attributes.total_time_hour=0>
			</cfif>
			<cfif not (isdefined("attributes.total_time_minute") and len(attributes.total_time_minute))>
				<cfset attributes.total_time_minute=0>
			</cfif>
			<cfloop list="#j_emps#" index="tc">
				<cfif (attributes.total_time_hour gt 0 or attributes.total_time_minute gt 0)>
					<cfquery name="GET_HOURLY_SALARY" datasource="#DSN#" maxrows="1">
						SELECT
							EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMP_NAME,
							ON_MALIYET,
							ON_HOUR
						FROM
							EMPLOYEE_POSITIONS
						WHERE
							EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tc#"> AND
							IS_MASTER = 1
					</cfquery>
					<cfif (get_hourly_salary.recordcount and (not len(get_hourly_salary.on_maliyet) or not len(get_hourly_salary.on_hour) or get_hourly_salary.on_hour eq 0 or get_hourly_salary.on_maliyet eq 0)) or get_hourly_salary.recordcount eq 0>
						<script type="text/javascript">
							alert("<cfoutput>#get_hourly_salary.emp_name#</cfoutput>'in İnsan Kaynakları Bölümü Pozisyon Çalışma Maliyeti Belirtilmemiş !");
							history.back();
						</script>
						<cfabort>
					<cfelse>
						<cfset salary_minute = get_hourly_salary.on_maliyet / get_hourly_salary.on_hour / 60>
					</cfif>
					<cfset topson=(attributes.total_time_hour*60)+attributes.total_time_minute>
					<!---<cfset topson=topson/60>--->
					<cfquery name="TIME_TOTAL" datasource="#DSN#">
						SELECT 
							SUM(TOTAL_TIME) AS TOTAL_TIME
						FROM
							TIME_COST
						WHERE
							EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tc#"> AND
							(EVENT_DATE > #DATEADD('d',-1,now())# AND EVENT_DATE <= #now()#)
					</cfquery>
					<cfif time_total.recordcount and len(time_total.total_time)>
						<cfset xx=time_total.total_time + topson>
					<cfelse>
						<cfset xx=topson>
					</cfif>
					<cfif xx gt 1440>
						<script type="text/javascript">
							alert("<cfoutput>#get_hourly_salary.emp_name#</cfoutput> - Bir Gün İçinde 24 Saatten Fazla Zaman Harcaması Girilemez!");
							history.back();
						</script>
						<cfabort>
					</cfif>
					<cfquery name="GET_HOUR" datasource="#DSN#">
						SELECT
							EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS EMP_NAME,
							ON_MALIYET,
							ON_HOUR
						FROM
							EMPLOYEE_POSITIONS
						WHERE
							EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tc#">
					</cfquery>
					<cfif not len(get_hour.on_hour)>
						<script type="text/javascript">
							alert("<cfoutput>#get_hourly_salary.emp_name#</cfoutput>'in SSK Aylık İş Saatlerini Düzenleyiniz!");
							history.back();
						</script>
						<cfabort>
					</cfif>
					<cfquery name="GET_MONEY" datasource="#DSN#">
						 SELECT
							ON_MALIYET AS SALARY 
						FROM
							EMPLOYEE_POSITIONS,
							DEPARTMENT
						WHERE
							EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND 
							EMPLOYEE_POSITIONS.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#tc#">
					</cfquery>
					<cfset total_min=(attributes.total_time_hour*60)+attributes.total_time_minute>
					<cfset para=round(salary_minute*total_min)>	
                    <cfset topson=topson/60>			
					<cfquery name="ADD_TIME_COST" datasource="#DSN#">
						INSERT INTO
							TIME_COST
						(
							OUR_COMPANY_ID,
							EVENT_ID,
							PROJECT_ID,
							TOTAL_TIME,
							EXPENSED_MONEY,
							EXPENSED_MINUTE,
							EMPLOYEE_ID,
							EVENT_DATE,
							COMMENT,
							STATE,
							TIME_COST_STAGE,
							RECORD_DATE,
							RECORD_IP,
							RECORD_EMP
						)
						VALUES
						(
							#session.ep.company_id#,
							#attributes.event_id#,
							<cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
							#TOPSON#,
							#PARA#,
							#TOTAL_MIN#,
							#tc#,
							#now()#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.event_head#">,
							1,
							<cfif isdefined('get_process_stage.process_row_id') and len(get_process_stage.process_row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#"><cfelse>NULL</cfif>,
							#now()#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							#session.ep.userid#
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<!--- güncelle ve mail gönder butonuna tıklandıysa --->
<cfif isdefined('attributes.send_mail_agenda') and len(attributes.send_mail_agenda) and attributes.send_mail_agenda eq 1> 
    <cfquery name="GET_MAILFROM" datasource="#DSN#">
        SELECT
            <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_EMAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_EMAIL</cfif>
        FROM		
            <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEES<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
        WHERE
            <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"></cfif>
    </cfquery>
    <cfif GET_MAILFROM.recordcount AND NOT LEN(GET_MAILFROM.EMPLOYEE_EMAIL)  and listfindnocase(employee_url,'#cgi.http_host#',';')>
    	<cfquery name="GET_MAILFROM" datasource="#DSN#">
            SELECT
                <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMAIL_SPC as EMPLOYEE_EMAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_EMAIL</cfif>
            FROM		
                <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEES_DETAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
            WHERE
                <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"></cfif>
		</cfquery>            
    </cfif>
	<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
        <cfset sender = "#get_mailfrom.employee_email#">
    <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
        <cfset sender = "#get_mailfrom.company_partner_email#">
    </cfif>
	<cfif len(sender)>
		<cfset list_mail="">
        <cfset list_name="">
	    <!---Çalışanlara, Bireysel ve Kurumsal üyelere mail gönderme--->
        <cfif listlen(j_emps)>
            <cfoutput query="emps">
                <cfif len(emps.employee_email)>
                    <cfif not listfind(list_mail,employee_email,',')>
                        <cfset list_mail=listappend(list_mail,emps.employee_email,',')>
                        <cfset list_name=listappend(list_name,emps.name,',')>
                    </cfif>
                </cfif>
            </cfoutput>
        </cfif>
        <cfif listlen(s_emps)>
            <cfoutput query="get_emps">
                <cfif len(get_emps.employee_email)>
                    <cfif not listfind(list_mail,employee_email,',')>
                        <cfset list_mail=listappend(list_mail,get_emps.employee_email,',')>
                        <cfset list_name=listappend(list_name,get_emps.name,',')>
                    </cfif>
                </cfif>
            </cfoutput>
        </cfif>
        <cfif listlen(j_cons)>
            <cfoutput query="comps">
                <cfif len(comps.consumer_email)>
                    <cfif not listfind(list_mail,consumer_email,',')>
                        <cfset list_mail=listappend(list_mail,comps.consumer_email,',')>
                        <cfset list_name=listappend(list_name,comps.name,',')>
                    </cfif>
                </cfif>
            </cfoutput>
         </cfif>
        <cfif listlen(s_cons)>
            <cfoutput query="s_comps">
                <cfif len(s_comps.consumer_email)>
                    <cfif not listfind(list_mail,consumer_email,',')>
                        <cfset list_mail=listappend(list_mail,s_comps.consumer_email,',')>
                        <cfset list_name=listappend(list_name,s_comps.name,',')>
                    </cfif>
                </cfif>
            </cfoutput>
        </cfif>
        <cfif listlen(j_pars)>
            <cfoutput query="pars">
                <cfif len(pars.company_partner_email)>
                    <cfif not listfind(list_mail,company_partner_email)>
                        <cfset list_mail=listappend(list_mail,pars.company_partner_email,',')>
                        <cfset list_name=listappend(list_name,pars.name,',')>
                    </cfif>
                </cfif>
            </cfoutput>
        </cfif>
        <cfif listlen(s_pars)>
            <cfoutput query="get_pars">
                <cfif len(get_pars.company_partner_email)>
                    <cfif not listfind(list_mail,company_partner_email)>
                        <cfset list_mail=listappend(list_mail,get_pars.company_partner_email,',')>
                        <cfset list_name=listappend(list_name,get_pars.name,',')>
                    </cfif>
                </cfif>
            </cfoutput>
        </cfif>
		<!--- ics dosyası oluşturma --->
        <cfquery name="GET_EVENT" datasource="#DSN#">
            SELECT * FROM EVENT WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
        </cfquery>
		<cfset startdate_ = date_add('h', session.ep.time_zone, attributes.startdate)>
        <cfset finishdate_ = date_add('h', session.ep.time_zone, attributes.finishdate)>
		<cfoutput query="get_event">
			<cfset filename = "event_#attributes.event_id#.ics">
            <cfset fileRmmbrname="event1_#attributes.event_id#.ics">
            <!--- calendar dosyasının içeriğini oluşturma kısmı--->
            <cf_wrk_Calendar content_name="vCalendar.content" sender="#sender#" startdate="#startdate_#" finishdate="#finishdate_#" recorddate="#get_event.update_date#" detail="#get_event.event_detail#" summary="#get_event.event_head#" type="0">
            <cfif attributes.xml_remember eq 1><!--- hatırlatıcı için--->
                <cfif get_event.event_place_id eq 1>
                	<cfset location="Ofis İçi">
                <cfelseif get_event.event_place_id eq 2>
                	<cfset location="Ofis Dışı">
                <cfelseif get_event.event_place_id eq 3>
                	<cfset location="Müşteri Ofisi">
                <cfelse>
                	<cfset location="">
                </cfif>
                <cf_wrk_Calendar content_name="vRemember.content" sender="#sender#" startdate="#startdate_#" finishdate="#finishdate_#" recorddate="#get_event.update_date#" detail="#get_event.event_detail#" summary="#get_event.event_head#" location="#location#" list_mail="#list_mail#" type="1">
			</cfif>
            <cfif not DirectoryExists("#upload_folder#agenda#dir_seperator#ics#dir_seperator##dateformat(now(),'yyyymmdd')#")>
                <cfdirectory action="create" directory="#upload_folder#agenda#dir_seperator#ics#dir_seperator##dateformat(now(),'yyyymmdd')#">
            </cfif>
            <cfdirectory action="list" directory="#upload_folder#agenda#dir_seperator#ics" name="get_olds">
            <cfloop query="get_olds">
                <cfset d_name_ = name>
                <cfif d_name_ lt dateformat(now(),'yyyymmdd')>
                    <cfdirectory action="list" directory="#upload_folder#agenda#dir_seperator#ics#dir_seperator##d_name_#" name="get_d_ic">
                    <cfif get_d_ic.recordcount>
                        <cfloop query="get_d_ic">
                            <cffile action="delete" file="#upload_folder#agenda#dir_seperator#ics#dir_seperator##d_name_##dir_seperator##get_d_ic.name#">
                        </cfloop>
                    </cfif>
                    <cfdirectory action="delete" directory="#upload_folder#agenda#dir_seperator#ics#dir_seperator##d_name_#">
                </cfif>
            </cfloop>
            <cffile action="write" file="#upload_folder#agenda#dir_seperator#ics#dir_seperator##dateformat(now(),'yyyymmdd')##dir_seperator##filename#" output="#Trim(vCalendar.content)#" charset="utf-8">
            <cfif attributes.xml_remember eq 1>
          		<cffile action="write" file="#upload_folder#agenda#dir_seperator#ics#dir_seperator##dateformat(now(),'yyyymmdd')##dir_seperator##fileRmmbrname#" output="#Trim(vRemember.content)#" charset="utf-8">
            </cfif> 
        </cfoutput>
        <!--- mail gönderme İşlemi--->
        <cfif len(list_mail)>
            <cfloop from="1" to="#listlen(list_mail)#" index="i">
                <cfset attributes.mail_content_to = listgetat(list_mail,i,',')>
                <cfset attributes.mail_content_from = sender>
                <cfset attributes.mail_content_subject = attributes.event_head>
                <cfset attributes.mail_content_additor = listgetat(list_name,i,',')>
                <cfset attributes.mail_record_emp=get_event.record_emp>
                <cfset attributes.mail_record_date= DateFormat(date_add('h',2,get_event.record_date), dateformat_style) & " " & TimeFormat(date_add('h',2,get_event.record_date), timeformat_style)>
                <cfset attributes.mail_update_emp='#session.ep.name# #session.ep.surname#'>
                <cfset attributes.mail_update_date=DateFormat(date_add('h',2,get_event.update_date), dateformat_style) & " " & TimeFormat(date_add('h',2,get_event.update_date), timeformat_style)>
                <cfset attributes.project_head='#attributes.project_head#'>
                <cfset attributes.project_id='#attributes.project_id#'>
                <cfset attributes.start_date=DateFormat(startdate_, dateformat_style) & " " & TimeFormat(startdate_, timeformat_style)>
                <cfset attributes.finish_date=DateFormat(finishdate_, dateformat_style) & " " & TimeFormat(finishdate_,timeformat_style)>
                <cfsavecontent variable="attributes.mail_content_info"><cf_get_lang_main no='1745.Bilgilendirme'></cfsavecontent>
                <cfsavecontent variable="attributes.mail_content_info2"><cfoutput>#attributes.event_detail#</cfoutput></cfsavecontent>
                <cfif cgi.server_port eq 443>
                    <cfset user_domain = "https://#cgi.server_name#">
                <cfelse>
                    <cfset user_domain = "http://#cgi.server_name#">
                </cfif>
                <cfset attributes.mail_content_link = '#user_domain#/#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#attributes.event_id#'>
                <cfset attributes.mail_content_param_file_list = '#upload_folder#agenda#dir_seperator#ics#dir_seperator##dateformat(now(),'yyyymmdd')##dir_seperator##filename#'>
                <cfif attributes.xml_remember eq 1> 
                	<cfset attributes.mail_content_param_file_list = listappend(attributes.mail_content_param_file_list,'#upload_folder#agenda#dir_seperator#ics#dir_seperator##dateformat(now(),'yyyymmdd')##dir_seperator##fileRmmbrname#',';')>
                </cfif>
                <cfset attributes.process_stage_info = attributes.process_stage>
				<cfinclude template="/design/template/info_mail/mail_content.cfm">
            </cfloop>
        <cfelse>
            <script type="text/javascript">
                alert("Katılımcı E-posta Adresleri Tanımlı Değil, E-posta Gönderilemedi!");
				window.location='<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#attributes.event_id#</cfoutput>';
            </script>
            <cfabort>
        </cfif>
    <cfelse>
        <script type="text/javascript">
            alert("E-posta Adresiniz Tanımlı Değil E-posta Gönderemezsiniz!");
			window.location='<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#attributes.event_id#</cfoutput>';
        </script>
        <cfabort>
    </cfif>
</cfif>