<!--- wrkCreditCards kredi kartı tahsil yöntemlerini select box olarak getirir AE 20090907--->
<cfparam name="attributes.fieldId" default="payment_type_id"><!--- alan adı --->
<cfparam name="attributes.width" default="120"><!--- genişlik --->
<cfparam name="attributes.is_branch_control" default="0"><!--- yetkiye göre getiriyor --->
<cfparam name="attributes.is_disabled" default="0"><!--- select box disable olsun mu --->
<cfparam name="attributes.control_status" default=""><!--- sadece aktif hesaplar gelsin --->
<cfparam name="attributes.selected_value" default=""><!--- Seçili olarak gelecek değer --->
<cfparam name="attributes.is_upd" default="0"><!--- Güncelleme sayfasından gelip gelmediğini tutuyor ona göre seçiniz gelmiyor --->
<cfparam name="attributes.is_open_accounts" default="0"><!--- Banka açılışı yapılmamış hesapların gelmesi için eklendi--->
<cfparam name="attributes.call_function" default=""><!--- Onchange çalışacak fonksiyon --->
<cfparam name="attributes.line_info" default=""><!--- Eğer birden fazla banka hesabı varsa sayfada aynı isimde değişken olmasın diye --->
<cfparam name="attributes.money_type_control" default=""><!--- 1 ise sadece tl olanları 2 ise sadece dövizli banka hesaplarını getirir --->
<cfparam name="attributes.is_system_money" default="0"><!--- 1 ise sadece sistem dövizi olan hesapları getirir --->
<cfparam name="attributes.is_active" default="1"><!--- 1 ise aktif olanlar, 0 ise tümü gelsin --->
<cfparam name="attributes.isRequired" default=""><!--- zorunlu olsun mu? --->
<cfparam name="attributes.requiredMsg" default="#caller.getLang('main',615)# !"><!--- zorunlu mesajı? --->
<cfif session.ep.ISBRANCHAUTHORIZATION eq 1>
	<cfset attributes.is_branch_control = 1>
</cfif>
<cfscript>
	CreateComponent = CreateObject("component","/../workdata/getCreditCards");
	queryResult = CreateComponent.getCompenentFunction(is_system_money:attributes.is_system_money,money_type_control:attributes.money_type_control,is_branch_control:attributes.is_branch_control,control_status:attributes.control_status,is_open_accounts:attributes.is_open_accounts,is_active:attributes.is_active);	
</cfscript>
<cfoutput>
	<input type="hidden" name="currency_id#attributes.line_info#" id="currency_id#attributes.line_info#" value="">
	<input type="hidden" name="account_acc_code#attributes.line_info#" id="account_acc_code#attributes.line_info#" value="">
	<input type="hidden" name="account_id#attributes.line_info#" id="account_id#attributes.line_info#" value="">
	<input type="hidden" name="payment_rate#attributes.line_info#" id="payment_rate#attributes.line_info#" value="">
	<input type="hidden" name="payment_rate_acc#attributes.line_info#" id="payment_rate_acc#attributes.line_info#" value="">
    <select
    	name="#attributes.fieldId#"
        id="#attributes.fieldId#"
        #attributes.isRequired#
        data-msg="#attributes.requiredMsg#"
        onChange="get_acc_info_#attributes.line_info#();<cfif len(attributes.call_function)>#attributes.call_function#();</cfif>;kur_ekle_f_hesapla('account_id')" <cfif attributes.is_disabled eq 1>disabled</cfif>>
    	<cfif attributes.is_upd eq 0><option value="">#caller.getLang('main',322)#</option></cfif>
		<cfloop query="queryResult">
			<option value="#PAYMENT_TYPE_ID#" <cfif len(attributes.selected_value) and PAYMENT_TYPE_ID eq attributes.selected_value>selected</cfif>><cfif len(ACCOUNT_NAME)>#ACCOUNT_NAME# / </cfif>#CARD_NO#</option>
		</cfloop>
    </select>
	<script type="text/javascript">
		function get_acc_info_#attributes.line_info#()
		{
			acc_info = document.getElementById('#attributes.fieldId#').value;
			if(acc_info != '')
			{
				url_= '/V16/bank/cfc/bankInfo.cfc?method=getCreditBankInfo';
				
				$.ajax({
					type: "get",
					url: url_,
					data: {paymentType: acc_info},
					cache: false,
					async: false,
					success: function(read_data){
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
							$.each(data_.DATA,function(i){
								document.getElementById('currency_id#attributes.line_info#').value = data_.DATA[i][0];
								document.getElementById('account_acc_code#attributes.line_info#').value = data_.DATA[i][1];
								document.getElementById('account_id#attributes.line_info#').value = data_.DATA[i][2];
								document.getElementById('payment_rate#attributes.line_info#').value = data_.DATA[i][3];
								document.getElementById('payment_rate_acc#attributes.line_info#').value = data_.DATA[i][4];
								});
						}
						else
						{
							$.ajax({
								type: "get",
								url: '/V16/bank/cfc/bankInfo.cfc?method=getCreditBankInfo',
								data: {paymentType: acc_info},
								cache: false,
								async: false,
								success: function(read_data){
									data_ = jQuery.parseJSON(read_data.replace('//',''));
									if(data_.DATA.length != 0)
									{
										$.each(data_.DATA,function(i){
											document.getElementById('currency_id#attributes.line_info#').value = "#session.ep.money#";
											document.getElementById('account_acc_code#attributes.line_info#').value = '';
											document.getElementById('account_id#attributes.line_info#').value = 0;
											document.getElementById('payment_rate#attributes.line_info#').value = data_.DATA[i][0];
											document.getElementById('payment_rate_acc#attributes.line_info#').value = data_.DATA[i][1];
											});
									}
								}
							});
						}
					}
				});	
				
			}
			else
			{
				document.getElementById('currency_id#attributes.line_info#').value = '';
				document.getElementById('account_acc_code#attributes.line_info#').value = '';
				document.getElementById('account_id#attributes.line_info#').value = '';
				document.getElementById('payment_rate#attributes.line_info#').value = '';
				document.getElementById('payment_rate_acc#attributes.line_info#').value = '';
			}
		}
		function acc_control(fieldId)//formlardaki zorunlu banka hesabı seçme kontrolleri için
		{
			if('#attributes.isRequired#' != 'required')
			{
				if(fieldId != undefined)
				{
					if (document.getElementById(fieldId).value == "")
					{
						alertObject({message: "<cf_get_lang_main no='615.Lütfen Ödeme Yöntemi Seçiniz'>!",closeTime:3000});
						return false;
					}
					else if (document.getElementById('#attributes.fieldId#').value == "")
					{
						alertObject({message: "<cf_get_lang_main no='615.Lütfen Ödeme Yöntemi Seçiniz'>!",closeTime:3000});
						return false;
					}
				}
			}
			return true;
		}
		get_acc_info_#attributes.line_info#();
	</script>
</cfoutput>
