<cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
<cfset  ay= "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfinclude template="../query/get_usage_purpose.cfm">
<cfinclude template="../query/get_vehicle_cat.cfm">
<cfinclude template="../query/get_assetp_groups.cfm">
<cfform  name="monthly_report" method="post" action="#request.self#?fuseaction=assetcare.vehicle_monthly_km_report">
    <cf_box_elements> 
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
            <div class="form-group">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='170.Kullanıcı Şube'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="depot_id" id="depot_id" value="">
                        <cfinput type="Text" name="depot" value="" style="width:160px;">
                        <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=monthly_report.depot&field_branch_id=monthly_report.depot_id','list','popup_list_branches')"></span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="assetp_id" id="assetp_id" value="">
                        <input name="assetp" id="assetp" type="text" style="width:150px;">
                        <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=monthly_report.assetp_id&field_name=monthly_report.assetp','list','popup_list_ship_vehicles');"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
            <div class="form-group">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='145.Kullanıcı Departman'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="department_id" id="department_id" value="">
                        <cfinput type="Text" name="department" value="" style="width:160px;">
                        <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=monthly_report.department&field_id=monthly_report.department_id','list','popup_list_departments')"></span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='641.Başlangıç Tarihi'></label>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <!--- yukari dil eklenmis hali tasindi FB20070921 <cfset ay = "Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık"> --->
                    <select name="fuel_month" id="fuel_month" style="width:79px;">
                        <cfoutput>
                            <cfloop index="i" from="1" to="12">
                            <option value="#i#">#ListGetAt(ay,i)#</option>
                            </cfloop>
                        </cfoutput>
                    </select>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <select name="fuel_year" id="fuel_year" style="width:68px;">
                        <cfoutput>
                            <cfloop index="i" from="#dateformat(now(),"yyyy")#" to="1970" step="-1">
                                <option value="#i#">#i#</option>
                            </cfloop>
                        </cfoutput>
                    </select>
                </div>
            </div>
        </div>
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
            <div id="fuel_graph"></div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cfsavecontent variable="insert_info"><cf_get_lang_main no='153.Ara'></cfsavecontent>
        <cfsavecontent variable="insert_alert"><cf_get_lang no='631.Arama Yapmak İstediğinizden Emin Misiniz?'></cfsavecontent>
        <cf_workcube_buttons is_upd='0' is_delete='0' is_cancel='0' is_disable='0' insert_info='#insert_info#' insert_alert='#insert_alert#'>
    </cf_box_footer>
</cfform>

