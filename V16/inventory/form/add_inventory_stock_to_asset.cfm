<cf_xml_page_edit fuseact="invent.popup_add_inventory_stock_to_asset">
<cfparam name="attributes.invoice_date" default="">
<cfquery name="get_assets" datasource="#dsn#">
    SELECT * FROM ASSET_P WHERE INVENTORY_ID = #attributes.inventory_id#
</cfquery>
<cfquery name="GET_INVENTORY" datasource="#DSN3#">
	SELECT
		INVENTORY_ID,
		QUANTITY,
		INVENTORY_NUMBER,
		INVENTORY_NAME
	FROM
		INVENTORY
	WHERE
		INVENTORY_ID = #attributes.inventory_id#
</cfquery>
<cfif not GET_INVENTORY.recordcount>
	<cfset GET_INVENTORY.recordcount= 0>
</cfif>
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT
		ASSETP_CATID,
        #dsn#.Get_Dynamic_Language(ASSETP_CATID,'#session.ep.language#','ASSET_P_CAT','ASSETP_CAT',NULL,NULL,ASSETP_CAT) AS ASSETP_CAT,
		IT_ASSET,
		MOTORIZED_VEHICLE
	FROM
		ASSET_P_CAT
	ORDER BY
		ASSETP_CAT
</cfquery>
<cfquery name="GET_ASSETP_GROUPS" datasource="#DSN#">
	SELECT
		GROUP_ID,
        #dsn#.Get_Dynamic_Language(GROUP_ID,'#session.ep.language#','SETUP_ASSETP_GROUP','GROUP_NAME',NULL,NULL,GROUP_NAME) AS GROUP_NAME
	FROM
		SETUP_ASSETP_GROUP
	ORDER BY 
		GROUP_NAME
</cfquery>
<cfquery name="GET_PURPOSE" datasource="#DSN#">
	SELECT
		USAGE_PURPOSE_ID,
        #dsn#.Get_Dynamic_Language(USAGE_PURPOSE_ID,'#session.ep.language#','SETUP_USAGE_PURPOSE','USAGE_PURPOSE',NULL,NULL,USAGE_PURPOSE) AS USAGE_PURPOSE
	FROM
		SETUP_USAGE_PURPOSE
	ORDER BY
		USAGE_PURPOSE
</cfquery>
<cfquery name="GET_ASSET_STATE" datasource="#DSN#">
	SELECT
		ASSET_STATE_ID,
		ASSET_STATE
	FROM 
		ASSET_STATE
	ORDER BY
		ASSET_STATE
</cfquery>
<cfif len(get_assets.assetp_catid)> 
    <cfquery name="GET_ASSET_SUB_CAT" datasource="#DSN#">
        SELECT #dsn#.Get_Dynamic_Language(ASSETP_SUB_CATID,'#session.ep.language#','ASSET_P_SUB_CAT','ASSETP_SUB_CAT',NULL,NULL,ASSETP_SUB_CAT) AS ASSETP_SUB_CAT,ASSETP_SUB_CATID FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assets.assetp_catid#">
    </cfquery>
