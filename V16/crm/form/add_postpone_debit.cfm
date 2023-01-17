<cfif isdefined("attributes.is_page") and not isdefined("attributes.consumer_id")>
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','Borç Erteleme Talebi',52188)#">
		<cfform name="add_event" method="post" action="">
			<input type="hidden" name="is_page" id="is_page" value="">
			<cf_box_search>
					<div class="col col-6 col-xs-12">
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="consumer_id" id="consumer_id" value="">
									<input type="hidden" name="partner_id" id="partner_id" value="">
									<input type="hidden" name="partner_name" id="partner_name" readonly="" value="">
									<input type="text" name="company_name" id="company_name" readonly="" value="">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&is_buyer_seller=0&field_id=add_event.partner_id&field_comp_name=add_event.company_name&field_name=add_event.partner_name&field_comp_id=add_event.consumer_id&is_single=1&select_list=2,6','wide');"></span>
								</div>
							</div>
						</div>
					</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='hepsini_sec()'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>	
</div>				
	<script type="text/javascript">
		function hepsini_sec()
		{
			if(document.add_event.consumer_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='52021.Lütfen Müşteri Seçiniz'> !");
				return false;
			}
			else
				return true;
		}
	</script>
<cfelse>
	<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT 
			COMPANY_BRANCH_RELATED.RELATED_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME
		FROM
			BRANCH,
			COMPANY_BRANCH_RELATED
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
			COMPANY_BRANCH_RELATED.IS_SELECT <> 0 AND
			BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
			COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.consumer_id# AND
			BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
			<!--- BK ekledi 20081011 Aydın Ersoz istegi KAPANMIS,DIGER,SUBE DEGISIKLIGI --->
			COMPANY_BRANCH_RELATED.MUSTERIDURUM NOT IN (1,4,66)				
	</cfquery>
	<cfquery name="GET_RELATED_BRANCH" dbtype="query">
		SELECT BRANCH_ID FROM GET_BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
	</cfquery>
	<div class="col col-12 col-xs-12">
		<div class="col col-9 col-xs-12">  
			<cf_box title="#getLang('','Borç Erteleme Talebi',52188)#" info_href="javascript:openBoxDraggable('#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#attributes.consumer_id#')" info_title_3="#getLang('','Müşteri Teminatları','52294')#">	
				<cfform name="add_debit" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_postpone_debit">
					<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
					<cf_box_elements>
						<cfoutput>
							<div class="col col-6 col-xs-12"  type="column" index="1" sort="true">
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='57493.Aktif'></label>
									<div class="col col-8 col-xs-12">
										<input type="checkbox" value="1" name="is_active" id="is_active" checked>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='57457.Müşteri'></label>
									<div class="col col-8 col-xs-12">
										#attributes.consumer_id#
									</div>
								</div>
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='52057.Eczane Adı'></label>
									<div class="col col-8 col-xs-12">
										<input type="hidden" name="fullname" id="fullname" value="#get_par_info(attributes.consumer_id,1,1,0)#">#get_par_info(attributes.consumer_id,1,1,0)#
									</div>
								</div>
							</div>
							<div class="col col-6 col-xs-12"  type="column" index="2" sort="true">
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='52056.Talep Eden Şube'></label>
									<div class="col col-8 col-xs-12">
										<select name="branch_id" id="branch_id" onChange="degistir()">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop query="get_branch">
												<option value="#branch_id#-#related_id#" <cfif listgetat(session.ep.user_location,2,'-') eq listfirst(branch_id,"-")>selected</cfif>>#branch_name# (#related_id#)</option>
											</cfloop>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='58859.Süreç'></label>
									<div class="col col-8 col-xs-12">
										<cf_workcube_process is_upd='0'	process_cat_width='110' is_detail='0'>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
									<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="process_date" id="process_date" value="<cfoutput>#DateFormat(now(),dateformat_style)#</cfoutput>">
										<span class="input-group-addon"><cf_wrk_date_image date_field='process_date'></span>
									</div>
									</div>
								</div>
							</div>
						</cfoutput>
					</cf_box_elements>	
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
					</cf_box_footer>
					<!--- Eczane Bilgileri -Ortak- --->
					<cfset none_style_ = 1>
					
					<cf_seperator title="#getLang('','Eczane Bilgi Detayları','52326')#" id="eczane_bilgi_detaylari_">
					<div id="eczane_bilgi_detaylari_">
						<cfinclude template="../display/display_customer_info.cfm">
					</div>
					<!--- ECZANE HAKKINDA AÇIKLAYICI BİLGİ --->
					<cf_seperator title="#getLang('','Eczane Hakkında Açıklayıcı Bilgi',52327)#" id="eczane_bilgileri">
					<div id="eczane_bilgileri">
						<cf_box_elements>
							<div class="col col-6 col-xs-12"  type="column" index="3" sort="true">
								<div class="form-group">
									<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52332.Eczanenin Ek İşi Var Mı'></div>
									<div class="col col-6 col-xs-12">
										<div class="col col-3 col-xs-12">
										<input type="radio" value="1" name="is_job_add" id="is_job_add" onClick="goster(job_add_span);"><cf_get_lang dictionary_id='58564.Var'>
										</div>
										<div class="col col-3 col-xs-12">
										<input type="radio" value="0" checked name="is_job_add" id="is_job_add" onClick="gizle(job_add_span);document.add_debit.job_add_detail.value='';"><cf_get_lang dictionary_id='58546.Yok'>
										</div>
									</div>
								</div>
								<div class="form-group" id="job_add_span" style="display:none;">
									<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52328.Faaliyet Alanı'></div>
									<div class="col col-6 col-xs-12">
										<input type="text" name="job_add_detail" id="job_add_detail" value="" maxlength="100">
									</div>
								</div>
								<div class="form-group">
									<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52329.Eczaneye Mal Verilmeye Devam Edilecek Mi'></div>
									<div class="col col-6 col-xs-12">
										<div class="col col-3 col-xs-12">
											<input type="radio" value="1" name="is_job_continue" id="is_job_continue" onClick="goster(job_continue_span);"><cf_get_lang dictionary_id='57495.Evet'>
										</div>
										<div class="col col-3 col-xs-12">
											<input type="radio" value="0" checked name="is_job_continue" id="is_job_continue" onClick="gizle(job_continue_span);document.add_debit.job_continue_detail.value='';"><cf_get_lang dictionary_id='57496.Hayır'>
										</div>
									</div>
								</div>
								<div class="form-group" id="job_continue_span" style="display:none;">
									<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52330.Çalışma Şartları'></div>
									<div class="col col-6 col-xs-12">
										<input type="text" name="job_continue_detail" id="job_continue_detail" value="" maxlength="100">
									</div>
								</div>
								<div class="form-group">
									<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52331.Eczanenin Daha Önce Ertelemesi Mevcut Mu'></div>
									<div class="col col-6 col-xs-12">
										<div class="col col-3 col-xs-12">
											<input type="radio" value="1" name="is_job_postpone" id="is_job_postpone" onClick="goster(job_postpone_span);"><cf_get_lang dictionary_id='57495.Evet'>
										</div>
										<div class="col col-3 col-xs-12">
											<input type="radio" value="0" checked name="is_job_postpone" id="is_job_postpone" onClick="gizle(job_postpone_span);document.add_debit.job_postpone_detail_total.value='<cfoutput>#TLFormat(0)#</cfoutput>'"><cf_get_lang dictionary_id='57496.Hayır'>
										</div>
									</div>
								</div>
								<div class="form-group" id="job_postpone_span" style="display:none;">
									<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></div>
									<div class="col col-6 col-xs-12">
										<input type="text" name="job_postpone_detail_total" id="job_postpone_detail_total" class="moneybox" value="<cfoutput>#TLFormat(0)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));">
									</div>
								</div>
							</div>
							<div class="col col-6 col-xs-12"  type="column" index="4" sort="true">
								<div class="form-group">
									<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52333.Eczanenin Ödeme Güçlüğüne Düşme Sebebi'></div>
									<div class="col col-6 col-xs-12">
										<textarea  name="debt_reason_detail" id="debt_reason_detail"  maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='52334.Eczane Hakkında Şube Müdürünün Görüşleri'></div>
									<div class="col col-6 col-xs-12">
										<textarea  name="manager_idea_detail" id="manager_idea_detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></div>
									<div class="col col-6 col-xs-12">
										<textarea  name="detail" id="detail"></textarea>
									</div>
								</div>
							</div>
						</cf_box_elements>
					</div>
					<!--- //ECZANE HAKKINDA AÇIKLAYICI BİLGİ --->
					<cf_seperator title="#getLang('','Eczane Borç Bilgileri',52335)#" id="borc_tutar_detaylari">
					<div id="borc_tutar_detaylari">
						<div class="col col-12 col-xs-12">
							<div class="col col-6 col-sm-8 col-xs-12">
								<!--- ERTELEME YAPILACAK BORÇLAR --->
								<cf_grid_list>
									<thead>
										<tr>
											<th colspan="4" align="center" width="275"><cf_get_lang dictionary_id='52336.Erteleme Yapılacak Borçlar'></th>
										</tr>
										<tr>
											<th width="15">
												<input name="record_num1" id="record_num1" type="hidden" value="0">
												<a href="javascript://" onClick="add_row(1);" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus" border="0"></i></a>
											</th>
											<th width="80"><cf_get_lang dictionary_id='57640.Vade'></th>
											<th width="70"><cf_get_lang dictionary_id='57982.Tür'><br/>(<cf_get_lang dictionary_id='57522.Çek / Senet'>)</th>
											<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
										</tr>
									</thead>
									<tbody id="table1" name="table1"></tbody>
									<tfoot>
										<tr>
											<td style="text-align:right;" colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
											<td colspan="2">&nbsp;<input type="text" name="postpone_pay_nettotal_1" id="postpone_pay_nettotal_1" class="moneybox" readonly value="<cfoutput>#TLFormat(0)#</cfoutput>"></td>
										</tr>
										<tr>
											<td style="text-align:right;" colspan="2"><cf_get_lang dictionary_id='57861.Ortalama Vade'></td>
											<td colspan="2">&nbsp;<input type="text" name="postpone_pay_net_duedate_1" id="postpone_pay_net_duedate_1" readonly value=""></td>
										</tr>
									</tfoot>
								</cf_grid_list>
								<!--- //ERTELEME YAPILACAK BORÇLAR --->
							</div>
							<div class="col col-6 col-sm-8 col-xs-12">
								<!--- GÜNÜ GELMEMİŞ BORÇLAR --->
								<cf_grid_list>
									<thead>
										<tr>
											<th colspan="4"><cf_get_lang dictionary_id='52337.Günü Gelmemiş Borçlar'></th>
										</tr>
										<tr>
											<th width="15">
												<input name="record_num2" id="record_num2" type="hidden" value="0">
												<a href="javascript://" onClick="add_row(2);" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus" border="0"></i></a>
											</th>
											<th width="80"><cf_get_lang dictionary_id='57640.Vade'></th>
											<th width="70"><cf_get_lang dictionary_id='57982.Tür'><br/>(<cf_get_lang dictionary_id='57522.Çek / Senet'>)</th>
											<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
										</tr>
									</thead>
									<tbody name="table2" id="table2"></tbody>
									<tfoot>
										<tr>
											<td style="text-align:right;" colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
											<td colspan="2">&nbsp;<input type="text" name="postpone_pay_nettotal_2" id="postpone_pay_nettotal_2" class="moneybox" readonly value="<cfoutput>#TLFormat(0)#</cfoutput>"></td>
										</tr>
										<tr>
											<td colspan="2"style="text-align:right;"><cf_get_lang dictionary_id='57861.Ortalama Vade'></td>
											<td colspan="2">&nbsp;<input type="text" name="postpone_pay_net_duedate_2" id="postpone_pay_net_duedate_2" readonly value=""></td>
										</tr>
									</tfoot>
								</cf_grid_list>
							<!--- //GÜNÜ GELMEMİŞ BORÇLAR --->
							</div>
						</div>
						<div class="col col-12 col-xs-12">
							<div class="col col-6 col-sm-8 col-xs-12">
								<!--- YENİ ÖDEME ŞEKLİ --->
								<cf_grid_list>
									<thead>
										<tr>
											<th colspan="4" width="275" align="center"><cf_get_lang dictionary_id='52338.Yeni Ödeme Şekli'></th>
										</tr>
										<tr>
											<th width="15">
												<input name="record_num3" id="record_num3" type="hidden" value="0">
												<a href="javascript://" onClick="add_row(3);"><i class="fa fa-plus"title="<cf_get_lang dictionary_id='57582.Ekle'>"  border="0"></i></a>
											</th>
											<th width="80"><cf_get_lang dictionary_id='57640.Vade'></th>
											<th width="70"><cf_get_lang dictionary_id='57982.Tür'><br/>(<cf_get_lang dictionary_id='57522.Çek / Senet'>)</th>
											<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
										</tr>
									</thead>
									<tbody name="table3" id="table3"></tbody>
									<tfoot>
										<tr>
											<td colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
											<td colspan="2">&nbsp;<input type="text" name="postpone_pay_nettotal_3" id="postpone_pay_nettotal_3" class="moneybox" readonly value="<cfoutput>#TLFormat(0)#</cfoutput>"></td>
										</tr>
										<tr>
											<td colspan="2"><cf_get_lang dictionary_id='57861.Ortalama Vade'></td>
											<td colspan="2">&nbsp;<input type="text" name="postpone_pay_net_duedate_3" id="postpone_pay_net_duedate_3" readonly value=""></td>
										</tr>
									</tfoot>
								</cf_grid_list>
							<!--- //YENİ ÖDEME ŞEKLİ --->
							</div>
						</div>
					</div>
					<!--- VADE FARKI ORANI-TUTARI --->
					<cf_flat_list>
						<thead>
							<tr>
								<th><cf_get_lang dictionary_id='52339.Vade Farkı Oranı'> %</th>
								<th><cf_get_lang dictionary_id='52340.Vade Farkı KDV Oranı'></th>
								<th><cf_get_lang dictionary_id='52341.Vade Farkı Tutarı'></th>
								<th><cf_get_lang dictionary_id='52342.Ertelenen Gün Sayısı'></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><div class="form-group"><input type="text" name="duedate_diff_rate" id="duedate_diff_rate" value="<cfoutput>#TLFormat(0)#</cfoutput>"  onKeyUp="hesapla_fark_toplam();return(FormatCurrency(this,event));" class="moneybox"></div></td>
								<td><div class="form-group"><input type="text" name="duedate_diff_kdv" id="duedate_diff_kdv" value="<cfoutput>#TLFormat(0)#</cfoutput>"  onKeyUp="hesapla_fark_toplam();isNumber(this)" class="moneybox"></div></td>
								<td><div class="form-group"><input type="text" name="duedate_diff_total" id="duedate_diff_total" value="<cfoutput>#TLFormat(0)#</cfoutput>" readonly  class="moneybox"></div></td>
								<td><div class="form-group"><input type="text" name="postpone_day_number" id="postpone_day_number" value="0" readonly  class="moneybox"></div></td>
							</tr>
						</tbody>
					</cf_flat_list>
				</cfform>
			</cf_box>
		</div>
		<div class="col col-3 col-md-3 col-sm-12 col-xs-12">
			<div id="general">
				<cf_box id="member_frame" title="#getLang('','Genel Bilgiler','57980')#" box_page="#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#attributes.consumer_id#&iframe=1&branch_id=#get_related_branch.branch_id#"></cf_box>
			</div>

		</div>
	</div>
	<script type="text/javascript">
		row_count_type1 = 0;
		row_count_type2 = 0;
		row_count_type3 = 0;
		ekle_cikar1 = 0;
		ekle_cikar3 = 0
		
		function add_row(type)
		{
			var newRow;
			var newCell;
			if(type == 1)
			{
				ekle_cikar1++;
				row_count_type1++;
				row_all = row_count_type1;
				row_count_name_ = type + '_' + row_count_type1;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
				document.add_debit.record_num1.value=row_count_name_;
			}
			else if (type == 2)
			{
				row_count_type2++;
				row_all = row_count_type2;
				row_count_name_ = type + '_' + row_count_type2;
				newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
				document.add_debit.record_num2.value=row_count_name_;
			}
			else if (type == 3)
			{
				ekle_cikar3++;
				row_count_type3++;
				row_all = row_count_type3;
				row_count_name_ = type + '_' + row_count_type3;
				newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);	
				document.add_debit.record_num3.value=row_count_name_;
			}
			newRow.setAttribute("name","frm_row" + row_count_name_);
			newRow.setAttribute("id","frm_row" + row_count_name_);
			newRow.setAttribute("NAME","frm_row" + row_count_name_);
			newRow.setAttribute("ID","frm_row" + row_count_name_);
			newRow.className = 'color-row';
			
			newCell = newRow.insertCell(newRow.cells.length);;
			newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count_name_ +'" id="row_kontrol' + row_count_name_ +'"><a width="20" href="javascript://" onclick="sil(row_kontrol' + row_count_name_ + ',' + type + ',' + row_all + ');"><i class="fa fa-minus" border="0"></i></a>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.setAttribute("id","postpone_due_date" + row_count_name_ + "_td");
			
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="postpone_due_date' + row_count_name_ +'" id="postpone_due_date_input_group' + row_count_name_ +'" maxlength="10" validate="#validate_style#" required="yes" value=""  style="width: 140px !important;" onChange="hesapla_ortalama_vade_('+type+');"></div></div>';
			document.querySelector("#postpone_due_date" + row_count_name_ + "_td .input-group").setAttribute("id","postpone_due_date_input_group" + row_count_name_ + "_td");
			wrk_date_image('postpone_due_date_input_group' + row_count_name_,'','add_debit');
			
			newCell = newRow.insertCell(newRow.cells.length);;
			if(type == 1 || type == 2)
				newCell.innerHTML = '<div class="form-group"><select name="postpone_debt_type' + row_count_name_ +'" id="postpone_debt_type' + row_count_name_ +'" style="width:"50px;"><option value="1"><cf_get_lang dictionary_id='58007.Çek'></option><option value="2"><cf_get_lang dictionary_id='58008.Senet'></option><option value="3"><cf_get_lang dictionary_id='57147.Açık Hesap'></option><option value="4"><cf_get_lang dictionary_id='52358.ÇSİ'></option></select></div>';
			else
				newCell.innerHTML = '<div class="form-group"><select name="postpone_debt_type' + row_count_name_ +'" id="postpone_debt_type' + row_count_name_ +'" style="width:"50px;"><option value="1"><cf_get_lang dictionary_id='58007.Çek'></option><option value="2"><cf_get_lang dictionary_id='58008.Senet'></option><option value="3"><cf_get_lang dictionary_id='57147.Açık Hesap'></option><option value="5"><cf_get_lang dictionary_id='58645.Nakit'></option></select></div>';
			
			newCell = newRow.insertCell(newRow.cells.length);;
			newCell.innerHTML = '<div class="form-group"><input type="text" name="postpone_total' + row_count_name_ +'" value="<cfoutput>#TLFormat(0)#</cfoutput>" id="postpone_total' + row_count_name_ +'" value="<cfoutput>#TLFormat(0)#</cfoutput>" class="moneybox" onKeyUp="hesapla_toplam_('+type+');return(FormatCurrency(this,event));"></div>';
		}
		
		function sil(sy,type,sym)
		{
			sy.value=0;
			if(type == 1) // 1.ve 3. tablolarda en az 1 satir zorunlulugu kontol edilecek
				ekle_cikar1--;
			else if(type == 3)
				ekle_cikar3--;
			var my_element=eval("frm_row" + type + "_" + sym);
			my_element.style.display="none";
			hesapla_toplam_(type);
			hesapla_ortalama_vade_(type);
			hesapla_fark_toplam();
		}
		
		function hesapla_toplam_(type)
		{
			kontrol_deger = 0;
			toplam_postpone_total = 0;
			toplam_deger_value = eval("add_debit.postpone_pay_nettotal_"+type);
			if(type == 1)
				row_count_ = row_count_type1;
			else if(type == 2)
				row_count_ = row_count_type2;
			else if(type == 3)
				row_count_ = row_count_type3;
			
			for(var f=1;f<=row_count_;f++)
			{
				row_count_type_f = type + "_" + f;
				if(eval("add_debit.row_kontrol"+row_count_type_f) != undefined)
				{
					if(eval("add_debit.row_kontrol"+row_count_type_f).value == 1)
					{
						kontrol_deger++;
						satir_postpone_total = eval("add_debit.postpone_total"+row_count_type_f);
						toplam_postpone_total += parseFloat(filterNum(satir_postpone_total.value));

						//satir_postpone_total.value = commaSplit(satir_postpone_total);
						toplam_deger_value.value = commaSplit(toplam_postpone_total);
					}
				}
			}
			if (kontrol_deger == 0)
			toplam_deger_value.value = commaSplit(0);

			hesapla_ortalama_vade_(type);
			hesapla_fark_toplam();
		}
		
		function hesapla_ortalama_vade_(type)
		{
			kontrol_deger2 = 0;
			last_total_value = 0;
			avg_due_date_value = 0;			
			if(type == 1)
				row_count_ = row_count_type1;
			else if(type == 2)
				row_count_ = row_count_type2;
			else if(type == 3)
				row_count_ = row_count_type3;
			for(var g=1;g<=row_count_;g++)
			{
				row_count_type_g = type + "_" + g;
				if(eval("add_debit.row_kontrol"+row_count_type_g) != undefined)
				{
					if(eval("add_debit.row_kontrol"+row_count_type_g).value == 1)
					{
						kontrol_deger2++;
						main_process_date = add_debit.process_date.value; // islem tarihi
						row_due_date = eval('add_debit.postpone_due_date'+row_count_type_g).value; //satirdaki vade
						row_postpone_total = filterNum(eval("add_debit.postpone_total"+row_count_type_g).value); //satir tutari
						row_postpone_nettotal = filterNum(eval('add_debit.postpone_pay_nettotal_'+type).value); //satir net toplamlari
						day_diff = datediff(main_process_date,row_due_date,0); // gun farki (islem tarihi - satir vade tarihi)
						day_diff_total = day_diff * row_postpone_total; // gun farki toplami (gun farki * satir tutari)
						last_total_value = last_total_value + day_diff_total; //satir net gun farki toplamlari
						avg_due_date_value = last_total_value / row_postpone_nettotal; //ortalama vade farki tutari
						last_avg_due_date_value = date_add('d',avg_due_date_value,main_process_date); //ortalama vade tarihi
						if(filterNum(eval('add_debit.postpone_pay_nettotal_'+type).value) > 0)
							eval('add_debit.postpone_pay_net_duedate_'+  type).value = last_avg_due_date_value; //ortalama vade inputuna yazdiriyor
						
						if(filterNum(eval('add_debit.postpone_pay_nettotal_'+3).value) > 0 && filterNum(eval('add_debit.postpone_pay_nettotal_'+1).value) > 0)
						{
							postpone_day_number_ = datediff(eval('add_debit.postpone_pay_net_duedate_'+  1).value,eval('add_debit.postpone_pay_net_duedate_'+  3).value,0); // ertelenen gun sayisi hesaplanir
							add_debit.postpone_day_number.value = postpone_day_number_; //ertelenene gun sayisi inputuna hesaplanana deger yazdiriliyor
						}
					}
	
				}
			}
			if (kontrol_deger2 == 0)
				eval('add_debit.postpone_pay_net_duedate_'+  type).value = '';
				
			hesapla_fark_toplam();
		}
		
		function hesapla_fark_toplam()
		{
			if(filterNum(eval('add_debit.postpone_pay_nettotal_'+3).value) > 0 && filterNum(eval('add_debit.postpone_pay_nettotal_'+1).value) > 0)
			{
				postpone_day_number_ = datediff(eval('add_debit.postpone_pay_net_duedate_'+  1).value,eval('add_debit.postpone_pay_net_duedate_'+  3).value,0); // ertelenene gun sayisi hesaplanir
				add_debit.postpone_day_number.value = postpone_day_number_; //ertelenene gun sayisi inputuna hesaplanana deger yazdiriliyor
				postpone_day_number_ = add_debit.postpone_day_number.value;
				vade_farki_orani = filterNum(add_debit.duedate_diff_rate.value);
				vade_farki_kdvsiz_tutari = filterNum(eval('add_debit.postpone_pay_nettotal_'+1).value)*vade_farki_orani*postpone_day_number_/100/30;
				vade_farki_kdvli_tutari = vade_farki_kdvsiz_tutari + (vade_farki_kdvsiz_tutari *(add_debit.duedate_diff_kdv.value/100));
				add_debit.duedate_diff_total.value = vade_farki_kdvli_tutari;
				add_debit.duedate_diff_total.value = commaSplit(add_debit.duedate_diff_total.value);
			}
		}
		
		function kontrol()
		{
			x = document.add_debit.branch_id.selectedIndex;
			if (document.add_debit.branch_id[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'> !");
				return false;
			}
			if(document.add_debit.process_date.value == "")
			{
				alert("<cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'> !");
				return false;
			}
			if(document.add_debit.is_job_add[0].checked == true && document.add_debit.job_add_detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='52343.Faaliyet Alanı Girmelisiniz'> !");
				return false;
			}
			if(document.add_debit.is_job_continue[0].checked == true && document.add_debit.job_continue_detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='52344.Çalışma Şartları Girmelisiniz'> !");
				return false;
			}
			if(document.add_debit.is_job_postpone[0].checked == true && filterNum(document.add_debit.job_postpone_detail_total.value) == 0)
			{
				alert("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'> !");
				return false;
			}
			if(document.add_debit.detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='52066.Lütfen Açıklama Giriniz'> !");
				return false;
			}
			
			for(var fg=1;fg<=3;fg++)
			{
				if (fg != 2 && eval("ekle_cikar"+fg) == 0)
				{
					alert(fg + ". <cf_get_lang dictionary_id='52345.Tabloya En Az Bir Satır Eklemelisiniz'> !");
					return false;
				}
				recordcount_types_ = eval("row_count_type"+fg);
				for(var g=1;g<=recordcount_types_;g++)
				{
					row_count_type_g = fg + "_" + g;
					if(eval("add_debit.row_kontrol"+row_count_type_g) != undefined)
						if(eval("add_debit.row_kontrol"+row_count_type_g).value == 1)
						{
							if(eval("add_debit.postpone_due_date"+row_count_type_g).value == "")
							{
								alert(fg + ". <cf_get_lang dictionary_id='52346.Tablodaki'> " + g + ".<cf_get_lang dictionary_id='52347.Satıra Vade Tarihi Girmelisiniz'>  !");
								return false;
							}
							if(eval("add_debit.postpone_total"+row_count_type_g).value == "" || filterNum(eval("add_debit.postpone_total"+row_count_type_g).value) == 0 )
							{
								alert(fg + ". <cf_get_lang dictionary_id='52346.Tablodaki'> " + g + ". <cf_get_lang dictionary_id='52348.Satıra Tutar Girmelisiniz'> !");
								return false;
							}
						}
				}
			}
			if(add_debit.duedate_diff_rate.value == "")
			{
				alert("<cf_get_lang dictionary_id='52380.Vade Farkı Oranı Girmelisiniz'>!");
				return false;
			}
			if((add_debit.duedate_diff_kdv.value != 8) && (add_debit.duedate_diff_kdv.value != 18))
			{
				alert("<cf_get_lang dictionary_id='52349.KDV Değeri 8 veya 18 Olmalıdır'>!");
				add_debit.duedate_diff_kdv.value = '';
				return false;
			}
			unformat_fields();
			return process_cat_control();
		}
		
		function degistir()
		{
			deger_branch_id_ilk = "";
			if(document.add_debit.branch_id.value != "")
			{
				deger_branch_id_ilk = document.add_debit.branch_id.value;
			}
			document.member_frame.location.href='<cfoutput>#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#attributes.consumer_id#&iframe=1</cfoutput>&branch_id=' + deger_branch_id_ilk;
			
		}

		function unformat_fields()
		{
			document.add_debit.job_postpone_detail_total.value =  filterNum(document.add_debit.job_postpone_detail_total.value);
			document.add_debit.postpone_pay_nettotal_1.value =  filterNum(document.add_debit.postpone_pay_nettotal_1.value);
			document.add_debit.postpone_pay_nettotal_2.value =  filterNum(document.add_debit.postpone_pay_nettotal_2.value);
			document.add_debit.postpone_pay_nettotal_3.value =  filterNum(document.add_debit.postpone_pay_nettotal_3.value);
			document.add_debit.duedate_diff_rate.value = filterNum(document.add_debit.duedate_diff_rate.value);
			document.add_debit.duedate_diff_total.value = filterNum(document.add_debit.duedate_diff_total.value);
		}
	</script>
</cfif>
