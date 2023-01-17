<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>
<cfquery name="get_op_type" datasource="#dsn3#">
	SELECT
   OPERATION_TYPE_ID
   ,CASE
    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
    ELSE OPERATION_TYPE
    END AS OPERATION_TYPE
	,O_HOUR
	,O_MINUTE
	,COMMENT
	,COMMENT2
	,FILE_NAME
	,OPERATION_COST
	,MONEY
	,FILE_SERVER_ID
	,OPERATION_CODE
	,OPERATION_STATUS
	,RECORD_DATE
	,RECORD_EMP
	,EZGI_H_SURE
	,EZGI_FORMUL
	,IS_VIRTUAL
    ,STOCK_ID
    ,PRODUCT_NAME
	FROM
        OPERATION_TYPES 
        LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = OPERATION_TYPES.OPERATION_TYPE_ID
        AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="OPERATION_TYPE">
        AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="OPERATION_TYPES">
        AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	WHERE
		OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_id#">
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
        <cfform name="operation_type" enctype="multipart/form-data" action="#request.self#?fuseaction=prod.upd_operation_type&operation_type_id=#attributes.operation_type_id#" method="post">
            <cf_catalystHeader>
            <input type="hidden" name="operation_type_id" id="operation_type_id" value="<cfoutput>#attributes.operation_type_id#</cfoutput>">
            <cfoutput>
                <cf_box>
                    <cf_box_elements>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-status">
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id ='57493.Aktif'></label>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                    <input type="checkbox" name="status" id="status" value="1" <cfif get_op_type.operation_status eq 1>checked</cfif>>
                                </div>
                            </div>
                            <div class="form-group" id="item-op_name">
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='36740.İşlem Tipi girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="op_name" required="yes" message="#message#" value="#get_op_type.OPERATION_TYPE#">
                                        <span class="input-group-addon"><cf_language_info table_name="OPERATION_TYPES" column_name="OPERATION_TYPE" column_id_value="#attributes.operation_type_id#" maxlength="50" datasource="#dsn3#" column_id="OPERATION_TYPE_ID" control_type="0"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-operation_code">
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="36377.Operasyon Kodu"> *</label>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                    <cfinput type="text" name="operation_code" id="operation_code" value="#get_op_type.OPERATION_CODE#" maxlength="5">
                                </div>
                            </div>
                            <div class="form-group" id="item-operation_cost">
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='36345.İşlem Maliyeti'> *</label>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='36344.İşlem Maliyeti Girmelisiniz !'></cfsavecontent>
                                        <cfinput type="text" name="operation_cost" validate="float" class="moneybox" message="#message#" value="#TLFormat(get_op_type.operation_cost)#" onkeyup="return(FormatCurrency(this,event));">
                                        <span class="input-group-addon width">
                                            <select name="money" id="money">
                                                <cfloop query="get_money">
                                                    <option value="#money#" <cfif get_op_type.money eq money>selected</cfif>>#money#</option>
                                                </cfloop>
                                            </select>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-minutes">
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58827.Dakika'></label>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                    <cfinput type="text" name="minutes" maxlength="3" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this);" value="#get_op_type.O_MINUTE#">
                                </div>
                            </div>
                            <div class="form-group" id="item-stock">
                                <label class="col col-3 col-md-3 col-xs-12">
                                    <cf_get_lang dictionary_id='57452.Stok'>
                                </label>
                            <div class="col col-9 col-md-9 col-xs-12">
                                <div class="input-group">
                                	<input type="hidden" name="stock_id_" id="stock_id_" value="#get_op_type.stock_id#">
                                <input type="text"   name="product_name_" id="product_name_" value="#get_op_type.product_name#" onFocus="AutoComplete_Create('product_name_','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','STOCK_ID','stock_id_','','3','225');" autocomplete="off">
                                <span href="javascript://" class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=operation_type.stock_id_&field_name=operation_type.product_name_<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');"></span>
                                </div>
                            </div>
                            </div>
                            <div class="form-group" id="item-comment_2">
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'> 2</label>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                    <input type="text" name="comment_2" id="comment_2" maxlength="100" value="#get_op_type.comment2#"/>
                                </div>
                            </div>
                            <div class="form-group" id="item-comment">
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                    <textarea name="comment" id="comment">#get_op_type.comment#</textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-asset">
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cfif len(get_op_type.FILE_NAME)><input type="radio" name="upd_asset" id="upd_asset" value="1"></cfif><cf_get_lang_main no='56.Belge'></label>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                    <input type="file" name="asset" id="asset">
                                </div>
                            </div>
                            <cfif len(get_op_type.FILE_NAME)>
                                <div class="form-group" id="item-loaded">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><span class="hide">Yüklenmiş Belge</span><input type="radio" name="upd_asset" id="upd_asset" value="0" checked></label>
                                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                        <a href="javascript://" onclick="windowopen('#file_web_path#operationtype/#get_op_type.FILE_NAME#','medium')" class="tableyazi">#get_op_type.FILE_NAME#</a>
                                    </div>
                                </div>
                            </cfif>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <cf_record_info query_name='get_op_type'>
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function='unformat_fields()'>
                    </cf_box_footer>
                </cf_box>
            </cfoutput>
        </cfform>
    </div>
    <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='36632.İstasyon-Kapasite/Saat'></cfsavecontent>
        <cf_box id="list_product_ws"
            title="#message#"
            box_page="#request.self#?fuseaction=prod.emptypopup_list_product_ws_ajaxproduct&operation_type_id=#attributes.operation_type_id#"
            add_href="#request.self#?fuseaction=prod.popup_add_ws_product&is_upd_workstation=1&operation_type_id=#attributes.operation_type_id#"
            closable="0"
            add_href_size="horizantal">
        </cf_box>
    </div>
</div>
<script type="text/javascript">
function unformat_fields()
{	
	if(document.getElementById('operation_code').value != '')
	{
		var listParam = document.getElementById('operation_code').value + "*" + "<cfoutput>#attributes.operation_type_id#</cfoutput>";
		operation_code_control=wrk_safe_query("prdp_operation_code_control",'dsn3',0,listParam);
		if(operation_code_control.recordcount > 0)
		{
			alert("Girdiginiz Operasyon Kodu Kullanılıyor!");
			return false;
		}
	}

	operation_type.operation_cost.value = filterNum(operation_type.operation_cost.value);
	return true;
}
</script>
