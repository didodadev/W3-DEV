<!---E.A 23.07.2012 select ifadeleri düzenlendi.--->
<cf_xml_page_edit fuseact="bank.auto_virtual_pos">
<cfquery name="GET_POS_ALL" datasource="#DSN3#">
	SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE POS_TYPE IS NOT NULL AND IS_ACTIVE = 1 ORDER BY (SELECT ACCOUNT_NAME FROM ACCOUNTS WHERE ACCOUNT_ID = BANK_ACCOUNT),LEFT(CARD_NO,3),ISNULL(NUMBER_OF_INSTALMENT,0)
</cfquery>
<cfquery name="get_bank_names" datasource="#DSN#">
	SELECT BANK_ID,BANK_CODE,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfquery name="getSetupPeriod" datasource="#dsn#">
	SELECT PERIOD_YEAR,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# ORDER BY RECORD_DATE DESC
</cfquery>

<cf_catalystHeader>
	<cf_box>
		<cfform name="auto_vir_pos" method="post" action="#request.self#?fuseaction=bank.emptypopup_add_rule">
		<cfif isdefined("attributes.pos_operation_id")>
			<input type="hidden" name="pos_operation_id"  id="pos_operation_id" value="<cfoutput>#attributes.pos_operation_id#</cfoutput>">
			<cfquery name="get_pos_operation" datasource="#dsn3#">
				SELECT 
					POS_OPERATION_ID,
					POS_ID,
					PAY_METHOD_IDS,
					BANK_IDS,
					VOLUME,
					IS_ACTIVE,
					PERIOD_ID,
					START_DATE,
					FINISH_DATE,
					RECORD_DATE,
					RECORD_EMP,
					ERROR_CODES,
					UPDATE_DATE,
					UPDATE_EMP,
					POS_OPERATION_NAME,
					IS_FLAG,
					STOPPED_EMP,
					STOPPED_DATE,
					CARD_TYPE
				FROM 
					POS_OPERATION WITH (NOLOCK) 
				WHERE 
					POS_OPERATION_ID = #attributes.pos_operation_id#
			</cfquery>
			<cfquery name="get_pos_operation_row" datasource="#dsn3#">
				SELECT 
					POS_OPERATION_ROW_ID
				FROM 
					POS_OPERATION_ROW WITH (NOLOCK) 
				WHERE 
					POS_OPERATION_ID = #attributes.pos_operation_id#
			</cfquery>
			<cfset pos_id = get_pos_operation.POS_ID>
			<cfset bank_ids = get_pos_operation.BANK_IDS>
			<cfset pay_method_ = get_pos_operation.PAY_METHOD_IDS>
			<cfset volume = get_pos_operation.VOLUME>
			<cfset active = get_pos_operation.IS_ACTIVE>
			<cfset period_id_ = get_pos_operation.PERIOD_ID>
			<cfset start_date = get_pos_operation.START_DATE>
			<cfset finish_date = get_pos_operation.FINISH_DATE>
			<cfset error_code = get_pos_operation.ERROR_CODES>
			<cfset pos_operation_name = get_pos_operation.POS_OPERATION_NAME>
			<cfset card_type = get_pos_operation.CARD_TYPE>
			<cfquery name="getPaymentInstalment" datasource="#dsn3#">
				SELECT ISNULL(NUMBER_OF_INSTALMENT,0) NUMBER_OF_INSTALMENT FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #pos_id#
			</cfquery>
			<cfquery name="PAYMENT_TYPE_ALL" datasource="#DSN3#">
				SELECT 
					PAYMENT_TYPE_ID,
					CARD_NO 
				FROM 
					CREDITCARD_PAYMENT_TYPE 
				WHERE 
					IS_ACTIVE = 1 AND
					<cfif len(getPaymentInstalment.NUMBER_OF_INSTALMENT)>
						ISNULL(NUMBER_OF_INSTALMENT,0) = #getPaymentInstalment.NUMBER_OF_INSTALMENT#
					<cfelse>
						NUMBER_OF_INSTALMENT IS NULL
					</cfif>
			</cfquery>
		<cfelse>
			<cfset pos_id = ''>
			<cfset bank_ids = ''>
			<cfset pay_method_ = ''>
			<cfset volume = ''>
			<cfset active = ''>
			<cfset period_id_ = ''>
			<cfset start_date = ''>
			<cfset finish_date = ''>
			<cfset error_code = ''>
			<cfset pos_operation_name = ''>
			<cfset card_type = ''>
		</cfif>
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<cfif isdefined("attributes.pos_operation_id")> 
					<div class="form-group id="item-is_active"">
						<label class="col col-4 col-xs-12 hide"><cf_get_lang dictionary_id='57493.Aktif'>/<cf_get_lang dictionary_id='57494.Pasif'></label>
						<div class="col col-8 col-xs-12">
							<label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" value="1" <cfif active eq 1>checked</cfif>></label>
						</div> 
					</div>
				</cfif>
				<div class="form-group" id="item-pos_operation_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58233.Tanım'> *</label>
					<div class="col col-8 col-xs-12">
						<input type="text" id="pos_operation_name"  name="pos_operation_name" value="<cfoutput>#pos_operation_name#</cfoutput>"  maxlength="100">
					</div> 
				</div>
				<div class="form-group" id="item-pos">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57679.POS'> *</label>
					<div class="col col-8 col-xs-12">
						<select name="pos" id="pos"  onchange="payMethodType(this.value);">
							<option value=""><cfoutput>#getLang('','Seçiniz',57734)#</cfoutput></option>
							<cfoutput query="get_pos_all">
								<option value="#PAYMENT_TYPE_ID#" <cfif pos_id eq PAYMENT_TYPE_ID>selected</cfif>>#CARD_NO#</option>
							</cfoutput>
						</select>                                 
					</div> 
				</div>
				<div class="form-group" id="item-cardcat">
					<label class="col col-4 col-xs-12"><cfoutput>#getLang("bank",38,"Kart Tipi")#</cfoutput></label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_combo
							multiple="1"
							name="card_type"
							query_name="GET_CREDITCARD"
							option_name="cardcat"
							value="#card_type#"
							option_value="cardcat_id"
							width="250"> 
					</div> 
				</div>
				<div id="payMethod" style="display:;">
				<cfif isdefined("attributes.pos_operation_id")>
					<div class="form-group" id="item-pay_method">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="pay_method" id="pay_method" multiple="multiple" >
								<cfoutput query="payment_type_all">
									<option value="#payment_type_id#" <cfif listfind(pay_method_,payment_type_id)>selected</cfif>>#card_no#</option>
								</cfoutput>
							</select>                                     
						</div> 
					</div>
					</cfif>
				</div>
				<div class="form-group" id="item-bank_names">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48948.Kart Bankası'><cfif is_bank_required eq 1>*</cfif></label>
					<div class="col col-8 col-xs-12">
						<select name="bank_names" id="bank_names" multiple="multiple" >
							<cfoutput query="get_bank_names">
								<option value="#bank_id#" <cfif listfind(bank_ids,bank_id)>selected</cfif>>#bank_name#</option>
							</cfoutput>
						</select>                                 
					</div> 
				</div>
				<cfif is_bank_error_code eq 1>
				<cfquery name="get_error_codes" datasource="#dsn#">
					SELECT DISTINCT RESP_CODE,RESP_CODE RESP_NAME FROM COMPANY_CC WHERE RESP_CODE IS NOT NULL AND RESP_CODE <> '' ORDER BY RESP_CODE
				</cfquery>
				<cfif isdefined("attributes.pos_operation_id")>
					<cfscript>
						get_old_codes = QueryNew("RESP_CODE,RESP_NAME","VarChar,VarChar");
						row_of_query = 0;
						if(not listfind(error_code,-1))
						{
							row_of_query = row_of_query + 1;
							QueryAddRow(get_old_codes,1);
							QuerySetCell(get_old_codes,"RESP_CODE","-1",row_of_query);
							QuerySetCell(get_old_codes,"RESP_NAME","Hata Kodu Boş Olanlar",row_of_query);
						}
					</cfscript>
					<cfloop list="#error_code#" index="kk">
						<cfscript>
							row_of_query = row_of_query + 1;
							QueryAddRow(get_old_codes,1);
							QuerySetCell(get_old_codes,"RESP_CODE","#kk#",row_of_query);
							if(kk eq -1)
								QuerySetCell(get_old_codes,"RESP_NAME","Hata Kodu Boş Olanlar",row_of_query);
							else
								QuerySetCell(get_old_codes,"RESP_NAME","#kk#",row_of_query);
						</cfscript>
					</cfloop>
					<cfquery name="get_error_codes" dbtype="query">
						SELECT RESP_CODE,RESP_NAME FROM get_error_codes
						UNION
						SELECT RESP_CODE,RESP_NAME FROM get_old_codes
					</cfquery>
				<cfelse>
					<cfscript>
						get_old_codes = QueryNew("RESP_CODE,RESP_NAME","VarChar,VarChar");
						row_of_query = 1;
						QueryAddRow(get_old_codes,1);
						QuerySetCell(get_old_codes,"RESP_CODE","-1",row_of_query);
						QuerySetCell(get_old_codes,"RESP_NAME","Hata Kodu Boş Olanlar",row_of_query);
					</cfscript>
					<cfquery name="get_error_codes" dbtype="query">
						SELECT RESP_CODE,RESP_NAME FROM get_error_codes
						UNION
						SELECT RESP_CODE,RESP_NAME FROM get_old_codes
					</cfquery>
				</cfif>                        
				<div class="form-group" id="item-eror_code">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48679.Hata Kodları'></label>
					<div class="col col-8 col-xs-12">
						<cf_multiselect_check 
							query_name="get_error_codes"  
							name="error_codes" 
							width="250"
							value = "#error_code#"
							option_name="resp_name" 
							option_value="resp_code">                                  
					</div> 
				</div>
				</cfif>
				<div class="form-group" id="item-period_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'> *</label>
					<div class="col col-8 col-xs-12">
						<select name="period_id" id="period_id" >
							<option value=""><cfoutput>#getLang('','Seçiniz',57734)#</cfoutput></option>
							<cfoutput query="getSetupPeriod">
								<option value="#period_id#" <cfif period_id_ eq period_id>selected</cfif>>#period_year#</option>
							</cfoutput>
						</select>                                 
					</div> 
				</div>
				<div class="form-group" id="item-start_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48680.Ödeme Planı Tarihi'></label>
					<div class="col col-8 col-xs-12">
						
						<div class="col col-6 col-xs-12">
							<div class="input-group"> 
								<cfinput type="text" name="start_date"  value="#dateformat(start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
						<div class="col col-6 col-xs-12">
							<div class="input-group"> 
								<cfinput type="text" name="finish_date"  value="#dateformat(finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>   
							</div>                         	
						</div>  
					</div> 
				</div>
				<div class="form-group" id="item-buton_1">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30114.Hacim'><cf_get_lang dictionary_id='58998.Hesapla'></label>
						<div class="col col-8 text-right">
							<input type="button" onClick="get_total();" value="<cf_get_lang dictionary_id='30114.Hacim'><cf_get_lang dictionary_id='58998.Hesapla'>"> 
						</div>
				</div>
				<div id="total">

				</div>
				<div class="form-group" id="item-ava_vol">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48682.Geçirilecek Hacim'>*</label>
					<div class="col col-8 col-xs-12">
						<input type="text" class="moneybox" name="ava_vol" id="ava_vol" value="<cfif len(volume)><cfoutput>#tlformat(volume)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event,2));"> 
					</div> 
				</div>
				
			</div>
		
		</cf_box_elements>
		<cf_box_footer>
			<cfif isdefined("attributes.pos_operation_id")>
				<cfset setClass="col col-6 col-xs-12 text-right">
				<div class="col col-6 col-xs-12">
					<cf_record_info query_name="get_pos_operation">
					<cfif len(get_pos_operation.stopped_emp)>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="56332.İşlemi Durduran">:</label>
					<div class="col col-8 col-xs-12">
							<cfoutput>#get_emp_info(get_pos_operation.stopped_emp,1,1)# - #dateformat(get_pos_operation.stopped_date,dateformat_style)# #timeformat(get_pos_operation.stopped_date,timeformat_style)#</cfoutput> 
					</div> 
					</div>
					</cfif> 
				</div>
			<cfelse>
				<cfset setClass="col col-12 text-right">
			</cfif>
			<div class="<cfoutput>#setClass#</cfoutput>">
				<input type="button" onClick="add_rule();" value="<cfif isdefined("attributes.pos_operation_id")><cf_get_lang no='27.Kural Güncelle'><cfelse><cf_get_lang no='23.Kural Ekle'></cfif>">
			</div>
		</cf_box_footer>
          

	</cfform> 
