<!--- Güncelleme sayfası için query çekiyor --->
<cf_xml_page_edit fuseact="settings.popup_add_quality_control_result">
<cfif isdefined("attributes.result_id")>
	<cfquery name="get_control_result" datasource="#dsn3#">
		SELECT 
        	QUALITY_CONTROL_ROW_ID, 
            #dsn#.Get_Dynamic_Language(QUALITY_CONTROL_ROW_ID,'#session.ep.language#','QUALITY_CONTROL_ROW','QUALITY_CONTROL_ROW',NULL,NULL,QUALITY_CONTROL_ROW) AS QUALITY_CONTROL_ROW,
            QUALITY_CONTROL_TYPE_ID, 
            QUALITY_ROW_DESCRIPTION, 
            QUALITY_VALUE, 
            TOLERANCE,
            TOLERANCE_2, 
            SAMPLE_METHOD,
            SAMPLE_NUMBER,
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP,
            CONTROL_OPERATOR,
            UNIT,
            CODE
        FROM 
    	    QUALITY_CONTROL_ROW 
        WHERE 
	        QUALITY_CONTROL_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
	</cfquery>
	<cfquery name="upd_quality_type" datasource="#dsn3#"> 
		SELECT 
    	    TYPE_ID, 
            IS_ACTIVE, 
            QUALITY_CONTROL_TYPE, 
            TYPE_DESCRIPTION, 
            STANDART_VALUE, 
            TOLERANCE, 
            QUALITY_MEASURE, 
            TOLERANCE_2, 
            PROCESS_CAT_ID, 
            SAMPLE_METHOD,
            SAMPLE_NUMBER,
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP 
        FROM 
	        QUALITY_CONTROL_TYPE 
        WHERE 
        	TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_control_result.quality_control_type_id#">
	</cfquery>
	<cfscript>
		result_id = attributes.result_id;
		type_id = get_control_result.QUALITY_CONTROL_TYPE_ID;
		type_name = upd_quality_type.QUALITY_CONTROL_TYPE;
		control_type= get_control_result.QUALITY_CONTROL_ROW;
		detail=get_control_result.QUALITY_ROW_DESCRIPTION;
		default_value=get_control_result.QUALITY_VALUE;
		tolerance=get_control_result.TOLERANCE;
		tolerance_2=get_control_result.TOLERANCE_2;
        sample_method=get_control_result.SAMPLE_METHOD;
        sample_number=get_control_result.SAMPLE_NUMBER;
        control_operator=get_control_result.CONTROL_OPERATOR;
        unit=get_control_result.UNIT;
        code=get_control_result.CODE;
	</cfscript>
<cfelse>
	<cfquery name="upd_quality_type" datasource="#dsn3#"> 
		SELECT 
    	    TYPE_ID, 
            IS_ACTIVE, 
            QUALITY_CONTROL_TYPE, 
            TYPE_DESCRIPTION, 
            STANDART_VALUE, 
            TOLERANCE, 
            QUALITY_MEASURE, 
            TOLERANCE_2, 
            PROCESS_CAT_ID, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            SAMPLE_METHOD,
            SAMPLE_NUMBER,
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP 
        FROM 
	        QUALITY_CONTROL_TYPE 
        WHERE 
        	TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
	</cfquery>
	<cfscript>
		result_id = '';
		type_id = upd_quality_type.TYPE_ID;
		type_name = upd_quality_type.QUALITY_CONTROL_TYPE;
		control_type='';
        sample_method= "";
        sample_number="";
		detail='';
		default_value='';
		tolerance='';
		tolerance_2='';
        control_operator='';
        unit='';
        code='';
	</cfscript>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
