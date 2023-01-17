<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.online" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project" default="">
<cfparam name="attributes.training_cat_id" default="">
<cfparam name="attributes.training_sec_id" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.train_id" default="">
<cfparam name="attributes.train_head" default="">
<cfsavecontent variable="ocak"><cf_get_lang_main no='180.Ocak'></cfsavecontent> 
<cfsavecontent variable="subat"><cf_get_lang_main no='181.şubat'></cfsavecontent> 
<cfsavecontent variable="mart"><cf_get_lang_main no='182.mart'></cfsavecontent> 
<cfsavecontent variable="nisan"><cf_get_lang_main no='183.nisan'></cfsavecontent> 
<cfsavecontent variable="mayis"><cf_get_lang_main no='184.mayıs'></cfsavecontent> 
<cfsavecontent variable="haziran"><cf_get_lang_main no='185.haziran'></cfsavecontent> 
<cfsavecontent variable="temmuz"><cf_get_lang_main no='186.temmuz'></cfsavecontent> 
<cfsavecontent variable="agustos"><cf_get_lang_main no='187.ağustos'></cfsavecontent> 
<cfsavecontent variable="eylul"><cf_get_lang_main no='188.eylül'></cfsavecontent> 
<cfsavecontent variable="ekim"><cf_get_lang_main no='189.ekim'></cfsavecontent> 
<cfsavecontent variable="kasim"><cf_get_lang_main no='190.kasım'></cfsavecontent>  
<cfsavecontent variable="aralik"><cf_get_lang_main no='191.aralık'></cfsavecontent> 
<cfset my_month_list="#ocak#,#subat#,#mart#,#nisan#,#mayis#,#haziran#,#temmuz#,#agustos#,#eylul#,#ekim#,#kasim#,#aralik#">
<cfset url_str = "">
	<cfset bu_ay=Month(now())>
	<cfif isdefined("attributes.form_submitted")>
		<cfinclude template="../query/get_class_ex_class.cfm">
	<cfelse>
		<cfset get_class_ex_class.recordcount = 0>
	</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_class_ex_class.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form1" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_class#url_str#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#" maxlength="50"style="width:100px;">
				</div>
				<div class="form-group" >
					<div class="input-group">
						<cfif len(attributes.project_id) and len(attributes.project)>
							<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
							<input type="text" name="project" id="project" placeholder="<cfoutput>#getLang('main',4)#</cfoutput>" value="<cfoutput>#attributes.project#</cfoutput>" onfocus="AutoComplete_Create('project','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form1','3','250');" autocomplete="off">
						<cfelse>
							<input type="hidden" name="project_id" id="project_id" value="">
							<input type="text" name="project" id="project" value="" placeholder="<cfoutput>#getLang('main',4)#</cfoutput>" onfocus="AutoComplete_Create('project','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form1','3','250');" autocomplete="off">					
						</cfif>
						<span class="input-group-addon icon-ellipsis btnPointer"  onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form1.project_id&project_head=form1.project');"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang_main no ='1080.Tarihi Kontrol Edini'></cfsavecontent>
						<cfinput name="date1" type="text" value="#dateformat(attributes.date1,dateformat_style)#" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
					</div>
				</div>						
				<div class="form-group medium">
					<select name="IC_DIS" id="IC_DIS">
						<option value=""><cf_get_lang_main no='218.Tip'></option>
						<option value="0" <cfif isdefined('attributes.ic_dis') and attributes.ic_dis eq 0>selected</cfif>><cf_get_lang_main no='1149.İç'></option>
						<option value="1" <cfif isdefined('attributes.ic_dis') and attributes.ic_dis eq 1>selected</cfif>><cf_get_lang_main no='1150.Dış'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="online">
						<option value=""<cfif attributes.online is ""> selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
						<option value="1"<cfif attributes.online is "1"> selected</cfif>><cf_get_lang_main no='2218.Online'></option>
						<option value="0"<cfif attributes.online is "0"> selected</cfif>><cf_get_lang no='159.Online Değil'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">	
					<div class="form-group " id="item-training_cat">
						<label class="col col-12"><cf_get_lang_main no='74.Kategori'></label>
						<div class="col col-12">
							<cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
							<cf_wrk_selectlang
							name="training_cat_id"
							width="135"
							option_name="training_cat"
							option_value="training_cat_id"
							option_text="#text#"
							table_name="TRAINING_CAT"
							value="#attributes.training_cat_id#">
						</div>
					</div>
					<div class="form-group" id="item-training_sec_id">
						<label class="col col-12"><cf_get_lang_main no='583.Bölüm'></label>
						<div class="col col-12">
							<cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
							<cf_wrk_selectlang
							name="training_sec_id"
							width="135"
							table_name="TRAINING_SEC"
							value="#attributes.training_sec_id#"
							option_text="#text#"
							option_name="section_name"
							option_value="training_sec_id">
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group " id="item-emp_id">
						<label class="col col-12"><cf_get_lang_main no='1983.Katılımcı'></label>
						<div  class="col col-12">
							<div class="input-group">
								<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">
								<input type="hidden" name="par_id" id="par_id" value="<cfoutput>#attributes.par_id#</cfoutput>">
								<input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#attributes.cons_id#</cfoutput>">
								<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
								<cf_wrk_employee_positions form_name='form1' emp_id='emp_id' emp_name='member_name'>
								<cfinput type="text" name="member_name" value="#attributes.member_name#" style="width:120px;" onKeyUp="get_emp_pos_1();" onFocus="AutoComplete_Create('member_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','100');">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form1.emp_id&field_name=form1.member_name&field_type=form1.member_type&field_partner=form1.par_id&field_consumer=form1.cons_id&select_list=1,2,3&keyword='+encodeURIComponent(document.form1.member_name.value)</cfoutput>,'list')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-train_id">
						<label class="col col-12"><cf_get_lang_main no='68.Konu'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfinput type="hidden" name="train_id" id="train_id" value="#attributes.train_id#">
								<cfinput type="text" name="train_head" id="train_head" value="#attributes.train_head#" style="width:150px;">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_list_training_subjects&field_id=form1.train_id&field_name=form1.train_head</cfoutput>','list');"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang("","",58063)#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_class_id', print_type : 320 }#">
	

		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='46015.Ders'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='30916.Eğitim Yeri'></th>
					<th><cf_get_lang dictionary_id='30935.Eğitimci'></th>
					<th><cf_get_lang dictionary_id='30631.Tarih'></th>
					<th><cf_get_lang dictionary_id='61446.Eğitim Linki'></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.list_class&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
						<cfif  get_class_ex_class.recordcount>
							<th width="20" nowrap="nowrap" class="text-center header_icn_none">
								<cfif get_class_ex_class.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a> </cfif> 
								<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_class_id');">
							</th>
						</cfif>
				</tr>
			</thead>
			<tbody>
				<cfset aktif_egitim = 0>
				<cfset planlanan_egitim = 0>
				<cfset online_egitim = 0>
				<cfset biten_egitim = 0>
				<cfif get_class_ex_class.recordcount>
					<cfoutput query="get_class_ex_class" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#class_id#" class="tableyazi">#class_name#</a></td>				
							<td><cfif TYPE eq 1><cf_get_lang dictionary_id='58562.Dış'><cfelse><cf_get_lang dictionary_id='58561.İç'></cfif></td>
							<td>#CLASS_PLACE#</td>
							<td>
								<!--- <cfif len(TRAINER_EMP)>
									#get_emp_info(TRAINER_EMP,0,1)#
								<cfelseif len(TRAINER_PAR)>
									#get_par_info(TRAINER_PAR,0,0,1)#
								<cfelseif len(TRAINER_CONS)>
									#get_cons_info(TRAINER_CONS,0,1)#
								</cfif> --->
								<cfset getComponent = createObject('component','V16.project.cfc.get_project_detail')>
								<cfscript>
									get_trainers = createObject("component","V16.training_management.cfc.get_class_trainers");
									get_trainers.dsn = dsn;
									get_trainer_names = get_trainers.get_classes
													(
														module_name : fusebox.circuit,
														class_id : class_id
													);
								</cfscript>
								<cfloop query="get_trainer_names">
									<cfif TRAINER_DETAIL eq 'Çalışan'>
										<div class="ui-list-text">
											<span class="name">#get_emp_info(get_trainer_names.T_ID,0,0)#</span>
										</div>
									<cfelseif TRAINER_DETAIL eq 'Bireysel'>
										<div class="ui-list-text">
											<span class="name">#get_cons_info(T_ID,1,0)#</span>
										</div>
									<cfelseif TRAINER_DETAIL eq 'Kurumsal'>
										<cfset GET_COMPANY_PARTNER = getComponent.GET_COMPANY_PARTNER(PARTNER_ID :T_ID)>
										<cfset member_name_ = '#GET_COMPANY_PARTNER.COMPANY_PARTNER_NAME# #GET_COMPANY_PARTNER.COMPANY_PARTNER_SURNAME#-#GET_COMPANY_PARTNER.NICKNAME#'>
										<div class="ui-list-text">
											<span class="name">#member_name_#</span>
										</div>
									</cfif>
								</cfloop>
							</td>
							<td>
								<cfset flag_finished=0>
								<cfif LEN(start_date) AND start_date GT '1/1/1900' and LEN(finish_date) AND finish_date GT '1/1/1900'>
									<cfif dateformat(start_date,'yyyy-mm-dd') eq dateformat(now(),'yyyy-mm-dd') or 
										dateformat(finish_date,'yyyy-mm-dd') eq dateformat(now(),'yyyy-mm-dd') or 
										(dateformat(start_date,'yyyy-mm-dd') LT dateformat(now(),'yyyy-mm-dd') and 
										dateformat(finish_date,'yyyy-mm-dd') GT dateformat(now(),'yyyy-mm-dd') )>
										<font  color="##FF0000"> 
										<cfset online_egitim = 1>
										<cfset aktif_egitim = aktif_egitim + 1>
									<cfelseif dateformat(start_date,'yyyy-mm-dd') GT dateformat(now(),'yyyy-mm-dd')>
										<cfset planlanan_egitim = planlanan_egitim + 1>
										<font  color="##000000"> 
									<cfelseif dateformat(finish_date,'yyyy-mm-dd') LT dateformat(now(),'yyyy-mm-dd')>
										<cfset biten_egitim = biten_egitim + 1>
										<font color="##FF00FF">
									</cfif>
									<cfset startdate = date_add('h', session.ep.time_zone, start_date)>
									<cfset finishdate = date_add('h', session.ep.time_zone, finish_date)>
									#dateformat(startdate,dateformat_style)# (#timeformat(startdate,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#) 
								<cfelseif LEN(MONTH_ID) AND MONTH_ID>
									<cfif MONTH_ID lt bu_ay>
										<cfset color_="FF00FF">
									<cfelseif MONTH_ID gte bu_ay>
										<cfset color_="000000">
									<cfelseif MONTH_ID eq bu_ay>
										<cfset color_="FF0000">
									<cfelse>
										<cfset color_="000000">
									</cfif>
									<font color="#color_#">
										#ListGetAt(my_month_list,MONTH_ID)# - #SESSION.EP.PERIOD_YEAR#
									</font>
									<cfset planlanan_egitim = planlanan_egitim + 1>
								</cfif>
							</td>							
							<td>
								<cfscript>
									local = {};
									local.start = timeformat(start_date,timeformat_style);
									local.end = timeformat(finish_date,timeformat_style);
									local.today = timeformat(now(),timeformat_style);
									local.valid = false;
									if ( (dateDiff("h", local.start, local.today) >= 0) 
											AND (dateDiff("h", local.today, local.end) >= 0) ){
										local.valid = true;
									}
								</cfscript>
								<cfif LEN(start_date) and LEN(finish_date) and get_class_ex_class.online eq 1 AND len(get_class_ex_class.TRAINING_LINK) and online_egitim eq 1>
									<a target="_blank" href="#get_class_ex_class.TRAINING_LINK#" class="tableyazi" <cfif local.valid eq false>onclick="return false;"</cfif>>
										<i class="fa fa-coffee"></i>
									</a>
								</cfif>
							</td>	
							<!-- sil -->
							<td><a href="#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#class_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
							<td style="text-align:center"><input type="checkbox" name="print_class_id" id="print_class_id" value="#class_id#"></td>
							<!-- sil -->
							</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'><cfelse><cf_get_lang_main no='289.Filtre Ediniz '></cfif>!</td>
					</tr>
				</cfif>
			</tbody>			
		</cf_grid_list>
		<div class="ui-info-bottom">
            <cfoutput>
				<p><b><cf_get_lang no='56.Biten Eğitimler'>:</b> #biten_egitim# / <b><cf_get_lang no='366.Aktif Eğitimler'>:</b> #aktif_egitim# / <b><cf_get_lang no='367.Planlanan Eğitimler'>:</b> #planlanan_egitim#</p>
			</cfoutput>
        </div>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.form_submitted")>
				<cfset url_str ="#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.online)>
				<cfset url_str = "#url_str#&online=#attributes.online#">
			</cfif>
			<cfif len(attributes.date1)>
				<cfset url_str = "#url_str#&date1=#attributes.date1#">					  
			</cfif>
			<cfif not isdefined("attributes.yil")>
				<cfset attributes.yil="">
			</cfif>
			<cfif isdefined("attributes.yil_src")>
				<cfset url_str = "#url_str#&yil_src=#attributes.yil_src#">
			</cfif>
			<cfif isDefined("attributes.training_sec_id")>
				<cfset url_str = "#url_str#&training_sec_id=#attributes.training_sec_id#">
			</cfif>
			<cfif isDefined("attributes.training_cat_id")>
				<cfset url_str = "#url_str#&training_cat_id=#attributes.training_cat_id#">
			</cfif>
			<cfif isDefined("attributes.ic_dis")>
				<cfset url_str = "#url_str#&ic_dis=#attributes.ic_dis#">
			</cfif>
			<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)>
				<cfset url_str= "#url_str#&emp_id=#attributes.emp_id#">
			</cfif>
			<cfif isdefined("attributes.par_id") and len(attributes.par_id)>
				<cfset url_str= "#url_str#&par_id=#attributes.par_id#">
			</cfif>
			<cfif isdefined("attributes.cons_id") and len(attributes.cons_id)>
				<cfset url_str= "#url_str#&cons_id=#attributes.cons_id#">
			</cfif>
			<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
				<cfset url_str= "#url_str#&member_type=#attributes.member_type#">
			</cfif>
			<cfif isdefined("attributes.member_name") and len(attributes.member_name)>
				<cfset url_str= "#url_str#&member_name=#attributes.member_name#">
			</cfif>
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="training_management.list_class#url_str#&is_form_submitted=1">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>