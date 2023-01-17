<cfset getComponent = createObject('component','V16.stock.cfc.measurement_parameters')>
<cfset get_measure = getComponent.GET_MEASUREMENT_PARAMETERS()>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='62815.Ölçüm Parametreleri'></cfsavecontent>
<cf_box title="#head#" uidrop="1" hide_table_column="1">
    <cf_grid_list>
        <thead>
            <tr>
                <th></th>
                <th><cf_get_lang dictionary_id='36538.Birim Adı'></th>
                <th width="20px"><a href="<cfoutput>#request.self#?fuseaction=stock.measurement_parameters&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th> 
            </tr>
        </thead>
        <tbody>
            <cfoutput query ="get_measure">
                <tr>
                    <td>#currentrow#</td>
                    <td><a href="#request.self#?fuseaction=stock.measurement_parameters&event=upd&measurement_id=#MEASUREMENT_ID#">#MEASUREMENT_NAME#</a></td>
                    <td ><a href="#request.self#?fuseaction=stock.measurement_parameters&event=upd&measurement_id=#MEASUREMENT_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Update'>"></i></a></td> 
                </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
</cf_box>