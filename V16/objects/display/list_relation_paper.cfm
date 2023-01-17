<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cat" default="0">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_txt" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>
<cfinclude template="../query/get_bill.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#get_bill.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function add_bill(id,name,cmp_id,value,taxvalue,date,bill_type_name)
{
	<cfif isdefined("attributes.field_name")>
		opener.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		opener.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_cmp_id")>
		opener.<cfoutput>#field_cmp_id#</cfoutput>.value = cmp_id;
	</cfif>
	<cfif isdefined("attributes.field_value")>
		opener.<cfoutput>#field_value#</cfoutput>.value = value;
	</cfif>
	<cfif isdefined("attributes.field_tax_value")>
		opener.<cfoutput>#field_tax_value#</cfoutput>.value = taxvalue;
	</cfif>
	<cfif isdefined("attributes.field_date")>
	  opener.<cfoutput>#field_date#</cfoutput>.value = date;
	</cfif>
	<cfif isdefined("attributes.field_bill_type_name")>
	  opener.<cfoutput>#field_bill_type_name#</cfoutput>.value = bill_type_name;
	</cfif>
	<cfif isdefined("attributes.field_is_billed")>
	  opener.<cfoutput>#attributes.field_is_billed#</cfoutput>.checked = true;
	</cfif>
	<cfif isdefined("attributes.field_calistir")>
		opener.bosalt();
	</cfif>
	window.close();
}
</script>
<cfparam name="select_list" default="1">
<cfset url_string="">
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>
<cfif isdefined("attributes.field_cmp_id")>
	<cfset url_string = "#url_string#&field_cmp_id=#field_cmp_id#">
</cfif>
<cfif isdefined("attributes.field_value")>
	<cfset url_string = "#url_string#&field_value=#field_value#">
</cfif>
<cfif isdefined("attributes.field_tax_value")>
	<cfset url_string = "#url_string#&field_tax_value=#field_tax_value#">
</cfif>
<cfif isdefined("attributes.field_date")>
	<cfset url_string = "#url_string#&field_date=#field_date#">
</cfif>
<cfif isdefined("attributes.field_bill_type_name")>
	<cfset url_string = "#url_string#&field_bill_type_name=#field_bill_type_name#">  
</cfif>
<cfif isdefined("attributes.cons_id")>
	<cfset url_string = "#url_string#&cons_id=#attributes.cons_id#">  
</cfif>
<cfif isdefined("attributes.comp_id")>
	<cfset url_string = "#url_string#&comp_id=#attributes.comp_id#">  
</cfif>
<cfif isdefined("attributes.subscription_id")>
	<cfset url_string = "#url_string#&subscription_id=#attributes.subscription_id#">  
</cfif>
<cfif isdefined("attributes.select_list")>
	<cfset url_string = "#url_string#&select_list=#attributes.select_list#">  
</cfif>
<table cellspacing="0" cellpadding="0" border="0" width="100%">
  <tr class="color-border"> 
	<td>
	<table cellspacing="1" cellpadding="2" border="0" align="center" width="100%">
	  <tr class="color-row">
	  <cfoutput> 
		<td>&nbsp;</td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=A">A</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=B">B</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=C">C</a><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=Ç">Ç</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=D">D</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=E">E</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=F">F</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=G">G</a><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=Ğ">Ğ</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=H">H</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=I">I</a><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=İ">İ</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=J">J</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=K">K</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=L">L</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=M">M</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=N">N</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=O">O</a><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=Ö">Ö</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=P">P</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=Q">Q</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=R">R</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=S">S</a><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=Ş">Ş</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=T">T</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=U">U</a><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=Ü">Ü</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=V">V</a><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=W">W</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=Y">Y</a></td>
		<td align="center" width="15"><a class="tableyazi" href="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#&keyword=Z">Z</a></td>
		<td>&nbsp;</td>
	  </cfoutput>
	  </tr>
	</table>
	</td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35" class="headbold">
  <tr>	
	<td>
	<cfoutput>
	<select name="categories" id="categories" onChange="location.href=this.value;">
		<cfif listcontainsnocase(select_list,1)>
		  <option value="#request.self#?fuseaction=objects.popup_list_bills#url_string#" <cfif fusebox.fuseaction is "popup_list_relation_paper">selected</cfif>><cf_get_lang dictionary_id='58917.Faturalar'></option>
		</cfif>
		<cfif listcontainsnocase(select_list,2)>
		  <option value="#request.self#?fuseaction=objects.popup_list_ship_rows#url_string#" selected><cf_get_lang dictionary_id='57773.İrsaliye'></option>
		</cfif>
	</select>
	</cfoutput>
	</td>
   <!--- <td><cf_get_lang_main no='1505.Faturalar'></td> --->
    <td style="text-align:right;" valign="bottom"> 
      <!--- Arama --->
      <table>
        <cfform name="form" action="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#" method="post">
		  <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
		  <tr> 
            <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
			<td>
				 <cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.başlama girmelisiniz'></cfsavecontent>
				 <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:67px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
				 <cf_wrk_date_image date_field="start_date">
			</td>
			<td>
			     <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
				 <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:67px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
				 <cf_wrk_date_image date_field="finish_date">
			</td>
            <td>
               	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			   	<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button></td>
          </tr>
      </table>
   	</td>
  </tr>
