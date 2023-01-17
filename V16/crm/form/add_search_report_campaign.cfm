<cfquery name="GET_CAMPAIGN" datasource="#dsn3#">
	SELECT CAMP_ID, CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_STATUS = 1 ORDER BY CAMP_HEAD
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','','51479')#"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#" id="add_company_assistance">
    <cfform name="add_company_assistance_info" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_search_report_campaign">
        <input type="hidden" name="target_company_id" id="target_company_id" value="<cfoutput>#attributes.target_company_id#</cfoutput>">
        <input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
        <cf_box_elements>
            <div class="form-group" id="item-campaing">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'>*</label>
                <div class="col col-8 col-xs-12">
                    <select name="campaign_id" id="campaign_id">
                        <option value=""><cf_get_lang dictionary_id='57446.Kampanya'></option>
                        <cfoutput query="get_campaign">
                            <option value="#camp_id#">#camp_head#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
        </cf_box_elements>
     <cf_box_footer><cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_company_assistance_info' , #attributes.modal_id#)"),DE(""))#"></cf_box_footer>
  </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
    $('#link').click(function(){
           $('.catalystClose').fadeOut();
       })
	x = document.add_company_assistance_info.campaign_id.selectedIndex;
	if (document.add_company_assistance_info.campaign_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='50021.Lütfen Kampanya Seçiniz'> !");
		add_company_assistance_info.campaign_id.focus();
		return false;
	}
	confirm("<cf_get_lang dictionary_id='35902.Yapacağınız Değişiklikler Seçmiş Olduğunuz Kampanyanın Hedef Kitlesini Etkileyecektir Emin misiniz'> !");
}
</script>