<cfelse>
	<cfset get_asset_sub_cat.recordcount = 0>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56931.Sabit Kıymeti Fiziki Varlığa Dönüştür"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
    <cf_box title="#message#" print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.inventory_id#&print_type=35" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_inventory_stock_to_asset" id="add_inventory_stock_to_asset" method="post" action="#request.self#?fuseaction=invent.emptypopup_add_inventory_stock_to_asset">
            <input type="hidden" name="select_list" id="select_list" value="">
            <input type="hidden" name="quantity" id="quantity" value="<cfoutput>#get_inventory.quantity#</cfoutput>">
            <input type="hidden" name="is_barcode_control" id="is_barcode_control" value="<cfoutput>#xml_barcode_control#</cfoutput>" />
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-get_assetp_cats">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56930.Varlık Tipi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <select name="assetp_catid" id="assetp_catid" onChange="hesapla2();" style="width:130px;">
                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                <cfoutput query="get_assetp_cats">
                                    <option value="#assetp_catid#;#motorized_vehicle#;#it_asset#" <cfif isdefined("get_assets.ASSETP_CATID") and (get_assetp_cats.ASSETP_CATID eq get_assets.ASSETP_CATID)>selected</cfif>>#assetp_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-assetp_sub_catid"><!--- fiziki varlıga donusturmede varlık alt kategorisi eklendi CE 28092019 --->
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="assetp_sub_catid" id="assetp_sub_catid" >
                                <option value=""><cf_get_lang dictionary_id="57734.Seciniz"></option>
                                <cfif get_asset_sub_cat.recordcount>
                                    <cfoutput query="GET_ASSET_SUB_CAT">
                                        <option value="#assetp_sub_catid#" <cfif assetp_sub_catid eq get_assets.assetp_sub_catid>selected</cfif>>#assetp_sub_cat#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-brand_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'> /<cf_get_lang dictionary_id='30041.Marka Tipi'> <cfif xml_brand_type eq 1> *</cfif></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                <input type="hidden" name="brand_id" id="brand_id" value="#get_assets.brand_id#">
                                <input type="hidden" name="brand_type_id" id="brand_type_id" value="#get_assets.brand_type_id#">
                                <input type="hidden" name="brand_type_cat_id" id="brand_type_cat_id" value="#get_assets.brand_type_cat_id#">
                                </cfoutput>
                                <cfif get_assets.recordcount and len(get_assets.brand_id)>
                                    <cfquery name="get_brand" datasource="#dsn#">
                                        SELECT
                                            SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME,
                                            SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
                                            SETUP_BRAND.BRAND_NAME
                                        FROM
                                            SETUP_BRAND_TYPE_CAT,
                                            SETUP_BRAND_TYPE,
                                            SETUP_BRAND
                                        WHERE
                                            SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
                                            SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
                                            SETUP_BRAND.BRAND_ID = #get_assets.brand_id#
                                    </cfquery>
                                <cfelse>
                                    <cfset get_brand.recordcount = 0>
                                </cfif>
                                <input type="text" name="brand_name" id="brand_name" value="<cfif get_brand.recordcount><cfoutput>#get_brand.BRAND_NAME# - #get_brand.BRAND_TYPE_NAME# - #get_brand.BRAND_TYPE_CAT_NAME#</cfoutput></cfif>" readonly style="width:130px;">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_brand();"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-make_year">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58225.Model'><cfif xml_make_year eq 1> *</cfif></label>
                        <div class="col col-8 col-xs-12">
                            <select name="make_year" id="make_year">
                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                <cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
                                <cfoutput>
                                    <cfloop from="#yil#" to="1970" index="i" step="-1">
                                        <option value="#i#" <cfif isdefined("get_assets.make_year") and len(get_assets.make_year) and get_assets.make_year eq i>selected</cfif>>#i#</option>
                                    </cfloop>
                                </cfoutput>
                            </select>	
                        </div>
                    </div>
            
                    <div class="form-group" id="item-company_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56928.Alınan Firma'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                <input type="text" name="company_name" id="company_name" readonly value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#get_par_info(attributes.company_id,1,0,0)#</cfoutput></cfif>" style="width:130px;">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=add_inventory_stock_to_asset.partner_name&field_partner=add_inventory_stock_to_asset.partner_id&field_comp_name=add_inventory_stock_to_asset.company_name&field_comp_id=add_inventory_stock_to_asset.company_id&field_consumer=add_inventory_stock_to_asset.consumer_id&is_buyer_seller=1&select_list=2,3','list','popup_list_pars');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12"  type="column" index="3" sort="true">
                    <div class="form-group" id="item-partner_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57578.Yetkili'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                            <input type="text" name="partner_name" id="partner_name" value="<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfoutput>#get_par_info(attributes.partner_id,0,0,0)#</cfoutput></cfif>" readonly style="width:130px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56926.Alış Tarihi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='56996.Alım Tarihi'></cfsavecontent>
                                <cfinput type="text" name="start_date" value="#dateformat(attributes.invoice_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:130px">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-make_year">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58878.Demirbaş No'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="inventory_id" id="inventory_id" value="<cfoutput>#get_inventory.inventory_id#</cfoutput>">
                            <input type="text" name="inventory_number" id="inventory_number" value="<cfoutput>#get_inventory.inventory_number#</cfoutput>" style="width:130px;">
                        </div>
                    </div>
                </div>
                <cf_grid_list class="workDevList">
                    <thead>
                        <tr>
                            <input type="hidden" name="add_asset" id="add_asset" value="<cfoutput>#get_assets.recordcount#</cfoutput>">
                            <cfif xml_count_control eq 1>
                            <th style="width:30px;"><a href="javascript://" onclick="add_row();"><img src="images/plus_list.gif" title="Ekle"></a></th>
                            </cfif>
                            <th width="100"><cf_get_lang dictionary_id='29452.Varlık'> *</th>
                            <th width="135"><cf_get_lang dictionary_id="57633.barcod"></th>
                            <th width="80"><cf_get_lang dictionary_id ='57637.Seri No'></th>
                            <th width="75"><cf_get_lang dictionary_id='58140.İş Grubu'></th>
                            <th width="90"><cf_get_lang dictionary_id='56925.Kullanım Amacı'></th>
                            <th width="135"><cf_get_lang dictionary_id='57544.Sorumlu'> *</th>
                            <th width="135"><cf_get_lang dictionary_id='56924.Kayıtlı Şube'> *</th>			
                            <th width="135"><cf_get_lang dictionary_id='56923.Kullanıcı Şube'></th>
                            <th width="75"><cf_get_lang dictionary_id ='57756.Durum'></th>
                        </tr>
                    </thead>
                    <tbody id="asset_body">
                        <cfif xml_count_control eq 1>
                            <input type="hidden" name="row_number" id="row_number" value="<cfoutput>#get_assets.recordcount#</cfoutput>" />
                            <cfif get_assets.recordcount>
                                <cfloop query="get_assets" startrow="1" endrow="#get_assets.recordcount#">
                                    <cfoutput>
                                        <tr id="asset_info_#currentrow#">
                                            <td>
                                                <input type="hidden" value="1" id="del_asset_#currentrow#" name="del_asset_#currentrow#"><a style="cursor:pointer" onclick="del_asset(#currentrow#);"><i class="fa fa-minus" border="0" alt="<cf_get_lang dictionary_id ='57463.sil'>"></i></a><a style="cursor:pointer" onclick="copy_row(#currentrow#);" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy"></i></a>
                                            </td>
                                            <td><input type="text" name="assetp#currentrow#" id="assetp#currentrow#" value="#get_inventory.inventory_name#" maxlength="100" style="width:100px;"></td>
                                            <td nowrap="nowrap">
                                                <input type="text" name="barcode#currentrow#" id="barcode#currentrow#" onKeyUp="isNumber(this)" value="#barcode#" style="width:85px;" maxlength="50" />
                                                <cfif is_auto_barcode eq 0>
                                                    <a href="javascript://" onclick="javascript:document.add_inventory_stock_to_asset.barcode#currentrow#.value='<cfoutput>#get_barcode_no()#</cfoutput>'"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="Otomatik Barkod" align="absbottom"></a>
                                                <cfelse>
                                                    <a href="javascript://" onclick="javascript:document.add_inventory_stock_to_asset.barcode#currentrow#.value='<cfoutput>#get_barcode_no(1)#</cfoutput>'"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="Otomatik Barkod" align="absbottom"></a>
                                                </cfif>
                                            </td>
                                            <td><input type="text" name="serial_number#currentrow#" id="serial_number#currentrow#" value="#serial_no#" maxlength="50" style="width:80px"></td>
                                            <td>
                                                <select name="assetp_group#currentrow#" id="assetp_group#currentrow#" style="width:100px;">
                                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                    <cfloop query="get_assetp_groups">
                                                        <option value="#group_id#" <cfif isdefined("get_assets.ASSETP_GROUP") and len(get_assets.ASSETP_GROUP) and group_id eq get_assets.ASSETP_GROUP>selected</cfif>>#group_name#</option>
                                                    </cfloop>
                                                </select>			  
                                            </td>
                                            <td>
                                                <select name="usage_purpose#currentrow#" id="usage_purpose#currentrow#" style="width:100px;">
                                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                    <cfloop query="get_purpose">
                                                        <option value="#usage_purpose_id#" <cfif isdefined("get_assets.USAGE_PURPOSE_ID") and len(get_assets.USAGE_PURPOSE_ID) and usage_purpose_id eq get_assets.USAGE_PURPOSE_ID>selected</cfif>>#usage_purpose#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                            <td nowrap="nowrap">
                                                <input type="hidden" name="position_code#currentrow#" id="position_code#currentrow#" value="#position_code#">
                                                <input type="hidden" name="emp_id#currentrow#" id="emp_id#currentrow#" value="#employee_id#">
                                                <input type="text" name="employee_name#currentrow#" id="employee_name#currentrow#" value="<cfif len(employee_id)>#get_emp_info(employee_id,0,0)#</cfif>" readonly style="width:114px;">
                                                <a href="javascript://" onClick="pencere_ac_position('#currentrow#');"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='57544.Sorumlu'>" align="absmiddle" border="0"></a>
                                            </td>
                                            <td nowrap="nowrap">
                                                <input type="hidden" name="department_id#currentrow#" id="department_id#currentrow#" value="#department_id#">
                                                <cfif len(department_id)>
                                                    <cfquery name="get_Dep" datasource="#dsn#">
                                                        SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #department_id#
                                                    </cfquery>
                                                </cfif>
                                                <input type="text" name="department#currentrow#" id="department#currentrow#" value="<cfif get_Dep.recordcount>#get_dep.department_head#</cfif>" readonly style="width:114px;">
                                                <a href="javascript://" onClick="pencere_ac_department('#currentrow#',1);"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='56924.Kayıtlı Şube'>" align="absmiddle" border="0"></a>
                                            </td>
                                            <td nowrap="nowrap">
                                                <input type="hidden" name="department_id_2_#currentrow#" id="department_id_2_#currentrow#" value="#department_id2#">
                                                <cfif len(department_id2)>
                                                    <cfquery name="get_dep2" datasource="#dsn#">
                                                        SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #department_id2#
                                                    </cfquery>
                                                </cfif>
                                                <input type="text" name="department2_#currentrow#" id="department2_#currentrow#" value="<cfif len(get_dep2.recordcount)>#get_dep2.department_head#</cfif>" readonly style="width:114px;">
                                                <a href="javascript://" onClick="pencere_ac_department('#currentrow#',2);"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='56923.Kullanıcı Şube'>" align="absmiddle" border="0"></a>
                                            </td>
                                            <td>
                                                <select name="status#currentrow#" id="status#currentrow#" style="width:100px">
                                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                    <cfloop query="get_asset_state">
                                                        <option value="#asset_state_id#" <cfif isdefined("get_assets.ASSETP_STATUS") and len(get_assets.ASSETP_STATUS) and asset_state_id eq get_assets.ASSETP_STATUS>selected</cfif>>#asset_state#</option>
                                                    </cfloop>
                                                </select>			  
                                            </td>
                                        </tr>
                                    </cfoutput>
                                </cfloop>
                            <cfelse>
                            </cfif>
                        <cfelse>
                            <cfloop from="1" to="#get_inventory.quantity#" index = "LoopCount">
                                <cfoutput>
                                    <tr>
                                        <td><input type="text" name="assetp#LoopCount#" id="assetp#LoopCount#" value="#get_inventory.inventory_name#" maxlength="100" style="width:100px;"></td>
                                        <td nowrap="nowrap">
                                            <input type="text" name="barcode#LoopCount#" id="barcode#LoopCount#" value="#get_assets.barcode[LoopCount]#" onKeyUp="isNumber(this)" style="width:85px;" maxlength="50" />
                                            <cfif is_auto_barcode eq 0>
                                                <a href="javascript://" onclick="javascript:document.add_inventory_stock_to_asset.barcode#LoopCount#.value='<cfoutput>#get_barcode_no()#</cfoutput>'"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang dictionary_id='46805.Otomatik Barkod'>" align="absbottom"></a>
                                            <cfelse>
                                                <a href="javascript://" onclick="javascript:document.add_inventory_stock_to_asset.barcode#LoopCount#.value='<cfoutput>#get_barcode_no(1)#</cfoutput>'"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang dictionary_id='46805.Otomatik Barkod'>" align="absbottom"></a>
                                            </cfif>
                                        </td>
                                        <td><input type="text" name="serial_number#LoopCount#" id="serial_number#LoopCount#" value="#get_assets.serial_no[LoopCount]#" maxlength="50" style="width:80px"></td>
                                        <td>
                                            <select name="assetp_group#LoopCount#" id="assetp_group#LoopCount#" style="width:100px;">
                                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                <cfloop query="get_assetp_groups">
                                                    <option value="#group_id#" <cfif get_assets.ASSETP_GROUP[LoopCount] eq group_id>selected</cfif>>#group_name#</option>
                                                </cfloop>
                                            </select>			  
                                        </td>
                                        <td>
                                            <select name="usage_purpose#LoopCount#" id="usage_purpose#LoopCount#" style="width:100px;">
                                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                <cfloop query="get_purpose">
                                                    <option value="#usage_purpose_id#" <cfif get_assets.USAGE_PURPOSE_ID[LoopCount] eq get_purpose.usage_purpose_id>selected</cfif>>#usage_purpose#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                        <td nowrap="nowrap">
                                            <input type="hidden" name="position_code#LoopCount#" id="position_code#LoopCount#" value="#get_assets.position_code[LoopCount]#">
                                            <input type="hidden" name="emp_id#LoopCount#" id="emp_id#LoopCount#" value="#get_assets.employee_id[LoopCount]#">
                                            <input type="text" name="employee_name#LoopCount#" id="employee_name#LoopCount#" value="#get_emp_info(get_assets.employee_id[LoopCount],0,0)#" readonly style="width:114px;">
                                            <a href="javascript://" onClick="pencere_ac_position('#LoopCount#');"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='57544.Sorumlu'>" align="absmiddle" border="0"></a>
                                        </td>
                                        <td nowrap="nowrap">
                                            <input type="hidden" name="department_id#LoopCount#" id="department_id#LoopCount#" value="#get_assets.DEPARTMENT_ID[LoopCount]#">
                                            <cfif len(get_assets.DEPARTMENT_ID[LoopCount])>
                                                <cfquery name="get_depp" datasource="#dsn#">
                                                    SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_assets.DEPARTMENT_ID[LoopCount]#
                                                </cfquery>
                                            </cfif>
                                            <input type="text" name="department#LoopCount#" id="department#LoopCount#" value="<cfif len(get_assets.DEPARTMENT_ID[LoopCount]) and isdefined("get_depp.DEPARTMENT_HEAD")>#get_depp.DEPARTMENT_HEAD#</cfif>" readonly style="width:114px;">
                                            <a href="javascript://" onClick="pencere_ac_department('#LoopCount#',1);"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='56924.Kayıtlı Şube'>" align="absmiddle" border="0"></a>
                                        </td>
                                        <td nowrap="nowrap">
                                            <input type="hidden" name="department_id_2_#LoopCount#" id="department_id_2_#LoopCount#" value="#get_assets.DEPARTMENT_ID2[LoopCount]#">
                                            <cfif len(get_assets.DEPARTMENT_ID2[LoopCount])>
                                                <cfquery name="get_depp2" datasource="#dsn#">
                                                    SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_assets.DEPARTMENT_ID2[LoopCount]#
                                                </cfquery>
                                            </cfif>
                                            <input type="text" name="department2_#LoopCount#" id="department2_#LoopCount#" value="<cfif len(get_assets.DEPARTMENT_ID2[LoopCount]) and isdefined("get_depp2.DEPARTMENT_HEAD")>#get_depp.DEPARTMENT_HEAD#</cfif>" readonly style="width:114px;">
                                            <a href="javascript://" onClick="pencere_ac_department('#LoopCount#',2);"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='56923.Kullanıcı Şube'>" align="absmiddle" border="0"></a>
                                        </td>
                                        <td>
                                            <select name="status#LoopCount#" id="status#LoopCount#" style="width:100px">
                                                <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                <cfloop query="get_asset_state">
                                                    <option value="#asset_state_id#" <cfif get_assets.ASSETP_STATUS[LoopCount] eq get_asset_state.asset_state_id>selected</cfif>>#asset_state#</option>
                                                </cfloop>
                                            </select>			  
                                        </td>
                                    </tr>
                                </cfoutput>
                            </cfloop>
                        </cfif>
                    </tbody>
                </cf_grid_list>
            </cf_box_elements>
            <cf_box_footer>
               
                        <cf_workcube_buttons is_upd='0' add_function= 'kontrol()'>
                   
            </cf_box_footer>
                    
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function pencere_ac_brand()
{
	a = document.add_inventory_stock_to_asset.assetp_catid.selectedIndex;
	if (document.add_inventory_stock_to_asset.assetp_catid[a].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='56922.Varlık Tipi Seçiniz'> ! ");
		return false;
	}
	else
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_brand_type_cat&field_brand_id=add_inventory_stock_to_asset.brand_id&field_brand_type_id=add_inventory_stock_to_asset.brand_type_id&field_brand_type_cat_id=add_inventory_stock_to_asset.brand_type_cat_id&field_brand_name=add_inventory_stock_to_asset.brand_name&select_list='+add_inventory_stock_to_asset.select_list.value+'</cfoutput>','list','popup_list_brand_type_cat');
}

