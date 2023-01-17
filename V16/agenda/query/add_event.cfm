<cfscript>
	cmps='';
	if(isdefined("cc_emp_ids")) s_emps = ListSort(cc_emp_ids,"Numeric", "Desc"); else s_emps = '';
	if(isdefined("cc_par_ids")) s_pars = ListSort(cc_par_ids,"Numeric", "Desc") ; else s_pars = '';
	if(isdefined("cc_cons_ids")) s_cons = ListSort(cc_cons_ids,"Numeric", "Desc") ; else s_cons = '';
	if(isdefined("cc_grp_ids")) s_grps = ListSort(cc_grp_ids,"Numeric", "Desc") ; else s_grps = '';
	if(isdefined("cc_wgrp_ids")) s_wrkgroup = ListSort(cc_wgrp_ids,"Numeric", "Desc") ; else s_wrkgroup = '';
	if(isdefined("to_emp_ids")) j_emps = ListSort(to_emp_ids,"Numeric", "Desc") ; else j_emps = '';	
	if(isdefined("attributes.to_par_ids")) j_pars = ListSort(to_par_ids,"Numeric", "Desc") ; else j_pars = '';
	if(isdefined("to_cons_ids")) j_cons = ListSort(to_cons_ids,"Numeric", "Desc") ; else j_cons = '';
	if(isdefined("to_grp_ids")) j_grps = ListSort(to_grp_ids,"Numeric", "Desc") ; else j_grps = '';
	if(isdefined("to_wgrp_ids")) j_wrkgroup = ListSort(to_wgrp_ids,"Numeric", "Desc"); else j_wrkgroup = '';	
</cfscript>
<cfset attributes.participant=''>
<!--- hic kimse secilmedi ise kaydeden katilimci olur yo26012009--->			
<cfif not listlen(j_emps) and not listlen(j_emps) and not listlen(j_pars) and not listlen(j_cons) and not listlen(j_grps) and not listlen(j_wrkgroup)>
	<cfif not isdefined("attributes.view_to_all") and not isdefined("attributes.is_wiew_branch") and not isdefined("attributes.is_wiew_department") and not isdefined("attributes.is_view_comp")>
		<cfset j_emps = '#session.ep.userid#'>
	</cfif>
