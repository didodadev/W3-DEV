<!---
Sanal pos ödeme yapılacaksa açılan sayfadır,devamında gercek sanal pos işlemi yapar(partner\public için ve sipariş\tek ödeme ekranları için ortaktır)...
Ayşenur 20060406
--->
<cfset pos_id = ListGetAt(attributes.action_to_account_id,4,";")>
<cfquery name="getSanalPosType" datasource="#DSN#">
	SELECT 
    	IS_SECURE, 
        USER_NAME, 
        PASSWORD, 
        TERMINAL_NO, 
        CLIENT_ID, 
        BANK_HOST_3D,
        STORE_KEY,
        POS_TYPE 
    FROM 
    	OUR_COMPANY_POS_RELATION 
    WHERE 
    	POS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_id#">
</cfquery>
<cfif use_https><cfset url_link = https_domain><cfelse><cfset url_link = ""></cfif>
<cfquery name="GET_PROCESS_TYPE_REV" datasource="#DSN3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT
	FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_rev#">
</cfquery>
<cfscript>
	process_type_rev = get_process_type_rev.process_type;
	is_cari_rev = get_process_type_rev.is_cari;
	is_account_rev = get_process_type_rev.is_account;
	expire_month = RepeatString("0",2-Len(attributes.exp_month)) & attributes.exp_month;
	expire_year = Right(attributes.exp_year,2);
</cfscript>
<cfif is_account_rev eq 1>
	<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
		<cfset my_acc_result = 2020>
	<cfelse>
		<cfset my_acc_result = 2020>
	</cfif>
	<cfif not len(my_acc_result)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1295.Muhasebe Hesaplarınız Tanımlanmamıştır Lütfen Müşteri Hizmetlerine Başvurunuz'>!");
			window.location.href='<cfoutput>#http_status##cgi.http_host#/#request.self#?fuseaction=objects2.welcome</cfoutput>';
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfset my_acc_result = ''>
</cfif>
<cfset payment_type_id = trim(ListGetAt(attributes.action_to_account_id,3,";"))>
<cfquery name="GET_TAKS_METHOD" datasource="#DSN3#">
	SELECT NUMBER_OF_INSTALMENT,ACCOUNT_CODE,CARD_NO,VFT_CODE,IS_COMISSION_TOTAL_AMOUNT,PAYMENT_RATE FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#payment_type_id#">
</cfquery>
<cfif not len(get_taks_method.account_code)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1296.Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Seçilmemiştir Lütfen Müşteri Hizmetlerine Başvurunuz'>!");
		window.location.href='<cfoutput>#http_status##cgi.http_host#/#request.self#?fuseaction=objects2.popup_add_online_pos</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif len(get_taks_method.number_of_instalment) and get_taks_method.number_of_instalment neq 0>
	<cfset taksit_sayisi = get_taks_method.number_of_instalment>
<cfelse>
	<cfset taksit_sayisi = 0>
</cfif>
<cfset vft_code = ""><!--- yapıkredide vft(vade farklı taksitli satış) koda göre bankaya gönderimde kullanılıyor --->
<cfif len(get_taks_method.vft_code)>
	<cfset vft_code = get_taks_method.vft_code>
</cfif>

<cfif get_taks_method.is_comission_total_amount eq 1 and len(get_taks_method.payment_rate)>
	<cfset cari_sales_credit = filterNum(attributes.sales_credit)-((filterNum(attributes.sales_credit)*get_taks_method.payment_rate)/100)>
<cfelse>
	<cfset cari_sales_credit = filterNum(attributes.sales_credit)>
</cfif>

