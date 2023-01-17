<!--- 
	Banka select box yerine kullanılacak custom tag,
	Aldığı değişkenlere göre banka hesaplarını select box ile listeler
	created SM 20090821
 --->
<cfparam name="attributes.fieldId" default="account_id"><!--- alan adı --->
<cfparam name="attributes.width" default="120"><!--- genişlik --->
<cfparam name="attributes.is_branch_control" default="0"><!--- yetkiye göre getiriyor --->
<cfparam name="attributes.is_disabled" default="0"><!--- select box disable olsun mu --->
<cfparam name="attributes.control_status" default="1"><!--- sadece aktif hesaplar gelsin --->
<cfparam name="attributes.selected_value" default=""><!--- Seçili olarak gelecek değer --->
<cfparam name="attributes.is_upd" default="0"><!--- Güncelleme sayfasından gelip gelmediğini tutuyor ona göre seçiniz gelmiyor --->
<cfparam name="attributes.is_open_accounts" default="0"><!--- Banka açılışı yapılmamış hesapların gelmesi için eklendi--->
<cfparam name="attributes.call_function" default=""><!--- Onchange çalışacak fonksiyon --->
<cfparam name="attributes.line_info" default=""><!--- Eğer birden fazla banka hesabı varsa sayfada aynı isimde değişken olmasın diye --->
<cfparam name="attributes.money_type_control" default=""><!--- 1 ise sadece tl olanları 2 ise sadece dövizli banka hesaplarını getirir --->
<cfparam name="attributes.is_system_money" default="0"><!--- 1 ise sadece sistem dövizi olan hesapları getirir --->
<cfparam name="attributes.currency_id_info" default=""><!--- gönderilen para birimndeki hesapları getirmesi için--->
<cfparam name="attributes.account_type" default="0"><!--- hesap türünü belirler (0:tumu,1:ticari,2:kredili) --->
<cfparam name="attributes.ajaxFormName" default=""><!--- ajax sayfalara değerleri taşımak için eklendi --->
<cfparam name="attributes.isRequired" default=""><!--- zorunlu olsun mu? --->
<cfparam name="attributes.is_multiple" default="">
<cfparam name="attributes.requiredMsg" default="#caller.getLang('main',793)# !"><!--- zorunlu mesajı? --->
<cfif session.ep.isBranchAuthorization>
	<cfset attributes.is_branch_control = 1>
</cfif>
<cfscript>
	CreateComponent = CreateObject("component","/../workdata/getAccounts");
	queryResult = CreateComponent.getCompenentFunction(is_system_money:attributes.is_system_money,use_period:caller.fusebox.use_period,money_type_control:attributes.money_type_control,is_branch_control:attributes.is_branch_control,control_status:attributes.control_status,is_open_accounts:attributes.is_open_accounts,currency_id_info:attributes.currency_id_info,account_type:attributes.account_type);	
