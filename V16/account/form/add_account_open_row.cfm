<cf_xml_page_edit fuseact="account.account_open_row">
<cfquery name="get_money_bskt" datasource="#dsn2#">
	SELECT MONEY AS MONEY_TYPE,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1
</cfquery>
<cf_box title="#getLang('account',161)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_bill_" action="#request.self#?fuseaction=account.emptypopup_add_account_open_row&card_id=#attributes.card_id#" method="post">
	<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
		<cf_box_elements vertical="1">
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id='47299.Hesap Kodu'></label>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="text" name="acc_code" value="" onFocus="AutoComplete_Create('acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','ACCOUNT_CODE,ACCOUNT_NAME,IFRS_CODE,ACCOUNT_CODE2','acc_code,acc_name,ifrs_code,account_code2','','3','225');" >
						<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac();"></span>
					</div>
				</div>																					
			</div>
			<cfif session.ep.our_company_info.is_ifrs eq 1>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<label><cf_get_lang dictionary_id='58130.UFRS Kod'></label>
					</div>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="ifrs_code" id="ifrs_code"  value="">
					</div>					
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<label><cf_get_lang dictionary_id='57789.Özel Kod'></label>
					</div>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="account_code2" id="account_code2" value="">
					</div>		
				</div>
			</cfif>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id='57897.Adı'></label>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<input type="text" name="acc_name" id="acc_name" value="">
				</div>
			</div>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id='57629.Açıklama'></label>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<input type="text" name="detail"  id="detail" value="">
				</div>		
			</div>
			<cfif xml_acc_branch_info eq 1>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<label><cf_get_lang dictionary_id ='57453.Şube'></label>
					</div>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='155' is_default='1' is_deny_condivol='1'>
					</div>					
				</div>
			</cfif>
			<cfif xml_acc_department_info eq 1>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<label><cf_get_lang dictionary_id='57572.Departman'></label>
					</div>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' width='155' is_deny_condivol='0'>
					</div>										
				</div>
			</cfif>
			<cfif xml_acc_project_info eq 1>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<label><cf_get_lang dictionary_id='57416.Proje'></label>
					</div>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cf_wrkProject fieldName="project_name" AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5" width="155" boxwidth="600" boxheight="400" buttontype="2">					
					</div>					
				</div>
			</cfif>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id='57587.Borç'></label>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<input type="text" name="debt" id="debt" value="0" onBlur="sil(0);kur_hesapla();"onkeyup="return(FormatCurrency(this,event));" class="moneybox">
				</div>
			</div>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id='57588.Alacak'></label>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<input type="text" name="claim" id="claim" value="0" onBlur="sil(1);kur_hesapla();"onkeyup="return(FormatCurrency(this,event));" class="moneybox">
				</div>
			</div> 
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id ='57279.Döviz Tutar'></label>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<input type="text" name="other_cash_amount" id="other_cash_amount" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
				<input type="hidden" name="other_cash_currency" id="other_cash_currency" value=""><!--- secilen döviz birimi bu inputa atanıyor ve account_card_rowsa bu deger yazılıyor --->				
				</div>
			</div>  
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id='58905.Sistem Dövizi'></label>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="text" name="amount_2" id="amount_2" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
						<span class="input-group-addon width">
							<cfif len(session.ep.money2)><cfoutput>#session.ep.money2#</cfoutput></cfif>
						</span>
					</div>
				</div>
			</div>         						
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id='57635.Miktar'></label>
				</div>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<input type="text" name="quantity" id="quantity" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
				</div>	
			</div>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<label><cf_get_lang dictionary_id='49891.Döviz Birimi'></label>
				</div>
				<div class="form-group">
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfif isdefined("get_note")>
							<cfscript>f_kur_ekle(action_id:attributes.id,process_type:1,base_value:'action_value',other_money_value:'other_cash_act_value',form_name:'cari',action_table_name:'CARI_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'ACTION_CURRENCY_ID');</cfscript>
						<cfelse>
							<cfscript>f_kur_ekle(process_type:0,base_value:'action_value',other_money_value:'other_cash_act_value',form_name:'cari',select_input:'ACTION_CURRENCY_ID');</cfscript>
						</cfif>
					</div>
				</div>
			</div>			
	</cf_box_elements>	
	
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function="kontrol()">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function sil(gelen)
	{
		if( (gelen==0) && (add_bill_.debt.value.length) && (add_bill_.claim.value.length) )
		add_bill_.claim.value = '';
		else if ( (gelen==1) && (add_bill_.debt.value.length) && (add_bill_.claim.value.length) )
		add_bill_.debt.value = '';
	}
	function kur_hesapla(money_)
	{
		var sel_money_='';
		for(var cur_i=1;cur_i<=document.add_bill_.kur_say.value;cur_i++)
		{
			if( eval('document.add_bill_.rd_money['+(cur_i-1)+'].checked'))
			{
				sel_money_rate = filterNum(eval('document.add_bill_.txt_rate2_'+cur_i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				sel_money_=eval('document.add_bill_.hidden_rd_money_'+cur_i).value ;
				document.add_bill_.other_cash_currency.value=sel_money_;
				bsk_money_row_no = cur_i;
			}
			if( eval('document.add_bill_.hidden_rd_money_'+(cur_i)).value == '<cfoutput>#session.ep.money2#</cfoutput>') //sistem 2.para birimi kuru alınıyor 
				system_money_2_rate_ = filterNum(eval('document.add_bill_.txt_rate2_'+cur_i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}	
			
		if(document.add_bill_.debt.value !='')
			acc_action_value=filterNum(document.add_bill_.debt.value);
		else
			acc_action_value=filterNum(document.add_bill_.claim.value);
			
		if( sel_money_!='') //diger doviz secilmisse
		{
			if(acc_action_value != '' && acc_action_value !=0)
				document.add_bill_.other_cash_amount.value=commaSplit(acc_action_value/sel_money_rate,2);
			else
				document.add_bill_.other_cash_amount.value=commaSplit(0);
		}
		<cfif len(session.ep.money2)>
			if(money_==undefined && system_money_2_rate_!= undefined)//islem döviz birimi degiştirildiginde sistem dövizini tekrar hesaplamasına gerek yok
				document.add_bill_.amount_2.value=commaSplit(acc_action_value/system_money_2_rate_);
		</cfif>
	}
	function kontrol()
	{
		if((add_bill_.debt.value=='') && (add_bill_.claim.value==''))
		{
			alert("<cf_get_lang dictionary_id ='58589.Değer Girmelisiniz'>!");
			return false;
		}
		
		if( (add_bill_.debt.value=='' || add_bill_.debt.value=='0') && (add_bill_.claim.value=='' || add_bill_.claim.value=='0') )
		{
			alert("<cf_get_lang dictionary_id='814.Tüm Değerler Sıfır veya Boş Olamaz'>");
			return false;
		}
		if(add_bill_.amount_2.value=='' || add_bill_.amount_2.value==0)
		{
			alert("<cf_get_lang dictionary_id ='50062.Sistem Dövizi Değeri Girmelisiniz'>!");
			return false;
		}
		add_bill_.debt.value = filterNum(add_bill_.debt.value);
		add_bill_.claim.value = filterNum(add_bill_.claim.value);
		add_bill_.other_cash_amount.value = filterNum(add_bill_.other_cash_amount.value);
		add_bill_.amount_2.value = filterNum(add_bill_.amount_2.value);	
		add_bill_.quantity.value = filterNum(add_bill_.quantity.value);
		return true;
	}		
	
	function pencere_ac()
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_bill_.acc_code<cfif session.ep.our_company_info.is_ifrs eq 1>&field_ozel_kod=add_bill_.account_code2</cfif>&field_acc_name=add_bill_.acc_name<cfif session.ep.our_company_info.is_ifrs eq 1>&field_ufrs_no=add_bill_.ifrs_code</cfif>&account_code=' + add_bill_.acc_code.value);	
	}
</script>
