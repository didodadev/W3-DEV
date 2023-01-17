<cfform name="add_event" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_event">
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
	<tr>
		<td class="headbold"><cf_get_lang no='220.Eğitim Ekle'></td>
	</tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr clasS="color-border">
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="2">
				<tr class="color-row">
					<td valign="top">
						<table border="0">
							<tr>
								<td valign="top" width="90"></td>
								<td width="255">
									<input type="checkbox" name="online" id="online" value="1"><cf_get_lang_main no='2218.online'>
									<input type="checkbox" name="int_or_ext" id="int_or_ext" value="1"><cf_get_lang no='168.Dış Eğitim'><!--- secili ise dis egitim --->
									<input type="checkbox" name="is_net_display" id="is_net_display" value="1" onClick="gizle_goster(is_site_display);"><cf_get_lang no='40.İnternette Gözüksün'> &nbsp;
								</td>
							</tr>
							<tr> 
								<td><cf_get_lang_main no='74.kategori'></td>
								<td>
									<select name="training_cat_id" id="training_cat_id" onChange="get_tran_sec(this.value)" style="width:250px;">
										<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
										<cfoutput query="get_training_cat">
											<option value="#training_cat_id#">#training_cat#</option>
										</cfoutput>
									</select>
								</td>
								<td width="110"><cf_get_lang no='445.Maksimum Katılımcı'></td>
								<td>
									<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='783.tam sayı'></cfsavecontent>
									<cfinput type="text" name="max_participation" style="width:68px;" validate="integer" message="#message#">&nbsp;
									<cf_get_lang no ='39.Self Servis Kontenjan'>&nbsp;
									<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='783.tam sayı'></cfsavecontent>
									<cfinput type="text" name="max_self_service" style="width:68px;" validate="integer" message="#message#">
								</td>
							</tr>
							<tr>
								<td><cf_get_lang no='188.bölüm'></td>
								<td>
									<select name="training_sec_id" id="training_sec_id" size="1" style="width:250">
										<option value="0"><cf_get_lang no='188.bölüm'>!</option>
									</select>	
								</td>
								<td><cf_get_lang no='187.Eğitim Yeri'></td>
								<td><cfinput type="text" name="class_place" style="width:250px;" maxlength="100"></td>
							</tr>
							<tr> 
								<td><cf_get_lang no='426.Ders'>*</td>
								<td>
									<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.başlık'></cfsavecontent> 
									<cfinput type="text" name="class_name" style="width:250px;" required="Yes" message="#message#" maxlength="100">
								</td>
								<td><cf_get_lang no='23.Eğitimci'></td>
								<td>
									<input type="hidden" name="emp_id" id="emp_id" value="">
									<input type="hidden" name="par_id" id="par_id" value="">
									<input type="hidden" name="cons_id" id="cons_id" value=""> 
									<input type="hidden" name="member_type" id="member_type" value="">
									<input type="text" name="emp_par_name" id="emp_par_name" value="" style="width:250;" readonly>&nbsp;<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_event.emp_id&field_name=add_event.emp_par_name&field_type=add_event.member_type&field_partner=add_event.par_id&field_consumer=add_event.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>','list');"><img src="/images/plus_thin.gif" width="15" alt="<cf_get_lang no='23.Eğitimci'>" border="0" align="absmiddle"></a>
								</td>
							</tr>
							<tr> 
								<td><cf_get_lang_main no='89.başlama'></td>
								<td>
									<table border="0" cellpadding="0" cellspacing="0">
										<tr> 
											<td width="73"><cfsavecontent variable="message"> <cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent><cfinput validate="#validate_style#" message="#message#" type="text" name="start_date" style="width:70px;" maxlength="10"></td>
											<td width="20"><cf_wrk_date_image date_field="start_date"></td>
											<td width="62"  style="text-align:right;"><cf_get_lang no='119.saat / dk'>:&nbsp;</td>
											<td width="55">
												<select name="event_start_clock" id="event_start_clock" style="width:54px;">
													<option value="0" selected><cf_get_lang_main no='79.Saat'></option>
													<cfloop from="7" to="30" index="i">
														<cfset saat=i mod 24>
														<option value="<cfoutput>#saat#</cfoutput>"><cfoutput>#saat#</cfoutput></option>
													</cfloop>
												</select>
											</td>
											<td>
												<select name="event_start_minute" id="event_start_minute" style="width:40px;">
													<option value="00" selected>00</option>
													<option value="05">05</option>
													<option value="10">10</option>
													<option value="15">15</option>
													<option value="20">20</option>
													<option value="25">25</option>
													<option value="30">30</option>
													<option value="35">35</option>
													<option value="40">40</option>
													<option value="45">45</option>
													<option value="50">50</option>
													<option value="55">55</option>
												</select>
											</td>
										</tr>
									</table>
								</td>
								<td><cf_get_lang no='35.Eğitim Yeri Sorumlusu'></td>
								<td><cfinput type="text" value="" name="CLASS_PLACE_MANAGER" style="width:250px;" maxlength="100"></td>
							</tr>
							<tr> 
								<td><cf_get_lang_main no='90.bitis'></td>
								<td> 
									<table border="0" cellpadding="0" cellspacing="0">
										<tr> 
											<td width="73">
												<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
												<cfinput type="text" name="finish_date" style="width:70px;"  message="#message#" validate="#validate_style#" maxlength="10">
											</td>
											<td width="20"><cf_wrk_date_image date_field="finish_date"></td>
											<td width="62"  style="text-align:right;"><cf_get_lang no='119.saat / dk'>:&nbsp;</td>
											<td width="55">
												<select name="event_finish_clock" id="event_finish_clock" style="width:54px;">
													<option value="0" selected><cf_get_lang_main no='79.Saat'></option>
													<cfloop from="7" to="30" index="i">
													<cfset saat=i mod 24>
														<option value="<cfoutput>#saat#</cfoutput>"><cfoutput>#saat#</cfoutput></option>
													</cfloop>
												</select>
											</td>
											<td>
												<select name="event_finish_minute" id="event_finish_minute" style="width:40px;">
													<option value="00" selected>00</option>
													<option value="05">05</option>
													<option value="10">10</option>
													<option value="15">15</option>
													<option value="20">20</option>
													<option value="25">25</option>
													<option value="30">30</option>
													<option value="35">35</option>
													<option value="40">40</option>
													<option value="45">45</option>
													<option value="50">50</option>
													<option value="55">55</option>
												</select>
											</td>
										</tr>
									</table>
								</td>
								<td><cf_get_lang no='30.Eğitim Yeri Adresi'></td>
								<td><cfinput type="text" value="" name="CLASS_PLACE_ADDRESS" style="width:250px;" maxlength="100"></td>
							</tr>
							<tr>
								<td></td>
								<td>
									<table border="0" cellpadding="0" cellspacing="0">
										<tr> 
											<td></td>
											<td width="75"  style="text-align:right;"><cf_get_lang no='169.Eğitim Gün'>*</td>
											<td>
												<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='169.toplam Gün'></cfsavecontent>
												<cfinput type="text" name="date_no" style="width:25px;" onKeyup='return(FormatCurrency(this,event));' required="Yes" message="#message#" maxlength="100">
											</td>
											<td width="60"  style="text-align:right;"><cf_get_lang_main no='79.Saat'>*</td>
											<td  style="text-align:right;">
												<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='170.toplam saat'></cfsavecontent> 
												<cfinput type="text" name="hour_no" style="width:25px;" onKeyup='return(FormatCurrency(this,event));' required="Yes" message="#message#" maxlength="100"> 
											</td>
										</tr>
									</table>
								</td>
								<td><cf_get_lang no='34.Eğitim Yeri Telefonu'></td>
								<td><cfinput type="text" value="" name="CLASS_PLACE_TEL" style="width:250px;" maxlength="100"></td>
							</tr>
							<tr>
								<td><cf_get_lang no ='29.Eğitim Şekli'></td>
								<td>
									<select name="training_style" id="training_style" style="width:250px">
										<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
										<cfoutput query="get_training_style">
											<option value="#training_style_id#" >#TRAINING_STYLE#</option>
										</cfoutput>
									</select>
								</td>
								<td valign="top"><cf_get_lang_main no='4.Proje'></td>
								<td>
									<input type="hidden" name="project_id" id="project_id" value="">
									<input type="text" name="project_head" id="project_head" style="width:250px;"  value="">
									<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_event.project_id&project_head=add_event.project_head');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='4.Proje'>" align="absmiddle" border="0"></a>
								</td>
							</tr>
							<tr> 
								<td valign="top" rowspan="2"><cf_get_lang_main no='2.Araçlar'></td>
								<td valign="top" rowspan="2"><textarea name="class_tools" id="class_tools" style="width:250px;height:80px;"></textarea></td>
								<td valign="top"><cf_get_lang no='32.Amaç'></td>
								<td valign="top"><textarea name="CLASS_TARGET" id="CLASS_TARGET" style="width:250px;height:50px;"></textarea></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td valign="top"><cf_get_lang no='425.Ders Duyurusu'></td>
								<td colspan="3"><textarea name="class_announcement" id="class_announcement" style="width:660px;height:70px;"></textarea></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td colspan="4">
									<table width="100%">
										<cfoutput>
										<tr>
											<td class="txtbold">
												<input type="Checkbox" name="VIEW_TO_ALL" id="VIEW_TO_ALL" value="1" onClick="wiew_control(1);"><cf_get_lang no='44.Bu olayı herkes görsün'>
											</td>
											<td class="txtbold">
												<input type="checkbox" name="is_wiew_branch" id="is_wiew_branch" value="#find_department_branch.branch_id#" onClick="wiew_control(2);">
												<cf_get_lang_main no='502.Şubemdeki Herkes Görsün'>
											</td>
											<td class="txtbold">
												<input type="hidden" name="is_wiew_branch_" id="is_wiew_branch_" value="#find_department_branch.branch_id#">
												<input type="checkbox" name="is_wiew_department" id="is_wiew_department" value="#find_department_branch.department_id#" onClick="wiew_control(3);">
												<cf_get_lang_main no='503.Departmanımdaki Herkes Görsün'>
											</td>
										</tr>
										</cfoutput>
									</table>
								</td>
							</tr>
							<tr> 
								<td>&nbsp;</td>
								<td><cf_workcube_buttons is_upd='0' add_function='OnFormSubmit()&&kontrol()'></td>
							</tr>
						</table>
					</td>
					<td id="is_site_display" style="display:none;" valign="top">
						<table>
							<tr>
								<td class="formbold"><cf_get_lang no ='24.Yayınlanacak Site'></td>
							</tr>
							<cfoutput query="get_site_menu">
								<tr>
									<td><input name="menu_#menu_id#" id="menu_#menu_id#" type="checkbox" value="#site_domain#">#site_domain#&nbsp;</td>
								</tr>
							</cfoutput>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
		<br/>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr clasS="color-border">
					<td>
						<table width="100%" border="0" cellspacing="1" cellpadding="2">
							<tr class="color-row">
								<td valign="top">
									<table border="0">
										<tr> 
											<td valign="top"><br/><cf_get_lang no='427.Ders İçeriği'></td>
											<td valign="top">
                                            <cf_html_edit field_name="class_objective" form_name="add_event" width="800" height="150"  folder="#file_web_path#training/" image_upload="1" module="training">
                                                <!---<cfmodule
                                                    template="/fckeditor/fckeditor.cfm"
                                                    toolbarSet="WRKContent"
                                                    basePath="/fckeditor/"
                                                    instanceName="class_objective"
                                                    valign="top"
                                                    value=""
                                                    width="600"
                                                    height="300">--->
                                            <td> 
										<tr> 
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
<script type="text/javascript">
var temp=add_event.training_id;

