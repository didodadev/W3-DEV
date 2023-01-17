<cfparam name="attributes.official_emp_id" default="">
<cfparam name="attributes.official_emp" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.asset_cat" default="">
<cfquery name="GET_ASSET_CAT" datasource="#dsn#">
	SELECT ASSET_CARE_ID, ASSET_CARE FROM ASSET_CARE_CAT ORDER BY ASSET_CARE
</cfquery>
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
<br/><br/>
<table width="98%" align="center" cellpadding="0" cellspacing="0">
		<tr class="color-list" height="22">
		<td height="35">
		<table width="98%" cellpadding="2" cellspacing="1" align="center">
			<tr>
				<!--- <cfoutput>
					<td width="15"><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&gun=#Dateformat(date_add("d",-1,tarih),"dd")#&ay=#Dateformat(date_add("d",-1,tarih),"mm")#&yil=#Dateformat(date_add("d",-1,tarih),"yyyy")#"><img src="/images/previous20.gif" border=0 align="absmiddle"></a></td>
					<td class="headbold" nowrap>#temp_tarih# - <cf_date tarih="tarih"><cfmodule template="../../agenda/display/tr_tarih.cfm" output="1" format="dddd" tarih="#tarih#"></td>
					<td width="15"><a href="#request.self#?fuseaction=assetcare.dsp_care_calender&gun=#Dateformat(date_add("d",1,tarih),"dd")#&ay=#Dateformat(date_add("d",1,tarih),"mm")#&yil=#Dateformat(date_add("d",1,tarih),"yyyy")#"><img src="/images/next20.gif" border=0 align="absmiddle"></a></td>
				</cfoutput> --->
				<td align="right" width="100%">
				<table>
					<cfform name="service_date" action="">
					<tr>
						<td><cf_get_lang_main no ='1421.Fiziki Varlik'></td>
						<td>
							<cf_wrkAssetp fieldId='asset_id' asset_id="#attributes.asset_id#"  fieldName='asset_name' form_name='service_date' button_type='plus_thin' width='145'>
						</td>
						<td><cf_get_lang_main no='157.Grevli'></td>
						<td><input type="hidden" name="official_emp_id" id="official_emp_id" value="<cfoutput>#attributes.official_emp_id#</cfoutput>">      
							<input type="text" name="official_emp" id="official_emp" onFocus="AutoComplete_Create('official_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','official_emp_id','','3','125');" value="<cfoutput>#attributes.official_emp#</cfoutput>" style="width:125px;" autocomplete="off">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=service_date.official_emp_id&field_name=service_date.official_emp&select_list=1','list','popup_list_positions')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
						</td>
						<td><cf_get_lang_main no='74.Kategori'></td>
						<td><select name="asset_cat" id="asset_cat" style="width:120px;">
								<option value=""><cf_get_lang_main no='74.Kategori'> 
								</option>
								<cfoutput query="get_asset_cat">
									<option value="#asset_care_id#" <cfif attributes.asset_cat eq asset_care_id>selected</cfif>>#asset_care# 
								</cfoutput>
							</select>
						</td>
<!--- 						 <td>
							<select name="url" onchange="get_care_calender_period(this.selectedIndex);"><!--- if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') } --->
								<option><cf_get_lang no='4.Bakim Periyodu'></option>
								<option value="3"><cf_get_lang no='91.Aylik'></option>
							</select>
						</td> 
							<td><!--- <cf_wrk_search_button> --->
							<input type="hidden" name="dept_i 	d_selected" value="" />
						</td>
 --->					</tr>
					</cfform>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<!--- <tr>
		<td>
			<table width="100%" height="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td class="headbold" width="175" valign="top"><cfinclude template="../../agenda/display/left_agenda.cfm"></td>
					<td align="left"><div id="show_dsp_care_calender" style="overflow-y:auto;overflow-x:auto;height:99%;width:100%;"></div></td>
				</tr>
			</table>
		</td>
	</tr> --->
</table>
<br/>
<!--- <script type="text/javascript">
	function get_care_calender_period(type_)
	
{
	if(type_==1){
	alert(type_);
	AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emptypopup_dsp_care_calender','show_dsp_care_calender');
	}
	if(type_==2){
		adres_ = '<cfoutput>#request.self#?fuseaction=assetcare.list_weekly_report&asset_id=#attributes.asset_id#&official_emp_id=#attributes.official_emp_id#</cfoutput>';
	AjaxPageLoad(adres_,'show_dsp_care_calender');//(adres_,'puantaj_list_layer','1',"Tablo Listeleniyor")

	}
	if(type_==3){
		adres_ = '<cfoutput>#request.self#?fuseaction=assetcare.list_monthly_report&asset_id=#attributes.asset_id#&official_emp_id=#attributes.official_emp_id#</cfoutput>';
	AjaxPageLoad(adres_,'show_dsp_care_calender');

	}
	/*
	asset_id_ = document.employee.sal_year.value;
	sal_mon_ = document.employee.sal_mon.value;
	ssk_office_all_ = document.employee.ssk_office.value;
	ssk_office_ = list_getat(document.employee.ssk_office.value,1,'-');
	ssk_no_ = list_getat(document.employee.ssk_office.value,2,'-');
	
	adres_= adres_ + '&sal_mon=' + sal_mon_ + '&sal_year=' + sal_year_ + '&ssk_office=' + encodeURI(ssk_office_all_);
	*/
 }	
</script> --->

