<cf_xml_page_edit>
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
<cfquery name="Get_Our_Company" datasource="#dsn#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Şikayet Alt Kategorileri','42923')#" add_href="#request.self#?fuseaction=settings.form_add_g_service_app_cat_sub" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cfinclude template="../display/list_g_service_app_cat_sub.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="service_app_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_g_service_app_cat_sub"> 
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-is_status">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" value="1" name="is_status" id="is_status" checked>
							</div>
						</div>
						<div class="form-group" id="item-servicecat_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="servicecat_id" id="servicecat_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_service_appcat">
										<option value="#servicecat_id#">#servicecat#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-servicecat_sub">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43130.Alt Kategori'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='43224.Alt Kategori Adı Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" name="servicecat_sub" value="" maxlength="50" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-our_company_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="our_company_id" id="our_company_id" multiple>
									<cfoutput query="Get_Our_Company">
										<option value="#comp_id#">#nick_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<input type="hidden" name="position_cats" id="position_cats" value="">
						<input type="hidden" name="position_codes" id="position_codes" value="">
						<div class="form-group" id="item-positions">
							<cfsavecontent variable="txt_1"><cf_get_lang dictionary_id ='36167.Yetkili Pozisyonlar'></cfsavecontent>
							<cf_workcube_to_cc
							is_update="0"
							to_dsp_name="#txt_1#"
							form_name="service_app_cat"
							str_list_param="1"
							action_dsn="#DSN#"
							str_action_names="POSITION_CODE AS TO_EMP"
							action_table="G_SERVICE_APPCAT_SUB_POSTS"
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


					</div>

				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</cfform>
		</div>
	</cf_box>
</div>

			<!--- 		
			</tr>
		</table>
		</td>
		<td>
		
		<table width="100%" border="0">
			<tr class="color-header" height="20">
				<td width="1%"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_pos=service_app_cat.position_codes&field_pos_table=td_yetkili1</cfoutput>&select_list=1&window_close=1','list');"><img src="/images/plus_square.gif" border="0"></a></td>
				<td class="form-title" width="49%"><cf_get_lang no='700.Yetkili Pozisyonlar'></td>
				<td width="1%"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=service_app_cat.position_cats&field_td=td_yetkili2</cfoutput>&is_noclose=1','list');"><img src="/images/plus_square.gif" border="0"></a></td>
				<td class="form-title" width="49%"><cf_get_lang no='753.Yetkili Pozisyon Tipleri'></td>
			</tr>
			<tr>
				<td id="td_yetkili1" colspan="2" valign="top"></td>
				<td id="td_yetkili2" colspan="2" valign="top"></td>
			</tr>
		</table>
		</td>
	</tr>
</table> --->
		
<script type="text/javascript">
function kontrol()
{
	x = document.service_app_cat.servicecat_id.selectedIndex;
	<cfif x_upper_category eq 1>
	if (document.service_app_cat.servicecat_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='43225.Üst Kategori Seçiniz'>!");
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
