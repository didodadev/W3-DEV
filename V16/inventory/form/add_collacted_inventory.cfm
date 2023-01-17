<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
    	MONEY_ID, 
        MONEY, 
        RATE1, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_MONEY 
    WHERE 
    	PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="KASA" datasource="#dsn2#">
	SELECT 
        CASH_NAME, 
        CASH_ACC_CODE, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
        CASH 
    WHERE 
        CASH_ACC_CODE IS NOT NULL ORDER BY CASH_NAME
</cfquery>
<cfquery name="GET_TAX" datasource="#dsn2#">
	SELECT 
        TAX, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	SETUP_TAX 
    ORDER BY 
    	TAX
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.partner_name" default="">

<cf_catalystHeader>
<cf_box>
	<cfform name="add_invent" id="add_invent" method="post" action="#request.self#?fuseaction=invent.emptypopup_add_collacted_inventory" onsubmit="return(unformat_fields());">
		<cf_basket_form id="collacted_inventory"> 
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<div class="form-group" >
						<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
						<div class="col col-10 col-xs-12"> 
							<div class="input-group"><cf_workcube_process_cat slct_width="140"></div>
						</div>
					</div>        
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="form-group">
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</div>
			</cf_box_footer>
		</cf_basket_form> 
		
		<cf_basket id="collacted_inventory_bask">
		<!--- <cf_box id="collacted_inventory_bask"> --->
			<div class="row">
				<div class="col col-12">
					<!--- <table class="detail_basket_list"> --->
					<cf_grid_list>
						<thead>
							<tr>
								<th><input type="hidden" name="record_num" id="record_num" value="0"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='56904.Sabit Kıymet Kategorisi'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='58878.Demirbaş No'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='57629.Açıklama'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id ='57628.Giriş Tarihi'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='57635.Miktar'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='56943.Dönembaşı Değer'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='56942.Dönem Amortismanı'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id="34062.Hesaplanmayan Kıst Amortisman"></th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id ='56909.Son Değer'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='56941.Döviz Değer'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='57677.Döviz'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='56906.Faydalı Ömür'>&nbsp;</th>
								<th nowrap="nowrap" ><cf_get_lang dictionary_id='56915.Amortisman Oranı'>&nbsp;</th>
								<th nowrap="nowrap" ><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'>&nbsp;</th>
								<th nowrap="nowrap" ><cf_get_lang dictionary_id='29425.Amortisman türü'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='58460.Masraf Merkezi'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='58551.Gider Kalemi'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='56967.Hesaplama Dönemi'>(<cf_get_lang dictionary_id ='58605.Periyod/Yıl'>)</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='56968.Borçlu Hesap Muhasebe Kodu'>&nbsp;</th>
								<th nowrap="nowrap"><cf_get_lang dictionary_id='56970.Alacak Hesabı Muhasebe Kodu'>&nbsp;</th>
							</tr>
						</thead>
						<tbody name="table1" id="table1"></tbody>
					</cf_grid_list>
				</div>
			</div>  
			<cf_basket_footer height="100">
				<div class="ui-row">
					<div id="sepetim_total" class="padding-0">
						<div class="col col-2 col-md-4 col-sm-6 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='57677.Dövizler'></span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
							<div class="totalBoxBody">
								<input type="hidden" name="deger_get_money" id="deger_get_money" value="<cfoutput>#get_money.recordcount#</cfoutput>">
								<table cellspacing="0">
									<tbody>
										<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
											SELECT 
												PERIOD_ID, 
												PERIOD, 
												STANDART_PROCESS_MONEY, 
												RECORD_DATE, 
												RECORD_IP, 
												RECORD_EMP, 
												UPDATE_DATE, 
												UPDATE_IP, 
												UPDATE_EMP
											FROM 
												SETUP_PERIOD 
											WHERE 
												PERIOD_ID = #session.ep.period_id#
										</cfquery>
										<cfoutput>
											<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)>
												<cfset selected_money=get_standart_process_money.STANDART_PROCESS_MONEY>
											<cfelseif len(session.ep.money2)>
												<cfset selected_money=session.ep.money2>
											<cfelse>
												<cfset selected_money=session.ep.money>
											</cfif>
											<cfloop query="get_money">
												<tr>
													<td nowrap="nowrap">
														<input type="hidden" id="hidden_rd_money_#currentrow#" name="hidden_rd_money_#currentrow#" value="#money#">
														<input type="hidden" id="txt_rate1_#currentrow#" name="txt_rate1_#currentrow#" value="#rate1#">
														<input type="radio" id="rd_money" name="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="toplam_hesapla();" <cfif selected_money eq money>checked</cfif>>#money#
													</td>
													<cfif session.ep.rate_valid eq 1>
														<cfset readonly_info = "yes">
													<cfelse>
														<cfset readonly_info = "no">
													</cfif>
													<td nowrap="nowrap">
														#TLFormat(rate1,0)#/
													</td>
													<td nowrap="nowrap">
														<!--- <input value="#TLFormat(rate1,0)#/"> --->
														<!--- #TLFormat(rate1,0)#/ --->
														<input type="text" class="box" style="width: 100%"  id="value_rate2#currentrow#" <cfif readonly_info>readonly</cfif>  name="value_rate2#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="toplam_hesapla();" ></td>
												</tr>
											</cfloop>
										</cfoutput>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<div class="totalBox">
							<div class="totalBoxHead font-grey-mint">
								<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
								<div class="collapse">
									<span class="icon-minus"></span>
								</div>
							</div>
							<div class="totalBoxBody">
								<table cellspacing="0">
									<tbody>
										<tr>
											<td nowrap="nowrap" class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id='57492.Toplam'></td>
											<td style="width: 30%; text-align: right;">
												<input type="text" name="total_amount" id="total_amount" class="box" style="width: 70%" readonly value="0">
											</td>
											<td nowrap="nowrap" style="width: 30%; text-align: right;">
												<cfinput type="text" id="tl_value5" name="tl_value5" class="box"  readonly value="#session.ep.money#" style="width: 70%">
											</td>
										</tr>
										<tr>
											<td class="txtbold" style="width: 40%;"><cf_get_lang dictionary_id ='58124.Döviz Toplam'></td>
											<td style="width: 30%; text-align: right;">
												<input type="text" id="other_net_total_amount" style="width: 70%"  name="other_net_total_amount" class="box" readonly value="0">&nbsp;
											</td>
											<td style="width: 30%; text-align: right;">
												<cfinput type="text" id="tl_value3" name="tl_value3" class="box" readonly value="#selected_money#" style="width: 70%" >
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</cf_basket_footer>
		</cf_basket>
	</cfform>
