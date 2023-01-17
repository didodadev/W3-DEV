<cf_xml_page_edit fuseact="member.popup_form_add_credit_cart" is_multi_page="1">
<cfquery name="GET_BANK_TYPE" datasource="#DSN#">
	SELECT BANK_NAME,BANK_ID FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#"><!--- 9,10 üye --->
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE =<cfif isDefined("attributes.comp_id")> 9<cfelse>10</cfif> ORDER BY SPECIAL_DEFINITION
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="30362.Kredi Kartı Ekle"></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" settings="1">
<cfform method="post" name="add_credit_card" action="#request.self#?fuseaction=member.emptypopup_add_credit_card">
    <cf_box_elements>
        <cfoutput> 
            <input type="hidden" value="#attributes.xml_same_credit_card_control#" name="xml_same_credit_card_control" id="xml_same_credit_card_control">
            <input type="hidden" name="draggable" id="draggable" value="<cfif isdefined('attributes.draggable')>#attributes.draggable#</cfif>">
            <input type="hidden" name="xml_deactivate_other_credit_cards" id="xml_deactivate_other_credit_cards" value="#attributes.xml_deactivate_other_credit_cards#">
            <cfif isDefined("attributes.comp_id")>
                <input type="hidden" value="#attributes.comp_id#" name="comp_id" id="comp_id">
            <cfelse>
                <input type="hidden" value="#attributes.cons_id#" name="cons_id" id="cons_id">
            </cfif>
        </cfoutput> 
        <div class="col col-6 col-md-6 col-sm-12" type="column" index="1" sort="true">
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                <div class="col col-8 col-sm-12">
                    <input type="checkbox" name="default_card" id="default_card" value="1" checked>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30363.Kart Tipi'></label>
                <div class="col col-8 col-sm-12">
                    <cf_wrk_combo
                    name="card_type"
                    query_name="GET_CREDITCARD"
                    option_name="cardcat"
                    option_value="cardcat_id"
                    width="220">
                </div>
            </div>

            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57521.Banka'><cfif add_bank_xml eq 1>*</cfif></label>
                <div class="col col-8 col-sm-12">
                    <select name="bank_type" id="bank_type" style="width:220px;">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                        <cfoutput query="get_bank_type">
                            <option value="#bank_id#">#bank_name#</option>
                        </cfoutput>
                    </select> 
                </div>
            </div>

            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30364.Kart Numarası'></label>
                <div class="col col-8 col-sm-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30376.Kredi Kart No !'></cfsavecontent>
                    <cfinput type="Text" name="card_no" validate="integer" required="Yes" message="#message#" maxlength="16" onKeyUp="isNumber(this);" style="width:220px;">
                </div>
            </div>

            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30541.Kart Hamili'></label>
                <div class="col col-8 col-sm-12">
                    <input type="Text" name="card_owner" id="card_owner" value="" style="width:220px;" maxlength="50">
                </div>
            </div>

            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30365.Son Kullanma Tarihi'></label>
                <div class="col col-4 col-sm-12">
                    <select name="month" id="month">
                        <cfloop from="1" to="12" index="k">
                            <cfoutput>
                                <option value="#k#">#NumberFormat(k,00)#</option>
                            </cfoutput> 
                        </cfloop>
                    </select>
                </div>
                <div class="col col-4 col-sm-12">
                    <select name="year" id="year">
                        <cfloop from="#dateFormat(now(),'yyyy')#" to="#dateFormat(now(),'yyyy')+10#" index="i">
                            <cfoutput>
                                <option value="#i#">#i#</option>
                            </cfoutput> 
                        </cfloop>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30542.CVS No'></label>
                <div class="col col-8 col-sm-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30542.CVv No!'></cfsavecontent>
                    <cfinput type="Text" name="CVS" validate="integer" message="#message#" maxlength="3" required="yes" onKeyUp="isNumber(this);" style="width:220px;">
                </div>
            </div>

            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30721.Hesap Kesim Günü'></label>
                <div class="col col-8 col-sm-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30721.Hesap Kesim Günü'></cfsavecontent>
                    <cfinput type="text" name="acc_off_date" validate="integer" message="#message#" maxlength="2" onKeyUp="isNumber(this);" style="width:70px;">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='30701.Dönüş Kodu'></label>
                <div class="col col-8 col-sm-12">
                   <input type="text" name="resp_code" id="resp_code" value="" message="#message#" maxlength="10">
                </div>
            </div>
            <cfif xml_special_def neq 0>
                <div class="form-group">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54971.Özel Tanım'></label>
                    <div class="col col-8 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='54971.Özel Tanım'></cfsavecontent>
                        <select name="special_def_id" id="special_def_id" style="width:220px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="GET_SPECIAL_DEFINITION">
                                <option value="#SPECIAL_DEFINITION_ID#">#SPECIAL_DEFINITION#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </cfif>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("cc_controls() && loadPopupBox('add_credit_card' , #attributes.modal_id#)"),DE(""))#">
    </cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	function cc_controls()
	{
		if(document.add_credit_card.card_type.value == 0)
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30514.Kredi Kartı Tipi !'>");
			return false;
		}
		<cfif add_bank_xml>
			if(document.add_credit_card.bank_type.value == 0)
			{
				alert("<cf_get_lang dictionary_id='48749.Banka Seçmelisiniz'>!");
				return false;
			}
		</cfif>
		<cfif xml_special_def eq 2>
			if(document.add_credit_card.special_def_id.value == '')
			{
				alert("<cf_get_lang dictionary_id='59891.Özel Tanım Seçmelisiniz'>!");
				return false;
			}
		</cfif>
		d = new Date();
		if((document.add_credit_card.year.value < d.getYear() && document.add_credit_card.month.selectedIndex < d.getMonth()) || (document.add_credit_card.year.value == d.getYear() && document.add_credit_card.month.selectedIndex < d.getMonth()))
		{
			alert("<cf_get_lang dictionary_id ='30598.Geçerlilik Tarihi Bu Dönemden Küçük Olamaz'>");
			return false;
		}
		return true;
	}
</script>
