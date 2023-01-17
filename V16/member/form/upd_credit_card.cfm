<cf_xml_page_edit fuseact="member.popup_form_add_credit_cart" is_multi_page="1">
<!--- 
	FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
	Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
--->
<cfscript>
	getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
	getCCNOKey.dsn = dsn;
	getCCNOKey1 = getCCNOKey.getCCNOKey1();
	getCCNOKey2 = getCCNOKey.getCCNOKey2();
</cfscript>
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_credit_card.cfm">
<cfquery name="get_bank_type" datasource="#dsn#">
	SELECT BANK_NAME,BANK_ID FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#"><!--- 9,10 üye --->
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE =<cfif isDefined("attributes.comp_id")> 9<cfelse>10</cfif> ORDER BY SPECIAL_DEFINITION
</cfquery>
<cfsavecontent variable="right"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=member.popup_credit_card_history&id=#attributes.ccid#</cfoutput>&comp_id=<cfif isDefined("attributes.comp_id")>1<cfelse>0</cfif>','','ui-draggable-box-large');" class="font-red-pink"><i class="fa fa-history" title="<cf_get_lang dictionary_id='57473.Tarihçe'>"></i></a></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="58199.Kredi Kartı"></cfsavecontent>
<cf_box title="#message#" right_images="#right#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" settings="1">
<cfform method="post" name="upd_credit_card" action="#request.self#?fuseaction=member.emptypopup_upd_credit_card">
	<cfoutput>
        <input type="hidden" name="xml_cc_relation_control" id="xml_cc_relation_control" value="#attributes.xml_cc_relation_control#">
        <input type="hidden" name="draggable" id="draggable" value="<cfif isdefined('attributes.draggable')>#attributes.draggable#</cfif>">
        <input type="hidden" name="xml_same_credit_card_control" id="xml_same_credit_card_control" value="#attributes.xml_same_credit_card_control#">
        <input type="hidden" name="xml_deactivate_other_credit_cards" id="xml_deactivate_other_credit_cards" value="#attributes.xml_deactivate_other_credit_cards#">
        <cfif isDefined("attributes.comp_id")>
            <input type="hidden" name="comp_id" id="comp_id" value="#attributes.comp_id#">
        <cfelse>
            <input type="hidden" name="cons_id" id="cons_id" value="#attributes.cons_id#">
        </cfif>
        <input type="hidden" name="ccid" id="ccid" value="#attributes.ccid#">
    </cfoutput> 
    <cf_box_elements>
        <div class="col col-6 col-md-6 col-sm-12" type="column" index="1" sort="true">
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                <div class="col col-8 col-sm-12">
                    <input type="checkbox" name="default_card" id="default_card" <cfif GET_CREDIT_CARD.IS_DEFAULT eq 1>checked</cfif> onClick="c_credit_card_status();">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30363.Kart Tipi'></label>
                <div class="col col-8 col-sm-12">
                    <cf_wrk_combo
                    name="card_type"
                    query_name="GET_CREDITCARD"
                    option_name="CARDCAT"
                    option_value="CARDCAT_ID"
                    width="220"
                    value="#GET_CREDIT_CARD.CARD_TYPE#">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57521.Banka'><cfif add_bank_xml eq 1>*</cfif></label>
                <div class="col col-8 col-sm-12">
                    <select name="bank_type" id="bank_type">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                        <cfoutput query="get_bank_type">
                            <option value="#BANK_ID#" <cfif get_bank_type.BANK_ID eq GET_CREDIT_CARD.BANK_TYPE>selected</cfif>>#BANK_NAME#</option>
                        </cfoutput>
                    </select> 
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30364.Kart Numarası'></label>
                <div class="col col-8 col-sm-12">
                    <cfset key_type = '#GET_CREDIT_CARD.MEMBER_ID#'>
                    <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                        <!--- anahtarlar decode ediliyor --->
                        <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                        <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                        <!--- kart no decode ediliyor --->
                        <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:GET_CREDIT_CARD.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                        <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
                    <cfelse>
                        <cfset content = '#mid(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(GET_CREDIT_CARD.CARD_NO,key_type,"CFMX_COMPAT","Hex")))#'>
                    </cfif>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30376.Kredi Kart No !'></cfsavecontent>
                    <cfinput type="Text" validate="creditcard" name="card_no" value="#content#" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="16">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30541.Kart Hamili'></label>
                <div class="col col-8 col-sm-12">
                    <input type="text" name="card_owner" id="card_owner" maxlength="50" value="<cfoutput>#GET_CREDIT_CARD.CARD_OWNER#</cfoutput>" >
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30365.Son Kullanma Tarihi'></label>
                <div class="col col-4 col-sm-12">
                    <select name="month" id="month">
                        <cfloop from="1" to="12" index="k">
                            <cfoutput>
                                <option value="#k#"<cfif GET_CREDIT_CARD.EX_MONTH eq k> selected </cfif>>#NumberFormat(k,00)#</option>
                            </cfoutput> 
                        </cfloop>
                    </select>
                </div>
                <div class="col col-4 col-sm-12">
                    <select name="year" id="year">
                        <cfloop from="#dateFormat(now(),'yyyy')-1#" to="#dateFormat(now(),'yyyy')+10#" index="i">
                            <cfoutput>
                            <option value="#i#" <cfif GET_CREDIT_CARD.EX_YEAR eq i> selected </cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30542.CVS No'></label>
                <div class="col col-8 col-sm-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30542.CVv No!'></cfsavecontent>
                    <cfif len(GET_CREDIT_CARD.CVS)>
                        <cfinput type="text" name="CVS" validate="integer" value="#Left(GET_CREDIT_CARD.CVS, 1)#*#Right(GET_CREDIT_CARD.CVS, 1)#" message="#message#" style="width:220px;" maxlength="3" onKeyUp="isNumber(this)" required="yes">
                    <cfelse>
                        <cfinput type="text" name="CVS" validate="integer" value="" message="#message#" style="width:220px;" maxlength="3" required="yes">
                    </cfif>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30721.Hesap Kesim Günü'></label>
                <div class="col col-8 col-sm-12">
                    <cfif len(GET_CREDIT_CARD.ACC_OFF_DAY)>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="30476.Hesap Kesim Günü Girmelisiniz"></cfsavecontent>
                        <cfinput type="text" name="acc_off_date" value="#GET_CREDIT_CARD.ACC_OFF_DAY#" validate="integer" onKeyUp="isNumber(this)" message="#message#" maxlength="2" style="width:70px;">
                    <cfelse>
                        <cfinput type="text" name="acc_off_date" validate="integer" message="#message#" style="width:70px;">
                    </cfif>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='30701.Dönüş Kodu'></label>
                <div class="col col-8 col-sm-12">
                   <input type="text" name="resp_code" id="resp_code" value="<cfoutput>#GET_CREDIT_CARD.RESP_CODE#</cfoutput>" message="#message#" maxlength="10">
                </div>
            </div>
            <cfif xml_special_def neq 0>
                <div class="form-group">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54971.Özel Tanım'></label>
                    <div class="col col-8 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id="38125.Özel Tanım"></cfsavecontent>
                        <select name="special_def_id" id="special_def_id" style="width:220px;">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <cfoutput query="GET_SPECIAL_DEFINITION">
                                <option value="#SPECIAL_DEFINITION_ID#" <cfif isdefined("attributes.special_def_id") and attributes.special_def_id eq SPECIAL_DEFINITION_ID>selected</cfif>>#SPECIAL_DEFINITION#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </cfif>
        </div>
    </cf_box_elements>
