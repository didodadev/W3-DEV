<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\templates.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Kabuk tasarımları listesi Layout ve Template
    Notes :         
--->
<cfparam name="attributes.site" default="">
 <!--- TODO: PROTEIN_TEMPLATES querysi cfc ye alınmalı--->
<cfquery name="PROTEIN_TEMPLATES" datasource="#dsn#">
    SELECT * FROM PROTEIN_TEMPLATES WHERE SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#">
</cfquery>
<cfsavecontent variable="message">Templates</cfsavecontent>
<cf_box title="#message#" uidrop="1" hide_table_column="1"> 
    <cf_flat_list sort="1">
        <thead>
            <tr>
                <th>#</th>
                <th><cf_get_lang dictionary_id='44794.Title'></th>
                <th><cf_get_lang dictionary_id='52874.Active'></th>
                <th><cf_get_lang dictionary_id='52735.Type'></th>
                <th width="20" class="header_icn_none">
                    <a href="<cfoutput>#request.self#?fuseaction=protein.templates&event=add&site=#attributes.site#</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                </th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="PROTEIN_TEMPLATES"> 
                <tr>
                    <td>#currentRow#</td>
                    <td><a href="index.cfm?fuseaction=protein.templates&event=upd&template=#TEMPLATE_ID#&site=#SITE#">#TITLE#</a></td>
                    <td><cfif STATUS eq 1><cf_get_lang dictionary_id='52874.Active'><cfelse><cf_get_lang dictionary_id='57494.Passive'></cfif></td>
                    <td><cfif TYPE eq 1><cf_get_lang dictionary_id='58070.Layout'><cfelse><cf_get_lang dictionary_id='62318.Template'></cfif></td>
                    <td width="20">
                        <a href="index.cfm?fuseaction=protein.templates&event=upd&template=#TEMPLATE_ID#&site=#SITE#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_flat_list>
</cf_box>
