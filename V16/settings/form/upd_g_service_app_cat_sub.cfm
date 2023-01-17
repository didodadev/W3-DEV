<cf_xml_page_edit fuseact="settings.form_add_g_service_app_cat_sub"> 
	<cfquery name="get_service_appcat_sub_posts" datasource="#dsn#">
        SELECT 
            SP.POSITION_CODE AS P_CODE,
            '' AS PAR_ID,
            '' AS CONS_ID,
            EP.EMPLOYEE_NAME AS AD,
            EP.EMPLOYEE_SURNAME AS SOYAD,
            EP.POSITION_NAME AS ALAN,
            1 AS LINK_TYPE
        FROM 
            G_SERVICE_APPCAT_SUB_POSTS SP,
            EMPLOYEE_POSITIONS EP
        WHERE
            SP.SERVICE_SUB_CAT_ID = #attributes.service_cat_sub_id#
            AND EP.POSITION_CODE = SP.POSITION_CODE
        UNION
        SELECT 
            '' AS P_CODE,
            SP.SERVICE_PAR_ID AS PAR_ID,
            0 AS CONS_ID,
            CP.COMPANY_PARTNER_NAME AS AD,
            CP.COMPANY_PARTNER_SURNAME AS SOYAD,
            COMPANY.NICKNAME AS ALAN,
            2 AS LINK_TYPE
        FROM 
            G_SERVICE_APPCAT_SUB_POSTS SP,
            COMPANY_PARTNER CP,
            COMPANY
        WHERE
            SP.SERVICE_SUB_CAT_ID = #attributes.service_cat_sub_id#
            AND CP.PARTNER_ID = SP.SERVICE_PAR_ID
            AND COMPANY.COMPANY_ID = CP.COMPANY_ID
        UNION
        SELECT 
            '' AS P_CODE,
            '' AS PAR_ID,
            SP.SERVICE_CONS_ID AS CONS_ID,
            CONS.CONSUMER_NAME AS AD,
            CONS.CONSUMER_SURNAME AS SOYAD,
            '' AS ALAN,
            3 AS LINK_TYPE
        FROM 
            G_SERVICE_APPCAT_SUB_POSTS SP,
            CONSUMER CONS
        WHERE
            SP.SERVICE_SUB_CAT_ID = #attributes.service_cat_sub_id#
            AND CONS.CONSUMER_ID = SP.SERVICE_CONS_ID
    </cfquery>
    <cfquery name="get_service_appcat_sub_cats" datasource="#DSN#">
        SELECT 
            SP.POSITION_CAT_ID,
            SPC.POSITION_CAT
        FROM 
            G_SERVICE_APPCAT_SUB_POSTS SP,
            SETUP_POSITION_CAT SPC
        WHERE
            SP.SERVICE_SUB_CAT_ID = #attributes.service_cat_sub_id# AND
            SPC.POSITION_CAT_ID = SP.POSITION_CAT_ID
    </cfquery>
    <cfquery name="get_service_rows" datasource="#dsn#">
        SELECT 
            SERVICE_STATUS_ROW_ID, 
            SERVICE_SUB_CAT_ID, 
            SERVICECAT_ID, 
            SERVICE_SUB_STATUS_ID, 
            SERVICE_ID 
        FROM 
            G_SERVICE_APP_ROWS 
        WHERE 
            SERVICE_SUB_CAT_ID = #attributes.service_cat_sub_id#
    </cfquery>
    <cfquery name="get_service_appcat" datasource="#dsn#">
        SELECT 
            SERVICECAT_ID, 
            SERVICECAT, 
            IS_INTERNET, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP 
        FROM 
            G_SERVICE_APPCAT
        WHERE
            IS_STATUS = 1    
    </cfquery>
    <cfquery name="get_service_appcat_sub" datasource="#dsn#">
        SELECT 
            SERVICE_SUB_CAT_ID, 
            SERVICE_SUB_CAT, 
            SERVICECAT_ID,
            OUR_COMPANY_ID, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP,
            IS_STATUS 
        FROM 
            G_SERVICE_APPCAT_SUB 
        WHERE 
            SERVICE_SUB_CAT_ID = #attributes.service_cat_sub_id#
    </cfquery>
    <cfquery name="Get_Our_Company" datasource="#dsn#">
        SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
    </cfquery>
    <cfset yetkili_list = ''>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Şikayet Alt Kategorileri','42923')#" add_href="#request.self#?fuseaction=settings.form_add_g_service_app_cat_sub" is_blank="0">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
				<cfinclude template="../display/list_g_service_app_cat_sub.cfm">
			</div>
			<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
				<cfform name="service_app_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_g_service_app_cat_sub">  
					<input type="hidden" name="position_cats" id="position_cats" value="<cfoutput>#ListSort(ValueList(get_service_appcat_sub_cats.POSITION_CAT_ID),'numeric')#</cfoutput>">
					<input type="hidden" name="position_codes" id="position_codes" value="<cfoutput>#ListSort(ValueList(get_service_appcat_sub_posts.P_CODE),'numeric')#</cfoutput>">
					<input type="hidden" name="partner_ids" id="partner_ids" value="<cfoutput>#ListSort(ValueList(get_service_appcat_sub_posts.PAR_ID),'numeric')#</cfoutput>">
					<input type="hidden" name="consumer_ids" id="consumer_ids" value="<cfoutput>#ListSort(ValueList(get_service_appcat_sub_posts.CONS_ID),'numeric')#</cfoutput>">
					<input type="hidden" name="service_cat_sub_id"  id="service_cat_sub_id" value="<cfoutput>#attributes.service_cat_sub_id#</cfoutput>">
					<cf_box_elements>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
							<div class="form-group" id="item-is_status">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="checkbox" value="1" name="is_status" id="is_status"<cfif get_service_appcat_sub.is_status eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group" id="item-servicecat_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="servicecat_id" id="servicecat_id">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_service_appcat">
											<option value="#servicecat_id#" <cfif len(get_service_appcat_sub.servicecat_id) and get_service_appcat_sub.servicecat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-servicecat_sub">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43130.Alt Kategori'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='43224.Alt Kategori Adı Girmelisiniz'>!</cfsavecontent>
										<cfinput type="Text" name="service_sub_cat" size="60" value="#get_service_appcat_sub.service_sub_cat#" maxlength="50" required="Yes" message="#message#">
										<span class="input-group-addon">
											<cf_language_info 
											table_name="G_SERVICE_APPCAT_SUB" 
											column_name="SERVICE_SUB_CAT" 
											column_id_value="#attributes.service_cat_sub_id#" 
											maxlength="500" 
											datasource="#dsn#" 
											column_id="SERVICE_SUB_CAT_ID" 
											control_type="0">	
										</span>
									</div>	
								</div>
							</div>
							<div class="form-group" id="item-our_company_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="our_company_id" id="our_company_id" multiple>
										<cfoutput query="Get_Our_Company">
											<option value="#comp_id#" <cfif listfind(get_service_appcat_sub.our_company_id,comp_id)>selected</cfif>  >#nick_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
							<div class="form-group" id="item-positions">
								<cfsavecontent variable="txt_1"><cf_get_lang dictionary_id ='36167.Yetkili Pozisyonlar'></cfsavecontent>
									<cf_workcube_to_cc 
									is_update="1" 
									to_dsp_name="#txt_1#"
									form_name="service_app_cat" 
									str_list_param="1"
									data_type="2"
									str_action_names="POSITION_CODE AS TO_EMP"
									str_alias_names = "TO_EMP"
									action_table="G_SERVICE_APPCAT_SUB_POSTS"
									action_id_name="SERVICE_SUB_CAT_ID"
									action_dsn="#DSN#"
									action_id="#attributes.service_cat_sub_id#">
							</div>
							<div class="form-group" id="item-types">
								<cf_flat_list>
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
								</cf_flat_list>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_record_info query_name="get_service_appcat_sub">
						<cfif get_service_rows.recordcount>
                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_g_service_app_cat_sub&service_cat_sub_id=#attributes.service_cat_sub_id#&del_all'>
                        </cfif>
					</cf_box_footer>
				</cfform>
			</div>
		</cf_box>
	</div>

<script type="text/javascript">
	function kontrol()
	{
		<cfif x_upper_category eq 1>
		x = document.service_app_cat.servicecat_id.selectedIndex;
		if (document.service_app_cat.servicecat_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='43225.Üst Kategori Seçiniz'> !");
			return false;
		}
		</cfif>
		if(document.service_app_cat.our_company_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='58017.İlişkili Şirketler'> !");
		return false;
    }
	}
</script>