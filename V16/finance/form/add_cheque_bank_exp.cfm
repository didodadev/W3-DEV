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
<cfsavecontent variable="right">
	<font color="#FF0000"><cf_get_lang dictionary_id='54617.Dikkat Toplu Çek Girişi Workcubeu kullanacak şirketlerin sadece başlangıçta çeklerini sisteme girmeleri için kullanılır'>.</font>
</cfsavecontent>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_cheque_entry" method="post" action="#request.self#?fuseaction=finance.emptypopup_add_cheque_bank_exp" onsubmit="return (unformat_fields());">
			<cfoutput query="GET_MONEY">
				<cfif money eq session.ep.money2>
					<cfinput name="money_rate2" type="hidden" value="#rate2#" class="moneybox">
				</cfif>
			</cfoutput>
			<div class="row"><label class="pull-left bold"><cfoutput>#getLang('finance',287)#</cfoutput></label><label class="pull-right bold"><cfoutput>#right#</cfoutput></label></div>
			<cf_grid_list>
				<thead>
					<tr>
						<th width="200"><cf_get_lang dictionary_id='57521.Banka'></th>
						<th><cf_get_lang dictionary_id='57742.Tarih'> *</th>
						<th><cf_get_lang dictionary_id='58180.Borçlu'></th>
						<th><cf_get_lang dictionary_id='58970.Ciro Eden'></th>
						<th width="250"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</th>
						<th><cf_get_lang dictionary_id='57521.Banka'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='54490.Çek No'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'> *</th>
						<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
						<th><cf_get_lang dictionary_id='54901.Sistem Para Br.'></th>
						<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					</tr>
				</thead>
				<cfloop from="1" to="15" index="i">
					<tbody>
						<tr>
							<td>
								<div class="form-group">
									<select name="hesap<cfoutput>#i#</cfoutput>" id="hesap<cfoutput>#i#</cfoutput>">
										<cfoutput query="GET_ACCOUNTS">
											<option value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#">#ACCOUNT_NAME# - #ACCOUNT_CURRENCY_ID#</option>
										</cfoutput>
									</select>
								</div>
							</td>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<cfinput value="" type="text" name="CHEQUE_DUEDATE#i#" message="#getLang('','çek tarihini giriniz',54676)#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="CHEQUE_DUEDATE#i#"></span>
									</div>
								</div>
							</td>
							<td>
								<div class="form-group"><cfinput type="text" name="DEBTOR_NAME#i#" value="" message="#getLang('','Firmayı Giriniz',54677)#!"></div>
							</td>
							<td><div class="form-group"><cfinput type="text" name="endorsement_member#i#"></div></td>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<cfinput type="hidden" name="company_id#i#" value="">
										<cfinput type="hidden" name="consumer_id#i#" value="">
										<cfinput type="text" name="company_name#i#" value="" onFocus="AutoComplete_Create('company_name#i#','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',0,2,0','COMPANY_ID,CONSUMER_ID','company_id#i#,consumer_id#i#','add_cheque_entry','3','250');" message="#getLang('','cari hesap Seçiniz !',45308)#">
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_member_name=add_cheque_entry.company_name#i#&field_comp_id=add_cheque_entry.company_id#i#&field_comp_name=add_cheque_entry.company_name#i#&field_consumer=add_cheque_entry.consumer_id#i#</cfoutput>');"></span>
									</div>
								</div>
							</td>
							<td><div class="form-group"><cfinput type="text" name="BANK_NAME#i#"></div></td>
							<td><div class="form-group"><cfinput type="text" name="BANK_BRANCH_NAME#i#"></div></td>
							<td><div class="form-group"><cfinput type="text" name="CHEQUE_NO#i#" onkeyup="isNumber(this);" onblur='isNumber(this);' message="#getLang('','Çek No Giriniz',54678)#!"></td></div>
							<td><div class="form-group"><cfinput type="text" name="CHEQUE_VALUE#i#" class="moneybox" onBlur="hesapla(#i#);" onkeyup="return(FormatCurrency(this,event));" message="#getLang('','Çek Tutarını Giriniz',54679)#!"></div></td>
							<td>
								<div class="form-group">
									<select name="CURRENCY_ID<cfoutput>#i#</cfoutput>" id="CURRENCY_ID<cfoutput>#i#</cfoutput>" onchange="hesapla(<cfoutput>#i#</cfoutput>);">
										<cfoutput query="GET_MONEY">
											<option value="#money#;#rate2#;#rate1#"<cfif money eq session.ep.money>selected</cfif>>#MONEY#</option>
										</cfoutput>
									</select>
								</div>
							</td>
							<td nowrap="nowrap"><div class="form-group"><cfinput type="text" name="SYSTEM_CHEQUE_VALUE#i#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" message="#getLang('','Çek Sistem Para Br. Tutarı Giriniz!',63638)#"></div></td>
							<td><div class="form-group"><cfinput type="text" name="CHEQUE_CODE#i#" value="" maxlength="50"></div></td>
							<cfinput type="hidden" name="CHEQUE_OTHER_MONEY_VALUE#i#" value="" class="moneybox" onkeyup="return (FormatCurrency(this,event));">
						</tr>
					</tbody>
				</cfloop>  
			</cf_grid_list>
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0'  add_function="kontrol()">
			<cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	function kontrol()
	{
		for(var i=1; i<=15; i++)
		{
			if(eval('add_cheque_entry.CHEQUE_NO'+i).value != "")
			{
				if(eval('add_cheque_entry.CHEQUE_DUEDATE'+i).value == "")
				{
					alert('<cfoutput>#getLang('hr',1110)#</cfoutput> <cfoutput>#getLang('main',1096)#</cfoutput>'+ i + '');
					return false;
				}	
				if(eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" && ( eval('add_cheque_entry.company_name'+i).value == "" || ( eval('add_cheque_entry.company_name'+i).value != "" && eval('add_cheque_entry.company_id'+i).value == "" && eval('add_cheque_entry.consumer_id'+i).value == "" )) )
				{
					alert('<cfoutput>#getLang('finance',103)#</cfoutput> <cfoutput>#getLang('main',1096)#</cfoutput>'+ i + '');
					return false;
				}
				if(eval('add_cheque_entry.CHEQUE_VALUE'+i).value == "")
				{
					alert('<cfoutput>#getLang('finance',107)#</cfoutput> <cfoutput>#getLang('main',1096)#</cfoutput>'+ i + '');
					return false;
				}
			}
			else if(eval('add_cheque_entry.CHEQUE_NO'+i).value == "" && (eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" || eval('add_cheque_entry.CHEQUE_DUEDATE'+i).value != "" || eval('add_cheque_entry.company_name'+i).value != "" || eval('add_cheque_entry.company_id'+i).value != "" || eval('add_cheque_entry.consumer_id'+i).value != ""))
			{
				alert('<cfoutput>#getLang('member',271)#</cfoutput> <cfoutput>#getLang('main',1096)#</cfoutput>'+ i + '');
				return false;
			}
			if(eval('add_cheque_entry.CHEQUE_NO'+i).value != "" && eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" && list_getat(eval('add_cheque_entry.hesap'+i).value,2,';') != list_getat(eval('add_cheque_entry.CURRENCY_ID'+i).value,1,';'))
			{
				alert('Banka ile Çekin Para Birimi Farklı!');
				return false;
			} 
			if(eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" && eval('add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value == "")
			{
				alert("<cf_get_lang dictionary_id='54904.Sistem Para Birimi Tutarları Eksik'>!");
				return false;
			}
		}
		return true;
	}
	
	function unformat_fields()
	{
		for(var i=1; i<=15; i++)
			{
			eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value=filterNum(eval('document.add_cheque_entry.CHEQUE_VALUE'+i ).value);
			eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value=filterNum(eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i ).value);
			eval('document.add_cheque_entry.CHEQUE_OTHER_MONEY_VALUE'+i).value=filterNum(eval('document.add_cheque_entry.CHEQUE_OTHER_MONEY_VALUE'+i ).value);
			}
		return true;
	}
	function hesapla(i)
	{
		if(eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value != '')
		{
			var temp_cheque_value = filterNum(eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value);
			var money_type=eval('document.add_cheque_entry.CURRENCY_ID'+i)[eval('document.add_cheque_entry.CURRENCY_ID'+i).options.selectedIndex].value;
			money_rate = (list_getat(money_type,2,';')/list_getat(money_type,3,';'));
			eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value = commaSplit(parseFloat(temp_cheque_value)*parseFloat(money_rate));
			eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value = commaSplit(temp_cheque_value);
			eval('document.add_cheque_entry.CHEQUE_OTHER_MONEY_VALUE'+i).value = commaSplit(filterNum(eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value)/document.add_cheque_entry.money_rate2.value);
		}
		else
			eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value =0;
	}
</script>
