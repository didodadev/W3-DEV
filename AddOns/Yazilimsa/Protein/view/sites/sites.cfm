<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\sites.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Site listesi
    Notes :         
--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_submit" default="1">
<cfif isdefined('attributes.is_submit') and len(attributes.is_submit)>
    <!--- TODO: PROTEIN_SITES querysi cfc ye alınmalı--->
    <cfquery name="PROTEIN_SITES" datasource="#dsn#">
        SELECT * FROM PROTEIN_SITES WHERE 1 = 1 <cfif isdefined('attributes.keyword') and len(attributes.keyword)> AND DOMAIN LIKE '%#attributes.keyword#%' </cfif>
    </cfquery>
</cfif>
<div class="col col-6 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Sites',29671)#" uidrop="1" hide_table_column="1"> 
        <cfform name="form" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.site">
            <input name="is_submit" id="is_submit" value="1" type="hidden">
            <cf_box_search>
                <div class="form-group" id="form_ul_keyword">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
        <cf_flat_list sort="1">
            <thead>
                <tr>
                    <th width="20">#</th>
                    <th><cf_get_lang dictionary_id='57892.Domain'></th>
                    <th><cf_get_lang dictionary_id='52874.Active'></th>
                    <th><cf_get_lang dictionary_id='62286.Live'> / <cf_get_lang dictionary_id='62287.Maintenance'></th>
                    <th><cf_get_lang dictionary_id='30964.Public'> / <cf_get_lang dictionary_id='31221.Private'></th>
                    <th><cf_get_lang dictionary_id='62288.Whom'></th>
                    <th><cf_get_lang dictionary_id='63171.Friendly Url'></th>
                    <th width="20" class="header_icn_none text-center">
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=protein.site&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                    </th>
                </tr>
            </thead>
            <tbody>
            <cfif isdefined('attributes.is_submit') and len(attributes.is_submit) and  PROTEIN_SITES.recordcount>
                <cfoutput query="PROTEIN_SITES"> 
                    <tr>
                        <td>#currentRow#</td>
                        <td><a href="index.cfm?fuseaction=protein.site&event=upd&site=#SITE_ID#">#DOMAIN#</a></td>
                        <td><cfif STATUS eq 1><cf_get_lang dictionary_id='52874.Active'><cfelse><cf_get_lang dictionary_id='52860.Passive'></cfif></td>
                        <td><cfif MAINTENANCE_MODE eq 1><cf_get_lang dictionary_id='62287.Maintenance'><cfelse><cf_get_lang dictionary_id='62286.Live'></cfif></td>
                        <td></td>
                        <td></td>
                        <td class="text-center">
                            <a href="#request.self#?fuseaction=protein.friendly_url&site=#SITE_ID#"><i class="icon-link" title="Friendly Url" alt="Friendly Url"></i></a>
                        </td>
                        <td class="text-center">
                            <a href="index.cfm?fuseaction=protein.site&event=upd&site=#SITE_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="7"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                </tr>
            </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>