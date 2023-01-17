<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfif month(now()) eq 1>
	<cfparam name="attributes.sal_mon" default="1">
<cfelse>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
</cfif>
<cfinclude template="../ehesap/query/get_ssk_offices.cfm">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.ssk_office" default="0">
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
        <cfform name="employee" method="post" action="">
        	<cf_box_search more="0"> 
				<div class="form-group">
					<select name="ssk_office" id="ssk_office">
						<cfoutput query="GET_SSK_OFFICES">
							<cfif len(SSK_OFFICE) and len(SSK_NO)>
								<option value="#SSK_OFFICE#-#SSK_NO#"<cfif attributes.ssk_office is "#SSK_OFFICE#-#SSK_NO#"> selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
							</cfif>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cfquery name="get_units" datasource="#DSN#">
						SELECT * FROM SETUP_CV_UNIT WHERE  IS_ACTIVE=1 ORDER BY UNIT_NAME
					</cfquery>
					<select name="func_id" id="func_id">
						<option value=""><cf_get_lang dictionary_id ='58702.Fonksiyon Seçiniz'>
						<cfoutput query="get_units">
							<option value="#get_units.unit_id#">#unit_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="sal_mon" id="sal_mon">
						<cfloop from="1" to="12" index="i">
							<cfoutput>
								<option value="#i#" <cfif month(now()) gt 1 and i eq month(now())-1>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<input type="text" name="sal_year" id="sal_year" value="<cfoutput>#session.ep.period_year#</cfoutput>" readonly size="3">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57911.Çalıştır"></cfsavecontent>
					<cf_wrk_search_button button_type="4" button_name="#message#" search_function="open_form_ajax()">
					
				</div>
			</cf_box_search>
        </cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='55674.Şube Bazında PDKS'></cfsavecontent>
	<cf_box title="#title#" hide_table_column="1" uidrop="1"   woc_setting = "#{ checkbox_name : 'print_pdks_id',  print_type : 533 }#">
		<div id="branch_pdks_table">
		</div>
		<cf_grid_list id="ajax_load">
			<tbody>
		<tr>
			<td colspan="50"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
		</tr>
	</tbody>
	</cf_grid_list>
	</cf_box>
</div>


<script type="text/javascript">
function open_form_ajax()
{
	adres_ = '<cfoutput>#request.self#?fuseaction=hr.emptypopup_ajax_view_pdks</cfoutput>';
	sal_year_ = document.getElementById('sal_year').value;
	func_ = document.getElementById('func_id').value;
	sal_mon_ = document.getElementById('sal_mon').value;
	//ssk_office_all_ = document.employee.shifts.value;
	//ssk_office_ = list_getat(document.employee.shifts.value,1,'-');
	//ssk_no_ = list_getat(document.employee.shifts.value,2,'-');
	ssk_office_all_ = document.getElementById('ssk_office').value;
	ssk_office_ = list_getat(document.getElementById('ssk_office').value,1,'-');
	ssk_no_ = list_getat(document.getElementById('ssk_office').value,2,'-');
	//adres_= adres_ + '&sal_mon=' + sal_mon_ + '&sal_year=' + sal_year_ + '&shifts=' + ssk_office_all_;
	adres_= adres_ + '&sal_mon=' + sal_mon_ + '&sal_year=' + sal_year_ + '&ssk_office=' + ssk_office_all_ + '&func_id=' + func_;
	$('#ajax_load').hide();
	AjaxPageLoad(adres_,'branch_pdks_table','1',"Tablo Listeleniyor");
	return false;
 }
 function send_adres_info()
 {
	adres = '<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=532</cfoutput>';
	//adres +='&ssk_office_all_='+encodeURIComponent(document.employee.shifts.value);
	//adres +='&ssk_office_='+encodeURIComponent(list_getat(document.employee.shifts.value,1,'-'));
	//adres +='&ssk_office_all_='+encodeURIComponent(document.getElementById('ssk_office').value);
	adres +='&ssk_office_='+encodeURIComponent(list_getat(document.getElementById('ssk_office').value,1,'-'));
	adres +='&ssk_no_='+encodeURIComponent(list_getat(document.getElementById('ssk_office').value,2,'-'));
	adres +='&sal_mon_='+document.getElementById('sal_mon').value;
	//adres +='&id='+list_getat(document.employee.shifts.value,2,'-');
	//adres +='&id='+list_getat(document.employee.shifts.value,2,'-');
	window.open(adres,'woc');	
 }
</script>