<cfif isDefined("attributes.order_related") and len(attributes.order_related)><cfset url_link_last = 'objects2.add_online_pos_from_order'><cfelse><cfset url_link_last = 'objects2.popup_add_online_pos_action'></cfif><!--- sipariş sonlardırdaki tahsilatı kayıt kısmı dinamik oldugu için ayrı sayfalara gidiyor --->
<cfset oid = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session_base.userid#_'&round(rand()*100)#">
<cfform name="add_online_pos" id="add_online_pos" action="?fuseaction=#url_link_last#" method="post">
<cfoutput>
	<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
	<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
	<input type="hidden" name="action_to_account_id" id="action_to_account_id" value="#attributes.action_to_account_id#">
	<input type="hidden" name="process_cat_rev" id="process_cat_rev" value="#attributes.process_cat_rev#">
	<input type="hidden" name="action_date" id="action_date" value="#attributes.action_date#">
	<input type="hidden" name="action_detail" id="action_detail" value="#attributes.action_detail#">
	<cfif isDefined("attributes.order_related") and len(attributes.order_related)>
		<input type="hidden" name="sales_credit" id="sales_credit" value="#attributes.sales_credit#">
		<input type="hidden" name="order_related" id="order_related" value="#attributes.order_related#">
	<cfelse>
		<input type="hidden" name="sales_credit" id="sales_credit" value="<cfif len(vft_code)>#attributes.sales_credit_dsp#<cfelse>#attributes.sales_credit#</cfif>"><!--- vft li işlemlerde komisyonlu tutarlar gönderilmez bankaya,vft kendisi hesaplama yapar --->
	</cfif>
	<input type="hidden" name="cari_sales_credit" id="cari_sales_credit" value="#cari_sales_credit#">
	<input type="hidden" name="process_type_rev" id="process_type_rev" value="#process_type_rev#">
	<input type="hidden" name="is_cari_rev" id="is_cari_rev" value="#is_cari_rev#">
	<input type="hidden" name="is_account_rev" id="is_account_rev" value="#is_account_rev#">	
	<input type="hidden" name="my_acc_result" id="my_acc_result" value="#my_acc_result#">
	<input type="hidden" name="card_owner" id="card_owner" value="#attributes.card_owner#">
	<cfif isDefined("attributes.is_price_standart")>
		<input type="hidden" name="price_standart_last" id="price_standart_last" value="#attributes.price_standart_last#">
	</cfif>
	<cfif isDefined("attributes.campaign_id")>
		<input type="hidden" name="campaign_id" id="campaign_id" value="#attributes.campaign_id#">
	</cfif>
	<input type="hidden" name="vft_code" id="vft_code" value="#vft_code#">
	<input type="hidden" name="exp_year" id="exp_year" value="#attributes.exp_year#">
	<cfif not isDefined("session.pp") and isDefined("attributes.invoice_kontrol") and attributes.invoice_kontrol eq 1><!--- xmlden seçili ise fatura kaydı da yapması için gerekli parametreler set ediliyor --->
		<input type="hidden" name="invoice_kontrol" id="invoice_kontrol" value="#attributes.invoice_kontrol#">
		<input type="hidden" name="invoice_process_cat" id="invoice_process_cat" value="<cfif len(attributes.invoice_process_cat)>#attributes.invoice_process_cat#</cfif>">
		<input type="hidden" name="invoice_department_id" id="invoice_department_id" value="<cfif len(attributes.invoice_department_id)>#attributes.invoice_department_id#</cfif>">
		<input type="hidden" name="invoice_location_id" id="invoice_location_id" value="<cfif len(attributes.invoice_location_id)>#attributes.invoice_location_id#</cfif>">
	</cfif>	
	<main role="main"> 
		<div class="container-fluid" style=" margin-top: 55px; "> 			
			<div class="row justify-content-md-center">
				<div class="col-12 col-sm-12 col-md-10 col-lg-6">
					<div class="card">
						<div class="card-header">
							<strong>Ödeme Bilgisi</strong>
						</div>
						<div class="card-body">
							<div class="form-group mb-0 row">
								<label class="col-sm-3 col-form-label form-control-sm font-weight-bold"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label>
								<div class="col-sm-9">
									<input type="text" readonly class="form-control-plaintext form-control-sm" value="<cfoutput>#get_taks_method.card_no#</cfoutput>">								
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-3 col-form-label form-control-sm font-weight-bold"><cf_get_lang_main no ='246.Üye'></label>
								<div class="col-sm-9">
									<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
										<cfquery name="GET_COMPANY_INFO" datasource="#DSN#">
											SELECT NICKNAME,MEMBER_CODE FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
										</cfquery>
										<input type="text" name="firma_info" value="#get_company_info.nickname#"  readonly class="form-control-plaintext form-control-sm">
										<input type="hidden" name="member_code" value="#get_company_info.member_code#">
									<cfelse>
										<cfquery name="GET_CONSUMER_INFO" datasource="#DSN#">
											SELECT CONSUMER_NAME,CONSUMER_SURNAME,MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
										</cfquery>
										<input type="text" name="firma_info" id="firma_info" value="#get_consumer_info.consumer_name# #get_consumer_info.consumer_surname#"  readonly class="form-control-plaintext form-control-sm">
										<input type="hidden" name="member_code" id="member_code" value="#get_consumer_info.member_code#">
									</cfif>																
								</div>
							</div>
							<div class="confirm-card-info">
								<div id="form-container">
									<div id="card-front">								
										<div id="image-container">
											<span id="amount">Tutar <cfif len(vft_code)>(VFT)</cfif>:
											<cfif isDefined("attributes.order_related") and len(attributes.order_related)>
												<input type="hidden" name="sales_credit_dsp" id="sales_credit_dsp" value="#TLFormat(attributes.sales_credit)# #session_base.money#" readonly="yes" >
												<strong>#TLFormat(attributes.sales_credit)# #session_base.money#"</strong>
											<cfelse>
												<input type="hidden" name="sales_credit_dsp" id="sales_credit_dsp" value="<cfif len(vft_code)>#attributes.sales_credit_dsp#<cfelse>#attributes.sales_credit#</cfif> #session_base.money#" readonly="yes">
												<strong><cfif len(vft_code)>#attributes.sales_credit_dsp#<cfelse>#attributes.sales_credit#</cfif> #session_base.money#</strong>
											</cfif>											
											</span>
											<input type="hidden" name="taksit_sayisi" value="#taksit_sayisi#" readonly="yes">
											<span id="installment">Taksit: <strong>#taksit_sayisi#</strong></span>	
											<span id="card-image"><i class="far fa-user-circle"></i></span>					
										</div>
										<label for="card-number">
											Kart No
										</label>
										<input type="text" name="card_no" id="card-number" validate="creditcard" value="#attributes.card_no#" readonly="yes">
										<div id="cardholder-container">
											<label for="card-holder">Ad Soyad</label>
											<input type="text" name="kart_sahibi" id="card-holder" value="#attributes.card_owner#" readonly="yes">
										</div>
										<div id="exp-container">
											<label for="card-exp">Ay / Gün</label>
											<input type="text" name="expire_month" id="expire_month" value="#expire_month#" readonly="yes">
											<input type="text" name="expire_year" id="expire_year" value="#expire_year#" readonly="yes" >
										</div>
										<div id="cvc-container">
											<label for="card-cvc"> CVV</label>
											<input type="text" id="card-cvc" value="*#mid(attributes.cvv_no,2,1)#*" readonly="yes" >
											<cfinput type="hidden" name="cvv_no" value="#attributes.cvv_no#" readonly="yes" >
											<p></p>
										</div>
									</div>
									<div id="shadow"></div>
									<div id="card-back">
										<div id="card-stripe"></div>
									</div>
								</div>
							</div>
							<table border="0" cellspacing="1" cellpadding="2" class="color-border" style="width:100%; height:100%;">
								<tr>
									<td class="color-row" colspan="2" style="vertical-align:top;"><br/>
										<table>
											<cfif isDefined("attributes.is_price_standart")>
												<tr style="height:25px;">
													<td>Son Kullanıcı Fiyatı :</td>
													<td >
														<input type="hidden" name="is_price_standart" id="is_price_standart" value="1">
														<cfinput type="text" name="price_standart_dsp" style="width:150px;" class="boxtext" value="#TLFormat(attributes.price_standart_last)#" readonly="yes">
													</td>
												</tr>
											</cfif>
											
											<cfif isdefined('attributes.vft_rte') and len(attributes.vft_rte)>
												<tr style="height:25px;">
													<td>VFT Oranı :</td>
													<td><cfinput type="text" name="vft_rate" style="width:150px;" class="boxtext" value="% #attributes.vft_rte#" readonly="yes"></td>
												</tr>
											</cfif>
											<cfif isdefined('attributes.vft_kredi') and len(attributes.vft_kredi)>
												<tr style="height:25px;">
													<td>VFT Tutar :</td>
													<td><input type="text" name="vft_kredi" id="vft_kredi" style="width:150px;" class="boxtext" value="<cfoutput>#attributes.vft_kredi# #session_base.money#</cfoutput>" readonly="yes"></td>
												</tr>
											</cfif>
											<!-- sil -->
											<cfif isDefined("attributes.joker_vada")><!--- Joker Vada Kullanmak İstiyorum seçeneği seçilmişse --->
												<tr style="height:25px;">
													<cfinclude template="../../add_options/query/add_online_pos_jokervada.cfm"><!--- sorgulama yapar --->
													<cfif approved_joker_info eq 1><!--- Joker vada kontrolunden onay almışsa --->
														<td><cf_get_lang no ='1298.Joker Vada Seçenekleri'> : </td>
														<td>
														<cfoutput>
															<cfset code_sayisi = Arraylen(xml_response_node.posnetResponse.koiInfo.code)>
															<cfset message_sayisi = Arraylen(xml_response_node.posnetResponse.koiInfo.message)>
															<cfloop from="1" to="#code_sayisi#" index="i">
																<cfset vada_code = xml_response_node.posnetResponse.koiInfo.code[i].XmlText>
																<cfset vada_message = xml_response_node.posnetResponse.koiInfo.message[i].XmlText>
																<input type="radio" name="joker_options_value" id="joker_options_value" value="#vada_code#" checked="checked">#vada_message#<br/>
															</cfloop>
														</cfoutput>
														</td>
													<cfelse>
														<td>Joker Vada Sorgusu : </td>
														<td><cfoutput>#xml_response_node.posnetResponse.respText.XmlText#</cfoutput></td>
													</cfif>
												</tr>
											</cfif>											
										<!-- sil -->
										</table>
									</td>
								</tr>
							</table>
						</div>
						<div class="card-footer">
							<cfsavecontent variable="alert">Tahsilatı Gerçekleştir</cfsavecontent>
							<cfsavecontent variable="alert2">Tahsilat İşlemi Yapılacaktır,Devam Etmek İstiyor Musunuz</cfsavecontent>
							<cfsavecontent variable="alert3">3D Onay Ekranına Git</cfsavecontent>
							<cfsavecontent variable="alert4">Geri</cfsavecontent>												
							<cfif getSanalPosType.is_secure eq 0>
								<cf_workcube_buttons is_upd='0' insert_info='#alert#' insert_alert='#alert2#' > <!---add_function='control()'--->
							<cfelse>
								<input type="button" name="back" id="back" class="btn btn-primary float-left" onclick="window.history.back();" value="<cfoutput>#alert4#</cfoutput>" />
								<input type="button" name="tahsilat_3d" id="tahsilat_3d" class="btn btn-success float-right" onclick="tahsilat_yap_3d();" value="<cfoutput>#alert3#</cfoutput>" />
								<input type="hidden" name="md" id="md" value="" />
								<input type="hidden" name="oid" id="oid" value="#oid#" />
								<input type="hidden" name="amount" id="amount" value="" />
								<input type="hidden" name="taksit" id="taksit" value="" />
								<input type="hidden" name="xid" id="xid" value="" />
								<input type="hidden" name="eci" id="eci" value="" />
								<input type="hidden" name="cavv" id="cavv" value="" />
								<input type="hidden" name="mdstatus" id="mdstatus" value="" />
								<input type="hidden" name="error_code" id="error_code" value="" />
							</cfif>
						</div>
					</div>
				</div>
			</div>
		</div>		
	</main>
