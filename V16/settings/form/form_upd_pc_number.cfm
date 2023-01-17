<cfquery name="get_computer" datasource="#dsn#">
SELECT 
	UNIT_ID,
	UNIT_NAME,
	UNIT_DESC,
	RECORD_DATE,
	RECORD_EMP,
	UPDATE_DATE,
	UPDATE_EMP
FROM 
	SETUP_PC_NUMBER
WHERE 
	UNIT_ID=#attributes.u_id#
</cfquery>
<cfquery name="get_pcs" datasource="#dsn#">
SELECT UNIT_ID, UNIT_NAME FROM SETUP_PC_NUMBER ORDER BY UNIT_ID
</cfquery>
<cfquery name="get_net_conn" datasource="#dsn#">
SELECT CONNECTION_ID, CONNECTION_NAME FROM SETUP_NET_CONNECTION ORDER BY CONNECTION_ID DESC 
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="37">
  <tr>
    <td height="37" class="headbold"><cf_get_lang no='915.Bilgisayar Sayısı'></td>
	<td width="80" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_pc_number"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
  </tr>
</table>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <tr>
          <td class="color-row" width="200" valign="top"><cfinclude template="../display/list_pc.cfm"></td>
          <td class="color-row" valign="top">
            <cfform  name="add_task" action="#request.self#?fuseaction=settings.emptypopup_upd_pc_number&u_id=#attributes.u_id#" method="post">
              <table>
                <tr>
				<td width="110"><cf_get_lang no='915.Bilgisayar Sayısı'>*</td>    
				<td>
				<cfsavecontent variable="message"><cf_get_lang no ='1141.Bilgisayar Sayısı Giriniz'>!</cfsavecontent>
				<cfinput name="unit_name" type="text" value="#get_computer.unit_name#" maxlength="50" required="yes" message="#message#" style="width=175;"></td>
                </tr>
				<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="unit_desc" id="unit_desc" style="width:175;height:40;" maxlength="50" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 50"><cfoutput>#get_computer.unit_desc#</cfoutput></textarea></td>
				</tr>
                <tr>
                  <td>&nbsp;</td><td><cf_workcube_buttons is_upd='0'></td>
			    </tr>
				<tr>
				  <td colspan="3"><p><br/>
					<cfoutput>
					<cfif len(get_computer.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_computer.record_emp,0,0)# - #dateformat(get_computer.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(get_computer.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_computer.update_emp,0,0)# - #dateformat(get_computer.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				  </td>
				</tr>
              </table>
            </cfform>
          </td>
        </tr>
      </table>