</cf_box>

<script type="text/javascript">
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	function kontrol()
	{
		if (!chk_process_cat('add_invent')) return false;	
		if(!check_display_files('add_invent')) return false;
		for(r=1; r<=document.getElementById("record_num").value; r++)
		{
			if(document.getElementById("row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (document.getElementById("invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56981.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (document.getElementById("invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56986.Lütfen Açıklama Giriniz'> !");
					return false;
				}
				if (document.getElementById("entry_date"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56940.Lütfen Giriş Tarihi Giriniz'> !");
					return false;
				}
				if ((document.getElementById("period_invent_value"+r).value == "")||(document.getElementById("period_invent_value"+r).value ==0))
				{ 
					alert ("<cf_get_lang dictionary_id='56939.Lütfen Dönembaşı Değeri Giriniz'> !");
					return false;
				}
				if ((document.getElementById("amortization_rate"+r).value == "")||(document.getElementById("amortization_rate"+r).value <0))
				{ 
					alert ("<cf_get_lang dictionary_id='56988.Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (document.getElementById("account_id"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56989.Lütfen Muhasebe Kodu Seçiniz'>!");
					return false;
				}
			}
		}
		if (record_exist == 0) 
			{
				alert("<cf_get_lang dictionary_id='56983.Lütfen Demirbaş Giriniz'>!");
				return false;
			}
	}
	function amortisman_kontrol(x)
	{
		deger_amortization_rate = document.getElementById("amortization_rate"+x);
		if (filterNum(deger_amortization_rate.value) >100)
		{ 
			alert ("<cf_get_lang dictionary_id='56960.Amortisman Oranı 100den Büyük Olamaz'> !");
			deger_amortization_rate.value = 0;
			return false;
		}
	}
	function period_kontrol(no)
	{
		deger = document.getElementById("period"+no);
		if ((filterNum(deger.value) <1) || (deger.value==""))
		{ 
			alert ("<cf_get_lang dictionary_id='56959.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
			deger.value =1;
			return false;
		}
	}
	function unformat_fields()
	{
		for(r=1; r<=document.getElementById("record_num").value ;r++)
		{
			document.getElementById("row_total"+r).value = filterNum(document.getElementById("row_total"+r).value);
			document.getElementById("period_invent_value"+r).value = filterNum(document.getElementById("period_invent_value"+r).value);

			document.getElementById("period_amort_value"+r).value = filterNum(document.getElementById("period_amort_value"+r).value);
			document.getElementById("partial_amort_value"+r).value = filterNum(document.getElementById("partial_amort_value"+r).value);
			document.getElementById("row_other_total"+r).value = filterNum(document.getElementById("row_other_total"+r).value);
			document.getElementById("amortization_rate"+r).value = filterNum(document.getElementById("amortization_rate"+r).value);
			document.getElementById("quantity"+r).value = filterNum(document.getElementById("quantity"+r).value);
			document.getElementById("inventory_duration"+r).value = filterNum(document.getElementById("inventory_duration"+r).value);
		}
		document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value);
		document.getElementById("other_net_total_amount").value = filterNum(document.getElementById("other_net_total_amount").value);
		for(s=1; s<=document.getElementById("deger_get_money").value; s++)
		{
			document.getElementById("value_rate2"+ s).value = filterNum(document.getElementById("value_rate2" + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=0;
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(document.getElementById("row_kontrol"+satir).value==1)
		{
			deger_total = document.getElementById("row_total"+satir);//tutar
			deger_last_value = document.getElementById("period_invent_value"+satir);//Dönem sonu değeri
			deger_amortization = document.getElementById("period_amort_value"+satir);//Dönem sonu amostismanı
			deger_other_net_total = document.getElementById("row_other_total"+satir);//dovizli tutar kdv dahil
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_amortization.value == "") deger_amortization.value = 0;
			if(deger_other_net_total.value == "") deger_other_net_total.value = 0;
			deger_money_id = document.getElementById("money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_total.value = filterNum(deger_total.value);
			deger_last_value.value = filterNum(deger_last_value.value);
			deger_amortization.value = filterNum(deger_amortization.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_total.value = parseFloat(deger_last_value.value) - parseFloat(deger_amortization.value);
			toplam_dongu_0 = parseFloat(deger_total.value);
			deger_other_net_total.value = ((parseFloat(deger_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_total.value = commaSplit(deger_total.value);
			deger_last_value.value = commaSplit(deger_last_value.value);
			deger_amortization.value = commaSplit(deger_amortization.value);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value);
		}
			toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		for(r=1; r<=document.getElementById("record_num").value; r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				deger_total = document.getElementById("row_total"+r);//tutar
				deger_miktar = document.getElementById("quantity"+r);//miktar
				deger_money_id = document.getElementById("money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1; s<=document.getElementById("deger_get_money").value; s++)
					{
						if(list_getat(document.all.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= document.getElementById("value_rate2"+s).value;
						}
					}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				deger_money_id = document.getElementById("money_id"+r);
				deger_money_id_son = list_getat(deger_money_id.value,3,',');
				deger_total.value = filterNum(deger_total.value);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
				toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_miktar.value));
				deger_total.value = commaSplit(deger_total.value);
			}
		}
			
		document.getElementById("total_amount").value = commaSplit(toplam_dongu_1);
		for(s=1; s<=document.getElementById("deger_get_money").value; s++)
		{
			form_value_rate2 = document.getElementById("value_rate2"+s);
			if(form_value_rate2.value == "")
				form_value_rate2.value = 1;
		}
		if(document.getElementById("deger_get_money").value == 1)
			for(s=1; s<=document.getElementById("deger_get_money").value; s++)
			{
				if(document.getElementById("rd_money").checked == true)
				{
					deger_diger_para = document.getElementById("rd_money");
					form_value_rate2 = document.getElementById("value_rate2"+s);
				}
			}
		else 
			for(s=1; s<=document.getElementById("deger_get_money").value; s++)
			{
				if(document.all.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.all.rd_money[s-1];
					form_value_rate2 = document.getElementById("value_rate2"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_value_rate2.value)));
	
		document.getElementById("tl_value3").value = deger_money_id_1;
		form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,entry_date,quantity,period_invent_value,period_amort_value,partial_amort_value,row_total,row_other_total,money_id_,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code)
	{
		if (inventory_cat_id == undefined) inventory_cat_id ="";
		if (inventory_cat == undefined) inventory_cat ="";
		if (invent_no == undefined) invent_no ="";
		if (invent_name == undefined) invent_name ="";
		if (entry_date == undefined) entry_date ="";
		if (quantity == undefined) quantity = 1;
		if (partial_amort_value == undefined) partial_amort_value = 0;
		if (period_invent_value == undefined) period_invent_value = 0;
		if (period_amort_value == undefined) period_amort_value = 0;
		if (row_total == undefined) row_total = 0;
		if (row_other_total == undefined) row_other_total = 0;
		if (money_id_ == undefined) money_id_ ="";
		if (inventory_duration == undefined) inventory_duration ="";
		if (amortization_rate == undefined) amortization_rate ="";
		if (amortization_method == undefined) amortization_method ="";
		if (amortization_type == undefined) amortization_type ="";
		if (account_id == undefined) account_id ="";
		if (account_code == undefined) account_code ="";
		if (expense_center_id == undefined) expense_center_id ="";
		if (expense_item_id == undefined) expense_item_id ="";
		if (expense_item_name == undefined) expense_item_name = "";
		if (period == undefined) period = 12;
		if (debt_account_id == undefined) debt_account_id ="";
		if (debt_account_code == undefined) debt_account_code ="";
		if (claim_account_id == undefined) claim_account_id ="";
		if (claim_account_code == undefined) claim_account_code ="";

		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.getElementById("record_num").value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="row_kontrol' + row_count +'" value="1" name="row_kontrol' + row_count +'" ><ul class="ui-icon-list"><li><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a></li><li><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang dictionary_id="58972.Satır Kopyala">"><i class="fa fa-copy"></i></a></li></ul>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="input-group"><input type="hidden" id="inventory_cat_id' + row_count +'" name="inventory_cat_id' + row_count +'" value="'+inventory_cat_id+'"><input type="text" " id="inventory_cat' + row_count +'" name="inventory_cat' + row_count +'" value="'+inventory_cat+'" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="open_inventory_cat_list('+ row_count +');"></span></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="invent_no' + row_count +'" name="invent_no' + row_count +'" value="'+invent_no+'"  class="boxtext"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="invent_name' + row_count +'" name="invent_name' + row_count +'" value="'+invent_name+'" s class="boxtext" maxlength="100"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","entry_date" + row_count + "_td");
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" id="entry_date' + row_count +'" name="entry_date' + row_count +'" class="text" maxlength="10"  value="'+entry_date+'">';
		wrk_date_image('entry_date' + row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'"  class="box" value="'+quantity+'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="period_invent_value' + row_count +'" name="period_invent_value' + row_count +'" value="'+period_invent_value+'" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" class="box"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="period_amort_value' + row_count +'" name="period_amort_value' + row_count +'" value="'+period_amort_value+'" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" class="box"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="partial_amort_value' + row_count +'" name="partial_amort_value' + row_count +'" value="'+partial_amort_value+'" onkeyup="return(FormatCurrency(this,event));" class="box"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="row_total' + row_count +'" name="row_total' + row_count +'" value="'+row_total+'" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" class="box" readonly></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="row_other_total' + row_count +'" name="row_other_total' + row_count +'" value="'+row_other_total+'" onkeyup="return(FormatCurrency(this,event));" class="box" readonly></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select id="money_id' + row_count +'" name="money_id' + row_count  +'" class="boxtext" onChange="hesapla('+ row_count +');">';
		<cfoutput query="get_money">
			if('#money#,#rate1#,#rate2#' == money_id_)
				a += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
			else
				a += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
		</cfoutput>
		newCell.innerHTML = '<div class="form-group">' + '<span class="input-group-addon width">'  + a + '</select>'+' </span>' + '</div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="inventory_duration' + row_count +'" name="inventory_duration' + row_count +'" value="'+inventory_duration+'" class="box" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="amortization_rate' + row_count +'" name="amortization_rate' + row_count +'" value="'+amortization_rate+'" class="box" onblur="return(amortisman_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="amortization_method'+ row_count +'" name="amortization_method'+ row_count +'"  class="box"><option value="0"><cf_get_lang dictionary_id="29421.Azalan Bakiye Üzerinden"></option><option value="1"><cf_get_lang dictionary_id="29422.Sabit Miktar Üzeriden"></option><option value="2"><cf_get_lang dictionary_id="29423.Hızlandırılmış Azalan Bakiye"></option><option value="3"><cf_get_lang dictionary_id="29424.Hızlandırılmış Sabit Değer"></option></select></span></div>';
		if(amortization_method != '')
			document.getElementById('amortization_method'+ row_count).value = amortization_method;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="amortization_type'+ row_count +'" name="amortization_type'+ row_count +'"  class="box"><option value="1">Kıst Amortismana Tabi</option><option value="2" selected>Kıst Amortismana Tabi Değil</option>></select>'
		if(amortization_type != '')
			document.getElementById('amortization_type'+ row_count).value = amortization_type;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'" value="'+account_id+'"><input type="text"  id="account_code' + row_count +'" name="account_code' + row_count +'" value="'+account_code+'" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_acc('+ row_count +');"></span></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<select id="expense_center_id' + row_count +'" name="expense_center_id' + row_count  +'" class="boxtext"><option value=""><cf_get_lang dictionary_id="58235.Masraf/Gelir Merkezi"></option>';
		<cfoutput query="GET_EXPENSE_CENTER">
			if('#EXPENSE_ID#' == expense_center_id)
				b += '<option value="#EXPENSE_ID#" selected>#EXPENSE#</option>';
			else
				b += '<option value="#EXPENSE_ID#">#EXPENSE#</option>';
		</cfoutput>
		newCell.innerHTML ='<div class="form-group">'+ '<span class="input-group-addon width">' + b + '</select>'+ '</span>' + '</div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" id="expense_item_id' + row_count +'" name="expense_item_id' + row_count +'" value="'+expense_item_id+'"><input type="text" readonly="yes"  id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+expense_item_name+'" class="boxtext"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_exp('+ row_count +');"></span></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" id="period' + row_count +'" name="period' + row_count +'"  class="box" value="'+period+'" onblur="return(period_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event,0));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" id="debt_account_id' + row_count +'" name="debt_account_id' + row_count +'" value="'+debt_account_id+'"><input type="text" id="debt_account_code' + row_count +'"  name="debt_account_code' + row_count +'" value="'+debt_account_code+'" class="boxtext" ><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_acc2('+ row_count +');"></span></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="input-group"><input  type="hidden" id="claim_account_id' + row_count +'" name="claim_account_id' + row_count +'" value="'+claim_account_id+'"><input type="text" id="claim_account_code' + row_count +'" name="claim_account_code' + row_count +'" value="'+claim_account_code+'" class="boxtext" ><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_acc1('+ row_count +');"></span></div>';
	}
	
	function copy_row(no_info)
	{
		if (document.getElementById("inventory_cat_id" + no_info) == undefined) inventory_cat_id =""; else inventory_cat_id = document.getElementById("inventory_cat_id" + no_info).value;
		if (document.getElementById("inventory_cat" + no_info) == undefined) inventory_cat =""; else inventory_cat = document.getElementById("inventory_cat" + no_info).value;
		if (document.getElementById("invent_no" + no_info) == undefined) invent_no =""; else invent_no = document.getElementById("invent_no" + no_info).value;
		if (document.getElementById("invent_name" + no_info) == undefined) invent_name =""; else invent_name = document.getElementById("invent_name" + no_info).value;
		if (document.getElementById("entry_date" + no_info) == undefined) entry_date =""; else entry_date = document.getElementById("entry_date" + no_info).value;
		if (document.getElementById("quantity" + no_info) == undefined) quantity =""; else quantity = document.getElementById("quantity" + no_info).value;
		if (document.getElementById("period_invent_value" + no_info) == undefined) period_invent_value =""; else period_invent_value = document.getElementById("period_invent_value" + no_info).value;
		if (document.getElementById("period_amort_value" + no_info) == undefined) period_amort_value =""; else period_amort_value = document.getElementById("period_amort_value" + no_info).value;
		if (document.getElementById("partial_amort_value" + no_info) == undefined) partial_amort_value =""; else partial_amort_value = document.getElementById("partial_amort_value" + no_info).value;
		if (document.getElementById("row_total" + no_info) == undefined) row_total =""; else row_total = document.getElementById("row_total" + no_info).value;
		if (document.getElementById("row_other_total" + no_info) == undefined) row_other_total =""; else row_other_total = document.getElementById("row_other_total" + no_info).value;
		if (document.getElementById("money_id" + no_info) == undefined) money_id =""; else money_id = document.getElementById("money_id" + no_info).value;
		if (document.getElementById("inventory_duration" + no_info) == undefined) inventory_duration =""; else inventory_duration = document.getElementById("inventory_duration" + no_info).value;
		if (document.getElementById("amortization_rate" + no_info) == undefined) amortization_rate =""; else amortization_rate = document.getElementById("amortization_rate" + no_info).value;
		if (document.getElementById("amortization_method" + no_info) == undefined) amortization_method =""; else amortization_method = document.getElementById("amortization_method" + no_info).value;
		if (document.getElementById("amortization_type" + no_info) == undefined) amortization_type =""; else amortization_type = document.getElementById("amortization_type" + no_info).value;
		if (document.getElementById("account_id" + no_info) == undefined) account_id =""; else account_id = document.getElementById("account_id" + no_info).value;
		if (document.getElementById("account_code" + no_info) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no_info).value;
		if (document.getElementById("expense_center_id" + no_info) == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id" + no_info).value;
		if (document.getElementById("expense_item_id" + no_info) == undefined) expense_item_id =""; else expense_item_id = document.getElementById("expense_item_id" + no_info).value;
		if (document.getElementById("expense_item_name" + no_info) == undefined) expense_item_name =""; else expense_item_name = document.getElementById("expense_item_name" + no_info).value;
		if (document.getElementById("period" + no_info) == undefined) period =""; else period = document.getElementById("period" + no_info).value;
		if (document.getElementById("debt_account_id" + no_info) == undefined) debt_account_id =""; else debt_account_id = document.getElementById("debt_account_id" + no_info).value;
		if (document.getElementById("debt_account_code" + no_info) == undefined) debt_account_code =""; else debt_account_code = document.getElementById("debt_account_code" + no_info).value;
		if (document.getElementById("claim_account_id" + no_info) == undefined) claim_account_id =""; else claim_account_id = document.getElementById("claim_account_id" + no_info).value;
		if (document.getElementById("claim_account_code" + no_info) == undefined) claim_account_code =""; else claim_account_code = document.getElementById("claim_account_code" + no_info).value;
		
		add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,entry_date,quantity, period_invent_value,period_amort_value,partial_amort_value,row_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code);
		toplam_hesapla();
	}
	
	function pencere_ac_acc(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=account_id' + no +'&field_name=account_code' + no +'');
	}
	function pencere_ac_acc1(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=claim_account_id' + no +'&field_name=claim_account_code' + no +'');
	}
	function pencere_ac_acc2(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=debt_account_id' + no +'&field_name=debt_account_code' + no +'');
	}
	function pencere_ac_exp(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=expense_item_id' + no +'&field_name=expense_item_name' + no +'&field_account_no=debt_account_code' + no +'&field_account_no2=debt_account_id' + no +'');
	}
	function open_inventory_cat_list(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=inventory_cat_id' + no +'&field_name=inventory_cat' + no +'&field_amortization_rate=amortization_rate' + no +'&field_inventory_duration=inventory_duration' + no +'');
	}
	function ayarla_gizle_goster()
	{
		if(document.getElementById("cash").checked)
			kasa_sec.style.display='';
		else
			kasa_sec.style.display='none';
	}
</script>
