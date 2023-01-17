<cf_get_lang_set module_name="stock">
<cfparam name="attributes.modal_id" default="">
<cfif isnumeric(attributes.department_id)>
	<cfinclude template="../query/get_department_upd.cfm">
<cfelse>
	<cfset get_department_upd.recordcount = 0>
</cfif>
<cfif not get_department_upd.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='45540.Depo Kaydı Bulunmamaktadır'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cfsavecontent variable="txt">
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.popup_add_department" title="<cf_get_lang dictionary_id ='57582.Ekle'>"><i class="fa fa-plus"></i></a>
</cfsavecontent>
    <cf_box title="#getLang('','Depolama Alanları',47091)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_department_process" method="post" name="add_dep">
            <input type="hidden" id="department_id" name="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>" />
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-department_head">
                        <label class="col col-3 col-xs-12"><cfoutput><cf_get_lang dictionary_id='58763.depo'> *</cfoutput></label>
                        <div class="col col-9 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='45286.depo girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="department_head" required="yes" message="#message#" style="width:200px;" value="#get_department_upd.department_head#" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-department_detail">
                        <label class="col col-3 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57629.Açıklama'></cfoutput></label>
                        <div class="col col-9 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                            <textarea rows="3" name="DEPARTMENT_DETAIL" id="DEPARTMENT_DETAIL" style="width:200px;" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_department_upd.department_detail#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-3 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57453.Şube'></cfoutput></label>
                        <div class="col col-9 col-xs-12">
                            <cfquery name="BRANCHES" datasource="#DSN#">
                                SELECT 
                                    BRANCH_ID, 
                                    BRANCH_NAME 
                                FROM 
                                    BRANCH 
                                <cfif session.ep.isBranchAuthorization>
                                    WHERE 
                                        BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
                                </cfif>
                                ORDER BY
                                    BRANCH_NAME
                            </cfquery>
                            <select name="branch_ID" id="branch_ID" style="width:200px;">
                                <cfoutput query="branches">
                                    <option value="#branch_ID#"<cfif branches.branch_id eq get_department_upd.branch_id>selected</cfif>>#branch_name# 
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-admin1">
                        <label class="col col-3 col-xs-12"><cfoutput><cf_get_lang dictionary_id='51174.yonetici'>1 *</cfoutput></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_id" id="pos_id" value="<cfoutput>#get_department_upd.ADMIN1_POSITION_CODE#</cfoutput>">
                                <cfsavecontent variable="message1"><cf_get_lang dictionary_id='45250.yonetici girmelisiniz'></cfsavecontent>
                                <cfif len(GET_DEPARTMENT_UPD.ADMIN1_POSITION_CODE)>
                                    <cfinput type="text"  name="admin1" required="Yes" message="#message1#" style="width:200px;" value="#get_emp_info(GET_DEPARTMENT_UPD.ADMIN1_POSITION_CODE,1,0)#">
                                <cfelse>
                                    <cfinput type="text"  name="admin1" required="Yes" message="#message1#" style="width:200px;" value="">
                                </cfif>
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_dep.admin1&field_code=add_dep.pos_id</cfoutput>','list')"></span>                                       
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-admin2">
                        <label class="col col-3 col-xs-12"><cfoutput><cf_get_lang dictionary_id='51174.yonetici'> 2</cfoutput></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_id2" id="pos_id2" value="<cfoutput>#get_department_upd.admin2_position_code#</cfoutput>">
                                <cfif len(GET_DEPARTMENT_UPD.ADMIN2_POSITION_CODE)>
                                    <cfinput type="Text"  name="admin2" style="width:200px;" value="#get_emp_info(GET_DEPARTMENT_UPD.ADMIN2_POSITION_CODE,1,0)#">
                                <cfelse>
                                    <cfinput type="Text"  name="admin2" style="width:200px;" value="">
                                </cfif>
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_dep.admin2&field_code=add_dep.pos_id2</cfoutput>','list')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-department_detail">
                        <label class="col col-12"><cfoutput><input type="checkbox" name="status" id="status"<cfif get_department_upd.department_status> checked</cfif>>&nbsp;<cf_get_lang dictionary_id='57493.Aktif'></cfoutput></label>
                    </div>
        </div>
        </cf_box_elements>
            <cf_box_footer>
                    <cf_record_info query_name="get_department_upd">
                    <cf_workcube_buttons type_format='1' is_upd='1' is_delete='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>

</cfif>
	
<script type="text/javascript">
function kontrol()
{	
	if(document.add_dep.status.checked == false)
	{
		var location_status = wrk_safe_query('stk_get_location_status','dsn',0,<cfoutput>#attributes.department_id#</cfoutput>);	
		if(location_status.recordcount)
		{
			alert("Bu depoya ait aktif lokasyonlar bulunmaktadır.");
			return false;
		}
	}	
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
