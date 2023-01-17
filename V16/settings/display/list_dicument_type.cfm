<cfquery name="get_company_list" datasource="#dsn#">
	SELECT 
        COMP_ID, 
        COMPANY_NAME
    FROM 
    	OUR_COMPANY
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td height="35" class="headbold"><cf_get_lang no='882.Şirket Akış Parametreleri'></td>
    </tr>
    <tr>
        <td class="color-border">
            <table cellspacing="1" cellpadding="2" border="0" align="center" width="100%"> 
            <tr class="color-header" height="22">
                <td class="form-title" width="45"><cf_get_lang_main no='75.No'></td>
                <td class="form-title"><cf_get_lang_main no='162.Şirket'> </td>
                <cfoutput query="get_company_list">
                    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">             
                        <td>#COMP_ID#</td>
                        <td><a href="javascript://" onclick= "windowopen('#request.self#?fuseaction=settings.popup_form_upd_our_company_info&ourcompany_id=#COMP_ID#', 'medium')";) class="tableyazi">#COMPANY_NAME#</a></td>
                    </tr>
                </cfoutput>
            </table>
        </td>
    </tr> 
</table>
