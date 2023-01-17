
<cfif isdefined("attributes.con_id") and len(attributes.con_id)>
	<cfquery name="get_zno" datasource="#dsn_Dev#">
    	SELECT * FROM POS_CONS WHERE CON_ID = #attributes.CON_ID#
    </cfquery>
</cfif>
<cfquery name="get_kasalar" datasource="#dsn#">
	SELECT 
    	B.BRANCH_NAME,
        PE.EQUIPMENT_CODE
    FROM 
    	BRANCH B,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
    	<cfif isdefined("attributes.con_id") and len(attributes.con_id)>
        	PE.EQUIPMENT_CODE = #get_zno.KASA_NUMARASI# AND
        </cfif> 
        B.BRANCH_ID = PE.BRANCH_ID AND
        B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	OZEL_KOD,
        BRANCH_NAME,
        PE.EQUIPMENT_CODE
</cfquery>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="" method="post" name="add_fis_form">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<cfif not isdefined("attributes.con_id")>
						<div class="form-group" id="item-give_date">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<cfif isdefined("attributes.con_id")>
										<cfset tarih_ = get_zno.give_date>
									<cfelse>
										<cfset tarih_ = now()>
									</cfif>
									<cfinput type="text" name="give_date" value="#dateformat(tarih_,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Teslim Tarihi',57645)#" required="yes" style="width:65px;" onBlur="return get_znumber();">
									<span class="input-group-addon"><cf_wrk_date_image date_field="give_date" call_function="get_znumber"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-employee_name">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54577.Kasiyer'></label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<cfinput type="hidden" name="employee_id" id="employee_id" value="" required="yes" message="#getLang('','Kasiyer Seçmelisiniz',62027)#!">
									<cfinput name="employee_name" type="text" id="employee_name" required="yes" message="#getLang('','Kasiyer Seçmelisiniz',62027)#!" style="width:100px;" onfocus="AutoComplete_Create('employee_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','employee_id','','3','130');" value="" maxlength="255" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_fis_form.employee_id&field_name=add_fis_form.employee_name&select_list=1&is_form_submitted=1&is_store_module=1&branch_related=1','list','popup_list_positions');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-kasa_numarasi">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37748.Mağaza'> - <cf_get_lang dictionary_id='57520.Kasa'></label>
							<div class="col col-8 col-sm-12">
								<cfselect name="kasa_numarasi" id="kasa_numarasi" required="yes" message="#getLang('','Kasa Seçmelisiniz',43941)#!" onChange="get_znumber();">
									<option value=""><cf_get_lang dictionary_id='47307.Kasa Seçiniz'></option>
									<cfoutput query="get_kasalar" group="BRANCH_NAME">
										<optgroup label="#BRANCH_NAME#">
											<cfoutput>
												<option value="#EQUIPMENT_CODE#">#EQUIPMENT_CODE#</option>
											</cfoutput>
										</optgroup>
									</cfoutput>
								</cfselect>
							</div>
						</div>
						<div class="form-group" id="item-z_number">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62028.Z Numarası'></label>
							<div class="col col-8 col-sm-12">
								<div id="z_number_div">
									<select name="z_number" id="z_number">
										<option value=""><cf_get_lang dictionary_id='62029.Önce Kasa Seçiniz'>!</option>
									</select>
								</div>
							</div>
						</div>
					<cfelse>
						<div class="form-group" id="item-give_date">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<cfif isdefined("attributes.con_id")>
										<cfset tarih_ = get_zno.CON_DATE>
									<cfelse>
										<cfset tarih_ = now()>
									</cfif>
									<cfinput type="text" name="give_date" value="#dateformat(tarih_,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Teslim Tarihi',57645)#" required="yes" style="width:65px;" readonly="yes">
								</div>
							</div>
						</div>
						<div class="form-group" id="item-employee_name">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54577.Kasiyer'></label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<cfinput type="hidden" name="employee_id" id="employee_id" value="#get_zno.kasiyer_no#" required="yes" message="#getLang('','Kasiyer Seçmelisiniz',62027)#!">
									<cfinput name="employee_name" type="text" id="employee_name" required="yes" message="#getLang('','Kasiyer Seçmelisiniz',62027)#!" style="width:100px;" onfocus="AutoComplete_Create('employee_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','employee_id','','3','130');" value="#get_emp_info(get_zno.kasiyer_no,0,0)#" maxlength="255" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_fis_form.employee_id&field_name=add_fis_form.employee_name&select_list=1&is_form_submitted=1&is_store_module=1&branch_related=1','list','popup_list_positions');"><img src="/images/plus_thin.gif" align="absmiddle"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-kasa_numarasi">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37748.Mağaza'> - <cf_get_lang dictionary_id='57520.Kasa'></label>
							<div class="col col-8 col-sm-12">
								<cfselect name="kasa_numarasi" id="kasa_numarasi" required="yes" message="#getLang('','Kasa Seçmelisiniz',43941)#!">
									<cfoutput query="get_kasalar" group="BRANCH_NAME">
										<optgroup label="#BRANCH_NAME#">
											<cfoutput>
												<option value="#EQUIPMENT_CODE#" <cfif EQUIPMENT_CODE eq get_zno.kasa_numarasi>selected</cfif>>#EQUIPMENT_CODE#</option>
											</cfoutput>
										</optgroup>
									</cfoutput>
								</cfselect>
							</div>
						</div>
						<div class="form-group" id="item-z_number">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62028.Z Numarası'></label>
							<div class="col col-8 col-sm-12">
								<div id="z_number_div">
									<cfinput type="text" name="z_number" id="z_number" value="#get_zno.zno#" style="width:75px;" readonly="yes">
								</div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group">
						<div id="z_number_div_action3"><cf_get_lang dictionary_id='62030.Küpürler İçin Z Numarası Seçmelisiniz'>!</div>
					</div>
					<div class="form-group">
						<div id="z_number_div_action2"><br /><cf_get_lang dictionary_id='62031.Toplamlar İçin Z Numarası Seçmelisiniz'>!</div>
					</div>
					<div class="form-group">
						<div id="z_number_div_action"><br /><cf_get_lang dictionary_id='62032.Z Numarası Seçmelisiniz'>!</div>
					</div>
				</div>
			</cf_box_elements>
		</cfform>
	</cf_box>
