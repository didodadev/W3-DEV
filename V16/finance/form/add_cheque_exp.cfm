<!--- <cfinclude template="../query/get_control.cfm"> --->
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no ='246.Toplu Çek Girişi'></td>
  </tr>
  <tr class="color-border">
    <td valign="top">
      <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="2">
        <td class="color-row" valign="top"> 
            <cfform name="add_cheque_entry" action="#request.self#?fuseaction=cheque.popup_add_cheque_exp" method="post" >
              <table>
              <tr class="color-list">
			  	<td class="txtboldblue"><cf_get_lang_main no='344.Durum'></td>
				<td class="txtboldblue"><cf_get_lang_main no ='330.Tarih'></td>
				<td class="txtboldblue"><cf_get_lang_main no ='1195.Firma'></td>
				<td class="txtboldblue"><cf_get_lang no ='104.Çek No'></td>
				<td class="txtboldblue"><cf_get_lang_main no ='261.Tutar'></td>
			  </tr>
			 <cfloop from="1" to="15" index="i">
			  <tr>
			  	<td><input type="radio" name="ba<cfoutput>#i#</cfoutput>" id="ba<cfoutput>#i#</cfoutput>" value="0" checked>A
					<input type="radio" name="ba<cfoutput>#i#</cfoutput>" id="ba<cfoutput>#i#</cfoutput>" value="1">B
				</td>
				<td>
					<cfsavecontent variable="alert"><cf_get_lang no ='290.çek tarihini giriniz'></cfsavecontent>
					<cfinput value="" type="text" name="CHEQUE_DUEDATE#i#" style="width:100px;" required="yes" message="#alert#">
                    <cf_wrk_date_image date_field="CHEQUE_DUEDATE#i#">
				</td>
				<td>
					<cfsavecontent variable="alert"><cf_get_lang no ='291.firmayı giriniz'></cfsavecontent>
					<cfinput type="text" name="DEBTOR_NAME#i#" value="" style="width:150px;" required="yes" message="#alert#">
				</td>
				<td>
					<cfsavecontent variable="alert"><cf_get_lang no ='292.çek no giriniz'></cfsavecontent>
					<cfinput type="text" name="CHEQUE_NO#i#"  style="width:150px;" required="yes" message="#alert#">
				</td>
				<td>
					<cfsavecontent variable="alert"><cf_get_lang no ='293.çek tutarını giriniz'></cfsavecontent>
                    <cfinput type="text" name="CHEQUE_VALUE#i#"  onkeyup="return(FormatCurrency(this,event));"  validate="float" range="0.005,"style="width:150px;" required="yes" message="#alert#">
				</td>
			  </tr>
			 </cfloop>  
			 <tr>
			 	<td height="30" colspan="5"  style="text-align:right;">
					<cf_workcube_buttons is_upd='0'  add_function="unformat_fields()">
				</td>
			 </tr>
			 </cfform>
              </table>
            
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
			return true;
		}
</script>

