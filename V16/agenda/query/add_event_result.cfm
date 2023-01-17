<cfquery name="control" datasource="#DSN#">
	SELECT EVENT_RESULT_ID FROM EVENT_RESULT WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>
<cfset j_EMPS = "">
<cfset j_PARS = "">
<cfset j_CONS = "">
<cfset j_GRPS = "">
<cfset j_WRKGROUPS = "">
<cfset CC_EMPS = "">
<cfset CC_PARS = "">
<cfset CC_CONS = "">
<cfif not (isdefined("attributes.joins") and isdefined("attributes.specs"))>
	<script type="text/javascript">
		alert("Katılımcı ve Bilgi Verilecekleri Eklemediğiniz için kayıt yapılamadı ve mail gönderilemedi");
	  	history.back();
	</script>
    <cfabort>
<cfelse>
    <cfloop list='#attributes.joins#' index="I">
    	<cfif I CONTAINS "EMP">
			<cfset j_EMPS = LISTAPPEND(j_EMPS,LISTGETAT(I,2,"-"))>
		<cfelseif I CONTAINS "PAR">
			<cfset j_PARS = LISTAPPEND(j_PARS,LISTGETAT(I,2,"-"))>
		<cfelseif I CONTAINS "CON">
			<cfset j_CONS = LISTAPPEND(j_CONS,LISTGETAT(I,2,"-"))>
		<cfelseif I CONTAINS "GRP">
			<cfset j_GRPS = LISTAPPEND(j_GRPS,LISTGETAT(I,2,"-"))>
		<cfelseif I CONTAINS "WRK">
			<cfset j_WRKGROUPS = LISTAPPEND(j_WRKGROUPS,LISTGETAT(I,2,"-"))>
		</cfif>
	</cfloop>
    <cfloop list='#attributes.specs#' index="X">
		<cfif X CONTAINS "EMPCC">
			<cfset CC_EMPS = LISTAPPEND(CC_EMPS,LISTGETAT(X,2,"-"))>
		<cfelseif X CONTAINS "PARCC">
			<cfset CC_PARS = LISTAPPEND(CC_PARS,LISTGETAT(X,2,"-"))>
		<cfelseif X CONTAINS "CONCC">
			<cfset CC_CONS = LISTAPPEND(CC_CONS,LISTGETAT(X,2,"-"))>
		</cfif>
	</cfloop> 
	<cfif IsDefined('form.to_emp_ids') and len(form.to_emp_ids)>
		<cfloop list='#form.to_emp_ids#' index="I">
			<cfset j_EMPS = LISTAPPEND(j_EMPS,I)>
		</cfloop> 
	</cfif>
	<cfif IsDefined('form.to_par_ids') and len(form.to_par_ids)>
		<cfloop list='#form.to_par_ids#' index="I">
			<cfset j_PARS = LISTAPPEND(j_PARS,I)>
		</cfloop> 
	</cfif>
	<cfif IsDefined('form.to_cons_ids') and len(form.to_cons_ids)>
		<cfloop list='#form.to_cons_ids#' index="I">
			<cfset j_CONS = LISTAPPEND(j_CONS,I)>
		</cfloop> 
	</cfif>
	<cfif IsDefined('form.to_wgrp_ids') and len(form.to_wgrp_ids)>
		<cfloop list='#form.to_wgrp_ids#' index="I">
			<cfset j_WRKGROUPS = LISTAPPEND(j_WRKGROUPS,I)>
		</cfloop> 
	</cfif>
	<cfif IsDefined('form.cc_emp_ids') and len(form.cc_emp_ids)>
		<cfloop list='#form.cc_emp_ids#' index="X">
			<cfset CC_EMPS = LISTAPPEND(CC_EMPS,X)>
		</cfloop> 
	</cfif>
	<cfif IsDefined('form.cc_par_ids') and len(form.cc_par_ids)>
		<cfloop list='#form.cc_par_ids#' index="X">
			<cfset CC_PARS = LISTAPPEND(CC_PARS,X)>
		</cfloop> 
	</cfif>
	<cfif IsDefined('form.cc_cons_ids') and len(form.cc_cons_ids)>
		<cfloop list='#form.cc_cons_ids#' index="X">
			<cfset CC_CONS = LISTAPPEND(CC_CONS,X)>
		</cfloop> 
	</cfif>
	<cfif isdefined("email") and (email eq 'true')>
        <cfif len(J_EMPS) or len(J_PARS) or len(j_CONS) or len(j_GRPS) or len(j_WRKGROUPS)>
            <cfquery name="GET_MAILTO" datasource="#dsn#">
                <cfif len(j_EMPS)>
                    SELECT
                        EMPLOYEE_EMAIL AS EMAIL
                    FROM		
                        EMPLOYEE_POSITIONS		
                    WHERE
                        EMPLOYEE_ID IN (#j_EMPS#)
                        AND IS_MASTER=1
                        AND EMPLOYEE_EMAIL != ''
                        AND EMPLOYEE_EMAIL IS NOT NULL
                </cfif>
                <cfif len(j_PARS)>
                    <cfif  len(j_EMPS)>
                    UNION ALL
                    </cfif>				
                    SELECT
                        COMPANY_PARTNER_EMAIL AS EMAIL
                    FROM		
                        COMPANY_PARTNER
                    WHERE
                        PARTNER_ID IN (#j_PARS#)
                        AND COMPANY_PARTNER_EMAIL!=''
                        AND COMPANY_PARTNER_EMAIL IS NOT NULL
                </cfif>
                <cfif len(j_CONS)>
                    <cfif len(j_PARS) OR len(j_EMPS)>
                    UNION ALL
                    </cfif>				
                    (SELECT
                        CONSUMER_EMAIL AS EMAIL
                    FROM		
                        CONSUMER
                    WHERE
                        CONSUMER_ID IN (#j_CONS#)
                        AND CONSUMER_EMAIL!=''
                        AND CONSUMER_EMAIL IS NOT NULL
                    )
                </cfif>
                <cfif  len(j_GRPS)>
                    <cfif  len(j_PARS) or len(j_EMPS) or len(j_CONS)>
                    UNION ALL
                    </cfif>				
                    SELECT
                        EMPLOYEE_EMAIL AS EMAIL
                    FROM		
                        EMPLOYEE_POSITIONS
                    WHERE
                        EMPLOYEE_EMAIL != ''
                    AND		
                        <cfif len(LISTSORT(GET_ALL_IDS.POSITIONS,"NUMERIC"))>
                            POSITION_ID IN (#LISTSORT(GET_ALL_IDS.POSITIONS,"NUMERIC")#)
                        <cfelse>
                            POSITION_ID = 0
                        </cfif>
                    
                    UNION ALL
                    SELECT
                        COMPANY_PARTNER_EMAIL AS EMAIL
                    FROM		
                        COMPANY_PARTNER
                    WHERE
                        COMPANY_PARTNER_EMAIL != ''
                    AND		
                        <cfif LEN(LISTSORT(GET_ALL_IDS.POSITIONS,"NUMERIC"))>
                            PARTNER_ID IN (#LISTSORT(GET_ALL_IDS.PARTNERS,"NUMERIC")#)
                        <cfelse>
                            PARTNER_ID = 0
                        </cfif>		
                    
                    UNION ALL
                    SELECT
                        CONSUMER_EMAIL AS EMAIL
                    FROM		
                        CONSUMER
                    WHERE
                        CONSUMER_EMAIL != ''
                    AND		
                        <cfif len(LISTSORT(GET_ALL_IDS.POSITIONS,"NUMERIC"))>
                            CONSUMER_ID IN (#LISTSORT(GET_ALL_IDS.CONSUMERS,"NUMERIC")#)
                        <cfelse>
                            CONSUMER_ID = 0
                        </cfif>		
                </cfif>
                <cfif len(j_WRKGROUPS)>
                    <cfif  len(j_PARS) or len(j_EMPS) or len(j_CONS) or len(j_GRPS)>
                    UNION ALL
                    </cfif>				
                    SELECT
                        EMPLOYEE_EMAIL AS EMAIL
                    FROM		
                        EMPLOYEE_POSITIONS
                    WHERE
                        EMPLOYEE_EMAIL != ''
                    AND		
                        POSITION_ID IN (SELECT
                                            WEP.POSITION_CODE
                                        FROM		
                                            WORK_GROUP AS WG ,
                                            WORKGROUP_EMP_PAR AS WEP
                                        WHERE
                                            WEP.POSITION_CODE IS NOT NULL AND
                                            WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND	
                                            WEP.WORKGROUP_ID = #j_WRKGROUPS#
                                        )		
                    
                    UNION ALL
                    SELECT
                        COMPANY_PARTNER_EMAIL AS EMAIL
                    FROM		
                        COMPANY_PARTNER
                    WHERE
                        COMPANY_PARTNER_EMAIL != ''
                    AND
                        PARTNER_ID IN (SELECT
                                            WEP.PARTNER_ID
                                        FROM		
                                            WORK_GROUP AS WG ,
                                            WORKGROUP_EMP_PAR AS WEP
                                        WHERE
                                            WEP.PARTNER_ID IS NOT NULL AND
                                            WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND	
                                            WEP.WORKGROUP_ID = #j_WRKGROUPS#
                                      )	
                </cfif>							 
            </cfquery>
         <cfelse>
            <cfset get_mailto.recordcount=0>
        </cfif>
        <cfif len(CC_EMPS) or len(CC_PARS) or len(CC_CONS)>
            <cfquery name="GET_MAILCC" datasource="#dsn#">
                <cfif len(CC_EMPS)>
                    SELECT EMPLOYEE_EMAIL AS EMAIL FROM	EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IN (#CC_EMPS#) AND IS_MASTER = 1 AND EMPLOYEE_EMAIL!='' AND EMPLOYEE_EMAIL IS NOT NULL
                </cfif>
                <cfif len(CC_PARS)>
                    <cfif  len(CC_EMPS)>
                    UNION ALL
                    </cfif>				
                    SELECT COMPANY_PARTNER_EMAIL AS EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#CC_PARS#) AND COMPANY_PARTNER_EMAIL!='' AND COMPANY_PARTNER_EMAIL IS NOT NULL
                </cfif>
                <cfif  len(CC_CONS)>
                    <cfif len(CC_PARS) OR len(CC_EMPS)>
                    UNION ALL
                    </cfif>				
                    SELECT CONSUMER_EMAIL AS EMAIL FROM CONSUMER WHERE CONSUMER_ID IN (#CC_CONS#) AND CONSUMER_EMAIL!='' AND CONSUMER_EMAIL IS NOT NULL
                </cfif> 
            </cfquery>
        <cfelse>
            <cfset get_mailcc.recordcount=0>
        </cfif>
        <cfif (get_mailto.recordcount eq 0) and (get_mailcc.recordcount eq 0)>
			<script type="text/javascript">
				alert("<cf_get_lang no ='96.Ya Katılımcı Seçmediniz ya da Seçtiğiniz Katılımcıların Mail Adresleri Yok'>");
				history.back();
            </script>
            <cfabort>
		</cfif>
    </cfif>       
	<cfset s_EMPS = "">
	<cfset s_PARS = "">
	<cfset s_CONS = "">
	<cfset s_GRPS = "">
	<cfset cmps="">
	<cfif len(j_pars)>
		<cfloop list="#j_pars#" index="i">
			<cfquery name="GET_CMP" datasource="#dsn#">
				SELECT
					*
				FROM
					COMPANY,
					COMPANY_PARTNER
				WHERE
					COMPANY.COMPANY_ID=COMPANY_PARTNER.COMPANY_ID AND
					COMPANY_PARTNER.PARTNER_ID=#I#
			</cfquery>
			<cfif not listfind(cmps,get_cmp.COMPANY_ID)>
				<cfset cmps=listappend(cmps,get_cmp.company_id)>
			</cfif>
		</cfloop>
	</cfif>
	<cfquery name="GET_CAT" datasource="#DSN#">
		SELECT EVENTCAT_ID, EVENT_HEAD, PROJECT_ID, STARTDATE, FINISHDATE, DATEDIFF(minute, STARTDATE, FINISHDATE) AS DIFFDATE FROM EVENT WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
	</cfquery>
    <cfquery name="get_hourly_salary" datasource="#DSN#">
        SELECT ISNULL(ON_MALIYET,0) ON_MALIYET, ISNULL(ON_HOUR,0) ON_HOUR FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
    </cfquery>
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
    <cfif get_hourly_salary.recordcount and get_hourly_salary.on_maliyet eq 0 or get_hourly_salary.on_hour eq  0>
        <cfset salary_minute = 0>
    <cfelse>
        <cfset salary_minute = get_hourly_salary.on_maliyet / get_hourly_salary.on_hour / 60>
    </cfif>
    <cfset total_min = GET_CAT.DIFFDATE>

	<cftransaction>
        <cfif NOT LEN(control.EVENT_RESULT_ID)>
            <cfquery name="add_event_result" datasource="#DSN#">
                INSERT INTO
                EVENT_RESULT
                (
                    EVENT_ID,
                    LOCKED,
                    EVENT_RESULT
                    <cfif len(j_EMPS)>,EVENT_RESULT_EMP</cfif>
                    <cfif len(j_PARS)>,EVENT_RESULT_PARTNER</cfif>
                    <cfif len(j_CONS)>,EVENT_RESULT_CONS</cfif>
                    <cfif len(j_WRKGROUPS)>,EVENT_RESULT_WRKGROUP</cfif>
                    <cfif len(CC_EMPS)>,EVENT_RESULT_CC_EMP</cfif>
                    <cfif len(CC_PARS)>,EVENT_RESULT_CC_PARTNER</cfif>
                    <cfif len(CC_CONS)>,EVENT_RESULT_CC_CONS</cfif>
                    ,RECORD_EMP
                    ,RECORD_IP
                    ,RECORD_DATE
                )
                VALUES(
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">,
                    <cfif isdefined("attributes.locked")>1,<cfelse>0,</cfif>
                    '#RESULT#'
                    <cfif len(j_EMPS)>,'#J_EMPS#'</cfif>
                    <cfif len(j_PARS)>,'#J_PARS#'</cfif>
                    <cfif len(j_CONS)>,'#J_CONS#'</cfif>
                    <cfif len(j_WRKGROUPS)>,'#j_WRKGROUPS#'</cfif>
                    <cfif len(CC_EMPS)>,'#CC_EMPS#'</cfif>
                    <cfif len(CC_PARS)>,'#CC_PARS#'</cfif>
                    <cfif len(CC_CONS)>,'#CC_CONS#'</cfif>
                    ,#SESSION.EP.USERID#
                    ,'#CGI.REMOTE_ADDR#'
                    ,#NOW()#
                )
            </cfquery>
        <cfelseif len(control.EVENT_RESULT_ID)>
            <cfquery name="UPD_EVENT_RESULT" datasource="#DSN#">
                UPDATE
                    EVENT_RESULT
                SET
                    LOCKED = <cfif isdefined("attributes.locked")>1,<cfelse>0,</cfif>
                    EVENT_RESULT = '#RESULT#'
                    <cfif len(j_EMPS)>,EVENT_RESULT_EMP = '#j_EMPS#'<cfelse>,EVENT_RESULT_EMP =''</cfif>
                    <cfif len(j_PARS)>,EVENT_RESULT_PARTNER = '#j_PARS#'<cfelse>,EVENT_RESULT_PARTNER =''</cfif>
                    <cfif len(j_CONS)>,EVENT_RESULT_CONS = '#j_CONS#'<cfelse>,EVENT_RESULT_CONS =''</cfif>
                    <cfif len(j_WRKGROUPS)>,EVENT_RESULT_WRKGROUP = '#j_WRKGROUPS#'<cfelse>,EVENT_RESULT_WRKGROUP =''</cfif>
                    <cfif len(CC_EMPS)>,EVENT_RESULT_CC_EMP = '#CC_EMPS#'<cfelse>,EVENT_RESULT_CC_EMP =''</cfif>
                    <cfif len(CC_PARS)>,EVENT_RESULT_CC_PARTNER = '#CC_PARS#'<cfelse>,EVENT_RESULT_CC_PARTNER =''</cfif>
                    <cfif len(CC_CONS)>,EVENT_RESULT_CC_CONS = '#CC_CONS#'<cfelse>,EVENT_RESULT_CC_CONS =''</cfif>
                    ,UPDATE_EMP = #SESSION.EP.USERID#
                    ,UPDATE_IP = '#CGI.REMOTE_ADDR#'
                    ,UPDATE_DATE = #now()#
                WHERE
                    EVENT_ID = <cfqueryparam value = "#attributes.event_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
            <cfquery name="DEL_TIME_COST" datasource="#dsn#">
                DELETE FROM TIME_COST WHERE EVENT_ID = <cfqueryparam value = "#attributes.event_id#" CFSQLType = "cf_sql_integer">
            </cfquery>
        </cfif>

        <!--- 
            Author: Uğur Hamurpet 
            Desc: Toplantı tutanak kaydından sonra zaman harcaması eklenir
            Date: 27/02/2021
        --->
        <cfif GET_CAT.DIFFDATE > 0 and len(j_EMPS)>
            <cfloop list="#j_EMPS#" index="emp_id">
                <cfquery name="get_employee" datasource="#dsn#">
                    SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #emp_id#
                </cfquery>
                <cfif get_employee.recordcount>
                    <cfquery name="ADD_TIME_COST" datasource="#dsn#">
                        INSERT INTO
                            TIME_COST(
                                OUR_COMPANY_ID,
                                TOTAL_TIME,
                                EXPENSED_MONEY,
                                EXPENSED_MINUTE,
                                EMPLOYEE_ID,
                                EMPLOYEE_NAME,
                                EVENT_DATE,
                                COMMENT,
                                TIME_COST_STAGE,
                                EVENT_ID,
                                PROJECT_ID,
                                RECORD_DATE,
                                RECORD_IP,
                                RECORD_EMP
                            )
                            VALUES
                            (
                                #session.ep.company_id#,
                                #TOTAL_MIN / 60#,
                                #round( salary_minute * total_min )#,
                                #TOTAL_MIN#,
                                #emp_id#,
                                '#get_employee.EMPLOYEE_NAME# #get_employee.EMPLOYEE_SURNAME#',
                                #now()#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CAT.EVENT_HEAD#">,
                                <cfif isdefined('get_process_stage.process_row_id') and len(get_process_stage.process_row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#"><cfelse>NULL</cfif>,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.event_id#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CAT.PROJECT_ID#">,
                                #now()#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                #session.ep.userid#
                            )
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>
    </cftransaction>

	<cfif isdefined("email") and (email eq 'true')>
        <cfquery name="GET_MAILFROM" datasource="#dsn#">
            SELECT
                <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_NAME NAME_,EMPLOYEE_SURNAME SURNAME_,EMPLOYEE_EMAIL EMAIL_<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_NAME NAME_,COMPANY_PARTNER_SURNAME NAME_,COMPANY_PARTNER_EMAIL EMAIL_</cfif>
            FROM		
                <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_POSITIONS<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
            WHERE
                <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                    EMPLOYEE_ID=#session.ep.USERID#
                <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                    PARTNER_ID=#session.pp.USERID#
                </cfif>
        </cfquery>
        <cfif GET_MAILFROM.RECORDCOUNT>
            <cfset sender = "#GET_MAILFROM.NAME_# #GET_MAILFROM.SURNAME_#<#GET_MAILFROM.EMAIL_#>">
        </cfif>
		<!---katılımcı yok --->
        <cfif get_mailto.recordcount>
			<cfset to_list=ValueList(get_mailto.email,',')>
            <cfset to_add=to_list>
        <cfelse>
        	<cfset to_list=sender>
            <cfset to_add=''>
		</cfif>
        <!---bilgi verecekler yok --->
        <cfif  get_mailcc.recordcount>
        	<cfset cc_list=ValueList(get_mailcc.email,',')>
		<cfelse>
        	<cfset cc_list=''>
		</cfif>
        <cfsavecontent variable="css">
            <style type="text/css">
                .color-header{background-color: ##a7caed;}
                .color-border	{background-color:##6699cc;}
                .color-row{	background-color: ##f1f0ff;}
                .label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
            </style>
        </cfsavecontent>
		<cfoutput>#css#</cfoutput>
        <cftry>
            <cfmail 
                from = "#sender#"
                to = "#to_list#"
                cc="#cc_list#"
                subject = "Olay Tutanağı" type="HTML">
                    #css#
                    Olay Başlığı : #attributes.header#<br />
                    Katılımcılar :#to_add#<br />
                    Tarih :  #dateformat(date_add('h',session.ep.time_zone,now()),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,now()),timeformat_style)#)<br />	
                    <hr>
                    <br />  
                    #attributes.RESULT#
            </cfmail>
            <cfset attributes.from = sender>
            <cfset attributes.cc_list="#cc_list#">
            <cfset attributes.body="#css##attributes.result#">
            <cfset attributes.to_list="#to_list#">
            <cfset attributes.type=0>
            <cfset attributes.module="agenda">
            <cfset attributes.subject="Olay Tutanağı">
            <cfinclude template="../../objects/query/add_mail.cfm">
            <cfcatch type="any">
                    <table height="100%" width="100%" cellspacing="0" cellpadding="0">
                        <tr class="color-border">
                            <td valign="top"> 
                                <table height="100%" width="100%" cellspacing="1" cellpadding="2">
                                    <tr class="color-list">
                                        <td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td align="center" class="headbold">Tutanak Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <cfabort>
                </cfcatch>
            </cftry>
        <table height="100%" width="100%" cellspacing="0" cellpadding="0">
            <tr class="color-border">
                <td valign="top"> 
                    <table height="100%" width="100%" cellspacing="1" cellpadding="2">
                        <tr class="color-list">
                            <td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
                        </tr>
                        <tr class="color-row">
                            <td align="center" class="headbold">Mail Başarıyla Gönderildi</td>
                        </tr>
                    </table>
                </td>
            </tr>
         </table>
    </cfif>
	<cfif (isdefined("get_mailto") and get_mailto.recordcount) or (isdefined("get_mailcc") and get_mailcc.recordcount)>
        <script type="text/javascript">
            function waitfor()
			{
              window.close();
            }
            setTimeout("waitfor()",2000); 		
        </script>
        <cfabort>
	<cfelse>
        <script type="text/javascript">
             window.close();
        </script>
         <cfabort>
    </cfif>
</cfif>
