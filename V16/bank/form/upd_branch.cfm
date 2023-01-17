<cfinclude template="../query/get_branch_detail.cfm">
<cfquery name="GET_BANK_TYPES" datasource="#DSN#">
	SELECT 
		BANK_ID,
		BANK_NAME
	FROM 
		SETUP_BANK_TYPES 
	WHERE 
		BANK_ID IS NOT NULL		
</cfquery>
<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform method="post" name="upd_branch" id="upd_branch" action="#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('bank'))#.upd_bank_branch">
			<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
			<cfoutput query="get_branch_detail">
				<cf_box_elements>
					<div class="col col-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-bank_name">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',34)#​</cfoutput>*</label>
							<div class="col col-8 col-xs-12">
								<select name="bank_name" id="bank_name" style="width:175px;" disabled>
									<cfloop query="get_bank_types">
										<option value="#bank_id#;#bank_name#" <cfif bank_id eq get_branch_detail.bank_id>selected</cfif>>#bank_name#</option>
									</cfloop>
								</select>
							</div> 
						</div>
						<div class="form-group" id="item-bank_branch_name">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1735)#​</cfoutput>*</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='93.Şube Adı Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="bank_branch_name" id="bank_branch_name" required="yes" message="#message#" value="#bank_branch_name#" style="width:175px;">
							</div> 
						</div>
						<div class="form-group" id="item-branch_code">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1593)#​</cfoutput></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="branch_code" id="branch_code" value="#branch_code#" onKeyUp="isNumber(this);" maxlength="5" style="width:175px;">
							</div> 
						</div>
						<div class="form-group" id="item-swift_code">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1733)#​</cfoutput></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="swift_code" id="swift_code" value="#swift_code#" maxlength="50" style="width:175px;">
							</div> 
						</div>
						<div class="form-group" id="item-contact_person">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',166)#​</cfoutput></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="contact_person" id="contact_person" value="#contact_person#" style="width:175px;">
							</div> 
						</div>
						<div class="form-group" id="item-bank_branch_tel">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',87)#​</cfoutput></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='92.Telefon Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="bank_branch_tel" id="bank_branch_tel" value="#bank_branch_tel#" validate="integer" message="#message#" style="width:175px;">
							</div> 
						</div>
						<div class="form-group" id="item-bank_branch_address">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1311)#​</cfoutput></label>
							<div class="col col-8 col-xs-12">
								<textarea name="bank_branch_address" id="bank_branch_address" style="width:175px; height:40px;">#bank_branch_address#</textarea>
							</div> 
						</div>
						<div class="form-group" id="item-bank_branch_postcode">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',60)#​</cfoutput></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="bank_branch_postcode" id="bank_branch_postcode" value="#bank_branch_postcode#" style="width:175px;">
							</div> 
						</div>
						<div class="form-group" id="item-bank_branch_city">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',559)#​</cfoutput>*</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='80.Şehir Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="bank_branch_city" id="bank_branch_city" required="yes" message="#message#" value="#bank_branch_city#" style="width:175px;">
							</div> 
						</div>
						<div class="form-group" id="item-bank_branch_country">
							<label class="col col-4 col-xs-12"><cfoutput>#getLang('main',807)#​</cfoutput></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="bank_branch_country" id="bank_branch_country" value="#bank_branch_country#" style="width:175px;">
							</div> 
						</div>
						<cfif isdefined("get_branch_detail.bank_id")>
							<cfquery name="get_company_info" datasource="#dsn#">
								SELECT
									C.FULLNAME,
									C.COMPANY_ID
								FROM
									COMPANY C,
									SETUP_BANK_TYPES SB
								WHERE
									C.COMPANY_ID = SB.COMPANY_ID AND
									SB.BANK_ID = #get_branch_detail.bank_id#
							</cfquery>
							<cfif get_company_info.recordcount>
								<cfquery name="GET_COMP_BRANCH" datasource="#DSN#">
									SELECT COMPBRANCH_ID,COMPBRANCH__NAME FROM COMPANY_BRANCH WHERE COMPANY_ID = #get_company_info.company_id#
								</cfquery>
								<div class="form-group" id="item-fullname">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='173.Kurumsal Üye'></label>
									<div class="col col-8 col-xs-12">
										<cfoutput>#get_company_info.fullname#</cfoutput>
									</div>
								</div>
								<div class="form-group" id="item-comp_branch">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='173.Kurumsal Üye'> <cf_get_lang_main no='1529.Şubesi'></label>
									<div class="col col-8 col-xs-12">
										<select name="comp_branch" id="comp_branch" style="width:175px;">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfloop query="get_comp_branch">
												<option value="#get_comp_branch.compbranch_id#" <cfif get_comp_branch.compbranch_id eq get_branch_detail.compbranch_id> selected</cfif>>#get_comp_branch.compbranch__name#</option>
											</cfloop>
										</select>
									</div>
								</div>
							</cfif>
						</cfif>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12"  type="column" index="2" sort="true">
						<cfif isdefined("get_company_info") and get_company_info.recordcount>
							<cfset attributes.cpid = get_company_info.company_id>
							<cfset is_from_finance = 1>
								<cf_flat_list>
									<tr>
										<td class="txtbold"><br/><a href="javascript:gizle_goster(genel);">&raquo;<cf_get_lang no='431.Kurumsal Üye Detay'></a></td>
									</tr>
								</cf_flat_list>
								<cf_flat_list  id="genel">
									<tr class="color-row">
										<td width="3" valign="top"><a href="javascript://" onclick="gizle_goster(member1);"><cf_get_lang_main no="359.Detay"></a></td>
										<td valign="top"><div id="member1" style="display:none"><cfinclude template="../../myhome/display/my_company_detail.cfm"></td>
									</tr>
									<tr class="color-row">
										<td valign="top"><a href="javascript://" onclick="gizle_goster(member2);"><cf_get_lang_main no="1473.Partner"></a></td>
										<td valign="top"><div id="member2" style="display:none"><cfinclude template="../../myhome/display/my_company_partner_detail.cfm"></td>
									</tr>
									<tr class="color-row">
										<td valign="top"><a href="javascript://" onclick="gizle_goster(member3);"><cf_get_lang_main no="1311.Adres"></a></td>
										<td valign="top"><div id="member3" style="display:none"><cfinclude template="../../myhome/display/my_company_address_detail.cfm"></div></td>
									</tr>
								</cf_flat_list>
						</cfif>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-6 col-xs-6">
						<cf_record_info query_name="get_branch_detail">
					</div>
					<div class="col col-6 col-xs-6">
						<cfsavecontent variable="message"><cf_get_lang_main no ='121.Silmek Istediginizden Emin misiniz'></cfsavecontent>
						<cf_workcube_buttons type_format="1"
							is_upd='1'
							delete_page_url="#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('bank'))#.del_bank_branch&id=#attributes.id#&branch=#get_branch_detail.bank_branch_name#"
							delete_alert='#message#' add_function = 'kontrol()'>
					</div>
				</cf_box_footer> 
			</cfoutput>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		document.getElementById('bank_name').disabled = false;
		a = document.getElementById('bank_name').options.selectedIndex;
		if (document.getElementById('bank_name').options[a].value == '')
		{	
			alert("<cf_get_lang no ='88.Banka Seçiniz'>");
			return false;
		}
		
		if (document.getElementById('bank_branch_name').value == '')
		{	
			alert("<cf_get_lang no='93.Şube Adı Girmelisiniz !'>");
			return false;
		}
		
		if (document.getElementById('bank_branch_city').value == '')
		{	
			alert("<cf_get_lang no='80.Şehir Girmelisiniz'>");
			return false;
		}
		return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