function pencere_ac_position(no)
{
	windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_inventory_stock_to_asset.position_code' +no+ '&field_name=add_inventory_stock_to_asset.employee_name' +no+ '&field_emp_id=add_inventory_stock_to_asset.emp_id' +no+ '&call_function=fill_department(' +no+ ')</cfoutput>','list','popup_list_positions');
}

function pencere_ac_department(no,type)
{
	if(type==1)
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_departments&field_id=add_inventory_stock_to_asset.department_id' +no+ '&field_dep_branch_name=add_inventory_stock_to_asset.department' +no+ '&number=' +no+ '&is_function=1</cfoutput>','list','popup_list_departments');
	else
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_departments&field_id=add_inventory_stock_to_asset.department_id_2_' +no+ '&field_dep_branch_name=add_inventory_stock_to_asset.department2_' +no+ '</cfoutput>','list','popup_list_departments');
}

function change_depot(no)
{
	eval('add_inventory_stock_to_asset.department_id_2_'+no).value = eval('add_inventory_stock_to_asset.department_id'+no).value;
	eval('add_inventory_stock_to_asset.department2_'+no).value = eval('add_inventory_stock_to_asset.department'+no).value;
}

function hesapla2()
{
	//Onceki marka degerlerini bosaltmak icin
	document.add_inventory_stock_to_asset.brand_id.value = '';
	document.add_inventory_stock_to_asset.brand_type_id.value = '';
	document.add_inventory_stock_to_asset.brand_type_cat_id.value = ''; 
    document.add_inventory_stock_to_asset.brand_name.value = '';
    document.add_inventory_stock_to_asset.assetp_sub_catid.value = '';
	
	x = document.add_inventory_stock_to_asset.assetp_catid.selectedIndex;
	if(x != '')
	{
		deger_motorized_vehicle = list_getat(document.add_inventory_stock_to_asset.assetp_catid[x].value,2,';');
		deger_it_asset = list_getat(document.add_inventory_stock_to_asset.assetp_catid[x].value,3,';');

		if(deger_motorized_vehicle == 1) document.add_inventory_stock_to_asset.select_list.value = 2;
		else if (deger_it_asset == 1) document.add_inventory_stock_to_asset.select_list.value = 3;
		else document.add_inventory_stock_to_asset.select_list.value = 1;		
    }
    for ( var i= $("#assetp_sub_catid option").length-1 ; i>-1 ; i--)
    {
        $('#assetp_sub_catid option')[i].remove();
            
    }
    var asset_id =  $("#assetp_catid").val();
    asset_id = asset_id.split(';');
    var sql = 'SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = ' + asset_id[0] ;
    get_assetp_sub_cat = wrk_query(sql,'dsn');
    if(get_assetp_sub_cat.recordcount > 0)
    {
        var selectBox = $("#assetp_sub_catid").attr('disabled');
        if(selectBox) $("#assetp_sub_catid").removeAttr('disabled');
        $("#assetp_sub_catid").append($("<option></option>").attr("value", '').text( "Seçiniz !" ));
        for(i = 1;i<=get_assetp_sub_cat.recordcount;++i)
        {
            $("#assetp_sub_catid").append($("<option></option>").attr("value", get_assetp_sub_cat.ASSETP_SUB_CATID[i-1]).text(get_assetp_sub_cat.ASSETP_SUB_CAT[i-1]));
        }
    }   
}

