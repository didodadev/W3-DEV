<cfparam name="attributes.model_id" default="">
<cfif isdefined('attributes.model_id') and len(attributes.model_id)>
	<cfquery name="get_model_det" datasource="#dsn1#">
		SELECT #dsn#.Get_Dynamic_Language(MODEL_ID,'#session.ep.language#','PRODUCT_BRANDS_MODEL','MODEL_NAME',NULL,NULL,MODEL_NAME) AS MODEL_NAME, MODEL_CODE,BRAND_ID FROM PRODUCT_BRANDS_MODEL WHERE MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.model_id#">
	</cfquery>
</cfif>

<cfif isdefined('attributes.model_id') and len(attributes.model_id)>
	<cfset model_id = attributes.model_id>
<cfelse>
	<cfset model_id = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Model',58225)#" popup_box="1" >
        <cfform action="#request.self#?fuseaction=product.emptypopup_add_product_model&model_id=#model_id#" method="post" name="product_cat" enctype="multipart/form-data">
        <input type="hidden" name="model_id" id="model_id" value="<cfoutput>#model_id#</cfoutput>">
            <cf_box_elements vertical="1">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-model_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58225.Model'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div <cfif isdefined('attributes.model_id') and len(attributes.model_id)>class="input-group"</cfif>>
                                <input type="text" name="model_name" id="model_name" value="<cfif isdefined('get_model_det.model_name') and len(get_model_det.model_name)><cfoutput>#get_model_det.model_name#</cfoutput></cfif>" maxlength="75">
                                <cfif isdefined("attributes.model_id") AND LEN(attributes.model_id)>
                                    <span class="input-group-addon">
                                    <cf_language_info 
                                        table_name="PRODUCT_BRANDS_MODEL" 
                                        column_name="MODEL_NAME" 
                                        column_id_value="#attributes.model_id#" 
                                        maxlength="500" 
                                        datasource="#dsn1#" 
                                        column_id="MODEL_ID" 
                                        control_type="0">
                                    </span>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-brand_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif not isdefined('get_model_det.brand_id')>
                            <input type="hidden" name="brand_code" id="brand_code" value="">
                                <cf_wrkProductBrand
                                    returnInputValue="brand_id,brand_name,brand_code"
                                    returnQueryValue="brand_id,brand_name,brand_code"
                                    width="200"
                                    compenent_name="getProductBrand"               
                                    boxwidth="300"
                                    boxheight="150"
                                    is_internet="1"
                                    brand_code="1"
                                    brand_ID="">
                            <cfelse>
                                <cf_wrkProductBrand
                                    returnInputValue="brand_id,brand_name,brand_code"
                                    returnQueryValue="brand_id,brand_name,brand_code"
                                    width="200"
                                    compenent_name="getProductBrand"               
                                    boxwidth="300"
                                    boxheight="150"
                                    is_internet="1"
                                    brand_code="1"
                                    brand_ID="#get_model_det.brand_id#">
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-model_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div <cfif isdefined('attributes.model_id') and len(attributes.model_id)>class="input-group"</cfif>>
                                <input type="text" name="model_code" id="model_code" value="<cfif isdefined('get_model_det.model_code') and len(get_model_det.model_code)><cfoutput>#get_model_det.model_code#</cfoutput></cfif>" maxlength="50">
                            </div>    
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='control()' >
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function control()
{
	
	if($('#model_name').val()=='')
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58225.Model'>");
		return false;
	}
	if($('#model_code').val()=='')
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58585.Kod'>");
		return false;
	}
    if($('#brand_id').val()=='')
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58847.Kod/Marka'>");
		return false;
	}
	return true;
}
</script>
