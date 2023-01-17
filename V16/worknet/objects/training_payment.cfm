<!--- sanal pos bilgileri --->
<cfset getSanalPos = createObject("component","worknet.objects.worknet_objects").getSanalPos() />

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
					document.getElementById('sales_credit').value = parseFloat(filterNum(document.getElementById('sales_credit_dsp').value));
				}
				else
				{
					document.getElementById('sales_credit').value = parseFloat(filterNum(document.getElementById('sales_credit_dsp').value)) + (parseFloat(filterNum(document.getElementById('sales_credit_dsp').value)) * (parseFloat(joker_inf.split(';')[6])/100));
				}
			}
			else
				document.getElementById('sales_credit').value = filterNum(document.getElementById('sales_credit_dsp').value);
	}
</script>

<cfif use_https><cfset url_link = https_domain><cfelse><cfset url_link = ""></cfif>
<cfform name="add_online_pos" method="post" action="#url_link##request.self#?fuseaction=worknet.emptypopup_add_training_payment_action">
	<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#getTraining.stock_id#</cfoutput>" />
	<input type="hidden" name="training_id" id="training_id" value="<cfoutput>#getTraining.class_id#</cfoutput>" />
	<input type="hidden" name="account_Recordcount" id="account_Recordcount" value="">
	<div class="abonelik_2">
		<div class="abonelik_22" style="padding: 0px 130px;">
			Eğitimi izleyebilmek için lütfen satın alınız.<br/>
			Fiyatlara KDV dahildir.
		</div>
		<div class="abonelik_21" style="margin:0px 100px; padding:15px;">
			<cfquery name="GET_PROCESS_CAT_TAHSILAT" datasource="#DSN3#">
				SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE <cfif isDefined("session.pp")>IS_PARTNER = 1<cfelse>IS_PUBLIC = 1</cfif> AND PROCESS_TYPE = 241
			</cfquery>
			<cfoutput>
				<input type="hidden" name="process_cat_rev" id="process_cat_rev" value="#GET_PROCESS_CAT_TAHSILAT.PROCESS_CAT_ID#">
				<input type="hidden" name="process_type" id="process_type" value="251">
				<input type="hidden" name="company_id" id="company_id" value="<cfif isDefined("session.pp")>#session.pp.company_id#</cfif>">
				<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isDefined("session.ww")>#session.ww.userid#</cfif>">
				<input type="hidden" name="action_date" id="action_date" value="#dateformat(now(),dateformat_style)#" />
			</cfoutput>
			<table width="500" style="padding:15px;">
				<tr height="25">
					<td>Banka *</td>
					<td><select name="pos_type_id" id="pos_type_id" style="width:175px;" onChange="if (this.options[this.selectedIndex].value != ''){ listAccounts();}">
							<option value="">Banka Seçiniz</option>
							<cfoutput query="getSanalPos">
								<option value="#pos_id#">#pos_name#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr height="25">
					<td>Kart Numarası *</td>
					<td>
						<cfsavecontent variable="alert">Lütfen Geçerli Kredi Kartı Numarası Giriniz</cfsavecontent>
						<cfinput type="hidden" name="card_no" validate="creditcard" maxlength="16" message="#alert#" required="yes" style="width:175px;" autocomplete="off">
						<cf_input_pcKlavye name="dsp_card_no" value="" type="text" numpad="true" accessible="true" maxlength="16" inputStyle="width:175px;"  onKeyUp="isNumber(this);kontrol_cardno();">
					</td>
				</tr>
				<tr height="25">
					<td>Kart Sahibi</td>
					<td><input name="card_owner" id="card_owner" type="text" style="width:175px;" maxlength="30"></td>
				</tr>
				<tr height="25">
					<td>Kart Güvenlik Kodu(CVV) *</td>
					<td>
						<cfsavecontent variable="alert">Lütfen Güvenlik Kodu(CVV No) Giriniz</cfsavecontent>
						<cfinput name="cvv_no" type="hidden" maxlength="3" autocomplete="off" readonly>
						<cf_input_pcKlavye name="dsp_cvv_no" value="" type="text" numpad="true" accessible="true" maxlength="3" inputStyle="width:50px;" validate="integer" onKeyUp="isNumber(this);kontrol_cardno();">
					</td>
				</tr>
				<tr height="25">
					<td>Kart Son Kullanma Tarihi *</td>
					<td><select name="exp_month" id="exp_month" style="width:50px; margin-right:5px;">
							<cfloop from="1" to="12" index="k">
								<cfoutput>
									<option value="#k#">#k#</option>
								</cfoutput> 
							</cfloop>
						</select>
						<select name="exp_year" id="exp_year" style="width:60px;">
							<cfloop from="#dateFormat(now(),'yyyy')#" to="#dateFormat(now(),'yyyy')+10#" index="i">
								<cfoutput>
									<option value="#i#">#i#</option>
								</cfoutput> 
							</cfloop>
						</select>
					</td>
				</tr>
				<tr height="25">
					<td><input type="hidden" name="sales_credit" id="sales_credit" value=""> 
						<input type="hidden" name="sales_credit_dsp" id="sales_credit_dsp" value="" />
					</td>
				</tr>
				<tr style="display:none" id="joker_info">
					<td></td>
					<td><input name="joker_vada" id="joker_vada" type="checkbox" checked="checked"><cf_get_lang no ='1333.Joker Vada Kullanmak İstiyorum'></td>
				</tr>
				<tr>
					<td valign="top" colspan="2">
						<div id="list_accounts"></div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="abonelik_3">
		<cfsavecontent variable="message">ONLİNE ÖDEME</cfsavecontent>
		<input class="abonelik_3_btn" type="button" onClick="kontrol()" value="<cfoutput>#message#</cfoutput>" />
	</div>
	<!--- 3d paramters --->
	<input type="hidden" value="" name="md" id="md" />
	<input type="hidden" value="" name="oid" id="oid" />
	<input type="hidden" value="" name="amount" id="amount" />
	<input type="hidden" value="" name="taksit" id="taksit" />
	<input type="hidden" value="" name="xid" id="xid" />
	<input type="hidden" value="" name="eci" id="eci" />
	<input type="hidden" value="" name="cavv" id="cavv" />
	<input type="hidden" value="" name="mdstatus" id="mdstatus" />
	<input type="hidden" value="" name="error_code" id="error_code" />
	<!--- 3d paramters --->
