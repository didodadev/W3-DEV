<cfif not (get_module_user(22) or get_module_user(24)  or get_module_user(25) )>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57532.Yetkiniz Yok'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfset xfa.upd = "objects.upd_account">
<cfset xfa.del = "objects.del_account">
<cfinclude template="../query/get_account.cfm">
<cfscript>
	if (get_acc.recordcount)
	{
		islem_gormus = 1 ;
		is_update = 1 ;
	} else 
	{
		islem_gormus = 0;
		is_update = 0;
	}
	if (is_update eq 1 and account.sub_account eq 1) is_update = 1 ;
	if (account.sub_account eq 1) is_update = 1 ;
	url_string = "";
	if ( isdefined("attributes.field_id") and len(attributes.field_id) )
		url_string = "#url_string#&field_id=#field_id#";
	if ( isdefined("attributes.field_name") and len(attributes.field_name) )
		url_string = "#url_string#&field_name=#attributes.field_name#";
	if ( isdefined("attributes.code") and len(attributes.code) )
		url_string = "#url_string#&code=#attributes.code#";
	if ( isdefined("attributes.db_source") and len(attributes.db_source) )
		url_string = "#url_string#&db_source=#attributes.db_source#";
	if ( isdefined("attributes.period_year") and len(attributes.period_year) )
		url_string = "#url_string#&period_year=#attributes.period_year#";
	if ( isdefined("attributes.nereden_geldi") and len(attributes.nereden_geldi) )
		url_string = "#url_string#&nereden_geldi=#attributes.nereden_geldi#";
	if ( isdefined("attributes.search_account_code") and len(attributes.search_account_code) )
		url_string = "#url_string#&search_account_code=#attributes.search_account_code#";
</cfscript>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32640.Hesap Kodu Güncelle'></cfsavecontent>
<cf_box title="#message#">
	<cfform name="upd_account" action="#request.self#?fuseaction=#xfa.upd##url_string#" method="post">
	<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
	<input type="hidden" name="account_id" id="account_id" value="<cfoutput>#attributes.account_id#</cfoutput>">
	<input type="hidden" name="field_id" id="field_id" value="<cfif isdefined("field_id")><cfoutput>#attributes.field_id#</cfoutput></cfif>">
	<input type="hidden" name="sub_account" id="sub_account" value="<cfoutput>#account.sub_account#</cfoutput>">
	<input type="hidden" name="old_account" id="old_account" value="<cfoutput>#account.account_code#</cfoutput>">
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-account_code">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32633.Hesap Kodu'></label>
					<div class="col col-8 col-xs-12">
							<cfset str_account_code = "" >
						<cfset uzunluk = ListLen(account.account_code,".") >
						<cfif uzunluk gt 1>
						<cfloop from="1" to="#evaluate(uzunluk-1)#" index="k">
							<cfset str_account_code="#str_account_code#.#ListGetAt(account.account_code,k,".")#">
						</cfloop>
						</cfif>
							<input name="first_line" id="first_line" type="hidden" value="<cfoutput>#Mid(str_account_code,2,len(str_account_code))#</cfoutput>">
							<input name="birlestir" id="birlestir" type="hidden" value="<cfif len(str_account_code)>1<cfelse>0</cfif>">
							<cfsavecontent variable="message" ><cf_get_lang dictionary_id='32394.Hesap Kodu Girmelisiniz!'></cfsavecontent>
							<cfif is_update eq 0 >
							<cfoutput>#Mid(str_account_code,2,len(str_account_code))#<cfif len(str_account_code)>.</cfif></cfoutput>
							<input type="text" name="account_code" id="account_code" maxlength="10" value="<cfoutput>#ListLast(account.account_code,".")#</cfoutput>" required="Yes" message="<cfoutput>#message#</cfoutput>"  <cfif not listfind(account.account_code,".")  and account.account_code lt "799">readonly</cfif>><!--- <cfif account.sub_account eq 1>readonly</cfif> --->
						<cfelse>
						<cfoutput>#account.account_code#</cfoutput>
							<input type="hidden" name="account_code" id="account_code" value="<cfoutput>#ListLast(account.account_code,".")#</cfoutput>" required="Yes" message="<cfoutput>#message#</cfoutput>">
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-account_name">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32634.Hesap Adı'></label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message2"><cf_get_lang dictionary_id='32586.Hesap Adı Girmelisiniz !'></cfsavecontent>
							<cfinput type="text" name="account_name" value="#account.account_name#" required="yes" message="#message2#">
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="account">
			<cfif is_update>
				<cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' add_function='kontrol()'>
			<cfelseif len(account.record_emp) >
				<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=#xfa.del#&old_account=#account.account_code#&account_id=#attributes.account_id#' add_function='kontrol()'>							
			<cfelse>
				<cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' add_function='kontrol()'>							
			</cfif>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
	{
		var temp_str = document.upd_account.account_code.value;
		if ((temp_str.indexOf(',') >= 0) || (temp_str.indexOf('.') >= 0))
		{
			alert("<cf_get_lang dictionary_id ='33809.Girdiğiniz Hesap Kodu Geçerli Değil'> !");
			return false;			
		}
	}
</script>