</cfif>
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
        	EMPLOYEE_ID IN (#s_emps#) 
            AND NOT (EMPLOYEE_EMAIL IS NULL OR EMPLOYEE_EMAIL = '')
        ORDER BY
        	EMPLOYEE_NAME,
            EMPLOYEE_SURNAME,
            POSITION_NAME
    </cfquery>
    <cfif not len(get_emps.employee_email)>
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
	<cfquery name="GET_PARS"  datasource="#DSN#">
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
    <cfif emps.recordcount and not len(emps.employee_email) and len(attributes.validator_id)>
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
                EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#listAppend(j_emps,attributes.validator_id)#) AND
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
	<cfset attributes.participant=listappend(attributes.participant,listdeleteduplicates(valuelist(pars.name,',')),',')>
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
        <cfif isdefined("attributes.branch_id#i#")>
            <cfif not listfind(branch_list,evaluate('attributes.branch_id#i#')) and len(evaluate('attributes.branch_id#i#'))>
                <cfset branch_list=listappend(branch_list,evaluate('attributes.branch_id#i#'))>
            </cfif>
        </cfif>
    </cfloop>
</cfif>
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
<cflock name="#createuuid()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_EVENT" datasource="#DSN#">
     		INSERT INTO
				EVENT
                (
                    EVENT_TO_BRANCH,
                    EVENTCAT_ID,
                    STARTDATE,
                    FINISHDATE, 
                    EVENT_HEAD,
                    EVENT_DETAIL,
                    EVENT_STAGE,		
                    WARNING_EMAIL,
                    WARNING_SMS,
                    EVENT_PLACE_ID,
                    <cfif isdefined("url.project_id") or (isdefined("attributes.project_id") and len(attributes.project_id))>PROJECT_ID,</cfif>
                    <cfif isdefined("attributes.camp_id") and isdefined("attributes.camp_name")>CAMP_ID,</cfif>
                    <cfif isdefined("url.opp_id")>OPP_ID,</cfif>
                    <cfif isdefined("url.offer_id")>OFFER_ID,</cfif>
                    <cfif len(j_emps)>EVENT_TO_POS,</cfif>
                    <cfif len(j_pars)>EVENT_TO_PAR,</cfif>
                    <cfif len(j_cons)>EVENT_TO_CON,</cfif>
                    <cfif len(j_grps)>EVENT_TO_GRP,</cfif>	
                    <cfif len(j_wrkgroup)>EVENT_TO_WRKGROUP,</cfif>
                    <cfif len(s_emps)>EVENT_CC_POS,</cfif>
                    <cfif len(s_pars)>EVENT_CC_PAR,</cfif>
                    <cfif len(s_cons)>EVENT_CC_CON,</cfif>
                    <cfif len(s_grps)>EVENT_CC_GRP,</cfif>
                    <cfif len(s_wrkgroup)>EVENT_CC_WRKGROUP,</cfif>
                    <cfif isdefined("attributes.empapp_id") and len(attributes.empapp_id)>EVENT_TO_EMPAPP,</cfif>
                    <cfif len(attributes.warning_start)>WARNING_START,</cfif>
                    IS_INTERNET,
                    IS_GOOGLE_CAL,
                    CREATED_GOOGLE_EVENT_ID,
                    VIEW_TO_ALL,
                    IS_WIEW_BRANCH,
                    IS_WIEW_DEPARTMENT,
                    IS_VIEW_COMPANY,
                    <cfif isDefined("session.agenda_userid")><!--- Baskasinda --->
                        <cfif session.agenda_user_type is "p"><!--- Partner --->
                            RECORD_PAR,
                        <cfelseif session.agenda_user_type is "e"><!--- Employee --->
                            RECORD_EMP,
                        </cfif>
                    <cfelse><!--- Kendinde --->
                        <cfif isdefined("session.ep.userid")>
                            RECORD_EMP,
                        <cfelseif isdefined("session.pp.userid")>
                            RECORD_PAR,
                        </cfif>
                    </cfif>
                    <cfif isdefined("validator") and len(validator)>
                        <cfif isdefined("validator_type") and len(validator_type)>
                            <cfif validator_type eq "employee" or validator_type eq "e">
                                VALIDATOR_POSITION_CODE,
                            <cfelseif validator_type eq "partner" or validator_type eq "p">
                                VALIDATOR_PAR,
                            </cfif>
                        </cfif>
                    <cfelse>
                        <cfif isDefined("session.agenda_userid")><!--- Baskasinda --->
                            <cfif session.agenda_user_type is "e"><!--- Employee --->
                                VALID_EMP,
                                VALID,
                                VALID_DATE,
                            <cfelseif session.agenda_user_type is "p"><!--- Partner --->
                                VALID_PAR_ID,
                                VALID_PAR,
                                VALID_PAR_DATE,
                            </cfif>
                        <cfelse><!--- Kendinde --->
                            <cfif isdefined("session.ep.userid")>
                                VALID_EMP,
                                VALID,
                                VALID_DATE,
                            <cfelseif isdefined("session.pp.userid")>
                                VALID_PAR_ID,
                                VALID_PAR,
                                VALID_PAR_DATE,
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfif isDefined("link_id")>
                        LINK_ID,
                    </cfif>
                    RECORD_IP,
                    RECORD_DATE,
                    WORK_ID,
                    ONLINE_MEET_LINK
                )
                VALUES
                (
                    <cfif isdefined('branch_list') and len(branch_list)>'#branch_list#'<cfelse>NULL</cfif>,
                    #eventcat_id#, 
                    #attributes.startdate#, 
                    #attributes.finishdate#, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.event_head#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.event_detail#">,
                    #attributes.process_stage#, 
                    #attributes.email_alert_day#, 
                    <cfif session.ep.our_company_info.sms eq 1>#attributes.sms_alert_day#<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.event_place") and len(attributes.event_place)>#attributes.event_place#<cfelse>NULL</cfif>,
                    <cfif isDefined("url.project_id")>
                        #url.project_id#,
                    <cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
                        #attributes.project_id#,
                    </cfif>
                    <cfif isdefined("attributes.camp_id") and isdefined("attributes.camp_name")>
                        <cfif len(attributes.camp_id) and len(attributes.camp_name)>#attributes.camp_id#,<cfelse>NULL,</cfif>
                    </cfif>
                    <cfif isdefined("url.opp_id")>#url.opp_id#,</cfif>
                    <cfif isDefined("url.offer_id")>#url.offer_id#,</cfif>
                    <cfif len(j_emps)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#j_emps#,">,</cfif>
                    <cfif len(j_pars)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#j_pars#,">,</cfif>
                    <cfif len(j_cons)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#j_cons#,">,</cfif>
                    <cfif len(j_grps)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#j_grps#,">,</cfif>
                    <cfif len(j_wrkgroup)><cfqueryparam cfsqltype="cf_sql_varchar" value="#j_wrkgroup#">,</cfif>
                    <cfif len(s_emps)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#s_emps#,">,</cfif>
                    <cfif len(s_pars)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#s_pars#,">,</cfif>
                    <cfif len(s_cons)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#s_cons#,">,</cfif>
                    <cfif len(s_grps)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#s_grps#,">,</cfif>
                    <cfif len(s_wrkgroup)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#s_wrkgroup#,">,</cfif>
                    <cfif isdefined("attributes.empapp_id") and len(attributes.empapp_id)>#attributes.empapp_id#,</cfif>
                    <cfif len(attributes.warning_start)>#attributes.warning_start#,</cfif>
                    <cfif isdefined('attributes.is_internet') and attributes.is_internet eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined('attributes.is_google_cal') and attributes.is_google_cal eq 1>1<cfelse>0</cfif>,
                    <cfif isdefined('attributes.googleEventId') and len(attributes.googleEventId)>'#attributes.googleEventId#'<cfelse>0</cfif>,
                    <cfif isDefined("attributes.view_to_all")>
                        1,
                        NULL,
                        NULL,
                        NULL,
                    <cfelseif isDefined("attributes.is_wiew_branch")>
                        0,
                        #attributes.is_wiew_branch#,
                        NULL,
                        NULL,
                    <cfelseif isDefined("attributes.is_wiew_department")>
                        0,
                        NULL,
                        #attributes.is_wiew_department#,
                        NULL,
                    <cfelseif isDefined("attributes.is_view_comp")>
                        0,
                        NULL,
                        NULL,
                        #attributes.is_view_comp#,
                    <cfelse>
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                    </cfif>
                    <cfif isDefined("session.agenda_userid")><!--- Baskasinda --->
                        <!---#session.agenda_userid#, --->
                        <cfif session.agenda_user_type is "p"><!--- Partner --->
                            #session.pp.userid#,
                        <cfelseif session.agenda_user_type is "e"><!--- Employee --->
                            #session.ep.userid#,
                        </cfif>
                    <cfelse><!--- Kendinde --->
                        <cfif isdefined("session.ep.userid")>
                            #session.ep.userid#,
                        <cfelseif isdefined("session.pp.userid")>
                            #session.pp.userid#,
                        </cfif>
                    </cfif>
                    <cfif isdefined("validator") and len(validator)>
                        <cfif isdefined("validator_type") and len(validator_type)>
                            #validator_id#,
                        </cfif>
                    <cfelse>
                        <cfif isDefined("session.agenda_userid")><!--- Baskasinda --->
                            <!---#session.agenda_userid#,--->
                            #session.ep.userid#,
                            1,
                            #now()#,
                        <cfelse><!--- Kendinde --->
                            <cfif isdefined("session.ep.userid")>
                                #session.ep.userid#,
                            <cfelseif isdefined("session.pp.userid")>
                                #session.pp.userid#,
                            </cfif>
                            1,
                            #now()#,
                        </cfif>
                    </cfif>
                    <cfif isDefined("link_id")>
                        #link_id#,
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    #now()#,
                    <cfif isdefined("attributes.work_id") and len(attributes.work_id) and len(attributes.work_head)>#attributes.work_id#<cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.meetLink") and len(attributes.meetLink)>
                        '#attributes.meetLink#'
                    <cfelseif isDefined("attributes.place_online") and len(attributes.place_online) and not len(attributes.meetLink)>
                        '#attributes.place_online#'
                    <cfelse>
                        NULL
                    </cfif>
                )
       </cfquery>
       <cfquery name="GET_LAST_EVENT_ID" datasource="#DSN#">
			SELECT MAX(EVENT_ID) MAX_ID FROM EVENT 
		</cfquery>
    	<!--- olayın yayinlanacagi siteler --->
		<cfif isdefined("attributes.is_internet")>
			<cfquery name="GET_MENU_" datasource="#DSN#">
				SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL AND IS_ACTIVE = 1
			</cfquery>
            <cfoutput query="get_menu_">
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
							#get_last_event_id.max_id#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes['menu_#menu_id#']#">
						)	
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
	</cftransaction>
