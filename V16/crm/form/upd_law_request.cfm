<cfquery name="GET_LAW" datasource="#DSN#">
	SELECT * FROM COMPANY_LAW_REQUEST WHERE LAW_REQUEST_ID = #attributes.law_request_id#
</cfquery>
<cfquery name="get_law_row_1" datasource="#dsn#">
	SELECT * FROM COMPANY_LAW_REQUEST_ROW WHERE LAW_REQUEST_ID = #attributes.law_request_id# AND TYPE_ID = 1
</cfquery>
<cfquery name="get_law_row_2" datasource="#dsn#">
	SELECT * FROM COMPANY_LAW_REQUEST_ROW WHERE LAW_REQUEST_ID = #attributes.law_request_id# AND TYPE_ID = 2
</cfquery>

<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		COMPANY_BRANCH_RELATED.RELATED_ID
	FROM
		BRANCH,
		COMPANY_BRANCH_RELATED
	WHERE
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.IS_SELECT <> 0 AND
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #get_law.company_id# AND
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
		<!--- BK ekledi 20081011 Aydın Ersoz istegi KAPANMIS,DIGER,SUBE DEGISIKLIGI --->
		COMPANY_BRANCH_RELATED.MUSTERIDURUM NOT IN (1,4,66)				
</cfquery>
<cfquery name="GET_BRANCH_" dbtype="query">
	SELECT 
		BRANCH_NAME
	FROM
		GET_BRANCH
	WHERE
		BRANCH_ID = #get_law.branch_id#
</cfquery>
<cfquery name="GET_RELATED_BRANCHS" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		COMPANY_BRANCH_RELATED.MUSTERIDURUM
	FROM
		BRANCH,
		COMPANY_BRANCH_RELATED
	WHERE
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #get_law.company_id#
</cfquery>
<cfquery name="GET_CUSTOMER_POSITION" datasource="#DSN#">
	SELECT 
		COMPANY_POSITION.POSITION_ID,
		SETUP_CUSTOMER_POSITION.POSITION_NAME 
	FROM 
		SETUP_CUSTOMER_POSITION, 
		COMPANY_POSITION
	WHERE 
		COMPANY_POSITION.POSITION_ID = SETUP_CUSTOMER_POSITION.POSITION_ID AND 
		COMPANY_POSITION.COMPANY_ID = #get_law.company_id#
	ORDER BY 
		SETUP_CUSTOMER_POSITION.POSITION_ID
</cfquery>
<cfquery name="GET_COMPANY_RIVAL_INFO" datasource="#DSN#">
	SELECT
		SETUP_RIVALS.R_ID,
		SETUP_RIVALS.RIVAL_NAME
	FROM
		COMPANY,
		COMPANY_PARTNER_RIVAL,
		SETUP_RIVALS
	WHERE
		COMPANY.COMPANY_ID = COMPANY_PARTNER_RIVAL.COMPANY_ID AND
		COMPANY_PARTNER_RIVAL.RIVAL_ID = SETUP_RIVALS.R_ID AND
		COMPANY.COMPANY_ID = #get_law.company_id#
</cfquery>
<cfquery name="GET_RELATED_BRANCH" dbtype="query">
	SELECT BRANCH_ID FROM GET_BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
