<cfinclude template="../query/get_departments.cfm">
<cfinclude template="../query/get_consumers.cfm">
<cfinclude template="../query/get_partners.cfm">
<cfinclude template="../query/get_survey.cfm">			
<cfinclude template="../query/get_survey_alts.cfm">			
<cfinclude template="../query/get_survey_votes_count.cfm">
<cfquery name="GET_OUR_COMPS" datasource="#DSN#">
	SELECT
		COMP_ID,
		COMPANY_NAME
	FROM 
		OUR_COMPANY
	ORDER BY
		COMPANY_NAME
</cfquery>	
<script type="text/javascript">
	function goster_survey(number)
	{
	/* sayı seçilenin 1 eksiği geliyor*/
		for (i=0;i<=number+1;i++)
		{
			eleman = eval('answer'+i);
			eleman.style.display = '';
		}
		for (i=number+2;i<=19;i++)
		{
			eleman = eval('answer'+i);
			eleman.style.display = 'none';
		}
	}
	
	function hepsi()
	{
		if (document.upd_anket.all.checked)
			{
			document.upd_anket.survey_guest.checked = true;
			for(i=0;i<document.upd_anket.survey_partners.length;i++)
				document.upd_anket.survey_partners[i].checked = true;
	
			for(i=0;i<document.upd_anket.survey_consumers.length;i++)
				document.upd_anket.survey_consumers[i].checked = true;
	
			for(i=0;i<document.upd_anket.survey_departments.length;i++)
				document.upd_anket.survey_departments[i].checked = true;			
			}
		else
			{
			for(i=0;i<document.upd_anket.survey_partners.length;i++)
				document.upd_anket.survey_partners[i].checked = false;
	
			for(i=0;i<document.upd_anket.survey_consumers.length;i++)
				document.upd_anket.survey_consumers[i].checked = false;
	
			for(i=0;i<document.upd_anket.survey_departments.length;i++)
				document.upd_anket.survey_departments[i].checked = false;
			}
	}
