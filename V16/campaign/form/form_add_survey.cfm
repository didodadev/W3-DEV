<cfif isdefined('attributes.camp_id')>
	<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
		SELECT CAMP_ID FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
	</cfquery>
</cfif>
<cfquery name="GET_OUR_COMPS" datasource="#dsn#">
	SELECT
		COMP_ID,
		COMPANY_NAME
	FROM 
		OUR_COMPANY
	ORDER BY
		COMPANY_NAME
</cfquery>
<cfinclude template="../query/get_departments.cfm">
<!--- Sadece aktif kategorilerin gelmesi için --->
<cfset attributes.is_active_consumer_cat = 1>
<cfinclude template="../query/get_consumers.cfm">
<cfinclude template="../query/get_partners.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_survey" method="POST" action="#request.self#?fuseaction=campaign.emptypopup_add_survey">
            <cfif isdefined('attributes.camp_id')>
                <input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#camp_id#</cfoutput>">
            </cfif>
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="false">
                    <div id="mali" style="width:100%;height:480px;z-index:1;overflow:auto;">
                        <table width="98%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="formbold" height="20"><cf_get_lang dictionary_id='49384.Yayın Alanı'><br/></td>
                            </tr>
                            <tr>
                                <td class="txtboldblue"><cf_get_lang dictionary_id='49509.Partner Portal'></td>
                            </tr>
                            <tr>
                                <td>
                                    <cfoutput query="get_partner_cats">
                                        <input type="Checkbox" name="survey_partners" id="survey_partners" value="#companycat_id#">#companycat#<br/>
                                    </cfoutput>
                                </td>
                            </tr>
                            <tr>
                                <td class="txtboldblue" height="25" valign="bottom"><cf_get_lang dictionary_id='49510.Public Portal'></td>
                            </tr>
                            <tr>
                                <td>
                                    <cfoutput query="get_consumer_cats">
                                        <input type="Checkbox" name="survey_consumers" id="survey_consumers" value="#conscat_id#">#conscat#<br/>
                                    </cfoutput>
                                    <input type="Checkbox" name="survey_guest" id="survey_guest" value="1"><cf_get_lang dictionary_id='49435.İnternet'>
                                </td>
                            </tr>
                            <tr height="25">
                                <td class="txtboldblue" valign="bottom"><cf_get_lang dictionary_id='49511.Employee Portal'></td>
                            </tr>
                            <tr>
                                <td>
                                    <cfoutput query="get_departments">
                                        <input type="Checkbox" name="survey_departments" id="survey_departments" value="#department_id#">#department_head#-#branch_name#<br/>
                                    </cfoutput>
                                </td>
                            </tr>
                            <tr height="25">
                                <td class="txtboldblue" valign="bottom"><cf_get_lang dictionary_id='29531.Şirketler'></td>
                            </tr>
                            <tr>
                                <td>
                                    <cfoutput query="get_our_comps">
                                        <input type="checkbox" name="survey_our_comp" id="survey_our_comp" value="#comp_id#">&nbsp;#company_name#<br/>
                                    </cfoutput>
                                </td>
                            </tr>
                            <tr height="25">
                                <td class="txtbold" valign="bottom">
                                    <input type="Checkbox" name="all" id="all" value="1" onclick="hepsi();"><cf_get_lang dictionary_id='57952.Herkes'>
                                </td>
                            </tr>
                            <tr height="25">
                                <td class="txtboldblue" valign="bottom"><cf_get_lang dictionary_id ='49611.Kariyer Portal'></td>
                            </tr>
                            <tr>
                                <td><input type="Checkbox" name="career_view" id="career_view" value="1"><cf_get_lang dictionary_id ='58030.Kariyer'> </td>
                            </tr>
                        </table>  
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-survey_head">
                        <label class="col col-3 col-xs-12"><cfoutput>#getlang('campaign',112)#</cfoutput></label>
                        <div class="col col-9 col-xs-12">
                            <cfinput type="text" name="survey_head" id="survey_head" style="width:300px;" required="Yes" maxlength="255">
                        </div>
                    </div>
                    <div class="form-group" id="item-survey">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58810.Soru'></label>
                        <div class="col col-9 col-xs-12">
                            <textarea name="survey" id="survey" style="width:300px;height:50px;" maxlength="500"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-9 col-xs-12">
                            <textarea name="detail" id="detail" style="width:300px;height:50px;"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-campaign_product_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="campaign_product_id" id="campaign_product_id" value="">
                                <input type="text" name="campaign_product" id="campaign_product" style="width:300px;" value="">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_survey.campaign_product_id&field_name=add_survey.campaign_product','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-9 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-survey_status">
                        <label class="col col-3 col-xs-12"> <cf_get_lang dictionary_id='57756.Durum'></label>
                        <label><input type="Checkbox" name="survey_status" id="survey_status"></label>
                        <label><cf_get_lang dictionary_id='57493.Aktif'></label>
                    </div>
                    <div class="form-group" id="item-view_date_start">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="view_date_start" id="view_date_start" value="" validate="#validate_style#" >
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="view_date_start">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-view_date_finish">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="view_date_finish" id="view_date_finish" value="" validate="#validate_style#" >
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="view_date_finish">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-survey_type">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49438.Anket Tipi'></label>
                        <div class="col col-9 col-xs-12">
                            <select name="survey_type" id="survey_type">
                                <cfoutput>
                                    <option value="1"><cf_get_lang dictionary_id='49440.Tekli Cevap'></option>
                                    <option value="2"><cf_get_lang dictionary_id='49441.Çoklu Cevap'></option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-answer_number">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49439.Şık Sayısı'></label>
                        <div class="col col-9 col-xs-12">
                            <select name="answer_number" id="answer_number" onchange="gosteriver(this.selectedIndex);">
                                <cfloop from="2" to="20" index="i">
                                    <cfoutput>
                                        <option value="#i#">#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <cfloop from="0" to="19" index="i">
                        <div class="form-group" id="answer<cfoutput>#i#</cfoutput>" style="display:none;">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29782.Şık'><cfoutput>#evaluate(i+1)#</cfoutput></label>
                            <div class="col col-9 col-xs-12">
                                <textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text"></textarea>
                            </div>
                        </div>
                    </cfloop>  
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function gosteriver(number)
	{
		/*sayi seçilenin 1 eksigi geliyor*/
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
		if (document.add_survey.all.checked)
		{
			document.add_survey.survey_guest.checked = true;
			for(i=0;i<document.add_survey.survey_partners.length;i++)
				document.add_survey.survey_partners[i].checked = true;
	
			for(i=0;i<document.add_survey.survey_consumers.length;i++)
				document.add_survey.survey_consumers[i].checked = true;
	
			for(i=0;i<document.add_survey.survey_departments.length;i++)
				document.add_survey.survey_departments[i].checked = true;
		}
		else
		{
			document.add_survey.survey_guest.checked = false;
			for(i=0;i<document.add_survey.survey_partners.length;i++)
				document.add_survey.survey_partners[i].checked = false;
	
			for(i=0;i<document.add_survey.survey_consumers.length;i++)
				document.add_survey.survey_consumers[i].checked = false;
	
			for(i=0;i<document.add_survey.survey_departments.length;i++)
				document.add_survey.survey_departments[i].checked = false;
		}
	}
	
	function kontrol()
	{
		if(!$("#survey_head").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">:<cf_get_lang dictionary_id="49432.Anket Başlığı">');
			return false;
		}
		if(!$("#view_date_start").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">:<cf_get_lang dictionary_id="58053.Başlangıç Tarihi !">');
			return false;
		}
		if(!$("#view_date_finish").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">:<cf_get_lang dictionary_id="57700.Bitiş Tarihi !">');
			return false;
		}
		x = document.getElementById('process_stage').selectedIndex;
		if (document.getElementById('process_stage')[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok ! '>");
			return false;
		}
		
		secim = 0;
		<cfif get_our_comps.recordcount gt 1>	
		for(i=0; i<add_survey.survey_our_comp.length; i++)
			if (add_survey.survey_our_comp[i].checked)
				secim = 1;
		<cfelseif get_our_comps.recordcount eq 1>
			if (add_survey.survey_our_comp.checked)
				secim = 2;
		</cfif>		
		if (!secim)
		{
			alert("<cf_get_lang dictionary_id='49682.En az Bir sirket seciniz'>!");
			return false;
		}
		else
			return true;
	}

	{	
		answer0.style.display = '';
		answer1.style.display = '';
	}
</script>

