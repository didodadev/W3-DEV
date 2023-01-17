<cf_get_lang_set module_name="objects">
<cfif not (get_module_user(22) or get_module_user(24)  or get_module_user(25))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57532.Yetkiniz Yok'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfset xfa.add = "objects.add_sub_account">
<cfinclude template="../query/get_account.cfm">
<cfscript>
	if (get_acc.recordcount)
	{
		islem_gormus = 1 ;
		is_update = 1 ;
	} else {
		islem_gormus = 0 ;
		is_update = 0 ;
	}
	if (is_update eq 1 and account.sub_account eq 1) is_update = 1;
	
</cfscript>
<cfif islem_gormus>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='33832.Hesap Numarası İşlem görmüş veya Tanım Olarak Seçilmiş Alt Hesap Eklenemez'>");
		window.close();
	</script>
	<cfabort>
</cfif>

<cf_catalystHeader>
	<div class="col col-12 col-xs-12">
		<cf_box>
		<cfform name="add_sub_account" action="" method="post">
			<input type="Hidden" name="account_id" id="account_id" value="<cfoutput>#attributes.account_id#</cfoutput>">
			<input type="Hidden" name="account_code" id="account_code" value="<cfoutput>#account.account_code#</cfoutput>">
			<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
				<input type="Hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
				<input type="Hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.code") and len(attributes.code)>
				<input type="Hidden" name="code" id="code" value="<cfoutput>#attributes.code#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.db_source") and len(attributes.db_source)>
				<input type="Hidden" name="db_source" id="db_source" value="<cfoutput>#attributes.db_source#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.period_year") and len(attributes.period_year)>
				<input type="Hidden" name="period_year" id="period_year" value="<cfoutput>#attributes.period_year#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.nereden_geldi") and len(attributes.nereden_geldi)>
				<input type="Hidden" name="nereden_geldi" id="nereden_geldi" value="<cfoutput>#attributes.nereden_geldi#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.search_account_code") and len(attributes.search_account_code)>
				<input type="Hidden" name="search_account_code" id="search_account_code" value="<cfoutput>#attributes.search_account_code#</cfoutput>">
			</cfif>
			<cf_box_elements>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-account_code">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32597.Üst Hesap'></label>
						<div class="col col-8 col-xs-12">
							<cfoutput>#account.account_code# : #account.account_name#</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-sub_account_code">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32598.Alt Hesap Kodu'></label>
						<div class="col col-8 col-xs-12">
							<cfoutput>#account.account_code#</cfoutput>.
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='32394.Alt Hesap Kodu Girmelisiniz !'></cfsavecontent>
							<cfinput type="text" name="sub_account_code" size="30" value="" maxlength="50" required="Yes" message="#message#">
						</div>
					</div>
					<div class="form-group" id="item-sub_account_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32599.Alt Hesap Adı'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id='32395.Alt Hesap Adı Girmelisiniz !'></cfsavecontent>
							<cfinput type="text" name="sub_account_name" size="50" required="Yes" message="#message2#">
						</div>
					</div>
					<cfif session.ep.our_company_info.is_ifrs eq 1>
					<div class="form-group" id="item-ifrs_code">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58130.UFRS Kod'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="ifrs_code" size="30" value="" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-ifrs_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58308.UFRS"> <cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="ifrs_name" size="50">
						</div>
					</div>
					<div class="form-group" id="item-account_code2">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="account_code2" size="30" value="" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-account_name2">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="account_name2" size="50">
						</div>
					</div>
					</cfif>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57461.Kaydet'></cfsavecontent>
					<cf_workcube_buttons is_upd='0' insert_info='#message#' add_function='kontrol()'>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	var temp_str = document.add_sub_account.sub_account_code.value;
	if ((temp_str.indexOf(',') >= 0) || (temp_str.indexOf('.') >= 0))
	{
		alert("<cf_get_lang dictionary_id ='33809.Girdiğiniz Hesap Kodu Geçerli Değil '>!");
		return false;			
	}
	if (trim(document.add_sub_account.sub_account_name.value)=='')
	{
		alert("<cf_get_lang dictionary_id ='32395.Alt Hesap Adı Girmelisiniz'>!");
		return false;
	}
	if (trim(document.add_sub_account.sub_account_code.value)=='')
	{
		alert("<cf_get_lang dictionary_id ='32394.Alt Hesap Kodu Girmelisiniz'>!");
		return false;
	}
	return true;
}
</script>