</div>


<script>
function get_znumber()
{
	document.getElementById('z_number_div_action').innerHTML = '<br /><cf_get_lang dictionary_id='62032.Z Numarası Seçmelisiniz'>!';
	document.getElementById('z_number_div_action2').innerHTML = '<cf_get_lang dictionary_id='62031.Toplamlar İçin Z Numarası Seçmelisiniz'>!';
	document.getElementById('z_number_div_action3').innerHTML = '<cf_get_lang dictionary_id='62030.Küpürler İçin Z Numarası Seçmelisiniz'>!';
	if(document.getElementById('give_date').value == '')
	{
		alert('<cf_get_lang dictionary_id='62034.Tarih Seçmelisiniz'>!');
		document.getElementById('kasa_numarasi').value = '';
		return false;	
	}
	kasa_id_ = document.getElementById('kasa_numarasi').value;
	
	if(kasa_id_ == '')
	{
		//alert('Kasa Seçmelisiniz!');
		document.getElementById('kasa_numarasi').value = '';
		return false;	
	}
	
	if(document.getElementById('employee_id').value == '' || document.getElementById('employee_name').value == '')
	{
		alert('<cf_get_lang dictionary_id='62027.Kasiyer Seçmelisiniz'>!');
		document.getElementById('kasa_numarasi').value = '';
		return false;	
	}
	
	adress_ = 'index.cfm?fuseaction=retail.popup_get_z_numbers';
	adress_ += '&kasa_id=' + kasa_id_;
	adress_ += '&give_date=' + document.getElementById('give_date').value;
	AjaxPageLoad(adress_,'z_number_div',1);
	return true;
}
function get_znumber_inner()
{
	if(document.getElementById('z_number').value == '')
	{
		document.getElementById('z_number_div_action').innerHTML = '<br /><cf_get_lang dictionary_id='62032.Z Numarası Seçmelisiniz'>!';
		document.getElementById('z_number_div_action2').innerHTML = '<cf_get_lang dictionary_id='62031.Toplamlar İçin Z Numarası Seçmelisiniz'>!';
		document.getElementById('z_number_div_action3').innerHTML = '<cf_get_lang dictionary_id='62030.Küpürler İçin Z Numarası Seçmelisiniz'>!';
		//alert('Z Numarası Seçmelisiniz!');
		return false;	
	}
	kasa_id_ = document.getElementById('kasa_numarasi').value;
	
	sql_ = "SELECT * FROM <cfoutput>#dsn_dev_alias#</cfoutput>.POS_CONS WHERE KASA_NUMARASI = " + kasa_id_;
	sql_ += " AND ZNO = '" + document.getElementById('z_number').value + "' ";
	sql_ += " AND YEAR(CON_DATE) = " + list_getat(document.getElementById('give_date').value,3,'/');
    sql_ += " AND MONTH(CON_DATE) = " + list_getat(document.getElementById('give_date').value,2,'/');
	sql_ += " AND DAY(CON_DATE) = " + list_getat(document.getElementById('give_date').value,1,'/');
	
	a = wrk_query(sql_);
	<cfif not isdefined("attributes.con_id") or not len(attributes.con_id)>
	if(a.recordcount)
	{
		alert('<cf_get_lang dictionary_id='62033.Bu Kasa İçin Z Raporu Oluşturulmuştur'>!');
		return false;
	}
	</cfif>
	
	
	adress_ = 'index.cfm?fuseaction=retail.popup_get_z_numbers_inner';
	adress_ += '&kasa_id=' + kasa_id_;
	adress_ += '&give_date=' + document.getElementById('give_date').value;
	adress_ += '&z_number=' + document.getElementById('z_number').value;
	<cfif isdefined("attributes.con_id")>
		adress_ += '<cfoutput>&con_id=#attributes.con_id#</cfoutput>';
	</cfif>
	AjaxPageLoad(adress_,'z_number_div_action',1);
	
	adress_ = 'index.cfm?fuseaction=retail.popup_get_z_numbers_inner2';
	adress_ += '&kasa_id=' + kasa_id_;
	adress_ += '&give_date=' + document.getElementById('give_date').value;
	adress_ += '&z_number=' + document.getElementById('z_number').value;
	<cfif isdefined("attributes.con_id")>
		adress_ += '<cfoutput>&con_id=#attributes.con_id#</cfoutput>';
	</cfif>
	AjaxPageLoad(adress_,'z_number_div_action2',1);
	
	adress_ = 'index.cfm?fuseaction=retail.popup_get_z_numbers_inner3';
	adress_ += '&kasa_id=' + kasa_id_;
	adress_ += '&give_date=' + document.getElementById('give_date').value;
	adress_ += '&z_number=' + document.getElementById('z_number').value;
	<cfif isdefined("attributes.con_id")>
		adress_ += '<cfoutput>&con_id=#attributes.con_id#</cfoutput>';
	</cfif>
	AjaxPageLoad(adress_,'z_number_div_action3',1);
	return true;
}
function kontrol()
{
	if (!chk_period(add_fis_form.give_date,"İşlem")) return false;
	
	if(document.getElementById('give_date').value == '')
	{
		alert('<cf_get_lang dictionary_id='62034.Tarih Seçmelisiniz'>!');
		return false;	
	}
	
	if(document.getElementById('kasa_numarasi').value == '')
	{
		alert('<cf_get_lang dictionary_id='43941.Kasa Seçmelisiniz'>!');
		return false;	
	}
	
	if(document.getElementById('employee_id').value == '' || document.getElementById('employee_name').value == '')
	{
		alert('<cf_get_lang dictionary_id='62027.Kasiyer Seçmelisiniz'>!');
		return false;	
	}
	
	if(document.getElementById('z_number').value == '')
	{
		alert('<cf_get_lang dictionary_id='62032.Z Numarası Seçmelisiniz'>!');
		return false;	
	}
}

function del_kontrol()
{
	if (!chk_period(add_fis_form.give_date,"İşlem")) 
		return false;
	else
		return true;
}
<cfif isdefined("attributes.con_id")>
	get_znumber_inner();
</cfif>
</script>