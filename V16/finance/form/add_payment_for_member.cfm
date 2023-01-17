<cfquery name="GET_CREDITCARD_PAYMENT_TYPE_MEMBER" datasource="#DSN3#">
	SELECT 
        CC_PAYMENT_TYPE_ID, 
        COMPANY_ID, 
        START_DATE, 
        FINISH_DATE, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP
    FROM 
    	CREDITCARD_PAYMENT_TYPE_MEMBER 
    WHERE 
	    CC_PAYMENT_TYPE_ID = #attributes.cc_payment_type_id#
</cfquery>
<cfparam name="attributes.cc_payment_type_id" default="0">
<cfparam name="attributes.start_dates" default="#now()#">
<cfparam name="attributes.finish_dates" default="#now()#">
<cfif GET_CREDITCARD_PAYMENT_TYPE_MEMBER.recordcount>
	<cfset attributes.start_dates = GET_CREDITCARD_PAYMENT_TYPE_MEMBER.START_DATE>
    <cfset attributes.finish_dates = GET_CREDITCARD_PAYMENT_TYPE_MEMBER.FINISH_DATE>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('main','Üyeler',57417)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="form_payment_member" id="form_payment_member" action="#request.self#?fuseaction=finance.emptypopup_add_payment_for_member" method="post">
        <cfinput name="cc_payment_type_id" type="hidden" value="#attributes.cc_payment_type_id#">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group require" id="item-start_dates">
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <cfinput name="start_dates" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.start_dates,dateformat_style)#">    
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_dates"></span>
                        </div>
                    </div>                
                </div> 
                <div class="form-group require" id="item-finish_dates">
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <cfinput name="finish_dates" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.finish_dates,dateformat_style)#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_dates"></span>
                        </div>
                    </div>                
                </div> 
                <div class="form-group require" id="item-workcube_to_cc">
                    <cf_workcube_to_cc
                        is_update="1"
                        to_dsp_name="Üyeler"
                        form_name="form_payment_member"
                        str_list_param="2"
                        action_dsn="#dsn3#"
                        str_action_names = "COMPANY_ID AS TO_COMP"
                        str_alias_names = ""
                        action_table="CREDITCARD_PAYMENT_TYPE_MEMBER"
                        action_id_name="CC_PAYMENT_TYPE_ID"
                        data_type="2"
                        action_id="#attributes.cc_payment_type_id#">
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' is_delete="0">
        </cf_box_footer>
    </cfform>
</cf_box>
  
