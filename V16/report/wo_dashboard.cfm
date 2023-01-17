<cf_catalystheader>
<cfquery name="woTypeCountQuery" datasource="#dsn#">
--Tiplerine Göre WO
SELECT 
CASE 
WHEN TYPE=0 THEN 'WBO' 
WHEN TYPE=1 THEN 'Param' 
WHEN TYPE=2 THEN 'System' 
WHEN TYPE=3 THEN 'Import' 
WHEN TYPE=4 THEN 'Period' 
WHEN TYPE=5 THEN 'Maintenance' 
WHEN TYPE=6 THEN 'Utility' 
WHEN TYPE=7 THEN 'Dev' 
WHEN TYPE=8 THEN 'Report' 
WHEN TYPE=9 THEN 'General' 
WHEN TYPE=10 THEN 'Child WO' 
WHEN TYPE=11 THEN 'Query-Backend' 
WHEN TYPE=12 THEN 'Export' 
WHEN TYPE=13 THEN 'Dashboard' 
END
AS TYPE,
COUNT(FULL_FUSEACTION) AS TotalWO FROM WRK_OBJECTS 
GROUP BY TYPE
ORDER BY TotalWO  DESC
</cfquery>

<cfquery name="woModuleCountQuery" datasource="#dsn#">
--Module'e Göre
SELECT WM.MODULE,COUNT(WO.FULL_FUSEACTION) TotalWO FROM WRK_OBJECTS WO
LEFT JOIN WRK_MODULE WM ON WO.MODULE_NO=WM.MODULE_NO
GROUP BY WM.MODULE
ORDER BY TotalWO  DESC
</cfquery>

<cfquery name="woStatuCountQuery" datasource="#dsn#">
--Statulerine Göre
SELECT STATUS,COUNT(FULL_FUSEACTION) TotalWO FROM WRK_OBJECTS
GROUP BY STATUS
ORDER BY TotalWO  DESC
</cfquery>

<cfquery name="woAuthorCountQuery" datasource="#dsn#">
--AUTHORlara Göre
SELECT AUTHOR,COUNT(FULL_FUSEACTION) TotalWO FROM WRK_OBJECTS 
GROUP BY AUTHOR
ORDER BY TotalWO  DESC
</cfquery>
<cfquery name="woCountQuery" datasource="#dsn#">
    SELECT COUNT(*) TotalWO FROM WRK_OBJECTS
</cfquery>
<div class="col col-3 col-xs-12 uniqueRow" id="module">
    <cfsavecontent  variable="head">MODULE</cfsavecontent>
        <cf_box title="#head#">
    
        <cf_flat_list>
            <thead>
                <tr>
                    <th>MODULE</th>
                    <th class="text-right"> <i class="fa fa-bar-chart"></i></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="woModuleCountQuery">
                    <tr>
                        <td>#MODULE#</td>
                        <td class="text-right">#TotalWO#</td>
                    </tr>
                </cfoutput>  
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
<div class="col col-3 col-xs-12 uniqueRow" id="author">
    <cfsavecontent  variable="head">AUTHOR</cfsavecontent>
    <cf_box  title="#head#">
        <cf_flat_list>
            <thead>
                <tr>
                    <th>AUTHOR</th>
                    <th class="text-right"><i class="fa fa-bar-chart"></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="woAuthorCountQuery">
                    <tr>
                        <td>#AUTHOR#</td>
                        <td class="text-right">#TotalWO#</td>
                    </tr>
                </cfoutput>  
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
<div class="col col-3 col-xs-12 uniqueRow" id="type">
    <cfsavecontent  variable="head">TYPE</cfsavecontent>
    <cf_box title="#head#" >
        <cf_flat_list>
            <thead>
                <tr>
                    <th>TYPE</th>
                    <th class="text-right"><i class="fa fa-bar-chart"></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="woTypeCountQuery">
                    <tr>
                        <td>#TYPE#</td>
                        <td class="text-right">#TotalWO#</td>
                    </tr>
                </cfoutput>  
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
<div class="col col-3 col-xs-12 uniqueRow" id="author">
    <cfsavecontent  variable="head">STATUS</cfsavecontent>
    <cf_box title="#head#">
        <cf_flat_list>
            <thead>
                <tr>
                    <th>STATUS</th>
                    <th class="text-right"><i class="fa fa-bar-chart"></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="woStatuCountQuery">
                    <tr>
                        <td>#STATUS#</td>
                        <td class="text-right">#TotalWO#</td>
                    </tr>
                </cfoutput>  
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
