<cfset attributes.id = attributes.service_id>
<cfinclude template="../query/get_service_plus.cfm">
<cfinclude template="../query/get_com_method.cfm">
<cfsavecontent  variable="head"><cf_get_lang dictionary_id="49309.Takip"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#head#" add_href="#request.self#?fuseaction=call.popup_add_service_plus&service_id=#service_id#&plus_type=#plus_type#">
        <cfform name="upd_service_plus" method="post" action="#request.self#?fuseaction=call.emptypopup_upd_service_plus">
            <input type="hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.service_id#</cfoutput>">
            <input type="hidden" name="service_plus_id" id="service_plus_id" value="<cfoutput>#get_service_plus.service_plus_id#</cfoutput>">
            <input type="hidden" name="plus_type" id="plus_type" value="<cfoutput>#attributes.plus_type#</cfoutput>">
            <input type="hidden" name="clicked" id="clicked" value="">
            <cf_box_elements vertical="1">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12 padding-0" index="1">
                    <div class="form-group" id="item-partner_names">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-posta'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="partner_emails" id="partner_emails" value="">
                                <!---<cfif len(get_service_plus.partner_id)>
                                    <input type="hidden" name="partner_id" value="<cfoutput>#get_service_plus.partner_id#</cfoutput>">
                                    <input type="Text" name="partner" readonly value="<cfoutput>#get_par_id(GET_SERVICE_PLUS.partner_id,0,-1,0)#</cfoutput>">
                                <cfelse>
                                    <input type="hidden" name="partner_id" value="">
                                    <input type="Text" name="partner_names" readonly value="">
                                </cfif>--->
                                <input type="hidden" name="partner_id" id="partner_id" value="<cfif len(get_service_plus.partner_id)><cfoutput>#get_service_plus.partner_id#</cfoutput></cfif>">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(get_service_plus.consumer_id)><cfoutput>#get_service_plus.consumer_id#</cfoutput></cfif>">
                                <input type="text" name="partner_names" id="partner_names" readonly value="<cfif len(get_service_plus.mail_sender)><cfoutput>#get_service_plus.mail_sender#</cfoutput></cfif>">
                                <cfif get_module_user(47)>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=upd_service_plus.partner_emails&names=upd_service_plus.partner_names','list');"></span>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item_header">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="header" id="header" value="<cfoutput><cfif isDefined("GET_SERVICE_PLUS.SUBJECT")>#GET_SERVICE_PLUS.SUBJECT#</cfif></cfoutput>">
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12 paddding-0" index="2">
                    <div class="form-group" id="item_plus_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57742.Tarih'></cfsavecontent>
                                <cfinput type="text" name="plus_date" id="plus_date" value="#dateformat(get_service_plus.plus_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#">
                                <cfif get_module_user(47)>
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="plus_date"></span>
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item_commethod_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58143.İletişim'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="commethod_id" id="commethod_id">
                                <option value="0"><cf_get_lang dictionary_id='58143.İletişim'></option>
                                <cfoutput query="get_com_method">
                                    <option<cfif commethod_id is get_service_plus.commethod_id> selected</cfif> value="#commethod_id#">#commethod#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-top-5" index="3">
                    <div class="form-group" id="item-plus_content">
                        <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarSet="WRKContent"
                        basePath="/fckeditor/"
                        instanceName="plus_content"
                        value="#GET_SERVICE_PLUS.plus_content#"
                        width="550"
                        height="300">
                    </div>
                </div>
            </cf_box_elements>
            <div class="ui-form-list-btn"><!---/// footer alanı record info ve submit butonu--->
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_record_info query_name="get_service_plus"></div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_workcube_buttons type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=call.emptypopup_del_service_plus&service_plus_id=#GET_SERVICE_PLUS.SERVICE_PLUS_ID#'>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='49265.Güncelle ve Mail Gönder'></cfsavecontent>
                    <div class="pull-right"><input type="submit" name="submit" class="ui-wrk-btn ui-wrk-btn-extra" value="<cfoutput>#message#</cfoutput>" onClick="clicked.value='&email=true';return control()"><!--- OnFormSubmit()&& ---></div>				  
                </div>
            </div>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	//document.upd_service_plus.partner_id.value = '<cfif isDefined("session.ep.userid")><cfoutput>#Session.ep.userid#</cfoutput><cfelseif isDefined("session.pp.userid")><cfoutput>#Session.pp.userid#</cfoutput></cfif>';
	function control()
	{
		if(document.getElementById('header').value == '')
		{
			alert("Konu Alanı Dolu Olmalıdır!");
			document.upd_service_plus.header.focus();
			return false;
		} 
		document.upd_service_plus.action= document.upd_service_plus.action+ document.getElementById('clicked').value; 
		var aaa = document.getElementById('partner_names').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)) && (document.getElementById('clicked').value == '&email=true'))
		{ 
			alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57428.E-mail'>!!");
			document.upd_service_plus.action = "<cfoutput>#request.self#?fuseaction=call.emptypopup_upd_service_plus</cfoutput>"; 
			document.getElementById('clicked').value = '';
			return false;
		}			  
		return true;
	}
</script>	 	
