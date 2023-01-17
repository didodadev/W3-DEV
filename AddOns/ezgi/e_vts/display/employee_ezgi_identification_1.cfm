<cfparam name="attributes.deliver_code" default="">
<cfquery name="get_deliver_code" datasource="#dsn3#">
    SELECT         
    	VTS_EMP_ID, 
        EMP_ID, 
        PAROLA
	FROM           
    	EZGI_VTS_IDENTY
</cfquery>
<cfset deliver_code_list = Valuelist(get_deliver_code.PAROLA)>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr>
		<td height="35">
			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td height="35" class="headbold"><a href="javascript:gizle_goster(add_fis_process);">&raquo;</a><cf_get_lang_main no='3096.Personel Tanıma'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
            <table cellspacing="1" cellpadding="2" border="0" width="98%" align="center" height="100%">
                <cfform name="form_basket" method="post" action="#request.self#?fuseaction=production.popup_dsp_employee_ezgi_identification" >
                <input type="hidden" name="is_form" value="1">
                <tr class="color-border">
                    <td style="width:100%; height:100%; vertical-align:middle">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
                            <tr class="color-row" id="add_fis_process">
                                <td style="text-align:center; vertical-align:middle">
                                    <cfoutput>
                                    <table  width="100%" >
                                      	<tr>
                                            <td style="font-size:18px; width:100%; height:35px; text-align:center"><cf_get_lang_main no='3097.Kartınızı Okutun'>  &nbsp;&nbsp;
                                            	<input type="password" name="deliver_code" value="" required="yes" id="deliver_code" maxlength="10" title="<cf_get_lang_main no='3098.Sadece Personel Kartları Geçerlidir'>" style="width:300px; font-size:25px; vertical-align:middle; height:30px" onKeyDown="if(event.keyCode == 13) {return input_control(this.value);}">&nbsp;
                                                <input type="submit" name="button" id="button" value="#getLang('objects2',1135)#" style="height:30px;width:90px; vertical-align:middle" />
                                           	</td>
                                       	</tr>
                              		</table>
                              		</cfoutput>
								</td>
                         	</tr>
                    	</table>
                  	</td>
              	</tr>
           	</cfform>
            </table>
     	</td>
   	</tr>
</table>
<script language="javascript">
document.form_basket.deliver_code.focus();
function input_control(deliver_code)
{
	if(list_find('<cfoutput>#deliver_code_list#</cfoutput>',deliver_code,','))
	{
		return true;
	}
	else
	{
		alert('<cf_get_lang_main no='3099.Kartınız Yetkili Değil'> - <cf_get_lang_main no='3100.İnsan Kaynaklarına Başvurunuz'>!');
		return false;
	}
}
</script>
