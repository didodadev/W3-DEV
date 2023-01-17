<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_camp_email_conts.cfm">
<cfinclude template="../query/get_camp_sms_conts.cfm">
<cfinclude template="../query/get_camp_tmarkets.cfm">
<cfinclude template="../query/get_campaign.cfm">
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.page" default="1">
<cfset attributes.maxrow = session.ep.maxrows>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>
<cfparam name="attributes.totalrecords" default='#camp_email_conts.recordcount#'>
<div id="campaign_works_div_">
    <!---<cfform name="works_" method="post" action="">
        <cf_ajax_list_search>
    		<cf_ajax_list_search_area>
            	<input type="hidden" name="is_submitted" id="is_submitted" value="1" />
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;text-align:right;">
                <cfsavecontent variable="search"><cf_get_lang dictionary_id ='153.Ara'></cfsavecontent>
                <cfset send_ = "">
                <cf_wrk_search_button add_function="loader_page2('#send_#');"><!---<input type="button" value="Listele" name="campaign_submit_button" id="campaign_submit_button" onclick="loader_page2">--->
            </cf_ajax_list_search_area>
        </cf_ajax_list_search>
    </cfform>--->
    <cf_flat_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id="57480.Konu"></th>
                <th width="80"><cf_get_lang dictionary_id="58143.İletişim"></th>
                <th width="20" class="text-center"><a href="javascript://" title="<cf_get_lang dictionary_id="57756.Durum">" alt="<cf_get_lang dictionary_id="57756.Durum">"><i class="fa fa-envelope-o"></i></a></th>               
                <th width="20"><a href="javascript://" title="<cf_get_lang dictionary_id='59807.Preview'>" alt="<cf_get_lang dictionary_id='59807.Preview'>"><i class="fa fa-file-image-o"></i></a></th> 
                <th width="20" target="_blank"><a href="https://app.sendgrid.com/statistics" title="<cf_get_lang dictionary_id='57434.Report'>" alt="<cf_get_lang dictionary_id='57434.Report'>"><i class="catalyst-bar-chart"></i></a></th>
               
            </tr>
        </thead>
        <tbody>
        <cfoutput query="camp_sms_conts">
            <tr>
                <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=campaign.popup_form_upd_sms_cont&sms_cont_id=#sms_cont_id#&draggable=1');"><cfif len(sms_head)>#sms_head#<cfelse>#left(sms_body,150)#</cfif></a></td>
                <td><cf_get_lang dictionary_id='49523.Sms'></td>
                <td class="text-center">
                    <cfif is_sent eq 1>
                        <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=campaign.popup_list_target_masses&sms_cont_id=#sms_cont_id#&camp_id=#camp_id#&goal=sms&draggable=1');"><i class="fa fa-tablet" alt="<cf_get_lang dictionary_id='49525.Gönderildi'>" title="<cf_get_lang dictionary_id='49525.Gönderildi'>" style="color:##13be54!important"></i></a>
                    <cfelse>
                        <cfif not campaign.camp_stage_id eq -1>
                            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=campaign.popup_list_target_masses&sms_cont_id=#sms_cont_id#&camp_id=#camp_id#&goal=sms&draggable=1');"><i class="fa fa-tablet" alt="<cf_get_lang dictionary_id='58743.Gönder'>" title="<cf_get_lang dictionary_id='58743.Gönder'>"></i></a>
                        </cfif>
                    </cfif>
                </td>
                <td>
                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=campaign.preview_sms&camp_id=#camp_id#&sms_cont_id=#sms_cont_id#');"><i class="fa fa-file-image-o" alt="<cf_get_lang dictionary_id='49191.SMS İçeriği Detay'>" title="<cf_get_lang dictionary_id='49191.SMS İçeriği Detay'>"></i></a>
                </td>
                <td>
                    <cfif camp_sms_conts.recordcount> 
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.del_campaign_content&is_sms=1&camp_id=#camp_id#&sms_cont_id=#sms_cont_id#','small');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                    </cfif>
                </td>
            </tr>
        </cfoutput>
        <cfif ListLen(CAMP_TMARKETS.TMARKET_ID)>
            <cfset target_list = ValueList(CAMP_TMARKETS.TMARKET_ID) & ',-1'>
        <cfelse>
            <cfset target_list = '-1'>
        </cfif>
        <cfif camp_email_conts.recordcount>
            <cfoutput query="camp_email_conts" startrow="#attributes.startrow#" maxrows="#attributes.maxrow#">
                <cfquery name="get_sent_contents_det" datasource="#dsn#">
                    SELECT SEND_EMP FROM SEND_CONTENTS WHERE CONT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#email_cont_id#"> AND CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#camp_id#">
                </cfquery>
                <cfif get_sent_contents_det.recordcount><!--- mail gonderimi yapildiysa renk degistirir --->
                    <cfset is_mail_sent = 1>
                <cfelse>
                    <cfset is_mail_sent = 0>
                </cfif>
                <tr>
                    <td><a href="#request.self#?fuseaction=content.list_content&event=det&cntid=#email_cont_id#" class="tableyazi">#email_subject#</a></td>
                    <td><cf_get_lang dictionary_id='42782.E-Mail'></td>
                    <td class="text-center">
                        <cfif is_mail_sent eq 1>
                            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=campaign.popup_list_target_masses&email_cont_id=#email_cont_id#&camp_id=#camp_id#&goal=email');"><i class="fa fa-envelope-open-o" style="color:##13be54!important" alt="<cf_get_lang dictionary_id='49525.Gönderildi'>" title="<cf_get_lang dictionary_id='49525.Gönderildi'>"></i></a>
                        <cfelse>
                            <cfif not campaign.camp_stage_id eq -1>
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=campaign.popup_list_target_masses&email_cont_id=#email_cont_id#&camp_id=#camp_id#&goal=email');"><i class="fa fa-envelope-o" alt="<cf_get_lang dictionary_id='58743.Gönder'>" title="<cf_get_lang dictionary_id='58743.Gönder'>"></i></a>
                            </cfif>
                        </cfif>
                    </td>
                    <td>
                        <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=campaign.emptypopup_preview_mail&email_cont_id=#email_cont_id#&camp_id=#camp_id#&goal=email');"><i class="fa fa-file-image-o" alt="<cf_get_lang dictionary_id='49418.Prova Sayfası'>" title="<cf_get_lang dictionary_id='49418.Prova Sayfası'>"></i></a>
                    </td>
                    <td>
                        <cfif get_sent_contents_det.recordcount> 
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.del_campaign_content&cont_id=#email_cont_id#&camp_id=#camp_id#&comp_id=#company_id#','small');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                        </cfif>
                    </td>  
                </tr>
            </cfoutput>
        <cfelseif camp_sms_conts.recordcount eq 0>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
        </tbody>
    </cf_flat_list>
	<cfif attributes.totalrecords gt attributes.maxrow> 
        <cfset adres = "">
        <cfif isdefined('attributes.is_submitted')>
            <cfset adres = "#adres#&is_submitted=1">
        </cfif>
        <cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
            <cfset adres = "#adres#&camp_id=#attributes.camp_id#">
        </cfif>
        <cfif len(attributes.startrow)>
            <cfset adres = "#adres#&startrow=#attributes.startrow#">
        </cfif>
        <cfif len(attributes.maxrow)>
            <cfset adres = "#adres#&maxrows=#attributes.maxrow#">
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrow#"
            totalrecords="#camp_email_conts.recordcount#"
            startrow="#attributes.startrow#"
            isAjax=true
            target="campaign_works_div_"
            adres="campaign.emptypopup_dsp_campaign_contents#adres#">
    </cfif> 
</div>
<!--- <script type="text/javascript">
	function loader_page2()
	{    
		adress_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=campaign.emptypopup_dsp_campaign_contents'+'&maxrows='+document.getElementById('maxrows').value+'&camp_id='+camp_id;
		AjaxPageLoad(adress_,'campaign_works_div_',1);
		return true;
	}
</script> --->
