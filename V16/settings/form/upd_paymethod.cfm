<cfinclude template="../../objects/query/payment_means_code.cfm">
<cf_xml_page_edit fuseact="settings.form_add_paymethod">
<cfquery name="Get_Our_Company" datasource="#DSN#">
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfquery name="Get_Paymethod_Our_Company" datasource="#dsn#"><!--- Ilıskili Sirketler --->
	SELECT OUR_COMPANY_ID FROM SETUP_PAYMETHOD_OUR_COMPANY WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.paymethod_id#">
</cfquery>

<cfset Paymethod_Our_Comp_List = ValueList(Get_Paymethod_Our_Company.Our_Company_Id,',')>

<cfquery name="PAYMETHODS" datasource="#DSN#">
    SELECT
		#dsn#.Get_Dynamic_Language(PAYMETHOD_ID,'#session.ep.language#','SETUP_PAYMETHOD','PAYMETHOD',NULL,NULL,PAYMETHOD) AS PAYMETHOD,
        *
    FROM 
        SETUP_PAYMETHOD 
    WHERE 
        PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.paymethod_id#">
</cfquery>

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
	<cf_box title="#getLang('settings','Ödeme Yöntemi Güncelle',42636)#">
		<cfform name="paymethod" method="post" action="#request.self#?fuseaction=settings.emptypopup_paymethod_upd">
			<cf_box_elements>	
				<input type="hidden" name="record_num" id="record_num" value="<cfoutput><cfif isdefined("attributes.due_month") and len(attributes.due_month)>#attributes.due_month#<cfelse>0</cfif></cfoutput>"/>
				<input type="Hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#url.paymethod_id#</cfoutput>"><input type="hidden" name="record_num" id="record_num" value="<cfoutput><cfif isdefined("attributes.due_month") and len(attributes.due_month)>#attributes.due_month#<cfelse>0</cfif></cfoutput>" />
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-status">
						<div class="col col-4 col-md-6 col-xs-12">
							<cf_get_lang dictionary_id='57493.Aktif'>
							<input type="checkbox" name="status" id="status"  <cfif paymethods.paymethod_status eq 1>checked</cfif>>
						</div>
						<div class="col col-4 col-md-6 col-xs-12">
							<cf_get_lang dictionary_id='58885.Partner'>
							<input type="checkbox" name="is_partner" id="is_partner"  <cfif paymethods.is_partner eq 1>checked</cfif>>
						</div>
						<div class="col col-4 col-md-6 col-xs-12">
							<cf_get_lang dictionary_id='30964.Public'>
							<input type="checkbox" name="is_public" id="is_public"  <cfif paymethods.is_public eq 1>checked</cfif>>
						</div>
					</div>
					<cfif isdefined("xml_date_control") and xml_date_control eq 1>
						<div class="form-group" id="item-is_due">
							<div class="col col-12 col-md-12 col-xs-12">
								<input type="checkbox" name="is_due" id="is_due"  <cfif paymethods.IS_DATE_CONTROL eq 1>checked</cfif>>
								<cf_get_lang dictionary_id='46679.Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin'>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-paymethod">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='42612.Ödeme Yöntemi girmelisiniz'> !</cfsavecontent>
									<cfinput type="Text" name="paymethod" size="30" value="#paymethods.paymethod#" maxlength="100" required="Yes" message="#message#">									
									<span class="input-group-addon"><cf_language_info 
									table_name="SETUP_PAYMETHOD" 
									column_name="PAYMETHOD" 
									column_id_value="#url.paymethod_id#" 
									maxlength="100" 
									datasource="#dsn#" 
									column_id="PAYMETHOD_ID" 
									control_type="0"></span>
								</div>
							</div>
					</div>
					<div class="form-group" id="item-payment_means_code">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57847.Ödeme'><cf_get_lang dictionary_id='58663.Şekli'><cf_get_lang dictionary_id='58585.Kod'><cfif control_einvoice.recordcount>*</cfif></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<select name="payment_means_code" id="payment_means_code">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="payment_means_code">
									<option value="#payment_means_code_id#,#detail#" title="#payment_means_code#" <cfif paymethods.payment_means_code eq payment_means_code.payment_means_code_id>selected="selected"</cfif>>#detail#</option>
								</cfoutput>
							</select>      
						</div>
					</div>
					<div class="form-group" id="dbs_" <cfif paymethods.payment_vehicle neq 8>style="display:none;"</cfif>>
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='30349.Banka Adi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfquery name="get_bank_names" datasource="#dsn#">
								SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
							</cfquery>
							<select name="bank_id" id="bank_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_bank_names">
									<option value="#bank_id#" <cfif get_bank_names.bank_id eq paymethods.bank_id>selected</cfif>>#bank_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-in_advance">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42490.Peşinat Oranı'> % *</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='42606.Peşinat Oranı girmelisiniz'></cfsavecontent>
							<cfinput  class="moneybox" type="text"  range="0,100"  message="#message#"  required="no" name="in_advance" value="#paymethods.in_advance#" onKeyUp="isNumber(this);">
						</div>
					</div>
					<div class="form-group" id="item-due_date_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42492.Vade Farkı Oranı % / Ay'>*</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='52380.Vade Farkı Oranı girmelisiniz'></cfsavecontent>
							<cfinput class="moneybox" type="text" name="due_date_rate" message="#message#" required="yes" value="#TLFormat(paymethods.due_date_rate)#" passthrough="onkeyup=""return(formatcurrency(this,event));""">							
						</div>
					</div>
					<div class="form-group" id="item-first_interest_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43659.Erken Ödeme İndirimi'> %</label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfinput class="moneybox" type="text" required="no" name="first_interest_rate"  value="#TlFormat(paymethods.first_interest_rate,4)#" onKeyUp="return(FormatCurrency(this,event,4));">
						</div>
					</div>	
					<div class="form-group" id="item-due_day">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57861.Ortalama Vade'></label>							
						<div class="col col-5 col-md-6 col-xs-12">
							<input type="text" name="due_day" id="due_day" value="<cfoutput>#paymethods.due_day#</cfoutput>" onchange="temizle_month();" onkeyup="isNumber(this);">
						</div>
						<div class="col col-3 col-md-4 col-xs-12">
							<input type="checkbox" name="is_business_due_day" id="is_business_due_day" value="1" <cfif len(paymethods.is_business_due_day) and paymethods.is_business_due_day>checked</cfif>>
							<label><cf_get_lang dictionary_id='65353.İş Günü'></label>
						</div>
					</div>
					<div class="form-group" id="item-taksit_kontrol">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42489.Vade Aylık Taksitlerle'></label>
						<div class="col col-4 col-md-6 col-xs-12">
							<input type="text" name="due_month" id="due_month"  value="<cfoutput>#paymethods.due_month#</cfoutput>" onchange="temizle_day();" onkeyup="isNumber(this);">									
						</div>
						<div  class="col col-4 col-md-6 col-xs-12">
							<cfif isdefined("xml_fixed_date") and xml_fixed_date eq 1>
								<cfif isdefined("xml_fixed_date") and xml_fixed_date eq 1><a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra" name="due_format" id="due_format" value="" onclick="fixedDate();taksit_kontrol_();"><cf_get_lang dictionary_id='42975.Taksit Belirle'></a></cfif>
								<input type="hidden" name="taksit_kontrol" id="taksit_kontrol" value="0"/>	
							</cfif>				
						</div>								
					</div>
					<cfif isdefined("xml_fixed_date") and xml_fixed_date eq 1>
						<table name="fixed" id="fixed">
							<cfif paymethods.recordcount>
								<cfoutput query="paymethods">
									<cfif len(paymethod_id)>
										<cfquery name="get_paymethods_fixed_date" datasource="#dsn#">
											SELECT 
                                                FIXED_DATE_ID, 
                                                PAYMETHOD_ID, 
                                                FIXED_DATE, 
                                                INSTALLMENT_NAME 
                                            FROM 
                                                SETUP_PAYMETHOD_FIXED_DATE 
                                            WHERE 
                                                PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymethod_id#"> 
                                            ORDER BY 
                                            	FIXED_DATE_ID
										</cfquery>
									<cfelse>
										<cfset get_paymethods_fixed_date.recordcount = 0>
									</cfif>
								</cfoutput>
								<cfoutput query="get_paymethods_fixed_date">
									<div class="form-group" id="frm_row#currentrow#" class="color-row">
										<label class="col col-4"> 
											<input type="text" name="installment_name#currentrow#" id="installment_name#currentrow#" value="#get_paymethods_fixed_date.installment_name#" readonly style="border:0;">
										</label>
										<div class="input-group">
											<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
											<input type="text" name="fixed_date#currentrow#"  id="fixed_date#currentrow#" value="#DateFormat(get_paymethods_fixed_date.fixed_date,dateformat_style)#">
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
							<input class="moneybox" type="text" name="delay_interest_rate" id="delay_interest_rate" value="<cfoutput>#TlFormat(paymethods.delay_interest_rate,4)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,4));">
						</div>
					</div>
					<div class="form-group" id="item-delay_interest_day">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43661.Gecikme Faizi Başlangıcı'></label>
						<div class="col col-5 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='43568.Gecikme Faizi Başlangıcı Girmelisiniz'> !</cfsavecontent>
							<cfinput class="moneybox" type="text" required="no" message="#message#" name="delay_interest_day" value="#paymethods.delay_interest_day#"onKeyUp="isNumber(this);">
						</div>
						<label class="col col-3"><cf_get_lang dictionary_id='43664.Gün Sonra'></label>
					</div>
					<div class="form-group" id="item-due_start_day">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43662.Vade Başlangıcı'></label>
						<div class="col col-5 col-md-6 col-xs-12">
							<cfinput type="text" required="no" message="#message#" name="due_start_day" value="#paymethods.due_start_day#"  onKeyUp="isNumber(this);">
						</div>
						<label class="col col-3"><cf_get_lang dictionary_id='43664.Gün Sonra'></label>
					</div>
					<div class="form-group" id="item-due_start_month">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43662.Vade Başlangıcı'></label>
						<div class="col col-5 col-md-6 col-xs-12">
							<cfinput type="text" required="no" name="due_start_month" value="#paymethods.due_start_month#" onKeyUp="isNumber(this);">
						</div>
						<label class="col col-3"><cf_get_lang dictionary_id='44681.Ay Sonra'></label>
					</div>
					<div class="form-group" id="item-is_due_endofmonth">
						<label class="col col-4 col-md-6 col-xs-12"></label>
						<label class="col col-8 col-md-6 col-xs-12"><input  type="checkbox" name="is_due_endofmonth" id="is_due_endofmonth" value="1" <cfif paymethods.is_due_endofmonth eq 1>checked</cfif>><cf_get_lang dictionary_id='42969.Vade Ay Sonundan Başlasın'></label>
					</div>
					<div class="form-group" id="item-is_due_beginofmonth">
						<label class="col col-4 col-md-6 col-xs-12"></label>
						<label class="col col-8 col-md-6 col-xs-12"><input  type="checkbox" name="is_due_beginofmonth" id="is_due_beginofmonth" value="1" <cfif paymethods.is_due_beginofmonth eq 1>checked</cfif>><cf_get_lang dictionary_id='60866.Vade Ay Sonundan Başlasın'></label>
					</div>
					<div class="form-group" id="item-next_day">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='38778.Sonraki'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<!--- dayofweek de pazar 1 - pazartesi 2 olarka geldiği için valuelar bu şekilde --->
							<select name="next_day" id="next_day">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="2" <cfif paymethods.next_day eq 2>selected</cfif>><cf_get_lang dictionary_id='57604.Pazartesi'></option>
								<option value="3" <cfif paymethods.next_day eq 3>selected</cfif>><cf_get_lang dictionary_id='57605.Salı'></option>
								<option value="4" <cfif paymethods.next_day eq 4>selected</cfif>><cf_get_lang dictionary_id='57606.Çarşamba'></option>
								<option value="5" <cfif paymethods.next_day eq 5>selected</cfif>><cf_get_lang dictionary_id='57607.Perşembe'></option>
								<option value="6" <cfif paymethods.next_day eq 6>selected</cfif>><cf_get_lang dictionary_id='57608.Cuma'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<textarea name="detail" id="detail"><cfoutput>#paymethods.detail#</cfoutput></textarea>
						</div>
					</div>
				</div>
				<div  class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-compound_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43502.Basit'> <cf_get_lang dictionary_id='32826.Bileşik Faiz'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input  type="checkbox" value="1" name="compound_rate" id="compound_rate" <cfif paymethods.compound_rate eq 1>Checked</cfif> onclick="kontrol_et_esitodeme(1);">
						</div>
					</div>
					<div class="form-group" id="item-financial_compound_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43503.Finansal'> <cf_get_lang dictionary_id='32826.Bileşik Faiz'> </label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input  type="checkbox"  value="1" name="financial_compound_rate" id="financial_compound_rate" onclick="kontrol_et_esitodeme(2);" <cfif paymethods.financial_compound_rate eq 1>Checked</cfif>>
						</div>
					</div>
					<div class="form-group" id="esit_odeme" style="display:none;">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43504.Eşit Ödeme'> </label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input  type="checkbox"  value="1" name="balanced_payment" id="balanced_payment" <cfif paymethods.balanced_payment eq 1>Checked</cfif>>
						</div>
					</div>
					<div class="form-group" id="item-no_compound_rate">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43663.Faizsiz'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<input  type="checkbox"  value="1" name="no_compound_rate" id="no_compound_rate" onclick="kontrol_et_esitodeme(3);" <cfif paymethods.no_compound_rate eq 1>Checked</cfif>>
						</div>
					</div>
					<div class="form-group" id="item-pay_vehicle">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42494.Ödeme Aracı'></label>
						<div class="col col-4 col-xs-12"> 
							<label><cf_get_lang dictionary_id='58007.Çek'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="1" <cfif paymethods.payment_vehicle eq 1>checked</cfif> onclick="display_bank();"></label>
							<label><cf_get_lang dictionary_id='58008.Senet'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="2" <cfif paymethods.payment_vehicle eq 2>checked</cfif> onclick="display_bank();"></label>
							<label><cf_get_lang dictionary_id='32736.Havale'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="3" <cfif paymethods.payment_vehicle eq 3>checked</cfif> onclick="display_bank();"></label>						
						</div>
						<div class="col col-4 col-xs-12"> 
							<label><cf_get_lang dictionary_id='58645.Nakit'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="6" <cfif paymethods.payment_vehicle eq 6>checked</cfif> onclick="display_bank();"></label>			
							<label><cf_get_lang dictionary_id='42319.Kapıda Ödeme'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="7" <cfif paymethods.payment_vehicle eq 7>checked</cfif> onclick="display_bank();"></label>													
							<label><cf_get_lang dictionary_id='42985.DBS'><input type="radio" name="pay_vehicle" id="pay_vehicle" value="8" <cfif paymethods.payment_vehicle eq 8>checked</cfif> onclick="display_bank();"></label>													
						</div>
					</div>
					<div class="form-group" id="item-money">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<cfinclude template="../query/get_money.cfm">
							<select name="money" id="money" >
								<cfoutput query="get_money">
									<option value="#money#" <cfif paymethods.money eq money>Selected</cfif>>#money#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-paymethod_our_company_id">
						<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
						<div class="col col-8 col-md-6 col-xs-12">
							<select name="paymethod_our_company_id" id="paymethod_our_company_id" multiple>
								<cfoutput query="Get_Our_Company">
									<option value="#comp_id#"  <cfif ListFind(Paymethod_Our_Comp_List,comp_id)>selected</cfif>>#nick_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>	
				<cf_record_info query_name="paymethods">
				<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_cancel="0" delete_page_url='#request.self#?fuseaction=settings.emptypopup_paymethod_del&paymethod_id=#URL.PAYMETHOD_ID#&head=#paymethods.paymethod#'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function temizle_month()
	{
		paymethod.due_month.value="";
	}
	function temizle_day()
	{
		paymethod.due_day.value="";
	}
	function fixedDate()
	{
		if((trim(document.paymethod.due_month.value) != ""))
		{
			record_count=document.paymethod.due_month.value;
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
		record_count=document.paymethod.due_month.value;
		document.paymethod.record_num.value=row_count;
		for(row_count=1; row_count<=record_count; row_count++)
		{
			newRow = document.getElementById("fixed").insertRow(document.getElementById("fixed").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);	
			newRow.className = 'color-row';
			var row_ = row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","fixed_date" + row_count + "_td");
			newCell.innerHTML = '<div class="form-group"><label class="col col-4"><input type="text"  name="installment_name' + row_count +'" value="' + row_ +'.  <cf_get_lang dictionary_id="30631.Tarih">" readonly></label><div class="input-group"><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="text" name="fixed_date' + row_count +'" id="fixed_date" maxlength="10" value=""></div></div>';
			document.querySelector("#fixed_date" + row_count + "_td .input-group").setAttribute("id","fixed_date_" + row_count + "_td");
			wrk_date_image('fixed_date_' + row_count,'','add_type');
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '&nbsp;';
		}
	}
	
	function kontrol_et_esitodeme(val1)
	{
		if(val1==1)
		{
			paymethod.financial_compound_rate.checked=false;
			paymethod.no_compound_rate.checked=false;
		}
		else if(val1==2)
		{
			paymethod.compound_rate.checked=false;
			paymethod.no_compound_rate.checked=false;
			paymethod.balanced_payment.checked=true;
		}
		else if(val1==3)
		{
			paymethod.compound_rate.checked=false;
			paymethod.financial_compound_rate.checked=false;
			paymethod.balanced_payment.checked=true;
		}
		
		if(paymethod.financial_compound_rate.checked){
			esit_odeme.style.display = '';
		}
		if(paymethod.financial_compound_rate.checked==false){
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
					
		if(document.paymethod.in_advance.value != 100 && (document.paymethod.due_month.value == "" || document.paymethod.due_month.value == 0))
		{
			alert("<cf_get_lang dictionary_id='65355.Peşinat Oranı %100 Olmadığından, Taksit Sayısı Belirlemeniz Gerekmektedir'>!");
			return false;
		}
		
		if(trim(document.paymethod.due_month.value) == "" && trim(document.paymethod.due_day.value) == "")
		{
			alert("<cf_get_lang dictionary_id='43501.Ortalama Vade veya Aylık Vade alanlarından birini doldurmalısınız'>!");
			return false;
		}
		
		if(document.paymethod.due_date_rate.value != "")
		{
			due_date_rate_ = filterNum(document.paymethod.due_date_rate.value);
			if(due_date_rate_>100)
			{
				alert("<cf_get_lang dictionary_id='43839.Vade Farkı Oranını Kontrol Ediniz'> !");
				return false;
			}
		}
		
		if (document.getElementById('taksit_kontrol').value == 1)
		{
			<cfif isdefined("xml_fixed_date") and xml_fixed_date eq 1>
				for(r=1;r<=document.paymethod.due_month.value;r++)
				{
					if(eval("document.paymethod.fixed_date"+r) == undefined || eval("document.paymethod.fixed_date"+r).value == "")
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
		if (document.paymethod.pay_vehicle[5].checked)
			goster(dbs_);
		else
			gizle(dbs_);
	}
</script>
