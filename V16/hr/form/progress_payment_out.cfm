<cf_box title="#getLang('','İzin ve Kıdemden Sayılmayacak Gün Dağılımı','56659')#">
    <cfform name="add_out" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_progress_payment_out">
        <cf_box_elements>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="form-group" >
                    <label class="col col-4 col-xs-12"></label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="checkbox" name="is_yearly" id="is_yearly" value="1" checked><cf_get_lang dictionary_id ='58575.İzin'> 
                            <input type="checkbox" name="is_kidem" id="is_kidem" value="1" checked><cf_get_lang dictionary_id ='56630.Kıdem'> 
                        </div>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined("attributes.emp_id")><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
                            <input type="text" name="emp_name" id="emp_name" value="<cfif isdefined("attributes.emp_id")><cfoutput>#get_emp_info(attributes.emp_id,0,0)#</cfoutput></cfif>" style="width:125px;" readonly>
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=add_out.emp_id&field_emp_name=add_out.emp_name</cfoutput>')"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="item-startdate" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>!</cfsavecontent>
                            <cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="start_date" style="width:80px;">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="item-finishdate" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>!</cfsavecontent>
                            <cfinput validate="#validate_style#" message="#message#" type="text" name="finish_date" style="width:80px;" required="Yes">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="item-detail" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>        
                    <div class="col col-8 col-xs-12">
                        <div class="col col-12 input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56660.Açıklama Giriniz'>!</cfsavecontent>
                            <cfinput type="text" name="detail" style="height:45px;" value="" message="#message#">
                        </div>
                    </div>
                </div>

            </div>
        </cf_box_elements>
    <cf_box_footer>
        <cf_workcube_buttons is_upd='0'>
    </cf_box_footer>

    </cfform>
</cf_box>
