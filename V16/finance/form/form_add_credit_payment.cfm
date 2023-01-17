<cfinclude template="../../objects/query/payment_means_code.cfm">
<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT
		ACCOUNT_NAME,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		ACCOUNT_ID
	FROM
		ACCOUNTS,
		BANK_BRANCH
	WHERE
		ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND 
		<cfif session.ep.period_year lt 2009>
			(ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')  
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) 
		</cfif>
	ORDER BY
		BANK_NAME,
		ACCOUNT_NAME
</cfquery>
<cfquery name="GETSANALPOS" datasource="#DSN#">
	SELECT 
		POS_ID,
		POS_NAME
	FROM 
		OUR_COMPANY_POS_RELATION AS POS_REL,
		OUR_COMPANY AS COMP
	WHERE
		COMP.COMP_ID = POS_REL.OUR_COMPANY_ID AND
		COMP.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		IS_ACTIVE = 1
	ORDER BY
		POS_ID
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
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_creditcard_payment" id="add_creditcard_payment" action="#request.self#?fuseaction=finance.emptypopup_add_credit_payment" method="post" onsubmit="return unformat_fields();" enctype="multipart/form-data">	
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-order_status">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_active" id="is_active" checked="checked" /><cf_get_lang dictionary_id ='57493.Aktif'></label>
					</div>
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-reserved">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_pesin" id="is_pesin" checked="checked" /><cf_get_lang dictionary_id ='54905.Banka Hemen Öder'></label>
					</div>
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-reserved">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_partner" id="is_partner" /><cf_get_lang dictionary_id='58885.Partner'></label>
					</div>	
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-reserved">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_public" id="is_public" onclick="gizle_goster(public_min_amount_id);" /><cf_get_lang dictionary_id='54963.Public'></label>
					</div>
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-cash_register">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_cash_register" id="is_cash_register" /><cf_get_lang dictionary_id='65213.Yazar Kasada Göster'></label>
					</div>
					<div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-reserved">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_special" id="is_special" /><cf_get_lang dictionary_id='57979.Özel'></label>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-card_no"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'> *</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="card_no" id="card_no" maxlength="100" required="yes">	
						</div>
					</div>
					<div class="form-group" id="item-payment_means_code"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57847.Ödeme'><cf_get_lang dictionary_id='58663.Şekli'><cf_get_lang dictionary_id='58585.Kod'><cfif control_einvoice.recordcount> *</cfif></label>
						<div class="col col-8 col-xs-12">
							<select name="payment_means_code" id="payment_means_code">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="payment_means_code">
									<option value="#payment_means_code_id#,#detail#" title="#payment_means_code#">#detail#</option>
								</cfoutput>
							</select>                          
						</div>
					</div> 
					<div class="form-group" id="item-card_image"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54906.Ödeme İkonu'></label>
						<div class="col col-8 col-xs-12">
							<input  type="file" name="card_image" id="card_image" />                    
						</div>
					</div>  
					<div class="form-group" id="item-account_id"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57652.Hesap'> *</label><!--- Banka hesapları gelir,kredikartı tahsilat vb işlemler içindir --->
						<div class="col col-8 col-xs-12">
							<select name="account_id" id="account_id">
								<option value=""><cf_get_lang dictionary_id ='54907.Hesap Seçiniz'></option>
								<cfoutput query="get_accounts">
									<option value="#ACCOUNT_ID#">#ACCOUNT_NAME#&nbsp;#ACCOUNT_CURRENCY_ID#</option>
								</cfoutput>
							</select>	                                             
						</div>
					</div>   
					<div class="form-group" id="item-pos_type"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='48865.Sanal POS'></label>
						<div class="col col-8 col-xs-12">
							<select name="pos_type" id="pos_type"><!---sistem yönetimi sanal pos tanımlarından getirir dinamik hale getirmek için yapıldı FA24012011--->
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="getsanalpos">
									<option value="#pos_id#">#pos_name#</option>
								</cfoutput>
							</select>		                                             
						</div>
					</div>                        
					<div class="form-group" id="item-number_of_instalment"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54816.Taksit Sayısı'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="number_of_instalment" id="number_of_instalment" onkeyup="return(formatcurrency(this,event,0));">		                                             
						</div>
					</div> 
					<div class="form-group" id="item-passingday_to_instalment_account"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54911.Hesaba Geçiş Günü'> *</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="passingday_to_instalment_account" id="passingday_to_instalment_account" required="yes" onkeyup="return(formatcurrency(this,event,0));">		                                             
						</div>
					</div> 
					<div class="form-group" id="item-vft_code"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54913.VFT Kodu'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="vft_code" id="vft_code" value="" maxlength="50">                               
						</div>
					</div>
				</div> 
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-vft_rate"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54533.VFT Oranı'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="vft_rate" id="vft_rate" value="" maxlength="50">                            
						</div>
					</div> 
					<div class="form-group" id="item-service_rate"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54914.Banka Komisyon Oranı'> %</label>
						<div class="col col-2 col-xs-3">
							<!--- Bu oran siparişe veya bankaya gönderilcek tutarı etkilemez,firmanın bankayla olan komisyon anlaşmasıdır
							işlemlerden oranları hesaplayıp bu hesapta komsiyonları tutar--->	
							<cfinput type="text" name="service_rate" id="service_rate" onkeyup="return(formatcurrency(this,event));" class="moneybox">                                                                    
						</div>
						<div class="col col-6 col-xs-9">
							<div class="input-group">
								<input type="hidden" name="service_account_code_id" id="service_account_code_id">
								<cfinput type="text" name="service_account_code" id="service_account_code" value="" readonly="yes">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_creditcard_payment.service_account_code&field_id=add_creditcard_payment.service_account_code_id')"></span>
							</div>                          
						</div>
					</div> 
					<div class="form-group" id="item-payment_rate"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54916.Kart Tahsilat Komisyonu\Oranı'></label>
						<div class="col col-2 col-xs-3">
							<!---Ek bilgi:partner finans tek ödeme ekranında girilen orana göre tutara ekleme yapar Ayşenur20061225 --->  
							<cfinput type="text" name="payment_rate" id="payment_rate" onkeyup="return(formatcurrency(this,event));" class="moneybox">
						</div>
						<div class="col col-6 col-xs-9">
							<cfinput type="text" name="payment_rate_dsp" id="payment_rate_dsp" onkeyup="return(formatcurrency(this,event));"  value="" class="moneybox">				                  
						</div>
					</div> 
					<div class="form-group" id="item-payment_rate_acc_name"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54917.Kart Tahsilat Komisyon Hesabı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<!---Ek bilgi:kredi kartı tahsilat sayfaarında bu hesap seçişi durumda oran ekleyip borç dekontu kaydeder Ayşenur20080105 --->
								<input type="hidden" name="payment_rate_acc" id="payment_rate_acc" value="">
								<cfinput type="text" name="payment_rate_acc_name" id="payment_rate_acc_name" value="">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_creditcard_payment.payment_rate_acc_name&field_id=add_creditcard_payment.payment_rate_acc')"></span> 
							</div>
						</div>
					</div> 
					<div class="form-group" id="item-product_name"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54919.B2B Komisyon Çarpanı\Ürünü'></label>
							<!---Ek bilgi:Siparişin satırına 0 dan farklıysa çarpan bu ürünü atar,
							ayrıca siparişden gelen sanal poslarda komisyon oranını hesaplayıp ödencek tutara ekleyip bankaya gönderir Ayşenur20060505 --->
						<div class="col col-2 col-xs-3">
							<input type="hidden" name="product_id" id="product_id" value="">
							<input type="hidden" name="stock_id" id="stock_id" value="">
							<cfinput type="text" name="commission_multiplier" id="commission_multiplier" onkeyup="return(formatcurrency(this,event));" class="moneybox">
						</div>
						<div class="col col-6 col-xs-9">  
							<div class="input-group">    
								<input type="text" name="product_name" id="product_name" value="" readonly="yes">		                                             
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_creditcard_payment.product_id&field_id=add_creditcard_payment.stock_id&field_name=add_creditcard_payment.product_name');"></span>
							</div>
						</div>     
					</div> 
					<div class="form-group" id="item-commission_multiplier_dsp"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54922.B2B Komisyon Oranı'></label>
						<div class="col col-8 col-xs-12">
							<!---sipariş sonlandır ekranında sadece gösterimlik kullanılacak bir orandır(datateknik isteğiyle) Ayşenur20070828--->
							<cfinput type="text" name="commission_multiplier_dsp" id="commission_multiplier_dsp" value="" onkeyup="return(formatcurrency(this,event));" class="moneybox">                                          
						</div>
					</div> 
					<div class="form-group" id="item-public_commission_multiplier"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54923.B2C Komisyon Çarpanı\Ürünü'></label>
						<!---Ek bilgi:public Siparişin satırına 0 dan farklıysa çarpan bu ürünü atar,
						ayrıca siparişden gelen sanal poslarda komisyon oranını hesaplayıp ödencek tutara ekleyip bankaya gönderir Ayşenur20060505 --->	
						<div class="col col-2 col-xs-3">
							<input type="hidden" name="public_product_id" id="public_product_id" value="">
							<input type="hidden" name="public_stock_id" id="public_stock_id" value="">
							<cfinput type="text" name="public_commission_multiplier" id="public_commission_multiplier" onkeyup="return(formatcurrency(this,event));" class="moneybox">
						</div>
						<div class="col col-6 col-xs-9">
							<div class="input-group">
								<input type="text" name="public_product_name" id="public_product_name" value="" readonly="yes">			
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_creditcard_payment.public_product_id&field_id=add_creditcard_payment.public_stock_id&field_name=add_creditcard_payment.public_product_name');"></span>
							</div>
						</div>               	                                             
					</div> 
					<div class="form-group" id="item-public_com_multiplier_dsp"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54925.B2C Komisyon Oranı'></label>
						<div class="col col-8 col-xs-12">
							<!---public  sipariş sonlandır ekranında sadece gösterimlik kullanılacak bir orandır(datateknik isteğiyle) Ayşenur20070828--->
							<cfinput type="text" name="public_com_multiplier_dsp" id="public_com_multiplier_dsp" value="" onkeyup="return(formatcurrency(this,event));" class="moneybox">		                                            
						</div>
					</div> 
					<div class="form-group" id="item-first_interest_rate"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54927.Erken Ödeme İndirimi'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="first_interest_rate" id="first_interest_rate" value="" onkeyup="return(formatcurrency(this,event));" class="moneybox">			                                             
						</div>
					</div> 
					<div class="form-group" id="item-account_code_name"> 
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54929.Muhasebe Hesabı'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="account_code" id="account_code" value="">
								<cfinput type="text" name="account_code_name" id="account_code_name" value="" required="yes" readonly="yes">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_creditcard_payment.account_code_name&field_id=add_creditcard_payment.account_code')"></span>            
							</div>
						</div>
					</div> 
					<div id="public_min_amount_id" style="display:none;">
						<div class="form-group" id="item-public_min_amount"> 
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="56287.Public Minimum Tutar"></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="public_min_amount" id="public_min_amount" style="text-align:right" maxlength="20" value="" onKeyUp="return(FormatCurrency(this,event));" />                         
							</div>
						</div> 
					</div>    
					<div class="form-group" id="item-is_comission_total_amount"> 
					<label class="col col-4 col-xs-12"></label>
					<div class="col col-8 col-xs-12">
						<label><input type="checkbox" name="is_comission_total_amount" id="is_comission_total_amount"><cf_get_lang dictionary_id ='54406.Komisyon Toplam Tutara Dahil'></label>				
						<label><input type="checkbox" name="is_prom_control" id="is_prom_control"><cf_get_lang dictionary_id ='54407.Promosyon Kontrolü Yapılsın'></label>	                       
					</div>
				</div> 
			</cf_box_elements>	
			<cf_box_footer>
				<cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{ 
			if(!$("#card_no").val().length)
			{
				alertObject({message: "<cfoutput><cf_get_lang dictionary_id='33337.Açıklama Girmelisiniz'> !</cfoutput>"})    
				return false;
			}
		<cfif control_einvoice.recordcount>
			if(!$("#payment_means_code").val().length)
			{
				alertObject({message: "<cf_get_lang dictionary_id='56288.Lütfen Ödeme Şekli Kodunu Giriniz'>"})    
				return false;
			}
		</cfif>
			if(!$("#account_id").val().length)
			{
				alertObject({message: "<cfoutput><cf_get_lang dictionary_id='54831.Banka Hesabı Seçiniz'></cfoutput>"})    
				return false;
			}
			if(!$("#account_code_name").val().length)
			{
				alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='54918.Muhasebe Kodu Seçmelisiniz'>!</cfoutput>"})    
				return false;
			}
			if(!$("#passingday_to_instalment_account").val().length)
			{
				alertObject({message: "<cf_get_lang dictionary_id='56289.Hesaba geçiş günü girmelisiniz'>!"})    
				return false;
			}
			if(!$("#card_no").val().length)
			{
				alertObject({message: "<cfoutput><cf_get_lang dictionary_id='33337.Açıklama Girmelisiniz'> !</cfoutput>"})    
				return false;
			}
		
	}
	
	function unformat_fields()
	{
		document.getElementById('service_rate').value = filterNum(document.getElementById('service_rate').value);
		document.getElementById('payment_rate').value = filterNum(document.getElementById('payment_rate').value);
		document.getElementById('payment_rate_dsp').value = filterNum(document.getElementById('payment_rate_dsp').value);
		document.getElementById('commission_multiplier').value = filterNum(document.getElementById('commission_multiplier').value);
		document.getElementById('commission_multiplier_dsp').value = filterNum(document.getElementById('commission_multiplier_dsp').value);
		document.getElementById('public_commission_multiplier').value = filterNum(document.getElementById('public_commission_multiplier').value);
		document.getElementById('public_com_multiplier_dsp').value = filterNum(document.getElementById('public_com_multiplier_dsp').value);
		document.getElementById('first_interest_rate').value = filterNum(document.getElementById('first_interest_rate').value);
		document.getElementById('public_min_amount').value = filterNum(document.getElementById('public_min_amount').value);
	}	
</script>
