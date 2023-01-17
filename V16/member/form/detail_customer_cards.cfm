<!--- Kart Numaralari Ekleme / Guncelleme; Bireysel Uye ve Kurumsal Uye Calisani Ekranlarinda Kullanilmaktadir FBS 20110226 --->
<cfquery name="Get_Card_Type" datasource="#dsn#">
	SELECT * FROM SETUP_CARD_CHANGE_TYPES ORDER BY CHANGE_TYPE_NAME
</cfquery>
<cfif isDefined("attributes.card_id") and Len(attributes.card_id)>
	<cfquery name="Get_Customer_Cards" datasource="#dsn#">
		SELECT * FROM CUSTOMER_CARDS WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_id#">
	</cfquery>
<cfelse>
	<cfset Get_Customer_Cards.RecordCount = 0>
	<cfset Get_Customer_Cards.Card_Status = 1>
	<cfset Get_Customer_Cards.Card_No = "">
	<cfset Get_Customer_Cards.Card_Startdate = "">
	<cfset Get_Customer_Cards.Card_FinishDate = "">
	<cfset Get_Customer_Cards.Change_Type_Id = "">
	<cfset Get_Customer_Cards.Card_Detail = "">
    <cfset Get_Customer_Cards.card_limit = "">
    <cfset Get_Customer_Cards.card_limit_money = "">
</cfif>
<cfparam name="attributes.modal_id" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Kart No',30233)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="customer_cards" action="#request.self#?fuseaction=member.emptypopup_detail_customer_cards">
            <cf_box_elements>
                <cfoutput>
                <input type="hidden" name="Card_Id" id="Card_Id" value="<cfif isDefined('attributes.Card_Id') and Len(attributes.Card_Id)>#attributes.Card_Id#</cfif>">
                <input type="hidden" name="Action_Id" id="Action_Id" value="<cfif isDefined('attributes.Action_Id') and Len(attributes.action_id)>#attributes.Action_Id#</cfif>">
                <input type="hidden" name="Action_Type_Id" id="Action_Type_Id" value="<cfif isDefined('attributes.Action_Type_Id') and Len(attributes.Action_Type_Id)>#attributes.Action_Type_Id#</cfif>">
                </cfoutput>
                <cfsavecontent variable="Date_Message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                <cfsavecontent variable="Card_Message"><cf_get_lang dictionary_id='34840.Lütfen Geçerli Bir Kart No Giriniz'> !</cfsavecontent>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="1">
                    <div class="col col-2 col-md-1 col-sm-4 col-xs-12">
                        <div class="form-group">
                            <label><cf_get_lang dictionary_id='57493.Aktif'> <input type="checkbox" name="Card_Status" id="Card_Status" value="1" <cfif Get_Customer_Cards.Card_Status eq 1>checked</cfif>></label>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="30233.Kart No">*</label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="Card_No" value="#Get_Customer_Cards.Card_No#" style="width:150px;" maxlength="16" required="yes" onKeyUp="isNumber(this);" message="#Card_Message#">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30281.Verilme Nedeni'> *</label>
                        <div class="col col-8 col-sm-12">
                            <select name="Change_Type_Id" id="Change_Type_Id" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="Get_Card_Type">
                                    <option value="#Change_Type_Id#" <cfif Get_Customer_Cards.Change_Type_Id eq Get_Card_Type.Change_Type_Id>selected</cfif>>#Change_Type_Name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30280.Verilme Tarihi'> *</label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="Card_Startdate" value="#DateFormat(Get_Customer_Cards.Card_Startdate,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" message="#Date_Message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field='Card_Startdate'></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30365.Son Kullanma Tarihi'> *</label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="Card_Finishdate" value="#DateFormat(Get_Customer_Cards.Card_Finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" message="#Date_Message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field='Card_Finishdate'></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="56883.250 Karakterden Fazla Yazmayınız"></cfsavecontent>
                            <textarea name="Card_Detail" id="Card_Detail" style="width:150px;height:50px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#Get_Customer_Cards.Card_Detail#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-card_limit">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54820.Limit'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" class="moneybox" name="card_limit"  id="card_limit" value="#Get_Customer_Cards.card_limit#">
                        </div>
                    </div>
                    <cfinclude template="../query/get_money.cfm">
                    <div class="form-group" id="item-card_limit_money">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="card_limit_money" id="card_limit_money">
                                <cfoutput query="get_money">
                                    <option value="#money#"  <cfif Get_Customer_Cards.card_limit_money eq money>selected</cfif>>#money#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cfif Get_Customer_Cards.RecordCount>
                    <cf_record_info query_name="Get_Customer_Cards" record_emp="Record_Emp" update_emp="Update_Emp">
                </cfif>
                <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('customer_cards' , #attributes.modal_id#)"),DE(""))#">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('Card_No').value != "")
		{
			if(document.getElementById('Card_No').value.length != 16)
			{
				alert("<cfoutput>#Card_Message#</cfoutput> (<cf_get_lang dictionary_id='30282.Eksik Karakter Sayısı'> : " + (16-document.getElementById('Card_No').value.length) + ")");
				return false;
			}
			if(document.getElementById('Card_Id').value == "") var Card_Id_ = 0; else var Card_Id_ = document.getElementById('Card_Id').value;
			var listParam = document.getElementById('Card_No').value + "*" + Card_Id_;
			var get_same_card_control = wrk_safe_query("same_customer_card_control","dsn",0,listParam);
			if(get_same_card_control.recordcount > 0)
			{
				alert("<cf_get_lang dictionary_id='30288.Aynı Kart Numarası Daha Önce Kullanılmıştır. Lütfen Girdiğiniz Bilgileri Kontrol Ediniz !'>");
				return false;
			}
		}
		if(document.getElementById('Change_Type_Id').value == "")
		{
			alert("<cf_get_lang dictionary_id='30286.Lütfen Verilme Nedenlerinden Birini Seçiniz'> !");
			return false;
		}
		return true;
	}
</script>
