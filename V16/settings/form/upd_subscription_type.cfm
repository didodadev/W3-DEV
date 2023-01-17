<cfquery name="GET_SUBSCRIPTION_TYPE" datasource="#DSN3#">
    SELECT 
        SUBSCRIPTION_TYPE_ID,
        #dsn#.Get_Dynamic_Language(SUBSCRIPTION_TYPE_ID,'#session.ep.language#','SETUP_SUBSCRIPTION_TYPE','SUBSCRIPTION_TYPE',NULL,NULL,SUBSCRIPTION_TYPE) AS SUBSCRIPTION_TYPE,
        PRODUCT_ID,
        STOCK_ID,
        ICON_COLOR,
        ICON_FILE,
        RECORD_DATE,
        RECORD_EMP,
        UPDATE_DATE,
        UPDATE_EMP
     FROM 
         SETUP_SUBSCRIPTION_TYPE 
     WHERE 
         SUBSCRIPTION_TYPE_ID = #attributes.subscription_type_id#
</cfquery>
<cfquery name="GET_PRO_PERM" datasource="#DSN3#">
    SELECT STATUS,PARTNER_ID, POSITION_CODE,POSITION_CAT FROM SUBSCRIPTION_GROUP_PERM WHERE SUBSCRIPTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subscription_type_id#">
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Abone Kategorileri','42255')#" add_href="#request.self#?fuseaction=settings.add_subscription_type" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <cfinclude template="../display/list_subscription_type.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="subs_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_subscription_type" enctype="multipart/form-data">
                <input type="hidden" name="subscription_type_id" id="subscription_type_id" value="<cfoutput>#get_subscription_type.subscription_type_id#</cfoutput>">
                <!--- <input type="hidden" name="subscription_type2" id="subscription_type2" value="<cfoutput>#get_subscription_type.subscription_type#</cfoutput>"> --->
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-subscription_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfinput type="text" name="subscription_type" id="subscription_type" value="#get_subscription_type.subscription_type#" maxlength="43" required="yes" message="#getLang('','Kategori Adı Girmelisiniz',58555)#!">
                                    <span class="input-group-addon">
                                        <cf_language_info
                                            table_name="SETUP_SUBSCRIPTION_TYPE"
                                            column_name="SUBSCRIPTION_TYPE"
                                            column_id_value="#subscription_type_id#"
                                            maxlength="500"
                                            datasource="#dsn3#" 
                                            column_id="SUBSCRIPTION_TYPE_ID" 
                                            control_type="2">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-product_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="input-group">
                                    <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#GET_SUBSCRIPTION_TYPE.STOCK_ID#</cfoutput>">
                                    <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#GET_SUBSCRIPTION_TYPE.PRODUCT_ID#</cfoutput>">
                                    <input type="text" name="product_name" id="product_name" value="<cfif len(GET_SUBSCRIPTION_TYPE.STOCK_ID)><cfoutput>#get_product_name(stock_id:GET_SUBSCRIPTION_TYPE.STOCK_ID)#</cfoutput></cfif>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','200');">
                                    <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=subs_type.stock_id&product_id=subs_type.product_id&&field_name=subs_type.product_name');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-system_icon_color">
                            <!--- Aboneler Haritasında gozuken ikonların rengini secmek icin konuldu --->
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45111.Renk'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cf_workcube_color_picker name="system_icon_color" value="#GET_SUBSCRIPTION_TYPE.ICON_COLOR#">
                            </div>
                        </div>
                        <div class="form-group" id="item-subs_icon_file">
                            <!--- Aboneler haritasında gozuken ikonlar --->
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58029.İkon'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfif len(get_subscription_type.ICON_FILE)>
                                    <div class="input-group">
                                        <input type="hidden" name="old_icon" id="old_icon" value="<cfoutput>#get_subscription_type.ICON_FILE#</cfoutput>">
                                        <cfinput type="file" name="subs_icon_file" id="subs_icon_file" value="">
                                        <span class="input-group-addon"  href="javascript://" onClick="windowopen('<cfoutput>#file_web_path#settings/#get_subscription_type.ICON_FILE#</cfoutput> ','medium');"><i class="fa fa-image"></i></span>
                                    </div>
                                <cfelse>
                                    <input type="file" name="subs_icon_file" id="subs_icon_file">
                                </cfif>
                                <cfif len(get_subscription_type.ICON_FILE)>
                                    <div class="col col-12">
                                        <label><cf_get_lang dictionary_id='62847.İkonu Sil'><input type="checkbox" name="del_icon" id="del_icon" value="1" /></label>
                                    </div>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                        <div class="form-group col col-8" id="item-gizli1">
                            <cf_workcube_to_cc 
                            is_update="1" 
                            to_dsp_name="#getLang('','Yetkili Pozisyonlar',42683)#" 
                            form_name="subs_type" 
                            str_list_param="1,2" 
                            action_dsn="#DSN3#"
                            str_action_names = "PARTNER_ID TO_PAR,POSITION_CODE TO_POS_CODE"
                            str_alias_names = "TO_PAR,TO_POS_CODE"
                            action_table="SUBSCRIPTION_GROUP_PERM"
                            action_id_name="SUBSCRIPTION_TYPE_ID"
                            data_type="2"
                            action_id="#attributes.subscription_type_id#">
                        </div>
                        <div class="form-group col col-8" id="item-gizli2">
                            <cf_flat_list>
                                <thead>
                                    <tr>
                                        <th class="text-center" width="20"> 
                                            <input type="hidden" name="position_cats" id="position_cats" value="<cfoutput>#ListSort(ValueList(GET_PRO_PERM.POSITION_CAT),'numeric')#</cfoutput>">
                                            <a href="javascript://" class="tableyazi" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=subs_type.position_cats&field_td=td_yetkili2</cfoutput>','list');"><i class="fa fa-plus"></i></a>        
                                        </th>
                                        <th><cf_get_lang dictionary_id='38005.Yetkili Pozisyon Tipleri'></th>
                                    </tr>
                                </thead>
                                <tbody id="td_yetkili2">
                                    <cfquery name="get_status_cats" datasource="#dsn#">
                                        SELECT SC.POSITION_CAT,SC.POSITION_CAT_ID FROM #dsn3#.SUBSCRIPTION_GROUP_PERM,SETUP_POSITION_CAT SC WHERE SC.POSITION_CAT_ID = SUBSCRIPTION_GROUP_PERM.POSITION_CAT AND SUBSCRIPTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.subscription_type_id#">
                                    </cfquery>
                                    <cfif get_status_cats.recordcount>
                                        <cfoutput query="get_status_cats">
                                            <input type="hidden" name="status_#position_cat_id#" id="status_#position_cat_id#" value="1">
                                            <tr id="tr_#position_cat_id#">
                                                <td class="text-center" width="20"><a href="javascript://" class="tableyazi" onclick="del_pos_cat(#position_cat_id#);"><i class="fa fa-minus"></i></a><br/></td>
                                                <td>#position_cat#</td>
                                            </tr>
                                        </cfoutput>
                                    </cfif>
                                 </tbody>        
                            </cf_flat_list>
                        </div>
                    </div>
                </cf_box_elements>
                <div class="col col-12">
                    <cf_box_footer>
                        <cf_record_info query_name="get_subscription_type">
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()">
                    </cf_box_footer>
                </div>
            </cfform>
        </div>
    </cf_box>
</div>
<script language="javascript">
	function del_pos_cat(pos_cat_id)
	{	
		document.getElementById('status_'+pos_cat_id).value = 0;
		document.getElementById('tr_'+pos_cat_id).style.display = 'none';
	}
    function kontrol()
	{	
		if (document.getElementById('subscription_type2').value = '');
        {
		alert("Vergi Kodu Seçiniz !");
            return false;
        }
	}

</script>

      
