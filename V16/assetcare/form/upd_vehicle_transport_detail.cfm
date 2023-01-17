<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_SHIP" datasource="#DSN#">
	SELECT SHIP_METHOD,SHIP_METHOD_ID FROM SHIP_METHOD ORDER BY SHIP_METHOD_ID
</cfquery>
<cfquery name="GET_TRANSPORT" datasource="#DSN#">
	SELECT 
        ASSET_P_TRANSPORT.SHIP_ID,
        ASSET_P_TRANSPORT.SHIP_NUM,
        ASSET_P_TRANSPORT.DOCUMENT_NUM,
        ASSET_P_TRANSPORT.SENDER_EMP_ID,
        ASSET_P_TRANSPORT.SHIP_DATE,
        ASSET_P_TRANSPORT.SENDER_DEPOT,
        ASSET_P_TRANSPORT.RECEIVER_DEPOT,
        ASSET_P_TRANSPORT.SHIP_FIRM,
        ASSET_P_TRANSPORT.PLATE,
        ASSET_P_TRANSPORT.PACK_QUANTITY,			
        ASSET_P_TRANSPORT.PACK_DESI,			
        ASSET_P_TRANSPORT.STUFF_TYPE,
        ASSET_P_TRANSPORT.SHIP_STATUS,
        ASSET_P_TRANSPORT.DOCUMENT_TYPE,
        ASSET_P_TRANSPORT.SHIP_METHOD,
        ASSET_P_TRANSPORT.DETAIL,
        ASSET_P_TRANSPORT.TOTAL_AMOUNT,
        ASSET_P_TRANSPORT.TOTAL_CURRENCY,
        DEPARTMENT.DEPARTMENT_HEAD,
        EMPLOYEE_NAME,
        EMPLOYEE_SURNAME,
        COMPANY.NICKNAME,
        BRANCH.BRANCH_NAME,
        DEPARTMENT.BRANCH_ID
	FROM
        ASSET_P_TRANSPORT,
        SHIP_METHOD,
        DEPARTMENT,
        EMPLOYEES,
        COMPANY,
        BRANCH
	WHERE  
        DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
        SHIP_METHOD.SHIP_METHOD_ID = ASSET_P_TRANSPORT.SHIP_METHOD AND
        ASSET_P_TRANSPORT.SENDER_DEPOT = DEPARTMENT.DEPARTMENT_ID AND
        EMPLOYEES.EMPLOYEE_ID = ASSET_P_TRANSPORT.SENDER_EMP_ID AND
        COMPANY.COMPANY_ID = ASSET_P_TRANSPORT.SHIP_FIRM AND
        ASSET_P_TRANSPORT.SHIP_ID = #attributes.ship_id#
</cfquery>
<cfquery name="GET_DEPARTMENTS" datasource="#DSN#">
	SELECT 
		DEPARTMENT_HEAD
	FROM 
		DEPARTMENT
	WHERE 
		DEPARTMENT_ID = #get_transport.receiver_depot#
</cfquery>
<cfinclude template="../query/get_document_type.cfm">
<cfsavecontent variable="img_">
    <a href="javascript://" onclick="nakliye_kayit();"><img src="/images/plus1.gif" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
