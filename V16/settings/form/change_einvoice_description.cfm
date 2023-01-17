<cfquery name="e_invoice_data" datasource="#DSN2#">
	SELECT 
    	EINVOICE_PREFIX,EINVOICE_NUMBER 
   FROM 
   		EINVOICE_NUMBER
</cfquery>
<cf_form_box title="E-Fatura Numara Tanımları">
  	<cfform name="e_invoice_descrition" method="post" action="#request.self#?fuseaction=settings.emptypopup_e_invoice_number_description_change">
		<cf_area>
			<table>
				<tr>
                	<td>E-Fatura Numarası :</td>
                        <td><input id="e_invoice_number" name="e_invoice_number"   readonly="readonly" value="<cfoutput>#e_invoice_data.EINVOICE_NUMBER#</cfoutput>"/></td> 
                        <td>
                        	<table>
                            	<tr>
                                	<td><a href="#" onclick="increase('e_invoice_number');"><img src="images/open_close_3.gif" title="Arttır"/></a></td>
                                	<td><a href="#" onclick="reduce('e_invoice_number');"><img src="images/open_close_2.gif" title="Azalt" /></a></td>
                                </tr>
                            </table>
                   		</td>
				</tr>
			</table>
		</cf_area>
		<cf_form_box_footer>
			<cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0'>
		</cf_form_box_footer>
	</cfform>
</cf_form_box>
<script type="text/javascript">
		function increase(deger)
		{
			
			document.getElementById(deger).value++;
			var uzn=9-document.getElementById(deger).value.length;
			for (i=0; i<uzn; i++)
			{
				document.getElementById(deger).value="0"+document.getElementById(deger).value;
			}
		}
		function reduce(deger)
		{
				if (document.getElementById(deger).value> 1)
					document.getElementById(deger).value--;
				var uzn=9-document.getElementById(deger).value.length;
				for (i=0; i<uzn; i++)
				{
					document.getElementById(deger).value="0"+document.getElementById(deger).value;
				}	
		}
	</script>
