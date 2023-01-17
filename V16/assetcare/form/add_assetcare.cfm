<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfif fusebox.use_period eq true>
	<cfset dsn2 = dsn2>
<cfelse>
	<cfset dsn2 = dsn>
</cfif>
<cfquery name="GET_CARE_CAT" datasource="#DSN#">
	SELECT 
		ASSET_CARE,
		ASSET_CARE_ID 
	<cfif isdefined("url.asset_id") and len(url.asset_id)>
		,ASSET_P.ASSETP_CATID
	</cfif>
	FROM 
		ASSET_CARE_CAT 
	<cfif isdefined("url.asset_id") and len(url.asset_id)>
		,ASSET_P
	WHERE
		ASSET_P.ASSETP_CATID = ASSET_CARE_CAT.ASSETP_CAT AND 
		ASSET_P.ASSETP_ID = #url.asset_id#
	</cfif>
	ORDER BY
		ASSET_CARE_CAT.ASSET_CARE
</cfquery>
<cfquery name="GET_ASSET_STATE" datasource="#DSN#">
	SELECT ASSET_STATE_ID,ASSET_STATE FROM ASSET_STATE ORDER BY ASSET_STATE
</cfquery>
<cfquery name="EXP_ITEM_NAME" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
</cfquery>
<cf_box title="#iif(isdefined('attributes.style'),'',DE(''))#">
    <cfform action="#request.self#?fuseaction=assetcare.emptypopup_add_asset_care" method="post" name="asset_care" enctype="multipart/form-data">
        <input type="hidden" name="is_detail" id="is_detail" value="0">
        <input type="hidden" name="motorized_vehicle" id="motorized_vehicle" value="<cfif isdefined("get_asset_name")><cfoutput>#get_asset_name.motorized_vehicle#</cfoutput></cfif>">
        <cf_box_elements vertical="1">
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <label ><cf_get_lang_main no='1655.Varlık'> *</label>
                <div class="form-group">
                    <div class="input-group">
                        <cfif isdefined("asset_id") and len(asset_id)>
                            <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                                SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #url.asset_id#
                            </cfquery>
                        </cfif>
                        <input type="hidden" name="asset_id" id="asset_id" value="<cfif isdefined("asset_id") and len(url.asset_id)><cfoutput>#url.asset_id#</cfoutput></cfif>">
                        <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'>!</cfsavecontent>
                        <cfif isdefined("asset_id") and len(url.asset_id)>
                            <cfinput type="text" name="asset_name" value="#get_asset_name.assetp#" required="yes" message="#message#" readonly style="width:150px;">
                        <cfelse>
                            <cfinput type="text" name="asset_name" value="" required="yes" message="#message#" readonly style="width:150px;">
                        </cfif>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=asset_care.asset_id&field_name=asset_care.asset_name&event_id=0&motorized_vehicle=0');"></span>
                    </div>                  
                </div>
                <label ><cf_get_lang no='41.Bakım Tarihi'> *</label>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='41.Bakım Tarihi !'></cfsavecontent>
                        <cfinput type="text" name="support_finish_date" validate="#validate_style#" maxlength="10" required="yes" message="#message#" style="width:150px;">
                        <span class="input-group-addon">
                            <cf_wrk_date_image date_field="support_finish_date">
                        </span>
                    </div>                    
                </div>
                <label ><cf_get_lang_main no='468.Belge No'></label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="bill_id" id="bill_id" value="" onChange="bosalt();">
                        <input type="text" name="bill_name" id="bill_name" value="" style="width:150px;" onChange="bosalt();">
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_bills&field_id=asset_care.bill_id&field_name=asset_care.bill_name&field_value=asset_care.expense&field_bill_type_name=asset_care.paper_type&cat=0&field_calistir=1</cfoutput>');"></span>
                        <input type="hidden" name="assetp_id" id="assetp_id" value=""><input type="hidden" name="is_detail" id="is_detail" value="0">
                    </div>                      
                </div>
            </div>
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <label><cf_get_lang no='50.Bakımı Yapan (Üye)'></label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="member_id" id="member_id" value="">
                        <input type="hidden" name="service_company_id" id="service_company_id" value="">
                        <input type="text" name="service_company"  id="service_company" value="" style="width:150px;" readonly>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=asset_care.service_company&field_comp_id=asset_care.service_company_id&field_name=asset_care.authorized&field_partner=asset_care.authorized_id&is_buyer_seller=1&select_list=7');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='50.Bakımı Yapan (Üye)'>" border="0" align="absbottom"></span>
                    </div>
                    
                </div>
                <label><cf_get_lang no='42.Bakım Tipi'></label>
                <div class="form-group"><select name="care_type_id" id="care_type_id" style="width:150px;">
                    <cfoutput query="get_care_cat">
                        <option value="#asset_care_id#">#asset_care#</option>
                    </cfoutput>
                    </select>
                </div>
                <label><cf_get_lang_main no='1121.Belge Tipi'></label>
                <div class="form-group"><cfinput type="text" style="width:150px;" name="paper_type" maxlength="100"></div>
            </div>
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <label><cf_get_lang no='38.Bakımı Yapan Yetkili'></label>
                <div class="form-group">
                    <input type="hidden" name="authorized_id" id="authorized_id" value="">
                    <input type="text" style="width:150px;" name="authorized" id="authorized" value="" readonly>
                </div>
                <label><cf_get_lang_main no='1139.Gider Kalemi'> *</label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="exp_item_name" id="exp_item_name" value="">
                        <cfsavecontent variable="messageitem"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1139.Gider Kalemi'>!</cfsavecontent>
                        <cfinput type="text" name="exp_item_name_id" value="" required="yes" message="#messageitem#" style="width:150px;">
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=asset_care.exp_item_name&field_name=asset_care.exp_item_name_id');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1139.Gider Kalemi'>" border="0" align="absbottom"></span>	
                    </div>              
                </div>
                <label rowspan="2"><cf_get_lang_main no='22.Rapor'></label>
                <div rowspan="2" class="form-group"><textarea style="width:150px;height:50px;" name="care_detail" id="care_detail"></textarea></div>
            </div>
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <label><cf_get_lang no='39.Bakım Yapan Çalışan'></label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="employee_id" id="employee_id" value="">
                        <input type="text" name="employee" id="employee" value="" style="width:150px;" readonly>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=asset_care.employee_id&field_name=asset_care.employee&select_list=1');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='39.Bakım Yapan Çalışan'>" border="0" align="absbottom"></span>
                    </div>		
                </div>
                <label><cf_get_lang_main no='1048.Masraf Merkezi'> *</label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="expense_center_id" id="expense_center_id" value="">
                        <cfsavecontent variable="messagexp"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1048.Masraf Merkezi'>!</cfsavecontent>
                        <cfinput name="expense_center" style="width:150px;" type="text" value="" required="yes" message="#messagexp#">
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=asset_care.expense_center&field_id=asset_care.expense_center_id&is_invoice=1</cfoutput>');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1048.Masraf Merkezi'>" border="0" align="absbottom"></span>
                    </div>
                </div>
            </div>
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <label><cf_get_lang no='39.Bakım Yapan Çalışan'> 2</label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="employee_id2" id="employee_id2"  value="">
                        <input type="text" name="employee2" id="employee2" style="width:150px;" value="" readonly>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=asset_care.employee_id2&field_name=asset_care.employee2&select_list=1');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='39.Bakım Yapan Çalışan'>" border="0" align="absbottom"></span>	
                    </div>
                </div>
                <label><cf_get_lang_main no='846.Maliyet '>*</label>
                <div class="form-group"><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='846.maliyet'></cfsavecontent>
                    <cfinput name="expense" type="text" message="#message#" style="width:97px;" onKeyup="return(FormatCurrency(this,event));">
                    <cfinclude template="../query/get_money.cfm">
                    <select name="money_currency" id="money_currency" style="width:50px;">
                        <cfoutput query="get_money">
                            <option value="#money#" <cfif session.ep.money eq get_money.money>selected</cfif>>#money#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
       </cf_box_elements>
       <cf_workcube_buttons is_upd='0' is_cancel='0' add_function='gonder2()'>
    </cfform>
</cf_box>


<script type="text/javascript">
	function bosalt()
	{
		if (asset_care.bill_name.value == "") 
			asset_care.bill_id.value = "";
	
		if(asset_care.bill_id.value == "")
		{
			asset_care.paper_type.readOnly = false;
			asset_care.expense.readOnly = false;
			asset_care.money_currency.disabled = false;
		}
	
		if (asset_care.bill_id.value != "")
		{
			asset_care.paper_type.readOnly = true;
			asset_care.expense.readOnly = true;
			asset_care.money_currency.disabled = true;
		}
		document.asset_care.expense.value = filterNum(asset_care.expense.value);
	}
		
	function gonder2()
	{
		asset_care.expense.value = filterNum(asset_care.expense.value);
		<cfif not isdefined("asset_care.money_currency.value")>
			asset_care.money_currency.disabled = false;
		</cfif>
		
		if ((asset_care.expense.value != "") && (asset_care.exp_item_name_id.value == ""))
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1139.Gider Kalemi'> !");
			return false;
		}
	
		if ((asset_care.expense.value != "") && (asset_care.expense_center_id.value == ""))
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='217.açıklama'> !");
			return false;
		}
	}
</script>
