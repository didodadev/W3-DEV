<!---
File: organization_chart.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 11.02.2020
Controller: -
Description: Organizasyon Şema Chart
--->
<cfset components = createObject('component','V16.hr.cfc.organization_chart')>
<cfset components_2 = createObject('component','V16.com_mx.component.flah_remoting.organization_chart')>
<cfset aa = components_2.findPositions(filter:4)>
<cfdump var="#aa#">
<cfset get_organization = components.GET_ORGANIZATION()>
<cf_box id="list_org_search" closable="0" collapsable="0">
    <cf_big_list_search_area>
        <cfform name="organization_chart" method="post" action="">
            <div class="row ">
                <div class="col col-2 col-md-2 col-sm-12 col-xs-12" >
                    <div class = "form-group">
                        <label class = "col col-12">Tip</label>
                        <div class="col col-12"> 
                            <select id = "type" name = "type">
                                <option value = "1"><cf_get_lang dictionary_id = "57972.Organizasyon"></option>
                                <option value = "2"><cf_get_lang dictionary_id = "58497.Pozisyon"></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-2 col-sm-12 col-xs-12" >
                    <div class = "form-group">
                        <label class = "col col-12"><cf_get_lang dictionary_id = "42984.Üst Düzey Birim"></label>
                        <div class="col col-12"> 
                            <select id = "type" name = "type">
                                
                                    <option value = "1"><cf_get_lang dictionary_id = "57972.Organizasyon"></option>
                                    <option value = "2"><cf_get_lang dictionary_id = "58497.Pozisyon"></option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_big_list_search_area>
</cf_box>