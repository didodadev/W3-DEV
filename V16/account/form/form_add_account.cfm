<cfscript>
	url_string = "";
	if(isdefined("attributes.field_id") and len(attributes.field_id))
		url_string = "#url_string#&field_id=#field_id#";
	if(isdefined("attributes.field_name") and len(attributes.field_name))
		url_string = "#url_string#&field_name=#attributes.field_name#";
	if(isdefined("attributes.code") and len(attributes.code))
		url_string = "#url_string#&code=#attributes.code#";
	if(isdefined("attributes.db_source") and len(attributes.db_source))
		url_string = "#url_string#&db_source=#attributes.db_source#";
	if(isdefined("attributes.period_year") and len(attributes.period_year))
		url_string = "#url_string#&period_year=#attributes.period_year#";
	if(isdefined("attributes.nereden_geldi") and len(attributes.nereden_geldi))
		url_string = "#url_string#&nereden_geldi=#attributes.nereden_geldi#";
	if(isdefined("attributes.search_account_code") and len(attributes.search_account_code))
		url_string = "#url_string#&account_code=#attributes.search_account_code#";
	if(isdefined('attributes.db_source'))
	{
		if(database_type is "MSSQL")
		{
			db_source = "#DSN#_#attributes.PERIOD_YEAR#_#attributes.db_source#";
			db_source3_alias = "#DSN#_#attributes.db_source#";
		}else if (database_type is "DB2")
		{
			db_source="#DSN#_#attributes.db_source#_#Right(Trim(attributes.PERIOD_YEAR),2)#";
			db_source3_alias="#DSN#_#attributes.db_source#_dbo";
		}
	}
	else
	{
		db_source = DSN2 ;
		db_source3_alias = DSN3_ALIAS;
	}
</cfscript> 
<cf_catalystHeader>
	<div class="col col-12 col-xs-12">
		<cf_box>
		<cfform name="add_account" action="#request.self#?fuseaction=account.add_account#url_string#" method="post">
			<cf_box_elements>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-account_code">
						<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id ='47299.Hesap Kodu'>*</label>
						<div class="col col-8 col-sm-6 col-xs-12">
							<cfif isdefined('attributes.acc_code')>
								<cfset t_value=attributes.acc_code>
							<cfelse>
								<cfset t_value="">
							</cfif>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='47351.Hesap Kodu Secmelisiniz'></cfsavecontent>
							<cfinput type="Text" name="account_code" value="#t_value#" required="Yes" message="#message#" validate="integer" maxlength="3" range="100,999">
						</div>
					</div>
					<div class="form-group" id="item-account_name">
						<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id ='55271.Hesap Adı'>*</label>
						<div class="col col-8 col-sm-6 col-xs-12">
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55271.Hesap Adı'></cfsavecontent>
							<cfinput type="Text" name="account_name" value="" required="yes" message="#message1#">
						</div>
					</div>
					<cfif session.ep.our_company_info.is_ifrs eq 1>
					<div class="form-group" id="item-ifrs_code">
						<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='58130.UFRS Kod'></label>
						<div class="col col-8 col-sm-6 col-xs-12">
							<cfinput type="Text" name="ifrs_code" value="">
						</div>
					</div>
					<div class="form-group" id="item-ifrs_name">
						<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="58308.UFRS"> <cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-sm-6 col-xs-12">
							<cfinput type="Text" name="ifrs_name" value="">
						</div>
					</div>
					<div class="form-group" id="item-account_code2">
						<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
						<div class="col col-8 col-sm-6 col-xs-12">
							<cfinput type="Text" name="account_code2" value="">
						</div>
					</div>
					<div class="form-group" id="item-account_name2">
						<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-sm-6 col-xs-12">
							<cfinput type="Text" name="account_name2" value="" message="#message1#">
						</div>
					</div>
					</cfif>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12">
					<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		var temp_str = document.add_account.account_code.value;
		if ((temp_str.indexOf(',') >= 0) || (temp_str.indexOf('.') >= 0))
		{
			alert("<cf_get_lang dictionary_id ='47510.Girdiğiniz Hesap Kodu Geçerli Değil'> !");
			return false;			
		}
		if (trim(document.add_account.account_name.value)=='')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id ='55271.Hesap Adı'>");
			return false;
		}
	}
</script>
