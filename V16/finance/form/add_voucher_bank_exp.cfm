<!--- <cfinclude template="../query/get_control.cfm"> --->
<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_NAME,
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_CURRENCY_ID,
		BANK_BRANCH.BANK_BRANCH_NAME
	FROM
		ACCOUNTS,	
		BANK_BRANCH
	WHERE
		ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
</cfquery>
	<cfsavecontent variable="head_">
		<cf_get_lang dictionary_id='54507.Banka Portföy Senet Girişi'>
	  </cfsavecontent>
<cfsavecontent variable="right">
    <font color="#FF0000"><cf_get_lang dictionary_id='54899.Dikkat Toplu Senet Girişi Workcube kullanacak şirketlerin sadece başlangıçta senetlerini sisteme girmeleri için kullanılır'>.</font>
</cfsavecontent>
<cfset pageHead = head_>
<cf_catalystHeader>
<cfform name="add_voucher_entry" method="post" action="#request.self#?fuseaction=finance.emptypopup_add_voucher_bank_exp">
	<cfoutput query="GET_MONEY">
		<cfif money eq session.ep.money2>
      		<cfinput name="money_rate2" type="hidden" value="#rate2#" class="moneybox">
        </cfif>
    </cfoutput>
   <cf_box title="#head_#">
        	<div class="row"><label class="pull-left bold"><cfoutput>#right#</cfoutput></label></div>
        	<div class="row">
            	<div class="col col-12">
                    <cf_grid_list>
						<thead>
							<tr>
								<th><cf_get_lang dictionary_id='57521.Banka'></th>
								<th><cf_get_lang dictionary_id='57742.Tarih'> *</th>
								<th><cf_get_lang dictionary_id='58180.Borçlu'></th>
								<th><cf_get_lang dictionary_id='57519.Cari Hesap'> *</th>
								<th><cf_get_lang dictionary_id='58502.Senet No'> *</th>
								<th><cf_get_lang dictionary_id='57673.Tutar'> *</th>
								<th><cf_get_lang dictionary_id="57489.Para Birimi"></th>
								<th><cf_get_lang dictionary_id="50263.Sistem Para Br."></th>
								<th><cf_get_lang dictionary_id="57789.Özel Kod"></th>
							</tr>
						</thead>
						<tbody>
							<cfloop from="1" to="15" index="i">
								<tr>
									<td>
										<select name="hesap<cfoutput>#i#</cfoutput>" id="hesap<cfoutput>#i#</cfoutput>" style="width:150px;">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="GET_ACCOUNTS">
												<option value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#">#ACCOUNT_NAME#</option>
											</cfoutput>
										</select>
									</td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang no ='516.Senet tarihini giriniz'>!</cfsavecontent>
												<cfinput value="" type="text" name="VOUCHER_DUEDATE#i#" style="width:65px;" message="#message#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="VOUCHER_DUEDATE#i#"></span>
											</div>
										</div>
									</td>
									<td>
										<cfsavecontent variable="message"><cf_get_lang no ='291.Firmayı Giriniz'>!</cfsavecontent>
										<cfinput type="text" name="DEBTOR_NAME#i#" value="" style="width:80px;" message="#message#">
									</td>
									<td nowrap="nowrap">
										<div class="form-group">
											<div class="input-group">
												<cfinput type="hidden" name="company_id#i#" value="">
												<cfinput type="hidden" name="consumer_id#i#" value="">
												<cfsavecontent variable="message"><cf_get_lang no='131.cari hesap Seçiniz !'></cfsavecontent>
												<cfinput type="text" name="company_name#i#" value="" onFocus="AutoComplete_Create('company_name#i#','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',0,2,0','COMPANY_ID,CONSUMER_ID','company_id#i#,consumer_id#i#','add_voucher_entry','3','250');" message="#message#" style="width:120px;">
												<span class="input-group-addon icon-ellipsis"  onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_member_name=add_voucher_entry.company_name#i#&field_comp_id=add_voucher_entry.company_id#i#&field_comp_name=add_voucher_entry.company_name#i#&field_consumer=add_voucher_entry.consumer_id#i#</cfoutput>');"></span>
											</div>
										</div>
									</td>
									<td>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58744.Senet No Giriniz'>!</cfsavecontent>
										<cfinput type="text" name="VOUCHER_NO#i#" style="width:80px;" message="#message#"></td>
									<td>
										<cfsavecontent variable="message"><cf_get_lang no ='517.Senet Tutarını Giriniz'>!</cfsavecontent>
										<cfinput type="text" name="VOUCHER_VALUE#i#" class="moneybox" onBlur="hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));"  style="width:80px;" message="#message#">
									</td>
									<td>
										<select name="CURRENCY_ID<cfoutput>#i#</cfoutput>" id="CURRENCY_ID<cfoutput>#i#</cfoutput>" style="width:70px;" onChange="hesapla(<cfoutput>#i#</cfoutput>);">
											<cfoutput query="GET_MONEY">
												<option value="#money#;#rate2#;#rate1#"<cfif money eq session.ep.money>selected</cfif>>#MONEY#</option>
											</cfoutput>
										</select>
									</td>
									<td>
										<cfsavecontent variable="message"><cf_get_lang no ='517.Senet Tutarını Giriniz'>!</cfsavecontent>
										<cfinput type="text" name="SYSTEM_VOUCHER_VALUE#i#" class="moneybox" onkeyup="return(FormatCurrency(this,event));"  style="width:80px;" message="#message#">
									</td>
									<cfinput type="hidden" name="VOUCHER_OTHER_MONEY_VALUE#i#" style="width:80px;" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
									<td><cfinput type="text" name="VOUCHER_CODE#i#" value="" maxlength="50" style="width:80px;"></td>
								</tr>
							</cfloop> 
						</tbody>
    				</cf_grid_list>
                </div>
            </div>
            <div class="row formContentFooter">
            	<div class="col col-12">
                	<cf_workcube_buttons type_format="1" is_upd='0'  add_function="kontrol()">
                </div>
            </div>
        
		</cf_box>

