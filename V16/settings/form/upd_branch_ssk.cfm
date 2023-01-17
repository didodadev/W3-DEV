<cf_get_lang_set module_name="settings">
	<cf_xml_page_edit fuseact="settings.popup_upd_branch_ssk">
<cfquery name="CATEGORY" datasource="#DSN#">
	SELECT * FROM BRANCH WHERE BRANCH_ID = #URL.ID#
</cfquery>
<cfif len(category.ssk_position_code)>
<cfquery name="GET_POS_DETAIL" datasource="#DSN#">
	SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #category.ssk_position_code#
</cfquery>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','settings',42354)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="branch" action="#request.self#?fuseaction=settings.emptypopup_branch_add_ssk" method="post" enctype="multipart/form-data">
			<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.id#</cfoutput>">
			<input type="hidden" name="upd_control" id="upd_control" value="<cfoutput>#attributes.upd_control#</cfoutput>">
			<cf_box_elements>
								<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-CAL_BOL_MUD_NAME">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42750.Çalışma Böl. Müd. Adı'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="Text" name="CAL_BOL_MUD_NAME" id="CAL_BOL_MUD_NAME"  value="<cfoutput>#CATEGORY.CAL_BOL_MUD_NAME#</cfoutput>" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-REAL_WORK">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42752.İşyerinde Yapılan İş'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="Text" name="REAL_WORK" id="REAL_WORK" value="<cfoutput>#CATEGORY.REAL_WORK#</cfoutput>" maxlength="50">
						</div>
					</div> 
					<div class="form-group" id="item-branch_work">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42358.İş Kolu'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<select name="branch_work" id="branch_work">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"<cfif category.branch_work eq 1> selected</cfif>>01-AVCILIK, BALIKÇILIK, TARIM VE ORMANCILIK</option>
								<option value="2"<cfif category.branch_work eq 2> selected</cfif>>02-GIDA SANAYİİ</option>
								<option value="3"<cfif category.branch_work eq 3> selected</cfif>>03-MADENCİLİK  VE TAŞ OCAKLARI</option>
								<option value="4"<cfif category.branch_work eq 4> selected</cfif>>04-PETROL, KİMYA, LASTİK, PLASTİK VE İLAÇ</option>
								<option value="5"<cfif category.branch_work eq 5> selected</cfif>>05-DOKUMA, HAZIR GİYİM VE DERİ</option>
								<option value="6"<cfif category.branch_work eq 6> selected</cfif>>06-AĞAÇ VE KÂĞIT</option>
								<option value="7"<cfif category.branch_work eq 7> selected</cfif>>07-İLETİŞİM</option>
								<option value="8"<cfif category.branch_work eq 8> selected</cfif>>08-BASIN, YAYIN  VE GAZETECİLİK</option>
								<option value="9"<cfif category.branch_work eq 9> selected</cfif>>09-BANKA, FİNANS  VE SİGORTA</option>
								<option value="10"<cfif category.branch_work eq 10> selected</cfif>>10-TİCARET, BÜRO, EĞİTİM VE GÜZEL SANATLAR</option>
								<option value="11"<cfif category.branch_work eq 11> selected</cfif>>11-ÇİMENTO, TOPRAK  VE CAM</option>
								<option value="12"<cfif category.branch_work eq 12> selected</cfif>>12-METAL</option>
								<option value="13"<cfif category.branch_work eq 13> selected</cfif>>13-İNŞAAT</option>
								<option value="14"<cfif category.branch_work eq 14> selected</cfif>>14-ENERJİ</option>									
								<option value="15"<cfif category.branch_work eq 15> selected</cfif>>15-TAŞIMACILIK</option>
								<option value="16"<cfif category.branch_work eq 16> selected</cfif>>16-GEMİ YAPIMI VE DENİZ TAŞIMACILIĞI, ARDİYE VE ANTREPOCULUK</option>
								<option value="17"<cfif category.branch_work eq 17> selected</cfif>>17-SAĞLIK  VE SOSYAL HİZMETLER</option>
								<option value="18"<cfif category.branch_work eq 18> selected</cfif>>18-KONAKLAMA  VE EĞLENCE İŞLERİ</option>									
								<option value="19"<cfif category.branch_work eq 19> selected</cfif>>19-SAVUNMA VE GÜVENLİK</option>
								<option value="20"<cfif category.branch_work eq 20> selected</cfif>>20-GENEL İŞLER</option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-danger_degree_no">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='43488.Kısa Vadeli Sigorta Kolları Prim Oranı'>*</label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='42684.Tehlike No Girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="danger_degree_no" value="#tlformat(category.danger_degree_no,2)#" required="yes" message="#message#" passthrough = "onKeyup='return(FormatCurrency(this,event,4));'" style="text-align:right;width:45px;">
						</div>
					</div>
					<div class="form-group" id="item-is_sakat_kontrol">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='43307.Sakat Kontrol'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="checkbox" name="is_sakat_kontrol" id="is_sakat_kontrol" value="1"<cfif category.is_sakat_kontrol eq 1> checked</cfif>>
						</div>
					</div>
					<div class="form-group" id="item-fileno">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='50431.Dosya No'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<cfinput type="text" id="file_no" name="file_no" value="#CATEGORY.file_no#">
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<textarea id="detail" name="detail" rows="4" cols="50" maxlength="250" message="#message#"><cfoutput>#category.detail#</cfoutput></textarea>
						</div>
					</div>  
                 
				</div>
				<div class="col col-12 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfsavecontent variable="head3"><cf_get_lang dictionary_id='62971.İşkur Bilgileri'></cfsavecontent>
						<cf_seperator id="sep3" header="#head3#">
					<div id="sep3" class="col-12">
					<div class="form-group" id="item-iskur_branch_name">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42776.İşkur Şube Adı'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="Text" name="iskur_branch_name" id="iskur_branch_name"  value="<cfoutput>#CATEGORY.iskur_branch_name#</cfoutput>" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-foundation_date">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42751.Şube İşe Başlama Tarihi'>*</label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='44140.Şube İşe Başlama Tarihi Giriniz'></cfsavecontent>
								<cfinput maxlength="10" required="Yes" validate="#validate_style#"  type="text" name="foundation_date" value="#dateformat(CATEGORY.foundation_date,dateformat_style)#" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="foundation_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-iskur_branch_no">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42749.İşkur Şube No'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="Text" name="iskur_branch_no" id="iskur_branch_no" value="<cfoutput>#CATEGORY.iskur_branch_no#</cfoutput>" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-iskur_tckimlik_no">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='44795.İşkur TC Kimlik No'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="Text" name="iskur_tckimlik_no" id="iskur_tckimlik_no" value="<cfoutput>#CATEGORY.iskur_tckimlik_no#</cfoutput>" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-iskur_password">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='44796.İşkur Şifre'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="Text" name="iskur_password" id="iskur_password" value="<cfoutput>#CATEGORY.iskur_password#</cfoutput>" maxlength="50">
						</div>
					</div>
				     </div>
					 <cfsavecontent variable="head1"><cf_get_lang dictionary_id='53552.SGK İşyeri'><cf_get_lang dictionary_id='37022.Bilgileri'></cfsavecontent>
						<cf_seperator id="sep_1" title="#head1#">
						<div id="sep_1">
							<div class="form-group" id="item-ssk_no">
								<label class="col col-1 col-md-1 col-sm-1 com-xs-12 bold"><cf_get_lang no='516.M'></label>
								<label class="col col-2 col-md-2 col-sm-2 com-xs-12 bold"><cf_get_lang no='375.İş Kolu'></label>
								<label class="col col-2 col-md-2 col-sm-2 com-xs-12 bold"><cf_get_lang no='2636.Ünite Kodu'></label>
								<label class="col col-2 col-md-2 col-sm-2 com-xs-12 bold"><cf_get_lang no='2635.İşyeri Sıra No'></label>
								<label class="col col-1 col-md-1 col-sm-1 com-xs-12 bold"><cf_get_lang_main no='1196.İl'></label>
								<label class="col col-1 col-md-1 col-sm-1 com-xs-12 bold"><cf_get_lang_main no='1226.İlçe'></label>
								<label class="col col-1 col-md-1 col-sm-1 com-xs-12 bold"><cf_get_lang no='2637.Kont'></label>
								<label class="col col-2 col-md-2 col-sm-2 com-xs-12 bold"><cf_get_lang no='1328.İşyeri Aracı'><cf_get_lang_main no='75.No'></label>
							</div>
							<div class="form-group" id="item-ssk_no2">
								<div class="col col-1 col-md-1 col-sm-1 com-xs-12 text-right">
									<cfinput type="text" name="ssk_m" value="#category.ssk_m#" maxlength="3" onkeyup="isNumber(this);process_focus('ssk_m');">
								</div>
								<div class="col col-2 col-md-2 col-sm-2 com-xs-12 text-right">
									<cfinput type="text" name="ssk_job" value="#category.ssk_job#" maxlength="6" onkeyup="isNumber(this);process_focus('ssk_job');">
								</div>
								<div class="col col-1 col-md-1 col-sm-1 com-xs-12 text-right">
									<cfinput type="text" name="ssk_branch" value="#category.ssk_branch#" maxlength="4" onkeyup="isNumber(this);process_focus('ssk_branch');">
								</div>
								<div class="col col-1 col-md-1 col-sm-1 com-xs-12 text-right">
									<cfinput type="text" name="ssk_branch_old" value="#category.ssk_branch_old#" maxlength="4" onkeyup="isNumber(this);process_focus('ssk_branch_old');">
								</div>
								<div class="col col-2 col-md-2 col-sm-2 com-xs-12 text-right">
									<cfinput type="text" name="ssk_no" value="#category.ssk_no#" maxlength="12" onkeyup="isNumber(this);process_focus('ssk_no');">
								</div>
								<div class="col col-1 col-md-1 col-sm-1 com-xs-12 text-right">
									<cfinput type="text" name="ssk_city" value="#category.ssk_city#" style="text-align:right;width:15px;" maxlength="4" onkeyup="isNumber(this);process_focus('ssk_city');">
								</div>
								<div class="col col-1 col-md-1 col-sm-1 com-xs-12 text-right">
									<cfinput type="text" name="ssk_country" value="#category.ssk_country#" maxlength="4" onkeyup="isNumber(this);process_focus('ssk_country');">
								</div>
								<div class="col col-1 col-md-1 col-sm-1 com-xs-12 text-right">
									<cfinput type="text" name="ssk_cd" value="#category.ssk_cd#" maxlength="4" onkeyup="isNumber(this);process_focus('ssk_cd');">
								</div>
								<div class="col col-2 col-md-2 col-sm-2 com-xs-12 text-right">
									<cfinput type="text" name="ssk_agent" value="#category.ssk_agent#" maxlength="5" onkeyup="isNumber(this);process_focus('ssk_agent');">
								</div>
							</div>                        
							<div class="form-group" id="item-ssk_office">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42355.SGK Şube'></label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
									<cfinput type="text" name="ssk_office" value="#category.ssk_office#" maxlength="250">
								</div>
							</div>
							<div class="form-group" id="item-work_zone_m">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42357.Çalışma Bölgesi'></label>
								<div class="col col-1 col-xs-2">
									<cfinput type="text" name="work_zone_m" value="#category.work_zone_m#" style="text-align:right" maxlength="3" onKeyUp="isNumber(this);">
								</div>
								<div class="col col-3 col-xs-4">
									<cfinput type="text" name="work_zone_job" value="#category.work_zone_job#" style="text-align:right" maxlength="10" onKeyUp="isNumber(this);">
								</div>
								<div class="col col-3 col-xs-4">
									<cfinput type="text" name="work_zone_file" value="#category.work_zone_file#" style="text-align:right" maxlength="10" onKeyUp="isNumber(this);">
								</div>
								<div class="col col-2 col-xs-2">
									<cfinput type="text" name="work_zone_city" value="#category.work_zone_city#" style="text-align:right" maxlength="4" onKeyUp="isNumber(this);">
								</div>
							</div>
							<div class="form-group" id="item-DANGER_DEGREE">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='42359.Tehlike Derecesi'></label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
									<label><cf_get_lang dictionary_id='57985.Üst'> <input type="radio" name="DANGER_DEGREE" id="DANGER_DEGREE" value="0" <cfif category.danger_degree eq 0> checked</cfif>></label>
									<label><cf_get_lang dictionary_id='42362.Normal'><input type="radio" name="DANGER_DEGREE" id="DANGER_DEGREE" value="1" <cfif category.danger_degree eq 1> checked</cfif>></label>
									<label><cf_get_lang dictionary_id='57986.Alt'><input type="radio" name="DANGER_DEGREE" id="DANGER_DEGREE" value="2" <cfif category.danger_degree eq 2> checked</cfif>></label>
								</div>
							</div>
							<div class="form-group" id="item-kanun_5084_oran">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12">5084 sayılı kanun</label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
									<select name="kanun_5084_oran" id="kanun_5084_oran">
										<option value="0"<cfif category.kanun_5084_oran eq 0> selected</cfif>><cf_get_lang dictionary_id='43309.Değil'></option>
										<option value="80"<cfif category.kanun_5084_oran eq 80> selected</cfif>>% 80 <cf_get_lang dictionary_id='43310.Tabi'></option>
										<option value="100"<cfif category.kanun_5084_oran eq 100> selected</cfif>>% 100  <cf_get_lang dictionary_id='43310.Tabi'></option>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-kanun_6486">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='64541.6486 sayılı kanun'></label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
									<select name="kanun_6486" id="kanun_6486">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="4"<cfif category.kanun_6486 eq 4> selected</cfif>>4 <cf_get_lang dictionary_id='58455.Yıl'></option>
										<option value="5"<cfif category.kanun_6486 eq 5> selected</cfif>>5 <cf_get_lang dictionary_id='58455.Yıl'></option>
										<option value="6"<cfif category.kanun_6486 eq 6> selected</cfif>>6 <cf_get_lang dictionary_id='58455.Yıl'></option>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-kanun_6322">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='64542.6322 sayılı kanun'></label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
									<select name="kanun_6322" id="kanun_6322">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="1"<cfif category.kanun_6322 eq 1> selected</cfif>>1-5. <cf_get_lang dictionary_id='60658.Bölgeler veya Gemi İnşa Yatırımı'></option>
										<option value="2"<cfif category.kanun_6322 eq 2> selected</cfif>>6.<cf_get_lang dictionary_id='57992.Bölge'></option>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-IS_5615_TAX_OFF">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12">5615 <cf_get_lang no='2814.Vergiden Yararlanamaz'></label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
									<input type="checkbox" name="IS_5615_TAX_OFF" id="IS_5615_TAX_OFF" value="1"<cfif category.IS_5615_TAX_OFF eq 1> checked</cfif>>
								</div>
							</div>
							<div class="form-group" id="item-is_5510">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang no ='2430.5 Puanlık İndirimden Yararlansın'> (5510)</label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
									<input type="checkbox" name="is_5510" id="is_5510" value="1" <cfif category.is_5510 eq 1>checked</cfif>>
								</div>
							</div>
							</div>
							<cfif get_module_user(48)>
								<cfsavecontent variable="head2"><cf_get_lang dictionary_id='44136.E-Bildirge Şifre Bilgileri'></cfsavecontent>
								<cf_seperator id="sep2" header="#head2#">
								<div id="sep2">
									<div class="form-group" id="item-open_date">
										<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='44137.Açılış Tarihi'></label>
										<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
											<div class="input-group">
												<cfinput maxlength="10" validate="#validate_style#"  type="text" name="open_date" style="width:135px;" value="#dateformat(CATEGORY.open_date,dateformat_style)#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="open_date"></span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-tckimlik_no">
										<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></label>
										<div class="col col-6 col-xs-9"> 
											<cfinput type="text" name="tckimlik_no" value="#category.tckimlik_no#" maxlength="11">
										</div>
										<div class="col col-3 col-xs-3"> 
											<cfinput type="text" name="user_name" value="#category.user_name#" maxlength="3">
										</div>
									</div>
									<div class="form-group" id="item-system_password">
										<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='39984.Sistem Şifresi'></label>
										<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
											<cfinput type="text" name="system_password" value="#category.system_password#" maxlength="10">
										</div>
									</div>
									<div class="form-group" id="item-company_password">
										<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='44138.İşyeri Şifresi'></label>
										<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
											<cfinput type="text" name="company_password" value="#category.company_password#" maxlength="10">
										</div>
									</div>
									<div class="form-group" id="item-employee_position_name">
										<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
										<div class="col col-5 col-md-5 col-sm-5 col-xs-12"> 
											<cfinput type="hidden" name="employee_id" value="#category.ssk_employee_id#">
											<cfinput type="hidden" name="to_position_code" value="#category.ssk_position_code#">
											<cfinput type="text" name="employee_name" value="#category.EMPLOYEE_SYSTEM_NAME#">
										</div>
											<div class="col col-4 col-md-4 col-sm-4 col-xs-12"> 
												<div class="input-group">
											<input type="text" name="position_name" id="position_name" value="<cfoutput>#category.position_name#</cfoutput>">
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=to_position_code&field_name=employee_name&field_emp_id=employee_id&field_pos_name=position_name&select_list=1');"></span>
										</div>
									</div>
								</div>                  
						    </cfif>
						</div>
						<cfif is_KBS_Government_Retirement_Fund eq 1>
							<cfsavecontent variable="head5"><cf_get_lang dictionary_id='62974.KBS'><cf_get_lang dictionary_id='57989.Ve'><cf_get_lang dictionary_id='56422.Emekli Sandığı'></cfsavecontent>
								<cf_seperator id="sep5" header="#head5#">
								<div id="sep5">
							   <div class="form-group" id="item-acc_unit_code">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57447.Muhasebe'><cf_get_lang dictionary_id='57636.Birim'><cf_get_lang dictionary_id='50905.Kodu'></label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
									<cfinput type="text" onkeyup="isNumber(this)"  id="acc_unit_code" name="acc_unit_code" value="#CATEGORY.ACC_UNIT_CODE#">
								</div>
							  </div>  
							  <div class="form-group" id="item-add_company_name">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57447.Muhasebe'><cf_get_lang dictionary_id='43106.Kurum Adı'></label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
									<cfinput type="text" id="acc_company_name" name="acc_company_name" value="#CATEGORY.ACC_COMP_NAME#">
								</div>
							  </div>  <cfoutput>
								<div class="form-group" id="item-unit_code_">
									<label class="col col-3 col-md-3 col-sm-3 com-xs-12 bold"></label>
									<label class="col col-1 col-md-1 col-sm-1 col-xs-12 bold"><cf_get_lang dictionary_id='51485.Kurum Kodu'></label>
									<label class="col col-2 col-md-2 col-sm-2 com-xs-12 bold"><cf_get_lang dictionary_id='64462.Saymanlık Numarası'></label>
									<label class="col col-2 col-md-2 col-sm-2 com-xs-12 bold"><cf_get_lang dictionary_id='64463.Kurum Numarası'></label>
									
									<label class="col col-2 col-md-2 col-sm-2 com-xs-12 bold"><cf_get_lang dictionary_id='64464.Harcama Birim Kodu'></label>
									<label class="col col-2 col-md-2 col-sm-2 com-xs-12 bold"></label>
								</div>
							  <div class="form-group" id="item-unit_code">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='51532.Harcama'><cf_get_lang dictionary_id='57636.Birim'><cf_get_lang dictionary_id='50905.Kodu'> </label>
								<div class="col col-1 col-md-1 col-sm-1 col-xs-12"> 
									<input type="text" onkeyup="isNumber(this)" name="exp_unit_code1"  id="exp_unit_code1" value="#CATEGORY.EXPENSE_UNIT_CODE1#">
								</div>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
									<input type="text" onkeyup="isNumber(this)"  name="exp_unit_code2" id="exp_unit_code2" value="#CATEGORY.EXPENSE_UNIT_CODE2#">
									</div>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
									<input type="text" onkeyup="isNumber(this)"  name="exp_unit_code3" id="exp_unit_code3" value="#CATEGORY.EXPENSE_UNIT_CODE3#">
									</div>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
									<input type="text" onkeyup="isNumber(this)"  name="exp_unit_code4" id="exp_unit_code4" value="#CATEGORY.EXPENSE_UNIT_CODE4#">
									</div>
									<div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
									<input type="text" onkeyup="isNumber(this)"  name="exp_unit_code5" id="exp_unit_code5" value="#CATEGORY.EXPENSE_UNIT_CODE5#">
									</div>
							  </div></cfoutput>
							  <div class="form-group" id="item-alpha">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='62975.Harcama Birimi'> </label>
										<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
										<input type="text" name="alpha" id="alpha" value="<cfoutput>#CATEGORY.EXPENSE_ALPHA#</cfoutput>">
									   </div>
							  </div>
								<div class="form-group" id="item-expense_id">
									<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='62976.Harcama Yetkilisi'> </label>
									<div class="col col-5 col-md-5 col-sm-5 col-xs-12"> 
										<input type="text" name="expense_tc" id="expense_tc" value="<cfoutput>#CATEGORY.EXPENSE_TC#</cfoutput>">
									</div>
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<div class="input-group"> 
											<input type="hidden" name="expense_user_pos_id" id="expense_user_pos_id" value="<cfoutput>#CATEGORY.expense_user_pos_id#</cfoutput>">
											<input type="text" name="expense_user" id="expense_user" value="<cfoutput>#CATEGORY.EXPENSE_USER_NAME#</cfoutput>">
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=expense_user&field_id=expense_user_pos_id&select_list=1');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-fulfillment_officer">
									<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'></label>
										<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
										<div class="input-group">
											<input type="hidden" name="fulfillment_officer_pos_id" id="fulfillment_officer_pos_id" value="<cfoutput>#CATEGORY.fulfillment_officer_pos_id#</cfoutput>">
											<input type="text" name="fulfillment_officer" id="fulfillment_officer" value="<cfoutput>#get_emp_info(CATEGORY.fulfillment_officer_pos_id,1,0)#</cfoutput>">
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=fulfillment_officer&field_id=fulfillment_officer_pos_id&select_list=1');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-salary_syndic_pos_id">
									<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='64962.Maaş Mutemedi'></label>
									<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
										<div class="input-group">
											<input type="hidden" name="salary_syndic_pos_id" id="salary_syndic_pos_id" value="<cfoutput>#CATEGORY.salary_syndic_pos_id#</cfoutput>">
											<input type="text" name="salary_syndic" id="salary_syndic" value="<cfoutput>#get_emp_info(CATEGORY.salary_syndic_pos_id,1,0)#</cfoutput>">
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=salary_syndic&field_id=salary_syndic_pos_id&select_list=1');"></span>
										</div>
									</div>
								</div>
							</div>  
						</cfif> 
						<cfsavecontent variable="head4"><cf_get_lang dictionary_id='47621.Devam Kontrol'><cf_get_lang dictionary_id='37022.Bilgileri'></cfsavecontent>
						<cf_seperator id="sep_4" title="#head4#">
							<div id="sep_4">
						<div class="form-group" id="item-pdks_checkbox">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='44139.Çalışıyor'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="checkbox" name="is_pdks_work" id="is_pdks_work" value="1"<cfif category.is_pdks_work eq 1> checked</cfif>>
						</div>
					</div>
						<div class="form-group" id="item-pdks_no">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58009.PDKS'><cf_get_lang dictionary_id='62973.Ekipman'><cf_get_lang dictionary_id='57487.No'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="text" name="pdks_no" id="pdks_no" value="<cfoutput>#CATEGORY.branch_pdks_code#</cfoutput>" maxlength="200">
						</div>
					</div>
					<div class="form-group" id="item-BRANCH_PDKS_IP_NUMBERS">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='44132.PDKS IP No'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="Text" name="BRANCH_PDKS_IP_NUMBERS" id="BRANCH_PDKS_IP_NUMBERS" value="<cfoutput>#CATEGORY.BRANCH_PDKS_IP_NUMBERS#</cfoutput>" maxlength="500">
						</div>
					</div> 
					<div class="form-group" id="item-wex_address">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='47849.Wex'><cf_get_lang dictionary_id='49318.Adresi'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="Text" name="wex_address" id="wex_address"  value="<cfoutput>#CATEGORY.WEX_ADDRESS#</cfoutput>" maxlength="500">
						</div>
					</div> 
					</div>
				</div>

			</cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box_footer>	
					<cf_record_info query_name="category">
					<cfif fusebox.circuit is not 'hr'>
						<cf_workcube_buttons is_upd='0' add_function="unformat_fields()">
					</cfif>
				</cf_box_footer>
			</div>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
