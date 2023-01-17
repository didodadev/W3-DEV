
<!--- form_add_table.cfm --->

<cfif isdefined("form.cols")>
<script type="text/javascript">

var eb = window.opener.document.all.editbar;
<cfoutput>
	eb._editor.WriteTable("#form.cols#","#form.rows#","#form.c_val#","#form.r_val#","#form.border#");
</cfoutput>
window.close();
</script>
</cfif>
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border"> 
    <td valign="middle"> 
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle"> 
          <td height="35"> 
            <table width="98%" align="center">
              <tr> 
                <td class="headbold"><cf_get_lang dictionary_id='57516.Tablo Ekle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top"> 
          <td> 
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr> 
                <td colspan="2">
				
				<cfif isdefined("form.cols_")>
				<form action="" method="post">
				<cfoutput>
				<input type="Hidden" name="cols" id="cols" value="#form.cols_#">
				<input type="Hidden" name="rows" id="rows" value="#form.rows_#">
				</cfoutput>
				<cf_get_lang dictionary_id='32786.Border'> : <input type="Text" name="border" id="border" value="1" size="2">
				<br/><br/>
				<cf_get_lang dictionary_id='32787.Satır Başlıkları'>:<br/>
				<cfoutput>
				<cfloop from="2" to="#form.rows_#" index="row">
				#row# <input type="Text" name="c_val" id="c_val"><br/>
				</cfloop>
				</cfoutput>
				<br/>
				<cf_get_lang dictionary_id='32511.Sütun Başlıkları'>:<br/>
				<cfoutput>
				<cfloop from="2" to="#form.cols_#" index="cols">
				#cols# <input type="Text" name="r_val" id="r_val"><br/>
				</cfloop>
				
				</cfoutput>				
				<br/>
				<cfsavecontent variable="button_name"><cf_get_lang dictionary_id='57582.Ekle'></cfsavecontent>
				<cf_workcube_buttons is_upd='0' insert_info='#button_name#'>
				</form>
				<cfelse>				
				<br/>
				<table>
				<form action="" method="post">
					<tr>
						
				      <td width="100"><cf_get_lang dictionary_id='32788.Satır Sayısı'></td>
						<td><input type="Text" name="rows_" id="rows_" style="width:150px;"></td>
					</tr>
					<tr>
						
				      <td><cf_get_lang dictionary_id='32789.Sutun Sayısı'></td>
						<td><input type="Text" name="cols_" id="cols_" style="width:150px;"></td>
					</tr>
					<tr>
				      <td height="35" colspan="2"  style="text-align:right;"> 
						<cfsavecontent variable="add"><cf_get_lang dictionary_id='57582.Ekle'></cfsavecontent>
					  	<cf_workcube_buttons is_upd='0' insert_info='#add#'>
				      </td>
					</tr>
				</form>
				</table>
				</cfif>
    
				            
				</td>
              </tr>
           </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
