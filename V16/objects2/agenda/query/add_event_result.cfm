<cfquery name="CONTROL" datasource="#DSN#">
	SELECT EVENT_RESULT_ID FROM EVENT_RESULT WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>
<cfset j_emps = "">
<cfset j_pars = "">
<cfset j_cons = "">
<cfset j_grps = "">
<cfset j_wrkgroups = "">
<cfset cc_emps = "">
<cfset cc_pars = "">
<cfset cc_cons = "">

<cfif not isdefined('session.agenda.event#form.event_id#.joinss') and not isdefined('session.agenda.event#form.event_id#.specss')>
	<script type="text/javascript">
		wrk_opener_reload();
		alert("<cf_get_lang_main no='1621.Katılımcı ve Bilgi Verilecekleri Eklemediğiniz için kayıt yapılamadı ve Mail Gönderilemedi'>");
	  	window.close();
	</script>
<cfelse>
	<cfloop list='#Evaluate("session.agenda.event#form.event_id#.joinss")#' index="i">
		<cfif i contains "emp">
			<cfset j_emps = listappend(j_emps,listgetat(i,2,"-"))>
		<cfelseif i contains "par">
			<cfset j_pars = listappend(j_pars,listgetat(i,2,"-"))>
		<cfelseif i contains "con">
			<cfset j_cons = listappend(j_cons,listgetat(i,2,"-"))>
		<cfelseif i contains "grp">
			<cfset j_grps = listappend(j_grps,listgetat(i,2,"-"))>
		<cfelseif i contains "wrk">
			<cfset j_wrkgroups = listappend(j_wrkgroups,listgetat(i,2,"-"))>
		</cfif>
	</cfloop>  
	
	<cfloop list='#evaluate("session.agenda.event#form.event_id#.specss")#' index="x">
		<cfif x contains "empcc">
			<cfset cc_emps = listappend(cc_emps,listgetat(x,2,"-"))>
		<cfelseif x contains "parcc">
			<cfset cc_pars = listappend(cc_pars,listgetat(x,2,"-"))>
		<cfelseif x contains "concc">
			<cfset cc_cons = listappend(cc_cons,listgetat(x,2,"-"))>
		</cfif>
	</cfloop> 
	
	<cfif IsDefined('form.to_emp_ids') and len(form.to_emp_ids)>
        <cfloop list='#form.to_emp_ids#' index="i">
			<cfset j_emps = listappend(j_emps,i)>
        </cfloop> 
	</cfif>
	
	<cfif IsDefined('form.to_par_ids') and len(form.to_par_ids)>
        <cfloop list='#form.to_par_ids#' index="i">
			<cfset j_pars = listappend(j_pars,i)>
        </cfloop> 
	</cfif>
	
	<cfif IsDefined('form.to_cons_ids') and len(form.to_cons_ids)>
        <cfloop list='#form.to_cons_ids#' index="i">
			<cfset j_cons = listappend(j_cons,i)>
        </cfloop> 
	</cfif>
	
	<cfif IsDefined('form.to_wgrp_ids') and len(form.to_wgrp_ids)>
        <cfloop list='#form.to_wgrp_ids#' index="i">
			<cfset j_wrkgroups = listappend(j_wrkgroups,i)>
        </cfloop> 
	</cfif>
	
	<cfif IsDefined('form.cc_emp_ids') and len(form.cc_emp_ids)>
        <cfloop list='#form.cc_emp_ids#' index="x">
			<cfset cc_emps = listappend(cc_emps,x)>
        </cfloop> 
	</cfif>
	
	<cfif IsDefined('form.cc_par_ids') and len(form.cc_par_ids)>
        <cfloop list='#form.cc_par_ids#' index="x">
			<cfset cc_pars = listappend(cc_pars,x)>
        </cfloop> 
	</cfif>
	
	<cfif IsDefined('form.cc_cons_ids') and len(form.cc_cons_ids)>
        <cfloop list='#form.cc_cons_ids#' index="x">
			<cfset cc_cons = listappend(cc_cons,x)>
        </cfloop> 
	</cfif>
	
	<cfset s_emps = "">
	<cfset s_pars = "">
	<cfset s_cons = "">
	<cfset s_grps = "">
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
					COMPANY.COMPANY_ID=COMPANY_PARTNER.COMPANY_ID AND
					COMPANY_PARTNER.PARTNER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
			</cfquery>
			<cfif not listfind(cmps,get_cmp.company_id)>
				<cfset cmps=listappend(cmps,get_cmp.company_id)>
			</cfif>
		</cfloop>
	</cfif>

	<cfquery name="GET_CAT" datasource="#DSN#">
		SELECT EVENTCAT_ID FROM EVENT WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
	</cfquery>
	<cfif not len(control.event_result_id)>
		<cfquery name="ADD_EVENT_RESULT" datasource="#DSN#">
			INSERT INTO
				EVENT_RESULT
				(
				   EVENT_ID,
				   EVENT_RESULT
				   <cfif len(j_emps)>,EVENT_RESULT_EMP</cfif>
				   <cfif len(j_pars)>,EVENT_RESULT_PARTNER</cfif>
				   <cfif len(j_cons)>,EVENT_RESULT_CONS</cfif>
				   <cfif len(j_wrkgroups)>,EVENT_RESULT_WRKGROUP</cfif>
				   <cfif len(cc_emps)>,EVENT_RESULT_CC_EMP</cfif>
				   <cfif len(cc_pars)>,EVENT_RESULT_CC_PARTNER</cfif>
				   <cfif len(cc_cons)>,EVENT_RESULT_CC_CONS</cfif>
				   ,RECORD_EMP
				   ,RECORD_IP
				   ,RECORD_DATE
			 	)
			 	VALUES
				(			   
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">,
				   '#result#'
				   <cfif len(j_emps)>,'#j_emps#'</cfif>
				   <cfif len(j_pars)>,'#j_pars#'</cfif>
				   <cfif len(j_cons)>,'#j_cons#'</cfif>
				   <cfif len(j_wrkgroups)>,'#j_wrkgroups#'</cfif>
				   <cfif len(cc_emps)>,'#cc_emps#'</cfif>
				   <cfif len(cc_pars)>,'#cc_pars#'</cfif>
				   <cfif len(cc_cons)>,'#cc_cons#'</cfif>
				   ,#session_base.userid#
				   ,'#CGI.REMOTE_ADDR#'
				   ,#NOW()#	
			 	)
		</cfquery>
	<cfelseif len(control.event_result_id)>
		<cfquery name="UPD_EVENT_RESULT" datasource="#DSN#">
			UPDATE
				EVENT_RESULT
			SET
				EVENT_RESULT = '#result#'
				<cfif len(j_emps)>,EVENT_RESULT_EMP = '#j_emps#'<cfelse>,EVENT_RESULT_EMP =''</cfif>
				<cfif len(j_pars)>,EVENT_RESULT_PARTNER = '#j_pars#'<cfelse>,EVENT_RESULT_PARTNER =''</cfif>
				<cfif len(j_cons)>,EVENT_RESULT_CONS = '#j_cons#'<cfelse>,EVENT_RESULT_CONS =''</cfif>
				<cfif len(j_wrkgroups)>,EVENT_RESULT_WRKGROUP = '#j_wrkgroups#'<cfelse>,EVENT_RESULT_WRKGROUP =''</cfif>
				<cfif len(cc_emps)>,EVENT_RESULT_CC_EMP = '#cc_emps#'<cfelse>,EVENT_RESULT_CC_EMP =''</cfif>
				<cfif len(cc_pars)>,EVENT_RESULT_CC_PARTNER = '#cc_pars#'<cfelse>,EVENT_RESULT_CC_PARTNER =''</cfif>
				<cfif len(cc_cons)>,EVENT_RESULT_CC_CONS = '#cc_cons#'<cfelse>,EVENT_RESULT_CC_CONS =''</cfif>
				,UPDATE_EMP = #session_base.userid#
				,UPDATE_IP = '#CGI.REMOTE_ADDR#'
				,UPDATE_DATE = #now()#
	
			WHERE
				EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
		</cfquery>
	</cfif>
	<cfif isDefined("attributes.is_email") and attributes.is_email eq 1>
		<cfif len(j_emps) or len(j_pars) or len(j_cons) or len(j_grps) or len(j_wrkgroups)>
			<cfquery name="GET_MAILTO" datasource="#DSN#">
				<cfif len(j_emps)>
					SELECT EMPLOYEE_EMAIL AS EMAIL FROM	EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IN (#j_emps#) AND  IS_MASTER = 1
				</cfif>
				<cfif len(j_pars)>
					<cfif  len(j_emps)>
						UNION ALL
					</cfif>				
					SELECT COMPANY_PARTNER_EMAIL AS EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#j_PARS#)
				</cfif>
				<cfif len(j_cons)>
					<cfif len(j_pars) or len(j_emps)>
						UNION ALL
					</cfif>				
					(SELECT CONSUMER_EMAIL AS EMAIL FROM CONSUMER WHERE CONSUMER_ID IN (#j_cons#))
				</cfif>
				<cfif  len(j_grps)>
					<cfif len(j_pars) or len(j_emps) or len(j_cons)>
						UNION ALL
					</cfif>				
					SELECT
						EMPLOYEE_EMAIL AS EMAIL
					FROM		
						EMPLOYEE_POSITIONS
					WHERE
						EMPLOYEE_EMAIL <> ''
					AND		
						<cfif len(listsort(get_all_ids.positions,"numeric"))>
							POSITION_ID IN (#listsort(get_all_ids.positions,"numeric")#)
						<cfelse>
							POSITION_ID = 0
						</cfif>			
					UNION ALL
					SELECT
						COMPANY_PARTNER_EMAIL AS EMAIL
					FROM		
						COMPANY_PARTNER
					WHERE
						COMPANY_PARTNER_EMAIL <> ''
					AND		
						<cfif len(listsort(get_all_ids.positions,"numeric"))>
							PARTNER_ID IN (#listsort(get_all_ids.partners,"numeric")#)
						<cfelse>
							PARTNER_ID = 0
						</cfif>		
					
					UNION ALL
					SELECT
						CONSUMER_EMAIL AS EMAIL
					FROM		
						CONSUMER
					WHERE
						CONSUMER_EMAIL <> ''
					AND		
						<cfif len(listsort(get_all_ids.positions,"numeric"))>
							CONSUMER_ID IN (#listsort(get_all_ids.consumers,"numeric")#)
						<cfelse>
							CONSUMER_ID = 0
						</cfif>		
									
				</cfif>
				<cfif len(j_wrkgroups)>
					<cfif len(j_pars) or len(j_emps) or len(j_cons) or len(j_grps)>
						UNION ALL
					</cfif>				
					SELECT
						EMPLOYEE_EMAIL AS EMAIL
					FROM		
						EMPLOYEE_POSITIONS
					WHERE
						EMPLOYEE_EMAIL <> ''
					AND		
						POSITION_ID IN (SELECT
											WEP.POSITION_CODE
										FROM		
											WORK_GROUP AS WG ,
											WORKGROUP_EMP_PAR AS WEP
										WHERE
											WEP.POSITION_CODE IS NOT NULL AND
											WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND	
											WEP.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#j_wrkgroups#">
										)		
					
					UNION ALL
					SELECT
						COMPANY_PARTNER_EMAIL AS EMAIL
					FROM		
						COMPANY_PARTNER
					WHERE
						COMPANY_PARTNER_EMAIL <> ''
					AND
						PARTNER_ID IN (SELECT
											WEP.PARTNER_ID
										FROM		
											WORK_GROUP AS WG ,
											WORKGROUP_EMP_PAR AS WEP
										WHERE
											WEP.PARTNER_ID IS NOT NULL AND
											WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND	
											WEP.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#j_wrkgroups#">
									  )	
				</cfif>							 
			</cfquery>
			<cfquery name="GET_MAILFROM" datasource="#DSN#">
				SELECT
					<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_EMAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_EMAIL</cfif>
				FROM		
					<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_POSITIONS<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
				WHERE
					<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
						EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
						PARTNER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
					</cfif>
			</cfquery>
            
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
				<cfset sender = "#get_mailfrom.employee_email#">
			<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
				<cfset sender = "#get_mailfrom.company_partner_email#">
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
					to = "#ValueList(get_mailto.email,',')#"
					from = "#sender#"
					subject = "<cf_get_lang_main no='179.Olay Tutanağı'>" type="HTML">
						#css#
						Olay Başlığı : #attributes.header#<br>
						Katılımcılar : #ValueList(get_mailto.email,',')#<br>
						Tarih :  #dateformat(date_add('h',session.pp.time_zone,now()),'dd/mm/yyyy')# (#timeformat(date_add('h',session.pp.time_zone,now()),'HH:MM')#)	  <br>	
						<hr>
						<br>
						#attributes.result#
				</cfmail>
				<cfset attributes.body="#css##attributes.result#">
				<cfset attributes.to="#ValueList(get_mailto.email,',')#">
				<cfset attributes.type=0>
				<cfset attributes.module="agenda">
				<cfset attributes.subject="Olay Tutanağı">
				<cfinclude template="add_mail.cfm">
				<table cellspacing="0" cellpadding="0" style="width:100%; height:100%;">
					<tr class="color-border">
						<td style="vertical-align:top;"> 
							<table cellspacing="1" cellpadding="2" style="width:100%; height:100%;">
								<tr class="color-list" style="height:35px;">
									<td class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
								</tr>
								<tr class="color-row">
									<td align="center" class="headbold"><cf_get_lang_main no='101.Mail Başarıyla Gönderildi'></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<cfcatch type="any">
					<table cellspacing="0" cellpadding="0" style="width:100%; height:100%;">
						<tr class="color-border">
							<td style="vertical-align:top;"> 
								<table cellspacing="1" cellpadding="2" style="width:100%; height:100%;">
									<tr class="color-list" style="height:35px;">
										<td class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
									</tr>
									<tr class="color-row">
										<td align="center" class="headbold"><cf_get_lang no='1622.Tutanak Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</cfcatch>
			</cftry>
		</cfif>
		<!--- Bilgi verileceklere mail gidecek --->
		<cfif len(cc_emps) or len(cc_pars) or len(cc_cons)>
			<cfquery name="GET_MAILCC" datasource="#DSN#">
				<cfif len(cc_emps)>
                    SELECT EMPLOYEE_EMAIL AS EMAIL FROM	EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IN (#cc_emps#) AND IS_MASTER = 1
                </cfif>
                <cfif len(cc_pars)>
                    <cfif  len(cc_pars)>
                        UNION ALL
                    </cfif>				
                    SELECT COMPANY_PARTNER_EMAIL AS EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#cc_pars#)
                </cfif>
                <cfif len(cc_cons)>
                    <cfif len(cc_pars) OR len(cc_emps)>
                        UNION ALL
                    </cfif>				
                    SELECT CONSUMER_EMAIL AS EMAIL FROM CONSUMER WHERE CONSUMER_ID IN (#cc_cons#)
                </cfif> 
            </cfquery>
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
                    to = "#ValueList(get_mailcc.email,',')#"
                    from = "#session.ep.company#<#session.ep.company_email#>"
                    subject = "<cf_get_lang_main no='179.Olay Tutanağı'>" type="HTML">
                        #css#
                        Olay Başlığı : #attributes.header#<br>
                        Katılımcılar : #ValueList(get_mailcc.email,',')#<br>
                        Tarih :  #dateformat(date_add('h',session.pp.time_zone,now()),'dd/mm/yyyy')# (#timeformat(date_add('h',session.pp.time_zone,now()),'HH:MM')#)	  <br>	
                        <hr>
                        <br>  
                        #attributes.result#
                </cfmail>
                <cfset attributes.body="#css##attributes.result#">
                <cfset attributes.to="#ValueList(get_mailcc.email,',')#">
                <cfset attributes.type=0>
                <cfset attributes.module="agenda">
                <cfset attributes.subject="Olay Tutanağı">
                <cfinclude template="add_mail.cfm">
                <table cellspacing="0" cellpadding="0" style="width:100%; height:100%;">
                    <tr class="color-border">
                        <td style="vertical-align:top;"> 
                            <table cellspacing="1" cellpadding="2" style="width:100%; height:100%;">
                                <tr class="color-list" style="height:35px;">
                                    <td class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
                                </tr>
                                <tr class="color-row">
                                    <td align="center" class="headbold"><cf_get_lang_main no='101.Mail Başarıyla Gönderildi'></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <cfcatch type="any">
                    <table cellspacing="0" cellpadding="0" style="width:100%; height:100%;">
                        <tr class="color-border">
                            <td style="vertical-align:top;"> 
                                <table cellspacing="1" cellpadding="2" style="width:100%; height:100%;">
                                    <tr class="color-list" style="height:35px;">
                                        <td class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
                                    </tr>
                                    <tr class="color-row">
                                        <td align="center" class="headbold"><cf_get_lang no='1622.Tutanak Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </cfcatch>
            </cftry>
		</cfif>
		<cfif (isdefined("get_mailto") and get_mailto.recordcount) or (isdefined("get_mailcc") and get_mailcc.recordcount)>
			<script type="text/javascript">
				wrk_opener_reload();
				function waitfor()
				{
				  	window.close();
				}
				setTimeout("waitfor()",2000); 		
			</script>
			<cfabort>
		</cfif>
	<cfelse>
		<script type="text/javascript">
		 wrk_opener_reload();
		 window.close();
		</script>
	</cfif>
</cfif>

<cfabort>

