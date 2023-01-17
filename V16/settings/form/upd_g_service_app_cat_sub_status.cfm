<cf_xml_page_edit fuseact="settings.form_add_g_service_app_sub_status">
    <cfquery name="GET_STATUS_POS" datasource="#DSN#">
        SELECT 
            SP.POSITION_CODE,
            EP.EMPLOYEE_NAME,
            EP.EMPLOYEE_SURNAME,
            EP.POSITION_NAME,
			SP.POSITION_CAT_ID
        FROM 
            G_SERVICE_APPCAT_SUB_STATUS_POST SP,
            EMPLOYEE_POSITIONS EP
        WHERE
            SP.SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id# AND
            EP.POSITION_CODE = SP.POSITION_CODE
    </cfquery>
    <cfquery name="GET_STATUS_CATS" datasource="#DSN#">
        SELECT 
            SP.POSITION_CAT_ID,
            SPC.POSITION_CAT
        FROM 
            G_SERVICE_APPCAT_SUB_STATUS_POST SP,
            SETUP_POSITION_CAT SPC
        WHERE
            SP.SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id# AND
            SPC.POSITION_CAT_ID = SP.POSITION_CAT_ID
    </cfquery>
    <cfquery name="GET_STATUS_INFO" datasource="#DSN#">
        SELECT 
            SP.POSITION_CODE_INFO,
            EP.EMPLOYEE_NAME,
            EP.EMPLOYEE_SURNAME,
            EP.POSITION_NAME
        FROM 
            G_SERVICE_APPCAT_SUB_STATUS_INFO SP,
            EMPLOYEE_POSITIONS EP
        WHERE
            SP.SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id# AND
            EP.POSITION_CODE = SP.POSITION_CODE_INFO
    </cfquery>
    
    <cfquery name="GET_SERVICE_ROWS" datasource="#DSN#">
        SELECT SERVICE_SUB_STATUS_ID FROM G_SERVICE_APP_ROWS WHERE SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id#
    </cfquery>
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
    <cfquery name="GET_SERVICE_SUB_STATUS" datasource="#DSN#">
        SELECT 
            SERVICE_SUB_STATUS_ID, 
            SERVICE_SUB_STATUS, 
            SERVICE_SUB_CAT_ID, 
            OUR_COMPANY_ID, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP, 
            ANALYSIS_HOUR, 
            ANALYSIS_MINUTE, 
            IS_STATUS, 
            SERVICE_EXPLAIN 
        FROM 
            G_SERVICE_APPCAT_SUB_STATUS 
        WHERE 
            SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id#
    </cfquery>
    <cfquery name="Get_Our_Company" datasource="#dsn#">
        SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
    </cfquery>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Şikayet Alt Tree Kategorileri','42924')#" add_href="#request.self#?fuseaction=settings.form_add_g_service_app_cat_sub_status" is_blank="0">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
				<cfinclude template="../display/list_g_service_app_cat_sub_status.cfm">
			</div>
			<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
				<cfform name="service_app_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_g_service_app_cat_sub_status">
					<input type="hidden" name="service_sub_status_id" id="service_sub_status_id" value="<cfoutput>#get_service_sub_status.service_sub_status_id#</cfoutput>">
					<cf_box_elements>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
							<div class="form-group" id="item-is_status">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
									<input type="checkbox" value="1" name="is_status" id="is_status" <cfif get_service_sub_status.is_status eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group" id="item-service_sub_cat_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'>*</label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
									<select name="service_sub_cat_id" id="service_sub_cat_id">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_service_appcat_sub">
											<option value="#service_sub_cat_id#" <cfif len(get_service_sub_status.service_sub_cat_id) and (service_sub_cat_id eq get_service_sub_status.service_sub_cat_id)> selected</cfif>>#servicecat#-#service_sub_cat#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-service_sub_status">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43130.Alt Kategori'>*</label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='43224.Alt Kategori Adı Girmelisiniz'>!</cfsavecontent>
										<cfinput type="text" name="service_sub_status" value="#get_service_sub_status.service_sub_status#" maxlength="50" required="yes" message="#message#">
										<span class="input-group-addon">
											<cf_language_info 
											table_name="G_SERVICE_APPCAT_SUB_STATUS" 
											column_name="SERVICE_SUB_STATUS" 
											column_id_value="#attributes.service_sub_status_id#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="SERVICE_SUB_STATUS_ID" 
											control_type="0">
										</span>
									</div>
								</div>
							</div>
							<cfif x_analysis_time eq 1>
								<div class="form-group" id="item-analysis_hour">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43384.Çözülme Süresi'></label>
									<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
										<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
											<div class="input-group">
												<input type="text" name="analysis_hour" id="analysis_hour" value="<cfif len(get_service_sub_status.analysis_hour)><cfoutput>#get_service_sub_status.analysis_hour#</cfoutput></cfif>" onKeyUp="isNumber(this);" maxlength="3">
												<span class="input-group-addon"><label><cf_get_lang dictionary_id='57491.Saat'></label></span>
											</div>
										</div>
										<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
											<div class="input-group">
												<input type="text" name="analysis_minute" id="analysis_minute" value="<cfif len(get_service_sub_status.analysis_minute)><cfoutput>#get_service_sub_status.analysis_minute#</cfoutput></cfif>" onKeyUp="isNumber(this);" maxlength="3">
												<span class="input-group-addon"><label><cf_get_lang dictionary_id='58127.Dakika'></label></span>
											</div>
										</div>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-explain">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
									<div class="input-group">
										<cftextarea id="explain" name="explain" style="width:200px; height:50px"><cfoutput>#get_service_sub_status.service_explain#</cfoutput></cftextarea>
										<span class="input-group-addon">
											<cf_language_info 
											table_name="G_SERVICE_APPCAT_SUB_STATUS" 
											column_name="SERVICE_EXPLAIN" 
											column_id_value="#attributes.service_sub_status_id#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="SERVICE_SUB_STATUS_ID" 
											control_type="0">
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-our_company_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
									<select name="our_company_id" id="our_company_id" multiple>
										<cfoutput query="Get_Our_Company">
											<option value="#comp_id#" <cfif listfind(get_service_sub_status.our_company_id,comp_id)>selected</cfif>>#nick_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
							<cfif is_authorized_positions eq 1>
								<input type="hidden" name="position_cats" id="position_cats" value="<cfoutput>#ListSort(ValueList(get_status_cats.position_cat_id),'numeric')#</cfoutput>">
								<div class="form-group" id="item-positions">
									<cfsavecontent variable="txt_1"><cf_get_lang dictionary_id ='36167.Yetkili Pozisyonlar'></cfsavecontent>
									<cf_workcube_to_cc
									is_update="1"
									to_dsp_name="#txt_1#"
									form_name="service_app_cat"
									str_list_param="1"
									action_dsn="#DSN#"
									str_action_names="POSITION_CODE AS TO_EMP"
									action_table="G_SERVICE_APPCAT_SUB_STATUS_POST"
									data_type="2"
									action_id_name="SERVICE_SUB_STATUS_ID"
									action_id="#attributes.service_sub_status_id#">
								</div>

								<!--- <cf_flat_list>
									<thead>
										<tr>
											<th width="20"> 
												<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=service_app_cat.position_cats&field_td=td_yetkili2</cfoutput>&is_noclose=1','list');"><i class="fa fa-plus"></i></a>
											</th>
											<th><cf_get_lang dictionary_id='38005.Yetkili Pozisyon Tipleri'></th>
										</tr>
									</thead>
									<tbody id="td_yetkili2"> </tbody>   
										<cfif get_service_appcat_sub_cats.recordcount>
											<input type="hidden" name="status_#position_cat_id#" id="status_#position_cat_id#" value="1">
											<cfoutput query="get_service_appcat_sub_cats">
												<tr id="tr_#position_cat_id#">
													<td width="20"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_g_service_app_cat_sub&service_cat_sub_id=#attributes.service_cat_sub_id#&position_cat_id=#position_cat_id#','small')"><i class="fa fa-minus"></i></a><br/></td>
													<td width="100">#position_cat#</td>
												</tr>
											</cfoutput>
										</cfif>
								</cf_flat_list> --->

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
										<cfif get_status_cats.recordcount>
											<cfoutput query="get_status_cats">
												<tr id="tr_#position_cat_id#">
													<td width="20"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_g_service_app_cat_sub&service_cat_sub_id=#service_sub_status_id#&position_cat_id=#position_cat_id#','small')"><i class="fa fa-minus"></i></a><br/></td>
													<td width="100">#POSITION_CAT#</td>
												</tr>
											</cfoutput>
										</cfif>    
									</cf_flat_list>
								</div>
								<div class="form-group" id="item-cc">
									<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58773.Bilgi Verilecekler'></cfsavecontent>
									<cf_workcube_to_cc
									is_update="1"
									cc_dsp_name="#txt_2#"
									form_name="service_app_cat"
									str_list_param="1"
									data_type="2"
									action_dsn="#DSN#"
									str_action_names="POSITION_CODE_INFO AS CC_EMP"
									action_table="G_SERVICE_APPCAT_SUB_STATUS_INFO"
									action_id_name="SERVICE_SUB_STATUS_ID"
									action_id="#attributes.service_sub_status_id#">
								</div>
							</cfif>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_record_info query_name="get_service_sub_status">
						<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_g_service_app_cat_sub_status&service_sub_status_id=#attributes.service_sub_status_id#&del_all'>
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
	