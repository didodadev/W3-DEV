<cfparam name="attributes.cat" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.upd_type" default="4">
<script>
function wrk_select_all_p(main_checkbox,row_checkbox,row_count)
{
	var check_len = row_count - 1;
	for(var cl_ind=0; cl_ind <= check_len; cl_ind++)
	{
		if(document.getElementById(main_checkbox).checked == true)
		{
			document.getElementById(row_checkbox + '_' + (cl_ind+ 1)).checked = true;	
		}
		else
		{
			document.getElementById(row_checkbox + '_' + (cl_ind+ 1)).checked = false;	
		}
	}
}
</script>

<cfparam name="attributes.brand_id" default="">
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY,
        CASE WHEN PRODUCT_CAT.HIERARCHY NOT LIKE '%.%' 
        	THEN PRODUCT_CAT.HIERARCHY + ' ' + PRODUCT_CAT.PRODUCT_CAT	
            WHEN PRODUCT_CAT.HIERARCHY LIKE '%.%.%'
            THEN '....' + PRODUCT_CAT.HIERARCHY + ' ' + PRODUCT_CAT.PRODUCT_CAT
            ELSE '..' + PRODUCT_CAT.HIERARCHY + ' ' + PRODUCT_CAT.PRODUCT_CAT
            END AS URUN_KAT            
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		HIERARCHY
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58874.Ürün Bilgisi Düzenle'></cfsavecontent>
    <cf_box title="#message#">
	<cfform name="set_" method="post" action="">
        <input type="hidden" value="1" name="is_search_submit"/>
            <cf_box_search >
                <div class="form-group">
                    <div class="col col-12 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#">
                    </div>
                </div>
                <div class="form-group">
                    <div class="col col-12 col-xs-12">
                        <select name="product_status" id="product_status">
                            <option value="1"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                            <option value="0"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                            <option value="2"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 2)> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        </select>
                    </div>                    
                </div>
                <div class="form-group">
                    <label><input type="checkbox" value="1" name="is_company_off" <cfif isdefined("attributes.is_company_off")>checked</cfif>/><cf_get_lang dictionary_id='37536.Webde Görünmesin'></label>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function="kontrol()" button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label><input type="radio" name="upd_type" id="upd_type" value="0" <cfif attributes.upd_type eq 0>checked</cfif> onclick="control_tr();"> <cf_get_lang dictionary_id='37970.Ürün Kategorisine Göre'></label>
                    </div>
                    <div class="form-group">
                        <label><input type="radio" name="upd_type" id="upd_type" value="1" <cfif attributes.upd_type eq 1>checked</cfif> onclick="control_tr();"> <cf_get_lang dictionary_id='37971.Tedarikçiye Göre'></label>
                    </div>
                    <div class="form-group">
                        <label><input type="radio" name="upd_type" id="upd_type" value="2" <cfif attributes.upd_type eq 2>checked</cfif> onclick="control_tr();"> <cf_get_lang dictionary_id='37972.Markaya Göre'></label>
                    </div>
                    <div class="form-group">
                        <label><input type="radio" name="upd_type" id="upd_type" value="3" <cfif attributes.upd_type eq 3>checked</cfif> onclick="control_tr();"> <cf_get_lang dictionary_id='37973.Marka ve Tedarikçiye Göre'></label>
                    </div>
                    <div class="form-group">
                        <label><input type="radio" name="upd_type" id="upd_type" value="4" <cfif attributes.upd_type eq 4>checked</cfif> onclick="control_tr();"> <cf_get_lang dictionary_id='37927.Ürün Adına Göre'></label>
                    </div>
                </div> 
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                    <cf_box_elements vertical="1">  
                        <div class="form-group">
                            <div id="kategori_1" style="display:none;">
                                <label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                            </div>
                            <div id="kategori_2" style="display:none;">
                                <div class="col col-8 col-xs-12">
                                    <div id="prod_cats">
                                        <cf_multiselect_check 
                                            query_name="get_product_cat"  
                                            name="cat"
                                            option_text="Ürün Kategorileri" 
                                            width="300"
                                            option_name="URUN_KAT" 
                                            option_value="HIERARCHY"
                                            filter="1"
                                            value="#attributes.cat#">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div id="company_1" style="display:none;">
                                <label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                            </div>
                            <div id="company_2" style="display:none;">
                                <div class="col col-8 col-xs-12">
                                    <cfquery name="COMPANIES" datasource="#DSN#">
                                        SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY
                                    </cfquery>
                                    <select name="our_company_id" id="our_company_id" onchange="showBranch(this.value);">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="companies">
                                            <option value="#comp_id#"<cfif isdefined('attributes.our_company_id') and listfind(attributes.our_company_id,COMP_ID)>selected</cfif>>#company_name#</option>
                                        </cfoutput>
                                    </select>	            
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div id="branch_1" style="display:none;">
                                <label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            </div>
                            <div class="col col-8 col-xs-12" id="comp_branches" style="display:none;">
                                <cfif isdefined('attributes.our_company_id') and len(attributes.our_company_id)>
                                    <cfquery name="GET_BRANCHES" datasource="#DSN#">
                                        SELECT BRANCH_ID, BRANCH_FULLNAME FROM BRANCH <cfif isdefined("our_company_id")>WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#"></cfif>
                                    </cfquery>
                                    <select name="branches" id="branches" multiple="multiple">
                                        <cfoutput query="GET_BRANCHES">
                                            <option value="#branch_id#" <cfif isdefined("attributes.branches") and listfind(attributes.branches,GET_BRANCHES.BRANCH_ID)>selected</cfif>>#BRANCH_FULLNAME#</option>
                                        </cfoutput>
                                    </select>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group">
                            <div id="tedarikci_1" style="display:none;">
                                <label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                            </div>
                            <div id="tedarikci_2" style="display:none;">
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input name="comp" type="text"  id="comp" style="width:250px;" onfocus="AutoComplete_Create('comp','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','140');" value="" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=set_.company_id&field_comp_name=set_.comp&select_list=2&keyword=</cfoutput>'+set_.comp.value,'list','popup_list_pars');" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
                                        <input type="hidden" name="company_id" id="company_id" value="">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div id="marka_1" style="display:none;">
                                <label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                            </div>
                            <div id="marka_2" style="display:none;">
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkproductbrand
                                    width="150"
                                    compenent_name="getProductBrand"               
                                    boxwidth="240"
                                    boxheight="150"
                                    brand_id="#attributes.brand_id#">
                                </div>		
                            </div>
                        </div> 
                    </cf_box_elements>
                </div>
            </cf_box_search_detail> 
    </cfform>
