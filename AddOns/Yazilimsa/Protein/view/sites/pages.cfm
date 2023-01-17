<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\pages.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Site sayfa listesi
    Notes :         AddOns\Yazilimsa\Protein\view\sites\site.cfm dosyasına include edilir
--->
<cfparam name="attributes.site" default="">
<!--- TODO: PROTEIN_PAGES querysi cfc ye alınmalı--->
<cfquery name="PROTEIN_PAGES" datasource="#dsn#">
    SELECT PAGE_ID , TITLE, FRIENDLY_URL, STATUS,SITE FROM PROTEIN_PAGES WHERE SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#">
</cfquery>
<cf_box title="#getLang('','Pages',62316)#" uidrop="1" hide_table_column="1"> 
    <cf_flat_list sort="1">
        <thead>
            <tr>
                <th>#</th>
                <th><cf_get_lang dictionary_id='44794.Title'></th>
                <th><cf_get_lang dictionary_id='52874.Active'></th>
                <th><cf_get_lang dictionary_id='50659.Kullanıcı Dostu URL'></th>
                <th width="20" class="header_icn_none">
                    <a href="<cfoutput>#request.self#?fuseaction=protein.pages&event=add&site=#attributes.site#</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                </th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="PROTEIN_PAGES"> 
                <tr>
                    <td>#currentRow#</td>
                    <td><a href="index.cfm?fuseaction=protein.pages&event=upd&page=#PAGE_ID#&site=#SITE#">#TITLE#</a></td>
                    <td><cfif STATUS eq 1><cf_get_lang dictionary_id='52874.Active'><cfelse><cf_get_lang dictionary_id='57494.Passive'></cfif></td>
                    <td>#FRIENDLY_URL#</td>
                    <td width="20">
                        <a href="index.cfm?fuseaction=protein.pages&event=upd&page=#PAGE_ID#&site=#SITE#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_flat_list>
</cf_box>