<cf_box_footer>
    <cf_record_info query_name="get_credit_card" is_consumer="1">
    <cfif isDefined("attributes.comp_id")>
        <cf_workcube_buttons is_upd='1' add_function="#iif(isdefined("attributes.draggable"),DE("cc_controls() && loadPopupBox('upd_credit_card' , #attributes.modal_id#)"),DE(""))#" del_function='deleteControl()'>
    <cfelse>
        <cf_workcube_buttons is_upd='1' add_function="#iif(isdefined("attributes.draggable"),DE("cc_controls() && loadPopupBox('upd_credit_card' , #attributes.modal_id#)"),DE(""))#" del_function='deleteControl()'>
    </cfif>
</cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	function deleteControl(){
        <cfif isdefined("attributes.comp_id")>
		document.upd_credit_card.action = '<cfoutput>#request.self#?fuseaction=member.emptypopup_del_credit_card&ccid=#attributes.ccid#&comp_id=comp_id</cfoutput>';
    <cfelse>
        document.upd_credit_card.action = '<cfoutput>#request.self#?fuseaction=member.emptypopup_del_credit_card&ccid=#attributes.ccid#</cfoutput>';
    </cfif>
    <cfif isDefined('attributes.draggable')>
		loadPopupBox('upd_credit_card',<cfoutput>#attributes.modal_id#</cfoutput>);
		return false;
    <cfelse>
		return true;
    </cfif>
    }
function cc_controls()
{
	if(document.upd_credit_card.card_type.value == 0)
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30514.Kredi Kartı Tipi !'>");
		return false;
	}
	<cfif add_bank_xml>
		if(document.upd_credit_card.bank_type.value == 0)
		{
			alert("<cf_get_lang dictionary_id='58940.Banka Seçiniz'>!");
			return false;
		}
	</cfif>
	<cfif xml_special_def eq 2>
			if(document.upd_credit_card.special_def_id.value == '')
			{
				alert("<cf_get_lang dictionary_id='59891.Özel Tanım Seçmelisiniz'>!");
				return false;
			}
		</cfif>
	d = new Date();
	if((document.upd_credit_card.year.value < d.getYear() && document.upd_credit_card.month.selectedIndex < d.getMonth()) || (document.upd_credit_card.year.value == d.getYear() && document.upd_credit_card.month.selectedIndex < d.getMonth()))
	{
		alert("<cf_get_lang dictionary_id ='30598.Geçerlilik Tarihi Bu Dönemden Küçük Olamaz'> !");
		return false;
	}
		return true;
}
function c_credit_card_status()
{
	if(document.all.default_card.checked == false)
	{
		<cfif isDefined("attributes.comp_id")>
			 var c_id = document.upd_credit_card.comp_id.value;
			 var is_member = 1;
		 <cfelse>
		 	 var c_id = document.upd_credit_card.cons_id.value;
		  	 var is_member = 0;
		 </cfif>
		if(confirm("<cf_get_lang dictionary_id='30743.Kredi Kartı Pasif Olarak Güncellenecektir'>!")) 
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_ajax_upd_comp_credit_card_status</cfoutput>&c_id='+c_id+'&cc_id='+document.upd_credit_card.ccid.value+'&xml_cc_relation_control='+document.upd_credit_card.xml_cc_relation_control.value+'&is_member='+is_member+'&is_default=0','credit_card_status_',1);
			return false;
		}
		else
		{
			if(document.all.default_card.checked == false)
			document.all.default_card.checked = true;
		}
	}
	else
		return true;
}
</script>
