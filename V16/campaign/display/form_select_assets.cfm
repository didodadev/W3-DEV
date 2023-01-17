<cfinclude template="../query/get_email_assets.cfm">
<cfquery name="GET_SURVEYS_CAMPAIGN" datasource="#DSN#">
	SELECT 
		SURVEY.SURVEY_ID,
		SURVEY.SURVEY
	FROM 
		#dsn3_alias#.CAMPAIGN_SURVEYS,
		SURVEY
	WHERE 
		SURVEY.SURVEY_ID = CAMPAIGN_SURVEYS.SURVEY_ID AND
		CAMPAIGN_SURVEYS.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
</cfquery>

<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="Mail" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="form_assets" method="post" action="#request.self#?fuseaction=campaign.emptypopup_send_camp_email">
            <input type="Hidden" name="camp_id" id="camp_id" value="<cfoutput>#camp_id#</cfoutput>">
            <input type="Hidden" name="email_cont_id" id="email_cont_id" value="<cfoutput>#email_cont_id#</cfoutput>">
            <cfif isdefined("attributes.consumer_id")>
                <input type="Hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
            </cfif>
            <cfif isdefined("attributes.partner_id")>
                <input type="Hidden" name="partner_id" id="partner_id" value="<cfoutput>#attributes.partner_id#</cfoutput>">
            </cfif>
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="receiver" id="receiver" value="<cfoutput><cfif isdefined("attributes.consumer_id")>#get_cons_info(attributes.consumer_id,0,0,0)#<cfelseif isdefined("attributes.partner_id")>#get_par_info(attributes.partner_id,0,-1,0)#</cfif></cfoutput>" maxlength="255">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.Email'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="consumer_email" id="consumer_email" value="<cfif isdefined("attributes.email")><cfoutput>#attributes.email#</cfoutput></cfif>" maxlength="255">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58662.Anket'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="survey_id" id="survey_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_surveys_campaign">
                                    <option value="#survey_id#">#survey#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58743.Gönder'></cfsavecontent>
                    <cf_workcube_buttons is_upd='0' insert_info='#message#' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_assets' , #attributes.modal_id#)"),DE(""))#">
            </cf_box_footer>
            <!--- <cfif get_email_assets.recordcount>
                <table>
                    <tr height="22">
                        <td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id='57568.Belgeler'></td>
                    </tr>
                    <cfoutput query="get_email_assets">
                        <tr>
                            <td width="20"><input type="Checkbox" name="asset_ids" id="asset_ids" value="#asset_id#"></td>
                            <td><a href="##" onclick="windowopen('#file_web_path#campaign/#file_name#','small');" class="tableyazi">#asset_name#</a>&nbsp;(#file_size# kb.)</td>
                        </tr>
                    </cfoutput>
                </table>
            </cfif> --->
        </cfform>
    </cf_box>
</div>