function redirect(x)
{
	for (m=temp.options.length-1;m>0;m--)
		temp.options[m] = null;
	for (i=0;i<group[x].length;i++)
		temp.options[i]=new Option(group[x][i].text,group[x][i].value);

	temp.options[0].selected=true;
}
function check()
{
	if (document.add_event.training_cat_id.value =='' || document.add_event.training_cat_id.value == 0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='74.Kategori'>");
			return false;
		}
	
	if ( (add_event.start_date.value != "") && (add_event.finish_date.value != "") )
		return time_check(add_event.start_date, add_event.event_start_clock, add_event.event_start_minute, add_event.finish_date,  add_event.event_finish_clock, add_event.event_finish_minute, "<cf_get_lang dictionary_id='54749.Ders Başlama Tarihi Bitiş Tarihinden önce olmalıdır'>!");
	return true;
	
}
function kontrol()
{
	/*x = (750 - document.add_event.class_objective.value.length);
	if ( x < 0)
	{ 
		alert ("<cf_get_lang no='121.Eğitim İçeriğindeki Fazla Karakter Sayısı'>"+ ((-1) * x));
		return false;
	}*/
	if(add_event.class_announcement.value.length > 1500)
	{
		alert("<cf_get_lang no='91.Ders Duyurusu Karakter Sayısı Maksimum'>: 1500 !");
		return false;
	}
	if(add_event.class_objective.value.length > 4000)
	{
		alert("<cf_get_lang no='103.Ders İçeriğinin Karakter sayısı 4000 den fazla olamaz'>!");
		return false;
	}
	add_event.hour_no.value = filterNum(add_event.hour_no.value);
	add_event.date_no.value = filterNum(add_event.date_no.value);
	if((add_event.start_date.value == "") && (add_event.finish_date.value == ""))
	{
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='447.Başlangıç Bitiş Tarihi '>/<cf_get_lang no='250.ay'>!");
		return false;
	}
	return check();
	
}

function wiew_control(type)
{
	if(type==1)
	{
		document.add_event.is_wiew_branch.checked=false;
		document.add_event.is_wiew_department.checked=false;
	}
	if(type==2)
	{
		document.add_event.VIEW_TO_ALL.checked=false;
		document.add_event.is_wiew_department.checked=false;
	}
	if(type==3)
	{
		document.add_event.VIEW_TO_ALL.checked=false;
		document.add_event.is_wiew_branch.checked=false;
	}
}

function get_tran_sec(cat_id)
{
		
		
		document.add_event.training_sec_id.options.length = 0;
		var get_sec = wrk_safe_query('trn_get_sec','dsn',0,cat_id);
		document.add_event.training_sec_id.options[0]=new Option('Bölüm !','0')
		for(var jj=0;jj<get_sec.recordcount;jj++)
		{
			document.add_event.training_sec_id.options[jj+1]=new Option(get_sec.SECTION_NAME[jj],get_sec.TRAINING_SEC_ID[jj])
		}
}
</script>