</cfquery>
<div class="col col-12 col-xs-12">
	<div class="col col-9 col-xs-12">  
		<cf_box title="#getLang('','Avukata Verme Talebi',52002)#" info_href="javascript:openBoxDraggable('#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#get_law.company_id#')" info_title_3="#getLang('','Müşteri Teminatları','52294')#" print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.law_request_id#&print_type=401" print_title="#getLang('','Yazdır','57474')#">	
			<cfform name="upd_law_req" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_law_request" onsubmit="unformat_fields();">
				<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#get_law.company_id#</cfoutput>">
				<input type="hidden" name="law_request_id" id="law_request_id" value="<cfoutput>#attributes.law_request_id#</cfoutput>">
				<cfif isdefined("attributes.is_normal_form")>
					<input type="hidden" name="is_normal_form" id="is_normal_form" value="<cfoutput>#attributes.is_normal_form#</cfoutput>">
				</cfif>
				<cf_box_elements>
					<cfoutput>
						<div class="col col-6 col-xs-12"  type="column" index="1" sort="true">
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='57493.Aktif'></label>
								<div class="col col-8 col-xs-12">
									<input type="checkbox" value="1" name="is_active" id="is_active" <cfif get_law.is_active eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='57457.Müşteri'></label>
								<div class="col col-8 col-xs-12">
									#get_law.company_id#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='52057.Eczane Adı'></label>
								<div class="col col-8 col-xs-12">
									<input type="hidden" name="fullname" id="fullname" value="#get_par_info(get_law.company_id,1,1,0)#">#get_par_info(get_law.company_id,1,1,0)#
								</div>
							</div>
						</div>
						<div class="col col-6 col-xs-12"  type="column" index="2" sort="true">
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='52056.Talep Eden Şube'></label>
								<div class="col col-8 col-xs-12">
									<input type="hidden" name="branch_id" id="branch_id" value="#get_law.branch_id#">
									#get_branch_.branch_name#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='58859.Süreç'></label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process is_upd='0' select_value = '#get_law.process_cat#' process_cat_width='163' is_detail='1'>
								</div>
							</div>
						</div>
					</cfoutput>
				</cf_box_elements>	
				<cf_box_footer>
					<cf_record_info query_name="get_law">
					<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'>
				</cf_box_footer>
				<!--- Eczane Bilgileri -Ortak- --->
				<cf_seperator title="#getLang('','Eczane Bilgi Detayları','52326')#" id="eczane_bilgi_detaylari_">
					<div id="eczane_bilgi_detaylari_">
						<cfset attributes.consumer_id = get_law.company_id>
						<cfinclude template="../display/display_customer_info.cfm">
					</div>
				<!--- ECZANE HAKKINDA AÇIKLAYICI BİLGİ --->
				<cf_seperator title="#getLang('','Eczane Hakkında Açıklayıcı Bilgi',52327)#" id="eczane_bilgileri">
					<div id="eczane_bilgileri">
						<cf_box_elements>
							<div class="col col-6 col-xs-12"  type="column" index="3" sort="true">
								<div class="form-group">
									<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id="52354.Muacelliyet Sözleşmesi"> *</div>
									<div class="col col-6 col-xs-12">
										<div class="col col-3 col-xs-12">
											<input type="radio" value="1" name="is_muaccelliyet" id="is_muaccelliyet" <cfif get_law.is_muaccelliyet eq 1>checked</cfif>><cf_get_lang dictionary_id="58564.Var">
										</div>
										<div class="col col-3 col-xs-12">
											<input type="radio" value="0" name="is_muaccelliyet" id="is_muaccelliyet" <cfif get_law.is_muaccelliyet eq 0>checked</cfif>><cf_get_lang dictionary_id="58546.Yok">
										</div>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58626.Kefil"> *</div>
									<div class="col col-8 col-xs-12">
										<textarea name="guarantor_detail" id="guarantor_detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#get_law.guarantor_detail#</cfoutput></textarea>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-4 col-xs-12"><cf_get_lang dictionary_id="52355.İpotek"> *</div>
									<div class="col col-8 col-xs-12">
										<textarea name="mortgage_detail" id="mortgage_detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#get_law.mortgage_detail#</cfoutput></textarea>
									</div>
								</div>
							</div>
							<div class="col col-6 col-xs-12"  type="column" index="4" sort="true">
								<div class="form-group">
									<div class="col col-4 col-xs-12"><cf_get_lang dictionary_id="52356.Rehin"> *</div>
									<div class="col col-8 col-xs-12">
										<textarea name="pawn_detail" id="pawn_detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#get_law.pawn_detail#</cfoutput></textarea>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></div>
									<div class="col col-8 col-xs-12">
										<textarea name="detail" id="detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"><cfoutput>#get_law.detail#</cfoutput></textarea>
									</div>
								</div>
							</div>
						</cf_box_elements>
					</div>
				<cf_seperator title="#getLang('','Eczane Borç Bilgileri',52335)#" id="eczane_borc_bilgileri_">
				<div id="eczane_borc_bilgileri_">
					<div class="col col-6 col-sm-8 col-xs-12">
						<!--- ERTELEME YAPILACAK BORÇLAR --->
						<cf_grid_list>
							<thead>
								<tr>
									<th colspan="4" align="center" width="275"><cf_get_lang dictionary_id="52357.İCRA TAKİBİ YAPILACAK BORÇLAR"></th>
								</tr>
								<tr>
									<th width="15">
										<input name="record_num1" id="record_num1" type="hidden" value="<cfoutput>#get_law_row_1.recordcount#</cfoutput>">
										<a href="javascript://" onClick="add_row(1);" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus" border="0"></i></a>
									</th>
									<th width="80"><cf_get_lang dictionary_id='57640.Vade'></th>
									<th width="70"><cf_get_lang dictionary_id='57982.Tür'><br/>(<cf_get_lang dictionary_id='57522.Çek / Senet'>)</th>
									<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
								</tr>
							</thead>
							<tbody id="table1" name="table1">
								<cfoutput query="get_law_row_1">
									<tr id="frm_row#type_id#_#currentrow#">
										<td><input type="hidden" name="law_request_row_id#type_id#_#currentrow#" id="law_request_row_id#type_id#_#currentrow#" value="#law_request_row_id#">
											<input type="hidden" value="1" name="row_kontrol#type_id#_#currentrow#" id="row_kontrol#type_id#_#currentrow#">
											<a href="javascript://" onclick="sil('#type_id#_#currentrow#','#type_id#','#currentrow#');"><i class="fa fa-minus" border="0"></i></a>
										</td>
										<td>
											<div class="form-group">
												<div class="input-group">
													<input type="text" name="perform_due_date#type_id#_#currentrow#" id="perform_due_date#type_id#_#currentrow#" value="#Dateformat(perform_due_date,dateformat_style)#">
													<span class="input-group-addon"><cf_wrk_date_image date_field='perform_due_date#type_id#_#currentrow#'></span>
												</div>
											</div>
										</td>
										<td>
											<div class="form-group">
												<select name="perform_type#type_id#_#currentrow#" id="perform_type#type_id#_#currentrow#">
													<option value="1" <cfif perform_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58007.Çek'></option>
													<option value="2" <cfif perform_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58008.Senet'></option>
													<option value="3" <cfif perform_type eq 3>selected</cfif>><cf_get_lang dictionary_id='51922.Açık Hesap'></option>
													<option value="4" <cfif perform_type eq 4>selected</cfif>><cf_get_lang dictionary_id='52358.ÇSİ'></option>
												</select>
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="perform_total#type_id#_#currentrow#" id="perform_total#type_id#_#currentrow#" value="#TLFormat(perform_total)#" class="moneybox" onKeyUp="hesapla_toplam_(1);return(FormatCurrency(this,event));">
											</div>
										</td>
									</tr>
								</cfoutput>
							</tbody>
								<tfoot>
									<tr>
										<td style="text-align:right;" colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td colspan="2">&nbsp;<input type="text" name="perform_pay_nettotal_1" id="perform_pay_nettotal_1" class="moneybox" readonly value="<cfoutput>#TLFormat(get_law.perform_pay_nettotal1)#</cfoutput>"></td>
									</tr>
								</tfoot>
						</cf_grid_list>
					</div>
					<div class="col col-6 col-sm-8 col-xs-12">
						<cf_grid_list>
							<thead>
								<tr>
									<th colspan="4" align="center" width="275"><cf_get_lang dictionary_id="52359.İCRA TAKİBİ YAPILMAYACAK BORÇLAR"></th>
								</tr>
								<tr>
									<th width="15">
										<input name="record_num2" id="record_num2" type="hidden" value="<cfoutput>#get_law_row_2.recordcount#</cfoutput>">
										<a href="javascript://" onClick="add_row(2);" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus" border="0"></i></a>
									</th>
									<th width="80"><cf_get_lang dictionary_id='57640.Vade'></th>
									<th width="70"><cf_get_lang dictionary_id='57982.Tür'><br/>(<cf_get_lang dictionary_id='57522.Çek / Senet'>)</th>
									<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
								</tr>
							</thead>
							<tbody id="table2" name="table2">
								<cfoutput query="get_law_row_2">
									<tr id="frm_row#type_id#_#currentrow#" class="color-list" align="center">
										<td><input type="hidden" name="law_request_row_id#type_id#_#currentrow#" id="law_request_row_id#type_id#_#currentrow#" value="#law_request_row_id#">
											<input type="hidden" value="1" name="row_kontrol#type_id#_#currentrow#" id="row_kontrol#type_id#_#currentrow#">
											<a href="javascript://" onclick="sil('row_kontrol#type_id#_#currentrow#','#type_id#','#currentrow#');"><i class="fa fa-minus" border="0"></i></a>
										</td>
										<td>
											<div class="form-group">
												<div class="input-group">
													<input type="text" name="perform_due_date#type_id#_#currentrow#" id="perform_due_date#type_id#_#currentrow#" value="#Dateformat(perform_due_date,dateformat_style)#">
													<span class="input-group-addon"><cf_wrk_date_image date_field='perform_due_date#type_id#_#currentrow#'></span>
												</div>
											</div>
										</td>
										<td>
											<div class="form-group">
												<select name="perform_type#type_id#_#currentrow#" id="perform_type#type_id#_#currentrow#">
													<option value="1" <cfif perform_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58007.Çek'></option>
													<option value="2" <cfif perform_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58008.Senet'></option>
													<option value="3" <cfif perform_type eq 3>selected</cfif>><cf_get_lang dictionary_id='51922.Açık Hesap'></option>
													<option value="4" <cfif perform_type eq 4>selected</cfif>><cf_get_lang dictionary_id='52358.ÇSİ'></option>
												</select>
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="perform_total#type_id#_#currentrow#" id="perform_total#type_id#_#currentrow#" value="#TLFormat(perform_total)#" class="moneybox" onKeyUp="hesapla_toplam_(2);return(FormatCurrency(this,event));">
											</div>
										</td>

									</tr>
								</cfoutput>
							</tbody>
								<tfoot>
									<tr>
										<td style="text-align:right;" colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td colspan="2">&nbsp;<input type="text" name="perform_pay_nettotal_2" id="perform_pay_nettotal_2" class="moneybox" readonly value="<cfoutput>#TLFormat(get_law.perform_pay_nettotal2)#</cfoutput>"></td>
									</tr>
								</tfoot>
						</cf_grid_list>
					</div>
				</div>
			</cfform>
		</cf_box>
	</div>
	<div class="col col-3 col-md-3 col-sm-12 col-xs-12">
		<!--- Notlar --->
		<cf_get_workcube_note action_section='LAW_REQUEST_ID' action_id='#attributes.law_request_id#'>
			<!--- Varliklar --->
		<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-9" module_id='52' action_section='LAW_REQUEST_ID' action_id='#attributes.law_request_id#'>
			<!---Genel Bilgiler --->
		<div id="general">
			<cf_box id="member_frame" title="#getLang('','Genel Bilgiler','57980')#" box_page="#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#get_law.company_id#&iframe=1&branch_id=#get_related_branch.branch_id#"></cf_box>
		</div>
	</div>