<cf_box title="#type_name#" popup_box="1">
        <cfform name="upd_quality_type" action="#request.self#?fuseaction=settings.emptypopup_add_quality_control_result" method="post">
            <input type="hidden" name="result_id" id="result_id" value="<cfoutput>#result_id#</cfoutput>">
            <input type="hidden" name="type_id" id="type_id" value="<cfoutput>#type_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-control_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58233.Tanım'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined("attributes.result_id")><div class="input-group"></cfif>
                                <cfinput type="text" name="control_type" value="#control_type#" required="yes" message="#getLang('','Sonuç Girmelisiniz',43770)#!" maxlength="250">
                                <cfif isdefined("attributes.result_id")>
                                    <span class="input-group-addon">
                                    <cf_language_info 
                                            table_name="QUALITY_CONTROL_ROW" 
                                            column_name="QUALITY_CONTROL_ROW" 
                                            column_id_value="#attributes.result_id#" 
                                            maxlength="50" 
                                            datasource="#dsn3#" 
                                            column_id="QUALITY_CONTROL_ROW_ID" 
                                            control_type="0">
                                    </span>
                                    </div>
                                </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-SAMPLE_METHOD">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63292.Örneklem Yöntemi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="sample_method" id="sample_method">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif sample_method eq 1>selected</cfif>><cf_get_lang dictionary_id='63293.Rastgele'></option>
                                    <option value="2" <cfif sample_method eq 2>selected</cfif>><cf_get_lang dictionary_id='63294.Yüzdesel'>%</option>
                                    <option value="4" <cfif sample_method eq 4>selected</cfif>><cf_get_lang dictionary_id='64043.Katlanarak'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-sample_number">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64046.Örnek Miktarı'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" id="sample_number"  name="sample_number"  value="#TLFormat(sample_number)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
                            </div>
                        </div>
                    <cfoutput>
                        <div class="form-group" id="item-unit">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="unit" id="unit">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif isDefined('unit') and unit eq 1>selected</cfif>>mg</option> 
                                    <option value="2" <cfif isDefined('unit') and unit eq 2>selected</cfif>>gr</option> 
                                    <option value="3" <cfif isDefined('unit') and unit eq 3>selected</cfif>>kg</option> 
                                    <option value="4" <cfif isDefined('unit') and unit eq 4>selected</cfif>>mm³</option> 
                                    <option value="5" <cfif isDefined('unit') and unit eq 5>selected</cfif>>cm³</option> 
                                    <option value="6" <cfif isDefined('unit') and unit eq 6>selected</cfif>>m³</option> 
                                    <option value="7" <cfif isDefined('unit') and unit eq 7>selected</cfif>>ml</option> 
                                    <option value="8" <cfif isDefined('unit') and unit eq 8>selected</cfif>>cl</option> 
                                    <option value="9" <cfif isDefined('unit') and unit eq 9>selected</cfif>>lt</option> 
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-default_value">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33137.Standart'><cf_get_lang dictionary_id='33616.Değer'></label >
                            <div class="col col-8 col-xs-12">
                                <input name="default_value" type="text" value="#TLFormat(default_value)#" maxlength="10"  id="default_value" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
                            </div>
                        </div>
                        <div class="form-group" id="item-top_limit">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52249.Üst Limit'></label>
                            <div class="col col-8 col-xs-12">
                                <input name="tolerance" type="text" value="#TLFormat(tolerance)#" maxlength="10" id="tolerance" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
                            </div>
                        </div>
                        <div class="form-group" id="item-min_limit">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52248.Alt Limit'></label>
                            <div class="col col-8 col-xs-12">
                                <input name="tolerance_2" type="text" value="#TLFormat(tolerance_2)#" maxlength="10" id="tolerance_2" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
                            </div>
                        </div>
                        <div class="form-group" id="item-code">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'></label>
                            <div class="col col-8 col-xs-12">
                                <input name="code" type="text" value="#code#" maxlength="200" id="code">
                            </div>
                        </div>
                        <div class="form-group" id="item-control">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57201.Kontrol'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="control_operator" id="control_operator"> 
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif isDefined('control_operator') and control_operator eq 1>selected</cfif>>=</option>
                                    <option value="2" <cfif isDefined('control_operator') and control_operator eq 2>selected</cfif>>></option>
                                    <option value="3" <cfif isDefined('control_operator') and control_operator eq 3>selected</cfif>><</option>
                                    <option value="4" <cfif isDefined('control_operator') and control_operator eq 4>selected</cfif>>=></option>
                                    <option value="5" <cfif isDefined('control_operator') and control_operator eq 5>selected</cfif>>=<</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="detail" id="detail" style="height:75px;" maxlength="750" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#detail#</cfoutput></textarea>
                            </div>
                        </div>
                </cfoutput>
            </div>
            </cf_box_elements> 
            <cf_box_footer>
                <div class="col col-12">
                    <cfif isdefined("attributes.result_id")>
                        <cf_workcube_buttons is_upd='1' add_function='control()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_q_control_result&id=#attributes.result_id#'>
                        <cf_record_info query_name="get_control_result">
                        <cfelse>
                        <cf_workcube_buttons is_upd='0' add_function='control()'>
                    </cfif>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script language="javascript">



function control()
{
	
}

</script>