function unformat_fields()
	{
		if(document.getElementById('kanun_6486').value != "" && document.getElementById('kanun_6322').value !="")
		{
			alert("6486 ve 6322 kanunlarını aynı anda seçemezsiniz!");
			return false;
		}
		document.getElementById('danger_degree_no').value = filterNum(document.getElementById('danger_degree_no').value);
	}
function process_focus(element)/* sicil no karakter kontrolu ve akış için*/
	{
		var value_length = document.getElementById(element).value.length;
		if(value_length == 1 && element == 'ssk_m')
			{ 
				document.getElementById('ssk_job').focus(); 
			}
		if(value_length == 4 && element == 'ssk_job')
			{	
				document.getElementById('ssk_branch').focus();	
			}
		if(value_length == 2 && element == 'ssk_branch')
			{
				document.getElementById(ssk_branch_old).focus();
			}
		if(value_length == 2 && element == 'ssk_branch_old')
			{
				document.getElementById('ssk_no').focus();
			}
		if(value_length == 7 && element == 'ssk_no')
			{
				document.getElementById('ssk_city').focus();
			}
		if(value_length == 3 && element == 'ssk_city')
			{
				document.getElementById('ssk_country').focus();
			}
		if(value_length == 2 && element == 'ssk_country')
			{
				document.getElementById('ssk_cd').focus();
			}
		if(value_length == 2 && element == 'ssk_cd')
			{
				document.getElementById('ssk_agent').focus();
			}
		if(value_length == 3 && element == 'ssk_agent')
			{
				document.getElementById('ssk_office').focus();
			}
	}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