</cfform>
<div id="ajax_form_3d" style="display:none;"></div>
<script language="javascript">
	function showPayment(tutar)
	{
		document.getElementById('payment').style.display = '';
		
		var pos_type_ = document.getElementById('pos_type_id').value;
		if(document.getElementById('sales_credit').value != '' && pos_type_ != '')
			listAccounts();

		document.getElementById('sales_credit').value = tutar;
		document.getElementById('sales_credit_dsp').value = tutar;
		document.getElementById('card_owner').focus();
	}
	function listAccounts(type)
	{	
		var pos_type_ = document.getElementById('pos_type_id').value;
		if (pos_type_ != undefined)
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_accounts_list_ajax<cfif isDefined("attributes.is_comission_total_amount")>&is_comission_total_amount=#attributes.is_comission_total_amount#</cfif><cfif isDefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>&action_to_account_id=#attributes.action_to_account_id#</cfif><cfif isdefined("attributes.is_view_commision")>&is_view_commision=#attributes.is_view_commision#</cfif><cfif isdefined("attributes.is_view_multiplier")>&is_view_multiplier=#attributes.is_view_multiplier#</cfif>&pos_type_id='+pos_type_+'','list_accounts',1)</cfoutput>;
	}
	
	function kontrol_cardno()
	{
		document.getElementById('card_no').value = document.getElementById('dsp_card_no').value;
		document.getElementById('cvv_no').value = document.getElementById('dsp_cvv_no').value;
	}
	
	function kontrol()
	{
		if(document.getElementById('pos_type_id').value == "")				
		{
			alert("Lütfen Banka Seçiniz!");
			return false;
		}
		if(document.getElementById('card_no').value == "")				
		{
			alert("Lütfen Geçerli Kredi Kartı Numarası Giriniz!");
			return false;
		}
		if(document.getElementById('cvv_no').value == "")				
		{
			alert("Lütfen Güvenlik Kodu(CVV No) Giriniz !");
			return false;
		}		
		d = new Date();
		if(document.getElementById('exp_year').value == d.getFullYear())
		{
			if(document.getElementById('exp_month').value < d.getMonth())
			{
				alert("Seçilen Tarih Bu Dönemden Küçük Olamaz !");
				return false;
			}
		}
		if(document.getElementById('sales_credit_dsp').value == 0 || document.getElementById('sales_credit_dsp').value.value == "")	
		{
			alert("Lütfen Tutar Giriniz");
			return false;
		}
		if(kontrol2())
		{
			account_sira = document.getElementById('account_Recordcount').value;
			
			if(account_sira != '')
			{
				if(account_sira == 1)
				{
					is_secure = list_getat(document.getElementById('action_to_account_id').value,9,';');
					account_ = document.getElementById('action_to_account_id').value;
				}
				else
				{
					for(var acc_cont=0;acc_cont<account_sira;acc_cont++)
					{
						if(document.getElementsByName('action_to_account_id')[acc_cont].checked == true)
						{
							is_secure = document.getElementsByName('action_to_account_id')[acc_cont].value.split(';')[7];
							account_ = document.getElementsByName('action_to_account_id')[acc_cont].value;
						}
					}
				}
			}
			/*if (is_secure == 1)
			{
				card_no_ = document.getElementById('card_no').value;
				cvv_no_ = document.getElementById('cvv_no').value;
				exp_year_ = document.getElementById('exp_year').value;
				exp_month_ = document.getElementById('exp_month').value;
				tutar_ = document.getElementById('sales_credit_dsp').value;
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_form_3d&action_to_account_id='+account_+'&card_no='+card_no_+'&cvv_no='+cvv_no_+'&exp_year='+exp_year_+'&exp_month='+exp_month_+'&tutar_='+tutar_+'','ajax_form_3d',1);
			}
			else*/
			document.getElementById('add_online_pos').submit();
		}
	}
	function historyBack()
	{
		document.getElementById('card_owner').focus();
	}
</script>
