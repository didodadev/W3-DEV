<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
	<cfset date_1=dateformat(attributes.startdate,dateformat_style)>
<cfelse>
	<cfset date_1="">
</cfif>
<cfif len(attributes.FINISHDATE)>
	<cf_date tarih='attributes.FINISHDATE'>
	<cfset date_2=dateformat(attributes.FINISHDATE,dateformat_style)>
<cfelse>
	<cfset date_2="">
</cfif>
<cfinclude template="../../query/get_emp_healty_all.cfm">	
<cfif not isdefined("attributes.print")>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-row">
          <td  style="text-align:right;">
            <a href="<cfoutput>#request.self#?fuseaction=ehesap.popup_print_personal_healty_all#page_code#&print=1&iframe=1</cfoutput>"><img src="/images/print.gif" title="<cf_get_lang dictionary_id='57474.Yazdır'>" border="0"></a>
			<a href="javascript://" onClick="window.close();"><img src="/images/close.gif" title="<cf_get_lang dictionary_id='57553.Kapat'>" border="0"></a>
		   </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<cfelse>
	<script type="text/javascript">
	function waitfor(){
	window.close();
	}	
	setTimeout("waitfor()",3000);
	window.print();
	</script>
</cfif>
	<cfif GET_HEALTY.recordcount>
	<cfset to_number = Ceiling(GET_HEALTY.recordcount/5)>
	<cfset strw = 1>
		<cfloop from="1" to="#to_number#" index="to_number_index">
		<table cellpadding="0" cellspacing="0" style="height:210mm;width:290mm;" align="center" border="0">
		<tr>
		<td valign="top">
			<table width="1000" border="1" cellspacing="0" cellpadding="0" bordercolor="CCCCCC" align="center">
			  <tr>
				<td colspan="10" height="35">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td class="formbold"><cf_get_lang dictionary_id="46668.HASTA PROTOKOL KAYIT DEFTERİ"></td>
					<td><cf_get_lang dictionary_id="57487.No">:<cfoutput>#to_number_index#</cfoutput></td>
					<td  class="formbold" style="text-align:right;">&nbsp;</td>
				  </tr>
				</table></td>
			  </tr>
			  <tr class="print" align="center">
				<td width="35"><cf_get_lang dictionary_id="36250.Sıra No"></td>
				<td width="35"><cf_get_lang dictionary_id="57742.Tarih"></td>
				<td width="150"><cf_get_lang dictionary_id="46665.Hastanın Adı,Soyadı"></td>
				<td width="75"><cf_get_lang dictionary_id="49318.Adresi"></td>
				<td width="40"><cf_get_lang dictionary_id="46659.Yaş ve Cinsiyet"></td>
				<td width="133"><cf_get_lang dictionary_id="46658.Bulgular ve Labaratuvar İncelemeleri"></td>
				<td width="133"><cf_get_lang dictionary_id="32413.Tanı"></td>
				<td width="133"><cf_get_lang dictionary_id="53320.Karar ve Verilen İlaçlar"></td>
				<td width="133"><cf_get_lang dictionary_id="56626.Düşünceler"></td>
				<td width="133"><cf_get_lang dictionary_id="46643.Doktorun Adı Soyadı İmza ve Kaşe"></td>
			  </tr>
			<cfoutput query="GET_HEALTY" maxrows="5" startrow="#strw#">
			 <tr style="height:35mm;" align="center">
				<td>#currentrow#</td>
				<td style="writing-mode : tb-rl;direction : rtl;" align="center">
				<cfif LEN(INSPECTION_DATE)>
					#dateformat(INSPECTION_DATE,dateformat_style)#
				</cfif>
				</td>
				<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# <br/> #POSITION_NAME#</td>
				<td>#HOMEADDRESS#</td>
				<td><cfif "#SEX#" eq 0>Kız<cfelse>Erkek</cfif></td>
				<td>#INSPECTION_RESULT#</td>
				<td>#COMPLAINT#</td>
				<td>#DECISION_MEDICINE#</td>
				<td>#HEALTY_DETAIL#</td>
				<td>#DOCTOR_NAME# #DOCTOR_SURNAME#</td>
			  </tr>
			</cfoutput>
			<cfset strw = strw + 5>
			<cfif GET_HEALTY.recordcount mod 5 is not 0 and to_number_index is to_number>
				<cfset aaaaaaa = GET_HEALTY.recordcount mod 5>
				<cfloop from="1" to="#aaaaaaa+1#" index="son">
				 <tr style="height:35mm;" align="center">
					<td>&nbsp;</td>
					<td style="writing-mode : tb-rl;direction : rtl;" align="center">&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				  </tr>
				</cfloop>
			</cfif>
			</table>
		</td>
		</tr>
		</table>
		</cfloop>
	</cfif>
