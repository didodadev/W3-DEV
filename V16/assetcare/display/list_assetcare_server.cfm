<cf_xml_page_edit>
<cfparam name="attributes.assetp_cat_ids" default="">
<cfparam name="attributes.ready_sale_subs" default="">
<cfif isdefined('x_assetp_cat_ids') and len(x_assetp_cat_ids)>
    <cfset attributes.assetp_cat_ids=x_assetp_cat_ids>                   
</cfif>
<cfif isdefined('x_ready_sale_subs') and len(x_ready_sale_subs)>
    <cfset attributes.ready_sale_subs=x_ready_sale_subs>                  
</cfif>
<cfset assetp_ = createObject("component", "V16.assetcare.cfc.assetcare_server")>
<cfset assetp_.dsn = dsn />
<cfset get_asset_it_server = assetp_.get_asset_server(assetp_cat_ids:attributes.assetp_cat_ids, ready_sale_subs:attributes.ready_sale_subs)>
<div class="col col-12 col-xs-12">
    <cf_box title="#getLang('','Workcloud Sunucular',65469)#">
        <cf_grid_list>
            <thead>
                <tr>
                    <th class="text-center"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='51238.Sunucu'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='47987.IP'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='65471.vCPU'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='65472.RAM'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='47940.HDD'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='58832.Abone'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='61700.Aktif Kullanıcı'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='65473.Satışa Hazır Abone'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='41895.Satılabilir'><cf_get_lang dictionary_id='57930.Kullanıcı'></th>
                </tr>
            </thead>
            <cfif get_asset_it_server.recordcount>
                <cfoutput query="get_asset_it_server">
                    <cfif not len(total_user)><cfset total_user_ = 0><cfelse><cfset total_user_= total_user></cfif>
                    <cfif not len(NUMBER_OF_USERS)><cfset NUMBER_OF_USERS_ = 0><cfelse><cfset NUMBER_OF_USERS_= NUMBER_OF_USERS></cfif>
                    <tbody>
                        <tr>
                            <td class="text-center">#currentrow#</td>
                            <td class="text-center">#assetp#</td>
                            <td class="text-center">#asset_ip#</td>
                            <td class="text-center">#IT_PRO#</td>
                            <td class="text-center">#IT_MEMORY#</td>
                            <td class="text-center">#IT_HDD#</td>
                            <td class="text-center">#SUM_SUBS#</td>
                            <td class="text-center"><cfif len(active_user)>#ACTIVE_USER#<cfelse>0</cfif></td>
                            <td class="text-center">#READY_SUBS#</td>
                            <td class="text-center">#NUMBER_OF_USERS_ - total_user_#</td>
                        </tr>
                    </tbody>
                </cfoutput>
            <cfelse>
                <tbody>
                    <tr>
                        <td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </tbody>
            </cfif>
        </cf_grid_list>
    </cf_box>
</div>