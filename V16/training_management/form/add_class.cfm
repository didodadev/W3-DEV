<cf_xml_page_edit fuseact="training_management.form_add_class">
<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfinclude template="../query/get_training_eval_quizs.cfm">
<cfset GET_SITE_MENU = cmp.GET_SITE_MENU_F()>
<cfset GET_COMPANIES = cmp.GET_COMPANIES_F()>
<cfset FIND_DEPARTMENT_BRANCH = cmp.FIND_DEPARTMENT_BRANCH_F()>
<cfset GET_LANGUAGE = cmp.GET_LANGUAGE_F()>
<cf_catalystHeader>
<cfform name="add_class_form" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_class">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2" divLang="Temel Bilgiler;Detay;">
				<div id="unique_sayfa_1" class="ui-info-text uniqueBox">
					<cf_box_elements vertical="1">
						<div class="col col-5 col-sm-12 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="url_training_" style="display:none;">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='30015.Online'></label>
								<div class="col col-10 col-sm-6 col-xs-12">									
									<cfoutput>
									<div class="input-group">	
										<cfinput type="text" name="url_training" id="url_training">
										<a class="input-group-addon btnPointer" target="_blank" onclick="return false;">
										<i class="fa fa-coffee"></i></a>
									</cfoutput>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-training_style">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang no ='29.Eğitim Şekli'></label>
								<div class="col col-10 col-sm-6 col-xs-12">
									<cf_wrk_selectlang
										name="training_style"
										option_name="TRAINING_STYLE"
										option_value="training_style_id"
										table_name="SETUP_TRAINING_STYLE"
										width="250">
								</div>
							</div>
							<div class="form-group" id="item-training_cat">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang_main no='74.kategori'>*</label>
								<div class="col col-10 col-sm-6 col-xs-12">
									<cf_wrk_selectlang
										name="training_cat_id"
										option_name="training_cat"
										option_value="training_cat_id"
										table_name="TRAINING_CAT"
										width="250"
										onchange="showSection(this.value);">
								</div>
							</div>
							<div class="form-group" id="item-section_place" >
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang_main no='583.bölüm'></label>
								<div class="col col-10 col-sm-6 col-xs-12" id="section_place" >
									<cf_wrk_selectlang
										name="training_sec_id"
										width="250"
										option_name="SECTION_NAME"
										option_value="TRAINING_SEC_ID"
										table_name="TRAINING_SEC">
								</div>	
							</div>
							<div class="form-group" id="item-class_name">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='46015.Ders'> *</label>
								<div class="col col-10 col-sm-6 col-xs-12">
									<!--- <cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='426.Ders '></cfsavecontent>  --->
									<cfinput type="text" name="class_name" id="class_name" maxlength="100"><!--- required="Yes" message="#message#" --->
								</div>
							</div>
							<div class="form-group" id="item-train_id">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='46049.Müfredat'></label>
								<div class="col col-10 col-sm-6 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="train_id" id="train_id" value="">
										<input type="text" name="train_head" id="train_head" value="" >
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_list_training_subjects&field_id=add_class_form.train_id&field_name=add_class_form.train_head&field_cat_id=add_class_form.training_cat_id&field_sec_id=add_class_form.training_sec_id&field_training_style=add_class_form.training_style</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-class_place" >
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang no='187.Eğitim Yeri'></label>
								<div class="col col-10 col-sm-6 col-xs-12"><cfinput type="text" name="class_place" id="class_place" maxlength="100"></div>
							</div>
							<div class="form-group" id="item-class_place_address"> 
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang no='30.Eğitim Yeri Adresi'></label>
								<div class="col col-10 col-sm-6 col-xs-12"><cfinput type="text" name="class_place_address" id="class_place_address" value="" maxlength="100"></div>
							</div>
							<div class="form-group" id="item-class_place_tel"> 
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang no='34.Eğitim Yeri Telefonu'></label>
								<div class="col col-10 col-sm-6 col-xs-12"><cfinput type="text" name="class_place_tel" id="class_place_tel" value="" maxlength="100" validate="integer" onKeyUp="isNumber(this);"></div>
							</div>
							<div class="form-group" id="item-class_place_manager" >
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang no='35.Eğitim Yeri Sorumlusu'></label>
								<div class="col col-10 col-sm-6 col-xs-12"><cfinput type="text" name="class_place_manager" id="class_place_manager" value="" maxlength="100"></div>
							</div>
							<div class="form-group" id="item-class_announcement">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang no='425.Ders Duyurusu'></label>
								<div class="col col-10 col-sm-6 col-xs-12"><textarea name="class_announcement" id="class_announcement"></textarea></div>
							</div>	
						</div>
						<div class="col col-5 col-sm-12 col-xs-12" type="column" index="2" sort="true">
							<!-- sağ blok -->
							<div class="form-group" id="item-language_id">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang_main no='1584.Dil'> *</label>
								<div class="col col-10 col-sm-6 col-xs-12">
									<select name="language_id" id="language_id">
											<cfoutput query="get_language">
												<option value="#language_short#">#language_set#</option>
											</cfoutput>
									</select>	
								</div>
							</div>
							<div class="form-group" id="item-process">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
								<div class="col col-10 col-sm-6 col-xs-12">	<cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'></div>	
							</div>
							<div class="form-group" id="item-start_date"> 
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang_main no='89.başlama'>*</label>
								<div class="col col-4 col-sm-6 col-xs-12">
									<div class="input-group">	
										<!--- <cfsavecontent variable="message"> <cf_get_lang_main no='782.zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent> --->
										<cfinput validate="eurodate" type="text" name="start_date" id="start_date" maxlength="10"><!--- message="#message#" --->
										<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
									</div>	
								</div>
								<label class="col col-2 col-sm-6 col-xs-12"> <cf_get_lang no='119.saat / dk'>*:</label>
								<div class="col col-2 col-sm-6 col-xs-6">
									<cf_wrkTimeFormat name="event_start_clock" value="0">
								</div>
								<div class="col col-2 col-sm-6 col-xs-6">
									<select name="event_start_minute" id="event_start_minute">
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
								</div>
							</div>
							<div class="form-group" id="item-finish_date">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang_main no='90.bitiş'>*</label>
								<div class="col col-4 col-sm-6 col-xs-12">
									<div class="input-group">
										<!--- <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent> --->
										<cfinput type="text" name="finish_date" id="finish_date" validate="eurodate" maxlength="10"><!--- message="#message#" --->
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
									</div>
								</div>
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang no='119.saat / dk'>*:</label>
								<div class="col col-2 col-sm-6 col-xs-6">
									<cf_wrkTimeFormat name="event_finish_clock" value="0">
								</div>
								<div class="col col-2 col-sm-6 col-xs-6">
									<select name="event_finish_minute" id="event_finish_minute">
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
								</div>
							</div>
							<div class="form-group" id="item-max_participation">
								<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang no='445.Maksimum Katılımcı'></label>
								<div class="col col-2 col-sm-6 col-xs-12"><cfinput type="text" name="max_participation" id="max_participation" validate="integer" onKeyUp="isNumber(this);"></div>
								<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='62065.Online Maksimum Başvuru'></label>
								<div class="col col-2 col-sm-6 col-xs-12">	<cfinput type="text" name="max_self_service" id="max_self_service" validate="integer" onKeyUp="isNumber(this);"></div>
							</div>
							<div class="form-group" id="item-date_no">
								<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang no='169.Toplam Gün'>*</label>
								<div class="col col-2 col-sm-6 col-xs-12">
									<!--- <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='169.toplam Gün'></cfsavecontent> --->
									<cfinput type="text" name="date_no" id="date_no" onKeyUp='return(FormatCurrency(this,event));' maxlength="100"><!--- required="Yes" message="#message#" --->
								</div>
								<label class="col col-4 col-sm-6 col-xs-12">
									<cf_get_lang_main no='80.toplam'><cf_get_lang_main no='79.Saat'>*
									<!--- <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='170.toplam saat'></cfsavecontent>  --->
								</label>
								<div class="col col-2 col-sm-6 col-xs-12">
									<cfinput type="text" name="hour_no" id="hour_no" onKeyUp='return(FormatCurrency(this,event));' maxlength="100"> <!--- required="Yes" message="#message#" --->
								</div>
							</div>
							<div class="form-group" id="item-stock_id">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang_main no='245.Ürün'></label>
								<div class="col col-10 col-sm-6 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="stock_id" id="stock_id" value="">
										<input type="text" name="product_name" id="product_name" value="" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id,','','3','200');" autocomplete="off">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_class_form.stock_id&field_name=add_class_form.product_name','list');"></span>			
									</div>
								</div>
							</div>
							<div class="form-group" id="item-class_tools" >
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang_main no='2.Araçlar'></label>
								<div class="col col-10 col-sm-6 col-xs-12"><textarea name="class_tools" id="class_tools"></textarea></div>
							</div>
							<div class="form-group" id="item-class_target" >
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang no='32.Amaç'></label>
								<div class="col col-10 col-sm-6 col-xs-12"><textarea name="class_target" id="class_target"></textarea></div>
							</div>
							<div class="form-group" id="item-project_id">
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
								<div class="col col-10 col-sm-6 col-xs-12">
									<div class="input-group">								
										<input type="hidden" name="project_id" id="project_id" value="">
										<input type="text" name="project_head" id="project_head" value="">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_class_form.project_id&project_head=add_class_form.project_head');"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-2 col-sm-12 col-xs-12" type="column" index="3" sort="true">	
							<div class="form-group">
								<label><input type="checkbox" name="online" id="online" value="1" onclick="gizle_goster(url_training_);"><cf_get_lang_main no='2218.online'></label>
						
								<label><input type="checkbox" name="is_net_display" id="is_net_display" value="1" onclick="gizle_goster(is_site_display);"><cf_get_lang no='40.İnternette Gözüksün'></label>
							
								<label><input type="checkbox" name="is_active" id="is_active" value="1" checked="checked"><cf_get_lang_main no='81.Aktif'> &nbsp;</label>

								<cfoutput>
									<label>
										<input type="Checkbox" name="view_to_all" id="view_to_all" value="1" onclick="wiew_control(1);"><cf_get_lang no='44.Bu olayı herkes görsün'>
									</label>	
									<label>
										<input type="checkbox" name="is_wiew_branch" id="is_wiew_branch" value="#find_department_branch.branch_id#" onclick="wiew_control(2);">
										<cf_get_lang_main no='502.Şubemdeki Herkes Görsün'>
									</label>
									<label>
										<input type="hidden" name="is_wiew_branch_" id="is_wiew_branch_" value="#find_department_branch.branch_id#">
										<input type="checkbox" name="is_wiew_department" id="is_wiew_department" value="#find_department_branch.department_id#" onclick="wiew_control(3);">
										<cf_get_lang_main no='503.Departmanımdaki Herkes Görsün'>
									</label>
									<label>
										<input type="checkbox" name="is_view_comp" id="is_view_comp" value="#session.ep.company_id#" onclick="wiew_control(4);">
										Sadece Şirket Çalışanları Görsün
									</label>
								</cfoutput>
								<div class="form-group col col-3 col-xs-12" id="agenda_companies" style="display:none;">
									<cfif xml_multiple_comp>
										<select name="agenda_company" multiple="multiple">
											<cfoutput query="get_companies">
													<div id="agenda_companies" style="display:none;">
														<option value="#COMP_ID#" <cfif session.ep.company_id eq comp_id>selected</cfif>>#NICK_NAME#</option>
													</div>
											</cfoutput>
										</select>
									</cfif>
								</div>
							</div>
							
							<div class="form-group"  id="item-is_site_display">	
								<div id="is_site_display" style="display:none;">
									<div class="col col-12 col-sm-6 col-xs-12 formbold"><cf_get_lang no ='24.Yayınlanacak Site'></div>	
									<cfoutput query="get_site_menu">
										<div class="col col-12 col-sm-6 col-xs-12"> 
											<input name="menu_#menu_id#" id="menu_#menu_id#" type="checkbox" value="#menu_id#">
											#site_domain#&nbsp;</br>
										</div>
									</cfoutput>	
								</div>
							</div>
						</div>	
					</cf_box_elements>
				</div>
				<div id="unique_sayfa_2" class="ui-info-text uniqueBox">
					<cf_box_elements vertical="1">
						<div class="col col-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="item-editor">
								<label style="display:none!important;"><cf_get_lang_main no='241.İçerik'></label>
								<cfmodule template="/fckeditor/fckeditor.cfm"
								toolbarset="WRKContent"
								basepath="/fckeditor/"
								instancename="class_objective"
								value=""
								width="100%"
								maxCharCount="4000"
								valign="top">
							</div>
						</div>
					</cf_box_elements>
				</div>			
			</cf_tab>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box_footer>
					<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</div>
		</cf_box>
	</div>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		if (!process_cat_control()) return false;
		/* if(document.getElementById('online').checked == true && document.getElementById('emp_par_name').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='23.Eğitimci'>");
			return false;
		} */
		if (document.add_class_form.training_cat_id.value =='' || document.add_class_form.training_cat_id.value == 0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='74.kategori'>");
			return false;
		}
		if(document.getElementById('class_name').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='7.Eğitim'>");
			return false;
		}
		if(document.getElementById('class_announcement').value.length > 1500)
		{
			alert("<cf_get_lang no='91.Ders Duyurusu Karakter Sayısı Maksimum'>: 1500 !");
			return false;
		}
		/* if(add_class_form.class_objective.value.length > 4000)
		{
			alert("<cf_get_lang no='103.Ders İçeriğinin Karakter sayısı 4000 den fazla olamaz'>!");
			return false;
		} */
		if(document.getElementById('language_id').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1584.Dil'>");
			return false;
		}
		if(document.getElementById('start_date').value == "")
		{
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'> : <cf_get_lang no='447.Başlangıç Bitiş Tarihi '>");
			return false;
		}
		if(document.getElementById('finish_date').value == "")
		{
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'> : <cf_get_lang no='447.Başlangıç Bitiş Tarihi '>");
			return false;
		}
		if (document.add_class_form.event_start_clock.value =='' || document.add_class_form.event_start_clock.value == 0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : Başlangıç <cf_get_lang no='119.saat / dk'>");
			return false;
		}
		if (document.add_class_form.event_finish_clock.value =='' || document.add_class_form.event_finish_clock.value == 0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : Bitiş <cf_get_lang no='119.saat / dk'>");
			return false;
		}
		if(document.getElementById('date_no').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='169.toplam Gün'>");
			return false;
		}
		else
		{
			document.getElementById('date_no').value = filterNum(document.getElementById('date_no').value);
		}
		if (document.getElementById('hour_no').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='170.toplam saat'>");
			return false;
		}
		else
		{
			document.getElementById('hour_no').value = filterNum(document.getElementById('hour_no').value);
		}
		if ( (document.getElementById('start_date').value != "") && (document.getElementById('finish_date').value != "") && (document.getElementById('event_start_clock').value != "") && (document.getElementById('event_finish_clock').value != "") )
			return time_check(add_class_form.start_date, add_class_form.event_start_clock, add_class_form.event_start_minute, add_class_form.finish_date,add_class_form.event_finish_clock,add_class_form.event_finish_minute, "Ders Başlama Tarihi Bitiş Tarihinden önce olmalıdır!");
		return true;
	}
	
	function wiew_control(type)
	{
		if(type==1)
		{
			document.add_class_form.is_wiew_branch.checked=false;
			document.add_class_form.is_wiew_department.checked=false;
			document.getElementById('is_view_comp').checked = false;
		}
		if(type==2)
		{
			document.add_class_form.view_to_all.checked=false;
			document.add_class_form.is_wiew_department.checked=false;
			document.getElementById('is_view_comp').checked = false;
		}
		if(type==3)
		{
			document.add_class_form.view_to_all.checked=false;
			document.add_class_form.is_wiew_branch.checked=false;
			document.getElementById('is_view_comp').checked = false;
		}
		if(type==4)
		{
			document.add_class_form.view_to_all.checked=false;
			document.add_class_form.is_wiew_branch.checked=false;
			document.add_class_form.is_wiew_department.checked=false;
			<cfif xml_multiple_comp eq 1>
				if(document.getElementById('is_view_comp').checked ==false)
					document.getElementById('agenda_companies').style.display = 'none';
				else
					document.getElementById('agenda_companies').style.display = '';
			</cfif>
		}
	}
	
	function showSection(cat_id)	
	{
		var cat_id = document.add_class_form.training_cat_id.value;
		if (cat_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.popup_ajax_list_section&cat_id="+cat_id;
			AjaxPageLoad(send_address,'section_place',1,'İlişkili Bölümler');
			
		}
	}
	
	function get_class_name(id)
	{
		var get_class_name_ = wrk_safe_query('trn_get_class_name','dsn',0,id);
		document.getElementById('related_class_name').value = get_class_name_.CLASS_NAME;
	}	
</script>