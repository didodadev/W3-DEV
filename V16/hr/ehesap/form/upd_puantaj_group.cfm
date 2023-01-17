<cfparam name="attributes.modal_id" default="">

<cfset cmp = createObject("component","V16.hr.ehesap.cfc.employee_puantaj_group")>
<cfset cmp.dsn = dsn>
<cfset get_groups = cmp.get_groups(group_id:attributes.group_id)>

<cf_box title="#getLang('','Çalışma Grubu',64698)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_puantaj_group" name="upd_puantaj_group" method="post">
        <input type="hidden" value="<cfoutput>#attributes.group_id#</cfoutput>" name="group_id" id="group_id">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-process_stage">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58969.Grup Adı">*</label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="group_name" style="width:200px;" required="yes" maxlength="100" value="#get_groups.group_name#">
                    </div>                
                </div> 
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_groups">
            <cf_workcube_buttons is_upd='1' del_function="#isDefined('attributes.draggable') ? 'deleteFunc()' : ''#"  add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_puantaj_group' , #attributes.modal_id#)"),DE(""))#">
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
    <cfif isDefined('attributes.draggable')>
        function deleteFunc() {
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_del_puantaj_group&group_id=#attributes.group_id#</cfoutput>',<cfoutput>#attributes.modal_id#</cfoutput>);
        }
    </cfif>
</script>
