<cfset xfa.upd = "account.upd_account">
<cfset xfa.del = "account.del_account">

<!--- 
	modified: 02042004  by arzu bt
	1) Sayfada guncelleme:eger 101 alt hesabi yok sa guncelleme yapilamaz.
	2) Eger Alt heasbi varsa sadece hesap ad bilgisi guncellenir kod guncellenemez.
 --->
<!--- Bu sorgularin sirasi degismesin! --->
<cfinclude template="../query/get_account.cfm">
<cfinclude template="../query/get_account_hareket.cfm">
<!--- // Bu sorgularin sirasi degismesin! --->
<cfscript>
	if (get_acc.recordcount)
	{
		islem_gormus = 1;
		is_update = 1;
	} else {
		islem_gormus = 0 ;
		is_update = 0;
	}
	if ((is_update eq 0) and (account.sub_account eq 1)) is_update = 1;
</cfscript>
<cf_catalystHeader>
	<div class="col col-12 col-xs-12">
		<cf_box>
			<cfform name="upd_account" action="#request.self#?fuseaction=#xfa.upd#" method="post">
				<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
				<input type="hidden" name="account_id"  id="account_id" value="<cfoutput>#attributes.account_id#</cfoutput>">
				<input type="hidden" name="field_id" id="field_id" value="<cfif isdefined("field_id")><cfoutput>#attributes.field_id#</cfoutput></cfif>">
				<input type="hidden" name="sub_account" id="sub_account" value="<cfoutput>#account.sub_account#</cfoutput>">
				<input type="hidden" name="old_account" id="old_account" value="<cfoutput>#account.account_code#</cfoutput>">
				<cf_box_elements>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-account_code">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='47299.Hesap Kodu'>*</label>
							<div class="col col-8 col-xs-12">
								<cfset str_account_code = "" >
								<cfset uzunluk = ListLen(account.account_code,".") >
								<cfif uzunluk gt 1>
									<cfloop from="1" to="#evaluate(uzunluk-1)#" index="k">
										<cfset str_account_code="#str_account_code#.#ListGetAt(account.account_code,k,".")#">
									</cfloop>
								</cfif>
								<input name="first_line" id="first_line" type="hidden" value="<cfoutput>#Mid(str_account_code,2,len(str_account_code))#</cfoutput>">
								<input name="birlestir" id="birlestir"  type="hidden" value="<cfif len(str_account_code)>1<cfelse>0</cfif>">
								<cfsavecontent variable="message" ><cf_get_lang dictionary_id='47351.Hesap Kodu Girmelisiniz'></cfsavecontent>
								<!--- <cfif is_update eq 0>
									<cfoutput>#Mid(str_account_code,2,len(str_account_code))#<cfif len(str_account_code)>.</cfif></cfoutput>
									<input type="Text" name="account_code" maxlength="10" value="<cfoutput>#ListLast(account.account_code,".")#</cfoutput>" required="Yes" message="<cfoutput>#message#</cfoutput>" <cfif not listfind(account.account_code,".")  and account.account_code lt "799">readonly</cfif>><!--- <cfif account.sub_account eq 1>readonly</cfif> --->
								<cfelse> --->
									<cfoutput>#account.account_code#</cfoutput>
									<input type="hidden" name="account_code" id="account_code" value="<cfoutput>#ListLast(account.account_code,".")#</cfoutput>" required="Yes" message="<cfoutput>#message#</cfoutput>" >								
								<!--- </cfif> --->
							</div>
						</div>
						<div class="form-group" id="item-account_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='55271.Hesap Adı'>*</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='55271.Hesap Adı'></cfsavecontent>
								<cfinput type="Text" name="account_name" value="#account.account_name#" required="yes" message="#message1#">
							</div>
						</div>
						<cfif session.ep.our_company_info.is_ifrs eq 1>
						<div class="form-group" id="item-ifrs_code">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58130.UFRS Kod'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ifrs_code" id="ifrs_code" value="<cfif len(account.ifrs_code)><cfoutput>#account.ifrs_code#</cfoutput></cfif>">
							</div>
						</div>
						<div class="form-group" id="item-ifrs_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58308.UFRS"> <cf_get_lang dictionary_id='36199.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ifrs_name" id="ifrs_name" value="<cfif len(account.ifrs_name)><cfoutput>#account.ifrs_name#</cfoutput></cfif>">
							</div>
						</div>
						<div class="form-group" id="item-account_code2">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="account_code2" id="account_code2" value="<cfif len(account.account_code2)><cfoutput>#account.account_code2#</cfoutput></cfif>">
							</div>
						</div>
						<div class="form-group" id="item-account_name2">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'><cf_get_lang dictionary_id='36199.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="account_name2" id="account_name2" value="<cfif len(account.account_name2)><cfoutput>#account.account_name2#</cfoutput></cfif>">
							</div>
						</div>
						</cfif>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-6">
						<cf_record_info query_name="account">
					</div>
					<div class="col col-6">
						<cfif (islem_gormus eq 0) and (account.sub_account eq 0) and account_acc_code.recordcount eq 0>
							<cf_workcube_buttons type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=account.list_account_plan&event=del&old_account=#account.account_code#&account_id=#attributes.account_id#' add_function='kontrol()'>
						<cfelse>
							<cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' add_function='kontrol()'>
						</cfif>
					</div>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
<script type="text/javascript">
function kontrol()
	{
		
		var temp_str = document.upd_account.account_code.value;
		if ((temp_str.indexOf(',') >= 0) || (temp_str.indexOf('.') >= 0))
		{
			alert("<cf_get_lang dictionary_id ='47510.Girdiğiniz Hesap Kodu Geçerli Değil'> !");
			return false;			
		}
		if (trim(document.upd_account.account_name.value)=='')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id ='55271.Hesap Adı'>!");
			return false;
		}
	}
</script>
