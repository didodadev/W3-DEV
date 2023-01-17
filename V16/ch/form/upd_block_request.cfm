<cfquery name="get_block_group" datasource="#dsn#">
	SELECT BLOCK_GROUP_ID,BLOCK_GROUP_NAME FROM BLOCK_GROUP
</cfquery>
<cfquery name="get_block_request" datasource="#dsn#">
	SELECT 
    	COMPANY_BLOCK_ID, 
        PROCESS_STAGE, 
        BLOCK_START_DATE, 
        BLOCK_FINISH_DATE, 
        COMPANY_ID, 
        CONSUMER_ID, 
        BLOCK_EMPLOYEE_ID, 
        BLOCK_GROUP_ID, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	COMPANY_BLOCK_REQUEST 
    WHERE 
    	COMPANY_BLOCK_ID = #attributes.block_id#
</cfquery>
<cfif len(get_block_request.company_id)>
	<cfquery name="get_company" datasource="#dsn#">
		SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID = #get_block_request.company_id#
	</cfquery>
	<cfset member_name = '#get_company.fullname#'>
	<cfset member_id = get_block_request.company_id>
	<cfset member_type = 'partner'>
<cfelse>
	<cfquery name="get_consumer" datasource="#dsn#">
		SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID = #get_block_request.consumer_id#
	</cfquery>
	<cfset member_name = '#get_consumer.consumer_name# #get_consumer.consumer_surname#'>
	<cfset member_id = get_block_request.consumer_id>
	<cfset member_type = 'consumer'>
</cfif>
<cf_catalystHeader>
    <cf_box>
        <cfform name="add_block_request" method="post" action="#request.self#?fuseaction=ch.emptypopup_upd_block_request">
            <input name="block_id" id="block_id" type="hidden" value="<cfoutput>#attributes.block_id#</cfoutput>">
                    <cf_box_elements>
                 	 <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                     	<div class="form-group" id="item-process_cat">
                        	 <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                              <div class="col col-8 col-xs-12">	
                              	<cf_workcube_process is_upd="0" process_cat_width="150" select_value="#get_block_request.process_stage#" is_detail="1">
                              </div>
                        </div>
                        <div class="form-group" id="item-block_group">
                        	 <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50057.Bloklama Nedeni'></label>
                              <div class="col col-8 col-xs-12">
                                <select name="block_group" id="block_group" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_block_group">
                                <option value="#block_group_id#" <cfif block_group_id eq get_block_request.block_group_id>selected</cfif>>#block_group_name#</option>
                                </cfoutput>
                                </select>
                              </div>
                        </div>
                        <div class="form-group" id="item-member_id">
                        	 <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                              <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#member_type#</cfoutput>">
                                    <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#member_id#</cfoutput>">
                                    <input type="text" name="member_name" id="member_name"  readonly value="<cfoutput>#member_name#</cfoutput>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=add_block_request.member_name&field_comp_id=add_block_request.member_id&field_name=add_block_request.member_name&field_consumer=add_block_request.member_id&field_type=add_block_request.member_type&select_list=2,3','list');"></span>
                                </div>
                              </div>
                        </div>
                        <div class="form-group" id="item-blocker_employee_id">
                        	 <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'> *</label>
                              <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="blocker_employee_id" id="blocker_employee_id" value="<cfif len(get_block_request.block_employee_id)><cfoutput>#get_block_request.block_employee_id#</cfoutput></cfif>">
                                    <input type="text" name="blocker_employee" id="blocker_employee" value="<cfif len(get_block_request.block_employee_id)><cfoutput>#get_emp_info(get_block_request.block_employee_id,0,0)#</cfoutput></cfif>" >
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_block_request.blocker_employee_id&field_name=add_block_request.blocker_employee&select_list=1','list');"></span>
                                </div>
                              </div>
                        </div>
                     </div>
                     <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                     	<div class="form-group" id="item-block_start_date">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50054.Blok Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                            	<div class="input-group">
                                	<cfinput type="text" name="block_start_date" validate="#validate_style#" required="yes" message="Başlama Tarihi Giriniz !" value="#dateformat(get_block_request.block_start_date,dateformat_style)#" maxlength="10" >
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="block_start_date"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="block_finish_date" validate="#validate_style#" value="#dateformat(get_block_request.block_finish_date,dateformat_style)#" maxlength="10" >
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="block_finish_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                            	<textarea name="detail" id="detail" style="width:155px;height:70px;"><cfoutput>#get_block_request.detail#</cfoutput></textarea>
                            </div>
                        </div>
                     </div>
                    </cf_box_elements>
                 <cf_box_footer>
                    <div class="col col-12">
                        <cf_record_info query_name="get_block_request">
                        <cf_workcube_buttons type_format="1" is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=ch.emptypopup_del_block_request&block_id=#attributes.block_id#'>
                    </div>
                </cf_box_footer>
             
	    </cfform>
    </cf_box>
<script type="text/javascript">
function kontrol()
{
	if(document.add_block_request.member_name.value == "" || document.add_block_request.member_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='54489.Lütfen Cari Hesap Seçiniz'>!");
		return false;
	}
	if(document.add_block_request.blocker_employee.value == "" || document.add_block_request.blocker_employee_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='50053.Lütfen İşlem Yapan Seçiniz'>!");
		return false;
	}
    if(!$("#block_start_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='41039.Lütfen Başlangıç Tarihi Giriniz'> !</cfoutput>"});
			return false;
		}
        
	return process_cat_control();
}
</script> 