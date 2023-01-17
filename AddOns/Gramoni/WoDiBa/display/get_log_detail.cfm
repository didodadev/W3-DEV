<cfset get_log = createObject("AddOns.Gramoni.WoDiBa.cfc.Functions").GetLoggerInfo2(attributes.id) />
                    
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="LOG KAYIT" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <!--- <cf_box title="#getLang('','LOG KAYIT',29408)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> --->    
        <!---  <cf_box title = "LOG KAYIT" closable = "1" collapsable = "0" resize = "0"> --->
                <cf_flat_list>
                    <cf_grid_list>
                    <tbody>
                        <tr>
                              <th align="left"><cf_get_lang dictionary_id='57543.Message'></th>
                                <th><cf_get_lang dictionary_id='31901.Details'></th>
                                <th><cf_get_lang dictionary_id='61329.Log Type'></th>
                                <th><cf_get_lang dictionary_id='58527.ID'></th>
                                <th><cf_get_lang dictionary_id='57627.Record Date'></th> 
                        </tr>
                        <cfoutput>
                            <tr>
                                <td>#get_log.MESSAGE#</td>
                                <td align="middle">#get_log.DETAILS#</td>
                                <td align="middle">#get_log.LOG_TYPE#</td>
                                <td align="middle">#get_log.WDB_ACTION_ID#</td>
                                <td align="middle">#dateFormat('#get_log.REC_DATE#',"dd.mm.yyyy- HH:DD")#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>
                </cf_flat_list>
            
    </cf_box>
</div>