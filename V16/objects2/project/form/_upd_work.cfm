<cftry>
	<cfset attributes.work_id = decrypt(attributes.work_id,"WORKCUBE","BLOWFISH","Hex")>
	<cfcatch type="any">
		<script language="javascript">
			alert('Yetkiniz Yok!');
			history.back(-1);
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<cfinclude template="../query/get_work.cfm">
<cfif upd_work.recordcount>
    <cfquery name="GET_SPECIAL_DEFINITION" datasource="#dsn#">
        SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 7
    </cfquery>
  	<cfinclude template="../query/get_pro_work_cat.cfm">
  	<cfinclude template="../query/get_priority.cfm">
  	<cfset sdate=date_add("h",session.pp.time_zone,upd_work.target_start)>
  	<cfset fdate=date_add("h",session.pp.time_zone,upd_work.target_finish)>
  	<cfset shour=datepart("h",sdate)>
  	<cfset fhour=datepart("h",fdate)>
	<cfinclude template="../query/get_work_history.cfm">
	<cfquery name="GET_PROCURRENCY" datasource="#DSN#">
		SELECT
			PTR.STAGE,
			PTR.PROCESS_ROW_ID 
		FROM
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE PT
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.PROCESS_ID = PTR.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			<cfif isdefined("session.pp")>
				PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
			<cfelseif isdefined("session.ww")>
				PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
			<cfelse>
				PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			</cfif>
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects2.popup_updwork%">
		ORDER BY 
			PTR.LINE_NUMBER
	</cfquery>
	<table cellspacing="1" cellpadding="2" border="0" class="color-border" align="center" style="width:100%; height:100%">
	  	<tr class="color-list" style="height:35px;">
			<td>
		  		<table border="0" cellspacing="0" cellpadding="0" style="width:100%">
					<tr>
			  			<td class="headbold">&nbsp;<cf_get_lang no='5.İş Detay'> (ID : <cfoutput>#attributes.work_id#</cfoutput>)</td>
			  			<td align="right" style="text-align:right;"><cf_per_cent start_date = '#sdate#' finish_date = '#fdate#' color1='66CC33' color2='3399FF'></td>
					</tr>
		  		</table>
			</td>
		</tr>
  		<tr class="color-row">
			<td style="vertical-align:top">
	  			<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%">
					<tr>
		  				<td colspan="2" style="vertical-align:top">
							<cfform method="post" name="upd_work" action="#request.self#?fuseaction=objects2.emptypopup_upd_work">
							<input type="hidden" name="work_id" id="work_id" value="<cfoutput>#attributes.work_id#</cfoutput>">
							<input type="Hidden" name="pro_id" id="pro_id" value="<cfoutput>#upd_work.project_id#</cfoutput>">
							<table border="0" cellspacing="2" cellpadding="2">
			  					<tr>
									<td><cf_get_lang_main no='74.Kategori'></td>
									<td><cf_get_lang_main no='70.Aşama'></td>
									<td><cf_get_lang_main no='73.Öncelik'></td>
							  	</tr>
							  	<tr>
									<td>
										<select name="pro_work_cat" id="pro_work_cat" style="width:125px;" onChange="tmplt();">
											<cfoutput query="get_work_cat">
                                                <option value="#work_cat_id#"<cfif len(upd_work.work_cat_id) and (upd_work.work_cat_id eq work_cat_id)>selected</cfif>>#work_cat# 
                                            </cfoutput>
				 	 					</select>
									</td>
									<td><cf_workcube_process is_upd='0' select_value = '#upd_work.work_currency_id#' process_cat_width='110' is_detail='1'>
										<input type="hidden" name="old_currency" id="old_currency" value="<cfoutput>#upd_work.work_currency_id#</cfoutput>">
                                    </td>
									<td>
										<select name="priority_cat" id="priority_cat" style="width:110px;">
											<cfoutput query="get_cats">
                                                <option value="#get_cats.priority_id#" <cfif upd_work.work_priority_id is get_cats.priority_id>selected</cfif>>#get_cats.priority#</option>
                                            </cfoutput>
										</select>
									</td>
				 				</tr>
							  	<tr>
									<td colspan="2" style="vertical-align:top">
								  		<table cellpadding="0" cellspacing="0" border="0">
											<tr>
									  			<td>
												<cfif len(upd_work.project_id)>
													<cfquery name="GET_PRO_NAME" datasource="#DSN#">
														SELECT 
															PROJECT_HEAD 
														FROM 
															PRO_PROJECTS 
														WHERE
															PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#upd_work.project_id#">
													</cfquery>
													<input type="Hidden" name="project_id" id="project_id" value="<cfoutput>#upd_work.project_id#</cfoutput>">
													<input type="text" name="project_head" id="project_head" style="width:240;" value="<cfoutput>#get_pro_name.project_head#</cfoutput>" readonly>
												<cfelse>
													<input type="Hidden" name="project_id" id="project_id" value="">
													<input type="text" name="project_head" id="project_head" style="width:240;" value="Projesiz" readonly>
												</cfif>
											</tr>
								  		</table>
									</td>
									<td colspan="2">
									  	<table cellpadding="0" cellspacing="0" border="0">
											<tr>
												<cfsavecontent variable="message"><cf_get_lang no='727.İlişki Belirleyin'></cfsavecontent>
										  		<td style="vertical-align:top">
													<input type="text" name="rel_work" id="rel_work" style="width:250px;" value="<cfoutput>#upd_work.related_work_id#</cfoutput>">
													<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_relation&form=upd_work&work_id=#attributes.work_id#</cfoutput>&pro_id='+document.upd_work.project_id.value,'small');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
										  		</td>
											</tr>
									  	</table>
									</td>
			  					</tr>
							</table>
		  				</td>
           				<!--- ilişkili belgeler --->
           				<td style="width:200px; vertical-align:top">
							<cfinclude template="../display/work_relation_asset.cfm">
          				</td>
					</tr>
					<tr>
					  	<td>
							<table border="0">
							  	<tr>
									<td>&nbsp;<cf_get_lang_main no='68.Başlık'></td>
							  	</tr>
							  	<tr>
									<td>
								  		<cfsavecontent variable="message"><cf_get_lang no='721.Lütfen İşin Adını Giriniz'></cfsavecontent>
								  		<cfinput type="Text" name="work_head" id="work_head" value="#upd_work.work_head#" required="Yes" message="#message#!" style="width:520px;" maxlength="100">
									</td>
							  	</tr>
							  	<tr>
									<td>&nbsp;<cf_get_lang_main no='359.Ayrıntı'></td>
							  	</tr>
							  	<!---<tr>
									<td>
								  		<textarea name="work_detail" id="work_detail" style="width:520px;" rows="7"></textarea>
									</td>
							  	</tr>--->
                                <tr>
                                	<td>
                               			<cfset tr_topic =''>
                                        <cfmodule
                                            template="../../../fckeditor/fckeditor.cfm"
                                            toolbarSet="Basic"
                                            basePath="/fckeditor/"
                                            instanceName="work_detail"
                                            valign="top"
                                            value=""
                                            width="580"
                                            height="180">                                    	
                                    </td>
                                </tr>
							</table>
					  	</td>
					</tr>
					<tr>
		  				<td>
							<table border="0" cellspacing="2" cellpadding="2">
							  	<tr>
									<td><cf_get_lang_main no='157.Görevli'></td>
									<td style="width:97px">Gerçekleşen <cf_get_lang_main no='243.Baş Tarihi'> </td>
									<td><cf_get_lang_main no='79.Saat'></td>
									<td style="width:97px">Gerçekleşen <cf_get_lang_main no='288.Bitiş Tarihi'> </td>
									<td><cf_get_lang_main no='79.Saat'></td>
							  	</tr>
			  					<tr>
									<td><!--- FA 20070219 hem kurumsal hem çalışan oldugu icin liste yöntemi kullanıldı --->
										<select name="task_" id="task_" style="width:150px;">
											<option value=""><cf_get_lang no='724.Görevli Seçiniz'>
											<!--- proje ekibi --->
											<cfif isdefined("attributes.id") and len(attributes.id)>
												<cfinclude template="../query/get_project_team.cfm">
												<cfif get_emps.recordcount>
													<cfoutput query="get_emps">
													  <option value="'','',#employee_id#,'1'" <cfif len(upd_work.project_emp_id) and (upd_work.project_emp_id eq employee_id)>selected</cfif>>#employee_name# #employee_surname#</option>
													</cfoutput>
												</cfif>
												<cfif get_pars.recordcount>
													<cfoutput query="get_pars">
													  <option value="'',#company_id#,#partner_id#,'2'" <cfif len(upd_work.outsrc_cmp_id) and (upd_work.outsrc_cmp_id eq company_id)>selected</cfif>>#nickname# - #company_partner_name# #company_partner_surname#</option>
													</cfoutput>
												</cfif>
												<!--- proje ekibi --->
											</cfif>
											<!--- Şirketin Partnerleri --->
												<cfinclude template="../../query/get_emps_pars_cons.cfm">
												<cfoutput query="get_emps_pars_cons">
													<cfif type eq 3>
														<option value="'',#comp_id#,#uye_id#,'3'" <cfif len(upd_work.outsrc_partner_id) and (upd_work.outsrc_partner_id eq uye_id)>selected</cfif>>#nickname# - #uye_name# #uye_surname#</option>
													</cfif>
												</cfoutput>
											<!--- Şirketin Partnerleri --->
									 	</select>
				 					</td>
									<td><!---#dateformat(sdate,'dd/mm/yyyy')#--->
									  	<cfsavecontent variable="massage">!!!<cf_get_lang no ='1392.Lütfen İşin Hedef Başlangıç Tarihi Giriniz'></cfsavecontent>
									  	<cfinput type="text" name="work_h_start"  id="work_h_start"  value="" required="Yes" message="#massage#"style="width:75px;" validate="eurodate">
									  	<cf_wrk_date_image date_field="work_h_start">
									</td>
									<td>
									  	<cfoutput>
											<select name="start_hour" id="start_hour">
											  	<cfloop from="0" to="23" index="i">
													<option value="#i#" <cfif i eq shour>selected</cfif>>#i#:00</option>
											  	</cfloop>
											</select>
									  	</cfoutput>
									</td>
									<td><!---#dateformat(fdate,'dd/mm/yyyy')#--->
									  	<cfinput type="text" name="work_h_finish" id="work_h_finish" value="" required="Yes" message="!!! Lütfen !!!\r İşin Hedef Bitiş Tarihi Giriniz" style="width:75px;" validate="eurodate">
									  	<cf_wrk_date_image date_field="work_h_finish">
									</td>
									<td>
										<cfoutput>
											<select name="finish_hour" id="finish_hour" >
											  	<cfloop from="0" to="23" index="i">
													<option value="#i#" <cfif i eq fhour>selected</cfif>>#i#:00</option>
											  	</cfloop>
											</select>
										</cfoutput>
									</td>
								</tr>
                                <tr>
                            		<td>Özel Tanım
                                        <select name="special_definition" id="special_definition" style="width:142px">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_special_definition">
                                                <option value="#special_definition_id#">#special_definition#</option>
                                            </cfoutput>
                                        </select>
									</td>
                                </tr>
								<tr style="height:35px;">
									<td colspan="2">
										<cfif upd_work.work_status eq 1>
											<cf_get_lang no='728.Gündemde'> <cfinput type="checkbox" name="work_status" id="work_status" checked="yes">
									  	<cfelse>
											<cf_get_lang no='717.Gündemde Değil'> <cfinput type="checkbox" name="work_status" id="work_status" >
									  	</cfif>
									  	&nbsp;&nbsp;
										<cf_get_lang_main no='71.Kayıt'>:
									  	<cfif len(upd_work.record_author)>
											<cfoutput>#get_emp_info(upd_work.record_author,0,0)#</cfoutput>
									  	<cfelseif len(upd_work.record_par)>
											<cfoutput>#get_par_info(upd_work.record_par,0,-1,0)#</cfoutput>
									  	</cfif>
									  	-
									  	<cfset rec_date = date_add('h',session.pp.TIME_ZONE,upd_work.RECORD_DATE)>
										<cfoutput>#Dateformat(rec_date,'dd/mm/yyyy')# #Timeformat(rec_date,'HH:mm')#</cfoutput> 
									</td>
									<td colspan="3" align="right" style="text-align:right;"> 
										<cfif upd_work.record_par eq session.pp.userid>
											<cf_workcube_buttons is_upd='1'
												delete_page_url='#request.self#?fuseaction=objects2.delwork&id=#upd_work.work_id#'
												add_function='chk_work(#upd_work.project_id#)'>
										<cfelse>
											<cf_workcube_buttons is_upd='1' is_delete='0' add_function='chk_work(#upd_work.project_id#)'>
										</cfif>
									</td>
								</tr>
			  					<tr>
									<cfif get_work_history.recordcount>
										<td colspan="7">
											<table align="center" cellpadding="0" cellspacing="1" border="0" class="color-border" style="width:100%">
												<tr class="color-list" style="height:20px;">
													<td class="formbold">&nbsp;<a href="javascript:gizle_goster(works_history);"><img src="images/graphcontinue.gif" border="0">&nbsp;<cf_get_lang no='679.İş Tarihçesi'></a></td>
												</tr>
												<tr id="works_history" class="color-row">
													<td>
														<table>
															<cfoutput query="get_work_history">
															<tr>
																<td>
																<table align="center" cellpadding="5" cellspacing="0" border="0" class="color-row" style="width:100%">
																	<tr>
																		<td><font color="##FF0000"><cf_get_lang_main no='68.Başlık'> :</font> #work_head#</td>
																	</tr>
																	<tr>
																		<td><font color="##FF0000"><cf_get_lang_main no='217.Açıklama'> :</font> #work_detail#</td>
																	</tr>
																	<tr>
																		<td>
																			<cfquery name="GET_PROCESS" datasource="#DSN#">
																				SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_work_history.work_currency_id#">
																			</cfquery>
																			<font color="##FF0000"><cf_get_lang_main no='70.Aşama'>:</font> #get_process.stage#&nbsp;&nbsp;
																			<font color="##FF0000"><cf_get_lang_main no='73.Öncelik'>:</font> #priority#&nbsp;&nbsp;
																			<font color="##FF0000"><cf_get_lang_main no='74.Kategori'>:</font> #work_cat#&nbsp;&nbsp;
																		</td>
																	</tr>
																	<cfif len(target_start) and len(target_finish)>					
																		<tr>
																			<cfset sdate=date_add("h",session.pp.time_zone,target_start)>
																			<cfset fdate=date_add("h",session.pp.time_zone,target_finish)>
																			<td><font color="##FF0000"><cf_get_lang_main no='89.aşlama'>:</font> #dateformat(sdate,'dd/mm/yyyy')# #timeformat(sdate,'HH:mm')#
																			&nbsp;&nbsp;<font color="##FF0000"><cf_get_lang_main no='90.Bitiş'>:</font> #dateformat(fdate,'dd/mm/yyyy')# #timeformat(fdate,'HH:mm')#
																			</td>
																		</tr>
																	</cfif>
																	<tr>
																		<td><font color="##FF0000"><cf_get_lang_main no='479.Güncelleyen'> :</font>
																		<cfif len(get_work_history.update_author)>
																			#get_emp_info(get_work_history.update_author,0,0)#
																		</cfif>
																		<cfif len(get_work_history.update_par)>
																			#get_par_info(get_work_history.update_par,0,0,0)#
																		</cfif>
																		&nbsp;&nbsp;
																		<cfset upd_date = date_add('h',session.pp.time_zone,update_date)>
																		<font color="##FF0000"><cf_get_lang no='729.Güncelleme Tarihi'> :</font> #Dateformat(upd_date,'dd/mm/yyyy')# #Timeformat(upd_date,'HH:mm')#
																		</td>
																	</tr>
																	<tr>
																		<td>
																			<cfif get_work_history.recordcount gt 1><hr></cfif>
																		</td>
																	</tr>
																</table>
																</td>
															</tr>
															</cfoutput>
														</table>
													</td>
												</tr>		
											</table>
										</td>
									</cfif>
								</tr>
                                <tr>
                                	<td><cfinclude template="../display/list_stock_receipts.cfm"></td>
                                </tr>
							</table>
						</td>
					</tr>
					</cfform>
				</table>
			</td>
		</tr>
	</table>
	<script type="text/javascript">
		function chk_work(pro_id)
		{
			if((document.getElementById('pro_id').value > 0) && (document.getElementById('project_id').value>0)&&(document.getElementById('rel_work_id').value!=0)&&(document.getElementById('rel_work_id').value!="")&&(document.getElementById('project_id').value!=pro_id))
			if(confirm("<cf_get_lang no='730.İlişkilendirilmiş iş seçtiğiniz projeye ait değil.İş ilişkisi silinecek'>!"))
			{
				window.open('<cfoutput>#request.self#?fuseaction=project.popup_arrange_rel&work_id=#attributes.work_id#</cfoutput>&rel_work_id='+document.getElementById('rel_work_id').value,'','');
				document.getElementById('rel_work_id').value=0;
				document.getElementById('rel_work').value="<cf_get_lang no='727.İlişki belirleyin'>";
			}
			else return false;
			return kontrol();
		}
		function kontrol()
		{
			x = document.upd_work.pro_work_cat.selectedIndex;
			if (document.upd_work.pro_work_cat[x].value == "")
			{ 
				alert ("<cf_get_lang no='723.İş Kategorisi Seçmelisiniz'> !");
				return false;
			}
			x = document.upd_work.task_.selectedIndex;
			if (document.upd_work.task_[x].value == "")
			{ 
				alert ("<cf_get_lang no='724.Görevli Seçmelisiniz'> !");
				return false;
			}
			return true;
		}
		
		tmplt();
		function tmplt(type)
		{	
			var pwc = document.getElementById('pro_work_cat').value;
			if(type == undefined) type = 0;
			if(type == 0)//kategoriye bağlı süreç gelecek
			{
				if(pwc != '')
				{
					var get_temp = wrk_safe_query('get_temp_work_cat','dsn',0,pwc);
					var tpid = get_temp.template_id;
					if (tpid != undefined)
					{
						setTimeout(function(){AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=project.popup_get_template&pwc='+pwc+'','fckedit',1)},400);
					}
				}
				<cfif isdefined("attributes.is_rel_stage_cat") and is_rel_stage_cat eq 1>
					if(pwc!='')
					{
						goster(stage1);
						setTimeout(function(){AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_stage&category_id='+pwc,'stage1')},400);
					}
					else
					{
						goster(stage1);
						setTimeout(function(){AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_stage&category_id=','stage1')},400);
					}
				</cfif>
			}
			else//kategori ve sürece bağlı template gelecek
			{
				<cfif isdefined("attributes.is_rel_stage_cat") and is_rel_stage_cat eq 1>
					var pro_stage = document.getElementById('process_stage').value;
					if(pwc !='' && pro_stage != '')
					{
						//goster(stage1);
						//goster(stage2);
						
						setTimeout(function(){AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=project.popup_get_template&pro_stage='+pro_stage+'&pwc='+pwc,'fckedit',1)},600);
					}
				</cfif>
			}
		}
	</script>
<cfelse>
	<table border="0" cellspacing="0" cellpadding="0" style="width:100%">
		<tr class="color-row" style="height:20px;">
		  	<td colspan="9"><cf_get_lang_main no='72.kayıt yok'></td>
		</tr>
	</table>
</cfif>
