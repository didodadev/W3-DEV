<cfquery name="GET_TARGET_CAT_ID" datasource="#DSN#">
    SELECT
        TARGETCAT_ID
    FROM
        TARGET
    WHERE
        TARGETCAT_ID=#TARGETCAT_ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td align="left" class="headbold"><cf_get_lang no='662.Hedef Kategorisi Güncelle'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_target_cat"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr class="color-row" valign="top">
        <td width="200"><cfinclude template="../display/list_target_cat.cfm"></td>
        <td>
            <table border="0">
                <cfform name="upd_target_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_target_cat_upd">
                	<input type="Hidden" ID="clicked" name="clicked" value="">
                    <cfquery name="CATEGORIES" datasource="#dsn#">
                    	SELECT 
        	                TARGETCAT_ID, 
                            TARGETCAT_NAME, 
                            DETAIL, 
                            TARGETCAT_WEIGHT, 
                            RECORD_DATE, 
                            RECORD_EMP, 
                            RECORD_IP, 
                            UPDATE_DATE, 
                            UPDATE_EMP, 
                            UPDATE_IP 
                        FROM 
    	                    TARGET_CAT 
                        WHERE 
	                        TARGETCAT_ID=#TARGETCAT_ID#
                    </cfquery>
                	<input type="Hidden" name="targetcat_id" id="targetcat_id" value="<cfoutput>#targetcat_id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang no='20.Kategori Adı'><font color=black>*</font></td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='1143.Kategori Adı girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="targetcat_name" size="10" value="#categories.targetcat_name#" maxlength="30" required="Yes" message="#message#" style="width:150px;">
                        </td>
                    </tr>
                    <tr>
                        <td width="100"><cf_get_lang no='1322.Kategori Ağırlığı'></td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no='1323.Kategori Ağırlığını girmelisiniz!'></cfsavecontent>
                            <cfinput type="text" name="targetcat_weight" value="#CATEGORIES.TARGETCAT_WEIGHT#" maxlength="5" validate="float" range="0,100" message="#message#" style="width:150px;">
                        </td>
                    </tr>
                    <tr>
                        <td width="100"><cf_get_lang_main no='217.Açıklama'></td>
                        <td>
                        	<textarea name="targetcat_detail" id="targetcat_detail" style="width:150px; height:70px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 250 "><cfoutput>#CATEGORIES.DETAIL#</cfoutput></textarea>
                        </td>
                    </tr>
                    <tr height="35">
                        <td colspan="2" align="right" style="text-align:right;">
                        <cfif get_target_cat_id.recordcount>
                        	<cf_workcube_buttons is_upd='1' is_delete='0'>
                        <cfelse>
                        	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_target_cat_del&targetcat_id=#targetcat_id#'>
                        </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left"><p><br/>
							<cfoutput>
								<cfif len(categories.record_emp)>
                                    <cf_get_lang_main no='71.Kayıt'> : #get_emp_info(categories.record_emp,0,0)# - #dateformat(categories.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(categories.update_emp)>
                                    <cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(categories.update_emp,0,0)# - #dateformat(categories.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