</cflock>
<cfif isdefined("attributes.action_id") or isdefined("attributes.action_section")>
	<cfset action_id_ = attributes.action_id>
	<cfset action_section_ = attributes.action_section>
<cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfset action_id_ = attributes.project_id>
	<cfset action_section_ = 'PROJECT_ID'>
</cfif>	
<cfif isdefined("action_id_")>
 	<cfquery name="INS_OFFER_PLUS" datasource="#DSN#">
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
			#action_id_#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#action_section_#">,
			#get_last_event_id.max_id#,
		  	<cfif isdefined("session.ep.company_id")>
				#session.ep.company_id#
			<cfelse>
		 		#session.pp.our_company_id#
		  	</cfif>
		)	
	</cfquery>
</cfif>
<cfif isdefined("attributes.agenda_company")>
    <cfloop list="#attributes.agenda_company#" index="cc">
        <cfquery name="ADD_COMP" datasource="#DSN#">
            INSERT INTO EVENT_COMPANY
            (
                EVENT_ID,
                COMPANY_ID
            )
            VALUES
            (
                #get_last_event_id.max_id#,
                #cc#
            )
        </cfquery> 
    </cfloop>
</cfif>
<cfif isdefined("url.project_id") or isdefined("attributes.opp_id") or isdefined("url.offer_id") or isDefined("attributes.is_popup")>
	<script type="text/javascript">
		 wrk_opener_reload();
		 window.close();
	</script>
	<cfabort>
