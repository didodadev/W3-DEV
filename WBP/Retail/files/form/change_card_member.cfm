<cfparam name="attributes.new_member_id" default="">
<cfparam name="attributes.new_comp_id" default="">
<cfparam name="attributes.modal_id" default="">

<cfif len(attributes.new_member_id)>
	<cfset attributes.new_member_name = get_cons_info(attributes.new_member_id,0,0)>
<cfelse>
	<cfset attributes.new_member_name = "">
</cfif>

<cfif len(attributes.new_comp_id)>
	<cfset attributes.new_comp_name = get_par_info(attributes.new_comp_id,1,0,0)>
<cfelse>
	<cfset attributes.new_comp_name = "">
</cfif>

<cfif isdefined("attributes.card_no")>
    <cfquery name="get_card" datasource="#dsn#">
        SELECT * FROM CUSTOMER_CARDS WHERE CARD_NO = '#attributes.card_no#'
    </cfquery>
    <cfset attributes.old_member_id = get_card.action_id>
    <cfset attributes.old_member_type = get_card.action_type_id>
    <cfset attributes.old_member_name = get_cons_info(attributes.old_member_id,0,0)>
<cfelse>
	<cfset attributes.card_no = ""> 
    <cfset attributes.old_member_id = "">
    <cfset attributes.old_member_name = "">
    <cfset attributes.old_member_type = "">
</cfif>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="box_notes" title="#getLang('','Kart Üyesi Değiştir',62499)#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="change_card_form" action="#iif(isDefined("attributes.draggable"),DE('#request.self#?fuseaction=retail.consumer_list'),DE(''))#" method="post">
            <cf_box_elements>
                <div class="col col-6 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='30233.Kart No'></label>
                        <div class="col col-6 col-sm-12">
                            <div class="input-group">
                                <input type="text" style="width:150px;" name="card_no" value="<cfoutput>#attributes.card_no#</cfoutput>" id="card_no" readonly>
                                <span class="input-group-addon icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=retail.popup_list_cons&member_card_no=change_card_form.card_no&field_name=change_card_form.card_member&field_id=change_card_form.card_member_id','wide');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='62494.Kartın Üyesi'></label>
                        <div class="col col-6 col-sm-12">
                            <cfinput type="hidden" name="card_member_id" id="card_member_id" value="#attributes.old_member_id#">
                            <cfinput type="hidden" name="card_member_type" id="card_member_type" value="#attributes.old_member_type#">
            	            <cfinput type="text" name="card_member" style="width:150px;" readonly="yes"  id="card_member" value="#attributes.old_member_name#">
                        </div>
                    </div>
                    <cfoutput>
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='62495.Kartın Taşınacağı Bireysel Üye'>*</label>
                            <div class="col col-6 col-sm-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="consumer_id" id="consumer_id" value="#attributes.new_member_id#">
                                    <cfinput type="text" name="card_new_member" style="width:150px;" id="card_new_member" value="#attributes.new_member_name#">
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=retail.popup_list_cons&field_name=change_card_form.card_new_member&field_id=change_card_form.consumer_id&user_type=1','wide');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-promotion_head">
                            <label class="col col-6 col-sm-12"><cf_get_lang dictionary_id='62496.Kartın Taşınacağı Kurumsal Üye'>*</label>
                            <div class="col col-6 col-sm-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="company_id" id="company_id" value="#attributes.new_member_id#">
                                    <cfinput type="text" name="card_new_comp" style="width:150px;" id="card_new_comp" value="#attributes.new_comp_name#">
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=retail.popup_list_cons&field_name=change_card_form.card_new_comp&field_id_cmp=change_card_form.company_id&user_type=2','wide');"></span>
                                </div>
                            </div>
                        </div>
                    </cfoutput>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('change_card_form' , #attributes.modal_id#)"),DE(""))#" button_type="1">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script>
function kontrol()
{
	con_id_ = document.getElementById('consumer_id').value;
	con_name_ = document.getElementById('card_new_member').value;
	comp_id_ = document.getElementById('company_id').value;
	comp_name_ = document.getElementById('card_new_comp').value;
	
	if(con_id_ == '' && comp_id_ == '')
	{
		alert('<cf_get_lang dictionary_id='62498.Taşınacak Üye Seçiniz'>!');
		return false;	
	}
	
	if((con_name_ != '' && comp_name_ != ''))
	{
		alert('<cf_get_lang dictionary_id='62497.Tek Üye Seçiniz'>!');
		return false;	
	}
}
</script>