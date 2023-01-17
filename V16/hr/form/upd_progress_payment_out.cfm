<cfquery name="get_progress_payment_out" datasource="#dsn#">
	SELECT 
    	PROGRESS_PAYMENT_OUT_ID, 
        EMP_ID, 
        START_DATE, 
        FINISH_DATE, 
        DETAIL, 
        PROGRESS_TIME, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        IS_KIDEM, 
        IS_YEARLY 
    FROM 
    	EMPLOYEE_PROGRESS_PAYMENT_OUT 
    WHERE 
	    PROGRESS_PAYMENT_OUT_ID = #attributes.progress_payment_out_id#
</cfquery>

<!--- <cfsavecontent variable="message"><cf_get_lang dictionary_id="56659.İzin ve Kıdemden Sayılmayacak Gün Dağılımı"></cfsavecontent> --->
<cf_box title="#getLang('','İzin ve Kıdemden Sayılmayacak Gün Dağılımı','56659')#" add_href="#request.self#?fuseaction=hr.popup_progress_payment_out">
    <cfform name="upd_out" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_progress_payment_outt">
        <input type="hidden" name="progress_payment_out_id" id="progress_payment_out_id" value="<cfoutput>#get_progress_payment_out.progress_payment_out_id#</cfoutput>">

        <cf_box_elements>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="form-group" >
                    <label class="col col-4 col-xs-12"></label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="checkbox" name="is_yearly" id="is_yearly" value="1" <cfif get_progress_payment_out.is_yearly eq 1>checked</cfif>><cf_get_lang dictionary_id ='58575.İzin'> 
                            <input type="checkbox" name="is_kidem" id="is_kidem" value="1" <cfif get_progress_payment_out.is_kidem eq 1>checked</cfif>><cf_get_lang dictionary_id ='56630.Kıdem'> 
                        </div>
                    </div>
                </div>
                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#get_progress_payment_out.emp_id#</cfoutput>">
                            <input type="text" name="emp_name" id="emp_name" value="<cfoutput>#get_emp_info(get_progress_payment_out.emp_id,0,0)#</cfoutput>"  readonly>
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=upd_out.emp_id&field_emp_name=upd_out.emp_name</cfoutput>')"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'><cf_get_lang dictionary_id='57742.Tarihi'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                            <cfinput validate="#validate_style#" required="Yes" message="#alert#" type="text" name="start_date"  value="#dateformat(get_progress_payment_out.start_date,dateformat_style)#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='288.Bitiş Tarihi'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                <cfif len(get_progress_payment_out.finish_date)>
                                    <cfinput validate="#validate_style#" message="#alert#" type="text" name="finish_date"  value="#dateformat(get_progress_payment_out.finish_date,dateformat_style)#" required="Yes">
                                <cfelse>
                                    <cfinput validate="#validate_style#" message="#alert#" type="text" name="finish_date"  value=""  required="Yes">
                                </cfif>
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>        
                    <div class="col col-8 col-xs-12">
                        <div class="col col-12 input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56660.Açıklama Giriniz'>!</cfsavecontent>
                            <cfinput type="text" name="detail" style="width:125px; height:45px;" value="#get_progress_payment_out.detail#" message="#message#">
                        </div>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56655.Gün Sayısı'></label>        
                    <div class="col col-8 col-xs-12">
                        <div class="col col-12 input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56654.Gün Sayısı Giriniz'>!</cfsavecontent>
                            <cfinput type="text" name="progress_time"  value="#get_progress_payment_out.progress_time#" validate="integer" message="#message#" readonly="yes">
                            
                        </div>
                    </div>
                </div>
                
            </div>

    </cf_box_elements>
    
    <cf_box_footer>
    	<cf_record_info query_name="get_progress_payment_out">
    	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_progress_payment_out&progress_payment_out_id=#attributes.progress_payment_out_id#'>
    </cf_box_footer>
    </cfform>
</cf_box>      
