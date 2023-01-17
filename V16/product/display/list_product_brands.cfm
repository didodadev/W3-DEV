<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.is_internet" default="">
<cfparam name="attributes.is_obm" default="1">
<cfparam name="attributes.our_company" default="#session.ep.company_id#">
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_PRODUCT_BRANDS" datasource="#dsn1#">
        SELECT
            #dsn#.Get_Dynamic_Language(BRAND_ID,'#session.ep.language#','PRODUCT_BRANDS','BRAND_NAME',NULL,NULL,BRAND_NAME) AS BRAND_NAME_,
            #dsn#.Get_Dynamic_Language(BRAND_ID,'#session.ep.language#','PRODUCT_BRANDS','DETAIL',NULL,NULL,DETAIL) AS DETAIL_,
            *
        FROM
            PRODUCT_BRANDS
        WHERE
            1=1
        <cfif len(attributes.is_active)>
            AND IS_ACTIVE = #attributes.is_active#
        </cfif>
        <cfif len(attributes.is_internet)>
            AND IS_INTERNET = #attributes.is_internet#
        </cfif>
        <cfif isdefined("attributes.our_company") and len(attributes.our_company)>
            AND BRAND_ID IN (SELECT BRAND_ID FROM PRODUCT_BRANDS_OUR_COMPANY WHERE OUR_COMPANY_ID = #attributes.our_company#)
        </cfif>
        <cfif len(attributes.keyword)>
            AND (BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
        </cfif> 
        ORDER BY
            <cfif isdefined("attributes.is_obm") and attributes.is_obm eq 0>
                BRAND_CODE
            <cfelse>
                BRAND_NAME
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_product_brands.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_product_brands.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_product" action="#request.self#?fuseaction=product.list_product_brands" method="post">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="is_internet" id="is_internet">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif attributes.is_internet eq 1>selected</cfif>><cf_get_lang dictionary_id='37531.Webde Görünsün'></option>
                        <option value="0" <cfif attributes.is_internet eq 0>selected</cfif>><cf_get_lang dictionary_id='37536.Webde Görünmesin'></option>
                    </select>
                </div>
                <div class="form-group">
                    <cfquery name="get_our_company" datasource="#dsn#">
                    SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY
                    </cfquery>
                    <select name="our_company" id="our_company">
                        <option value=""><cf_get_lang dictionary_id='29531.Şirketler'></option>
                        <cfoutput query="get_our_company">
                            <option value="#comp_id#" <cfif attributes.our_company eq comp_id>selected</cfif>>#nick_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="is_obm" id="is_obm">
                        <option value=""><cf_get_lang dictionary_id='58924.Sıralama'></option>
                        <option value="1" <cfif attributes.is_obm eq 1>selected</cfif>><cf_get_lang dictionary_id='37930.İsme Göre'></option>
                        <option value="0" <cfif attributes.is_obm eq 0>selected</cfif>><cf_get_lang dictionary_id='37087.Koda Göre'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="is_active" id="is_active">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Marka',58847)#" pure="1" uidrop="1" hide_table_column="1" collapsable="0" resize="0" woc_setting = "#{ checkbox_name : 'print_brand_id', print_type : 218 }#">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.Sira'></th>
                    <th><cf_get_lang dictionary_id='58527.ID'></th>
                    <th><cf_get_lang dictionary_id='58585.Kod'></th>
                    <th><cf_get_lang dictionary_id='58847.Marka Adı'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th class="header_icn_none" width="20"><a href="javascript://"  onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_product_brands&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <cfif isdefined("attributes.form_submitted") and get_product_brands.recordcount>
                        <th width="20" nowrap="nowrap" class="text-center header_icn_none">
                            <cfif get_product_brands.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
                            <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_brand_id');">
                        </th>
                
                    </cfif>
            </tr>
            </thead>
            <tbody>
                <cfif GET_PRODUCT_BRANDS.recordcount>
                    <cfoutput query="get_product_brands" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=product.list_product_brands&event=upd&id=#get_product_brands.brand_id#" class="tableyazi" >#brand_id#</a></td>
                            <td>#BRAND_CODE#</td>
                            <td><a href="#request.self#?fuseaction=product.list_product_brands&event=upd&id=#get_product_brands.brand_id#" class="tableyazi">#BRAND_NAME_#</a></td>
                            <td>#DETAIL_#</td>
                            <!-- sil -->
                            <td>
                                <a href="#request.self#?fuseaction=product.list_product_brands&event=upd&id=#get_product_brands.brand_id#" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a>
                            </td>
                            <!-- sil -->
                            <td class="text-center"><input type="checkbox" name="print_brand_id" id="print_brand_id" value="#brand_id#"></td>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>		
        <cfif not GET_PRODUCT_BRANDS.recordcount>
        <div class="ui-info-bottom">
            <p><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></p>
        </div>	
        </cfif>
        <cfset url_str = "">
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        <cfif isdefined ("attributes.is_obm") and len (attributes.is_obm)>
            <cfset url_str = "#url_str#&is_obm=#attributes.is_obm#">
        </cfif>
        <cfif isdefined ("attributes.is_active") and len (attributes.is_active)>
            <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
        </cfif>
        <cfif isdefined ("attributes.is_internet") and len (attributes.is_internet)>
            <cfset url_str = "#url_str#&is_internet=#attributes.is_internet#">
        </cfif>
        <cfif isDefined('attributes.our_company') and len(attributes.our_company)>
            <cfset url_str = "#url_str#&our_company=#attributes.our_company#">
        </cfif>
        <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
            <cfset url_str ="#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
            <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="product.list_product_brands#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
</script>
