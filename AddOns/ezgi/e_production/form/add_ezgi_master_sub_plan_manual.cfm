<div id="prod_stock_and_spec_detail_div" align="center" style="position:absolute;width:300px; height:150; overflow:auto;z-index:1;"></div>
<cfquery name="get_master_plan" datasource="#dsn3#">
	SELECT	MASTER_PLAN_START_DATE,
			MASTER_PLAN_FINISH_DATE,
			MASTER_PLAN_CAT_ID, 
			MASTER_PLAN_NAME, 
			MASTER_PLAN_NUMBER, 
			MASTER_PLAN_DETAIL, 
			MASTER_PLAN_STATUS, 
			MASTER_PLAN_STAGE,
			EMPLOYYEE_ID, 
			BRANCH_ID, 
			RECORD_EMP, 
			RECORD_IP, 
			RECORD_DATE, 
			IS_PROCESS, 
			MONEY,
			MASTER_PLAN_PROJECT_ID,
			GROSSTOTAL
	FROM	EZGI_MASTER_PLAN
	WHERE	MASTER_PLAN_ID = #master_plan_id#
</cfquery>
<cfparam name="attributes.master_alt_plan_start_date" default="#get_master_plan.MASTER_PLAN_START_DATE#">
<cfparam name="attributes.master_alt_plan_finish_date" default="#get_master_plan.MASTER_PLAN_FINISH_DATE#">
<cfparam name="attributes.master_alt_plan_start_h" default="">
<cfparam name="attributes.master_alt_plan_finish_h" default="">
<cfparam name="attributes.master_alt_plan_start_m" default="">
<cfparam name="attributes.master_alt_plan_finish_m" default="">
<cfparam name="attributes.form_basket_submitted" default="">
<cfquery name="get_paper_no" datasource="#dsn3#">
	SELECT    	PROCESS_ID, 
				PROCESS_NAME, 
				PAPER_SERIOUS, 
				PAPER_NO, 
				PAPER_NO_LENGTH,
               	CURRENT_POINT, 
                UP_WORKSTATION_ID, 
                UP_WORKSTATION_TIME
	FROM       	EZGI_MASTER_PLAN_SABLON
	WHERE     	(PROCESS_ID = #islem_id#)
</cfquery>
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr>
		<td height="35">
			<table border="0" width="99%" align="center">
				<tr>
					<td class="headbold" height="35"><cf_get_lang_main no='3349.Alt Plan Ekleme'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" height="95%" class="color-border">
				<tr>
				<cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_master_sub_plan">
					<input type="hidden" name="form_basket_submitted" value="1" />
                    <input type="hidden" name="islem_id" value="<cfoutput>#islem_id#</cfoutput>" />
                  	<input type="hidden" name="master_plan_id" value="<cfoutput>#attributes.master_plan_id#</cfoutput>">
					<td valign="top" height="50" class="color-row">
						<table>
							<tr>
								<td width="115" nowrap><cf_get_lang_main no='70.Aşama'></td>
								<td width="165"><cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'></td>
								<td width="100"><cf_get_lang_main no='243.Baslama Tarihi'>*</td>
								<td width="175" nowrap="nowrap">
                                	<cfsavecontent variable="message"><cf_get_lang_main no ='1333.Baslama Tarihi Girmelisiniz'> !</cfsavecontent>
                                    <input required="Yes"  message="#message#" type="text" name="master_alt_plan_start_date" id="master_alt_plan_start_date"  validate="eurodate" style="width:65px;" value="#dateformat(attributes.master_alt_plan_start_date,'DD/MM/YYYY')#" > 
                                   <cf_wrk_date_image date_field="master_alt_plan_start_date">
                                    <select name="master_alt_plan_start_h" id="master_alt_plan_start_h">
                                    <cfloop from="0" to="23" index="i">
                                        <option value="#i#" <cfif isdefined('attributes.master_alt_plan_start_date') and timeformat(attributes.master_alt_plan_start_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
                                <select name="master_alt_plan_start_m" id="master_alt_plan_start_m">
                                    <cfloop from="0" to="59" index="i">
                                        <option value="#i#" <cfif isdefined('attributes.master_alt_plan_start_date') and timeformat(attributes.master_alt_plan_start_date,'MM') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
								</td>
								<td width="80"><cf_get_lang_main no='1174.İşlemi Yapan'></td>
								<td width="160"><input type="hidden" name="expense_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
									<input type="text" name="expense_employee" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly="yes" style="width:140px;">
								</td>
								<td width="60"><cf_get_lang_main no='217.Açıklama'></td>
                                <td rowspan="4" nowrap valign="top">
                                    <textarea name="reference_no" maxlength="500" style="width:167;height:73;" 
									onkeydown="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" 
									onkeyup="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
                                </td>
							</tr>
							<tr>
								<td>Master Plan No </td>
								<td><input type="text" name="master_plan_number" readonly="readonly" value="<cfoutput>#get_master_plan.MASTER_PLAN_NUMBER#</cfoutput>"  maxlength="25" style="width:140px;"></td>
								<td><cf_get_lang_main no='288.Bitis Tarihi'>*</td>
								<td>
									<input type="hidden" name="_popup" value="2">
									<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
									<input required="Yes"  message="#message#" type="text" name="master_alt_plan_finish_date" id="master_alt_plan_finish_date"  validate="eurodate" style="width:65px;" value="#dateformat(attributes.master_alt_plan_finish_date,'DD/MM/YYYY')#" > 
                                   <cf_wrk_date_image date_field="master_alt_plan_finish_date">
                                    <select name="master_alt_plan_finish_h" id="master_alt_plan_finish_h">
                                    <cfloop from="0" to="23" index="i">
                                        <option value="#i#" <cfif isdefined('attributes.master_alt_plan_finish_date') and timeformat(attributes.master_alt_plan_finish_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
                                <select name="master_alt_plan_finish_m" id="master_alt_plan_finish_m">
                                    <cfloop from="0" to="59" index="i">
                                        <option value="#i#" <cfif isdefined('attributes.master_alt_plan_finish_date') and timeformat(attributes.master_alt_plan_finish_date,'MM') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                    </cfloop>
                                </select>
								</td>
								<td><cf_get_lang_main no='4.Proje'></td>
                                <td>
								<input type="hidden" name="project_id" value="#get_master_plan.MASTER_PLAN_PROJECT_ID#" />
								<input type="text" name="project_name" value="<cfif len(get_master_plan.MASTER_PLAN_PROJECT_ID)><cfoutput>#get_project_name(get_master_plan.MASTER_PLAN_PROJECT_ID)#</cfoutput></cfif>" readonly style="width:130px;"></td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='3350.Alt Üretim Plan No'></td>
								<td><cfoutput>
							<input name="paper_serious" type="text"  value="#Trim(get_paper_no.PAPER_SERIOUS)#" maxlength="1" style="width:25px;" />
							<input name="paper_number" type="text"    value="#get_paper_no.PAPER_NO#" maxlength="15" style="width:80px;" /></cfoutput>	</td>
								<td><cf_get_lang_main no='3351.Hedef İş Puanı'></td>
								<td><cfoutput><input name="work_point" type="text" value="#get_paper_no.CURRENT_POINT#" style="width:65px;" /></cfoutput></td>
                                <td></td>
								<td></td>
							</tr>
							<tr>
								<td ></td>
								<td ></td>
								<td></td>
								<td></td>
								<td colspan="2"></td>
								<td><input type="submit" name="is_submitted" onclick="kontrol_shift_tree_info()" value="<cf_get_lang_main no='3352.Alt Plan Oluştur'>"/> </td>
							</tr>
						</table>
					</td>
				</tr>
				</cfform>
				<tr>
					<td class="color-row" valign="top">
						<table cellspacing="1" cellpadding="2" width="100%" border="0" class="color-border">
							<tr class="color-header" height="22">
								<td class="txtboldblue" width="20" align="center">
                                <td class="form-title" width="70"><cf_get_lang_main no='1677.Emir No'></td>
                                <td class="form-title" width="80"><cf_get_lang_main no='799.Sipariş No'></td>
                               	<td class="form-title" width="80">Lot No</td>
                                <td class="form-title" width="100"><cf_get_lang_main no='106.Stok Kodu'></td>
                                <td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
                                <td class="form-title" width="65">Spec</td>
                                <td class="form-title" width="100"><cf_get_lang_main no='1422.İstasyon'></td> 
                               	<td class="form-title" width="75"><cf_get_lang_main no='1447.Süreç'></td>
                                <td class="form-title" width="90" align="center"><cfoutput>#getLang('stock',179)#</cfoutput></td>
                                <td class="form-title" width="80" align="center"><cfoutput>#getLang('stock',180)#</cfoutput></td>
                               	<td class="form-title" width="70" align="right"><cf_get_lang_main no='223.Miktar'></td>
                                <td class="form-title" width="50"><cf_get_lang_main no='224.Birim'></td>
							</tr>
							<tr valign="top" height="20" class="color-row">
								<td colspan="13" align="left"><cf_get_lang_main no='3353.Alt Plan Ekleyiniz'></td>
							</tr>
						</table>
					</td>				
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>
<script language="JavaScript">
function kontrol_shift_tree_info()
{
	if(document.getElementById('project_id').value == "")
	{
		alert("<cf_get_lang_main no ='1436.Önce Proje Seçiniz '> !");
		return false;
	}
	if(document.getElementById('shift_id').value == "")
	{
		alert("<cf_get_lang_main no='3354.Önce Master Plan Seçiniz'> !");
		return false;
	}
	if((document.getElementById('master_alt_plan_start_date').value != "") && (document.getElementById('master_alt_plan_finish_date').value != ""))
	return time_check(document.getElementById('master_alt_plan_start_date'), document.getElementById('master_alt_plan_start_h'), document.getElementById('master_alt_plan_start_m'), document.getElementById('master_alt_plan_finish_date'),  document.getElementById('master_alt_plan_finish_h'), document.getElementById('master_alt_plan_finish_m'), "<cf_get_lang_main no='3348.Başlama ve Bitiş Tarihlerini Kontrol Ediniz'> !");
	else
	{alert("<cf_get_lang_main no='3348.Başlama ve Bitiş Tarihlerini Kontrol Ediniz'>");return false;}
	return true;
}
</script>								
