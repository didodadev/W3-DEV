<cf_xml_page_edit fuseact="assetcare.list_assetp">
    <cfset colspan = 14>

    <cfparam name="attributes.page" default=1>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_assetps1.cfm">
	<cfparam name="attributes.totalrecords" default='#get_assetps.query_count#'>
<cfelse>
	<cfset GET_ASSETPS.recordcount = 0>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cf_grid_list>
    <thead> 
        <tr>
            <th><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th><cf_get_lang dictionary_id='29452.Varlık'></th>
            <th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
            <cfif xml_show_detail eq 1>
                <cfset ++colspan>
                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
            </cfif>
                <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                <th><cf_get_lang dictionary_id='57637.Serial No'></th>
                <th><cf_get_lang dictionary_id='48388.Varlık Tipi'></th>
            <cfif isdefined('xml_assetp_sub_catid') and xml_assetp_sub_catid eq 1>
                <cfset ++colspan>
                <th><cf_get_lang dictionary_id='47876.Varlık alt kategori'></th>
            </cfif>
                <th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
                <th><cf_get_lang dictionary_id='57544.Sorumlu'> 1</th>
            <cfif xml_show_responsible eq 1>
                <cfset ++colspan>
                <th><cf_get_lang dictionary_id='57544.Sorumlu'> 2</th>
            </cfif>
                <th><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></th>
                <th><cf_get_lang dictionary_id='58225.Model'></th>
                <th><cf_get_lang dictionary_id='48014.Mülkiyet'></th>
                <th><cf_get_lang dictionary_id="60371.Mekan"></th>
            <cfif xml_show_stage eq 1>
                <cfset ++colspan>	
                <th><cf_get_lang dictionary_id='57756.Durum'></th>
            </cfif>
            <th><cf_get_lang dictionary_id='57482.Asama'></th>
            <cfif xml_company_date eq 1>
                <cfset ++colspan>
                <th><cf_get_lang dictionary_id='47893.Alış Tarihi'></th>
            </cfif>
            <cfif xml_show_tarih eq 1>
                <cfset ++colspan>
                <th><cf_get_lang dictionary_id='57627.Tarihi'></th>
            </cfif>
            <!-- sil --><th width="20" class="header_icn_none text-center"><a href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_assetp&event=add'><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
        </tr>
    </thead>
    <tbody>
        <cfif get_assetps.recordcount>
            <cfoutput query="get_assetps">
                <tr>
                    <td>#RowNum#</td>
                    <td><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#assetp_id#" class="tableyazi">#assetp#</a></td>
                    <td>#INVENTORY_NUMBER#</td>
                    <cfif xml_show_detail eq 1>
                    <td <cfif len(ASSETP_DETAIL) gt 50>title="#ASSETP_DETAIL#"</cfif>>#left(ASSETP_DETAIL,50)#<cfif len(ASSETP_DETAIL) gt 50>...</cfif></td>
                    </cfif>
                    <td>#barcode#</td>
                    <td>#serial_no#</td>
                    <td>#assetp_cat#</td>
                    <cfif isdefined('xml_assetp_sub_catid') and xml_assetp_sub_catid eq 1>
                    <td>#assetp_sub_cat#</td>
                    </cfif>
                    <td>#branch_name# / #department_head#</td>
                    <td><cfif len(employee_id)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#EMP_NAME#</a></cfif></td>
                    <cfif xml_show_responsible eq 1>
                        <td>#NAME_2#</td>
                    </cfif>
                    <td>
                        <cfif len(brand_type_cat_id)>
                        #brand_name# - #brand_type_name# - #brand_type_cat_name#
                        </cfif>
                    </td>
                    <td>                    
                #attributes.make_year#
                    </td>
                    <td>
                        <cfswitch expression="#property#">
                            <cfcase value="1"><cf_get_lang dictionary_id='57449.Satın Alma'></cfcase>
                            <cfcase value="2"><cf_get_lang dictionary_id='48065.Kiralama'></cfcase>
                            <cfcase value="3"><cf_get_lang dictionary_id='48066.Leasing'></cfcase>
                            <cfcase value="4"><cf_get_lang dictionary_id='48067.Sözleşmeli'></cfcase>
                        </cfswitch>
                    </td>
                    <td>#space_code# #space_name#</td>
                    <cfif xml_show_stage eq 1>
                        <td>#asset_state#</td>
                    </cfif>
                    <td><cfif status><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                    <cfif xml_company_date eq 1>
                        <td>#dateformat(sup_company_date,dateformat_style)#</td>
                    </cfif>
                    <cfif xml_show_tarih eq 1>
                        <td>#dateformat(date,dateformat_style)#</td>
                    </cfif>
                    <!-- sil --><td><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#assetp_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td height="22" colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>

<cfset url_str = "">
<cfif len(attributes.keyword)>
    <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.assetp_catid)>
    <cfset url_str = "#url_str#&assetp_catid=#attributes.assetp_catid#">
</cfif>	
<cfif len(attributes.branch_id)>
    <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif len(attributes.department)>
    <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
    <cfset url_str = "#url_str#&department=#attributes.department#">
</cfif>
<cfif len(attributes.emp_id)>
    <cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
</cfif>
<cfif len(attributes.employee_name)>
    <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
</cfif>	
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
    <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif len(attributes.is_active)>
    <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
</cfif>
<cfif len(attributes.brand_type_id)>
    <cfset url_str = "#url_str#&brand_type_id=#attributes.brand_type_id#">
</cfif>
<cfif len(attributes.brand_name)>
    <cfset url_str = "#url_str#&brand_name=#attributes.brand_name#">
</cfif>
<cfif len(attributes.make_year)>
    <cfset url_str = "#url_str#&make_year=#attributes.make_year#">
</cfif>
<cfif len(attributes.property)>
    <cfset url_str = "#url_str#&property=#attributes.property#">
</cfif>
<cfif len(attributes.is_collective_usage)>
    <cfset url_str = "#url_str#&is_collective_usage=#attributes.is_collective_usage#">
</cfif>
<cfif len(attributes.position_code2) and len(attributes.member_type_2) and len(attributes.position2)>
    <cfset url_str = "#url_str#&position_code2=#attributes.position_code2#&member_type_2=#attributes.member_type_2#&position2=#attributes.position2#">
</cfif>
<cfif len(attributes.assetp_status)>
    <cfset url_str = "#url_str#&assetp_status=#attributes.assetp_status#">
</cfif>
<cfif len(attributes.order_type)>
    <cfset url_str = "#url_str#&order_type=#attributes.order_type#">
</cfif>
<cfif len(attributes.assetp_sub_catid)>
    <cfset url_str="#url_str#&assetp_sub_catid=#attributes.assetp_sub_catid#">
</cfif>
<cfif len(attributes.asset_p_space_id)>
    <cfset url_str = "#url_str#&keyword=#attributes.asset_p_space_id#">
</cfif>
<!-- sil -->
<cf_paging
    page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="assetcare.list_assetp#url_str#">
<!-- sil -->