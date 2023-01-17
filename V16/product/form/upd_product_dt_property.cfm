<cf_xml_page_edit fuseact="product.popup_form_upd_product_dt_property">
    <!--- Guncellemede, kategoriye yeni bir ozellik eklendiginde buraya gelmiyordu, bu sekilde , olmayanlarin gelmesi seklinde unionli bir duzenleme yapildi fbs 20100624 --->
    <cfquery name="GET_PROPERTY" datasource="#DSN1#">
        SELECT
            PDP.PRODUCT_DT_PROPERTY_ID,
            PDP.VARIATION_ID,
            #dsn#.#dsn#.Get_Dynamic_Language(PDP.PRODUCT_DT_PROPERTY_ID,'#ucase(session.ep.language)#','PRODUCT_DT_PROPERTIES','DETAIL',NULL,NULL,PDP.DETAIL) AS DETAIL,
            PDP.IS_EXIT,
            PDP.TOTAL_MIN,
            PDP.TOTAL_MAX,
            S.STOCK_ID,
            S.PRODUCT_NAME,
            PDP.PRODUCT_PROPERTY_ID,
            PDP.AMOUNT,
            PDP.RECORD_DATE,
            PDP.RECORD_EMP,
            PDP.UPDATE_EMP,
            PDP.UPDATE_DATE,
            PDP.IS_OPTIONAL,
            PDP.IS_INTERNET,
            PDP.LINE_VALUE,
            PDP.PROPERTY_ID,
            #dsn#.#dsn#.Get_Dynamic_Language(PDP.PROPERTY_ID,'#ucase(session.ep.language)#','PRODUCT_PROPERTY','PROPERTY',NULL,NULL,PP.PROPERTY) AS PROPERTY
            <cfif IsDefined("xml_auto_product_code_2") and xml_auto_product_code_2 eq 0>
            ,PPD.PRPT_ID,
            PPD.PROPERTY_DETAIL_ID, 
            PPD.PROPERTY_DETAIL
            </cfif>
        FROM
            PRODUCT_DT_PROPERTIES PDP
            LEFT JOIN #DSN3#.STOCKS AS S ON  PDP.PRODUCT_PROPERTY_ID = S.STOCK_ID 
            LEFT JOIN PRODUCT_PROPERTY PP ON PDP.PROPERTY_ID = PP.PROPERTY_ID
            <cfif IsDefined("xml_auto_product_code_2") and xml_auto_product_code_2 eq 0>
            LEFT JOIN PRODUCT_PROPERTY_DETAIL PPD ON PDP.VARIATION_ID =PPD.PROPERTY_DETAIL_ID
            </cfif>
        WHERE
            PDP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">     
        ORDER BY LINE_VALUE    
    </cfquery>
   
    <cfquery name="GET_PROPERTY_VARIATION" datasource="#DSN1#">
        SELECT PRPT_ID,PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID IN (#ValueList(get_property.property_id)#) ORDER BY PROPERTY_DETAIL
    </cfquery>
    
    <cfparam name="attributes.modal_id" default=""> 
    <cfparam name="attributes.draggable" default="0"> 
    <cf_box title="#getLang('','Ürün Özellikleri',37408)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="upd_related_features" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_product_dt_property">
            <input  type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
            <input type="hidden" name="auto_product_code_2" id="auto_product_code_2" value="<cfoutput>#xml_auto_product_code_2#</cfoutput>">
            <input type="hidden" name="draggable" id="draggable" value="<cfoutput>#attributes.draggable#</cfoutput>">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="120"><cf_get_lang dictionary_id='57632.Özellik'></th>
                        <th width="120"><cf_get_lang dictionary_id='37249.Varyasyon'></th>
                        <cfif isdefined("xml_product_connect") and xml_product_connect eq 1>
                            <th width="130"><cf_get_lang dictionary_id='57657.Ürün'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                        <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th  width="150"><cf_get_lang dictionary_id='37250.Değer'></th>
                        <th  width="60"><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th  width="20"><cf_get_lang dictionary_id='37171.Input'></th>
                        <th  width="20"><cf_get_lang dictionary_id='37100.Output'></th>
                        <th  width="20"><cf_get_lang dictionary_id='37172.Web'></th>
                        <th width="20"><a title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="pencere_pos_kontrol();"><i class="fa fa-plus"></i></a><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_property.recordcount#</cfoutput>"></th>
                    </tr>
                </thead>
                <tbody name="table1" id="table1">
                <cfoutput query="get_property">
                    <cfif Len(get_property.record_date)>
                        <cfset record_date_ = dateformat(get_property.record_date,dateformat_style)>
                        <cfset record_emp_ = get_emp_info(get_property.record_emp,0,0)>
                    </cfif>
                    <cfquery name="GET_VARIATION" dbtype="query">
                        SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM GET_PROPERTY_VARIATION WHERE PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_property.property_id#"> ORDER BY PROPERTY_DETAIL
                    </cfquery>
                    <tr id="frm_row#currentrow#">
                        <td>
                            <div class="form-group">
                                <div class="input-group">
                                    <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                    <input type="text" name="property#currentrow#" id="property#currentrow#" value="#property#">
                                    <input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#property_id#">
                                    <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_pos('#currentrow#');" title="<cf_get_lang dictionary_id ='58201.Ozellik Seç'>"></span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group">
                                <cfif xml_auto_product_code_2 eq 1>
                                    <select name="variation_id#currentrow#" id="variation_id#currentrow#">
                                        <option value=""><cf_get_lang dictionary_id='37249.Varyasyon'></option>
                                        <cfloop query="get_variation">
                                            <option value="#property_detail_id#" <cfif get_property.variation_id eq property_detail_id>selected</cfif>>#property_detail#</option>
                                        </cfloop>
                                    </select>
                                <cfelse>
                                    <!--- <cfquery name="GET_VARIATION_POPUP" dbtype="query">
                                        SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM GET_PROPERTY_VARIATION WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_property.variation_id#"> ORDER BY PROPERTY_DETAIL
                                    </cfquery>--->
                                    <div class="input-group">
                                        <input type="hidden" name="variation_id#currentrow#" id="variation_id#currentrow#" value="#get_property.variation_id#">
                                        <input type="text" name="variation#currentrow#" id="variation#currentrow#" value="#get_property.PROPERTY_DETAIL#">
                                        <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="select_var('#currentrow#');"  title="<cf_get_lang dictionary_id='33615.Varyasyon'> "></span>
                                    </div>
                                </cfif>
                            </div>
                        </td>
                        <cfif isdefined("xml_product_connect") and xml_product_connect eq 1>
                            <td>
                                <div class="form-group">
                                    <div class="input-group">
                                        <input type="hidden" name="product_property_id#currentrow#" id="product_property_id#currentrow#" value="#product_property_id#">
                                        <input type="text" name="product_property#currentrow#" id="product_property#currentrow#" value="#PRODUCT_NAME#">
                                        <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_product_property('#currentrow#');" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
                                    </div>
                                </div>
                            </td>
                        </cfif>
                        <td>
                            <div class="form-group">
                                <div class="input-group">
                                    <input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#detail#" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cf_get_lang dictionary_id ='37038.Açıklama Alanına En Fazla 300 Karakter Girilebilir'>!">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                            table_name="PRODUCT_DT_PROPERTIES" 
                                            column_name="DETAIL" 
                                            column_id_value="#PRODUCT_DT_PROPERTY_ID#" 
                                            maxlength="500" 
                                            datasource="#DSN1#" 
                                            column_id="PRODUCT_DT_PROPERTY_ID" 
                                            control_type="0">
                                    </span>
                                </div> 
                            </div>                        
                        </td>
                        <td><div class="form-group"><input type="text" name="line_row#currentrow#" id="line_row#currentrow#" value="#line_value#" class="moneybox" maxlength="2" onKeyup="return(FormatCurrency(this,event));"></div></td>
                        <td nowrap="nowrap">
                            <div class="form-group">
                                <div class="col col-6 pl-0">
                                    <input type="text" name="total_min#currentrow#" id="total_min#currentrow#" onKeyup="return(FormatCurrency(this,event));" value="#tlformat(total_min,2)#" maxlength="10">/
                                </div>
                                <div class="col col-6 pr-0">
                                    <input type="text" name="total_max#currentrow#" id="total_max#currentrow#" maxlength="10" value="#tlformat(total_max,2)#" onKeyup="return(FormatCurrency(this,event));" >
                                </div>
                            </div>
                        </td>
                        <td><div class="form-group"><input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#tlformat(amount,2)#" onKeyup="return(FormatCurrency(this,event));" class="moneybox" maxlength="10"></div></td>
                        <td><div class="form-group"><input type="checkbox" name="is_optional#currentrow#" id="is_optional#currentrow#" <cfif is_optional eq 1>checked</cfif>></div></td>
                        <td><div class="form-group"><input type="checkbox" name="is_exit#currentrow#" id="is_exit#currentrow#" <cfif is_exit eq 1>checked</cfif>></div></td>
                        <td><div class="form-group"><input type="checkbox" name="is_internet#currentrow#" id="is_internet#currentrow#" <cfif is_internet eq 1>checked</cfif>></div></td>
                        <td><a onclick="sil('#currentrow#');"><i class="fa fa-minus"></i></a></td>
                    </tr>
                </cfoutput>
                </tbody>
            </cf_grid_list>
            <div class="ui-info-bottom">
                <div class="col col-6">
                    <cf_record_info query_name="get_property">
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons is_upd='1' type_format='1' add_function="kontrol()" is_delete='0' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_product_dt_property&product_id=#attributes.pid#'>
                </div>
            </div>
        </cfform>
    </cf_box>
    <script type="text/javascript">
        row_count=<cfoutput>#get_property.recordcount#</cfoutput>;
        function sil(sy)
        {
            var my_element=eval("upd_related_features.row_kontrol"+sy);
            my_element.value=0;
            $("#table1 #frm_row"+sy).css("display", "none");
        }
        function pencere_pos(no)
        {
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_product_properties&property=upd_related_features.property' + no + '&property_id=upd_related_features.property_id' + no + '&is_select=1&is_product_property=1&value_deger='+no);
        }
        function select_var(crntrw)
        {
            <cfoutput>
                windowopen('#request.self#?fuseaction=product.popup_list_variations_property&property_id=' + eval('document.getElementById("property_id' + crntrw + '")').value + '&record_num_value=' + crntrw + '','list'); 
            </cfoutput>
        }
        function pencere_product_property(no)
        {
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_related_features.product_property_id' + no + '&field_name=upd_related_features.product_property' + no );
        }
	
        function fillVariation(no)
        {
            $("#variation_id"+no).empty();
            var listParam = $("#property_id"+no).val();
            var columns = wrk_safe_query('variation control','DSN1',0,listParam);
            $("#variation_id"+no).append('<option value=""><cf_get_lang dictionary_id="37249.Varyasyon"></option>');
            if(columns.recordcount)
            {
                for ( var i = 0; i < columns.recordcount; i++ ) {
                $("#variation_id"+no).append('<option value='+columns.PROPERTY_DETAIL_ID[i]+'>'+columns.PROPERTY_DETAIL[i]+'</option>');
                }
            }
        }
        function pencere_pos_kontrol()
        {
            <cfoutput>
                openBoxDraggable('#request.self#?fuseaction=product.popup_product_properties<cfif xml_auto_product_code_2 eq 0>&xml_auto_product_code_2=0</cfif>&form_name=upd_related_features&product_id='+#attributes.pid#+'&record_num_value=' + upd_related_features.record_num.value);
            </cfoutput>
        }
        function kontrol()
        {
            if(upd_related_features.record_num.value == "")
            {
                alert("<cf_get_lang dictionary_id ='37173.Lütfen Satir Giriniz'> !");
                return false;
            }
            for (var r=1;r<=upd_related_features.record_num.value;r++)
            {
                eval('upd_related_features.line_row'+r).value = filterNum(eval('upd_related_features.line_row'+r).value);
                eval('upd_related_features.amount'+r).value = filterNum(eval('upd_related_features.amount'+r).value);
                eval('upd_related_features.total_max'+r).value = filterNum(eval('upd_related_features.total_max'+r).value);
                eval('upd_related_features.total_min'+r).value = filterNum(eval('upd_related_features.total_min'+r).value);
            }
            <cfif isDefined("attributes.draggable")>
                loadPopupBox('upd_related_features' , <cfoutput>#attributes.modal_id#</cfoutput>);
            </cfif>
            return false;
        }
    </script>
    