function kontrol()
{
	<cfif x_control_fixtures_no eq 1>
		<cfif get_assets.recordcount>
			if(document.add_inventory_stock_to_asset.inventory_number.value != '')
				if(!paper_control(add_inventory_stock_to_asset.inventory_number,'FIXTURES','1',<cfoutput>'#listgetat(get_assets.assetp_id,1)#','#get_inventory.inventory_number#','','','','#dsn#</cfoutput>')) return false;
		<cfelse>
			if(!paper_control(add_inventory_stock_to_asset.inventory_number,'FIXTURES',true,'','','','','','<cfoutput>#dsn#</cfoutput>')) return false;
		</cfif>
	</cfif>
	a = document.add_inventory_stock_to_asset.assetp_catid.selectedIndex;
	if (document.add_inventory_stock_to_asset.assetp_catid[a].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='56922.Varlık Tipi Seçiniz'> ! ");
		return false;
	}
	<cfif xml_brand_type eq 1>
	if(document.add_inventory_stock_to_asset.brand_name.value == "")
	{
		alert("<cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='56921.Marka Tipi Girmelisiniz'> !");
		return false;
	}
	</cfif>

	<cfif xml_make_year eq 1>
	t = document.add_inventory_stock_to_asset.make_year.selectedIndex;
	if (document.add_inventory_stock_to_asset.make_year[t].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='56920.Lütfen Model Seçiniz'> !");
		return false;
	}
	</cfif>
	
	if(document.add_inventory_stock_to_asset.company_name.value =="" && document.add_inventory_stock_to_asset.partner_name.value =="" )
	{
		alert("<cf_get_lang dictionary_id='56919.Alınan Firma Şeçmelisiniz'> !");
		return false;
	}	
	
	if(document.add_inventory_stock_to_asset.start_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='56918.Alış Tarihi Girmelisiniz'> !");
		return false;
	}
	<cfif xml_count_control eq 1>
		tt = document.getElementById('row_number').value;
	<cfelse>
		tt = <cfoutput>#get_inventory.quantity#</cfoutput>
	</cfif>
	for(r=1;r<=tt;r++)
	{
		deger_assetp = eval("document.add_inventory_stock_to_asset.assetp"+r);
		deger_department_id = eval("document.add_inventory_stock_to_asset.department_id"+r);
		deger_position_code = eval("document.add_inventory_stock_to_asset.position_code"+r);
		
		{
			if(deger_assetp.value == "")
			{
				alert("<cf_get_lang dictionary_id='56917.Lütfen Varlık Adı Giriniz'> ! ");
				return false;
			}
			
			if(deger_position_code.value == "")
			{
				alert("<cf_get_lang dictionary_id='56914.Lütfen Sorumlu Seçiniz'> ! ");
				return false;
			}			
			
			if(deger_department_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='56913.Kayıtlı Şube Seçmelisiniz'> ! ");
				return false;
			}
		}
	}

	return true;
}
	var add_asset=<cfif isdefined("get_assets")><cfoutput>#get_assets.recordcount#</cfoutput><cfelse>1</cfif>;
	function del_asset(count){
			var my_row = document.getElementById('del_asset_'+count);
			my_row.value=0;
			var my_row=document.getElementById('asset_info_'+count);
			add_asset--;
			my_row.style.display="none";
			document.getElementById('row_number').value = parseInt(document.getElementById('row_number').value) -1 ;
	}
	<cfif len(get_inventory.quantity)>
	quantity = <cfoutput>#get_inventory.quantity#</cfoutput>;
	<cfelse>
	quantity = 0;
	</cfif>
	function add_row(del_asset_,assetp,barcode,serial_number,assetp_group,usage_purpose,position_code,emp_id,employee_name,department_id,department,department_id_2_,department2_,status)
	{
		if(del_asset_==undefined) del_asset_=1;
		if(assetp==undefined) assetp="";
		if(barcode==undefined) barcode="";
		if(serial_number==undefined) serial_number="";
		if(assetp_group==undefined) assetp_group="";
		if(usage_purpose==undefined) usage_purpose="";
		if(position_code==undefined) position_code="";
		if(emp_id==undefined) emp_id="";
		if(employee_name==undefined) employee_name="";
		if(department_id==undefined) department_id="";
		if(department==undefined) department="";
		if(department_id_2_==undefined) department_id_2_="";
		if(department2_==undefined) department2_="";
		if(status==undefined) status="";
		
		add_asset++;
		if(add_asset > quantity)
		{
			alert('Satır Sayısı Miktardan Fazla');
			return false;	
		}
		document.getElementById('add_asset').value=add_asset;
		var newRow;
		var newCell;
		newRow = document.getElementById("asset_body").insertRow(document.getElementById("asset_body").rows.length);
		newRow.setAttribute("name","asset_info_" + add_asset);
		newRow.setAttribute("id","asset_info_" + add_asset);
		document.getElementById('row_number').value=add_asset;

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" value="1" id="del_asset_'+ add_asset +'" name="del_asset_'+ add_asset +'"><a style="cursor:pointer" onclick="del_asset('+ add_asset + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a><a style="cursor:pointer" onclick="copy_row('+add_asset+');"title="<cf_get_lang dictionary_id="58972.Satır Kopyala">"><i class="fa fa-copy"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="assetp'+add_asset+'" id="assetp'+add_asset+'" value="<cfoutput>#get_inventory.inventory_name#</cfoutput>" maxlength="100" style="width:100px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="barcode'+add_asset+'" id="barcode'+add_asset+'" value="'+barcode+'" style="width:85px;" onKeyUp="isNumber(this)" maxlength="50" />&nbsp;<cfif is_auto_barcode eq 0><a href="javascript://" onclick="document.add_inventory_stock_to_asset.barcode'+add_asset+'.value=<cfoutput>#get_barcode_no()#</cfoutput>"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="Otomatik Barkod" align="absbottom"></a><cfelse><a href="javascript://" onclick="document.add_inventory_stock_to_asset.barcode'+add_asset+'.value=<cfoutput>#get_barcode_no(1)#</cfoutput>"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang dictionary_id="46805.Otomatik Barkod" align="absbottom"></a></cfif>';
<!---		newCell.innerHTML += '<cfif is_auto_barcode eq 0><a href="javascript://" onclick="document.add_inventory_stock_to_asset.barcode'+add_asset+'.value=<cfoutput>#get_barcode_no()#</cfoutput>"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang no="927.Otomatik barkod"> !" align="absbottom"></a><cfelse><a href="javascript://" onclick="document.add_inventory_stock_to_asset.barcode'+add_asset+'.value='<cfoutput>#get_barcode_no(1)#</cfoutput>'"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang no="927.Otomatik barkod">" align="absbottom"></a></cfif>';--->
		<!--- <cfif is_auto_barcode eq 0><a href="javascript://" onclick="document.add_inventory_stock_to_asset.barcode#currentrow#.value='<cfoutput>#get_barcode_no()#</cfoutput>'"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang no="927.Otomatik barkod"> !" align="absbottom"></a><cfelse><a href="javascript://" onclick="javascript:document.add_inventory_stock_to_asset.barcode'+add_asset+'.value='<cfoutput>#get_barcode_no(1)#</cfoutput>'"><img src="/images/plus_thin.gif" border="0" id="barcode_image" title="<cf_get_lang no="927.Otomatik barkod">" align="absbottom"></a></cfif>'--->
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="serial_number'+add_asset+'" id="serial_number'+add_asset+'" value="'+serial_number+'" maxlength="50" style="width:80px">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		b = '<select name="assetp_group'+add_asset+'" id="assetp_group'+add_asset+'" style="width:100px;"><option value=""><cf_get_lang dictionary_id ="57734.Seçiniz"></option>';
		<cfoutput query="get_assetp_groups">
			if('#group_id#' == assetp_group)
				b += '<option value="#group_id#" selected>#group_name#</option>';
			else
				b += '<option value="#group_id#">#group_name#</option>';
		</cfoutput>
		newCell.innerHTML =b+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		a = '<select name="usage_purpose'+add_asset+'" id="usage_purpose'+add_asset+'" style="width:100px;"><option value=""><cf_get_lang dictionary_id ="57734.Seçiniz"></option>';
		<cfoutput query="get_purpose">
			if('#usage_purpose_id#' == usage_purpose)
				a += '<option value="#usage_purpose_id#" selected>#usage_purpose#</option>';
			else
				a += '<option value="#usage_purpose_id#">#usage_purpose#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" name="position_code'+add_asset+'" id="position_code'+add_asset+'" value="'+position_code+'"><input type="hidden" name="emp_id'+add_asset+'" id="emp_id'+add_asset+'" value="'+emp_id+'"><input type="text" name="employee_name'+add_asset+'" id="employee_name'+add_asset+'" value="'+employee_name+'" readonly style="width:114px;"> <a href="javascript://" onClick="pencere_ac_position('+add_asset+');"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id="57544.Sorumlu">" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" name="department_id'+add_asset+'" id="department_id'+add_asset+'" value="'+department_id+'"><input type="text" name="department'+add_asset+'" id="department'+add_asset+'" value="'+department+'" readonly style="width:114px;"> <a href="javascript://" onClick="pencere_ac_department('+add_asset+',1);"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id="56924.Kayıtlı Şube">" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" name="department_id_2_'+add_asset+'" id="department_id_2_'+add_asset+'" value="'+department_id_2_+'"><input type="text" name="department2_'+add_asset+'" id="department2_'+add_asset+'" value="'+department2_+'" readonly style="width:114px;"> <a href="javascript://" onClick="pencere_ac_department('+add_asset+',2);"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id="56923.Kullanıcı Şube">" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		c = '<select name="status'+add_asset+'" id="status'+add_asset+'" style="width:100px"><option value=""><cf_get_lang dictionary_id ="57734.Seçiniz"></option>';
		<cfoutput query="get_asset_state">
			if('#asset_state_id#' == status)
				c += '<option value="#asset_state_id#" selected>#asset_state#</option>';
			else
				c += '<option value="#asset_state_id#">#asset_state#</option>';
		</cfoutput>
		newCell.innerHTML =c+ '</select>';
		
	}
	
	function copy_row(no_info)
	{
		if (document.getElementById("del_asset_" + no_info) == undefined) del_asset_ =""; else del_asset_ = document.getElementById("del_asset_" + no_info).value;
		if (document.getElementById("assetp" + no_info) == undefined) assetp =""; else assetp = document.getElementById("assetp" + no_info).value;
		if (document.getElementById("barcode" + no_info) == undefined) barcode =""; else barcode = document.getElementById("barcode" + no_info).value;
		if (document.getElementById("serial_number" + no_info) == undefined) serial_number =""; else serial_number = document.getElementById("serial_number" + no_info).value;
		if (document.getElementById("assetp_group" + no_info) == undefined) assetp_group =""; else assetp_group = document.getElementById("assetp_group" + no_info).value;
		if (document.getElementById("usage_purpose" + no_info) == undefined) usage_purpose =""; else usage_purpose = document.getElementById("usage_purpose" + no_info).value;
		if (document.getElementById("position_code" + no_info) == undefined) position_code =""; else position_code = document.getElementById("position_code" + no_info).value;
		if (document.getElementById("emp_id" + no_info) == undefined) emp_id =""; else emp_id = document.getElementById("emp_id" + no_info).value;
		if (document.getElementById("employee_name" + no_info) == undefined) employee_name =""; else employee_name = document.getElementById("employee_name" + no_info).value;
		if (document.getElementById("department_id" + no_info) == undefined) department_id =""; else department_id = document.getElementById("department_id" + no_info).value;
		if (document.getElementById("department" + no_info) == undefined) department =""; else department = document.getElementById("department" + no_info).value;
		if (document.getElementById("department_id_2_" + no_info) == undefined) department_id_2_ =""; else department_id_2_ = document.getElementById("department_id_2_" + no_info).value;
		if (document.getElementById("department2_" + no_info) == undefined) department2_ =""; else department2_ = document.getElementById("department2_" + no_info).value;
		if (document.getElementById("status" + no_info) == undefined) status =""; else status = document.getElementById("status" + no_info).value;
		add_row(del_asset_,assetp,barcode,serial_number,assetp_group,usage_purpose,position_code,emp_id,employee_name,department_id,department,department_id_2_,department2_,status);
 }
function fill_department(no)
{
	$('#department_id'+no).val("");
	$('#department_id_2_'+no).val("");
	$('#department'+no).val("");
	$('#department2_'+no).val("");
	var member_id=$('#position_code'+no).val();
	if(member_id!='')
	{
		get_department= wrk_safe_query('get_department_employee','dsn',0,member_id);
		if($('#get_department.DEPARTMENT_ID')!='' && get_department.recordcount)
		{
			$('#department_id'+no).val(get_department.DEPARTMENT_ID);
			$('#department_id_2_'+no).val(get_department.DEPARTMENT_ID);
			$('#department'+no).val(get_department.DEPARTMENT_HEAD +'-'+get_department.BRANCH_NAME);
			$('#department2_'+no).val(get_department.DEPARTMENT_HEAD +'-'+get_department.BRANCH_NAME);
		}
	}
}
</script>
