<!---Select İfadeleri düzenlendi e.a 23.07.2012--->
<cf_xml_page_edit fuseact="bank.popup_add_provision_import">
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO
	FROM
		ACCOUNTS ACCOUNTS,
		CREDITCARD_PAYMENT_TYPE CPT
	WHERE
		ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT
		<cfif session.ep.period_year lt 2009>
			AND (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')  
		<cfelse>
			AND ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) 
		</cfif>
		AND CPT.IS_ACTIVE = 1
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
</cfquery>
<cfparam name="attributes.prov_period" default="">
<cfparam  name="attributes.modal_id" default="">
<cf_box title="#getLang('','Provizyon İmport','48698')#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> <!---Provizyon İmport--->
	<cfform name="provision_import_file" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=bank.popupflush_import_provision" onsubmit="return control();">
	<input type="hidden" name="i_id" id="i_id" value="<cfoutput>#attributes.i_id#</cfoutput>">
	<input type="hidden" name="x_is_add_ins_number" id="x_is_add_ins_number" value="<cfoutput>#x_is_add_ins_number#</cfoutput>">
	<input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-process_cat">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'>*</label>
					<div class="col col-8 col-xs-12">
						<cf_workcube_process_cat slct_width="225">
					</div>
				</div>
				<div class="form-group" id="item-action_to_account_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57652.Hesap'><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
					<div class="col col-8 col-xs-12">
						<select name="action_to_account_id" id="action_to_account_id" >
						<option value=""><cf_get_lang dictionary_id="48966.Hesap ve Ödeme Yöntemi Seçiniz"></option>
						<cfoutput query="GET_ACCOUNTS"><!---eleman sırası değişmesin AE--->
							<option value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#;#PAYMENT_TYPE_ID#;#listgetat(session.ep.user_location,2,'-')#">#ACCOUNT_NAME# / #CARD_NO#</option>
						</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-key_type">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'>*</label>
					<div class="col col-8 col-xs-12">
						<input name="key_type" id="key_type" type="password" autocomplete="off" >
					</div>
				</div>
				<cfif session.ep.admin or get_module_power_user(19)><!--- sadece yıl sonunda ve pronet için uzman bilgisinde yapılması gerektigi icin admine bağlanmıstır...Aysenur20061214 --->
					<div class="form-group" id="item-prov_period">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48956.İlişkili Fatura Dönemi'></label>
						<div class="col col-8 col-xs-12">
							<cfquery name="GET_PERIODS" datasource="#dsn#">
								SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
							</cfquery>
							<select name="prov_period" id="prov_period" >
								<cfoutput query="GET_PERIODS">
									<option value="#PERIOD_ID#" <cfif attributes.prov_period eq PERIOD_ID>selected<cfelseif PERIOD_ID eq session.ep.period_id>selected</cfif>>#PERIOD# - (#PERIOD_YEAR#)</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</cfif>
				<div class="form-group" id="item-process_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'>!</cfsavecontent>
							<cfinput required="yes" value="#dateformat(now(),dateformat_style)#" message="#message#" type="text" name="process_date" id="process_date" style="width:65px;" validate="#validate_style#" maxlength="10">
							<span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
						</div>
					</div>
				</div>
			</div>
		
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons type_format="1" is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('provision_import_file' , #attributes.modal_id#)"),DE(""))#'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
provision_import_file.key_type.focus();
function control()
{
	if (!chk_process_cat('provision_import_file')) return false;
	if(!check_display_files('provision_import_file')) return false;
	x = document.provision_import_file.action_to_account_id.selectedIndex;
	if (document.provision_import_file.action_to_account_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58027.Ödeme Yöntemi Seçiniz'>");
		return false;
	}
	if(provision_import_file.key_type.value == "")
	{
		alert("<cf_get_lang dictionary_id='49039.Şifre Giriniz'>");
		return false;
	}
	return true;
}
</script>