</cfoutput>
</cfform>
<table>
	<tr>
    	<td>
			<cfif getSanalPosType.is_secure eq 1><!---3d islemlerde dogrulama sayfasını acmak icin --->
				<cfset threeDGate_token = #encrypt(CFID,'protein_3d','CFMX_COMPAT','Hex')#>
                <cfscript>
                    //sanal pos sifre ve gerekli bilgileri
                    pos_user_name = getSanalPosType.user_name;
                    pos_user_password = getSanalPosType.password;
                    pos_terminal_no = getSanalPosType.terminal_no;
                    pos_client_id = getSanalPosType.client_id;
                    post_adress_3d = getSanalPosType.bank_host_3d;
                    pos_store_key = getSanalPosType.store_key;
                    
                    if (len(taksit_sayisi) and taksit_sayisi neq 0)
                        taksit = taksit_sayisi;
                    else
                        taksit = '';
                    okUrl = '#http_status##cgi.HTTP_HOST#/?fuseaction=objects2.popup_3d_control&okParam=1&threeDGate=#threeDGate_token#';
                    failUrl = '#http_status##cgi.HTTP_HOST#/?fuseaction=objects2.popup_3d_control&okParam=0&threeDGate=#threeDGate_token#';
                   
                    
                    if(listfind("1,2,3,4,5,6,10,13,14,15,16",getSanalPosType.pos_type,','))
                    {
                        rnd = timeformat(now(),'HHmmssl');
                        tutar = filterNum(attributes.sales_credit);
                        hashData = '#pos_client_id##oid##tutar##okUrl##failUrl##taksit##rnd##pos_store_key#';
                        hashData_ = ToBase64(BinaryDecode(Hash(hashData, "SHA1"), "Hex"));
                    }
                    else if(getSanalPosType.pos_type eq 8)//garanti
                    {
                        if (len(pos_terminal_no) lt 9)
                            terminalID_ = repeatString("0",9-len(pos_terminal_no)) & "#pos_terminal_no#";
                        else
                            terminalID_ = pos_terminal_no;
                        tutar = filterNum(attributes.sales_credit);
                        tutar = tutar*100;
                        
                        strMode = "PROD";
                        strApiVersion = "v0.01";
                        strType = "sales";
                        
                        SecurityData = hash("#pos_user_password##terminalID_#",'sha-1');
                        HashData = hash("#pos_terminal_no##oid##tutar##okUrl##failUrl##strType##taksit##pos_store_key##SecurityData#",'sha-1');
                    }
                </cfscript>
				<cfoutput>
				<form name="form_3d" action="#post_adress_3d#" method="post">
                     <cfif getSanalPosType.pos_type eq 8>
                        <input type="hidden" name="cardnumber" id="cardnumber" value="#attributes.card_no#"/>
                        <input type="hidden" name="cardexpiredatemonth" id="cardexpiredatemonth" value="#expire_month#"/>
                        <input type="hidden" name="cardexpiredateyear" id="cardexpiredateyear" value="#expire_year#" />
                        <input type="hidden" name="cardcvv2" id="cardcvv2" value="#attributes.cvv_no#"/>
                        <input type="hidden" name="mode" id="mode" value="#strMode#" />
                        <input type="hidden" name="apiversion" id="apiversion" value="#strApiVersion#" />
                        <input type="hidden" name="terminalprovuserid" id="terminalprovuserid" value="#pos_user_name#" />
                        <input type="hidden" name="terminaluserid" id="terminaluserid" value="#pos_user_name#" />
                        <input type="hidden" name="terminalmerchantid" id="terminalmerchantid" value="#pos_client_id#" />
                        <input type="hidden" name="txntype" id="txntype" value="#strType#" />
                        <input type="hidden" name="txnamount" id="txnamount" value="#tutar#" />
                        <input type="hidden" name="txncurrencycode" id="txncurrencycode" value="949" />
                        <input type="hidden" name="txninstallmentcount" id="txninstallmentcount" value="#taksit#" />
                        <input type="hidden" name="orderid" id="orderid" value="#oid#" /><br />
                        <input type="hidden" name="terminalid" id="terminalid" value="#pos_terminal_no#" />
                        <input type="hidden" name="successurl" id="successurl" value="#okUrl#" />
                        <input type="hidden" name="errorurl" id="errorurl" value="#failUrl#" />
                        <input type="hidden" name="customeripaddress" id="customeripaddress" value="#cgi.REMOTE_ADDR#" />
                        <input type="hidden" name="customeremailaddress" id="customeremailaddress" value="" />
                        <input type="hidden" name="secure3dhash" id="secure3dhash" value="#HashData#" />
                        <input type="hidden" name="secure3dsecuritylevel" id="secure3dsecuritylevel" value="3d">
                     <cfelseif listfind("1,2,3,4,5,6,10,13,14,15,16",getSanalPosType.pos_type,',')>
                        <input type="hidden" name="pan" id="pan" value="#attributes.card_no#">
                        <input type="hidden" name="cv2" id="cv2" value="#attributes.cvv_no#"> 
                        <input type="hidden" name="Ecom_Payment_Card_ExpDate_Year" id="Ecom_Payment_Card_ExpDate_Year" value="#expire_year#">
                        <input type="hidden" name="Ecom_Payment_Card_ExpDate_Month" id="Ecom_Payment_Card_ExpDate_Month" value="#expire_month#">
                        <input type="hidden" name="clientid" id="clientid" value="#pos_client_id#" > 
                        <input type="hidden" name="amount" id="amount" value="#tutar#" >
                        <input type="hidden" name="oid" id="oid" value="#oid#">
                        <input type="hidden" name="okUrl" id="okUrl" value="#okUrl#">
                        <input type="hidden" name="failUrl" id="failUrl" value="#failUrl#">
                        <input type="hidden" name="rnd" id="rnd" value="#rnd#">
                        <input type="hidden" name="hash" id="hash" value="#hashData_#">
                        <input type="hidden" name="taksit" id="taksit" value="#taksit#">
                        <input type="hidden" name="storetype" id="storetype" value="3d">
                        <input type="hidden" name="lang" id="lang" value="tr">
                        <input type="hidden" name="currency" id="currency" value="949">
                     </cfif>
                    </form>
                    <script language="javascript">
                        function tahsilat_yap_3d()
                        {
                            if(document.getElementById('error_code').value == '')
                            {
                                windowopen('','page','wrk3dwindow');
                                document.form_3d.target = 'wrk3dwindow';                               
                                document.form_3d.submit();
                            }
                            else
                            {
                                alert('Kart bilgilerinizi kontrol ederek tekrar deneyiniz !');
                                history.back();
                            }
                        }
                        function historyBack()
                        {
                            if(document.getElementById('error_code').value != '')
                                history.back();
                        }
                    </script>
                </cfoutput>
            </cfif>
		</td>
	</tr>
</table>

<script type="text/javascript">
	<cfif not isDefined("attributes.joker_vada") and (isDefined("attributes.order_related") and len(attributes.order_related))>//sipariş sonlandırdan giden sayfalarda jokervada yoksa kontrol ekranı olmadan direkt işlem bitiyor
		document.add_online_pos.submit();
	</cfif>
</script>