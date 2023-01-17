<cfinclude template="../../login/send_login.cfm">
<cfset total_debit = 0>
<cfset total_debit2 = 0>
<cfset control_total_debit = 0>
<cfquery name="GET_INST_INFO" datasource="#DSN#">
	SELECT
		IS_INSTALMENT_INFO
	FROM
		COMPANY_CREDIT
	WHERE
		<cfif isDefined("session.pp")>
            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND 
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
        <cfelse>
            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND 
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
        </cfif>
</cfquery>
<cfif isDefined("attributes.order_id_info")><!--- siparişten farklı kartla ödeme seçildiğinde,sipariş bilgilerini alıyor --->
	<cfquery name="GET_ORDER_INFO" datasource="#DSN3#">
		SELECT
			ORDERS.ORDER_NUMBER,
			ORDERS.NETTOTAL,
			ORDERS.CAMPAIGN_ID,
			<cfif isDefined("session.pp")>
                CREDITCARD_PAYMENT_TYPE.COMMISSION_MULTIPLIER COM_MULT
            <cfelse>
                CREDITCARD_PAYMENT_TYPE.PUBLIC_COMMISSION_MULTIPLIER COM_MULT
            </cfif>
		FROM
			ORDERS,
			CREDITCARD_PAYMENT_TYPE
		WHERE
			ORDERS.CARD_PAYMETHOD_ID = CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID AND
			ORDERS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id_info#"> AND
			ORDERS.IS_PAID <> 1
	</cfquery>
	<cfif len(get_order_info.com_mult) and get_order_info.com_mult gt 0>
		<cfset order_value = (wrk_round(get_order_info.nettotal) * 100)/(get_order_info.com_mult+100)>
	<cfelse>
		<cfset order_value = wrk_round(get_order_info.nettotal)>
	</cfif>
	<cfif len(get_order_info.campaign_id)>
		<cfset camp_id_info = get_order_info.campaign_id>
    <cfelse>
		<cfset camp_id_info = ''>
    </cfif>
</cfif>
<cfif isdefined("session.ww.userid")>
	<cfquery name="GET_CREDIT_CARDS" datasource="#DSN#">
		SELECT
			CC.*,
			SC.CARDCAT
		FROM
			CONSUMER_CC CC,
			SETUP_CREDITCARD SC
		WHERE
			CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			CC.CONSUMER_CC_TYPE = SC.CARDCAT_ID
		ORDER BY
			(CC.ACC_OFF_DAY-DAY(GETDATE()))
	</cfquery>
<cfelseif isdefined("session.pp")>
	<cfquery name="GET_CREDIT_CARDS" datasource="#DSN#">
		SELECT
			CC.*,
			SC.CARDCAT
		FROM
			COMPANY_CC CC,
			SETUP_CREDITCARD SC
		WHERE
			CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
			CC.COMPANY_CC_TYPE = SC.CARDCAT_ID AND
			IS_DEFAULT = 1
		ORDER BY
			(CC.ACC_OFF_DAY-DAY(GETDATE()))
	</cfquery>	
</cfif>

<script type="text/javascript"><!--- Bu fonksyionu aşağıya taşımayın AE --->
	function show_jokervada(joker_inf)
	{
		pos_type = joker_inf.split(';')[3];//pos type i alır,Yapıkredide işlem olur sadece
		if(pos_type == 9 && joker_inf.split(';')[5] != undefined && joker_inf.split(';')[5] > 0)//ve taksitli işlemse
		{
			joker_info.style.display='';
			document.add_online_pos.joker_vada.checked = true;//joker vada seçili gelsin
		}
		else
		{
			joker_info.style.display='none';
			document.add_online_pos.joker_vada.checked = false;
		}
		if(document.getElementById('sales_credit_dsp').value != "")
			if(joker_inf.split(';')[6] != "" && joker_inf.split(';')[6] >0)//komisyon oranı
			{
				if(joker_inf.split(';')[7] == 1)
				{
					document.getElementById('sales_credit').value = commaSplit(parseFloat(filterNum(document.getElementById('sales_credit_dsp').value)));
				}
				else
				{
					document.getElementById('sales_credit').value = commaSplit(parseFloat(filterNum(document.getElementById('sales_credit_dsp').value)) + (parseFloat(filterNum(document.getElementById('sales_credit_dsp').value)) * (parseFloat(joker_inf.split(';')[6])/100)));
				}
			}
			else
				document.getElementById('sales_credit').value = commaSplit(filterNum(document.getElementById('sales_credit_dsp').value));
	}
