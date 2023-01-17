
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
<cffunction name="addwork" access="remote" returnformat="plain" output="no">
										<cfargument name="service_head" type="string" required="yes">
										<cfargument name="service_detail" type="string" required="yes">
										<cfargument name="project_id" type="string" required="yes">
										<cfargument name="company_id" type="string" required="yes">
										<cfargument name="partner_id" type="string" required="yes">
										<cfargument name="company_name" type="string" required="yes">
										<cfargument name="partner_name" type="string" required="yes">
										<cfargument name="pstartdate" type="string" required="no">
										<cfargument name="pfinishdate" type="string" required="no">
										<cfargument name="gstartdate" type="string" required="no">
										<cfargument name="gfinishdate" type="string" required="no">
										
										<cfargument name="servicecat_id" type="string" required="no">
										<cfargument name="servicecat_sub_id" type="string" required="no" default="1">
										<cfargument name="servicecat_sub_status_id" required="no" type="string" default="1">
										<cfargument name="project_emp_id" required="yes" type="string">
										<cfargument name="login_type" required="yes" type="string">
										<cfargument name="cityid" required="yes" type="string">
										<cfargument name="countyid" required="yes" type="string">
										<cfargument name="service_address" required="yes" type="string">
											<cfargument name="ws_companyid" type="string" required="no">			
												
												<cfset our_company_id=arguments.ws_companyid>
													<cfinclude template="mobil_company_set.cfm">
											<cfif len(pstartdate)>
												<cfset psdate=ListFirst(pstartdate,' ')>
												<cfset pstime=ListLast(pstartdate,' ')>
												<cfset y=listgetat(psdate,3,'/')>
												<cfset m=numberformat(listgetat(psdate,2,'/'),00)>
												<cfset d=listgetat(psdate,1,'/')>
												<cfset s=listlast(pstime,':')>
												<cfif s eq '00'><cfset s=0></cfif>
														<cfif s mod 5 lt 3 and s neq 0>
																<cfset s = s - (s mod 5)>
														<cfelseif s mod 5 gte 3 and s neq 5>
																<cfset s = s + 5 - (s mod 5) >
														</cfif>
														<cfif s gt 55>
																<cfset s=55>
														</cfif>
												<cfset ss=listfirst(pstime,':')>
												<cfif ss eq '00'><cfset ss=2></cfif>
												<cfset ss=ss-2>
												<cfset pstartdate=CreateDateTime(y,m,d,ss,s,0)>
											</cfif>
											<cfif len(pfinishdate)>
													<cfset pbdate=ListFirst(pfinishdate,' ')>
													<cfset pbtime=ListLast(pfinishdate,' ')>
													<cfset y=listgetat(pbdate,3,'/')>
													<cfset m=numberformat(listgetat(pbdate,2,'/'),00)>
													<cfset d=listgetat(pbdate,1,'/')>
													<cfset s=listlast(pbtime,':')>
														<cfif s eq '00'><cfset s=0></cfif>
														<cfif s mod 5 lt 3 and s neq 0>
																<cfset s = s - (s mod 5)>
														<cfelseif s mod 5 gte 3 and s neq 5>
																<cfset s = s + 5 - (s mod 5) >
														</cfif>
														<cfif s gt 55>
															<cfset s=55>
														</cfif>
													<cfset ss=listfirst(pbtime,':')>
													<cfif ss eq '00'>
														<cfset ss=0>
													<cfelse>
														<cfset ss=ss-2>
													</cfif>
													
												<cfset pfinishdate=CreateDateTime(y,m,d,ss,s,0)>
											</cfif>
											<cfif len(gfinishdate)>
												<cfset tempdate=ListFirst(gfinishdate,' ')>
												<cfset temptime=ListLast(gfinishdate,' ')>
												<cfset y=listgetat(tempdate,3,'/')>
												<cfset m=numberformat(listgetat(tempdate,2,'/'),00)>
												<cfset d=listgetat(tempdate,1,'/')>
												<cfset s=listlast(temptime,':')>
															<cfif s mod 5 lt 3 and s neq 0>
																<cfset s = s - (s mod 5)>
															<cfelseif s mod 5 gte 3 and s neq 5>
																<cfset s = s + 5 - (s mod 5) >
															</cfif>
															<cfif s gt 55>
																	<cfset s=55>
															</cfif>
												<cfset ss=listfirst(temptime,':')>
												<cfif ss eq '00'><cfset ss=2></cfif>
												<cfset ss=ss-2>
												<cfset gfinishdate=CreateDateTime(y,m,d,ss,s,0)>
										  </cfif>
																										
										<cfif len(gstartdate)>
												<cfset tempdate=ListFirst(gstartdate,' ')>
												<cfset temptime=ListLast(gstartdate,' ')>
												<cfset y=listgetat(tempdate,3,'/')>
												<cfset m=numberformat(listgetat(tempdate,2,'/'),00)>
												<cfset d=listgetat(tempdate,1,'/')>
												<cfset s=listlast(temptime,':')>
															<cfif s mod 5 lt 3 and s neq 0>
																<cfset s = s - (s mod 5)>
															<cfelseif s mod 5 gte 3 and s neq 5>
																<cfset s = s + 5 - (s mod 5) >
															</cfif>
																<cfif s gt 55>
																	<cfset s=55>
																	</cfif>
												<cfset ss=listfirst(temptime,':')>
												<cfif ss eq '00'><cfset ss=2></cfif>
												<cfset ss=ss-2>
												<cfset gstartdate=CreateDateTime(y,m,d,ss,s,0)>
										</cfif>
										
										
										
											<!---<cfquery name="GET_GEN_PAPER" datasource="#DSN3#">
												SELECT * FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
											</cfquery>
											<cfset attributes.paper_type = "SERVICE_APP">
											<cfset paper_code = evaluate('get_gen_paper.#attributes.paper_type#_no')>
											<cfset paper_number = evaluate('get_gen_paper.#attributes.paper_type#_number') + 1>
											<cfset system_paper_no=paper_code & '-' & paper_number>
											<cfset system_paper_no_add=paper_number>
													<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
																UPDATE
																	GENERAL_PAPERS
																SET
																	SERVICE_APP_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#system_paper_no_add#">
																WHERE
																	SERVICE_APP_NUMBER IS NOT NULL
													</cfquery>
											--->
														<cfset process_stage_id=180>
														<cfset subscription_id=1>
														<cfset priority_id=1>
															<cftransaction action="begin">	
															
																		<cfif login_type eq 0>
																			<cfset attributes.project_emp_id = arguments.PROJECT_EMP_ID>
																		<cfelse>
																			<cfquery name="get_company" datasource="#dsn#">
																				select COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_emp_id#">
																			</cfquery>
																			<cfset attributes.task_company_id=get_company.company_id>
																			<cfset attributes.task_partner_id=arguments.PROJECT_EMP_ID>
																			<cfset attributes.project_emp_id ="">
																		</cfif>

																		<cfset attributes.service_id = "">
																		<cfset caller.attributes.fuseaction = "project.upd_work">
																		<cfset attributes.module_name = "project">
																		<cfset attributes.lang_name = "tr">
																		<cfset caller.language = 'tr'>
																		<cfset caller.lang_auto_control = 1>
																		<cfset attributes.is_mobile = 1>
																		<cfset caller.dsn3 = dsn3>
																		<cfset caller.dsn = dsn>
																		<cfset caller.fusebox.workcube_mode = 1>
																		<cfinclude template="../CustomTags/get_lang_set_main.cfm">
																		<cfinclude template="../CustomTags/get_lang_set.cfm">
																		<cfset lang_array_main.item = caller.lang_array_main.item>
																		<cfset lang_array.item = caller.lang_array.item>
																		<cfif arguments.company_id gt 0>
																			<cfset attributes.company_id = arguments.company_id>
																		<cfelse>
																			<cfset attributes.company_id =""><!---bireysel üyeiçin--->
																		</cfif>
																		<cfset attributes.is_mail = 0>
																		<cfset attributes.our_company_id = our_company_id>
																		<cfset session.ep.time_zone = 2>
																		<cfset session.ep.userid = arguments.project_emp_id>
																		<cfset session.ep.company_id = our_company_id>
																		<cfset session.ep.company = "Nemesis Alarmsis Teknoloji A.Ş">
																		<cfset session.ep.company_email ="info@nemesisalarmsis.com">
																		<cfset session.ep.name = "mobil">
																		<cfset session.ep.surname = "mobil">
																		
																				<cfset attributes.startdate_plan = NOW()>
																		
																		
																		<cfset employee_domain = 'http://#listfirst(employee_url,';')#/'>
																		<cfset attributes.project_id = arguments.project_id>
																		<cfset attributes.work_head = left(arguments.service_head,100)>
																		<cfset attributes.fuseaction = "project.add_service">
																		<cfset attributes.company_partner_id =arguments.partner_id>
																		<cfset language = 'tr'>
																		<cfquery name="GET_WORK_CAT" datasource="#DSN#" maxrows="1">
																				SELECT WORK_CAT_ID, WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT
																		</cfquery>
																		<cfset attributes.PRO_WORK_CAT = GET_WORK_CAT.WORK_CAT_ID>
																					<cfquery name="GET_CATS" datasource="#DSN#" maxrows="1">
																						SELECT PRIORITY_ID, PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY
																					</cfquery>
																		<cfset attributes.PRIORITY_CAT = GET_CATS.PRIORITY_ID>
																		<cfquery name="GET_WORK_PROCESS" datasource="#DSN#" maxrows="1">
																			SELECT TOP 1
																				PTR.STAGE,
																				PTR.PROCESS_ROW_ID
																			FROM 
																				PROCESS_TYPE_ROWS  PTR,																								
																				PROCESS_TYPE_OUR_COMPANY PTO,
																				PROCESS_TYPE PT
																			WHERE
																				PT.PROCESS_ID = PTR.PROCESS_ID AND
																				PT.PROCESS_ID = PTO.PROCESS_ID AND
																				PTO.OUR_COMPANY_ID = #our_company_id# AND <!--- company_id gönderilsin --->
																				PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.addwork,%">
																				ORDER BY
																						PTR.LINE_NUMBER
																				</cfquery>
																						
																						<cfset file_web_path = '/documents/'>
																						<cfset session.ep.position_code = ""><!---control_session.POSITION_CODE>--->
																						<cfset attributes.work_process_stage = get_work_process.PROCESS_ROW_ID>
																						
																						 
																						<cfset session.ep.language = 'tr'>
																						<cfset attributes.process_stage = process_stage_id>
																						<cfset user_domain = 'http://#cgi.http_host#/'>
																						<cfset attributes.work_status = 1>
																						<cfset attributes.work_fuse = 'service.add_service'>
																						<cfset attributes.work_detail = arguments.service_detail>
																						<cfset attributes.apply_date = NOW()>
																						<cfset attributes.apply_hour = Hour(NOW())> 
																						<cfset attributes.apply_minute = Minute(NOW())>  
																						<cfset temp_apply_date = attributes.apply_date>
																						<cfset attributes.startdate_plan = temp_apply_date>
																						<cfset caller.fusebox.workcube_mode = 0>
																						<cf_date tarih='temp_apply_date'>
																						<cfset attributes.finishdate_plan = dateformat(dateadd('d',1,temp_apply_date),'dd/mm/yyyy')>
																						<cfset attributes.finish_hour_plan = attributes.apply_hour>
																						<cfset attributes.finish_hour = attributes.apply_hour>
																						<cfset attributes.start_hour = attributes.apply_hour>
																						<cfset attributes.old_process_line = 0>
																						<!---<cfset attributes.action_id = XXX.IDENTITYCOL>--->
																																																																																		</cftransaction>
																<cfinclude template="../project/query/add_work_brs.cfm">
																<!---<cfquery name="upd_work" datasource="#dsn#">
																	UPDATE PRO_WORKS
																	SET TARGET_START=#pstartdate#,
																		TARGET_FINISH=#pfinishdate#
																	where 
																	WORK_ID=#get_last_work.work_id#
																</cfquery>--->
																	<cfscript>
																		sonuc = '{"SONUC"="#get_last_work.work_id#", "SONUCMESAJI"="#get_last_work.work_id#"}';
																	</cfscript>
																	<cfreturn sonuc>
									</cffunction>
									</cfcomponent>