</cfif>
<cfif isDefined("attributes.reserve") and (attributes.reserve eq 1)>
    <script>
        window.location='<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#get_last_event_id.max_id#&reserv=1</cfoutput>';
    </script>
</cfif>

<!--- Çalışan katılımcılara mail gönderme bloğu başlangıç--->
<cfif isdefined('attributes.send_mail_agenda') and len(attributes.send_mail_agenda) and attributes.send_mail_agenda eq 1> 
<!--- kaydet ve mail gönder butonuna tıklandıysa --->
<cfquery name="GET_MAILFROM" datasource="#DSN#">
	SELECT
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_EMAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_EMAIL</cfif>
	FROM		
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEES<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
	WHERE
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"></cfif>
</cfquery>
<cfif GET_MAILFROM.recordcount AND NOT LEN(GET_MAILFROM.EMPLOYEE_EMAIL) and listfindnocase(employee_url,'#cgi.http_host#',';')>
	<cfquery name="GET_MAILFROM" datasource="#dsn#">
		SELECT
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEES_DETAIL.EMAIL_SPC as EMPLOYEE_EMAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_EMAIL</cfif>
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

<!--- Çalışanlara, Bireysel ve Kurumsal üyelere mail gönderme--->
<cfif len(sender)>
  	<cfset list_mail="">
  	<cfset list_name="">
	<cfif listlen(j_emps)>
    	<cfoutput query="emps">
        	<cfif len(emps.employee_email) and emps.type eq 2>
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
        	<cfif len(comps.consumer_email) and comps.type eq 1>
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
			<cfif len(pars.company_partner_email) and pars.type eq 2>
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
    <cfif len(list_mail)>
    <!--- ics dosyası oluşturma --->
        <cfquery name="GET_EVENT" datasource="#DSN#">
        	SELECT EVENT_HEAD, EVENT_DETAIL, RECORD_DATE, EVENT_PLACE_ID FROM EVENT WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_last_event_id.max_id#">
        </cfquery>
		<cfset startdate_ = date_add('h', session.ep.time_zone, attributes.startdate)>
        <cfset finishdate_ = date_add('h', session.ep.time_zone, attributes.finishdate)>
		<cfoutput query="get_event">
			<cfset filename = "event_#get_last_event_id.max_id#.ics">
            <cfset fileRmmbrname="event1_#get_last_event_id.max_id#.ics">
            <!--- calendar dosyasının içeriğini oluşturma kısmı--->
            <cf_wrk_Calendar content_name="vCalendar.content" sender="#sender#" startdate="#startdate_#" finishdate="#finishdate_#" recorddate="#get_event.record_date#" detail="#get_event.event_detail#" summary="#get_event.event_head#" type="0">
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
                <cf_wrk_Calendar content_name="vRemember.content" sender="#sender#" startdate="#startdate_#" finishdate="#finishdate_#" recorddate="#get_event.record_date#" detail="#get_event.event_detail#" summary="#get_event.event_head#" location="#location#" list_mail="#list_mail#" type="1">
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
                <cfset attributes.mail_record_emp='#session.ep.name# #session.ep.surname#'>
                <cfset attributes.mail_record_date=dateformat(dateadd('h',session.ep.time_zone,now()),dateformat_style) & " " & timeformat(dateadd('h',session.ep.time_zone,now()),timeformat_style)>
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
                <cfset attributes.mail_content_link = '#user_domain#/#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#get_last_event_id.max_id#'>
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
				window.location='<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#get_last_event_id.max_id#</cfoutput>';
            </script>
            <cfabort>
        </cfif>
        </cfif>
    <cfelse>
        <script type="text/javascript">
            alert("E-posta Adresiniz Tanımlı Değil, E-posta Gönderemezsiniz!");
			window.location='<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#get_last_event_id.max_id#</cfoutput>';
        </script>
        <cfabort>
    </cfif>
</cfif>