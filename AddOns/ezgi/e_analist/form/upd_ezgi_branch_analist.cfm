<cfsetting showdebugoutput="yes">
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
<cfquery name="get_upd" datasource="#dsn3#">
	SELECT * FROM EZGI_ANALYST_BRANCH WHERE ANALYST_BRANCH_ID = #attributes.upd_id#
</cfquery>
<cfinclude template="../query/get_ezgi_branch_gelirler.cfm">
<cfinclude template="../query/get_ezgi_branch_giderler.cfm">
<cfinclude template="../query/get_ezgi_branch_sonuc.cfm">
<cfif len(get_TOTAL.SMM)>
 	<cfset total_smm = get_TOTAL.SMM>
<cfelse>
 	<cfset total_smm = 0>
</cfif>
<cfif len(GET_TOTAL_EXPENSE.GIDER)>
 	<cfset expense_gider = GET_TOTAL_EXPENSE.GIDER>
<cfelse>
	<cfset expense_gider = 0>
</cfif>
<cfif len(GET_TOTAL.TOTAL_SALES)>
        	<cfset net_total = GET_TOTAL.TOTAL_SALES>
        <cfelse>
        	<cfset net_total = 0>
        </cfif>
<cfset attributes.is_branch = get_upd.is_branch>
<cfset attributes.detail = get_upd.detail>
<cfset attributes.analyst_status = get_upd.status>
<cfset attributes.start_date = get_upd.date>
<cfset attributes.branch_id = get_upd.branch_id>
<cfset attributes.price_cat_id = get_upd.PRICE_CATID>
<cfset attributes.rate = get_upd.rate>
<cfset attributes.year_value = get_upd.year_value>
<cfset attributes.month_value = get_upd.month_value>
<cfset attributes.record_employee_id = get_upd.employee_id>
<cfset attributes.record_employee = get_emp_info(get_upd.employee_id,0,0)>
<cfset attributes.process_stage = get_upd.PROCESS_STAGE>
<table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td height="35" class="headbold"><cfoutput>#getLang('member',190)#</cfoutput></td>
        <td width="30px" style="text-align:right">
        	<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.</cfoutput>list_ezgi_branch_analist">
            	<img src="/images/refer.gif" title="<cf_get_lang_main no='3604.Şube Aylık Analiz'>"> 
           	</a>
        	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=report.popup_add_ezgi_branch_analist_cost&upd_id=#attributes.upd_id#</cfoutput>','list');">
            	<img src="/images/money_plan.gif" title="<cfoutput>#getLang('cash',189)#</cfoutput>">
            </a>
        	<a style="cursor:pointer" onclick="input_control(<cfoutput>#get_upd.STATUS#</cfoutput>);">
				<cfif get_upd.STATUS eq 0>
                    <img src="/images/lock_open.gif" title="<cf_get_lang_main no='2068.Tamamlanmadı'>">
                <cfelse>
                    <img src="/images/lock_buton.gif" title="<cf_get_lang_main no='1374.Tamamlandı'>">
                </cfif>
            </a>
        	<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.</cfoutput>add_ezgi_branch_analist">
            	<img src="/images/plus_list.gif" title="<cf_get_lang_main no='3200.İşlem Tipi Ekle'>"> 
           	</a>
      	</td>
	</tr>
	<cfoutput>
		<tr>
			<td style="vertical-align:top">
				<cfform name="upd_branch_analist" method="post" action="#request.self#?fuseaction=report.emptypopup_upd_ezgi_branch_analist">
                	<cfinput type="hidden" value="#attributes.upd_id#" name="upd_id">
                    <table width="98%" height="99%" cellpadding="2" cellspacing="1" class="color-border" align="center">
                        <tr>
                        	<td valign="top" class="color-row">
                            	<table>
                                	<tr>
                                        <td valign="top">&nbsp;</td>
                                        <td valign="top" width="110px">
                                            <select name="is_branch" id="is_branch" style="width:95px; height:20px">
                                                <option value="1" <cfif attributes.is_branch eq 1>selected</cfif>><cf_get_lang_main no='41.Sube'></option>
                                                <option value="0" <cfif attributes.is_branch eq 0>selected</cfif>><cf_get_lang_main no='1161.Merkez'></option>
                                            </select>
                                        </td>
                                        <td valign="top" width="25px"><cf_get_lang_main no='1043.Yıl'></td>
                                        <td valign="top" width="80px">
                                            <select name="year_value" id="year_value" style="width:65px; height:20px">
                                                <cfloop query="get_period">
                                                    <option value="#PERIOD_YEAR#" <cfif attributes.year_value eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
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
                                        <td valign="top" width="160px">
                                            <cf_workcube_process is_upd='0' select_value='#attributes.process_stage#' process_cat_width='125' is_detail='1'>
                                        </td>
                                        <td rowspan="2" valign="top" width="60px"><cf_get_lang_main no='217.Açiklama'></td>
                                        <td rowspan="2" width="210px"><textarea name="detail" id="detail" style="width:200px;height:50px;"><cfif len(attributes.detail)>#attributes.detail#</cfif></textarea>
                                        </td>	
                                    </tr>
                                    <tr>
                                        <td ></td>
                                        <td ><cf_get_lang_main no='3361.Katsayı'>*
                                            <cfinput type="text" name="rate" id="rate" maxlength="5" style="width:50px;" value="#TlFormat(attributes.rate,2)#">
                                        </td>
                                        <td valign="top" width="50px"><cf_get_lang_main no='1312.Ay'></td>
                                        <td valign="top" width="80px">
                                            <select name="month_value" id="month_value" style="width:65px; height:20px">
                                                <option value="1" <cfif attributes.month_value eq 1>selected</cfif>><cf_get_lang_main no='180.Ocak'></option>
                                                <option value="2" <cfif attributes.month_value eq 2>selected</cfif>><cf_get_lang_main no='181.Şubat'></option>
                                                <option value="3" <cfif attributes.month_value eq 3>selected</cfif>><cf_get_lang_main no='182.Mart'></option>
                                                <option value="4" <cfif attributes.month_value eq 4>selected</cfif>><cf_get_lang_main no='183.Nisan'></option>
                                                <option value="5" <cfif attributes.month_value eq 5>selected</cfif>><cf_get_lang_main no='184.Mayıs'></option>
                                                <option value="6" <cfif attributes.month_value eq 6>selected</cfif>><cf_get_lang_main no='185.Haziran'></option>
                                                <option value="7" <cfif attributes.month_value eq 7>selected</cfif>><cf_get_lang_main no='186.Temmuz'></option>
                                                <option value="8" <cfif attributes.month_value eq 8>selected</cfif>><cf_get_lang_main no='187.Ağustos'></option>
                                                <option value="9" <cfif attributes.month_value eq 9>selected</cfif>><cf_get_lang_main no='188.Eylül'></option>
                                                <option value="10" <cfif attributes.month_value eq 10>selected</cfif>><cf_get_lang_main no='189.Ekim'></option>
                                                <option value="11" <cfif attributes.month_value eq 11>selected</cfif>><cf_get_lang_main no='190.Kasım'></option>
                                                <option value="12" <cfif attributes.month_value eq 12>selected</cfif>><cf_get_lang_main no='191.Aralık'></option>
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
                                        <td valign="top" ><cf_get_lang_main no='487.Kaydeden'>*</td>
                                        <td valign="top" >
                                            <input type="hidden" name="record_employee_id" id="record_employee_id" value="#attributes.record_employee_id#">
                                            <input type="text" name="record_employee" id="record_employee" value="#attributes.record_employee#" style="width:150px;" onFocus="AutoComplete_Create('record_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_employee_id','','3','125');" autocomplete="off">
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=record_employee_id&field_name=record_employee&select_list=1','list','popup_list_positions');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                    	<td colspan="9"></td>
                                    	<td align="left" valign="top">
											<cfif get_upd.STATUS eq 0>
                                            	<cf_workcube_buttons 
                                                	is_upd='1' 
                                                    add_function ='input_control(2)'
                                                    delete_page_url='#request.self#?fuseaction=report.emptypopup_del_ezgi_branch_analist&upd=#attributes.upd_id#'
                                              	>
                                            </cfif>
                                        </td>
                                    </tr>
                             	</table>
                         	</td>
                       	</tr>
                        <tr>
                        	<td bgcolor="##FFFFFF">&nbsp;</td>
                      	</tr>
                    	<tr class="color-row" height="80%">
                          	<td valign="top">
                               	<table  width="100%" height="99%" cellpadding="2" cellspacing="1"  align="center">
                                 	<tr>
                                     	<td>
                                         	<cfsavecontent variable="message"><font color="black">Gelirler</font></cfsavecontent>
                                           		<cf_show_ajax page_style="off" table_align="left" title="#message#" tr_id="upd_id_1" page_url="#request.self#?fuseaction=report.ajax_ezgi_analyst_gelirler&upd_id=#attributes.upd_id#">
                                     	</td>
                              		</tr>
                             	</table>	
                         	</td>
                    	</tr>
                      	<tr>
                        	<td bgcolor="##FFFFFF">&nbsp;</td>
                      	</tr>
                    	<tr class="color-row" height="80%">
                          	<td valign="top">
                               	<table  width="100%" height="99%" cellpadding="2" cellspacing="1"  align="center">
                                 	<tr>
                                     	<td>
                                         	<cfsavecontent variable="message"><font color="black">Giderler</font></cfsavecontent>
                                           		<cf_show_ajax page_style="off" table_align="left" title="#message#" tr_id="upd_id_2" page_url="#request.self#?fuseaction=report.ajax_ezgi_analyst_giderler&upd_id=#attributes.upd_id#">
                                     	</td>
                              		</tr>
                             	</table>	
                         	</td>
                    	</tr>
                    	<tr>
                        	<td bgcolor="##FFFFFF">&nbsp;</td>
                      	</tr>
                    	<tr class="color-row" height="80%">
                          	<td valign="top">
                               	<table  width="100%" height="99%" cellpadding="2" cellspacing="1"  align="center">
                                 	<tr>
                                     	<td>
                                         	<cfsavecontent variable="message"><font color="black">Sonuç</font></cfsavecontent>
                                           		<cf_show_ajax page_style="on" table_align="left" title="#message#" tr_id="upd_id_3" page_url="#request.self#?fuseaction=report.ajax_ezgi_analyst_sonuc&upd_id=#attributes.upd_id#">
                                     	</td>
                              		</tr>
                             	</table>	
                         	</td>
                    	</tr>
                    </table>
				</cfform>
			</td>
        	<td width="230" valign="top">
              <!--- Varliklar --->
              <cf_get_workcube_asset asset_cat_id="-3" module_id='35' action_section='PRODUCT_TREE' action_id='#attributes.upd_id#'><br>
              <!--- Notlar --->
              <cf_get_workcube_note  company_id="#session.ep.company_id#" action_section='upd_id' action_id='#attributes.upd_id#'><br>
              <!---Planlama Oranı--->
              <cfinclude template="dsp_ezgi_analyst_branch_graph.cfm" ><br>
        	</td>
		</tr>
	</table>
	<script language="JavaScript">
        function input_control(status)
        {
                if(document.getElementById('record_employee').value == "")
                {
                    alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='487.Kaydeden'>!");
                    document.getElementById('record_employee').focus();
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
                
            if(status==1)
            {
                sor=confirm('Belgenin Kilidi Açılacaktır?');
                if (sor == true)
                {
                    document.getElementById("upd_branch_analist").action = "<cfoutput>#request.self#</cfoutput>?fuseaction=report.emptypopup_upd_ezgi_branch_analist&status=0";
                    document.getElementById("upd_branch_analist").submit();
                }
                else
                return false;
            }
            else if(status==0)
            {
                sor=confirm('Belge Kilitlenecektir?');
                if (sor == true)
                {
                    document.getElementById("upd_branch_analist").action = "<cfoutput>#request.self#</cfoutput>?fuseaction=report.emptypopup_upd_ezgi_branch_analist&status=1";
                    document.getElementById("upd_branch_analist").submit();
                }
                else
                return false;
            }
        }
    </script>
</cfoutput>