</cf_box>
<script type="text/javascript">
	function add_rule()
	{  
		<cfif isdefined("attributes.pos_operation_id") and get_pos_operation_row.recordcount>
			get_flag = wrk_query('SELECT IS_FLAG FROM POS_OPERATION WITH (NOLOCK) WHERE POS_OPERATION_ID = <cfoutput>#attributes.pos_operation_id#</cfoutput>','dsn3');
			if(get_flag.IS_FLAG == 1)
			{
				alert("<cf_get_lang dictionary_id='56333.Sanal Pos Çekimi Yapıldığı İçin Kuralı Güncelleyemezsiniz'>!");
				return false;
			}
		</cfif>
		
		
		if(!$("#pos_operation_name").val().length)
		{
			alertObject({message: "<cf_get_lang dictionary_id='51288.Lütfen Kural Tanımı Giriniz'>"})    
			return false;
		}
			if(!$("#pos").val().length)
			{
				alertObject({message: "<cf_get_lang dictionary_id='56338.Lütfen POS Seçimi Yapınız'>"})    
				return false;
			}
			
			if(!$('#pay_method :selected').length)
			{
				alertObject({message: "<cf_get_lang dictionary_id='58027.Lütfen Ödeme Yöntemi Seçiniz'>!"})    
				return false;
		    }
		<cfif is_bank_required eq 1>
			if(!$('#bank_names :selected').length)
			{
				alertObject({message: "<cf_get_lang dictionary_id='56339.Kart Bankası Giriniz'>!"})    
				return false;
		    }
		</cfif>
		if(!$("#period_id").val().length)
		{
			alertObject({message: "<cf_get_lang dictionary_id='48567.Dönem Seçiniz'>!"})    
			return false;
		}
		

		
		/*if (document.auto_vir_pos.pay_method.value == '')
		{
			alert('Lütfen En Az Bir Ödeme Yöntemi Seçimi Yapınız!');
			return false;
		}*/
		if (document.auto_vir_pos.ava_vol.value == '')
		{
			alert("<cf_get_lang dictionary_id='56343.Lütfen Geçirilecek Hacim Tutarı Giriniz'>!");
			return false;
		}
		if(document.auto_vir_pos.ava_total != undefined)
		{
			if(parseFloat(filterNum(document.auto_vir_pos.ava_vol.value)) > parseFloat(filterNum(document.auto_vir_pos.ava_total.value)))
			{
				alert("<cf_get_lang dictionary_id='56349.Geçirilecek Hacim Hesaplanan Hacimden Büyük Olamaz'>!");
				return false;
			}
		}
		<cfif isdefined("attributes.pos_operation_id") and get_pos_operation_row.recordcount>
			if(!confirm('İşlemi Güncellediğinizde Operasyon Satırları da Silinecektir. Emin misiniz ?'))
				return false;
		</cfif>
		document.auto_vir_pos.ava_vol.value = filterNum(document.auto_vir_pos.ava_vol.value);
		if(document.auto_vir_pos.ava_total != undefined)
			document.auto_vir_pos.ava_total.value = filterNum(document.auto_vir_pos.ava_total.value);
			document.auto_vir_pos.submit();
		return true;	
	}
	function payMethodType(x)
	{
		document.auto_vir_pos.ava_vol.value = 0;
		if(x != '')
		{
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.emptypopup_get_pos_operation_pay_method&payMethodId_='+x+'','payMethod','1');
			document.getElementById('payMethod').style.display = "";
		}
		else
			document.getElementById('payMethod').style.display = "none";
	}
	function get_total()
	{
		if (document.getElementById('pos').value == '')
		{
			alert("<cf_get_lang dictionary_id='56338.Lütfen POS Seçimi Yapınız'>");
			return false;
		}
		if (document.auto_vir_pos.pay_method.value == '')
		{
			alert("<cf_get_lang dictionary_id='56350.Lütfen En Az Bir Ödeme Yöntemi Seçimi Yapınız'>");
			return false;
		}
		<cfif is_bank_required eq 1>
			if (document.auto_vir_pos.bank_names.value == '')
			{
				alert("<cf_get_lang dictionary_id='56362.Lütfen En Az Bir Kart Bankası Seçimi Yapınız'>");
				return false;
			}
		</cfif>
		if (document.auto_vir_pos.period_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='56366.Lütfen Dönem Seçimi Yapınız'>");
			return false;
		}
		
		var pay_met_list='';
		for(kk=0;kk<document.auto_vir_pos.pay_method.length; kk++)
		{
			if(auto_vir_pos.pay_method[kk].selected && auto_vir_pos.pay_method.options[kk].value.length!='')
			pay_met_list = pay_met_list + ',' + auto_vir_pos.pay_method.options[kk].value;
		}
		pay_met_list = pay_met_list + ',';
		
		var bank_id_list='';
		for(kk=0;kk<document.auto_vir_pos.bank_names.length; kk++)
		{
			if(auto_vir_pos.bank_names[kk].selected && auto_vir_pos.bank_names.options[kk].value.length!='')
			bank_id_list = bank_id_list + ',' + auto_vir_pos.bank_names.options[kk].value;
		}
		bank_id_list = bank_id_list + ',';
		
		var card_type_list='';
		for(kk=0;kk<document.auto_vir_pos.card_type.length; kk++)
		{
			if(auto_vir_pos.card_type[kk].selected && auto_vir_pos.card_type.options[kk].value.length!='')
			card_type_list = card_type_list + ',' + auto_vir_pos.card_type.options[kk].value;
		}
		card_type_list = card_type_list + ',';
		<cfif is_bank_error_code eq 1>
			var error_codes_list='';
			for(kk=0;kk<document.auto_vir_pos.error_codes.length; kk++)
			{
				if(auto_vir_pos.error_codes[kk].selected && auto_vir_pos.error_codes.options[kk].value.length!='')
				error_codes_list = error_codes_list + ',' + auto_vir_pos.error_codes.options[kk].value;
			}
			error_codes_list = error_codes_list + ',';
			<cfif not isdefined("attributes.pos_operation_id")>
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_get_total&error_codes='+error_codes_list+'&finish_date='+document.auto_vir_pos.finish_date.value+'&start_date='+document.auto_vir_pos.start_date.value+'&period_id='+document.auto_vir_pos.period_id.value+'&bank_id_list='+bank_id_list+'&pay_met_list='+pay_met_list+'&card_type_list='+card_type_list+'','total','1');
			<cfelse>
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=bank.popup_get_total&error_codes='+error_codes_list+'&pos_operation_id=#attributes.pos_operation_id#</cfoutput>&finish_date='+document.auto_vir_pos.finish_date.value+'&start_date='+document.auto_vir_pos.start_date.value+'&period_id='+document.auto_vir_pos.period_id.value+'&bank_id_list='+bank_id_list+'&pay_met_list='+pay_met_list+'&card_type_list='+card_type_list+'','total','1');
			</cfif>
		<cfelse>
			<cfif not isdefined("attributes.pos_operation_id")>
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_get_total&finish_date='+document.auto_vir_pos.finish_date.value+'&start_date='+document.auto_vir_pos.start_date.value+'&period_id='+document.auto_vir_pos.period_id.value+'&bank_id_list='+bank_id_list+'&pay_met_list='+pay_met_list+'','total','1');
			<cfelse>
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=bank.popup_get_total&pos_operation_id=#attributes.pos_operation_id#</cfoutput>&finish_date='+document.auto_vir_pos.finish_date.value+'&start_date='+document.auto_vir_pos.start_date.value+'&period_id='+document.auto_vir_pos.period_id.value+'&bank_id_list='+bank_id_list+'&pay_met_list='+pay_met_list+'','total','1');
			</cfif>
		</cfif>
	}
</script>


