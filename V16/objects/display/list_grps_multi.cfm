<cfinclude template="../query/get_groups.cfm">
<script type="text/javascript">

function prepeare(update)
{
	text_ = "";
	value_ = "";
	for (i=document.grps.source_to.options.length-1; i>=0; i--)
		{
		if (document.grps.source_to.options[i].selected)
			{
			value_ = value_ + document.grps.source_to.options[i].value + ",";
			<cfif isDefined("attributes.field_td")>
				text_ = text_ + document.grps.source_to.options[i].text + "<br/>";
			</cfif>
			}
		}
	/*sondaki virgülü at*/
	if (document.grps.source_to.options.length != 0)
		{
		value_ = value_.toString().substr(0,value_.length-1);
		}
	/*sayfaya*/
	if (update == 0)
		{
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value = "," + value_ + ",";
		<cfif isDefined("attributes.field_td")>
		opener.<cfoutput>#attributes.field_td#</cfoutput>.innerHTML = text_;
		</cfif>
		}
	else
		{
		opener.<cfoutput>#attributes.field_id#</cfoutput>.value += value_ + ",";
		<cfif isDefined("attributes.field_td")>
		opener.<cfoutput>#attributes.field_td#</cfoutput>.innerHTML += "<br/>"+text_;
		</cfif>
		}
	window.close();	
	return true;
}
</script>

<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border"> 
    <td valign="middle"> 
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle"> 
          <td height="35"> 
            <table width="98%" align="center">
              <tr> 
                <td valign="bottom" class="headbold"><cf_get_lang dictionary_id='32716.Gruplar'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top"> 
          <td> 
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr> 
                <td colspan="2">
                  <table border="0" cellpadding="0" cellspacing="0">
                    <FORM name="grps">
					<tr> 
					  <td> 
						<table>
						  <tr>
							<td>
								<select name="source_to" id="source_to" size="10" style="width:150px;" multiple>
									<cfoutput query="get_groups">
                                        <option value="#group_id#">#group_name#
                                    </cfoutput>
								</select>
							 </td>
						  </tr>
						  <tr> 
							<td colspan="3"  style="text-align:right;">
							<input type="button" value="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="prepeare(1);" style="width:65px;">
							<cf_workcube_buttons is_upd='0' add_function='prepeare(0)'>
							</td>
						  </tr>
					</table>		
					</td>
					</tr>
				</FORM>	
				</table></td>
              </tr>
           </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>