</script>

<cfif use_https><cfset url_link = https_domain><cfelse><cfset url_link = ""></cfif>
<cfparam name="attributes.action_value" default="">
<cfparam name="attributes.sales_credit_dsp" default="">
<cfform name="add_online_pos" method="post" action="#url_link##request.self#?fuseaction=objects2.popup_add_online_pos_kontrol">
	<cfinput type="hidden" name="action_date" value="#dateFormat(Now(),'dd.mm.YYYY')#" />
	<div class="row">
        <div class="col-sm-12">
			<div class="add-online-pos">
				<cfif isDefined("attributes.campaign_id") and isDefined("session.pp")><!--- üyenin kampanya başlama tarihinden önceki cari hareketler toplamı --->
					<cfquery name="GET_DEBIT" datasource="#DSN2#">
						SELECT
							SUM(ALACAK-BORC) TOTAL_DEBIT,
							SUM(ALACAK2-BORC2) TOTAL_DEBIT2
						FROM
						(
							SELECT
								SUM(C.ACTION_VALUE) AS BORC,
								SUM(C.ACTION_VALUE_2) AS BORC2,		
								0 AS ALACAK,
								0 AS ALACAK2,
								C.TO_CMP_ID AS COMPANY_ID,
								OTHER_MONEY,
								C.ACTION_DATE
							FROM
								CARI_ROWS C
							WHERE
								C.TO_CMP_ID IS NOT NULL AND
								C.TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
								C.ACTION_DATE <= (SELECT CAMP_STARTDATE FROM #dsn3_alias#.CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#">)
							GROUP BY
								C.TO_CMP_ID,
								OTHER_MONEY,
								ACTION_DATE
						UNION ALL
							SELECT
								0 AS BORC,
								0 AS BORC2,
								SUM(C.ACTION_VALUE) AS ALACAK,
								SUM(C.ACTION_VALUE_2) AS ALACAK2,
								C.FROM_CMP_ID AS COMPANY_ID,
								OTHER_MONEY,
								C.ACTION_DATE
							FROM
								CARI_ROWS C
							WHERE
								C.FROM_CMP_ID IS NOT NULL AND
								C.FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
								C.ACTION_DATE <= (SELECT CAMP_STARTDATE FROM #dsn3_alias#.CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#">)
							GROUP BY
								C.FROM_CMP_ID,
								OTHER_MONEY,
								ACTION_DATE
							) CARI_ROWS
					</cfquery>
					<cfquery name="GET_PAYMENTS" datasource="#DSN3#"><!--- bu kampanyayla yapılmış sanal pos tahsilatları --->
						SELECT SUM(SALES_CREDIT) TOTAL_DEBIT,SUM(OTHER_CASH_ACT_VALUE) TOTAL_DEBIT2 FROM CREDIT_CARD_BANK_PAYMENTS WHERE CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#"> AND ACTION_FROM_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
					</cfquery>
					<table>
						<tr style="height:25px;">
							<input type="hidden" name="campaign_id" id="campaign_id" value="<cfoutput>#attributes.campaign_id#</cfoutput>">
							<cfif len(get_debit.total_debit)>
								<cfset total_debit = get_debit.total_debit>
							</cfif>
							<cfif len(get_debit.total_debit2)>
								<cfset total_debit2 = get_debit.total_debit2>
							</cfif>
							<cfif len(get_payments.total_debit)>
								<cfset total_debit = total_debit+get_payments.total_debit>
							</cfif>
							<cfif len(get_payments.total_debit2)>
								<cfset total_debit2 = total_debit2+get_payments.total_debit2>
							</cfif>
							<td>Önceki Borcunuz: <cfoutput><cfif total_debit lt 0><cfset control_total_debit = abs(total_debit)>#TLFormat(abs(total_debit))# #session.pp.money#<cfelse><cfset control_total_debit = 0> 0 #session.pp.money#</cfif>&nbsp;&nbsp; <cfif total_debit2 lt 0>#TLFormat(abs(total_debit2))# #session.pp.money2#<cfelse>0 #session.pp.money2#</cfif></cfoutput></td>
						</tr>
						<tr style="height:25px;">
							<td>Kampanya Başlamadan Önceki Borcunuzu Aşağıdaki Ödeme Yöntemlerinden Uygun Koşulla Ödeyebilirsiniz.</td>
						</tr>
					</table>
				</cfif>
				<cfquery name="GET_PROCESS_CAT_TAHSILAT" datasource="#DSN3#">
					SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE <cfif isDefined("session.pp")>IS_PARTNER = 1<cfelse>IS_PUBLIC = 1</cfif> AND PROCESS_TYPE = 241
				</cfquery>
				<cfoutput>
					<input type="hidden" name="process_cat_rev" id="process_cat_rev" value="#GET_PROCESS_CAT_TAHSILAT.PROCESS_CAT_ID#">
					<input type="hidden" name="process_type" id="process_type" value="241">
					<input type="hidden" name="company_id" id="company_id" value="<cfif isDefined("session.pp")>#session.pp.company_id#</cfif>">
					<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isDefined("session.ww.userid")>#session.ww.userid#</cfif>">
					<cfif isDefined("attributes.order_id_info")><!--- siparişten farklı kartla ödeme seçeğinde bu ekranı açıyor --->
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<input type="hidden" name="order_id_info" id="order_id_info" value="#attributes.order_id_info#">
									<label>Sipariş No: <b>: #get_order_info.order_number#</b></label>										
								</div>
							</div>
						</div>
					</cfif>
					<cfif isDefined("attributes.reload_info")><input type="hidden" name="reload_info" id="reload_info" value=""></cfif>
				</cfoutput>
				<div class="row">
					<div class="col-sm-3">
						<div class="form-group">
							<label for="sales_credit_dsp">Tutar *</label>
							<input type="text" name="sales_credit_dsp" id="sales_credit_dsp" class="form-control moneybox" required="yes" value="<cfoutput><cfif isDefined("attributes.sales_credit_dsp") and len(attributes.sales_credit_dsp)>#TLFormat(attributes.sales_credit_dsp)#<cfelseif isDefined("attributes.campaign_id") and total_debit lt 0>#TLFormat(abs(total_debit))#<cfelseif isDefined("attributes.order_id_info")>#TLFormat(order_value)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event));" <cfif isDefined("attributes.order_id_info") or (isDefined("attributes.sales_credit_dsp") and len(attributes.sales_credit_dsp))>readonly</cfif>> 
							<input type="hidden" name="sales_credit" id="sales_credit" required="yes" value=""> 
						</div>
					</div>
				</div>
				<div class="row">
				<div id="list_accounts" class="col-sm-12"></div>
				</div>
				<div class="row">
				<div id="show_member_card" style="display:none;"></div>
				</div>
				<cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
					<div class="row">
						<div class="form-group col-sm-12">
							<label for="member_credit_card">Kredi Kartı</label>
							<select name="member_credit_card" id="member_credit_card" class="form-control" onchange="get_card_no();">
								<cfif get_credit_cards.recordcount>														
									<cfoutput query="get_credit_cards">
										<cfif isDefined("session.ww")>
											<cfset key_type = '#CONSUMER_ID#'>
											<cfset cc_number_ = consumer_cc_number>
											<cfset cc_id_ = consumer_cc_id>
										<cfelse>
											<cfset key_type = '#COMPANY_ID#'>
											<cfset cc_number_ = company_cc_number>
											<cfset cc_id_ = company_cc_id>
										</cfif>
										<!--- 
											FA-09102013
											kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
											Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
										--->
										<cfscript>
											getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
											getCCNOKey.dsn = dsn;
											getCCNOKey1 = getCCNOKey.getCCNOKey1();
											getCCNOKey2 = getCCNOKey.getCCNOKey2();
										</cfscript>
										
										<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
										<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
											<!--- anahtarlar decode ediliyor --->
											<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
											<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
											<!--- kart no encode ediliyor --->
											<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:cc_number_,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
											<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
										<cfelse>
											<cfset content = '#mid(Decrypt(cc_number_,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(cc_number_,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(cc_number_,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(cc_number_,key_type,"CFMX_COMPAT","Hex")))#'>
										</cfif>
										<option value="#cc_id_#">#content#</option>
									</cfoutput>
								<cfelse>
									<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								</cfif>
							</select>
						</div>
					</div>
				</cfif>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label for="card_owner">Kart Üzerindeki İsim *</label>
							<input name="card_owner" id="card_owner" class="form-control" type="text" maxlength="30" autocomplete="off">
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label for="card_no">Kart Numarası *</label>
							<div class="input-group">
								<cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
									<input type="hidden" name="card_no" id="card_no" class="form-control" maxlength="16">
								<cfelse>
									<input type="text" name="card_no" id="card_no" class="form-control" maxlength="16" autocomplete="off" value="" />
								</cfif>
								<div class="input-group-append">
									<span class="input-group-text">
										<i class="far fa-credit-card"></i>
									</span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="form-group col-sm-6">
						<div class="form-group">
							<label for="action_detail">Açıklama</label>
							<input type="text" name="action_detail" id="action_detail" class="form-control" value="" />
						</div>
					</div>
					<div class="form-group col-sm-2">
						<label for="exp_month">Ay *</label>
						<select name="exp_month" id="exp_month" class="form-control">
							<cfloop from="1" to="12" index="k">
								<cfoutput>
									<option value="#k#">#k#</option>
								</cfoutput> 
							</cfloop>
						</select>
					</div>
					<div class="form-group col-sm-2">
						<label for="exp_year">Yıl *</label>                            
						<select name="exp_year" id="exp_year" class="form-control">
							<cfloop from="#dateFormat(now(),'yyyy')#" to="#dateFormat(now(),'yyyy')+10#" index="i">
								<cfoutput>
									<option value="#i#">#i#</option>
								</cfoutput> 
							</cfloop>
						</select>
					</div>
					<div class="col-sm-2">
						<div class="form-group">
							<label for="cvv_no">CVV *</label>
							<div class="input-group">
								<cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
									<cfsavecontent variable="alert">Lütfen Güvenlik Kodu(CVV No) Giriniz</cfsavecontent>
									<cfinput type="hidden" name="cvv_no" id="cvv_no" maxlength="3" message="#alert#" autocomplete="off" readonly>
									<cfinput type="password" name="dsp_cvv_no" maxlength="3" inputStyle="width:50px;" message="#alert#" required="yes" validate="integer" onKeyUp="isNumber(this);kontrol_cardno();" value="" />
								<cfelse>
									<cfsavecontent variable="alert">Lütfen Güvenlik Kodu(CVV No) Giriniz</cfsavecontent>
									<cfinput type="password" name="cvv_no" class="form-control" maxlength="3" inputStyle="width:50px;" message="#alert#" required="yes" validate="integer" onKeyUp="isNumber(this);"  value="" />
								</cfif>
								<div class="input-group-append">
									<span class="input-group-text">
										<i class="fas fa-question" title="Güvenlik Kodu(CVV), Tüm Kredi Kartlarının Arka Yüzünde Bulunan 3 Haneli Numaradır Kredi Kartı İşlemlerinizde Güvenliğinizi Arttırmak İçin Bu Numarayı Girmek Zorundasınız."></i>
									</span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row" style="display:none" id="joker_info">
					<div class="col-sm-12">
						<div class="form-group">
							<label><input name="joker_vada" id="joker_vada" type="checkbox" checked="checked">Joker Vada Kullanmak İstiyorum</label>
						</div>
					</div>
				</div>
				<cfif isdefined("attributes.is_credit_card_rules") and len(attributes.is_credit_card_rules)>
					<div class="row">
						<div class="col-sm-12">
							<div class="form-group">
							<label>Kredi Kartı Kullanım Şartları</label>
								<textarea readonly="readonly" class="form-control"><cfoutput>#attributes.is_credit_card_rules#</cfoutput></textarea>
								<label><input type="checkbox" name="credit_card_rules" id="credit_card_rules" value="1" />
								Kredi Kartı Kullanım Şartlarını Kabul Ediyorum *</label>
							</div>								
						</div>
					</div>
				</cfif>
			</div>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()' insert_alert='#alert#' win_alert="0" insert_info="Ödeme Yap">
			</cf_box_footer>
        </div>
    </div>
</cfform>

<script type="text/javascript">
	var loader_div_message_ = "Yükleniyor...";

	$(document).ready(function(){
		$("#sales_credit_dsp").change(function() {
			listAccounts();
		});
	});

	function kontrol_cardno()
	{
		document.getElementById('card_no').value = document.getElementById('dsp_card_no').value;
		document.getElementById('cvv_no').value = document.getElementById('dsp_cvv_no').value;
	}

	function get_card_no()
	{
		if(document.getElementById('consumer_id').value != "")	
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&consumer_cc_id='+document.getElementById('member_credit_card').value,'show_member_card');
		else
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&company_cc_id='+document.getElementById('member_credit_card').value,'show_member_card');
	}
	<cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
		if(document.add_online_pos.consumer_id.value != "")	
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&consumer_cc_id='+document.getElementById('member_credit_card').value,'show_member_card');
		else
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&company_cc_id='+document.getElementById('member_credit_card').value,'show_member_card');
	</cfif>
	
	function kontrol()
	{
		<cfif isDefined("attributes.campaign_id")>
		temp_aaa = filterNum(document.getElementById('sales_credit_dsp').value);
		if(temp_aaa > <cfoutput>#control_total_debit#</cfoutput>)
		{
			alert("Sadece Kampanyadan Önceki Borcunuzu Ödeyebilirsiniz!");
			return false;
		}
		</cfif> 
		if(document.getElementById('process_type').value == "" || document.getElementById('process_cat_rev').value == "")
		{
			alert("İşlem Tipi Tanımlayınız!");
			return false;
		}

		if(document.getElementById('sales_credit_dsp').value == 0 || document.getElementById('sales_credit_dsp').value == "")	
		{
			alert("Lütfen Önce Tutar Giriniz!");
			document.getElementById('sales_credit_dsp').focus();
			return false;
		}
		
		if(document.getElementById('card_no').value == "")
		{
			alert("Kredi Kartı No Giriniz");
			return false;
		}

		if(document.getElementById('exp_year').value == "" || document.getElementById('exp_month').value == "")
		{
			alert("Lütfen Son Kullanım Tarihini Seçiniz");
			return false;
		}
		
		d = new Date();
		y = document.add_online_pos.exp_year.selectedIndex;
	
		if(document.add_online_pos.exp_year[y].value < d.getFullYear())
		{
			alert(".Seçilen Tarih Bu Dönemden Küçük Olamaz!");
			return false;
		}
		else if(document.add_online_pos.exp_year[y].value == d.getFullYear())
		{
			m = document.add_online_pos.exp_month.selectedIndex;
			thismonth = d.getMonth() + 1;
			if(document.add_online_pos.exp_month[m].value < thismonth)
			{
				alert("Seçilen Tarih Bu Dönemden Küçük Olamaz!");
				return false;
			}
		}

		if(document.add_online_pos.credit_card_rules != undefined && document.add_online_pos.credit_card_rules.checked == false)
		{
			alert("Devam Etmek İçin Kredi Kartı Kullanım Şartlarını Kabul Etmelisiniz !");
			return false;
		}
		return kontrol2();
		
		return true;
	}

	function listAccounts()
	{	
		<cfoutput>
			<cfset http_status = cgi.HTTPS eq 'on' ? "https://" : "http://">
			AjaxPageLoad('#http_status##cgi.http_host#/?fuseaction=objects2.emptypopup_get_accounts_list_ajax<cfif isDefined("attributes.is_comission_total_amount")>&is_comission_total_amount=#attributes.is_comission_total_amount#</cfif><cfif isDefined("attributes.is_vft_total") and len(attributes.is_vft_total)>&is_vft_total=#attributes.is_vft_total#</cfif><cfif isDefined("attributes.campaign_id") and len(attributes.campaign_id)>&campaing_id=#attributes.campaign_id#</cfif><cfif isdefined("attributes.order_id_info") and len(attributes.order_id_info)>&order_id_info=#order_id_info#</cfif><cfif isDefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>&action_to_account_id=#attributes.action_to_account_id#</cfif><cfif isDefined("camp_id_info") and len(camp_id_info)>&camp_id_info=#camp_id_info#</cfif><cfif isdefined("attributes.is_view_commision")>&is_view_commision=#attributes.is_view_commision#</cfif><cfif isdefined("attributes.is_view_multiplier")>&is_view_multiplier=#attributes.is_view_multiplier#</cfif>','list_accounts',1);
		</cfoutput>
	}
</script>