</script>
<cf_catalystHeader>
<div class="col col-9 col-xs-12  uniqueRow">
    <cf_box>
        <cfform name="upd_anket" id="upd_anket" method="post" action="#request.self#?fuseaction=campaign.emptypopup_popup_upd_survey">
            <input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#survey_id#</cfoutput>">
            <input type="hidden" name="alts" id="alts" value="<cfoutput>#valuelist(get_survey_alts.alt_id)#</cfoutput>">
            <cf_box_elements>          	   
                <div class="col col-4 col-md-6 col-xs-12" type="column" index="1" sort="false">
                    <div id="anket_list" style="width:100%; max-height:500px; z-index:1;overflow:auto;">
                        <table width="98%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="formbold" height="25"><cf_get_lang dictionary_id='49384.Yayın Alanı'></td>
                            </tr>
                            <tr>
                                <td class="txtboldblue"><cf_get_lang dictionary_id='49509.Partner Portal'></td>
                            </tr>
                            <tr>
                                <td>
                                    <cfoutput query="get_partner_cats">
                                        <input type="Checkbox" name="survey_partners" id="survey_partners" value="#companycat_id#" <cfif get_survey.survey_partners contains ",#companycat_id#,">checked</cfif>>#companycat#<br/>
                                    </cfoutput>
                                </td>
                            </tr>
                            <tr>
                                <td class="txtboldblue" height="25" valign="bottom"><cf_get_lang dictionary_id='49510.Public Portal'></td>
                            </tr>
                            <tr>
                                <td>
                                    <cfoutput query="get_consumer_cats">
                                        <input type="Checkbox" name="survey_consumers" id="survey_consumers" value="#conscat_id#" <cfif get_survey.survey_consumers contains ",#conscat_id#,">checked</cfif>>#conscat#<br/>
                                    </cfoutput>
                                    <input type="Checkbox" name="survey_guest" id="survey_guest" value="1" <cfif get_survey.SURVEY_GUEST eq 1>checked</cfif>><cf_get_lang dictionary_id='49435.İnternet'>
                                </td>
                            </tr>
                            <tr>
                                <td class="txtboldblue" height="25" valign="bottom"><cf_get_lang dictionary_id ='49611.Kariyer Portal'></td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="Checkbox" name="career_view" id="career_view" value="1" <cfif isdefined("get_survey.career_view") and get_survey.career_view eq 1>checked</cfif>>
                                    <cf_get_lang dictionary_id ='58030.Kariyer'>
                                </td>
                            </tr>
                            <tr>
                                <td class="txtboldblue" height="25" valign="bottom"><cf_get_lang dictionary_id='49511.Employee Portal'></td>
                            </tr>
                            <tr>
                                <td>
                                    <cfoutput query="get_departments">
                                        <input type="Checkbox" name="survey_departments" id="survey_departments" value="#department_id#" <cfif get_survey.survey_departments contains ",#department_id#,">checked</cfif>>#department_head#-#branch_name#<br/>
                                    </cfoutput>
                                </td>
                            </tr>
                            <tr>
                                <td class="txtboldblue" height="25" valign="bottom"><cf_get_lang dictionary_id='29531.Şirketler'></td>
                            </tr>
                                <cfoutput query="GET_OUR_COMPS">
                                    <tr>
                                        <td>
                                            <input type="checkbox" name="survey_our_comp" id="survey_our_comp" value="#comp_id#" <cfif get_survey.survey_our_comp contains ",#comp_id#,">checked</cfif>>&nbsp;#COMPANY_NAME#<br/>
                                        </td>
                                    </tr>
                                </cfoutput>
                            <tr>
                                <td class="txtbold" height="25" valign="bottom"><input type="Checkbox" name="all" id="all" value="1" onclick="hepsi();"><cf_get_lang dictionary_id='57952.Herkes'></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="col col-4 col-md-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-survey_head">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="survey_head" style="width:300px;" required="Yes"  maxlength="255" value="#get_survey.survey_head#">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="SURVEY" 
                                    column_name="SURVEY_HEAD" 
                                    column_id_value="#url.survey_id#" 
                                    maxlength="255" 
                                    datasource="#dsn#" 
                                    column_id="SURVEY_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-survey">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58810.Soru'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <textarea name="survey" id="survey" style="width:300px;height:50px;" maxlength="500"><cfoutput>#get_survey.survey#</cfoutput></textarea>
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="SURVEY" 
                                    column_name="SURVEY" 
                                    column_id_value="#url.survey_id#" 
                                    datasource="#dsn#" 
                                    column_id="SURVEY_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-3"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <textarea name="detail" id="detail" style="width:300px;height:50px;"><cfoutput>#get_survey.detail#</cfoutput></textarea>
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="SURVEY" 
                                    column_name="DETAIL" 
                                    column_id_value="#url.survey_id#" 
                                    datasource="#dsn#" 
                                    column_id="SURVEY_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfif LEN(get_survey.PRODUCT_ID)>
                                    <input type="hidden" name="campaign_product_id" id="campaign_product_id" value="<cfoutput>#get_survey.PRODUCT_ID#</cfoutput>">
                                    <cfquery name="get_pro_name" datasource="#dsn3#">
                                        SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #GET_SURVEY.PRODUCT_ID#
                                    </cfquery>
                                    <input type="text" name="campaign_product" id="campaign_product" style="width:300px;" value="<cfoutput>#get_pro_name.PRODUCT_NAME#</cfoutput>">
                                <cfelse>
                                    <input type="hidden" name="campaign_product_id" id="campaign_product_id" value="">
                                    <input type="text" name="campaign_product" id="campaign_product" style="width:300px;" value="">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis btnPointer " onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_anket.campaign_product_id&field_name=upd_anket.campaign_product','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12"> <cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-9 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0' select_value="#get_survey.stage_id#">
                        </div>
                    </div>
                    <div class="form-group" id="item-survey-status">
                        <label class="col col-3 col-xs-12"> <cf_get_lang dictionary_id='57756.Durum'></label>
                        <div class="col col-9 col-xs-12">
                            <label>
                                <input type="Checkbox" <cfif get_survey.SURVEY_STATUS is 1>checked</cfif> name="SURVEY_STATUS" id="SURVEY_STATUS">
                                <cf_get_lang dictionary_id='57493.Aktif'>
                            </label>
                        </div>
                    </div>
                    <div class="form-group" id="item-view_date_START">
                        <label class="col col-3 col-xs-12">  <cf_get_lang dictionary_id='57501.Başlangıç'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_survey.VIEW_DATE_START)>
                                    <cfinput type="text" name="view_date_START" style="width:118px;" value="#dateformat(date_add('h',session.ep.time_zone,get_survey.view_date_START),dateformat_style)#" validate="#validate_style#">
                                <cfelse>
                                    <cfinput type="text" name="view_date_START" style="width:120px;" value="" validate="#validate_style#" >
                                </cfif>
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="view_date_START">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-view_date_FINISH">
                        <label class="col col-3 col-xs-12"> <cf_get_lang dictionary_id='57502.Bitiş'> </label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfif len(get_survey.VIEW_DATE_FINISH)>
                                    <cfinput type="text" name="view_date_FINISH" style="width:118px;" value="#dateformat(date_add('h',session.ep.time_zone,get_survey.view_date_FINISH),dateformat_style)#" validate="#validate_style#">
                                <cfelse>
                                    <cfinput type="text" name="view_date_FINISH" style="width:118px;" value="" validate="#validate_style#" >
                                </cfif>
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="view_date_FINISH">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-survey_type">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49438.Anket Tipi'></label>
                        <div class="col col-9 col-xs-12">
                            <cfif not get_survey_votes_count.recordcount>
                                <select name="survey_type" id="select">
                                    <option value="1" <cfif get_survey.survey_type IS 1>selected</cfif>><cf_get_lang dictionary_id='49440.Tekli Cevap'></option>
                                    <option value="2" <cfif get_survey.survey_type IS 2>selected</cfif>><cf_get_lang dictionary_id='49441.Çoklu Cevap'></option>
                                </select>
                            <cfelse>
                                <input name="survey_type" id="survey_type" type="hidden" value="<cfoutput>#get_survey.SURVEY_TYPE#</cfoutput>">									
                                <select name="temp_survey_type" id="temp_survey_type" disabled>
                                    <option value="1" <cfif get_survey.survey_type IS 1>selected</cfif>><cf_get_lang dictionary_id='49440.Tekli Cevap'></option>
                                    <option value="2" <cfif get_survey.survey_type IS 2>selected</cfif>><cf_get_lang dictionary_id='49441.Çoklu Cevap'></option>
                                </select>	
                            </cfif>
                        </div>
                    </div> 
                    <div class="form-group" id="item-answer_number">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49439.Şık Sayısı'></label>
                        <div class="col col-9 col-xs-12">
                            <cfif not get_survey_votes_count.recordcount>
                                <select name="answer_number" onchange="goster_survey(this.selectedIndex);" id="answer_number">
                                    <cfloop from="2" to="20" index="i">
                                        <option value="<cfoutput>#i#</cfoutput>" <cfif get_survey.answer_number eq i>selected</cfif>><cfoutput>#i#</cfoutput></option>
                                    </cfloop>
                                </select>
                            <cfelse>
                                <input name="answer_number" id="answer_number" type="hidden" value="<cfoutput>#get_survey.ANSWER_NUMBER#</cfoutput>">
                                <select name="temp_answer_number" disabled onchange="goster_survey(this.selectedIndex);" id="answer_number">
                                    <cfloop from="2" to="20" index="i">
                                        <option value="<cfoutput>#i#</cfoutput>" <cfif get_survey.answer_number eq i>selected</cfif>><cfoutput>#i#</cfoutput></option>
                                    </cfloop>
                                </select>
                            </cfif>
                        </div>
                    </div>                             
                    <cfset i = 0> 
                    <cfoutput query="get_survey_alts">		
                        <div class="form-group" id="answer#i#" style="display:none;">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29782.Şık'>#evaluate(i+1)#</label>
                            <div class="col col-9 col-xs-12">  
                                <div class="input-group">
                                    <cfif not get_survey_votes_count.recordcount>
                                        <textarea name="answer#i#_text" id="answer#i#_text" rows="2" style="width:300px;">#alt#</textarea>	  
                                        <span class="input-group-addon">
                                            <cf_language_info 
                                            table_name="SURVEY_ALTS" 
                                            column_name="ALT" 
                                            column_id_value="#ALT_ID#" 
                                            datasource="#dsn#"
                                            maxlength="255" 
                                            column_id="ALT_ID" 
                                            control_type="0">
                                        </span>									
                                    <cfelse>
                                        <textarea name="answer#i#_text" id="answer#i#_text" rows="2" readonly style="width:300px;">#alt#</textarea>
                                        <span class="input-group-addon">
                                            <cf_language_info 
                                            table_name="SURVEY_ALTS" 
                                            column_name="ALT" 
                                            column_id_value="#ALT_ID#" 
                                            datasource="#dsn#" 
                                            maxlength="255"
                                            column_id="ALT_ID" 
                                            control_type="0">	
                                        </span>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <cfset i = i +1>
                        </cfoutput>
                        <cfloop from="#evaluate(i)#" to="19" index="j">
                            <div class="form-group" id="answer<cfoutput>#j#</cfoutput>" style="display:none;">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29782.Şık'><cfoutput>#evaluate(j+1)#</cfoutput></label>
                                <div class="col col-9 col-xs-12">
                                    <textarea name="answer<cfoutput>#j#</cfoutput>_text" id="answer<cfoutput>#j#</cfoutput>_text" rows="2"></textarea>
                                </div>
                            </div>
                        </cfloop>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-xs-12">
                    <cf_record_info query_name="GET_SURVEY">
                </div>
                <div class="col col-6 col-xs-12">
                    <cf_workcube_buttons is_upd='1' add_function='kontrol()' type_format="1" 
                    delete_page_url='#request.self#?fuseaction=campaign.emptypopup_del_survey&survey_id=#attributes.survey_id#&head=#get_survey.survey_head#'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>  
