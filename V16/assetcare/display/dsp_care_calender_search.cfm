<cfquery name="GET_ASSETP_CAT" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT <!--- WHERE MOTORIZED_VEHICLE = 1 ---> ORDER BY ASSETP_CAT
</cfquery>
<cfquery name="GET_ASSET_CAT" datasource="#dsn#">
	SELECT ASSET_CARE_ID, ASSET_CARE,ASSETP_CAT FROM ASSET_CARE_CAT ORDER BY ASSET_CARE
</cfquery>
<cfif (attributes.fuseaction eq 'assetcare.list_weekly_report') or (attributes.fuseaction eq 'assetcare.dsp_care_calender')>
<cfscript>
	if (isdefined('url.gun')) 
		gun = url.gun;
	else
		gun = dateformat(now(), 'dd');
	if (isdefined('url.ay'))
		ay = url.ay;
	else
		ay = dateformat(now(),'mm');
	if (isdefined('url.yil'))
		yil = url.yil;
	else
		yil = dateformat(now(),'yyyy');
	
	tarih = '#gun#/#ay#/#yil#';
	try
	{
		temp_tarih = tarih;
		attributes.to_day = date_add('h', -session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
	}
	catch(Any excpt)
	{
		tarih = '1/#ay#/#yil#';
		temp_tarih = tarih;
		attributes.to_day = date_add('h', -session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-1'));
	}
</cfscript>
<cf_date tarih="temp_tarih">
</cfif>
<cfform name="service_date_" method="post" action="#request.self#?fuseaction=assetcare.list_monthly_report">
<cf_big_list_search title="">
	<cf_big_list_search_area>
			<div class="row form-inline">
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="official_emp_id" id="official_emp_id" value="<cfoutput>#attributes.official_emp_id#</cfoutput>">      
						<input type="text" name="official_emp" placeholder="<cf_get_lang_main no='157.Grevli'>" id="official_emp" onFocus="AutoComplete_Create('official_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','official_emp_id','','3','125');" value="<cfoutput>#attributes.official_emp#</cfoutput>" style="width:130px;" autocomplete="off">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=service_date_.official_emp_id&field_name=service_date_.official_emp&select_list=1','list','popup_list_positions')"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>"> 
						<input type="text" name="branch" id="branch" placeholder="<cf_get_lang_main no='41.Sube'>" value="<cfoutput>#attributes.branch#</cfoutput>" style="width:130px;"> 
						<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=service_date_.branch&field_branch_id=service_date_.branch_id','list','popup_list_branches')"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="time_type" id="time_type" style="width:130px;">
						<option value="1" <cfif attributes.time_type eq 1>selected</cfif>><cf_get_lang_main no='1045.Gnlk'></option>
						<option value="2" <cfif attributes.time_type eq 2>selected</cfif>><cf_get_lang_main no='1046.Haftalik'></option>
						<option value="3" <cfif attributes.time_type eq 3>selected</cfif>><cf_get_lang_main no='1520.Aylik'></option>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function='kontrol()' is_excel= '0'>
					<cfif attributes.time_type eq 1>
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module='care_calendar2' is_ajax="1">
					<cfelse>
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' is_ajax="1">
					</cfif>
				</div>
			</div>
	</cf_big_list_search_area>
	<cf_big_list_search_detail_area>
            <div class="row form-inline">
                <div class="form-group">
					<div class="input-group">
                    	<cf_wrkAssetp fieldId='asset_id' asset_id="#attributes.asset_id#" fieldName='asset_name' form_name='service_date_' button_type='plus_thin' width='130'>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
                        <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
                        <input type="text" name="department" id="department" placeholder="<cf_get_lang_main no='160.Departman'>" value="<cfoutput>#attributes.department#</cfoutput>" style="width:130px;">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=service_date_.department_id&field_dep_branch_name=service_date_.department','list');"></span>
                    </div>
				</div>	
                <div class="form-group">
					<select name="assetpcatid" id="assetpcatid" style="width:130px;" onChange="get_value(this.value,'asset_cat',0);">
						<option value=""><cf_get_lang_main no='74.Kategori'></option>
						<cfoutput query="get_assetp_cat">
							<option value="#assetp_catid#" <cfif attributes.assetpcatid eq assetp_catid> selected</cfif>>#assetp_cat#</option>
						</cfoutput>
					</select>
				</div>
                <div class="form-group">
					<select name="asset_cat" id="asset_cat" style="width:125px;">
						<option value=""><cf_get_lang no ='42.Bakım Tipi'></option>
						<cfoutput query="get_asset_cat">
						<option value="#asset_care_id#" <cfif attributes.asset_cat eq asset_care_id>selected</cfif>>#asset_care#
						</cfoutput>
					</select>
				</div> 
            </div>
	</cf_big_list_search_detail_area>
</cf_big_list_search>
</cfform>
<script type="text/javascript">
function kontrol()
{
	if(document.service_date_.time_type.value == '')
	{
		alert("Bakım Periyodu Seçmelisiniz !");
		return false;
	}
	else	
	{	
		if(document.service_date_.time_type.value == 1) 
		{
			service_date_.action = <cfoutput>'#request.self#?fuseaction=assetcare.dsp_care_calender'</cfoutput>; 
			service_date_.submit();
		}
		if(document.service_date_.time_type.value == 2) 
		{
			service_date_.action = <cfoutput>'#request.self#?fuseaction=assetcare.list_weekly_report<cfif isdefined("seventh_day") and len(seventh_day)>&yil=#dateformat(seventh_day,"yyyy")#&ay=#dateformat(seventh_day,"mm")#&gun=#dateformat(seventh_day,"dd")#</cfif>'</cfoutput>; 
			service_date_.submit();
		}
		if(document.service_date_.time_type.value == 3) 
		{
			service_date_.action = <cfoutput>'#request.self#?fuseaction=assetcare.list_monthly_report&yil=#yil#&ay=#ay#&gun=#gun#'</cfoutput>; 
			service_date_.submit();
		}
	}
}

function get_value(assetp_id)
{
	var get_care_type_no=wrk_safe_query('ascr_get_care_type_no','dsn',0,assetp_id);
	var asset_cat_len = eval('document.getElementById("asset_cat")').options.length;
	for(j=asset_cat_len;j>=0;j--)
		eval('document.getElementById("asset_cat")').options[j] = null;	
		eval('document.getElementById("asset_cat")').options[0] = new Option('Seçiniz','');
	for(var jj=0;jj < get_care_type_no.recordcount;jj++)
		eval('document.getElementById("asset_cat")').options[jj+1]=new Option(''+get_care_type_no.ASSET_CARE[jj]+'',''+get_care_type_no.ASSET_CARE_ID[jj]+'');
}
</script>