</cf_box>

    <cfif isdefined("attributes.is_search_submit")>
        <cfform name="set2_" method="post" action="#request.self#?fuseaction=product.emptypopup_change_product_info">
            <!--- kriter search --->
                    <!--- <cfquery name="get_types" datasource="#dsn_dev#">
                            SELECT * FROM EXTRA_PRODUCT_TYPES WHERE TYPE_STATUS = 1 ORDER BY TYPE_NAME
                        </cfquery>
                        <cfset kriter_list = "">
                        <cfoutput query="get_types">
                            <cfif isdefined("attributes.search_sub_id_#type_id#")>
                                <cfset type_id_ = type_id>
                                <cfset sub_type_id_ = evaluate("attributes.search_sub_id_#type_id#")>
                                <cfset sub_type_name_ = evaluate("attributes.search_sub_name_#type_id#")>
                                <cfif len(sub_type_id_) and len(sub_type_name_)>
                                <cfset kriter_list = listappend(kriter_list,sub_type_id_)>
                                </cfif>
                            </cfif>
                        </cfoutput>--->
                        
                    <!--- <cfset kriter_product_list = "">
                        <cfif listlen(kriter_list)>
                            <cfquery name="get_kriter_products" datasource="#dsn1#">
                                SELECT
                                    PRODUCT_ID
                                FROM
                                    PRODUCT
                                WHERE
                                    PRODUCT_ID IS NOT NULL AND
                                    (
                                    <cfset sira_ = 0>
                                    <cfloop list="#kriter_list#" index="ccc">
                                        <cfset sira_ = sira_ + 1>
                                        PRODUCT_ID IN (SELECT E.PRODUCT_ID FROM #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS E WHERE SUB_TYPE_ID = #ccc#)
                                        <cfif sira_ neq listlen(kriter_list)>
                                            AND
                                        </cfif>
                                    </cfloop>
                                    )
                            </cfquery>
                            <cfif get_kriter_products.recordcount>
                                <cfset kriter_product_list = valuelist(get_kriter_products.PRODUCT_ID)>
                            </cfif>
                        </cfif>--->
            <!--- kriter search --->
            <cfif attributes.upd_type eq 0>
                <cfquery name="get_cats" datasource="#dsn1#">
                    SELECT 
                        PRODUCT_CAT.PRODUCT_CATID, 
                        PRODUCT_CAT.HIERARCHY, 
                        PRODUCT_CAT.PRODUCT_CAT
                    FROM
                        <cfif isdefined("attributes.branches") and len(attributes.branches)>
                            PRODUCT_BRANCH,
                        </cfif>
                        PRODUCT_CAT,
                        PRODUCT_CAT_OUR_COMPANY PCO
                    WHERE 
                        PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
                        <cfif isdefined("attributes.branches") and len(attributes.branches)>
                            PRODUCT_BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branches#" list>) AND
                        </cfif>
                        <cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
                            PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#"> AND
                        <cfelse>
                            PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                        </cfif>
                        <cfif listlen(attributes.cat)>
                        (
                        <cfloop from="1" to="#listlen(attributes.cat)#" index="ccc">
                            <cfset cat_ = listgetat(attributes.cat,ccc)>
                            (PRODUCT_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cat_#"> OR PRODUCT_CAT.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#cat_#.%">)
                            <cfif ccc neq listlen(attributes.cat)>
                                OR
                            </cfif>
                        </cfloop>
                        )
                        <cfelse>
                        PRODUCT_CAT.PRODUCT_CATID = 0
                        </cfif>
                        GROUP BY
                            PRODUCT_CAT.PRODUCT_CATID,
                            PRODUCT_CAT.HIERARCHY
                            ,PRODUCT_CAT.PRODUCT_CAT
                </cfquery>
                <cfif get_cats.recordcount>
                    <cfquery name="GET_PRODUCTS" datasource="#dsn1#">
                        SELECT
                            *,
                            (SELECT PB.BRAND_NAME FROM PRODUCT_BRANDS PB WHERE PB.BRAND_ID = PRODUCT.BRAND_ID) AS MARKA,
                            (SELECT PC.HIERARCHY + ' ' + PC.PRODUCT_CAT FROM PRODUCT_CAT PC WHERE PC.PRODUCT_CATID = PRODUCT.PRODUCT_CATID) AS KATEGORI,
                            (SELECT C.FULLNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = PRODUCT.COMPANY_ID) AS COMP_FULLNAME,
                            (SELECT C.NICKNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = PRODUCT.COMPANY_ID) AS COMP_NAME
                        FROM
                            PRODUCT
                        WHERE
                            <cfif isDefined("attributes.product_status") and (attributes.product_status eq 1)>
                                PRODUCT_STATUS = 1 AND
                            </cfif>
                            <cfif isDefined("attributes.product_status") and (attributes.product_status eq 0)>
                                PRODUCT_STATUS = 0 AND
                            </cfif>
                            <cfif isdefined("attributes.is_company_off")>
                                (COMPANY_ID IS NULL OR COMPANY_ID = '') AND
                            </cfif>
                            <cfif len(attributes.keyword)>
                                PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
                            </cfif>
                            PRODUCT_CATID IN (#valuelist(get_cats.PRODUCT_CATID)#) 
                    ORDER BY 
                        PRODUCT_NAME
                    </cfquery>
                <cfelse>
                    <cfset GET_PRODUCTS.recordcount = 0> 
                </cfif>
                <cfelseif attributes.upd_type eq 4>
                <cfquery name="GET_PRODUCTS" datasource="#dsn1#">
                        SELECT
                            *,
                            (SELECT PC.HIERARCHY + ' ' + PC.PRODUCT_CAT FROM PRODUCT_CAT PC WHERE PC.PRODUCT_CATID = PRODUCT.PRODUCT_CATID) AS KATEGORI,
                            (SELECT PB.BRAND_NAME FROM PRODUCT_BRANDS PB WHERE PB.BRAND_ID = PRODUCT.BRAND_ID) AS MARKA,
                            (SELECT C.FULLNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = PRODUCT.COMPANY_ID) AS COMP_FULLNAME,
                            (SELECT C.NICKNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = PRODUCT.COMPANY_ID) AS COMP_NAME
                        FROM
                            PRODUCT
                        WHERE
                            <cfif isDefined("attributes.product_status") and (attributes.product_status eq 1)>
                                PRODUCT_STATUS = 1 AND
                            </cfif>
                            <cfif isDefined("attributes.product_status") and (attributes.product_status eq 0)>
                                PRODUCT_STATUS = 0 AND
                            </cfif>
                            <cfif isdefined("attributes.is_company_off")>
                                (COMPANY_ID IS NULL OR COMPANY_ID = '') AND
                            </cfif>
                            <cfif len(attributes.keyword)>
                                PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
                            </cfif>
                            PRODUCT_ID IS NOT NULL
                        ORDER BY 
                        PRODUCT_NAME
                    </cfquery>
                <cfelseif attributes.upd_type eq 1>
                    <cfquery name="GET_PRODUCTS" datasource="#dsn1#">
                        SELECT
                            *,
                            (SELECT PC.HIERARCHY + ' ' + PC.PRODUCT_CAT FROM PRODUCT_CAT PC WHERE PC.PRODUCT_CATID = PRODUCT.PRODUCT_CATID) AS KATEGORI,
                            (SELECT PB.BRAND_NAME FROM PRODUCT_BRANDS PB WHERE PB.BRAND_ID = PRODUCT.BRAND_ID) AS MARKA,
                            (SELECT C.FULLNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = PRODUCT.COMPANY_ID) AS COMP_FULLNAME,
                            (SELECT C.NICKNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = PRODUCT.COMPANY_ID) AS COMP_NAME
                        FROM
                            PRODUCT
                        WHERE
                            <cfif isDefined("attributes.product_status") and (attributes.product_status eq 1)>
                                PRODUCT_STATUS = 1 AND
                            </cfif>
                            <cfif isDefined("attributes.product_status") and (attributes.product_status eq 0)>
                                PRODUCT_STATUS = 0 AND
                            </cfif>
                            <cfif isdefined("attributes.is_company_off")>
                                (COMPANY_ID IS NULL OR COMPANY_ID = '') AND
                            </cfif>
                            <cfif len(attributes.keyword)>
                                PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
                            </cfif>
                            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id# ">
                        ORDER BY 
                        PRODUCT_NAME
                    </cfquery>
                <cfelseif attributes.upd_type eq 2>
                    <cfquery name="GET_PRODUCTS" datasource="#dsn1#">
                        SELECT
                            *,
                            (SELECT PB.BRAND_NAME FROM PRODUCT_BRANDS PB WHERE PB.BRAND_ID = PRODUCT.BRAND_ID) AS MARKA,
                            (SELECT PC.HIERARCHY + ' ' + PC.PRODUCT_CAT FROM PRODUCT_CAT PC WHERE PC.PRODUCT_CATID = PRODUCT.PRODUCT_CATID) AS KATEGORI,
                            (SELECT C.FULLNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = PRODUCT.COMPANY_ID) AS COMP_FULLNAME,
                            (SELECT C.NICKNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = PRODUCT.COMPANY_ID) AS COMP_NAME
                        FROM
                            PRODUCT
                        WHERE
                            <cfif isDefined("attributes.product_status") and (attributes.product_status eq 1)>
                                PRODUCT_STATUS = 1 AND
                            </cfif>
                            <cfif isDefined("attributes.product_status") and (attributes.product_status eq 0)>
                                PRODUCT_STATUS = 0 AND
                            </cfif>
                            <cfif isdefined("attributes.is_company_off")>
                                (COMPANY_ID IS NULL OR COMPANY_ID = '') AND
                            </cfif>
                            <cfif len(attributes.keyword)>
                                PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
                            </cfif>
                            BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
                        ORDER BY 
                        PRODUCT_NAME
                    </cfquery>
                <cfelseif attributes.upd_type eq 3>
                    <cfquery name="GET_PRODUCTS" datasource="#dsn1#">
                    SELECT
                            *,
                            (SELECT PB.BRAND_NAME FROM PRODUCT_BRANDS PB WHERE PB.BRAND_ID = PRODUCT.BRAND_ID) AS MARKA,
                            (SELECT PC.HIERARCHY + ' ' + PC.PRODUCT_CAT FROM PRODUCT_CAT PC WHERE PC.PRODUCT_CATID = PRODUCT.PRODUCT_CATID) AS KATEGORI,
                            (SELECT C.FULLNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = PRODUCT.COMPANY_ID) AS COMP_FULLNAME,
                            (SELECT C.NICKNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = PRODUCT.COMPANY_ID) AS COMP_NAME
                        FROM
                            PRODUCT
                        WHERE
                            <cfif isDefined("attributes.product_status") and (attributes.product_status eq 1)>
                                PRODUCT_STATUS = 1 AND
                            </cfif>
                            <cfif isDefined("attributes.product_status") and (attributes.product_status eq 0)>
                                PRODUCT_STATUS = 0 AND
                            </cfif>
                            <cfif isdefined("attributes.is_company_off")>
                                (COMPANY_ID IS NULL OR COMPANY_ID = '') AND
                            </cfif>
                            <cfif len(attributes.keyword)>
                                PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
                            </cfif>
                            BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> AND
                            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                        ORDER BY 
                        PRODUCT_NAME
                    </cfquery>
            </cfif> 
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57564.Ürünler'></cfsavecontent>
            <cf_box title="#message#" uidrop="1" hide_table_column="1">   
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                            <th><cf_get_lang dictionary_id='57756.Durum'></th>
                            <th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
                            <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                            <th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                            <th><cf_get_lang dictionary_id='58847.Marka'></th>
                            <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>						
                            <th><cf_get_lang dictionary_id='29533.Tedarikçi'> <cf_get_lang dictionary_id='32646.Kodu'></th>
                            <th style="text-align:center" ><input type="checkbox" name="all_product_id" id="all_product_id" value="1" checked="checked" onclick="wrk_select_all_p('all_product_id','product_id','<cfoutput>#GET_PRODUCTS.recordcount#</cfoutput>');"/></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif GET_PRODUCTS.recordcount>
                            <cfoutput query="GET_PRODUCTS">
                                <tr>
                                    <td width="35">#currentrow#</td>
                                    <td><cfif product_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                                    <td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#product_code#</a></td>
                                    <td>#KATEGORI#</td>
                                    <td>#product_name#</td>
                                    <td>#marka#</td>
                                    <td>#comp_FULLname#</td>
                                    <td>#COMP_NAME#</td>
                                    <td style="text-align:center"><input type="checkbox" name="product_id" id="product_id_#currentrow#" value="#product_id#" checked="checked"/></td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                        <tr>
                            <td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>                          
                        </tr>
                        </cfif>
                    </tbody>
                </cf_grid_list>
            </cf_box>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58718.düzenle'></cfsavecontent>
                <cf_box title="#message#">
                <cf_box_elements vertical="1">
                    <div class="col col-2 col-md-12 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group">
                            <div class="col col-12">
                                <cfquery name="GET_PRODUCT_COMP" datasource="#DSN3#">
                                    SELECT COMPETITIVE_ID,COMPETITIVE FROM PRODUCT_COMP ORDER BY COMPETITIVE
                                </cfquery>
                                <select name="product_status" id="product_status">
                                    <option value=""><cf_get_lang dictionary_id='37976.Ürün Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37977.Aktif Yap'></option>
                                    <option value="0"><cf_get_lang dictionary_id='37978.Pasif Yap'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="sales_status" id="sales_status">
                                    <option value=""><cf_get_lang dictionary_id='37979.Satış Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37059.Satışta'></option>
                                    <option value="0"><cf_get_lang dictionary_id='37980.Satışta Değil'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="internet_status" id="internet_status">
                                    <option value=""><cf_get_lang dictionary_id='37981.İnternet Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37982.İnternette Görünür'></option>
                                    <option value="0"><cf_get_lang dictionary_id='37983.İnternette Görünmez'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="extranet_status" id="extranet_status">
                                    <option value=""><cf_get_lang dictionary_id='37984.Extranet Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37985.Extranette Görünür'></option>
                                    <option value="0"><cf_get_lang dictionary_id='37986.Extranette Görünmez'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="zero_stock_status" id="zero_stock_status">
                                    <option value=""><cf_get_lang dictionary_id='37987.Sıfır Stok Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37558.Sıfır Stok İle Çalış'></option>
                                    <option value="0"><cf_get_lang dictionary_id='37988.Sıfır Stok İle Çalışma'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="package_control_type" id="package_control_type">
                                    <option value=""><cf_get_lang dictionary_id='37768.Paket Kontrol Tipi'></option>
                                    <option value="1"><cf_get_lang dictionary_id='40429.Kendisi'></option>
                                    <option value="2"><cf_get_lang dictionary_id='37770.Bileşenleri'></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-2 col-md-12 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="cost_status" id="cost_status">
                                    <option value=""><cf_get_lang dictionary_id='38008.Maliyet Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37175.Takip ediliyor'></option>
                                    <option value="0"><cf_get_lang dictionary_id='38009.Takip Edilmiyor'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="mixed_parcel" id="mixed_parcel">
                                    <option value=""><cf_get_lang dictionary_id='37467.Karma Koli'></option>
                                    <option value="1"><cf_get_lang dictionary_id='57495.Evet'></option>
                                    <option value="0"><cf_get_lang dictionary_id='57496.Hayır'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="scale_status" id="scale_status">
                                    <option value=""><cf_get_lang dictionary_id='38010.Terazi Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37067.Teraziye Gidiyor'></option>
                                    <option value="0"><cf_get_lang dictionary_id='38012.Teraziye Gitmiyor'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="price_authority" id="price_authority">
                                    <option value=""><cf_get_lang dictionary_id='37372.Fiyat Yetkisi'></option>
                                    <cfoutput query="get_product_comp">
                                        <option value="#competitive_id#">#competitive#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="production_status" id="production_status">
                                    <option value=""><cf_get_lang dictionary_id='37989.Üretim Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37057.Üretiliyor'></option>
                                    <option value="0"><cf_get_lang dictionary_id='37991.Üretilmesin'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="purchase_status" id="purchase_status">
                                    <option value=""><cf_get_lang dictionary_id='37992.Tedarik Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37993.Tedarik Edilsin'></option>
                                    <option value="0"><cf_get_lang dictionary_id='37994.Tedarik Edilmesin'></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-2 col-md-12 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="limited_stock" id="limited_stock">
                                    <option value=""><cf_get_lang dictionary_id='37922.Stoklarla Sınırlı'></option>
                                    <option value="1"><cf_get_lang dictionary_id='57495.Evet'></option>
                                    <option value="0"><cf_get_lang dictionary_id='57496.Hayır'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="inventory_status" id="inventory_status">
                                    <option value=""><cf_get_lang dictionary_id='37995.Envanter Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37996.Envantere Dahil Olsun'></option>
                                    <option value="0"><cf_get_lang dictionary_id='37997.Envantere Dahil Olmasın'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="serial_no_status" id="serial_no_status">
                                    <option value=""><cf_get_lang dictionary_id='37998.Seri No Takip Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37999.Takibi Yapılsın'></option>
                                    <option value="0"><cf_get_lang dictionary_id='38000.Takibi Yapılmasın'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="prototype" id="prototype">
                                    <option value=""><cf_get_lang dictionary_id='37062.Prototip'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37063.Özelleştirilebilir'></option>
                                    <option value="0"><cf_get_lang dictionary_id='38013.Özelleştirilemez'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="pos_commission_status" id="pos_commission_status">
                                    <option value=""><cf_get_lang dictionary_id='38011.Pos Komisyon Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='58998.Hesapla'></option>
                                    <option value="0"><cf_get_lang dictionary_id='29440.Hesaplama'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <select name="is_quality" id="is_quality">
                                    <option value=""><cf_get_lang dictionary_id='59157.Kalite'> <cf_get_lang dictionary_id='30111.Durumu'></option>
                                    <option value="1"><cf_get_lang dictionary_id='37175.Takip ediliyor'></option>
                                    <option value="0"><cf_get_lang dictionary_id='38009.Takip Edilmiyor'></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-6 col-xs-12" type="column" index="4" sort="true">
                        <div>
                            <label class="txtbold col col-12" height="30"><cf_get_lang dictionary_id='58674.Yeni'><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <div class="input-group">
                                    <input name="new_comp" type="text"  id="new_comp" style="width:250px;" onfocus="AutoComplete_Create('new_comp','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','new_company_id','','3','140');" value="" autocomplete="off">
                                    <input type="hidden" name="new_company_id" id="new_company_id" value="">
                                    <span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=set2_.new_company_id&field_comp_name=set2_.new_comp&select_list=2</cfoutput>','list','popup_list_pars');" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
                                </div>
                            </div>
                        </div>
                        <div>
                            <label class="txtbold col col-12"><cf_get_lang dictionary_id='58847.Marka'> <cf_get_lang dictionary_id='37673.Yeniden Sipariş Noktası'></label>
                        </div>  
                        <div class="form-group">
                            <div class="col col-12">
                                <cf_wrkproductbrand
                                    width="250"
                                    compenent_name="getProductBrand"               
                                    boxwidth="250"
                                    boxheight="150"
                                    fieldId="new_brand_id"
                                    fieldName="new_brand_name"
                                    returnInputValue="new_brand_id,new_brand_name"
                                    returnQueryValue="BRAND_ID,BRAND_NAME"
                                    brand_id=""
                                    >
                            </div>
                        </div> 
                        <div>
                            <label class="txtbold col col-12"><cf_get_lang dictionary_id='57486.Kategori'> <cf_get_lang dictionary_id='37673.Yeniden Sipariş Noktası'></label>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="cat_id" id="cat_id" value="">
                                    <input type="hidden" name="cat" id="cat" value="">
                                    <input name="category_name" type="text" id="category_name" style="width:200px;" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','0');" value="" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=0&field_id=set2_.cat_id&field_code=set2_.cat&field_name=set2_.category_name</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-6 col-xs-12" type="column" index="5" sort="true">
                        <div>
                            <label class="txtbold col col-12"><cf_get_lang dictionary_id='32671.Ek Bilgiler'></label>
                        </div>        
                        <div class="form-group">
                           
                            <div class="col col-6">  
                                <input type="text" value="" name="tax_purchase" id="tax_purchase" style="width:50px;" placeholder="<cf_get_lang dictionary_id='42993.Alış KDV'>"> 
                            </div>
                          
                            <div class="col col-6">   
                                <input type="text" value="" name="tax" id="tax" style="width:50px;" placeholder="<cf_get_lang dictionary_id='42994.Satış KDV'>">
                            </div>
                        </div>
                        <div>
                            <label class="txtbold col col-12"><cf_get_lang dictionary_id='34311.Alternatif'> <cf_get_lang dictionary_id='58061.Cari'> 1</label>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <div class="input-group">
                                    <input name="new_comp1" type="text"  id="new_comp1" style="width:250px;" onfocus="AutoComplete_Create('new_comp1','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','new_company_id1','','3','140');" value="" autocomplete="off">
                                    <input type="hidden" name="new_company_id1" id="new_company_id1" value="">
                                    <span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=set2_.new_company_id1&field_comp_name=set2_.new_comp1&select_list=2</cfoutput>','list','popup_list_pars');" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
                                </div>
                            </div>
                        </div>
                        <div>
                            <label class="txtbold col col-12"><cf_get_lang dictionary_id='34311.Alternatif'> <cf_get_lang dictionary_id='58061.Cari'> 2</label>
                        </div>
                        <div class="form-group">
                            <div class="col col-12">
                                <div class="input-group">
                                    <input name="new_comp2" type="text"  id="new_comp2" style="width:250px;" onfocus="AutoComplete_Create('new_comp','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','new_company_id2','','3','140');" value="" autocomplete="off">
                                    <input type="hidden" name="new_company_id2" id="new_company_id2" value="">
                                    <span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=set2_.new_company_id2&field_comp_name=set2_.new_comp2&select_list=2</cfoutput>','list','popup_list_pars');" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>	
                    <cf_workcube_buttons is_upd='0' is_delete='0'>
                </cf_box_footer>
            </cf_box>
        </cfform>
    </cfif>
<script type="text/javascript">
	function control_tr()
	{
		if(document.set_.upd_type[0].checked==true)
		{
			gizle(tedarikci_1);
			gizle(tedarikci_2);
			gizle(marka_1);
			gizle(marka_2);
			goster(kategori_1);
			goster(kategori_2);
            goster(company_1);
            goster(comp_branches);
            goster(company_2);
            goster(branch_1);
            
		}
		else if(document.set_.upd_type[4].checked==true)
		{
			gizle(tedarikci_1);
			gizle(tedarikci_2);
			gizle(marka_1);
			gizle(marka_2);
			gizle(kategori_1);
			gizle(kategori_2);
            gizle(company_1);
            gizle(comp_branches);
            gizle(company_2);
            gizle(branch_1);
		}
		else if(document.set_.upd_type[1].checked==true)
		{
			goster(tedarikci_1);
			goster(tedarikci_2);
			gizle(kategori_1);
			gizle(kategori_2);
            gizle(company_1);
            gizle(company_2);
            gizle(comp_branches);
            gizle(branch_1);
			gizle(marka_1);
			gizle(marka_2);
		}
		else if(document.set_.upd_type[2].checked==true)
		{
			gizle(tedarikci_1);
			gizle(tedarikci_2);
			gizle(kategori_1);
			gizle(kategori_2);
            gizle(company_1);
            gizle(company_2);
            gizle(comp_branches);
            gizle(branch_1);
			goster(marka_1);
			goster(marka_2);
		}
		else if(document.set_.upd_type[3].checked==true)
		{
			goster(tedarikci_1);
			goster(tedarikci_2);
			gizle(kategori_1);
			gizle(kategori_2);
            gizle(company_1);
            gizle(company_2);
            gizle(comp_branches);
            gizle(branch_1);
			goster(marka_1);
			goster(marka_2);
		}
	}
	control_tr();
	function kontrol()
	{
			if(document.set_.upd_type[0].checked==true)
			{
				if(document.set_.cat.value=='')
				{
					alert("<cf_get_lang dictionary_id="58947.Kategori Seçmelisiniz">");
					return false;
				}
			}
			else if(document.set_.upd_type[4].checked==true)
			{
				if(document.set_.keyword.value == '' || document.set_.keyword.value.length < 3)
				{
					alert("<cf_get_lang dictionary_id='51678.En Az 3 Karakter Girmelisiniz!'>");
					return false;	
				}
			}
			else if(document.set_.upd_type[1].checked==true)
			{
				if(document.set_.comp.value=='' || document.set_.company_id.value=='')
				{
					alert("<cf_get_lang dictionary_id='38002.Tedarikçi Seçmelisiniz'>!");
					return false;
				}
			}
			else if(document.set_.upd_type[2].checked==true)
			{
				if(document.set_.brand_name.value=='' || document.set_.brand_id.value=='')
				{
					alert("<cf_get_lang dictionary_id='58946.Marka Seçmelisiniz'>");
					return false;
				}
			}
			else if(document.set_.upd_type[3].checked==true)
			{
				if(document.set_.brand_name.value=='' || document.set_.brand_id.value=='')
				{
					alert("<cf_get_lang dictionary_id='58946.Marka Seçmelisiniz'>");
					return false;
				}
				if(document.set_.comp.value=='' || document.set_.company_id.value=='')
				{
					alert("<cf_get_lang dictionary_id='38002.Tedarikçi Seçmelisiniz'>!");
					return false;
				}
			}
			return true;
	}	
	
	function filter_char(strng)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=product.ajax_product_categories&keyword=' + strng + '','prod_cats',1);
	}
	
	function showBranch(comp_id)	
	{
        var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=product.ajax_company_branches&company_id="+comp_id;
        AjaxPageLoad(send_address,'comp_branches',1,'İlişkili Şubeler');
	}
</script>