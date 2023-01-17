<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_txt" default="">
<cfparam name="attributes.frm_inventory" default="">
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
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default='#get_bill.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function add_bill(id,name,cmp_id,value,taxvalue,date,bill_type_name,bill_type,per_id)
{
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_per_id")><!--- ödeme planları için eklenmiştir --->
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_per_id#</cfoutput>.value = per_id;
	</cfif>
	<cfif isdefined("attributes.field_cmp_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_cmp_id#</cfoutput>.value = cmp_id;
	</cfif>
	<cfif isdefined("attributes.field_value")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_value#</cfoutput>.value = value;
	</cfif>
	<cfif isdefined("attributes.field_tax_value")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_tax_value#</cfoutput>.value = taxvalue;
	</cfif>
	<cfif isdefined("attributes.field_date")>
	  <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_date#</cfoutput>.value = date;
	</cfif>
	<cfif isdefined("attributes.field_bill_type_name")>
	  <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_bill_type_name#</cfoutput>.value = bill_type_name;
	</cfif>
	<cfif isdefined("attributes.field_bill_type")>
	  <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_bill_type#</cfoutput>.value = bill_type;
	</cfif>
	<cfif isdefined("attributes.field_is_billed")>
	  <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_is_billed#</cfoutput>.checked = true;
	</cfif>
	
	<cfif isdefined("attributes.field_calistir")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.bosalt();
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>

<cfset url_string="">
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>
<cfif isdefined("attributes.field_per_id")>
	<cfset url_string = "#url_string#&field_per_id=#field_per_id#">
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
<cfif isdefined("attributes.field_bill_type")>
		<cfset url_string = "#url_string#&field_bill_type=#field_bill_type#">  
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
<cfif isdefined("attributes.frm_inventory")>
	<cfset url_string = "#url_string#&frm_inventory=#attributes.frm_inventory#">  
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Faturalar',58917)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form_list_bills" action="#request.self#?fuseaction=objects.popup_list_bills#url_string#" method="post">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
				</div>
				<div class="form-group">
                    <div class="input-group">
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','başlama girmelisiniz',57655)#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
				</div>
				<div class="form-group">
                    <div class="input-group">
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getlang('','bitiş tarihi girmelisiniz',57739)#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getlang('','Kayıt sayısı hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_list_bills' , #attributes.modal_id#)"),DE(""))#">
                </div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-select_alis">
						<cfif isdefined("frm_inventory") and (frm_inventory eq 1 or frm_inventory eq 2)>
							<select name="cat" id="cat">
								<option value="0" <cfif attributes.cat eq 0>selected</cfif>><cf_get_lang dictionary_id='32451.Alış Faturaları'>
									<cfif frm_inventory eq 2>
										<option value="-1" <cfif attributes.cat eq -1>selected</cfif>><cf_get_lang dictionary_id='39763.Masraf Fişleri'>
									</cfif>
								<option value="49" <cfif attributes.cat eq 49>selected</cfif>><cf_get_lang dictionary_id='29573.Alınan Kur Farkı Faturası '>
								<option value="51" <cfif attributes.cat eq 51>selected</cfif>><cf_get_lang dictionary_id='57763.Alinan Vade Farki Fat'>
								<option value="54" <cfif attributes.cat eq 54>selected</cfif>><cf_get_lang dictionary_id='57824.Parekende Satis Iade Faturasi'>
								<option value="55" <cfif attributes.cat eq 55>selected</cfif>><cf_get_lang dictionary_id='32950.Topt Sat Iade Fatura'>
								<option value="57" <cfif attributes.cat eq 57>selected</cfif>><cf_get_lang dictionary_id='57770.Verilen Proforma Fat'>
								<option value="59" <cfif attributes.cat eq 59>selected</cfif>><cf_get_lang dictionary_id='57822.Mal Alim Faturasi'>
								<option value="60" <cfif attributes.cat eq 60>selected</cfif>><cf_get_lang dictionary_id='32955.Alinan Hizmet Faturasi'>
								<option value="61" <cfif attributes.cat eq 61>selected</cfif>><cf_get_lang dictionary_id='57814.Alinan Proforma Fat'>
								<option value="601" <cfif attributes.cat eq 601>selected</cfif>><cf_get_lang dictionary_id='57812.Alinan Hakediş Faturası'>
								<option value="63" <cfif attributes.cat eq 63>selected</cfif>><cf_get_lang dictionary_id='57811.Alinan Fiyat Farki Fat'>
								<option value="64" <cfif attributes.cat eq 64>selected</cfif>><cf_get_lang dictionary_id='57823.Müstahsil Makbuzu'>
								<option value="65" <cfif attributes.cat eq 65>selected</cfif>><cf_get_lang dictionary_id='58757.Sabit Kıymet Alım Faturası'>
							</select>
						<cfelse>
							<select name="cat" id="cat">
								<option value="0" <cfif attributes.cat eq 0>selected</cfif>><cf_get_lang dictionary_id='32451.Alış Faturaları'>
								<option value="1" <cfif attributes.cat eq 1>selected</cfif>><cf_get_lang dictionary_id='32435.Satış Faturaları'>
								<option value="49" <cfif attributes.cat eq 49>selected</cfif>><cf_get_lang dictionary_id='29573.Alınan Kur Farkı Faturası '>
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
								<option value="601" <cfif attributes.cat eq 601>selected</cfif>><cf_get_lang dictionary_id='57812.Alinan Hakediş Faturası'>
								<option value="62" <cfif attributes.cat eq 61>selected</cfif>><cf_get_lang dictionary_id='57815.Alim Iade Fatura'>
								<option value="63" <cfif attributes.cat eq 63>selected</cfif>><cf_get_lang dictionary_id='57811.Alinan Fiyat Farki Fat'>
								<option value="64" <cfif attributes.cat eq 64>selected</cfif>><cf_get_lang dictionary_id='57823.Müstahsil Makbuzu'>
								<option value="65" <cfif attributes.cat eq 65>selected</cfif>><cf_get_lang dictionary_id='58757.Sabit Kıymet Alım Faturası'>
								<option value="66" <cfif attributes.cat eq 66>selected</cfif>><cf_get_lang dictionary_id='58758.Sabit Kıymet Satis Faturası'>
							</select>
						</cfif>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-depo_list">
						<div class="input-group">
							<input type="hidden" name="department_id" id="department_id" <cfif len(attributes.department_txt)>value="<cfoutput>#attributes.department_id#</cfoutput>"</cfif>>
							<input type="Text" readonly style="width:150px;" name="department_txt" id="department_txt" value="<cfoutput>#attributes.department_txt#</cfoutput>">
							<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_departments&field_name=form.department_txt&field_id=form.department_id&is_store_id=1</cfoutput>','list')" ><img src="/images/plus_thin.gif" align="top" border="0"></span>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='57441.Fatura ID'></th>
					<th><cf_get_lang dictionary_id='32677.Alış Satış'></th>		
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='58133.Fatura No'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>		
					<th><cf_get_lang dictionary_id='57680.Genel Toplam'></th> 
				</tr>
			</thead>
			<tbody>
				<cfif get_bill.recordcount>
					<cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<cfif GET_BILL.PURCHASE_SALES is 1>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='32435.SATIŞ FATURASI'></cfsavecontent>
								<cfset _type_ = 'invoice'>
							<cfelseif GET_BILL.PURCHASE_SALES is 0>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='32451.ALIŞ FATURASI'></cfsavecontent>
								<cfset _type_ = 'invoice'>
							<cfelseif GET_BILL.PURCHASE_SALES is -1>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58064.MASRAF FİŞİ'></cfsavecontent>
								<cfset _type_ = 'expense'>
							</cfif>
							<td><a href="javascript://" class="tableyazi" onclick="add_bill('#GET_BILL.INVOICE_ID#','#get_bill.INVOICE_NUMBER#','#get_bill.COMPANY_ID#','#TLFormat(get_bill.NETTOTAL)#','#get_bill.TAXTOTAL#','#dateformat(get_bill.INVOICE_DATE,dateformat_style)#','#message#','#_type_#','#session.ep.period_id#');">#GET_BILL.INVOICE_ID#</a></td>
							<td>#message#</td>		
							<td>#GET_BILL.fullname#</td>
							<td><a href="javascript://" class="tableyazi" onclick="add_bill('#GET_BILL.INVOICE_ID#','#get_bill.INVOICE_NUMBER#','#get_bill.COMPANY_ID#','#TLFormat(get_bill.NETTOTAL)#','#get_bill.TAXTOTAL#','#dateformat(get_bill.INVOICE_DATE,dateformat_style)#','#message#','#_type_#','#session.ep.period_id#');">#get_bill.INVOICE_NUMBER#</a></td>
							<td align="center">#dateformat(get_bill.INVOICE_DATE,dateformat_style)#</td>
							<td  style="text-align:right;">#TLFormat(get_bill.NETTOTAL)# #session.ep.money#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6" class="color-row" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif len(attributes.cat)>
			<cfset url_string = "#url_string#&cat=#attributes.cat#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
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
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_list_bills#url_string#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
