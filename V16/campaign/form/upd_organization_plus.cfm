<cfset attributes.id = attributes.organization_id>
<cfinclude template="../query/get_com_method.cfm">
<cfquery name = "get_organization_plus" datasource = "#dsn#">
    SELECT * FROM ORGANIZATION_PLUS WHERE ORGANIZATION_PLUS_ID = #attributes.organization_plus_id#
</cfquery>
<cf_box title="#getLang('','Takipler','57325')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" add_href="javascript:openBoxDraggable('#request.self#?fuseaction=campaign.popup_add_organization_plus&organization_id=#organization_id#&plus_type=#plus_type#')">
<cfform name="upd_organization_plus" method="post" action="#request.self#?fuseaction=campaign.emptypopup_upd_organization_plus">
	<input type="hidden" name="organization_id" id="organization_id" value="<cfoutput>#attributes.organization_id#</cfoutput>">
	<input type="hidden" name="organization_plus_id" id="organization_plus_id" value="<cfoutput>#get_organization_plus.organization_plus_id#</cfoutput>">
	<input type="hidden" name="plus_type" id="plus_type" value="<cfoutput>#attributes.plus_type#</cfoutput>">
	<input type="hidden" name="clicked" id="clicked" value="">
	<cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_box_elements>
            <div class="col col-6 col-md-4 col-sm-8 col-xs-6" index="1">
                <div class="form-group" id="item-partner_names">
                    <label class="col col-2 col-md-2 col-xs-12"><cf_get_lang_main no='16.E-posta'>*</label>
                    <div class="col col-9 col-md-9 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="partner_emails" id="partner_emails" value="">
                            <input type="hidden" name="partner_id" id="partner_id" value="<cfif len(get_organization_plus.partner_id)><cfoutput>#get_organization_plus.partner_id#</cfoutput></cfif>">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(get_organization_plus.consumer_id)><cfoutput>#get_organization_plus.consumer_id#</cfoutput></cfif>">
                            <input type="text" name="partner_names" id="partner_names" readonly value="<cfif len(get_organization_plus.mail_sender)><cfoutput>#get_organization_plus.mail_sender#</cfoutput></cfif>" style="width:205px;">
                            <cfif get_module_user(47)>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_mail=upd_organization_plus.partner_names&field_partner=upd_organization_plus.partner_id&field_consumer=upd_organization_plus.consumer_id&select_list=7,8');"></span>
                            </cfif>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item_header">
                    <label class="col col-2 col-md-2 col-xs-12"><cf_get_lang_main no='68.Konu'>*</label>
                    <div class="col col-9 col-md-9 col-xs-12">
                        <input type="text" name="header" id="header" style="width:485px;" value="<cfoutput><cfif isDefined("get_organization_plus.SUBJECT")>#get_organization_plus.SUBJECT#</cfif></cfoutput>">
                    </div>
                </div>
            </div>
            <div class="col col-2 col-md-5 col-sm-4 col-xs-6" index="2">
                <div class="form-group" id="item_plus_date">
                    <label class="col col-3 col-md-4 col-xs-12"><cf_get_lang_main no ='330.Tarih'></label>
                    <div class="col col-9 col-md-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang_main no ='330.Tarih'></cfsavecontent>
                            <cfinput type="text" name="plus_date" id="plus_date" style="width:65px;" value="#dateformat(get_organization_plus.plus_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#">
                            <cfif get_module_user(47)>
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="plus_date"></span>
                            </cfif>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item_commethod_id">
                    <label class="col col-3 col-md-4 col-xs-12"><cf_get_lang_main no='731.İletişim'></label>
                    <div class="col col-9 col-md-8 col-xs-12">
                        <select name="commethod_id" id="commethod_id" style="width:150px;">
                            <option value="0"><cf_get_lang_main no='731.İletişim'></option>
                            <cfoutput query="get_com_method">
                                <option<cfif commethod_id is get_organization_plus.commethod_id> selected</cfif> value="#commethod_id#">#commethod#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="3">
				<div class="form-group" id="item-plus_content">
                    <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarSet="WRKContent"
                    basePath="/fckeditor/"
                    instanceName="plus_content"
                    value="#get_organization_plus.plus_content#"
                    width="550"
                    height="300">
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer><!---/// footer alanı record info ve submit butonu--->
           <cf_record_info query_name="get_organization_plus">
            <cf_workcube_buttons type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=campaign.emptypopup_del_organization_plus&organization_plus_id=#get_organization_plus.organization_plus_id#'>
            <cfinput type="submit" name="submit" class="ui-wrk-btn ui-wrk-btn-success" value="#getLang('','Güncelle ve Mail Gönder','49265')#" onClick="clicked.value='&email=true';return control()"><!--- OnFormSubmit()&& --->				  
        </cf_box_footer>    
    </cfform>
</cf_box>
<script type="text/javascript">
	function control()
	{
		if(document.getElementById('header').value == '')
		{
			alert("Konu Alanı Dolu Olmalıdır!");
			document.upd_organization_plus.header.focus();
			return false;
		} 
		document.upd_organization_plus.action= document.upd_organization_plus.action+ document.getElementById('clicked').value; 
		var aaa = document.getElementById('partner_names').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)) && (document.getElementById('clicked').value == '&email=true'))
		{ 
			alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='16.E-mail'>!!");
			document.upd_organization_plus.action = "<cfoutput>#request.self#?fuseaction=campaign.emptypopup_upd_organization_plus</cfoutput>"; 
			document.getElementById('clicked').value = '';
			return false;
		}			  
		return true;
	}
</script>	 	