</cfscript>
<cfoutput>
	<input type="hidden" name="bank_name#attributes.line_info#" id="bank_name#attributes.line_info#" value="">
	<input type="hidden" name="bank_branch_name#attributes.line_info#" id="bank_branch_name#attributes.line_info#" value="">
	<input type="hidden" name="currency_id#attributes.line_info#" id="currency_id#attributes.line_info#" value="">
	<input type="hidden" name="account_acc_code#attributes.line_info#" id="account_acc_code#attributes.line_info#" value="">
	<input type="hidden" name="bank_code#attributes.line_info#" id="bank_code#attributes.line_info#" value="">
    <select 
		name="#attributes.fieldId#"
		<cfif isdefined("attributes.is_multiple") and len(attributes.is_multiple)>
			multiple="multiple"
		</cfif>
        id="#attributes.fieldId#" 
        #attributes.isRequired#
        data-msg="#attributes.requiredMsg#"
        onChange="get_acc_info_#attributes.line_info#();<cfif len(attributes.call_function)>#listfirst(attributes.call_function)#('#attributes.fieldId#');#listlast(attributes.call_function)#</cfif>" <cfif attributes.is_disabled eq 1>disabled</cfif>>
    	<cfif attributes.is_upd eq 0><option value="">#caller.getLang('main',1652)#</option></cfif>
		<cfloop query="queryResult">
			<!--- workdatadan aktif hesaplari getir secenegi kaldirilarak buraya tasindi, pasif olan hesabin islem detayinda yanlis banka bilgisi geliyor FBS20110413 --->
			<cfif (len(attributes.selected_value) and account_id eq attributes.selected_value) or ((attributes.control_status eq 1 and account_status eq 1) or attributes.control_status neq 1)>
				<option value="#account_id#" <cfif len(attributes.selected_value) and listfind(attributes.selected_value,account_id,',')>selected</cfif>>#account_name#&nbsp;#account_currency_id#</option>
			</cfif>
		</cfloop>
    </select>
	<script type="text/javascript">
		function get_acc_info_#attributes.line_info#()
		{
			acc_info = document.getElementById('#attributes.fieldId#').value;
			
			if(acc_info != '')
			{
				url_= '/V16/bank/cfc/bankInfo.cfc?method=getBankInfo';
				$.ajax({                                                                                             
					url: url_,
					dataType: "text",
					data: {acc_info: acc_info},
					cache: false,
					async: false,
					success: function(read_data) {
						data_ = jQuery.parseJSON(read_data.replace('//',''));
						if(data_.DATA.length != 0)
						{
							$.each(data_.DATA,function(i){
								document.getElementById('currency_id#attributes.line_info#').value = data_.DATA[i][0];			//ACCOUNT_CURRENCY_ID
								document.getElementById('account_acc_code#attributes.line_info#').value = data_.DATA[i][1];		//ACCOUNT_ACC_CODE
								document.getElementById('bank_name#attributes.line_info#').value = data_.DATA[i][2];			//BANK_NAME
								document.getElementById('bank_branch_name#attributes.line_info#').value = data_.DATA[i][3];		//BANK_BRANCH_NAME
								document.getElementById('bank_code#attributes.line_info#').value = data_.DATA[i][4];		//BANK_CODE
								
								<cfif len(attributes.ajaxFormName)>
									$("##currency_id<cfoutput>#attributes.line_info#</cfoutput>").appendTo("##<cfoutput>#attributes.ajaxFormName#</cfoutput>");
									$("##account_acc_code<cfoutput>#attributes.line_info#</cfoutput>").appendTo("##<cfoutput>#attributes.ajaxFormName#</cfoutput>");
									$("##bank_name<cfoutput>#attributes.line_info#</cfoutput>").appendTo("##<cfoutput>#attributes.ajaxFormName#</cfoutput>");
									$("##bank_branch_name<cfoutput>#attributes.line_info#</cfoutput>").appendTo("##<cfoutput>#attributes.ajaxFormName#</cfoutput>");
									$("##bank_code<cfoutput>#attributes.line_info#</cfoutput>").appendTo("##<cfoutput>#attributes.ajaxFormName#</cfoutput>");
									
									newElement = $('<input>').attr({
									  name: '<cfoutput>#attributes.fieldId#</cfoutput>',
									  type: 'hidden',
									  value : $("##<cfoutput>#attributes.fieldId#</cfoutput>").val()
									}).appendTo("##<cfoutput>#attributes.ajaxFormName#</cfoutput>");
								</cfif>
								
							});
						}
					}
				});
			}
			else
			{
				document.getElementById('currency_id#attributes.line_info#').value = '';
				document.getElementById('account_acc_code#attributes.line_info#').value = '';
				document.getElementById('bank_name#attributes.line_info#').value = '';
				document.getElementById('bank_branch_name#attributes.line_info#').value = '';
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
							alertObject({message: "<cf_get_lang_main no='793.Lutfen Banka Hesabi Seciniz'>!",closeTime:3000});
							return false;
						}
					}
					else if (document.getElementById('#attributes.fieldId#').value == "")
					{
						alertObject({message: "<cf_get_lang_main no='793.Lutfen Banka Hesabi Seciniz'>!",closeTime:3000});
						return false;
					}
					}
				return true;
			}
	
		get_acc_info_#attributes.line_info#();
	</script>
</cfoutput> 