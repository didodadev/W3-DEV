<cfinclude template="../query/get_control.cfm">
<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='97.Çek Ekle'></td>
  </tr>
  <tr class="color-border">
    <td valign="top">
      <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="2">
        <td class="color-row" valign="top"> 
		<br/>
            <cfform name="add_cheque_entry" action="#request.self#?fuseaction=cheque.popup_add_cheque_exp" method="post" onsubmit="return(unformat_fields());">
              <table>
              <tr>
			  	<td><cf_get_lang no='2.Durum'></td>
				<td><cf_get_lang_main no='330.Tarih'></td>
				<td><cf_get_lang_main no='162.Firma'></td>
				<td><cf_get_lang no='25.Çek No'></td>
				<td><cf_get_lang_main no='261.Tutar'></td>
			  </tr>
			 <cfloop from="1" to="15" index="i">
			  <tr>
			  	<td><input type="radio" name="ba<cfoutput>#i#</cfoutput>" id="ba<cfoutput>#i#</cfoutput>" value="0" checked>A
					<input type="radio" name="ba<cfoutput>#i#</cfoutput>" id="ba<cfoutput>#i#</cfoutput>" value="1">B
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
					<cfinput value="" type="text" name="CHEQUE_DUEDATE#i#" style="width:100px;" required="yes" message="#message#" validate="#validate_style#">
                    <cf_wrk_date_image date_field="CHEQUE_DUEDATE">
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='75.şirket girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="DEBTOR_NAME#i#" value="" style="width:150px;" required="yes" message="#message#">
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='19.çek no girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="CHEQUE_NO#i#" style="width:150px;" required="yes" message="#message#">
				</td>
				<td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='1738.Lutfen Tutar Giriniz'></cfsavecontent>
					<cfinput type="text" name="CHEQUE_VALUE#i#" onkeyup="return(FormatCurrency(this,event));" style="width:150px;" required="yes" message="çek tutarını giriniz!">
				</td>
			  </tr>
			 </cfloop>  
			 <tr>
			 	<td colspan="5"><cf_workcube_buttons is_upd='0'></td>
			 </tr>
              </table>
            </cfform>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
	function unformat_fields()
		{
			document.add_cheque_entry.CHEQUE_VALUE1.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE1.value);
			document.add_cheque_entry.CHEQUE_VALUE2.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE2.value);
			document.add_cheque_entry.CHEQUE_VALUE3.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE3.value);
			document.add_cheque_entry.CHEQUE_VALUE4.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE4.value);
			document.add_cheque_entry.CHEQUE_VALUE5.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE5.value);
			document.add_cheque_entry.CHEQUE_VALUE6.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE6.value);
			document.add_cheque_entry.CHEQUE_VALUE7.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE7.value);
			document.add_cheque_entry.CHEQUE_VALUE8.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE8.value);
			document.add_cheque_entry.CHEQUE_VALUE9.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE9.value);
			document.add_cheque_entry.CHEQUE_VALUE10.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE10.value);
			document.add_cheque_entry.CHEQUE_VALUE11.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE11.value);
			document.add_cheque_entry.CHEQUE_VALUE12.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE12.value);
			document.add_cheque_entry.CHEQUE_VALUE13.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE13.value);
			document.add_cheque_entry.CHEQUE_VALUE14.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE14.value);
			document.add_cheque_entry.CHEQUE_VALUE15.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE15.value);
		}
</script>
