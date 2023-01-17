<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfif month(now()) eq 1>
	<cfparam name="attributes.sal_mon" default="1">
<cfelse>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
</cfif>
<cfinclude template="../ehesap/query/get_ssk_offices.cfm">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.ssk_office" default="0">
<cfquery name="get_shifts" datasource="#dsn#">
	SELECT * FROM SETUP_SHIFTS ORDER BY SHIFT_ID
</cfquery>
<!-- sil -->
    <table width="98%" cellpadding="2" cellspacing="1" class="color-border" align="center">
      <tr class="color-row">      
      <td>
        <table>
          <tr>    
          <td class="headbold" height="40"><cf_get_lang dictionary_id="32180.Vardiyalar"></td>
          <td>
		  <table id="sube_puantaj">
            <cfform name="employee" method="post" action="">
              <tr>
                <td>
                  <select name="shifts" id="shifts">
                    <cfoutput query="get_shifts">
                        <option value="#shift_id#">#shift_name# (#start_hour#-#end_hour#)</option>
                    </cfoutput>
                  </select>
                  <select name="sal_mon" id="sal_mon">
						<cfloop from="1" to="12" index="i">
							<cfoutput>
								<option value="#i#" <cfif month(now()) gt 1 and i eq month(now())-1>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
							</cfoutput>
						</cfloop>
					</select>
                  <input type="text" name="sal_year" id="sal_year" value="<cfoutput>#session.ep.period_year#</cfoutput>" readonly size="3">
                </td>
                <td width="15"><a href="javascript://" onClick="open_form_ajax();"><img src="/images/ara.gif" border="0"></a></td>
				<td width="600"><div id="menu_puantaj_1" style="width:200;height:10;"></div></td>
				<td  style="text-align:right;">
					<a href="javascript://" onClick="send_adres_info();"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.yazıcıya gönder'>"></a>
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
<!-- sil -->
<script type="text/javascript">
	function open_form_ajax()
	{
		adres_ = '<cfoutput>#request.self#?fuseaction=hr.emptypopup_ajax_view_pdks_fm</cfoutput>';
		sal_year_ = document.getElementById('sal_year').value;
		sal_mon_ = document.getElementById('sal_mon').value;
		shifts_ = document.getElementById('shifts').value;
	//	ssk_office_ = list_getat(document.employee.shifts.value,1,'-');
	//	ssk_no_ = list_getat(document.employee.shifts.value,2,'-');
		adres_= adres_ + '&sal_mon=' + sal_mon_ + '&sal_year=' + sal_year_;
		AjaxPageLoad(adres_,'puantaj_list_layer','1',"Tablo Listeleniyor");
	}
	
	function send_adres_info()
	{
		adres = '<cfoutput>#request.self#?fuseaction=hr.popup_print_branch_pdks_table</cfoutput>';
		adres +='&ssk_office_all_='+encodeURIComponent(document.employee.shifts.value);
		adres +='&ssk_office_='+encodeURIComponent(list_getat(document.employee.shifts.value,1,'-'));
		adres +='&sal_mon_='+document.employee.sal_mon.value;
		adres +='&id='+list_getat(document.employee.shifts.value,2,'-');
		windowopen(adres,'page');
	}
</script>
