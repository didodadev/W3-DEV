<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#,#merkez_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = bugun_>
</cfif>
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.in_department_id" default="">
<cf_form_box title="Şube Stok Taşıma">
	<cfform action="" method="post" name="search_cash">
    <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <table>
            <tr>
            	<td>Aktarım Günü</td>
                <td nowrap>
                    <cfinput type="text" name="search_startdate" maxlength="10" value="#dateformat(attributes.search_startdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" message="Tarih Hatalı!">
                    <cf_wrk_date_image date_field="search_startdate">
                </td>
            </tr>
            <tr>
                <td>Aktarım Şube</td>
                <td>
                	<cfselect name="department_id" style="width:200px;">
                    	<option value="">Aktarım Şube Seçiniz</option>
                        <cfoutput query="get_departments_search">
                        	<option value="#department_id#" <cfif attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
                        </cfoutput>
                    </cfselect>
                </td>
           </tr>
           <tr>
                <td>Aktarılacak Şube</td>
                <td>                                
                     <cfselect name="in_department_id" style="width:200px;">
                    	<option value="">Aktarılacak Şube Seçiniz</option>
                        <cfoutput query="get_departments_search">
                        	<option value="#department_id#" <cfif attributes.in_department_id eq department_id>selected</cfif>>#department_head#</option>
                        </cfoutput>
                    </cfselect>
                </td>
            </tr>
            <tr> 
            	<td colspan="2"><cf_workcube_buttons insert_info="Aktarımı Başlat" insert_alert="Şube Stok Taşıma İşlemi Yapıyorsunuz! Emin misiniz?" add_function="input_kontrol()"></td>         		
       		</tr>
            </table>
    </cfform>
</cf_form_box>
<script>
function input_kontrol()
{
	deger_on = document.getElementById('department_id').value;
	if(deger_on == '')
	{
		alert('Aktarım Yapılacak Şube Seçmelisiniz!');
		return false;
	}
	
	deger_ic = document.getElementById('in_department_id').value;
	if(deger_ic == '')
	{
		alert('Aktarılacak Şube Seçmelisiniz!');
		return false;
	}
	
	deger_t = document.getElementById('search_startdate').value;
	if(deger_t == '')
	{
		alert('Aktarılacak Tarih Seçmelisiniz!');
		return false;
	}
	
	if(deger_on == deger_ic)
	{
		alert('Aynı Şubeye Aktarım Yapamazsınız!');	
		return false;
	}
	return true;
}
</script>