<cfparam name="attributes.q_id_list" default="">
<cfparam name="attributes.is_sample" default="">
<cfparam name="attributes.is_upd" default="">
<cfparam name="attributes.is_reload" default="">
<cfparam name="attributes.product_sample_id" default="">
<cfparam name="attributes.refinery_lab_test_id" default="">
<cfparam name="get_q_sub_types.recordCount" default="">
<cfparam name="get_report_content.REPORT_CONTENT" default="">
<!---Laboratuvar İşlemi Numuneden geldiyse Ürün ve Ürün Kategorisinde tanımlı test ve parametreler gelir. (Yalnızca add eventinde)
Upd eventinde REFINERY_LAB_TESTS tablosunda kayıtlı test ve parametreler gelir. (Çünkü add eventinde bu parametreler REFINERY_LAB_TESTS tablosuna kaydolur.)
Bu değişiklik satır çoklanmalarını engellemek için yapıldı. (13.05.2022)
Hem add hem upd'de Yeni Tanım eklenebilir. --->

<!--- Add eventinde inputtan numune seçilirse --->
<cfif isDefined("attributes.p_sample_id")>
    <cfset attributes.product_sample_id =attributes.p_sample_id>
 </cfif>
<cfif len(attributes.product_sample_id)><cfset attributes.is_sample=1></cfif>
<cfif attributes.is_sample eq 1>
    <cfset getLabTestRow = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sample_analysis").getLabTestRow(
		refinery_lab_test_id: attributes.refinery_lab_test_id
    ) />
</cfif>
<cfif not isDefined("is_reload")>
    <cf_box_elements>
        <cfoutput>
            <a class="ui-wrk-btn ui-wrk-btn-extra" name="add_param" id="add_param" href="javascript://" onClick="add_params()">#getLang('','Tanım ve Prosedür Ekle','64139')#</a>
        </cfoutput>
        <script>
            function add_params() {
                <cfif (attributes.is_sample eq 1) or (attributes.is_upd eq 1)>
                    list= $("#parameter_id_list").val();
                <cfelse>
                    list= "";
                </cfif>
                openBoxDraggable('<cfoutput>#request.self#?fuseaction=lab.test_parameters&event=add&is_sample=#attributes.is_sample#&is_upd=#attributes.is_upd#&product_sample_id=#attributes.product_sample_id#&refinery_lab_test_id=#attributes.refinery_lab_test_id#</cfoutput>&parameter_id_list='+list+'','parameter');
            }
        </script>
    </cf_box_elements>
</cfif>

<div id="new_params">
    <cfif (attributes.is_sample eq 1) or (attributes.is_upd eq 1)>
        <cfinclude template="../../sample_analysis/display/upd_test_parameters.cfm">
    </cfif>
</div>
<cfquery name="get_product_quality_types" datasource="#dsn3#">
    SELECT 
    QT.TYPE_ID,
    QT.QUALITY_CONTROL_TYPE,
    QT.PROCESS_CAT_ID
    FROM 
        QUALITY_CONTROL_TYPE QT
    WHERE
        TYPE_ID IS NOT NULL
    GROUP BY 
    QT.TYPE_ID,
    QT.QUALITY_CONTROL_TYPE,
    QT.PROCESS_CAT_ID
