<!---
    File :          AddOns\Yazilimsa\Protein\view\widgets\widgets.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Protein sitesinde kullanılmış widgetlerı listeler
--->
<cfparam name="attributes.site" default="">
<cfquery name="PROTEIN_WIDGET" datasource="#dsn#">
    SELECT WIDGET_ID, TITLE, WIDGET_NAME, STATUS, SITE FROM PROTEIN_WIDGETS WHERE SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#">
</cfquery>
<cfquery name="thısDomaın" datasource="#dsn#">
    SELECT DOMAIN FROM PROTEIN_SITES WHERE SITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#">
</cfquery>
<cfset pageHead = "#pageHead# - #thısDomaın.DOMAIN#">
<cf_catalystHeader>
<div class="row">
    <div class="col col-6 col-md-9 col-sm-12 pl-0"> 
        <cfsavecontent variable="message">Widgets</cfsavecontent>
        <cf_box title="#message#" uidrop="1" hide_table_column="1"> 
            <cf_flat_list sort="1">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Title</th>
                        <th>Active</th>
                        <th>Widget</th>
                        <th class="header_icn_none">
                            <a href="<cfoutput>#request.self#?fuseaction=protein.widgets&event=add&site=#attributes.site#</cfoutput>"><i class="fa fa-plus"></i></a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="PROTEIN_WIDGET"> 
                        <tr>
                            <td>#currentRow#</td>
                            <td><a href="index.cfm?fuseaction=protein.widgets&event=upd&widget=#WIDGET_ID#&site=#SITE#">#TITLE#</a></td>
                            <td><cfif STATUS eq 1>Active<cfelse>Passive</cfif></td>
                            <td>#WIDGET_NAME#</td>
                            <td>
                                <a href="index.cfm?fuseaction=protein.widgets&event=upd&widget=#WIDGET_ID#&site=#SITE#"><i class="fa fa-pencil"></i></a>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_flat_list>
        </cf_box>
  </div>
</div>