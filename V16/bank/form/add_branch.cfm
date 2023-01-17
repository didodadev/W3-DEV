<!--- <cfinclude template="../query/get_control.cfm"> --->
<cfquery name="get_bank_types" datasource="#dsn#">
	SELECT BANK_ID,	BANK_NAME FROM SETUP_BANK_TYPES WHERE BANK_ID IS NOT NULL ORDER BY BANK_NAME
</cfquery>
<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cf_catalystHeader> <!--- Sube Ekle --->
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="add_branch" id="add_branch" method="post" action="#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('bank'))#.add_bank_branch">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-bank_name">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',34)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <select name="bank_name" id="bank_name" style="width:175px;" <cfif isdefined("attributes.bank_id")>disabled</cfif>>
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_bank_types">
                                    <option value="#bank_id#;#bank_name#" <cfif isdefined("attributes.bank_id") and attributes.bank_id eq bank_id>selected</cfif>>#bank_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_branch_name">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1735)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="bank_branch_name" id="bank_branch_name" value="" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_code">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1593)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="branch_code" id="branch_code" value="" onKeyUp="isNumber(this);" maxlength="5" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-swift_code">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1733)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="swift_code" id="swift_code" value="" maxlength="50" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-contact_person">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',166)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="contact_person" id="contact_person" value="" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_branch_tel">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',87)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang no='92.Telefon Girmelisiniz !'></cfsavecontent>
                            <cfinput type="text" name="bank_branch_tel" id="bank_branch_tel" value="" validate="integer" message="#message#" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_branch_address">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1311)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="bank_branch_address" id="bank_branch_address" style="width:175px; height:60px;;"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_branch_postcode">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',60)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="bank_branch_postcode" id="bank_branch_postcode" value="" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_branch_city">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',559)#</cfoutput>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="bank_branch_city" id="bank_branch_city" value="" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_branch_country">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',807)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="bank_branch_country" id="bank_branch_country" value="" style="width:175px;">
                        </div>
                    </div>
                    <cfif isdefined("attributes.bank_id")>
                        <cfquery name="get_company_info" datasource="#dsn#">
                            SELECT
                                C.FULLNAME,
                                C.COMPANY_ID
                            FROM
                                COMPANY C,
                                SETUP_BANK_TYPES SB
                            WHERE
                                C.COMPANY_ID = SB.COMPANY_ID
                                AND SB.BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_id#">
                        </cfquery>
                        <cfif get_company_info.recordcount>
                            <cfquery name="GET_COMP_BRANCH" datasource="#DSN#">
                                SELECT COMPBRANCH_ID,COMPBRANCH__NAME FROM COMPANY_BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_info.company_id#">
                            </cfquery>
                            <div class="form-group" id="item-fullname">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='173.Kurumsal Üye'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfoutput>#get_company_info.fullname#</cfoutput>
                                </div>
                            </div>
                            <div class="form-group" id="item-comp_branch">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='173.Kurumsal Üye'> <cf_get_lang_main no='1637.Şubeler'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="comp_branch" id="comp_branch" style="width:175px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_comp_branch">
                                            <option value="#get_comp_branch.compbranch_id#">#get_comp_branch.compbranch__name#</option>
                                        </cfoutput>
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
                        <cf_flat_list  id="genel" >
                            <tr class="color-row">
                                <td width="3" valign="top"><a href="javascript://" onclick="gizle_goster(member1);"><cf_get_lang_main no="359.Detay"></a></td>
                                <td valign="top"><div id="member1" style="display:none;"><cfinclude template="../../myhome/display/my_company_detail.cfm"></div></td>
                            </tr>
                            <tr class="color-row">
                                <td valign="top"><a href="javascript://" onclick="gizle_goster(member2);"><cf_get_lang_main no="1473.Partner"></a></td>
                                <td valign="top"><div id="member2" style="display:none;"><cfinclude template="../../myhome/display/my_company_partner_detail.cfm"></div></td>
                            </tr>
                            <tr class="color-row">
                                <td valign="top"><a href="javascript://" onclick="gizle_goster(member3);"><cf_get_lang_main no="1311.Adres"></a></td>
                                <td valign="top"><div id="member3" style="display:none;"><cfinclude template="../../myhome/display/my_company_address_detail.cfm"></div></td>
                            </tr>
                        </cf_flat_list>
                    </cfif>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(!$("#bank_branch_name").val().length)
		{
			alert("<cfoutput>#getLang('bank',93)#</cfoutput>");
			return false
		}
		if(!$("#bank_branch_city").val().length)
		{
			alert("<cfoutput>#getLang('bank',80)#</cfoutput>");
			return false
		}
		document.getElementById('bank_name').disabled = false;
		a = document.getElementById('bank_name').options.selectedIndex;
		if (document.getElementById('bank_name').options[a].value == '')
		{	
			alert("<cfoutput>#getLang('bank',88)#</cfoutput>");
			return false;
		}
		
		if (document.getElementById('bank_branch_name').value == '')
		{	
			alert("<cfoutput>#getLang('bank',93)#</cfoutput>");
			return false;
		}
		
		if (document.getElementById('bank_branch_city').value == '')
		{	
			alert("<cfoutput>#getLang('bank',80)#</cfoutput>");
			return false;
		}
		return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
