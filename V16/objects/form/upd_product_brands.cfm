<cf_get_lang_set module_name="objects">
<cfset attributes.brand_id = url.id>
<cfquery name="get_brand" datasource="#dsn1#">
	SELECT 
    	BRAND_ID,
        BRAND_CODE,
        #dsn#.Get_Dynamic_Language(BRAND_ID,'#session.ep.language#','PRODUCT_BRANDS','BRAND_NAME',NULL,NULL,BRAND_NAME) AS BRAND_NAME,
        #dsn#.Get_Dynamic_Language(BRAND_ID,'#session.ep.language#','PRODUCT_BRANDS','DETAIL',NULL,NULL,DETAIL) AS DETAIL,
        IS_ACTIVE,
        IS_INTERNET,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        UPDATE_DATE,
        UPDATE_EMP,
        UPDATE_IP 
	FROM 
		PRODUCT_BRANDS 
	WHERE 
    	BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfquery name="get_brand_comps" datasource="#dsn1#">
	SELECT * FROM PRODUCT_BRANDS_OUR_COMPANY WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfset our_comp_list = valuelist(get_brand_comps.our_company_id)>
<cfinclude template="../query/get_our_companies.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box collapsable="0" resize="0">
        <cfform action="#request.self#?fuseaction=objects.emptypopup_upd_product_brands" method="post" name="product_cat" enctype="multipart/form-data">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
            <cf_box_elements vertical="1">
                <div class="col col-2 col-md-2 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_active" id="is_active" <cfif get_brand.is_active eq 1>checked</cfif> value="1"><cf_get_lang dictionary_id ='57493.Aktif '></label>
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_internet" id="is_internet" <cfif get_brand.is_internet eq 1>checked</cfif> value="1"><cf_get_lang dictionary_id ='58079.İnternet'></label>
                    </div>
                </div>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-brand_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='33073.marka girmelisiniz'></cfsavecontent>
                                <cfinput type="Text" name="brand_name" id="brand_name" value="#get_brand.brand_name#" maxlength="75" required="Yes" message="#message#">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="PRODUCT_BRANDS" 
                                    column_name="BRAND_NAME" 
                                    column_id_value="#attributes.id#" 
                                    maxlength="500" 
                                    datasource="#dsn1#" 
                                    column_id="BRAND_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-brand_code">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='33952.Kod Girmelisiniz'> </cfsavecontent>
                            <cfinput type="text" name="brand_code" id="brand_code" value="#get_brand.brand_code#" maxlength="50" required="Yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <textarea name="detail" id="detail"><cfif len(get_brand.detail)><cfoutput>#get_brand.detail#</cfoutput></cfif></textarea>
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="PRODUCT_BRANDS" 
                                    column_name="DETAIL" 
                                    column_id_value="#attributes.id#" 
                                    maxlength="500" 
                                    datasource="#dsn1#" 
                                    column_id="BRAND_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-our_company_ids">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58017.İlişkili Şirketler'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select multiple="multiple" name="our_company_ids" id="our_company_ids">
                                <cfoutput query="get_our_companies">
                                    <option value="#comp_id#" <cfif listlen(our_comp_list) and listfindnocase(our_comp_list,comp_id)>selected</cfif>>#nick_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group"> 
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30253.Kullanıcı Dostu URL'></label>                      
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">             
                            <cf_publishing_settings fuseaction="product.list_product_brands" event="det" action_type="BRAND_ID" action_id="#url.id#">                          
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <div class="ui-form-list-btn">
                <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                    <cf_record_info query_name='get_brand'>
                </div>
                <div class="col col-6 col-md-4 col-sm-4 col-xs-12">
                    <cf_workcube_buttons is_upd='1' add_function='kapa_refresh()&&productcat_comp()' delete_page_url='#request.self#?fuseaction=objects.emptypopup_del_product_brands&id=#attributes.id#&head=#get_brand.brand_code#'>
                </div>
            </div>
        </cfform>
    </cf_box>
    <cfinclude template="../../product/display/dsp_product_images.cfm">
    <cf_get_workcube_content action_type ='BRAND_ID' action_type_id ='#attributes.id#' style='0' design='0'>
</div>
<script type="text/javascript">
	function productcat_comp()
	{
		var new_our_company_list='';
		
		for(ii=0;ii<document.product_cat.our_company_ids.length; ii++)
		{
			if(product_cat.our_company_ids[ii].selected && product_cat.our_company_ids.options[ii].value.length!='')
				new_our_company_list= new_our_company_list + ',' + product_cat.our_company_ids.options[ii].value;
		}
		<cfloop list="#our_comp_list#" index="k">
			if(!list_find(new_our_company_list,<cfoutput>#k#</cfoutput>,',') )
			{
				var new_dsn3 = '<cfoutput>#dsn#_#k#</cfoutput>';
				var get_productcat = wrk_safe_query("obj_get_productcat",new_dsn3,0,<cfoutput>#url.id#</cfoutput>);
				if (get_productcat.recordcount)
				{
					alert("<cf_get_lang dictionary_id ='33958.İlgili Şirkette Bu Kategori Bir Üründe Kullanılmıştır'>");
					return false;
				}
			}
		</cfloop>
	}
	function kapa_refresh()
	{
		y=(1000-product_cat.detail.value.length);
		if(y<0)
		{
			alert("<cf_get_lang dictionary_id ='57629.Açıklama'> "+((-1)*y)+"<cf_get_lang dictionary_id='29538.Karakter Uzun'> ");
			return false;
		}
		return true;
	}
	function del_images()
	{
		document.product_cat.del_1.style.display='';
		document.product_cat.del_2.style.display='none';
		document.product_cat.old_logo_del.value=1;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">