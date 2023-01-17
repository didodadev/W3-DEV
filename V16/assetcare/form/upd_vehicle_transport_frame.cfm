<cfsetting showdebugoutput="no">
<cfquery name="GET_TRANSPORT" datasource="#dsn#">
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
        ASSET_P_TRANSPORT.SHIP_STATUS,
        ASSET_P_TRANSPORT.TOTAL_AMOUNT,
        ASSET_P_TRANSPORT.TOTAL_CURRENCY,
        ASSET_P_TRANSPORT.SHIP_METHOD,
        ASSET_P_TRANSPORT.STUFF_TYPE,
        ASSET_P_TRANSPORT.DETAIL,
        SHIP_METHOD.SHIP_METHOD,
        DEPARTMENT.DEPARTMENT_HEAD,
        EMPLOYEE_NAME,
        EMPLOYEE_SURNAME,
        COMPANY.FULLNAME,
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

<cfparam name="attributes.document_type" default="">
<cfinclude template="../query/get_money.cfm">
<cfquery name="get_ship" datasource="#dsn#">
	SELECT SHIP_METHOD,SHIP_METHOD_ID FROM SHIP_METHOD ORDER BY SHIP_METHOD_ID
</cfquery>
<cfquery name="get_documents" datasource="#dsn#">
	SELECT DOCUMENT_TYPE FROM ASSET_P_TRANSPORT WHERE SHIP_ID = #attributes.ship_id# 
</cfquery>
<cfinclude template="../query/get_document_type.cfm">
<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
	<cfquery name="get_asset" datasource="#dsn#">
		SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE ASSETP_ID=#attributes.assetp_id#
	</cfquery>
    <cfset pageHead = "#getLang('','Nakliye Kayıt Güncelle',48561)# : #getLang('main',1656)# : #get_asset.assetp# ">
<cfelse>
	<cfset pageHead = "#getLang('','Nakliye Kayıt Güncelle',48561)#">
