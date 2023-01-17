<cfquery name="get_workstation" datasource="#dsn3#">
	SELECT 
    	WP.WS_P_ID,
    	WP.WS_ID, 
        WP.DEFAULT_STATUS, 
        WORKSTATIONS.STATION_ID,
        WORKSTATIONS.STATION_NAME, 
        WORKSTATIONS.EMPLOYEE_NUMBER, 
        WORKSTATIONS.EZGI_SETUP_TIME, 
        WORKSTATIONS.EZGI_KATSAYI
	FROM            
    	WORKSTATIONS_PRODUCTS AS WP INNER JOIN
      	WORKSTATIONS ON WP.WS_ID = WORKSTATIONS.STATION_ID
	WHERE        
    	WP.OPERATION_TYPE_ID = #attributes.operation_type_id#
 	ORDER BY
    	WP.DEFAULT_STATUS DESC
</cfquery>
<cfset station_id_list = ValueList(get_workstation.STATION_ID)>
<cfquery name="get_operation" datasource="#dsn3#">
	SELECT        
    	OPERATION_TYPE, 
        O_MINUTE, 
        OPERATION_CODE, 
        OPERATION_STATUS, 
        EZGI_H_SURE, 
        EZGI_FORMUL
	FROM            
    	OPERATION_TYPES
	WHERE        
    	OPERATION_TYPE_ID = #attributes.operation_type_id#
</cfquery>
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='3426.Operasyon Bilgisi Güncelle'></td>
        <td class="dphb">
        	<cfoutput>

            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<cfform name="upd_operation" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_iflow_operation_rate">
    <table class="dpm" align="center">
        <tr>
            <td valign="top" class="dpml">
                <cf_form_box>	
                	<cfinput type="hidden" name="operation_type_id" value="#attributes.operation_type_id#">
                    <cfif isdefined('attributes.e_design')>
                    	<cfinput type="hidden" name="e_design" value="#attributes.e_design#">
                    <cfelse>
                    	<cfinput type="hidden" name="master_plan_id" value="#attributes.master_plan_id#">
                    </cfif>
                    <cfinput type="hidden" name="station_id_list" value="#station_id_list#">
                    <cfoutput>
                	 <table>
                     	<tr height="25px"  id="operation_code_">
                            <td valign="top" style="font-weight:bold"><cfoutput>#getLang('prod',64)#</cfoutput> </td>
                            <td valign="top">:&nbsp;
                            	<cfinput name="operation_code" readonly="yes" type="text" id="operation_code" style="width:50px; text-align:right" value="#get_operation.operation_code#">
                            </td>
                      	</tr>
                        <tr height="25px"  id="operation_name_">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='3240.Operasyon Adı'> </td>
                            <td valign="top">:&nbsp;
                            	<cfinput name="operation_type" readonly="yes" type="text" id="operation_type" style="width:300px" value="#get_operation.operation_type#">
                            </td>
                      	</tr>
                        <tr height="25px"  id="operation_time_">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='280.İşlem'>/<cf_get_lang_main no='3355.Hazırlık Süresi'></td>
                            <td valign="top">:&nbsp;
                            	<cfinput name="ezgi_i_sure" type="text" id="ezgi_i_sure" style="width:50px; text-align:right" value="#get_operation.O_MINUTE#"> / 
                                <cfinput name="ezgi_h_sure" type="text" id="ezgi_h_sure" style="width:50px; text-align:right" value="#get_operation.EZGI_H_SURE#">
                            </td>
                      	</tr>
                        <tr height="25px"  id="operation_rate_">
                            <td valign="top" style="font-weight:bold"><cf_get_lang_main no='616.Formül'></td>
                            <td valign="top">:&nbsp;
                            	<cfinput name="formul" type="text" id="formul" style="width:300px" value="#get_operation.EZGI_FORMUL#">
                            </td>
                      	</tr>
                    </table>
                    </cfoutput>
                    <br />
                    <table style="width:100%">
                    	<tr>
                            <td style=" text-align:right; width:100%">
                            	<cfinput type="button" name="vazgec" id="vazgec" value="#getLang('main',50)#" onClick="window.close();">
                    			<cfinput type="submit" name="kayit" id="kayit" value="#getLang('main',52)#" onClick="kontrol();">
                            </td>
                     	</tr>
                    </table>
              	</cf_form_box>
                <cf_seperator title="#getLang('main',3472)#" id="thickness_" is_closed="0">
                <div id="thickness_" style="width:100%">
                    <cf_form_list id="table2">
                        <thead style="width:100%">
                            <tr height="20px">
                                <th style="text-align:center; width:25px" ><cf_get_lang_main no='1165.Sıra'></th>
                                <th style="text-align:center; width:250px">&nbsp;<cfoutput>#getLang('prod',356)#</cfoutput></th>
                                <th style="text-align:center; width:50px" >&nbsp;<cf_get_lang_main no='164.Çalışan'></th>
                                <th style="text-align:center; width:70px">&nbsp;Setup </th>
                                <th style="text-align:center; width:70px">&nbsp;<cf_get_lang_main no='3361.Katsayı'> </th>
                                <th style="text-align:center; width:40px">&nbsp;Default</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfif get_workstation.recordcount>
                                <cfoutput query="get_workstation">
                                    <tr>
                                        <td style="width:30px; height:20px; text-align:right; vertical-align:middle">#currentrow#&nbsp;</td>
                                        <td style="text-align:left; vertical-align:middle">#STATION_NAME#&nbsp;</td>
                                        <td style="text-align:center; vertical-align:middle">
                                        	<cfinput name="employee_number#station_id#" type="text" id="employee_number#station_id#" style="width:45px" value="#EMPLOYEE_NUMBER#" class="box">&nbsp;
                                        
                                        </td>
                                        <td style="text-align:center; vertical-align:middle">
                                        	<cfinput name="ezgi_setup_time#station_id#" type="text" id="ezgi_setup_time#station_id#" style="width:65px" value="#EZGI_SETUP_TIME#" class="box">&nbsp;
                                        </td>
                                        <td style="text-align:center; vertical-align:middle">
                                        	<cfinput name="ezgi_katsayi#station_id#" type="text" id="ezgi_katsayi#station_id#" style="width:65px" value="#TlFormat(EZGI_KATSAYI,1)#" class="box">&nbsp;
                                       	</td>
                                        <td style="text-align:center; vertical-align:middle">
                                        	<input name="default_status#station_id#" type="checkbox" id="default_status#station_id#" value="#WS_P_ID#" <cfif DEFAULT_STATUS eq 1>checked</cfif>>&nbsp;
                                        </td>
                                    </tr>
                                </cfoutput>
                            </cfif>
                        </tbody>
                    </cf_form_list>
                </div>
            </td>
        </tr>
    </table>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById("ezgi_i_sure").value <= 0)
		{
			alert("<cf_get_lang_main no='3427.İşlem Süresi 0 dan büyük olmalıdır.'> !");
			document.getElementById('ezgi_i_sure').focus();
			return false;
		}
		if(document.getElementById("ezgi_h_sure").value <= 0)
		{
			alert("<cf_get_lang_main no='3428.Hazırlık Süresi 0 dan büyük olmalıdır.'> !");
			document.getElementById('ezgi_h_sure').focus();
			return false;
		}
		sor=confirm('<cf_get_lang_main no='124.Güncellemek İstediğinizden Emin misiniz?'>')
		if(sor==false)
			return false;
	}
</script>