</cfform>

<script type="text/javascript">
	function kontrol()
	{
		for(var i=1; i<=15; i++)
		{
			if(document.getElementById('hesap'+i).value != "")
			{
            
            
				if(document.getElementById('VOUCHER_NO'+i).value == "")
				{
					alert(i + ".<cf_get_lang dictionary_id='45657.Satır İçin'> <cf_get_lang dictionary_id='50332.Senet No Girmelisiniz'>");
						return false;
				}
			
				if(document.getElementById('VOUCHER_VALUE'+i).value == "")
				{
				alert(i + ".<cf_get_lang dictionary_id='45657.Satır İçin'> <cf_get_lang dictionary_id='54493.Lütfen Tutar Giriniz'> !");
				return false;
			}
				if(document.getElementById('VOUCHER_DUEDATE'+i).value == "")
				{
				alert(i + ".<cf_get_lang dictionary_id='45657.Satır İçin'> <cf_get_lang dictionary_id='56195.Lütfen Tarih Seçiniz'>!");
				return false;
			}	
				if (document.getElementById('VOUCHER_VALUE'+i).value != "" && list_getat(document.getElementById('hesap'+i).value,2,';') != list_getat(document.getElementById('CURRENCY_ID'+i).value,1,';'))
				{
					alert("<cf_get_lang dictionary_id='50495.Kasa ile Senetin Para Birimi Farklı'>");
					return false;
				}
				if(document.getElementById('VOUCHER_VALUE'+i).value != "" && document.getElementById('SYSTEM_VOUCHER_VALUE'+i).value == "")
				{
					alert('<cfoutput><cf_get_lang dictionary_id='54904.Sistem Para Birimi Tutarları Eksik'></cfoutput>');
					return false;
				}
				
				if(document.getElementById('VOUCHER_VALUE'+i).value != "" && ( document.getElementById('company_name'+i).value == "" || ( document.getElementById('company_name'+i).value != "" && document.getElementById('company_id'+i).value == "" && document.getElementById('consumer_id'+i).value == "" )) )
				{
					alert('<cfoutput>#getLang('','Lütfen Cari Hesap Seçiniz','54489')#</cfoutput> <cfoutput>#getLang('','satır','58508')#</cfoutput>' +i+ '');
					return false;
				}
			}
		}
		return (unformat_fields());
		return true;
	}
	
	function unformat_fields()
	{
		for(var i=1; i<=15; i++)
		{
			document.getElementById('VOUCHER_VALUE'+i).value=filterNum(document.getElementById('VOUCHER_VALUE'+i ).value);
			document.getElementById('SYSTEM_VOUCHER_VALUE'+i).value=filterNum(document.getElementById('SYSTEM_VOUCHER_VALUE'+i ).value);
			document.getElementById('VOUCHER_OTHER_MONEY_VALUE'+i).value=filterNum(document.getElementById('VOUCHER_OTHER_MONEY_VALUE'+i ).value);
		}
		return true;
	}
	function hesapla(i)
	{
		if(document.getElementById('VOUCHER_VALUE'+i).value != '')
		{
			var temp_cheque_value = filterNum(document.getElementById('VOUCHER_VALUE'+i).value);
			var money_type=document.getElementById('CURRENCY_ID'+i)[document.getElementById('CURRENCY_ID'+i).options.selectedIndex].value;
			money_rate = (list_getat(money_type,2,';')/list_getat(money_type,3,';'));
			
			document.getElementById('SYSTEM_VOUCHER_VALUE'+i).value = commaSplit(parseFloat(temp_cheque_value)*parseFloat(money_rate));
			document.getElementById('VOUCHER_VALUE'+i).value = commaSplit(temp_cheque_value);
			document.getElementById('VOUCHER_OTHER_MONEY_VALUE'+i).value = commaSplit(filterNum(document.getElementById('SYSTEM_VOUCHER_VALUE'+i).value)/document.add_voucher_entry.money_rate2.value);
		}
		else
			document.getElementById('SYSTEM_VOUCHER_VALUE'+i).value =0;
	}
</script>