</div>
<script type="text/javascript">
	row_count_type1 = <cfoutput>#get_law_row_1.recordcount#</cfoutput>;
	row_count_type2 = <cfoutput>#get_law_row_2.recordcount#</cfoutput>;
	
	function add_row(type)
	{
		var newRow;
		var newCell;
		if(type == 1)
		{
			row_count_type1++;
			row_all = row_count_type1;
			row_count_name_ = type + '_' + row_count_type1;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		}
		else if (type == 2)
		{
			 row_count_type2++;
			 row_all = row_count_type2;
			 row_count_name_ = type + '_' + row_count_type2;
			newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		}
		newRow.setAttribute("name","frm_row" + row_count_name_);
		newRow.setAttribute("id","frm_row" + row_count_name_);
		newRow.setAttribute("NAME","frm_row" + row_count_name_);
		newRow.setAttribute("ID","frm_row" + row_count_name_);
		newRow.className = 'color-row';
		if (type == 1)
			document.upd_law_req.record_num1.value=row_all;
		else if (type == 2)
			document.upd_law_req.record_num2.value=row_all;

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count_name_ +'" id="row_kontrol' + row_count_name_ +'"><a href="javascript://" onclick="sil(document.getElementById(\'row_kontrol' + row_count_name_ + '\'),' + type + ',' + row_all + ');"><i class="fa fa-minus"></i></a>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","perform_due_date" + row_count_name_ + "_td");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="perform_due_date_input_group' + row_count_name_ +'" name="perform_due_date' + row_count_name_ +'" class="text" maxlength="10" style="width:75px;" value="" validate="#validate_style#" required="yes"></div></div>';
		document.querySelector("#perform_due_date" + row_count_name_ + "_td .input-group").setAttribute("id","perform_due_date_input_group" + row_count_name_ + "_td");
		wrk_date_image('perform_due_date_input_group' + row_count_name_,'','upd_law_req');
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="perform_type' + row_count_name_ +'" style="width:"80px;"><option value="1"><cf_get_lang dictionary_id='58007.Çek'></option><option value="2"><cf_get_lang dictionary_id='58008.Senet'></option><option value="3"><cf_get_lang dictionary_id='51922.Açık Hesap'></option><option value="4"><cf_get_lang dictionary_id='52358.ÇSİ'></option></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="perform_total' + row_count_name_ +'" value="<cfoutput>#TLFormat(0)#</cfoutput>" class="moneybox" style="width:70px;" onKeyUp="hesapla_toplam_('+type+');return(FormatCurrency(this,event));"></div>';
	}
	
	function sil(sy,type,sym)
	{
		sy.value=0;
		eval('upd_law_req.row_kontrol' + type + "_" + sym).value = 0;
		var my_element=eval("frm_row" + type + "_" + sym);
		my_element.style.display="none";
		hesapla_toplam_(type);
	}

	function hesapla_toplam_(type)
	{
		kontrol_deger = 0;
		toplam_perform_total = 0;
		toplam_deger_value = eval("upd_law_req.perform_pay_nettotal_"+type);
		if(type == 1)
			row_count_ = row_count_type1;
		else if(type == 2)
			row_count_ = row_count_type2;

		for(var f=1;f<=row_count_;f++)
		{
			row_count_type_f = type + "_" + f;
			if(eval("upd_law_req.row_kontrol"+row_count_type_f) != undefined)
			{
				if(eval("upd_law_req.row_kontrol"+row_count_type_f).value == 1)
				{
					kontrol_deger++;
					satir_perform_total = filterNum(eval("upd_law_req.perform_total"+row_count_type_f).value); //satir tutari
					toplam_perform_total = toplam_perform_total + satir_perform_total; // satir net toplamlari
					satir_perform_total = commaSplit(eval("upd_law_req.perform_total"+row_count_type_f).value);
					toplam_deger_value.value = commaSplit(toplam_perform_total);
				}
				
			}
		}
		if (kontrol_deger == 0)
			toplam_deger_value.value = commaSplit(0);
	}
	
	function kontrol()
	{
		if(document.upd_law_req.guarantor_detail.value == "")
		{
			alert("<cf_get_lang dictionary_id='52360.Lütfen Kefil Bilgisi Giriniz'> !");
			return false;
		}
		if(document.upd_law_req.mortgage_detail.value == "")
		{
			alert("<cf_get_lang dictionary_id='52361.Lütfen İpotek Bilgisi Giriniz'>!");
			return false;
		}
		if(document.upd_law_req.pawn_detail.value == "")
		{
			alert("<cf_get_lang dictionary_id='52362.Lütfen Rehin Bilgisi Giriniz'>!");
			return false;
		}
		if(document.upd_law_req.detail.value == "")
		{
			alert("<cf_get_lang dictionary_id='57629.Açıklama'> !");
			return false;
		}
		
		for(var fg=1;fg<=2;fg++)
		{
			recordcount_types_ = eval("row_count_type"+fg);
			for(var g=1;g<=recordcount_types_;g++)
			{
				row_count_type_g = fg + "_" + g;
				if(eval("upd_law_req.row_kontrol"+row_count_type_g) != undefined)
					if(eval("upd_law_req.row_kontrol"+row_count_type_g).value == 1)
						if(eval("upd_law_req.perform_due_date"+row_count_type_g).value == "")
						{
							alert(fg + ". <cf_get_lang dictionary_id='52346.Tablodaki'> " + g + ".<cf_get_lang dictionary_id='52347.Satıra Vade Tarihi Girmelisiniz'>!");
							return false;
						}
						if(eval("upd_law_req.perform_total"+row_count_type_g).value == "" || filterNum(eval("upd_law_req.perform_total"+row_count_type_g).value) == 0 )
						{
							alert(fg + ". <cf_get_lang dictionary_id='52346.Tablodaki'> " + g + ". <cf_get_lang dictionary_id='52348.Satıra Tutar Girmelisiniz'> !");
							return false;
						}
			}
		}
		return process_cat_control();
	}

	
	function unformat_fields()
	{
		document.upd_law_req.perform_pay_nettotal_1.value =  filterNum(document.upd_law_req.perform_pay_nettotal_1.value);
		document.upd_law_req.perform_pay_nettotal_2.value =  filterNum(document.upd_law_req.perform_pay_nettotal_2.value);
	}
</script>
