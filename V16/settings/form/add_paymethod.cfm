<cfinclude template="../../objects/query/payment_means_code.cfm">
<cf_xml_page_edit fuseact="settings.form_add_paymethod">
<cfquery name="Get_Our_Company" datasource="#dsn#">
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_bank_names" datasource="#dsn#">
	SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>

<cfif isdefined("url.paymethod_id") and len(url.paymethod_id)>
	<cfquery name="GET_PAYMETHODS_FIXED_DATE" datasource="#DSN#">
		SELECT PAYMETHOD_ID FROM SETUP_PAYMETHOD_FIXED_DATE WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.paymethod_id#">
	</cfquery>
<cfelse>
	<cfset get_paymethods_fixed_date.recordcount = 0>
</cfif>

<cfquery name="CONTROL_EINVOICE" datasource="#DSN#">
	SELECT 
    	IS_EFATURA 
    FROM 
    	OUR_COMPANY_INFO 
    WHERE 
    	IS_EFATURA = 1 AND 
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
</cfquery>
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('settings','Ödeme Yöntemi Ekle',42488)#">
		<cfform name="add_paymethod" method="post" action="#request.self#?fuseaction=settings.emptypopup_paymethod_add">
			<cf_box_elements>
			<input type="hidden" name="record_num" id="record_num" value="<cfoutput><cfif isdefined("attributes.due_month") and len(attributes.due_month)>#attributes.due_month#<cfelse>0</cfif></cfoutput>" />
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-status">
						<div class="col col-4 col-md-6 col-xs-12">
							<cf_get_lang dictionary_id='57493.Aktif'>
							<input type="checkbox" name="status" id="status" checked value="1">
						</div>
						<div class="col col-4 col-md-6 col-xs-12">
							<cf_get_lang dictionary_id='58885.Partner'>
							<input type="checkbox" name="is_partner" id="is_partner">
						</div>
						<div class="col col-4 col-md-6 col-xs-12">
							<cf_get_lang dictionary_id='30964.Public'>
							<input type="checkbox" name="is_public" id="is_public">
						</div>
					</div>
					<cfif isdefined("xml_date_control") and xml_date_control eq 1>
						<div class="form-group" id="item-is_due">
							<div class="col col-12 col-md-12 col-xs-12">
								<input type="checkbox" name="is_due" id="is_due">
								<cf_get_lang dictionary_id='46679.Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin'>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-paymethod">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>*</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='42612.Ödeme Yöntemi girmelisiniz'></cfsavecontent>
								<cfinput type="Text" name="paymethod" id="paymethod" size="30" value="" maxlength="75" required="Yes" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-payment_means_code">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57847.Ödeme'><cf_get_lang dictionary_id='58663.Şekli'><cf_get_lang dictionary_id='58585.Kod'><cfif control_einvoice.recordcount>*</cfif></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<select name="payment_means_code" id="payment_means_code">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="payment_means_code">
									<option value="#payment_means_code_id#,#detail#" title="#payment_means_code#">#detail#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="dbs_" style="display:none;">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='30349.Banka Adi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<select name="bank_id" id="bank_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_bank_names">
									<option value="#bank_id#">#bank_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-in_advance">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42490.Peşinat Oranı'> % *</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='42606.Peşinat Oranı girmelisiniz'></cfsavecontent>
							<cfinput class="moneybox" type="text"  name="in_advance"  id="in_advance" range="0,100" required="no" message="#message#" onKeyUp="isNumber(this);">
						</div>
					</div>
					<div class="form-group" id="item-due_date_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42492.Vade Farkı Oranı % / Ay'>*</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='52380.Vade Farkı Oranı girmelisiniz'></cfsavecontent>
							<cfinput class="moneybox" type="text" name="due_date_rate" id="due_date_rate" required="yes" message="#message#" onKeyUp="return(FormatCurrency(this,event),4);">
						</div>
					</div>
					<div class="form-group" id="item-first_interest_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43659.Erken Ödeme İndirimi'> %</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfinput class="moneybox" type="text" name="first_interest_rate" id="first_interest_rate" required="no" onKeyUp="return(FormatCurrency(this,event,4));">
						</div>
					</div>	
					<div class="form-group" id="item-due_day">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57861.Ortalama Vade'></label>
						<div class="col col-4 col-md-6 col-xs-12">
							<input type="text" name="due_day" id="due_day" onchange="temizle_month();" onkeyup="isNumber(this);">
						</div>
						<div class="col col-4 col-md-4 col-xs-12">
							<input type="checkbox" name="is_business_due_day" id="is_business_due_day" value="1">
							<label><cf_get_lang dictionary_id='65353.İş Günü'></label>
						</div>
					</div>
					<div class="form-group" id="item-taksit_kontrol">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42489.Vade Aylık Taksitlerle'></label>
						<div class="col col-4 col-md-6 col-xs-12">
							<input type="text" name="due_month" id="due_month" onchange="temizle_day();" onkeyup="isNumber(this);">								
						</div>
						<div class="col col-4 col-md-6 col-xs-12">
							<cfif isdefined("xml_fixed_date") and xml_fixed_date eq 1>
								<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra" name="due_format" id="due_format" value="" onclick="fixedDate();taksit_kontrol_();"><cf_get_lang dictionary_id='42975.Taksit Belirle'></a>																
								<input type="hidden" name="taksit_kontrol" id="taksit_kontrol" value="0"/>	
							</cfif>				
						</div>								
					</div>
					<cfif isdefined("xml_fixed_date") and xml_fixed_date eq 1>
						<table name="fixed" id="fixed">
							<cfif get_paymethods_fixed_date.recordcount>
								<cfoutput query="get_paymethods_fixed_date">
									<div class="form-group" id="frm_row#currentrow#" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
										<div class="input-group">
											<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
											<input type="text" name="fixed_date#currentrow#"  id="fixed_date#currentrow#" value="">
											<span class="input-group-addon"><cf_wrk_date_image date_field="fixed_date#currentrow#"></span>
										</div>
									</div>
								</cfoutput>
							</cfif>
						</table>
					</cfif>							
				</div>
				<div  class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">	
					<div class="form-group" id="item-delay_interest_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43660.Gecikme Faizi'> %</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfinput class="moneybox" type="text" name="delay_interest_rate"  id="delay_interest_rate"  required="no" message="#message#" onKeyUp="return(FormatCurrency(this,event,4));">
						</div>
					</div>
					<div class="form-group" id="item-delay_interest_day">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43661.Gecikme Faizi Başlangıcı'></label>
						<div class="col col-5 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='43568.Gecikme Faizi Başlangıcı Girmelisiniz'> !</cfsavecontent>
							<cfinput type="text" name="delay_interest_day" id="delay_interest_day" required="no" message="#message#" onKeyUp="isNumber(this);">
						</div>
						<label class="col col-3"><cf_get_lang dictionary_id='43664.Gün Sonra'></label>
					</div>
					<div class="form-group" id="item-due_start_day">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43662.Vade Başlangıcı'></label>
						<div class="col col-5 col-md-6 col-xs-12">
							<cfinput type="text" name="due_start_day" id="due_start_day" required="no" onKeyUp="isNumber(this);">
						</div>
						<label class="col col-3"><cf_get_lang dictionary_id='43664.Gün Sonra'></label>
					</div>
					<div class="form-group" id="item-due_start_month">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43662.Vade Başlangıcı'></label>
						<div class="col col-5 col-md-6 col-xs-12">
							<cfinput type="text" name="due_start_month" id="due_start_month" required="no"  onKeyUp="isNumber(this);">
						</div>
						<label class="col col-3"><cf_get_lang dictionary_id='44681.Ay Sonra'></label>
					</div>
					<div class="form-group" id="item-is_due_endofmonth">
						<label class="col col-4 col-md-6 col-xs-12"></label>
						<label class="col col-8 col-md-6 col-xs-12"><input  type="checkbox" name="is_due_endofmonth" id="is_due_endofmonth" value="1"><cf_get_lang dictionary_id='42969.Vade Ay Sonundan Başlasın'></label>
					</div>
					<div class="form-group" id="item-is_due_beginofmonth">
						<label class="col col-4 col-md-6 col-xs-12"></label>							
						<label class="col col-8 col-md-6 col-xs-12"><input  type="checkbox" name="is_due_beginofmonth" id="is_due_beginofmonth" value="1"><cf_get_lang dictionary_id='60866.Vade Ay Başından Başlasın'></label>
					</div>
					<div class="form-group" id="item-next_day">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='38778.Sonraki'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<!--- dayofweek de pazar 1 - pazartesi 2 olarka geldiği için valuelar bu şekilde --->
							<select name="next_day" id="next_day">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="2"><cf_get_lang dictionary_id='57604.Pazartesi'></option>
								<option value="3"><cf_get_lang dictionary_id='57605.Salı'></option>
								<option value="4"><cf_get_lang dictionary_id='57606.Çarşamba'></option>
								<option value="5"><cf_get_lang dictionary_id='57607.Perşembe'></option>
								<option value="6"><cf_get_lang dictionary_id='57608.Cuma'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<textarea name="detail" id="detail" style="width:150px;height:40px;"></textarea>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-compound_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43502.Basit'> <cf_get_lang dictionary_id='32826.Bileşik Faiz'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input  type="checkbox" name="compound_rate" id="compound_rate"  value="1" onclick="kontrol_et_esitodeme(1);">
						</div>
					</div>
					<div class="form-group" id="item-financial_compound_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43503.Finansal'> <cf_get_lang dictionary_id='32826.Bileşik Faiz'> </label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input  type="checkbox"  name="financial_compound_rate" id="financial_compound_rate" value="1" onclick="kontrol_et_esitodeme(2);">
						</div>
					</div>
					<div class="form-group" id="esit_odeme" style="display:none;">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43504.Eşit Ödeme'> </label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input  type="checkbox" name="balanced_payment" id="balanced_payment" value="1">
						</div>
					</div>
					<div class="form-group" id="item-no_compound_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43663.Faizsiz'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input  type="checkbox" name="no_compound_rate" id="no_compound_rate"  value="1" onclick="kontrol_et_esitodeme(3);">
						</div>
					</div>
					<div class="form-group" id="item-pay_vehicle">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42494.Ödeme Aracı'></label>
						<div class="col col-4 col-xs-12"> 
							<label><cf_get_lang dictionary_id='58007.Çek'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="1" onclick="display_bank()"></label>
							<label><cf_get_lang dictionary_id='58008.Senet'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="2" onclick="display_bank()"></label>
							<label><cf_get_lang dictionary_id='32736.Havale'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="3" onclick="display_bank()"></label>						
						</div>
						<div class="col col-4 col-xs-12"> 
							<label><cf_get_lang dictionary_id='58645.Nakit'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="6" onclick="display_bank()"></label>			
							<label><cf_get_lang dictionary_id='42319.Kapıda Ödeme'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="7" onclick="display_bank()"></label>													
							<label><cf_get_lang dictionary_id='42985.DBS'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="8" onclick="display_bank()"></label>													
						</div>
					</div>
					<div class="form-group" id="item-money">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfinclude template="../query/get_money.cfm">
							<select name="money" id="money">
								<cfoutput query="get_money">
									<option value="#money#"<cfif session.ep.money eq money>selected</cfif>>#money#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-paymethod_our_company_id">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<select name="paymethod_our_company_id" id="paymethod_our_company_id" multiple>
								<cfoutput query="Get_Our_Company">
									<option value="#comp_id#">#nick_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	function temizle_month()
	{
		add_paymethod.due_month.value="";
	}
	function temizle_day()
	{
		add_paymethod.due_day.value="";
	}
	function fixedDate()
	{
		if((trim(document.add_paymethod.due_month.value) != ""))
		{
			record_count=document.add_paymethod.due_month.value;
			delete_();
		}
	}
	function delete_(sy)
	{
		var obj = document.getElementById('fixed');
		for (var i=0;i<obj.childNodes.length;i++){
			obj.removeChild(obj.childNodes[i]);
		}
		add_row();
	}
	var row_count=0;
	function add_row(record_count)
	{
		row_count++;
		var newRow;
		var newCell;
		record_count=document.add_paymethod.due_month.value;
		document.add_paymethod.record_num.value=row_count;
		for(row_count=0; row_count<record_count; row_count++)
		{    
			newRow = document.getElementById("fixed").insertRow(document.getElementById("fixed").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);	
			newRow.className = 'color-row';
			var row_ = row_count + 1;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","fixed_date" + row_count + "_td");
			newCell.innerHTML = '<div class="form-group"><label class="col col-4"><input type="text"  name="installment_name' + row_count +'" value="' + row_ +'.  <cf_get_lang dictionary_id="30631.Tarih">" readonly></label><div class="input-group"><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="text" name="fixed_date' + row_count +'" id="fixed_date_input_group" maxlength="10" value=""></div></div>';
			document.querySelector("#fixed_date" + row_count + "_td .input-group").setAttribute("id","fixed_date_input_group" + row_count + "_td");
			wrk_date_image('fixed_date_input_group' + row_count,'','add_type');
		}
	}
	function kontrol_et_esitodeme(val1)
	{
		if(val1==1)
		{
			add_paymethod.financial_compound_rate.checked=false;
			add_paymethod.no_compound_rate.checked=false;
		}
		else if(val1==2)
		{
			add_paymethod.compound_rate.checked=false;
			add_paymethod.no_compound_rate.checked=false;
			add_paymethod.balanced_payment.checked=true;
		}
		else if(val1==3)
		{
			add_paymethod.compound_rate.checked=false;
			add_paymethod.financial_compound_rate.checked=false;
			add_paymethod.balanced_payment.checked=true;
		}
		
		if(add_paymethod.financial_compound_rate.checked){
			esit_odeme.style.display = '';
		}
		if(add_paymethod.financial_compound_rate.checked==false){
			esit_odeme.style.display = 'none';
		}	
	}	
	function kontrol()
	{
		<cfif control_einvoice.recordcount>
		if(document.getElementById('payment_means_code').value == "")
		{
			alert("<cf_get_lang dictionary_id='56288.Lütfen Ödeme Şekli Kodunu Giriniz'> !");
			return false;
		}
		</cfif>
			
		if(document.add_paymethod.in_advance.value != 100 && (document.add_paymethod.due_month.value == "" || document.add_paymethod.due_month.value == 0))
		{
			alert("<cf_get_lang dictionary_id='65355.Peşinat Oranı %100 Olmadığından, Taksit Sayısı Belirlemeniz Gerekmektedir'>!");
			return false;
		}
		
		if(trim(document.add_paymethod.due_month.value) == "" && trim(document.add_paymethod.due_day.value) == "")
		{
			alert("<cf_get_lang dictionary_id='43501.Ortalama Vade veya Aylık Vade alanlarından birini doldurmalısınız'>!");
			return false;
		}
		
		if (document.getElementById('taksit_kontrol').value == 1)
		{
		<cfif isdefined("xml_fixed_date") and xml_fixed_date eq 1>
			for(r=1;r<document.add_paymethod.due_month.value;r++)
			{
				if(eval("document.add_paymethod.fixed_date"+r) == undefined || eval("document.add_paymethod.fixed_date"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id='65354.Taksit Tarihlerini Eksiksiz Giriniz'>!");
						return false;
					}
			}
		</cfif>
		}
	}	
	
	function taksit_kontrol_()
	{
		if(document.getElementById('due_month').value == 0)
		{
			document.getElementById('taksit_kontrol').value =0;
		}
		else
		{
			document.getElementById('taksit_kontrol').value =1;
		}
	}
	
	function display_bank()
	{
		if (document.add_paymethod.pay_vehicle[5].checked)
			goster(dbs_);
		else
			gizle(dbs_);
	}
</script>
