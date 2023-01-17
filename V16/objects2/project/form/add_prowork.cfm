<cfinclude template="../query/get_pro_work_cat.cfm">
<cfinclude template="../query/get_priority.cfm">
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
    SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 7
</cfquery>
<script type="text/javascript">
	function kontrol()
	{
		x = document.getElementById('pro_work_cat').selectedIndex;
		if (document.getElementById('pro_work_cat')[x].value == "")
		{ 
			alert ("<cf_get_lang no='723.İş Kategorisi Seçmelisiniz'> !");
			return false;
		}
		x = document.getElementById('task_').selectedIndex;
		if (document.getElementById('task_')[x].value == "")
		{ 
			alert ("<cf_get_lang no='724.Görevli Seçmelisiniz'> !");
			return false;
		}
	}
</script>
<cfform method="post" name="add_work" action="#request.self#?fuseaction=objects2.emptypopup_add_pro_work&project_id=#attributes.project_id#">
	<table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%">
		<cfquery name="GET_PROJECT" datasource="#DSN#">
			SELECT PROJECT_HEAD, PROJECT_ID, TARGET_START, TARGET_FINISH, COMPANY_ID, PARTNER_ID FROM PRO_PROJECTS WHERE PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfquery>
    	<tr class="color-border"> 
      		<td style="vertical-align:middle"> 
				<table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:100%">
			  		<tr class="color-list" style="vertical-align:middle; height:35px;"> 
						<td> 
							<table align="center" style="width:98%">
								<tr> 
					  				<td class="headbold" style="vertical-align:bottom"><cfoutput>#get_project.project_head#</cfoutput> Projesine İş Ekle</td>
								</tr>
				  			</table>
						</td>
			  		</tr>
          			<tr class="color-row" style="vertical-align:top"> 
            			<td> 
							<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%">
                				<tr> 
                  					<td colspan="2"> <br/> 
										<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_project.project_id#</cfoutput>"> 
										<input type="hidden" name="pro_h_start" id="pro_h_start" value="<cfoutput>#get_project.target_start#</cfoutput>"> 
										<input type="hidden" name="pro_h_finish" id="pro_h_finish" value="<cfoutput>#get_project.target_finish#</cfoutput>"> 
										<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_project.company_id#</cfoutput>"> 
										<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_project.partner_id#</cfoutput>"> 
										<table border="0" cellspacing="2" cellpadding="2" style="width:100%">
										  	<tr> 
                                            	<td style="width:160px;"><cf_get_lang_main no='74.Kategori'> *</td>
												<td style="width:130px;"><cf_get_lang_main no="1447.Süreç"></td>
												<td><cf_get_lang no='725.Öncelik Kategorisi'></td>
										  	</tr>
										  	<tr> 
                                            	<td>
													<select name="pro_work_cat" id="pro_work_cat" style="width:125px;" onChange="tmplt();">
														<option value=""><cf_get_lang_main no='322.Seçiniz'>
														<cfoutput query="get_work_cat">
													  		<option value="#work_cat_id#">#work_cat# 
														</cfoutput>
												  	</select>
												</td>
												<td>
                                                	<cfif isDefined('attributes.is_rel_stage_cat') and attributes.is_rel_stage_cat eq 1>
                                                     	<div id="stage1" style="display:none;"></div>
                                                    <cfelse>
                                                		<cf_workcube_process is_upd='0' process_cat_width='105' is_detail='0'>
                                                	</cfif>
                                                </td>
												<td>
													<select name="priority_cat" id="priority_cat" style="width:105px;">
														<cfoutput query="get_cats"> 
														  <option value="#priority_id#">#priority#
														</cfoutput> 
												  	</select>
												</td>
										  	</tr>
                                            <tr>
                                            	<td colspan="3">
													<input type="text" name="rel_work" id="rel_work" style="width:240px;" value="<cf_get_lang no='726.İlişkili İş'>"> 
													<input type="hidden" name="rel_work_id" id="rel_work_id" value="0"> 
													<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_relation&form=add_work&pro_id=#url.project_id#</cfoutput>','small');"><img src="/images/plus_list.gif"  border="0" align="absmiddle"></a> 
												</td>
                                            </tr>
										</table>
									</td>
                				</tr>
                				<tr> 
                  					<td>
				  						<table border="0" cellspacing="2" cellpadding="2">
											<tr> 
												<td><cf_get_lang_main no='68.Başlık'> *</td>
										  	</tr>
										  	<tr> 
												<cfsavecontent variable="alert"><cf_get_lang no ='721.Lütfen İşin Adını Giriniz'></cfsavecontent>
												<td><cfinput type="text" name="work_head" id="work_head" required="Yes" message="#alert#" style="width:480px;" maxlength="100"></td>
										  	</tr>
										  	<tr> 
												<td><cf_get_lang_main no='359.Ayrıntı'></td>
										  	</tr>
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
                    					</table>
									</td>
                				</tr>
                				<tr> 
                  					<td> 
									  	<table border="0" cellspacing="2" cellpadding="2">
										  	<tr>
												<!---<td><cf_get_lang_main no='74.Kategori'> *</td> --->
												<td><cf_get_lang_main no='243.Başlama Tarihi'> *</td>
												<td><cf_get_lang_main no='79.Saat'></td>
												<td><cf_get_lang_main no='288.Bitiş Tarihi'> *</td>
												<td><cf_get_lang_main no='79.Saat'></td>
										  	</tr>
										  	<tr>
												<!---<td>
													<select name="pro_work_cat" id="pro_work_cat" style="width:125px;">
														<option value=""><cf_get_lang_main no='322.Seçiniz'>
														<cfoutput query="get_work_cat">
													  		<option value="#work_cat_id#">#work_cat# 
														</cfoutput>
												  	</select>
												</td>---> 
												<td>
													<cfinput name="work_h_start" id="work_h_start" required="Yes" validate="eurodate" message="!!! Lütfen !!!\r İşin Hedef Başlangıç Tarihi Giriniz" type="text" value="" style="width:80px;"> 
												  	<cf_wrk_date_image date_field="work_h_start"> 
												</td>
												<td> 
													<cfoutput> 
														<select name="start_hour" id="start_hour">
														<cfloop from="0" to="23" index="i">
															<option value="#i#" <cfif i eq 8>selected</cfif>>#i#:00</option>
														</cfloop>
														</select>
												  	</cfoutput> 
												</td>
												<cfsavecontent variable="alert">!!!<cf_get_lang no ='1390.Lütfen İşin Hedef Bitiş Tarihi Giriniz'></cfsavecontent>
												<td><cfinput type="text" name="work_h_finish" id="work_h_finish" required="Yes" validate="eurodate" message=" #alert#" value="" style="width:80px;"> 
													<cf_wrk_date_image date_field="work_h_finish"> 
												</td>
												<td> 
													<cfoutput> 
														<select name="finish_hour" id="finish_hour">
													  		<cfloop from="0" to="23" index="i">
																<option value="#i#" <cfif i eq 18>selected</cfif>>#i#:00</option>
													  		</cfloop>
														</select>
												  	</cfoutput>
												</td>
                      						</tr>
                      						<tr> 
												<td colspan="2">
													<!--- FA 20070219 hem kurumsal hem çalışan oldugu icin liste yöntemi kullanıldı --->
													<select name="task_" id="task_" style="width:200px;">
														<option value=""><cf_get_lang no='724.Görevli Seçiniz'>
														<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
															<!--- Proje Ekibi --->
															<cfinclude template="../query/get_project_team.cfm">
															<cfif get_emps.recordcount>
																<cfoutput query="get_emps">
																	<option value="'','',#employee_id#,1">#employee_name# #employee_surname# 
																</cfoutput>
															</cfif>
															<cfif get_emps.recordcount>
																<cfoutput query="get_pars">
																  	<option value="'',#company_id#,#partner_id#,'2'">#company_partner_name# #company_partner_surname# - #nickname#
																</cfoutput>
															</cfif>
															<!--- Proje Ekibi --->
														</cfif>
														<!--- Şirketin Partnerleri --->
														<cfinclude template="../../query/get_emps_pars_cons.cfm">
															<cfoutput query="get_emps_pars_cons">
																<cfif type eq 3>
																	<option value="'',#comp_id#,#uye_id#,'3'">#nickname# - #uye_name# #uye_surname#</option>
																</cfif>
															</cfoutput>
														<!--- Şirketin Partnerleri --->
												 	</select>
												</td>
												<td colspan="5" align="right" style="text-align:right;"> 
													<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
													<input type="hidden" name="hepsi" id="hepsi" value=""> 
												</td>
                      						</tr>
                    					</table>
				  					</td>
                				</tr>
              				</table>  
			 			</td>
          			</tr>
        		</table>
	  		</td>
    	</tr> 
	</table>
</cfform>

<cfif isDefined("attributes.work_id")>
	<cfquery name="GET_PRO_WORK_INFO" datasource="#DSN#">
		SELECT 
			WORK_HEAD,
			WORK_ID,
			TARGET_START,
			TARGET_FINISH
		FROM 
			PRO_WORKS 
		WHERE 
			WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
	</cfquery>
	<cfscript>
		sdate=date_add("h", session.pp.time_zone,get_pro_work_info.target_start);
		fdate=date_add("h", session.pp.time_zone,get_pro_work_info.target_finish);
		shour=datepart("h",sdate);
		fhour=datepart("h",fdate);
	</cfscript>	
	<cfoutput>
	<script type="text/javascript">
		window.add_work.rel_work.value      = '#get_pro_work_info.work_head#';
		window.add_work.rel_work_id.value   = '#get_pro_work_info.work_id#';
		window.add_work.work_h_start.value  = "#dateformat(sdate,'dd/mm/yyyy')#";
		window.add_work.start_hour.value    = "#shour#";
		window.add_work.work_h_finish.value = "#dateformat(fdate,'dd/mm/yyyy')#";
		window.add_work.finish_hour.value   = "#fhour#";
	</script>
	</cfoutput>
</cfif>

<script language="javascript">
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
