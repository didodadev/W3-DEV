<!---- İlan Detay ---->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_components_notice = createObject("component", "V16.objects2.career.cfc.notice")>

<cfif isdefined("session.cp.userid") and len(session.cp.userid)>
    <cfset get_app = get_components.get_app()>
    <cfset GET_IDENTY = get_components.get_app_identy()>
</cfif>

<cfset get_notice = get_components_notice.GET_NOTICE(notice_id: notice_id)>

<cfif not get_notice.recordcount>
	<script type="text/javascript">
		{
			alert("<cf_get_lang dictionary_id='35475.This ad is inactive!'>!");
			history.go(-1);
		}
	</script>
	<cfabort>
</cfif>

<div class="main_tree">
  <div class="membership">
	<cfif len(get_notice.visual_notice) and isdefined("get_notice.view_visual_notice")>
    	 <div class="color-pos-header">
            <cf_get_server_file output_file="hr/#get_notice.visual_notice#" output_server="#get_notice.server_visual_notice_id#" output_type="0" image_link="0" alt="<cf_get_lang dictionary_id='35072.İlan'>" title="<cf_get_lang dictionary_id='35072.İlan'>">
         </div>
    <cfelse>
        <cfif len(get_notice.our_company_id)>
            <cfset check = get_components.GET_COMPANIES(company_id: get_notice.our_company_id)>
        <cfelse>
            <cfset check = ''>
        </cfif>
        <cfoutput>
            <table cellpadding="3" cellspacing="2" class="adver_categori">
                <tr>
                    <td width="140">&nbsp;&nbsp;<cfif len(check.asset_file_name3)><img src="#application.systemParam.systemParam().user_domain##application.systemParam.systemParam().file_web_path#settings/#check.asset_file_name3#" border="0" alt="<cf_get_lang_main no='1225.Logo'>" title="<cf_get_lang_main no='1225.Logo'>" height="30" style="vertical-align:middle;"/></cfif></td>
                    <td width="200"><b style="font-size:13px;">#get_notice.notice_head#</b></td>
                    <td>
                        <b style="font-size:13px;">
                        <cfif listlen(get_notice.notice_city)>
                            <cfset row_count = 0>
                            <cfloop list="#get_notice.notice_city#" index="i">
                                <cfset row_count = row_count + 1>
                                <cfset get_city = get_components.GET_CITY(city_id: i)>
                                #get_city.city_name# <cfif row_count lt listlen(get_notice.notice_city,',')>-</cfif>
                            </cfloop>
                        </cfif>
                        </b>
                    </td>
                    <td><b style="font-size:13px;"><cf_get_lang dictionary_id='58794.Reference No.'>: #get_notice.notice_no#</b></td>
                </tr>
            </table>
            <br />
            <cfif len(get_notice.detail)>
            	<h1><cf_get_lang dictionary_id='35237.General Qualifications'></h1>
                <ul class="adver_ul">
                    <cfoutput>#get_notice.detail#</cfoutput>
                </ul>
            </cfif>
            <cfif len(get_notice.work_detail)>
                <h1><cf_get_lang dictionary_id='35112.Job Definition'></h1><br />
                <p><cfoutput>#get_notice.work_detail#</cfoutput></p>
            </cfif>
        </cfoutput>
    </cfif>
    <br /><br />
    <div>
        <div style="float:left;">
            <a href="javascript:history.go(-1);" style="color:#FFF" title="<cf_get_lang dictionary_id='46942.Return'>" class="trubuttonaktif"><cf_get_lang dictionary_id='46942.Return'></a>
        </div>
        <div style="float:right;">
            <cfif isdefined("session.cp.userid")>
                <cfset GET_APP_POS = get_components_notice.GET_APP_POS(notice_id: attributes.notice_id, empapp_id: session.cp.userid)>

                <cfif get_app_pos.recordcount>
                    <a href="#" class="ib1" style="float:right; color:#FFC;"><cf_get_lang dictionary_id='35238.You ve previously applied for this job.'>.</a><br /><br />
                <cfelse>
                    <cfif (isdefined("get_app") and get_app.app_status eq 1)>
                        <a href="javascript://" onclick="return hs.htmlExpand(this,{headingText:'<cf_get_lang dictionary_id='34890.Add Application'>: <cfoutput>#get_app.name# #get_app.surname#</cfoutput>'})" class="ib1" style="float:right; color:#FFF;">ilana başvur</a><br /><br />
                        <div class="highslide-maincontent">
                            <cfinclude template="../form/form_add_app_pos.cfm">
                        </div>
                    <cfelse>
                        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_upd_cv_7" class="ib1" style="float:right;"><cf_get_lang dictionary_id='35241.Your CV is not active or you cannot apply due to missing information'>.</a><br /><br />
                    </cfif>
                </cfif>
            <cfelse>
                <cfsavecontent variable="session.error_text"><cf_get_lang dictionary_id='34539.Please Login'>!</cfsavecontent>
                <a href="javascript://" onclick="return hs.htmlExpand(this,{headingText:'Bu ilanı arkadaşınla paylaş'})" class="ib1" style="float:right; color:#FFF;"><cf_get_lang dictionary_id='31643.Apply to Job Posting'></a><br /><br />
                <div class="highslide-maincontent">
                   <cfinclude template="../form/form_add_app_pos.cfm">
                </div>
                <a href="<cfoutput>#request.self#?fuseaction=objects2.kariyer_login</cfoutput>"></a>
            </cfif>
            <a href="#" onclick="return hs.htmlExpand(this,{headingText:'Bu ilanı arkadaşınla paylaş'})" class="ib2" style="color:#FFF;"><cf_get_lang dictionary_id='62714.share'></a>
            <!---Arkadaşına Gönder--->
            <div class="highslide-maincontent">
                <cfset get_notice = get_components_notice.get_notice(notice_type: 2, notice_id:attributes.notice_id )>
                <cfform name="notice_share" action="#request.self#?fuseaction=objects2.add_message_send">
                    <cfoutput>
                        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_notice.our_company_id#</cfoutput>">
                        <input type="hidden" name="notice_id" id="notice_id" value="<cfoutput>#attributes.notice_id#</cfoutput>">
                        <table>
                            <tr>
                                <td class="headbold"><cf_get_lang dictionary_id='57574.Company'></td>
                                <td>: <cfinput type="text" name="company_name" id="company_name" value="#get_par_info(get_notice.company_id,1,0,0)#" style="border-width:0px;width:200px;" readonly="yes"></td>
                            </tr>
                            <tr>
                                <td class="headbold"><cf_get_lang dictionary_id='57480.Subject'></td>
                                <td>: <cfinput type="text" name="detail" id="detail" value="#get_notice.notice_head#" style="border-width:0px;width:200px;" readonly="yes"></td>
                            </tr>
                            <tr>
                                <td class="headbold"><cf_get_lang dictionary_id='58497.Position'></td>
                                <td>: <cfinput type="text" name="position" id="position" value="#get_notice.position_name#" style="border-width:0px;width:200px;" readonly="yes"></td>
                            </tr>
                            <tr>
                                <td class="headbold"><cf_get_lang dictionary_id='57971.Province'></td>
                                <td>: 
                                    <cfif listlen(get_notice.notice_city)>
                                        <cfset row_count = 0>
                                        <cfloop list="#get_notice.notice_city#" index="i">
                                            <cfset row_count = row_count + 1>
                                            <cfset GET_CITY = get_components.GET_CITY(city_id : i)>
                                            <cfinput type="text" name="city_name" id="city_name" value="#get_city.city_name#" style="border-width:0px;width:200px;" readonly="yes"> <cfif row_count lt listlen(get_notice.notice_city,',')>-</cfif>
                                        </cfloop>
                                    </cfif>
                                </td>
                            </tr>
                        </table>
                    </cfoutput>
                    <input type="hidden" name="share_not" id="share_not" value="1">
                    <table>
                        <tr>
                            <td class="headbold"><cf_get_lang dictionary_id='60308.sender'> : <cf_get_lang dictionary_id='32370.Name Last Name'></td>
                            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='32370.Name Last Name'></cfsavecontent>
                                <cfinput type="text" name="sender_name" class="input_1" id="sender_name" required="yes" message="#message#">
                            </td>
                        </tr>
                        <tr>
                            <td class="headbold"><cf_get_lang dictionary_id='60308.sender'> : <cf_get_lang dictionary_id='57428.Email'></td>
                            <td><cfsavecontent variable="message2"><cf_get_lang dictionary_id='34559.Please Enter E-mail Address'></cfsavecontent>
                                <cfinput type="text" name="sender_email" class="input_1" id="sender_email" validate="email" required="yes" message="#message2#">
                            </td>
                        </tr>
                        <tr>
                            <td class="headbold">1. <cf_get_lang dictionary_id='58733.Buyer'>:  <cf_get_lang dictionary_id='57428.Email'></td>
                            <td><cfsavecontent variable="message3">Lütfen alıcı e-posta adresini giriniz</cfsavecontent>
                                <cfinput type="text" name="receive_email" class="input_1" id="receive_email" validate="email" required="yes" message="#message3#">
                            </td>
                        </tr>
                        <tr>
                            <td class="headbold">2. <cf_get_lang dictionary_id='58733.Buyer'> :  <cf_get_lang dictionary_id='57428.Email'></td>
                            <td><cfinput type="text" name="receive_email2" class="input_1" id="receive_email2" validate="email" message="#message3#"></td>
                        </tr>
                        <tr>
                            <td class="headbold">3. <cf_get_lang dictionary_id='58733.Buyer'> :  <cf_get_lang dictionary_id='57428.Email'></td>
                            <td><cfinput type="text" name="receive_email3"  class="input_1" id="receive_email3" validate="email" message="#message3#"></td>
                        </tr>
                        <tr>
                            <td valign="top" class="headbold"><cf_get_lang dictionary_id='58733.Buyer'> :  <cf_get_lang dictionary_id='57428.Email'></td>
                            <td><textarea name="receive_notes"  class="input_1" id="receive_notes"></textarea></td>
                        </tr>
                        <tr>
                            <td style="text-align:right;">
                                <cfsavecontent variable="button_t"><cf_get_lang dictionary_id='36339.E-Mail Gönder'></cfsavecontent>
                                <cf_workcube_buttons is_insert='1' insert_info="#button_t#" data_action="/V16/objects2/career/cfc/notice:add_message_send" next_page="#request.self#" add_function='kontrol()'>
                            </td>
                        </tr>
                    </table>
                </cfform>
            </div>
            <!---Arkadaşına Gönder--->
        </div>
    </div>
  </div>
</div>