</cfif>
<cf_catalystHeader>
    <cf_box>
	<div class="col col-12 uniqueRow">
        <cfform method="post" name="upd_transport" id="upd_transport" action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_transport">
            <input type="hidden" name="ship_id" id="ship_id" value="<cfoutput>#attributes.ship_id#</cfoutput>">
            <input type="hidden" name="is_detail" id="is_detail" value="0">
            <!--- <cf_form_box> --->
               <cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang no='319.Sevk No'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="shipping_num" id="shipping_num" value="<cfoutput>#get_transport.ship_num#</cfoutput>" maxlength="50" >
                        </div>
                    </div>

                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang no='411.Sevk Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="shipping_date" id="shipping_date" maxlength="10" value="<cfoutput>#dateformat(get_transport.ship_date,dateformat_style)#</cfoutput>" > 
                                    <span class="input-group-addon" ><cf_wrk_date_image date_field="shipping_date"></span>
                                </div>
                        </div>
                    </div>

                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang no='410.Gönderen Şube'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="sender_depot_id" id="sender_depot_id" value="<cfoutput>#get_transport.sender_depot#</cfoutput>"> 
                                    <input type="text" name="sender_depot" id="sender_depot" value="<cfoutput>#get_transport.branch_name#-#get_transport.department_head#</cfoutput>" readonly > 
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=upd_transport.sender_depot&field_id=upd_transport.sender_depot_id','list','popup_list_departments')"></span>
                                        
                                </div>
                            </div>
                    </div>
                   
                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang no='409.Gönderen Kişi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input name="sender_employee_id" id="sender_employee_id" type="hidden" value="<cfoutput>#get_transport.sender_emp_id#</cfoutput>"> 
                                    <input type="text" name="sender_employee" id="sender_employee" value="<cfoutput>#get_transport.employee_name# #get_transport.employee_surname#</cfoutput>"  readonly> 
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_transport.sender_employee_id&field_name=upd_transport.sender_employee&branch_related&select_list=3','list','popup_list_positions')"></span>
                                </div>
                            </div>
                    </div>

                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang no='408.Alıcı Şube'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfset x = "">
                                    <cfif len(get_transport.receiver_depot)>
                                        <cfquery name="GET_DEPS" datasource="#DSN#">
                                            SELECT DEPARTMENT_HEAD,BRANCH_NAME FROM DEPARTMENT,BRANCH WHERE DEPARTMENT_ID = #get_transport.receiver_depot# AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                                        </cfquery>
                                        <cfif get_deps.recordCount>
                                            <cfset x = get_deps.branch_name&'-'&get_deps.department_head>
                                        </cfif>
                                    </cfif>
                                        <input type="hidden" name="receiver_depot_id" id="receiver_depot_id" value="<cfoutput>#get_transport.receiver_depot#</cfoutput>"> 
                                        <input type="text" name="receiver_depot" id="receiver_depot" value="<cfoutput>#x#</cfoutput>" readonly > 
                                        <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=upd_transport.receiver_depot&field_id=upd_transport.receiver_depot_id&is_all_departments=1','list','popup_list_departments')"></span>
                                </div>
                            </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
                        <div class="col col-8 col-xs-12">
                        <input name="document_num" id="document_num" type="text" value="<cfoutput>#get_transport.document_num#</cfoutput>" maxlength="40">
                        </div>
                    </div>

                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang no='258.Taşıma Tipi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <select name="shipping_type" id="shipping_type" style="width:155px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_ship"> 
                                    <option value="#ship_method_id#" <cfif get_transport.ship_method eq ship_method_id>selected</cfif>>#ship_method#</option>
                                </cfoutput>
                                </select>
                        </div>
                    </div>

                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang no='407.Taşıyan Firma'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="transporter_id" id="transporter_id" value="<cfoutput>#get_transport.ship_firm#</cfoutput>"> 
                            <input type="text" name="transporter" id="transporter" value="<cfoutput>#get_transport.fullname#</cfoutput>" readonly > 
                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_transport.transporter_id&field_comp_name=upd_transport.transporter&select_list=2','list','popup_list_pars')"></span>
                                </div>
                            </div>
                    </div>

                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'></label>
                            <div class="col col-8 col-xs-12">
                               <input name="plate" id="plate" type="text"  value="<cfoutput>#get_transport.plate#</cfoutput>">
                            </div>
                    </div>

                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang no='406.Gönderi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-4 ">
                                    <input name="quantity" id="quantity" type="text" placeholder="<cf_get_lang_main no='670.Adet'>" value="<cfoutput>#get_transport.pack_quantity#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));" >
                                </div>
                                <div class="col col-4 ">
                                    <input name="desi" id="desi" type="text" placeholder="<cf_get_lang no='457.Desi'>" value="<cfoutput>#get_transport.pack_desi#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));" > 
                                </div>
                                <div class="col col-4 ">
                                    <select name="stuff_type" id="stuff_type" >
                                        <option value="1" <cfif get_transport.stuff_type eq 1>selected</cfif>><cf_get_lang no='441.Koli'></option>
                                        <option value="2" <cfif get_transport.stuff_type eq 2>selected</cfif>><cf_get_lang_main no='279.Dosya'></option>
                                        <option value="3" <cfif get_transport.stuff_type eq 3>selected</cfif>><cf_get_lang_main no='1068.Arac'></option>
                                    </select>
                                </div>
                            </div>
                    </div>

                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='70.Asama'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="shipping_status" id="shipping_status" >
                                <option value="0" <cfif get_transport.ship_status eq 0>selected</cfif>><cf_get_lang no='435.Gönderildi'></option>                
                            </select>
                        </div>
                    </div>

                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='1121.Belge Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="document_type" id="document_type" >
                                <cfoutput query="get_document_type"> 
                                    <option value="#document_type_id#" <cfif get_documents.document_type eq document_type_id>selected</cfif>>#document_type_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>

                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang no='243.KDV li Toplam Tutar'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-8">
                                <input name="total_amount" id="total_amount" type="text"  value="<cfoutput>#tlFormat(get_transport.total_amount)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));"> 
                                </div>
                                
                                <div class="col col-4">
                                    <select name="total_currency" id="total_currency" >
                                        <cfoutput query="get_money"> 
                                            <option value="#money#"<cfif money eq get_transport.total_currency>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>
                                </div>

                            </div>
                    </div>

                    <div class="form-group" >
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="detail" id="detail" style="width:158;height:40"><cfoutput>#get_transport.detail#</cfoutput></textarea>
                            </div>
                    </div>

                </div>
                </cf_box_elements>
                 <cf_form_box_footer>
                    <cf_workcube_buttons is_upd='1' is_cancel='0' is_delete='1' add_function="kontrol()" 
                    	delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_vehicle_transport&ship_id=#attributes.ship_id#&head=#get_transport.document_num#&is_detail=0'>
                 </cf_form_box_footer>
            <!--- </cf_form_box> --->
        </cfform>
	</div>
</cf_box>

<cfinclude template="../display/list_vehicle_transport.cfm"> 

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
		if(document.upd_transport.shipping_date.value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='411.Sevk Tarihi'>");
			return false;
		}	
		if(!CheckEurodate(document.upd_transport.shipping_date.value,'Sevk Tarihi'))
		{
			return false;
		}			
		x = document.upd_transport.shipping_type.selectedIndex;
		if(document.upd_transport.shipping_type[x].value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='258.taşıma türü'>!");
			return false;
		}
		unformat_fields();
		return true;
	}
</script>
