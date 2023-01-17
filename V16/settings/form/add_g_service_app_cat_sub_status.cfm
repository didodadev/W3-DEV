<cf_xml_page_edit fuseact="settings.form_add_g_service_app_sub_status">
<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
	SELECT
		SAS.SERVICE_SUB_CAT_ID,
		SAS.SERVICE_SUB_CAT,
		SA.SERVICECAT,
        SAS.OUR_COMPANY_ID
	FROM
		G_SERVICE_APPCAT_SUB SAS,
		G_SERVICE_APPCAT SA
	WHERE
		SA.SERVICECAT_ID = SAS.SERVICECAT_ID
        AND(
        	SAS.OUR_COMPANY_ID LIKE '#session.ep.company_id#'
            OR SAS.OUR_COMPANY_ID LIKE '%,#session.ep.company_id#'
            OR SAS.OUR_COMPANY_ID LIKE '#session.ep.company_id#,%'
            OR SAS.OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%'
        )
        AND SAS.IS_STATUS = 1
	ORDER BY
		SAS.SERVICE_SUB_CAT
</cfquery>
<cfquery name="Get_Our_Company" datasource="#dsn#">
	SELECT
    	COMP_ID,
        NICK_NAME
    FROM
    	OUR_COMPANY
    ORDER BY
    	NICK_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Şikayet Alt Tree Kategorileri','42924')#" add_href="#request.self#?fuseaction=settings.form_add_g_service_app_cat_sub_status" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cfinclude template="../display/list_g_service_app_cat_sub_status.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="service_app_cat" method="post"action="#request.self#?fuseaction=settings.emptypopup_add_g_service_app_cat_sub_status">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-is_status">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<input type="checkbox" value="1" name="is_status" id="is_status" checked>
							</div>
						</div>
						<div class="form-group" id="item-service_sub_cat_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<select name="service_sub_cat_id" id="service_sub_cat_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_service_appcat_sub">
									<option value="#service_sub_cat_id#">#servicecat#-#service_sub_cat#</option>
								</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-service_sub_status">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43130.Alt Kategori'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='43224.Alt Kategori Adı Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" name="service_sub_status" value="" maxlength="50" required="yes" message="#message#">
							</div>
						</div>
						<cfif x_analysis_time eq 1>
							<div class="form-group" id="item-analysis_hour">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43384.Çözülme Süresi'></label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<div class="input-group">
											<input type="text" name="analysis_hour" id="analysis_hour" value="" onKeyUp="isNumber(this);" maxlength="3">
											<span class="input-group-addon"><label><cf_get_lang dictionary_id='57491.Saat'></label></span>
										</div>
									</div>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<div class="input-group">
											<input type="text" name="analysis_minute" id="analysis_minute" value="" onKeyUp="isNumber(this);" maxlength="3">
											<span class="input-group-addon"><label><cf_get_lang dictionary_id='58127.Dakika'></label></span>
										</div>
									</div>
								</div>
							</div>
						</cfif>
						<div class="form-group" id="item-explain">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cftextarea id="explain" name="explain" style="width:200px; height:50px"></cftextarea>
							</div>
						</div>
						<div class="form-group" id="item-our_company_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<select name="our_company_id" id="our_company_id" multiple>
									<cfoutput query="Get_Our_Company">
										<option value="#comp_id#">#nick_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
						<cfif is_authorized_positions eq 1>
							<input type="hidden" name="position_codes" id="position_codes" value="">
							<input type="hidden" name="position_cats" id="position_cats" value="">
							<input type="hidden" name="position_codes_info" id="position_codes_info" value="">
							<div class="form-group" id="item-positions">
                                <cfsavecontent variable="txt_1"><cf_get_lang dictionary_id ='36167.Yetkili Pozisyonlar'></cfsavecontent>
                                <cf_workcube_to_cc
                                is_update="0"
                                to_dsp_name="#txt_1#"
                                form_name="service_app_cat"
                                str_list_param="1"
                                action_dsn="#DSN#"
                                str_action_names="POSITION_CODE AS TO_EMP"
                                action_table="G_SERVICE_APPCAT_SUB_STATUS_POST"
                                data_type="1">
                            </div>
							<div class="form-group" id="item-types">
                                <cf_flat_list>
                                    <thead>
                                        <tr>
                                            <th width="20"> 
                                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=service_app_cat.position_cats&field_td=td_yetkili2</cfoutput>&is_noclose=1','list');"><i class="fa fa-plus"></i></a>
                                            </th>
                                            <th nowrap="nowrap"><cf_get_lang dictionary_id='38005.Yetkili Pozisyon Tipleri'></th>
                                        </tr>
                                    </thead>
                                    <tbody id="td_yetkili2"> </tbody>        
                                </cf_flat_list>
                            </div>
							<div class="form-group" id="item-cc">
								<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58773.Bilgi Verilecekler'></cfsavecontent>
								<cf_workcube_to_cc
								is_update="0"
								cc_dsp_name="#txt_2#"
								form_name="service_app_cat"
								str_list_param="1"
								data_type="1"
								action_dsn="#DSN#"
                                str_action_names="POSITION_CODE_INFO AS CC_EMP"
                                action_table="G_SERVICE_APPCAT_SUB_STATUS_INFO">
							</div>
						</cfif>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	<cfif x_upper_category eq 1>
	x = document.service_app_cat.service_sub_cat_id.selectedIndex;
	if (document.service_app_cat.service_sub_cat_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='43225.Üst Kategori Seçiniz'>! ");
		return false;
	}
	</cfif>
	if(document.service_app_cat.service_sub_status.value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='43224.Alt Kategori Adı Girmelisiniz'>!");
		return false;
	}	
	if(document.service_app_cat.explain.value.length>250)
	{
		alert("<cf_get_lang dictionary_id='29725.Maksimum Karakter Sayısı'>: 250")
		return false;
	}
	return true;
}
</script>