</div> 
<div class="col col-3 col-xs-12  uniqueRow">
    <cf_box title="#getLang('main',535)#"
        id="survey_ajax" 
        unload_body="1" 
        style="width:99%"
        closable="0"
        box_page="#request.self#?fuseaction=objects.popup_ajax_survey&survey_id=#attributes.survey_id#&type=1">
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		deger = 0;
		<cfif get_our_comps.recordcount gt 1>	
			for(dgr=0;dgr<<cfoutput>#get_our_comps.recordcount#</cfoutput>;dgr++)
				if(document.upd_anket.survey_our_comp[dgr].disabled==false)
				{	
					if(document.upd_anket.survey_our_comp[dgr].checked == true)
					{
						deger++;
						break;							
					}
				}
			if(deger== 0)
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49627.en az'> <cf_get_lang dictionary_id='58091.bir'> <cf_get_lang dictionary_id='57574.şirket'>!");
				return false;
			}
			else
				return true;
		<cfelseif get_our_comps.recordcount eq 1>
			if(document.upd_anket.survey_our_comp.disabled==false)
			{	
				if(document.upd_anket.survey_our_comp.checked == true)
				{
					deger++;
				}
			}
			if(deger== 0)
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49627.en az'> <cf_get_lang dictionary_id='58091.bir'> <cf_get_lang dictionary_id='57574.şirket'>!");
				return false;
			}
			else
				return true;
		</cfif>
	}

	{	
		<cfif get_survey.answer_number gt 0>
			<cfloop from="0" to="#evaluate(get_survey.answer_number-1)#" index="i">
				<cfoutput>answer#i#.style.display = '';</cfoutput>
			</cfloop>
		</cfif>	
	}
</script>

