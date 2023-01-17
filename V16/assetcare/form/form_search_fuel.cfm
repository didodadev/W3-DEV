<cfinclude template="../query/get_fuel_type.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfinclude template="../query/get_branch.cfm">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.document_type_id" default="">	
<cfparam name="attributes.record_num" default="">
<cfparam name="attributes.document_num" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.assetp_name" default="">
<cfparam name="attributes.assetp_id" default="">
<cfparam name="attributes.fuel_comp_name" default="">
<cfparam name="attributes.fuel_comp_id" default="">
<cfparam name="attributes.fuel_type_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_fuel" method="post" action="#request.self#?fuseaction=assetcare.form_search_fuel" onSubmit="return(kontrol());"><!--- target="frame_fuel_search" --->
			<cf_box_search>    	
				<input type="hidden" name="is_submitted" id="is_submitted" value="1">
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
						<input type="text" name="assetp_name" id="assetp_name" placeholder="<cfoutput>#getLang(1656,'Plaka',29453)#</cfoutput>" value="<cfoutput>#attributes.assetp_name#</cfoutput>">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=search_fuel.assetp_id&field_name=search_fuel.assetp_name&list_select=2','list','popup_list_ship_vehicles');"></span>
					</div>    
				</div>	
				<div class="form-group">
					<input name="document_num" id="document_num" type="text" placeholder="<cfoutput>#getLang(468,'Belge No',57880)#</cfoutput>" value="<cfoutput>#attributes.document_num#</cfoutput>">
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
						<input type="text" name="employee_name" id="employee_name" placeholder="<cfoutput>#getLang(132,'Sorumlu',57544)#</cfoutput>" value="<cfoutput>#attributes.employee_name#</cfoutput>">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_fuel.employee_id&field_name=search_fuel.employee_name&select_list=1</cfoutput>','list','popup_list_positions')" alt="<cf_get_lang dictionary_id='57544.Sorumlu'>" align="absmiddle" border="0"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
						<input type="text" name="branch" id="branch" placeholder="<cfoutput>#getLang(41,'Şube',57453)#</cfoutput>" value="<cfoutput>#attributes.branch#</cfoutput>">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_fuel.branch_id&field_branch_name=search_fuel.branch','list','popup_list_branches');" alt="<cf_get_lang dictionary_id='57453.Şube'>" align="absmiddle" border="0"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-fuel_comp_name">
                        <label class="col col-12"><cfoutput>#getLang(2320,'Yakıt Şirketi',30117)#</cfoutput></label>
                        <div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="fuel_comp_id" id="fuel_comp_id" value="<cfoutput>#attributes.fuel_comp_id#</cfoutput>">
								<input type="text" name="fuel_comp_name" id="fuel_comp_name" value="<cfoutput>#attributes.fuel_comp_name#</cfoutput>">
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=search_fuel.fuel_comp_id&field_comp_name=search_fuel.fuel_comp_name&is_buyer_seller=1&select_list=2</cfoutput>')" alt="<cf_get_lang dictionary_id='30117.Yakıt Şirketi'>" align="absmiddle" border="0"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-document_type_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
                        <div class="col col-12">
							<select name="document_type_id" id="document_type_id">
								<option value=""><cf_get_lang dictionary_id='58533.Belge Tipi'></option>
								<cfoutput query="get_document_type">
									<option value="#document_type_id#" <cfif attributes.document_type_id eq document_type_id>selected</cfif>>#document_type_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-fuel_type_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='30113.Yakıt Tipi'></label>
                        <div class="col col-12">
							<select name="fuel_type_id" id="fuel_type_id">
								<option value=""><cf_get_lang dictionary_id='30113.Yakıt Tipi'></option>
								<cfoutput query="get_fuel_type">
									<option value="#fuel_id#" <cfif attributes.fuel_type_id eq fuel_id>selected</cfif>>#fuel_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-start_date">
                        <label class="col col-12"><cfoutput>#getLang(243,'Başlama Tarihi',57655)#</cfoutput></label>
                        <div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id ='30122.Başlangıç Tarihini Kontrol Ediniz '>!</cfsavecontent>
								<cfinput type="text" name="start_date" value="#attributes.start_date#" placeholder="#getLang(243,'Başlama Tarihi',57655)#" validate="#validate_style#" maxlength="10" message="#message1#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-finish_date">
                        <label class="col col-12"><cfoutput>#getLang(288,'Bitiş Tarihi',57700)#</cfoutput></label>
                        <div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='30123.Bitiş Tarihini Kontrol Ediniz'> !</cfsavecontent>
								<cfinput type="text" name="finish_date" value="#attributes.finish_date#" placeholder="#getLang(288,'Bitiş Tarihi',57700)#" validate="#validate_style#" maxlength="10" message="#message2#">
								<input name="record_num" id="record_num" type="hidden">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail> 
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Yakıt Harcamaları',47252)#" uidrop="1" hide_table_column="1">
		<cf_grid_list sort="0">
			<cfinclude template="../display/list_fuel_search.cfm">
		</cf_grid_list>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{	
	if(!CheckEurodate(document.search_fuel.start_date.value,"<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>"))
	{
		return false;
	}
	
	if(!CheckEurodate(document.search_fuel.finish_date.value,"<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>"))
	{
		return false;
	}
	
	if ((document.search_fuel.start_date.value.length>0) && (document.search_fuel.finish_date.value.length>0) && (!date_check(document.search_fuel.start_date,document.search_fuel.finish_date,"<cf_get_lang dictionary_id='57806.Tarih Aralığını Kontrol Ediniz'>!")) )
	{
		return false;
	}
	
	return true;
}
</script>
