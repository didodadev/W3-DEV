<cfif isdefined("attributes.is_page") and not isdefined("attributes.consumer_id")>
    <div class="col col-12 col-xs-12">
		<cf_box title="#getLang('','Avukata Verme Talebi',52002)#">
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
				alert("<cf_get_lang dictionary_id='52021.Lütfen Müşteri Seçiniz'>  !");
				return false;
			}
			else
				return true;
		}
	</script>
<cfelse>
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
			COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.consumer_id# AND
			BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
			<!--- BK ekledi 20081011 Aydın Ersoz istegi KAPANMIS,DIGER,SUBE DEGISIKLIGI --->
			COMPANY_BRANCH_RELATED.MUSTERIDURUM NOT IN (1,4,66)				
	</cfquery>
	<cfquery name="GET_RELATED_BRANCH" dbtype="query">
		SELECT BRANCH_ID FROM GET_BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
	</cfquery>
    <cfsavecontent variable="img_">
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#attributes.consumer_id#</cfoutput>','page');"><img src="/images/notkalem.gif" title="Müşteri Teminatları" border="0"></a>
    </cfsavecontent>
	<div class="col col-12 col-xs-12">
		<div class="col col-9 col-xs-12">  
			<cf_box title="#getLang('','Avukata Verme Talebi',52002)#" info_href="javascript:openBoxDraggable('#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#attributes.consumer_id#')" info_title_3="#getLang('','Müşteri Teminatları','52294')#">	
				<cfform name="add_law_req" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_law_request" onsubmit="unformat_fields();">
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
										<div class="col col-6 col-xs-12"><cf_get_lang dictionary_id="52354.Muacelliyet Sözleşmesi"> *</div>
										<div class="col col-6 col-xs-12">
											<div class="col col-3 col-xs-12">
												<input type="radio" value="1" name="is_muaccelliyet" id="is_muaccelliyet"><cf_get_lang dictionary_id="58564.Var">
											</div>
											<div class="col col-3 col-xs-12">
												<input type="radio" value="0" name="is_muaccelliyet" id="is_muaccelliyet" checked><cf_get_lang dictionary_id="58546.Yok">
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58626.Kefil"> *</div>
										<div class="col col-8 col-xs-12">
											<textarea name="guarantor_detail" id="guarantor_detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea>
										</div>
									</div>
									<div class="form-group">
										<div class="col col-4 col-xs-12"><cf_get_lang dictionary_id="52355.İpotek"> *</div>
										<div class="col col-8 col-xs-12">
											<textarea name="mortgage_detail" id="mortgage_detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea>
										</div>
									</div>
								</div>
								<div class="col col-6 col-xs-12"  type="column" index="4" sort="true">
									<div class="form-group">
										<div class="col col-4 col-xs-12"><cf_get_lang dictionary_id="52356.Rehin"> *</div>
										<div class="col col-8 col-xs-12">
											<textarea name="pawn_detail" id="pawn_detail" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea>
										</div>
									</div>
									<div class="form-group">
										<div class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></div>
										<div class="col col-8 col-xs-12">
											<textarea name="detail" id="detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea>
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
											<td colspan="2">&nbsp;<input type="text" name="perform_pay_nettotal_1" id="perform_pay_nettotal_1" class="moneybox" readonly value="<cfoutput>#TLformat(0)#</cfoutput>"></td>
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
											<input name="record_num2" id="record_num2" type="hidden" value="0">
											<a href="javascript://" onClick="add_row(2);" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus" border="0"></i></a>
										</th>
										<th width="80"><cf_get_lang dictionary_id='57640.Vade'></th>
										<th width="70"><cf_get_lang dictionary_id='57982.Tür'><br/>(<cf_get_lang dictionary_id='57522.Çek / Senet'>)</th>
										<th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>
									</tr>
								</thead>
								<tbody id="table2" name="table2"></tbody>
									<tfoot>
										<tr>
											<td style="text-align:right;" colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
											<td colspan="2">&nbsp;<input type="text" name="perform_pay_nettotal_2" id="perform_pay_nettotal_2" class="moneybox" readonly value="<cfoutput>#TLformat(0)#</cfoutput>"></td>
										</tr>
									</tfoot>
							</cf_grid_list>
						</div>
					</div>
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
		ekle_cikar1 = 0;
		
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
				document.add_law_req.record_num1.value=row_count_name_;
			}
			else if (type == 2)
			{
				row_count_type2++;
				row_all = row_count_type2;
				row_count_name_ = type + '_' + row_count_type2;
				newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
				document.add_law_req.record_num2.value=row_count_name_;
			}
			newRow.setAttribute("name","frm_row" + row_count_name_);
			newRow.setAttribute("id","frm_row" + row_count_name_);
			newRow.setAttribute("NAME","frm_row" + row_count_name_);
			newRow.setAttribute("ID","frm_row" + row_count_name_);
			newRow.className = 'color-row';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count_name_ +'" id="row_kontrol' + row_count_name_ +'"><a href="javascript://" onclick="sil(document.getElementById(\'row_kontrol' + row_count_name_ + '\'),' + type + ',' + row_all + ');"><i class="fa fa-minus"></i></a>';

		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","perform_due_date" + row_count_name_ + "_td");
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="perform_due_date_input_group' + row_count_name_ +'" name="perform_due_date' + row_count_name_ +'" class="text" maxlength="10" style="width:75px;" value="" validate="#validate_style#" required="yes"></div></div>';
			document.querySelector("#perform_due_date" + row_count_name_ + "_td .input-group").setAttribute("id","perform_due_date_input_group" + row_count_name_ + "_td");
			wrk_date_image('perform_due_date_input_group' + row_count_name_,'','add_law_req');
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><select name="perform_type' + row_count_name_ +'" style="width:"50px;"><option value="1"><cf_get_lang dictionary_id='58007.Çek'></option><option value="2"><cf_get_lang dictionary_id='58008.Senet'></option><option value="3"><cf_get_lang dictionary_id='51922.Açık Hesap'></option><option value="4"><cf_get_lang dictionary_id='52358.ÇSİ'></option></select></div>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="perform_total' + row_count_name_ +'" value="<cfoutput>#TLFormat(0)#</cfoutput>" class="moneybox" style="width:65px;" onKeyUp="hesapla_toplam_('+type+');return(FormatCurrency(this,event));"></div>';
		}
		
		function sil(sy,type,sym)
		{
			sy.value=0;
			if(type == 1)
				ekle_cikar1--;
			var my_element=eval("frm_row" + type + "_" + sym);
			my_element.style.display="none";
			hesapla_toplam_(type);
		}
		
		function hesapla_toplam_(type)
		{
			kontrol_deger = 0;
			toplam_perform_total = 0;
			toplam_deger_value = eval("add_law_req.perform_pay_nettotal_"+type);
			if(type == 1)
				row_count_ = row_count_type1;
			else if(type == 2)
				row_count_ = row_count_type2;			
			for(var f=1;f<=row_count_;f++)
			{
				row_count_type_f = type + "_" + f;
				if(eval("add_law_req.row_kontrol"+row_count_type_f) != undefined)
				{
					if(eval("add_law_req.row_kontrol"+row_count_type_f).value == 1)
					{
						kontrol_deger++;
						satir_perform_total = filterNum(eval("add_law_req.perform_total"+row_count_type_f).value); //satir tutari
						toplam_perform_total = parseFloat(toplam_perform_total) + parseFloat(satir_perform_total); // satir net toplamlari
						satir_perform_total = commaSplit(eval("add_law_req.perform_total"+row_count_type_f).value);
						toplam_deger_value.value = commaSplit(toplam_perform_total);
					}
				}
			}
			if (kontrol_deger == 0)
				toplam_deger_value.value = commaSplit(0);
		}
		
		function kontrol()
		{
			x = document.add_law_req.branch_id.selectedIndex;
			if (document.add_law_req.branch_id[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'> !");
				return false;
			}
			if(document.add_law_req.guarantor_detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='52360.Lütfen Kefil Bilgisi Giriniz'>!");
				return false;
			}
			if(document.add_law_req.mortgage_detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='52361.Lütfen İpotek Bilgisi Giriniz'>!");
				return false;
			}
			if(document.add_law_req.pawn_detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='52362.Lütfen Rehin Bilgisi Giriniz'>!");
				return false;
			}
			if(document.add_law_req.detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='57629.Açıklama'> !");
				return false;
			}
			for(var fg=1;fg<=2;fg++)
			{
				if (fg == 1 && eval("ekle_cikar"+fg) == 0)
				{
					alert(fg + "<cf_get_lang dictionary_id='52345.Tabloya En Az Bir Satır Eklemelisiniz'>!");
					return false;
				}
				recordcount_types_ = eval("row_count_type"+fg);
				for(var g=1;g<=recordcount_types_;g++)
				{
					row_count_type_g = fg + "_" + g;
					if(eval("add_law_req.row_kontrol"+row_count_type_g) != undefined)
						if(eval("add_law_req.row_kontrol"+row_count_type_g).value == 1)
						{
							if(eval("add_law_req.perform_due_date"+row_count_type_g).value == "")
							{
								alert(fg + ". <cf_get_lang dictionary_id='52346.Tablodaki'> " + g + ". <cf_get_lang dictionary_id='52347.Satıra Vade Tarihi Girmelisiniz'>!");
								return false;
							}
							if(eval("add_law_req.perform_total"+row_count_type_g).value == "" || filterNum(eval("add_law_req.perform_total"+row_count_type_g).value) == 0 )
							{
								alert(fg + ". <cf_get_lang dictionary_id='52346.Tablodaki'> " + g + ". <cf_get_lang dictionary_id='52348.Satıra Tutar Girmelisiniz'>!");
								return false;
							}
						}
				}
			}
			return process_cat_control();
		}
		
		function degistir()
		{
			deger_branch_id_ilk = "";
			if(document.add_law_req.branch_id.value != "")
			{
				deger_branch_id_ilk = document.add_law_req.branch_id.value;
			}
			document.member_frame.location.href='<cfoutput>#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#attributes.consumer_id#&iframe=1</cfoutput>&branch_id=' + deger_branch_id_ilk;
		}

		function unformat_fields()
		{
			//document.add_law_req.perform_pay_nettotal_1.value =  filterNum(document.add_law_req.perform_pay_nettotal_1.value);
			//document.add_law_req.perform_pay_nettotal_2.value =  filterNum(document.add_law_req.perform_pay_nettotal_2.value);
		}
	</script>
</cfif>
