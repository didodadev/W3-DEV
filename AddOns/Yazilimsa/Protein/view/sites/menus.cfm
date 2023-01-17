<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\menus.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Site menü listesi
    Notes :         AddOns\Yazilimsa\Protein\view\sites\site.cfm dosyasına include edilir
--->
<!--- TODO: PROTEIN_MENUS querysi cfc ye alınmalı--->
<cfquery name="PROTEIN_MENUS" datasource="#dsn#">
    SELECT * FROM PROTEIN_MENUS WHERE  SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#">
</cfquery>
<cf_box title="#getLang('','Menu Definitions',62317)#" uidrop="1" hide_table_column="1"> 
    <cf_flat_list sort="1">
        <thead>
            <tr>
                <th>#</th>
                <th><cf_get_lang dictionary_id='52847.Menu'></th>
                <th><cf_get_lang dictionary_id='52874.Active'></th>
                <th width="20" class="header_icn_none">
                    <a href="<cfoutput>#request.self#?fuseaction=protein.menus&event=add&site=#attributes.site#</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                </th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="PROTEIN_MENUS"> 
                <tr>
                    <td>#currentRow#</td>
                    <td>
                        <a href="index.cfm?fuseaction=protein.menus&event=upd&menu=#MENU_ID#&site=#SITE#">
                            #MENU_NAME#
                            <cfif IS_DEFAULT eq 1> / <small class="font-red"><cf_get_lang dictionary_id='43116.Default'></small></cfif>
                        </a>
                    </td>
                    <td><cfif MENU_STATUS eq 1><cf_get_lang dictionary_id='52874.Active'><cfelse><cf_get_lang dictionary_id='57494.Passive'></cfif></td>
                    <td width="20">
                        <a href="index.cfm?fuseaction=protein.menus&event=upd&menu=#MENU_ID#&site=#SITE#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_flat_list>
</cf_box>
