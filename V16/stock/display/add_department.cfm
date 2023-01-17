<cf_get_lang_set module_name="stock">
    <cfparam name="attributes.modal_id" default="">
    <cf_box title="#getLang('','Depolama Alanları',47091)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	    <cfform action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_department_process" method="post" name="add_dep">
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-department_head">
                        <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='58763.depo'> *</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='33242.Depo Girmelisiniz'> !</cfsavecontent>
                            <cfinput type="text" name="department_head" required="Yes" message="#message#" style="width:200px;" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-department_detail">
                        <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57629.Açıklama'></cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                            <textarea rows="3" name="department_detail" id="department_detail" maxlength="150" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:200px;"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='57453.Şube'></cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfquery name="BRANCHES" datasource="#DSN#">
                                SELECT 
                                    BRANCH.BRANCH_ID, 
                                    BRANCH.BRANCH_NAME,
                                    BRANCH.BRANCH_STATUS,
                                    BRANCH.COMPANY_ID,
                                    OUR_COMPANY.COMP_ID,
                                    OUR_COMPANY.NICK_NAME
                                FROM 
                                    BRANCH 
                                INNER JOIN
                                    OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
                                WHERE 
                                    BRANCH.BRANCH_STATUS = 1						
                                    <cfif session.ep.isBranchAuthorization>
                                        AND BRANCH.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
                                    </cfif>
                                        AND 
                                        BRANCH.BRANCH_ID IS NOT NULL
                                ORDER BY
                                    OUR_COMPANY.NICK_NAME,
                                    BRANCH.BRANCH_NAME
                                    
                            </cfquery>
                            <select name="branch_id" id="branch_id">
                                <option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
                                <cfoutput query="branches" group="NICK_NAME">
                                    <optgroup label="#NICK_NAME#"></optgroup>
                                    <cfoutput>
                                        <option value="#branch_id#"<cfif isDefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#branch_name#</option>
                                    </cfoutput>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-admin1">
                        <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='51174.yonetici'>1 *</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='45250.Yonetici Girmelisiniz'> !</cfsavecontent>
                                <cfinput type="text"  name="admin1" required="Yes" message="#message#" style="width:200px;">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_dep.admin1&field_code=add_dep.pos_id</cfoutput>','list')"></span>
                                <input type="hidden" name="pos_id" id="pos_id">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-admin2">
                        <label class="col col-4 col-xs-12"><cfoutput><cf_get_lang dictionary_id='51174.yonetici'> 2</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="admin2" id="admin2" style="width:200px;">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_dep.admin2&field_code=add_dep.pos_id2</cfoutput>','list')"></span>
                                <input type="hidden" name="pos_id2" id="pos_id2" value="">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-department_detail">
                        <label class="col col-12"><cfoutput><input type="checkbox" name="status" id="status" checked>&nbsp;<cf_get_lang dictionary_id='57493.Aktif'></cfoutput></label>
                    </div>
        </div>
        </cf_box_elements>
        <cf_box_footer>
                <cf_workcube_buttons add_function="saveform()"is_upd='0'>
        </cf_box_footer>
	</cfform>
</cf_box>
<script>
    function saveform()
     {
          if(document.add_dep.branch_id.value == "")
          {
              alert("<cf_get_lang dictionary_id='48083.Şube Girmelisiniz'>!");
              document.getElementById('branch_id').focus();
              return false;
          }
         
      }
  </script> 

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
