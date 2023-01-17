<cfparam name="attributes.detail" default="">
<cfparam name="attributes.analyst_status" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.rate" default="20">
<cfparam name="attributes.start_date" default="">
<cfsetting showdebugoutput="yes">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = wrk_get_today()>
</cfif>
<cfquery name="get_period" datasource="#dsn#">
	SELECT        
    	TOP (5) PERIOD_YEAR
	FROM            
    	SETUP_PERIOD
	WHERE        
    	OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY 
    	PERIOD_YEAR DESC
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_price_cat" datasource="#dsn3#">
	SELECT PRICE_CATID, BRANCH, PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND IS_SALES = 1
</cfquery>
<table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td height="35" class="headbold"><cfoutput>#getLang('member',190)#</cfoutput></td>
	</tr>
</table>
<cfoutput>
	<table width="98%" height="92%" cellpadding="2" cellspacing="1" class="color-border" align="center">
		<tr>
			<td valign="top" class="color-row">
				<cfform name="add_branch_analist" method="post" action="#request.self#?fuseaction=report.emptypopup_add_ezgi_branch_analist">
                    <table>
                        <tr height="15">
                            <td valign="top">&nbsp;</td>
                            <td valign="top" width="110px">
                            	<select name="is_branch" id="is_branch" style="width:95px; height:20px">
                                	<option value="1"><cf_get_lang_main no='41.Sube'></option>
                                    <option value="0"><cf_get_lang_main no='1161.Merkez'></option>
                                </select>
                            </td>
                            <td valign="top" width="25px"><cf_get_lang_main no='1043.Yıl'></td>
                            <td valign="top" width="80px">
                            	<select name="year_value" id="year_value" style="width:65px; height:20px">
                                    <cfloop query="get_period">
                                        <option value="#PERIOD_YEAR#">#PERIOD_YEAR#</option>
                                    </cfloop>
                                </select>
                            </td>
                            <td valign="top" width="60px"><cf_get_lang_main no='41.Sube'>*</td>
                            <td valign="top" width="110px">
                             	<select name="branch_id" id="branch_id" style="width:80px;height:20px">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfloop query="get_branch">
                                        <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and branch_id eq attributes.branch_id>selected</cfif>>#branch_name#</option>
                                    </cfloop>
                                </select> 
                           	</td>
                            <td valign="top" width="90px"><cf_get_lang_main no='642.Süreç/Asama'></td>
                            <td valign="top" width="160px"><cf_workcube_process is_upd='0' process_cat_width='125' is_detail='0'></td>
                            <td rowspan="2" valign="top" width="60px"><cf_get_lang_main no='217.Açiklama'></td>
                            <td rowspan="2" width="210px"><textarea name="detail" id="detail" style="width:200px;height:50px;"><cfif isdefined("attributes.order_row_id")>#get_amount.order_detail#</cfif></textarea>
                            </td>	
                            <td rowspan="2"  align="left" valign="top"><cf_workcube_buttons is_upd='0' add_function ='input_control()'></td>
                        </tr>
                        <tr>
                        	<td ></td>
                            <td >
                            	<cf_get_lang_main no='3361.Katsayı'>*
                            	<cfinput type="text" name="rate" id="rate" maxlength="5" style="width:50px; text-align:right" value="#TlFormat(attributes.rate,2)#">
                            </td>
                            <td valign="top" width="50px"><cf_get_lang_main no='1312.Ay'></td>
                            <td valign="top" width="80px">
                            	<select name="month_value" id="month_value" style="width:65px; height:20px">
                                	<option value="1"><cf_get_lang_main no='180.Ocak'></option>
                                	<option value="2"><cf_get_lang_main no='181.Şubat'></option>
                                    <option value="3"><cf_get_lang_main no='182.Mart'></option>
                                    <option value="4"><cf_get_lang_main no='183.Nisan'></option>
                                    <option value="5"><cf_get_lang_main no='184.Mayıs'></option>
                                    <option value="6"><cf_get_lang_main no='185.Haziran'></option>
                                    <option value="7"><cf_get_lang_main no='186.Temmuz'></option>
                                    <option value="8"><cf_get_lang_main no='187.Ağustos'></option>
                                    <option value="9"><cf_get_lang_main no='188.Eylül'></option>
                                    <option value="10"><cf_get_lang_main no='189.Ekim'></option>
                                    <option value="11"><cf_get_lang_main no='190.Kasım'></option>
                                    <option value="12"><cf_get_lang_main no='191.Aralık'></option>
                                </select>
                            
                            </td>
                            <td ><cf_get_lang_main no='330.Tarih'>*</td>
                            <td >
                            	<cfif session.ep.our_company_info.unconditional_list>
                                    <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:65px;">
                                <cfelse>
                                    <cfsavecontent variable="message"><cf_get_lang_main no='2325.Başlangıç Tarihini Kontrol Ediniz'></cfsavecontent>
                                    <cfinput type="text" name="start_date"  value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                                </cfif>
                                <cf_wrk_date_image date_field="start_date">
                            </td>
                           	<td valign="top" width="60px"><cf_get_lang_main no='487.Kaydeden'>*</td>
                            <td valign="top" width="195px"><input type="hidden" name="record_employee_id" id="record_employee_id" value="">
                                <input type="text" name="shift_employee" id="shift_employee" value="" style="width:125px;" onFocus="AutoComplete_Create('shift_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_employee_id','','3','125');" autocomplete="off">
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=record_employee_id&field_name=shift_employee&select_list=1','list','popup_list_positions');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                            </td>
                            <td colspan="2"></td>
                        </tr>
                    </table>
				</cfform>
			</td>
		</tr>
		<tr class="color-row" height="80%">
			<td valign="top"><div id="SHIFT_TREE"></div></td>
		</tr>
	</table>
<script language="JavaScript">
	function input_control()
	{
		if(document.getElementById('shift_employee').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='487.Kaydeden'>!");
			document.getElementById('shift_employee').focus();
			return false;
		}
		if(document.getElementById('branch_id').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='41.Sube'>!");
			document.getElementById('branch_id').focus();
			return false;
		}
		if(document.getElementById('start_date').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='330.Tarih'>!");
			document.getElementById('start_date').focus();
			return false;
		}
		if(document.getElementById('rate').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='3361.Katsayı'>!");
			document.getElementById('rate').focus();
			return false;
		}
	}
</script>
</cfoutput>