</cfquery>
    <cfif len(attributes.q_id_list)>
        <cfset attributes.q_id_list = ListDeleteDuplicates(attributes.q_id_list)>
        <cfset main_type_ids=''>  
        <cfset sub_type_ids=''>    
        <cfloop from="1" to="#listLen(attributes.q_id_list,',')#" index="ind">
            <cfoutput>
                <cfset el_main_type = listGetAt(attributes.q_id_list,ind)>
                <cfset el_main_type_list = listGetAt(el_main_type,1,";")>
                <cfset main_type_ids = listappend(main_type_ids,el_main_type_list,",")>

                <cfset el_sub_type = listGetAt(attributes.q_id_list,ind)>
                <cfset el_sub_type_list = listGetAt(el_sub_type,2,";")>
                <cfset sub_type_ids = listappend(sub_type_ids,el_sub_type_list,",")>
            </cfoutput>
        </cfloop>
        <cfquery name="get_product_quality_types" datasource="#dsn3#">
            SELECT 
                QT.TYPE_ID,
                QT.QUALITY_CONTROL_TYPE
            FROM 
                QUALITY_CONTROL_TYPE QT
            WHERE
                TYPE_ID IS NOT NULL
                AND TYPE_ID in (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#main_type_ids#">)
            GROUP BY 
                QT.TYPE_ID,
                QT.QUALITY_CONTROL_TYPE
        </cfquery>
        <cfif get_product_quality_types.recordCount>
            <cfset current_row = 0>
            <cfif not len(attributes.is_upd) and attributes.is_sample eq 1>
                <cfset current_row = upd_current_row_2>
            </cfif>
            <cfset rowcount_ = 0>
            <cfloop query="get_product_quality_types">
                <cfquery name="get_quality_sub_cat" datasource="#dsn3#">
                    SELECT 
                        QR.QUALITY_ROW_DESCRIPTION TYPE_DESCRIPTION,
                        QR.SAMPLE_METHOD,
                        QR.SAMPLE_NUMBER,
                        QR.CONTROL_OPERATOR,
                        QR.QUALITY_VALUE,
                        QR.TOLERANCE,
                        QR.TOLERANCE_2,
                        QR.QUALITY_CONTROL_ROW_ID,
                        QR.QUALITY_CONTROL_ROW	QUALITY_CONTROL_TYPE,
                        QR.QUALITY_CONTROL_TYPE_ID,
                        QR.UNIT
                    FROM 
                        QUALITY_CONTROL_ROW QR
                    WHERE
                        QUALITY_CONTROL_TYPE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_quality_types.TYPE_ID#">
                        AND  QUALITY_CONTROL_ROW_ID in (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#sub_type_ids#">)
                </cfquery>
                <div class="ui-info-bottom">
                    <cfif isDefined('content_id') and len(content_id)>
                        <a  target="_blank" href="<cfoutput>#request.self#?fuseaction=content.list_content&event=det&cntid=#get_product_quality_types.content_id#</cfoutput>"><i class="fa fa-file-text" style="color:#DAA520" ></i></a>
                    <cfelse>
                        <a href="javascript://"><i class="fa fa-file-text" style="color:#C2B280"></i></a>
                    </cfif>
                    <cfoutput>
                        &nbsp<font color="red">#get_product_quality_types.quality_control_type#</font>
                    </cfoutput>
                </div>
                <div class="form-group">
                    <div class="checkbox checbox-switch">
                        <label class="checking">
                            <cfoutput>
                                <input type="checkbox" name="accepted_#currentrow#" id="accepted_#currentrow#" value="1" onchange="change_val('#currentrow#')"/>
                            </cfoutput>
                            <span></span>
                        </label>
                    </div>
                </div>
                <cf_grid_list id="list_#get_product_quality_types.currentrow#">
                    <thead>
                        <tr>
                            <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                            <th width="150"><cf_get_lang dictionary_id='64052.Parametre'></th>
                            <th width="100" class="text-center"><cf_get_lang dictionary_id='63477.Örneklem'></th>
                            <th width="100"><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th width="100" class="text-right"><cf_get_lang dictionary_id='52248.Alt Limit'></th>
                            <th width="100" class="text-right"><cf_get_lang dictionary_id='52249.Üst Limit'></th>
                            <th  width="100" class="text-right"><cf_get_lang dictionary_id='33137.Standart'><cf_get_lang dictionary_id='33616.Değer'></th>
                            <th width="25" class="text-center"><=></th>
                            <th><cf_get_lang dictionary_id='59085.Sonuç'></th>
                            <th>&nbsp</th>
                            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfset rowcount_ = rowcount_+ get_quality_sub_cat.recordcount>
                        <cfif get_quality_sub_cat.recordcount>
                            <cfset current_r= 0>
                            <cfoutput query="get_quality_sub_cat"> 
                                <cfset current_row = current_row + 1>
                                <tr>
                                    <td>
                                        <input type="hidden" class="q_row" name="q_row_accept_#current_row#" id="q_row_accept_#current_row#" value="">
                                        <input type="hidden" name="parameterId#current_row#" id="parameterId#current_row#" value="#QUALITY_CONTROL_ROW_ID#">
                                        <input type="hidden" name="groupId#current_row#" id="groupId#current_row#" value="#QUALITY_CONTROL_TYPE_ID#">
                                        #currentrow#
                                    </td>
                                    <td>#QUALITY_CONTROL_TYPE#</td>
                                    <td>
                                        <div class="form-group">
                                            <div class="col col-8">
                                                <cfif isDefined('sample_number')><input type="text" name="sample_number_#current_row#" id="sample_number_#current_row#" value="#TLFormat(sample_number)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/></cfif>
                                            </div>
                                            <div class="col col-4">
                                                <cfif isDefined('sample_method')>
                                                    <input type="text" name="samp" id="samp" value="<cfif sample_method eq 1>R<cfelseif sample_method eq 2>%<cfelseif sample_method eq 3>K</cfif>" title="<cfif sample_method eq 1><cf_get_lang dictionary_id='63293.Rastgele'><cfelseif sample_method eq 2><cf_get_lang dictionary_id='52250.Yüzde'><cfelseif sample_method eq 3><cf_get_lang dictionary_id='64043.Katlanarak'></cfif>">
                                                    <input type="hidden" name="sample_method_#current_row#" id="sample_method_#current_row#" value="#sample_method#">
                                                </cfif>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <div class="col col-8">
                                                <input type="text" name="amount_#current_row#" id="amount_#current_row#" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/>
                                            </div>
                                            <div class="col col-4">
                                                <cfif isDefined('unit')>
                                                    <input type="text" name="units" id="units" readonly value="<cfif unit eq 1>mg<cfelseif unit eq 2>gr <cfelseif unit eq 3>kg <cfelseif unit eq 4>mm³ <cfelseif unit eq 5>cm³ <cfelseif unit eq 6>m³ <cfelseif unit eq 7>ml <cfelseif unit eq 8>cl <cfelseif unit eq 9>lt </cfif>">
                                                    <input type="hidden" name="unit_#current_row#" id="unit_#current_row#" value="#unit#">
                                                </cfif>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-right"><input type="text" name="minLimit#current_row#" id="minLimit#current_row#" value="#TLFormat(TOLERANCE_2)#" class="moneybox"/></td>
                                    <td class="text-right"><input type="text" name="maxLimit#current_row#" id="maxLimit#current_row#" value="#TLFormat(TOLERANCE)#" class="moneybox"/></td>
                                    <td class="text-right"><input type="text" name="standart_value_#current_row#" id="standart_value_#current_row#" value="#TLFormat(QUALITY_VALUE)#" class="moneybox"/></td>
                                    <td>
                                        <select name="options#current_row#" id="options#current_row#" class="text-center"> 
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="1" <cfif isDefined('control_operator') and control_operator eq 1>selected</cfif>>=</option>
                                            <option value="2" <cfif isDefined('control_operator') and control_operator eq 2>selected</cfif>>></option>
                                            <option value="3" <cfif isDefined('control_operator') and control_operator eq 3>selected</cfif>><</option>
                                            <option value="4" <cfif isDefined('control_operator') and control_operator eq 4>selected</cfif>>=></option>
                                            <option value="5" <cfif isDefined('control_operator') and control_operator eq 5>selected</cfif>>=<</option>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="text" name="result_#current_row#" id="result_#current_row#" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
                                    </td>
                                    <td>
                                        <div class="checkbox checbox-switch">
                                            <label>
                                                <input type="checkbox" name="accept_#current_row#" id="accept_#current_row#" value="1"/>
                                                <span></span>
                                            </label>
                                        </div>
                                    </td>
                                    <td><input type="text" name="type_description_#current_row#" id="type_description_#current_row#" value="#TYPE_DESCRIPTION#" /></td>
                                </tr>
                            </cfoutput>
                        </cfif>
                    </tbody>
                </cf_grid_list>
                <cfif get_q_sub_types.recordcount eq 0>
                    <div class="ui-info-bottom">
                        <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</p>
                    </div>
                </cfif>
            </cfloop>
            <cfif len(attributes.is_upd) or (not len(attributes.is_upd) and not len(attributes.is_sample))>
                <cfoutput>
                    <input type="hidden" name="rowcount_" id="rowcount_" value="#rowcount_#">
                </cfoutput>
            </cfif>
        </cfif>
    </cfif>
    <!--- Numune add parameter --->
    <cfif not len(attributes.is_upd) and attributes.is_sample eq 1>
        <cfif not isDefined("rowcount_")><cfset rowcount_= 0></cfif>
        <cfset rowcount_= rowcount_ + upd_rowcount_2>
        <cfoutput>
            <input type="hidden" name="rowcount_" id="rowcount_" value="#rowcount_#">
        </cfoutput>
    <cfelse>
    </cfif>
    <cfif not isDefined("is_reload")>
        <cf_seperator title="#getLang('','Test Raporu','64149')#" id="editor">
        <div id="editor">
            <div class="form-group">
                <cfmodule
                template="/fckeditor/fckeditor.cfm"
                toolbarSet="Basic"
                basePath="/fckeditor/"
                instanceName="test_report_content"
                valign="top"
                value="#iIf(attributes.is_sample eq 1 ,DE('#get_report_content.REPORT_CONTENT#'),DE(''))#">
            </div>
        </div>
    </cfif> 
    
<script type="text/javascript">
    $(document).attr("title", "<cf_get_lang dictionary_id='64096.Laboratuvar İşlemleri'>");
    $('.checking').css('float','left');
    window.onload = function() {
        $('#test_rows .catalyst-refresh').click();
        return false;
    };
        if ($('.test_rows_').length > 0) {
        $('#editor').css('display','block');
        $('#seperator').css('display','block');
    }
    else{
        $('#editor').css('display','none');
        $('#seperator').css('display','none');
    }
   
    <cfif attributes.is_reload eq 1>
        $('#editor').css('display','block');
        $('#seperator').css('display','block');
    </cfif>

    function change_val(row) {
		if($('#accepted_'+row).is(':checked')) {
			var table_length =$('#list_'+row+ ' tr .q_row').length;
			for ( i = 0; i < table_length; i++) {
				var tr_id = $('#list_'+row+ ' tr .q_row')[i].id;
				$('#'+tr_id).val(1);
			} 
		}
	}
</script>