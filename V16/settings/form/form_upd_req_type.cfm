<!-- Hakan-->
<cfquery name="get_reqs" datasource="#dsn#"> 
	SELECT 
    	REQ_ID, 
        REQ_NAME, 
        REQ_DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP,
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_REQ_TYPE 
    WHERE 
    	REQ_ID = #attributes.req_id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang_main no='1297.Yetkinlikler'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_req_type"><img src="/images/plus1.gif" border="0" align="absmiddle" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr class="color-row" valign="top">
        <td width="220"><cfinclude template="../display/list_req_type.cfm"></td>
        <td>
            <cfform name="content_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_req_type_upd">
            <input name="req_id" id="req_id" type="hidden" value="<cfoutput>#get_reqs.REQ_ID#</cfoutput>">
                <table border="0">
                    <tr>
                        <td width="60"><cf_get_lang_main no='1297.Yetkinlikler'> *</td>
                        <td><cfsavecontent variable="message"><cf_get_lang no='1163.Yetkinlik girişi yapmalısınız'>!</cfsavecontent>
                        <cfinput type="Text" name="req_name" style="width:150px;" value="#trim(get_reqs.REQ_NAME)#" maxlength="50" required="Yes" message="#message#"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='217.Açıklama'></td>
                        <td>
                        	<textarea name="req_detail" id="req_detail" style="width:150px; height:60px" maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı :200"><cfoutput>#trim(get_reqs.REQ_DETAIL)#</cfoutput></textarea>				  
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td height="35"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cf_get_lang_main no='71.Kayıt'> :
                            <cfoutput>
								<cfif len(get_reqs.record_emp)>#get_emp_info(get_reqs.record_emp,0,0)#</cfif>
                                <cfif len(get_reqs.record_date)>- #dateformat(get_reqs.record_date,dateformat_style)#</cfif>
                                <cfif len(get_reqs.update_date)>
                                    <br/>
                                    <cf_get_lang_main no='479.Güncelleyen'> :
                                    #get_emp_info(get_reqs.update_emp,0,0)#
                                    - #dateformat(get_reqs.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>			
                        </td>
                    </tr>
                </table>
            </cfform>
        </td>
    </tr>
</table>
<br/>
<script type="text/javascript">
function kontrol()
{
	x = (200 - document.content_cat.req_detail.value.length);
	if ( x < 0 )
	{ 
		alert ("Açıklama"+ ((-1) * x) + "Karakter Uzun");
		return false;
	}
}

</script>
