<cfparam default="" name="attributes.consumer_id">
<cfparam default="" name="attributes.company_id">
<cfparam default="" name="attributes.consumer_name">
<cfparam default="" name="attributes.company_name">
<cfset get_cus_cards.recordcount = 0>

<cfparam name="attributes.modal_id" default="">

<cfif len(attributes.consumer_id)>
	<cfset attributes.consumer_id = attributes.consumer_id>
    <cfset attributes.consumer_name = get_cons_info(attributes.consumer_id,0,0)>
 	<cfquery name="get_gen" datasource="#dsn#">
    	SELECT GENIUS_ID FROM CONSUMER WHERE CONSUMER_ID =  #attributes.consumer_id#
    </cfquery>
    <cfif len(get_gen.genius_id)>
        <!---<cfquery name="get_cus_cards" datasource="#dsn_gen#">
            SELECT CODE,ID FROM CARD WHERE FK_CUSTOMER = #get_gen.genius_id#
        </cfquery>--->
    <cfelse>
    	<script>
			alert('<cf_get_lang dictionary_id='62537.Bu Üye Genuis Bağlantısı Bulunamadı'>\n<cf_get_lang dictionary_id='62538.Puan Ekleme Yapılamaz'>!');
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</script>
        <cfabort>
    </cfif>
<cfelseif len(attributes.company_id)>
    <cfset attributes.company_id = attributes.company_id>
    <cfset attributes.company_name = get_par_info(attributes.company_id,-1,0,0)>
 	<cfquery name="get_gen" datasource="#dsn#">
    	SELECT GENIUS_ID FROM COMPANY WHERE COMPANY_ID =  #attributes.company_id#
    </cfquery>
    <cfif len(get_gen.genius_id)>
        <cfquery name="get_cus_cards" datasource="#dsn_gen#">
            SELECT CODE,ID FROM CARD WHERE FK_CUSTOMER = #get_gen.genius_id#
        </cfquery>
    <cfelse>
    	<script>
			alert('<cf_get_lang dictionary_id='62537.Bu Üye Genuis Bağlantısı Bulunamadı'>\n<cf_get_lang dictionary_id='62538.Puan Ekleme Yapılamaz'>!');
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</script>
        <cfabort>
    </cfif>
</cfif>
<cfif not isdefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#iif(isDefined("attributes.draggable"),"getLang('','Müşteri Puanları',40562)",DE(''))#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_form" action="#iif(isDefined("attributes.draggable"),DE('#request.self#?fuseaction=retail.consumer_list'),DE(''))#" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <cfif len(attributes.consumer_id) or len(attributes.company_id)>
                        <div class="form-group" id="item-company_name">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="57457.Müşteri"></label>
                            <div class="col col-8 col-sm-12">
                                <cfsavecontent  variable="message"><cf_get_lang dictionary_id='34788.Müşteri Seçiniz'></cfsavecontent>
                                <cfinput type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#" readonly="yes">
                                <cfinput type="hidden" name="company_id" id="company_id" value="#attributes.company_id#" readonly="yes">
                                <cfif len(attributes.company_id)>
                                    <cfinput type="text" name="company_name" id="company_name" required="yes" message="#message#" value="#attributes.company_name#" readonly="yes">
                                <cfelseif len(attributes.consumer_id)>
                                    <cfinput type="text" name="consumer_name" id="consumer_name" required="yes" message="#message#" value="#attributes.consumer_name#" readonly="yes">
                                </cfif>
                            </div>
                        </div>
                        <cfif get_cus_cards.recordcount>
                            <div class="form-group" id="item-card">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61778.Müşteri Kart'></label>
                                <div class="col col-8 col-sm-12">
                                    <select name="card" id="card" style="width:150px;">
                                        <cfoutput query="get_cus_cards">
                                            <option value="#code#">#code#</option>
                                        </cfoutput>
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    </select>
                                </div>
                            </div>
                        </cfif>
                    <cfelse>
                        <div class="form-group" id="item-company_name">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="57457.Müşteri"></label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='34788.Müşteri Seçiniz'></cfsavecontent>
                                    <cfinput type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
                                    <cfinput type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
                                    <cfinput type="text" name="company_name" id="company_name" required="yes" message="#message#" style="width:150px;" value="#attributes.company_name#">
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_list_cons&field_id_cmp=add_form.company_id&field_name=add_form.company_name&field_id=add_form.consumer_id&member_card_no=add_form.card','wide')"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='34788.Müşteri Seçiniz'>" align="absmiddle"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-card">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61778.Müşteri Kart'></label>
                            <div class="col col-8 col-sm-12">
                                <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61781.Lütfen Kart Seçiniz'>!</cfsavecontent>
                                <cfinput type="text" name="card" id="card" required="yes" message="#message#" style="width:150px;" value="" readonly="yes">
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57692.İşlem'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="type" id="type" style="width:150px;">
                                <option value="1"><cf_get_lang dictionary_id='61779.Puan Ekle'></option>
                                <option value="2"><cf_get_lang dictionary_id='61780.Puan Çıkar'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='29943.Lütfen miktar giriniz'></cfsavecontent>
                            <cfinput type="text" required="yes" passThrough="onkeyup=""return(FormatCurrency(this,event,2,'float'));""" message="#message#" name="amount" onKeyUp="isNumber(this,1)" id="amount" style="width:150px; text-align:right;" value="">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons add_function="control()">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function control()
	{
		if(document.getElementById('card').value=='')
		{
			alert('Lütfen Kart Seçiniz!');
			return false;
		}
		document.getElementById('amount').value = filterNum(document.getElementById('amount').value);
		<cfif isdefined("attributes.draggable")>loadPopupBox('add_form' , <cfoutput>#attributes.modal_id#</cfoutput>);<cfelse>return true;</cfif>	
	}
</script>