</cfsavecontent>
<cf_popup_box title="#getLang('assetcare',690)#" right_images="#img_#"><!---Nakliye Kayıt güncelle--->
    <cfform  method="post" name="upd_transport" action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_transport&ship_id=#attributes.ship_id#" onsubmit="return(unformat_fields());">
    <input type="hidden" name="is_detail" id="is_detail" value="1">
        <table>
            <tr> 
                <td><cf_get_lang no='319.Sevk No'> *</td>
                <td width="200">
                    <cfsavecontent variable="message1"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='319.sevk No'>!</cfsavecontent>
                    <cfinput type="text" name="shipping_num" style="width:155px;"  value="#get_transport.ship_num#" maxlength="50" required="yes" message="#message1#">
                </td>
                <td><cf_get_lang no='406.Gönderi'></td>
                <td>
                    <input name="quantity" id="quantity" type="text" value="<cfoutput>#tlformat(get_transport.pack_quantity)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));" style="width:40px;">
                    <input name="desi" id="desi" type="text" value="<cfoutput>#tlformat(get_transport.pack_desi)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));" style="width:40px;">
                    <select name="stuff_type" id="stuff_type" style="width:70px;">
                        <option value="1" <cfif get_transport.stuff_type eq 1>selected</cfif>><cf_get_lang no='441.Koli'></option>
                        <option value="2" <cfif get_transport.stuff_type eq 2>selected</cfif>><cf_get_lang_main no='279.Dosya'></option>
                        <option value="3" <cfif get_transport.stuff_type eq 3>selected</cfif>><cf_get_lang_main no='1068.Arac'></option>
                    </select>
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang no='411.Sevk Tarihi'> *</td>
                <td>
                    <cfsavecontent variable="message2"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='411.Geçerli sevk tarihi'>!</cfsavecontent>
                    <cfinput type="text" name="shipping_date" required="yes" maxlength="10" value="#dateformat(get_transport.ship_date,dateformat_style)#" validate="#validate_style#" style="width:155px" message="#message2#"> 
                    <cf_wrk_date_image date_field="shipping_date">
                </td>
                <td><cf_get_lang_main no='70.Asama'></td>
                <td>
                    <select name="shipping_status" id="shipping_status" style="width:155px;">
                        <option value="0" <cfif get_transport.ship_status eq 0>selected</cfif>><cf_get_lang no='435.Gönderildi'></option>
                        <option value="1" <cfif get_transport.ship_status eq 1>selected</cfif>><cf_get_lang no='659.Alındı'></option>
                    </select>
                </td>
                </tr>
                <tr> 
                <td><cf_get_lang no='410.Gönderen Şube'> *</td>
                <td>
                    <input type="hidden" name="sender_depot_id" id="sender_depot_id" value="<cfoutput>#get_transport.sender_depot#</cfoutput>">
                    <cfsavecontent variable="message3"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='410.Gönderen Şube'>!</cfsavecontent>
                    <cfinput type="Text" name="sender_depot" value="#get_transport.branch_name#-#get_transport.department_head#" readonly required="yes" message="#message3#" style="width:155px;"> 
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=upd_transport.sender_depot&field_id=upd_transport.sender_depot_id','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='410.Gönderen Şube'>" align="absmiddle" border="0"></a>
                </td>
                <td><cf_get_lang_main no='468.Belge No'> </td>
                <td><cfinput name="document_num" type="text" style="width:155px;" value="#get_transport.document_num#" maxlength="40"></td>
            </tr>
            <tr> 
                <td><cf_get_lang no='409.Gönderen Kişi'> *</td>
                <td>
                    <cfsavecontent variable="message4"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='409.Gönderen Kişi'>!</cfsavecontent>
                    <input name="sender_employee_id" id="sender_employee_id" type="hidden" value="<cfoutput>#get_transport.sender_emp_id#</cfoutput>"> 
                    <cfinput type="text" name="sender_employee" maxlength="10" style="width:155px" message="#message4#" required="yes" value="#get_transport.employee_name# #get_transport.employee_surname#"> 
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_transport.sender_employee_id&field_name=upd_transport.sender_employee','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='409.Gönderen Kişi'>" align="absmiddle" border="0"></a>
                </td>
                <td><cf_get_lang_main no='1121.Belge Tipi'></td>
                <td>
               <select name="document_type" id="document_type" style="width:155px;">
                    <cfoutput query="get_document_type"> 
                        <option value="#document_type_id#" <cfif get_transport.document_type eq document_type_id>selected</cfif>>#document_type_name#</option>
                    </cfoutput>
                    </select>
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang no='408.Alıcı Şube'> *</td>
                <td>
                    <cfset x = "">
                    <cfif len(get_transport.receiver_depot)>
                        <cfquery name="GET_DEPS" datasource="#DSN#">
                            SELECT DEPARTMENT_HEAD,BRANCH_NAME FROM DEPARTMENT,BRANCH WHERE DEPARTMENT_ID = #get_transport.receiver_depot# AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                        </cfquery>
                        <cfif get_deps.recordCount>
                            <cfset x = get_deps.branch_name&'-'&get_deps.department_head>
                        </cfif>
                    </cfif>
                    <cfsavecontent variable="message5"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='408.Alıcı Şube'>!</cfsavecontent>
                    <input type="hidden" name="receiver_depot_id" id="receiver_depot_id" value="<cfoutput>#get_transport.receiver_depot#</cfoutput>"> 
                    <cfinput type="Text" name="receiver_depot" value="#x#" readonly style="width:155px;" required="yes" message="#message5#"> 
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=upd_transport.receiver_depot&field_id=upd_transport.receiver_depot_id&is_all_departments=1','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='408.Alıcı Şube'>!" align="absmiddle" border="0"></a>
                </td>
                <td><cf_get_lang_main no='261.Toplam Tutar'></td>
                <td>
                    <cfinput name="total_amount" type="text" style="width:100px;" value="#tlFormat(get_transport.total_amount)#" onKeyup="return(FormatCurrency(this,event));"> 
                    <select name="total_currency" id="total_currency" style="width:52px;">													
                    <cfoutput query="get_money"> 
                        <option value="#money_id#" <cfif money_id eq get_transport.total_currency>selected</cfif>>#money#</option>
                    </cfoutput>
                    </select>
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang no='258.Taşıma Tipi'> *</td>
                <td>
                    <select name="shipping_type" id="shipping_type" style="width:155px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfoutput query="get_ship"> 
                        <option value="#ship_method_id#" <cfif get_transport.ship_method eq ship_method_id>selected</cfif>>#ship_method#</option>
                    </cfoutput>
                    </select>
                </td>
                <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                <td rowspan="2" valign="top"><textarea name="detail" id="detail" style="width:157px;height:40px"><cfoutput>#get_transport.detail#</cfoutput></textarea></td>
            </tr>
            <tr> 
                <td><cf_get_lang no='407.Taşıyan Firma'> *</td>
                <td>
                    <input type="hidden" name="transporter_id" id="transporter_id" value="<cfoutput>#get_transport.ship_firm#</cfoutput>"> 
                    <cfinput type="Text" name="transporter" value="#get_transport.nickname#" readonly style="width:155px;" required="yes"> 
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_transport.transporter_id&field_comp_name=upd_transport.transporter&is_buyer_seller=1','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='407.Taşıyan Firma'>" align="absmiddle" border="0"></a>
                </td>
                <td>&nbsp;</td>
            </tr>
            <tr> 
                <td><cf_get_lang_main no='1656.Plaka'></td>
                <td><input name="plate" id="plate" type="text" style="width:155px;" value="<cfoutput>#get_transport.plate#</cfoutput>"></td>
                <td>&nbsp;</td>
            </tr>
        </table>
        <cf_popup_box_footer>
            <cf_workcube_buttons is_upd='1' is_cancel='0' is_delete='1' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_vehicle_transport&ship_id=#attributes.ship_id#&head=#get_transport.document_num#&is_detail=1' add_function="kontrol()">
        </cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
function unformat_fields()
{
	var fld = document.upd_transport.quantity;
	var fld2 = document.upd_transport.desi;
	var fld3 = document.upd_transport.total_amount;
	fld.value = filterNum(fld.value);
	fld2.value = filterNum(fld2.value);
	fld3.value = filterNum(fld3.value);
}
function kontrol()
{
	x = document.upd_transport.shipping_type.selectedIndex;
	if(document.upd_transport.shipping_type[x].value == "")
	{
	alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='193.Sevkiyat Türü'>");
	return false;
	}
	document.upd_transport.quantity.value = filterNum(upd_transport.quantity.value);
	return true;
}
function nakliye_kayit()
{
	window.opener.parent.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.vehicle_transport';
	window.close();
}
</script>