</table>
<table cellpacing="0" cellpadding="0" border="0" width="98%" align="center">
   <!-- sil -->
   <!-- sil -->
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
	  <!-- sil -->
	  <tr style="text-align:right;" class="color-list">
	  	<td height="20" colspan="11">
	 	 <table>
		  <tr>
			 <td> 
              <select name="cat" id="cat" style="width:150px;">
				<option value="0" <cfif attributes.cat eq 0>selected</cfif>><cf_get_lang dictionary_id='32451.Alış Faturaları'>
				<option value="1" <cfif attributes.cat eq 1>selected</cfif>><cf_get_lang dictionary_id='32435.Satış Faturaları'>
				<option value="50" <cfif attributes.cat eq 50>selected</cfif>><cf_get_lang dictionary_id='32756.Verilen Vade Farki Fat'>
				<option value="51" <cfif attributes.cat eq 51>selected</cfif>><cf_get_lang dictionary_id='57763.Alinan Vade Farki Fat'>
				<option value="52" <cfif attributes.cat eq 52>selected</cfif>><cf_get_lang dictionary_id='57765.Perakende Sat Faturasi'> 
				<option value="53" <cfif attributes.cat eq 53>selected</cfif>><cf_get_lang dictionary_id='57825.Toptan Sat Faturasi'>
				<option value="54" <cfif attributes.cat eq 54>selected</cfif>><cf_get_lang dictionary_id='57824.Parekende Satis Iade Faturasi'>
				<option value="55" <cfif attributes.cat eq 55>selected</cfif>><cf_get_lang dictionary_id='32950.Topt Sat Iade Fatura'>
				<option value="56" <cfif attributes.cat eq 56>selected</cfif>><cf_get_lang dictionary_id='57829.Verilen Hizmet Fat'>
				<option value="57" <cfif attributes.cat eq 57>selected</cfif>><cf_get_lang dictionary_id='57770.Verilen Proforma Fat'>
				<option value="58" <cfif attributes.cat eq 58>selected</cfif>><cf_get_lang dictionary_id='57830.Verilen Fiyat Farki Fat'>
				<option value="59" <cfif attributes.cat eq 59>selected</cfif>><cf_get_lang dictionary_id='57822.Mal Alim Faturasi'>
				<option value="60" <cfif attributes.cat eq 60>selected</cfif>><cf_get_lang dictionary_id='32955.Alinan Hizmet Faturasi'>
				<option value="61" <cfif attributes.cat eq 61>selected</cfif>><cf_get_lang dictionary_id='57814.Alinan Proforma Fat'>
				<option value="62" <cfif attributes.cat eq 61>selected</cfif>><cf_get_lang dictionary_id='57815.Alim Iade Fatura'>
				<option value="63" <cfif attributes.cat eq 63>selected</cfif>><cf_get_lang dictionary_id='57811.Alinan Fiyat Farki Fat'>
				<option value="64" <cfif attributes.cat eq 64>selected</cfif>><cf_get_lang dictionary_id='57823.Müstahsil Makbuzu'>
			</select>
            </td>
			<td><cf_get_lang dictionary_id='58763.Depo'></td>
			<td><input type="hidden" name="department_id" id="department_id" <cfif isdefined('attributes.department_id') and isdefined('department_txt') and len(attributes.department_txt)>value="<cfoutput>#attributes.department_id#</cfoutput>"</cfif>>
				<input type="text" readonly style="width:150px;" name="department_txt" id="department_txt" value="<cfif isdefined('attributes.department_txt')><cfoutput>#attributes.department_txt#</cfoutput></cfif>">
				<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_departments&field_name=form.department_txt&field_id=form.department_id&is_store_id=1</cfoutput>','list')" >
				<img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
			</td>		  
		  </tr>
		  </cfform>
	  </table>
	 </td>
	</tr>
	<tr class="color-header" height="22"> 
		  <td class="form-title" width="75"><cf_get_lang dictionary_id='41116.Fatura ID'></td>
		  <td class="form-title" width="90"><cf_get_lang dictionary_id='32677.Alış Satış'></td>		
		  <td class="form-title"><cf_get_lang dictionary_id='57574.Şirket'></td>
		  <td class="form-title" width="75"><cf_get_lang dictionary_id='58133.Fatura No'></td>
		  <td class="form-title"><cf_get_lang dictionary_id='57742.Tarih'></td>		
          <td class="form-title"><cf_get_lang dictionary_id='57680.Genel Toplam'></td> 
		</tr>
	<cfif get_bill.recordcount>
	<cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<cfif GET_BILL.PURCHASE_SALES is 1>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='32435.SATIŞ FATURASI'></cfsavecontent>
		<cfelseif GET_BILL.PURCHASE_SALES is 0>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='32451.ALIŞ FATURASI'></cfsavecontent>
		</cfif>
		<td><a href="javascript://" class="tableyazi" onclick="add_bill('#GET_BILL.INVOICE_ID#','#get_bill.INVOICE_NUMBER#','#get_bill.COMPANY_ID#','#TLFormat(get_bill.NETTOTAL)#','#get_bill.TAXTOTAL#','#dateformat(get_bill.INVOICE_DATE,dateformat_style)#','#message#');">#GET_BILL.INVOICE_ID#</a></td>
		<td>#message#</td>		
		<td><cfif len(get_bill.company_id)>#GET_BILL.fullname#<cfelseif len(get_bill.consumer_id)>#GET_BILL.consumer_name# #GET_BILL.consumer_surname#<cfelse>&nbsp;</cfif></td>
		<td><a href="javascript://" class="tableyazi" onclick="add_bill('#GET_BILL.INVOICE_ID#','#get_bill.INVOICE_NUMBER#','#get_bill.COMPANY_ID#','#TLFormat(get_bill.NETTOTAL)#','#get_bill.TAXTOTAL#','#dateformat(get_bill.INVOICE_DATE,dateformat_style)#','#message#');">#get_bill.INVOICE_NUMBER#</a></td>
		<td align="center">#dateformat(get_bill.INVOICE_DATE,dateformat_style)#</td>
		<td  style="text-align:right;">#TLFormat(get_bill.NETTOTAL)# #session.ep.money#</td>
	</tr>
	</cfoutput>
	<cfelse>
	<tr>
		<td colspan="8" class="color-row" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
	</tr>
	</cfif>
</table>
  </td>
 </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfif len(attributes.cat)>
		<cfset url_string = "#url_string#&cat=#attributes.cat#">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.field_bill_type_name")>
		<cfset url_string = "#url_string#&field_bill_type_name=#field_bill_type_name#">
	</cfif>
	<cfif isdate(attributes.start_date)>
		<cfset url_string = "#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
	</cfif>
	<cfif isdate(attributes.finish_date)>
		<cfset url_string = "#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
	</cfif>
	<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
		<cfset url_string  = "#url_string #&department_id=#attributes.department_id#" >
	</cfif>
	<cfif isdefined("attributes.department_txt") and len(attributes.department_txt)>
		<cfset url_string  = "#url_string #&department_txt=#attributes.department_txt#" >
	</cfif>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
	<tr> 
		<td>
		<cf_pages 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.#fusebox.fuseaction##url_string#"></td>
		<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
	</tr>
</table>
</cfif>

