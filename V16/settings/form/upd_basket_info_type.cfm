<cfif not (isdefined('attributes.info_type_id') and len(attributes.info_type_id))>
	<script type="text/javascript">
		alert("Kayıt Bulunamadı!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_INFO_TYPES" datasource="#DSN3#">
	SELECT 
    	* 
    FROM 
    	SETUP_BASKET_INFO_TYPES 
    WHERE 
	    BASKET_INFO_TYPE_ID = #attributes.info_type_id#
</cfquery>
<cfquery name="GET_BASKET" datasource="#DSN3#">
	SELECT 
    	* 
    FROM 
	    SETUP_BASKET 
    ORDER BY 
    	BASKET_ID 
</cfquery>
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('settings',808,42791)#" add_href="#request.self#?fuseaction=settings.add_basket_info_type" is_blank="0"><!--- Basket Ek Tanımları --->
        <cfform name="upd_info_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_basket_info_type">        
            <input type="hidden" name="basket_info_type_id" id="basket_info_type_id" value="<cfoutput>#attributes.info_type_id#</cfoutput>">
            <cf_box_elements>	
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<cfinclude template="../display/list_basket_info_types.cfm">
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-extra_info_type">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43747.Ek Tanım'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang no ='1765.Ek Tanım Girmelisiniz'>!</cfsavecontent>
                                    <div class="input-group">
                                    <cfinput type="text" name="extra_info_type" value="#trim(GET_INFO_TYPES.BASKET_INFO_TYPE)#" maxlength="30" required="yes" message="#message#" >
                                    <span class="input-group-addon">
                                    <cf_language_info 
                                        table_name="SETUP_BASKET_INFO_TYPES" 
                                        column_name="BASKET_INFO_TYPE" 
                                        column_id_value="#attributes.info_type_id#" 
                                        maxlength="500" 
                                        datasource="#dsn3#" 
                                        column_id="BASKET_INFO_TYPE_ID" 
                                        control_type="0">
                                    </span>
                                 </div>
							</div>
						</div>
						<div class="form-group" id="item-option_number">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='59359.Görüntüleneceği Yer'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<select name="option_number" id="option_number" >
                                    <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                    <option value="1" <cfif GET_INFO_TYPES.OPTION_NUMBER EQ 1>selected</cfif>><cf_get_lang no='808.Basket Ek Tanım'> 1</option>
                                    <option value="2" <cfif GET_INFO_TYPES.OPTION_NUMBER EQ 2>selected</cfif>><cf_get_lang no='808.Basket Ek Tanım'> 2</option>
                                    <option value="3" <cfif GET_INFO_TYPES.OPTION_NUMBER EQ 3>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                                </select>
							</div>
						</div>
						<div class="form-group" id="item-basket_detail">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-6 col-xs-12">
                                <cfinput type="text" name="basket_detail" value="#GET_INFO_TYPES.BASKET_DETAIL#"  maxlength="50">							</div>
						</div>
						<div class="form-group" id="item-basket_id">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='61296.Basket Şablonu'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<select name="basket_id" id="basket_id" style="width=200px;height:100px;" multiple>
                                    <cfoutput query="get_basket">
                                        <option <cfif listfind(get_info_types.basket_id,get_basket.basket_id)>selected</cfif> value="#get_basket.basket_id#">#get_basket_name(get_basket.basket_id)#</option>
                                    </cfoutput>
                                </select>
							</div>
						</div>
					</div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_info_types"><cf_workcube_buttons is_upd='1' is_delete='0' add_function="control()">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function control()
{
	if(document.upd_info_type.extra_info_type.value=='')
	{
		alert("<cf_get_lang no ='1765.Ek Tanım Girmelisiniz'>");
		return false;
	}
	else
		return true;
}
</script>
