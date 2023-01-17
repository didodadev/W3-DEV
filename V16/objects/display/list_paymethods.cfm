<cfsetting showdebugoutput="yes">
<cfset attributes.name = 1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.payMethodTip" default="">
<cfparam name="attributes.modal_id" default="">

<cfset url_string = "">
<cfif isdefined("attributes.function_parameter")>
	<cfset url_string = "#url_string#&function_parameter=#attributes.function_parameter#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_duedate")>
	<cfset url_string = "#url_string#&field_duedate=#attributes.field_duedate#">
</cfif>
<cfif isdefined("attributes.field_dueday")>
	<cfset url_string = "#url_string#&field_dueday=#attributes.field_dueday#">
</cfif>
<cfif isdefined("attributes.field_duedate_rate")>
	<cfset url_string = "#url_string#&field_duedate_rate=#attributes.field_duedate_rate#">
</cfif>
<cfif isdefined("attributes.field_due_month")>
	<cfset url_string = "#url_string#&field_due_month=#attributes.field_due_month#">
</cfif>
<cfif isdefined("attributes.field_paymethod_vehicle")>
	<cfset url_string = "#url_string#&field_paymethod_vehicle=#attributes.field_paymethod_vehicle#">
</cfif>
<cfif isdefined("attributes.field_card_payment_id")>
	<cfset url_string = "#url_string#&field_card_payment_id=#attributes.field_card_payment_id#">
</cfif>
<cfif isdefined("attributes.field_comission_stock_id")>
	<cfset url_string = "#url_string#&field_comission_stock_id=#attributes.field_comission_stock_id#">
</cfif>
<cfif isdefined("attributes.field_commission_product_id")>
	<cfset url_string = "#url_string#&field_commission_product_id=#attributes.field_commission_product_id#">
</cfif>
<cfif isdefined("attributes.field_commission_rate")>
	<cfset url_string = "#url_string#&field_commission_rate=#attributes.field_commission_rate#">
</cfif>
<cfif isdefined("attributes.FUNCTION_NAME")>
	<cfset url_string = "#url_string#&FUNCTION_NAME=#attributes.FUNCTION_NAME#">
</cfif>
<cfif isdefined("attributes.field_card_payment_name")>
	<cfset url_string = "#url_string#&field_card_payment_name=#attributes.field_card_payment_name#">
</cfif>

<cfif isdefined("attributes.function_parameter")>
	<script type="text/javascript">
	if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#evaluate("attributes.function_parameter")#</cfoutput>'))
		{if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#evaluate("attributes.function_parameter")#</cfoutput>').value == '')
		{
			alert("<cf_get_lang dictionary_id='38699.Teslim Tarihi Giriniz'>");	
			window.close();
		}}
	</script>
</cfif>
<!--- 
alınabilecek alanlar:
	field_id : 
	field_name :
	1-Çek 
	2-Senet
	3-Havale
	4-Açık Hesap
	5- Kredi Kart	
	PAYMETHOD_ID
	PAYMETHOD
	DETAIL
	arzu bt ekledi:0902/2004
	paymentdate_value:odeme tarihi dueday eklenecek olan tarih.
	field_duedate :duedate alani
--->

<cfif attributes.payMethodTip is "" or (not attributes.payMethodTip is "" and ListFind(attributes.payMethodTip,'2',','))>
	<cfif not isdefined("attributes.is_paymethods")>
		<cfquery name="CARD_PAYMENT_TYPES" datasource="#DSN3#">
			SELECT  
				PAYMENT_TYPE_ID, 
				CARD_NO,
				NUMBER_OF_INSTALMENT, 
				COMMISSION_STOCK_ID,
				COMMISSION_PRODUCT_ID,
				COMMISSION_MULTIPLIER,
				POS_TYPE
			FROM  
				CREDITCARD_PAYMENT_TYPE 
			WHERE 
				IS_ACTIVE = 1
				<cfif len(attributes.keyword)>
					AND CARD_NO LIKE '%#attributes.keyword#%'
				</cfif>
			ORDER BY 
				CARD_NO
		</cfquery>
	<cfelse>
		<cfset card_payment_types.recordcount = 0>
	</cfif>
 <cfelse>
	<cfset card_payment_types.recordcount = 0>
</cfif>

<cfif attributes.payMethodTip is "" or (not attributes.payMethodTip is "" and ListFind(attributes.payMethodTip,'1',','))>
	<cfinclude template="../query/get_paymethods.cfm">
<cfelse>
	<cfset paymethods.recordcount = 0>
</cfif>

<script type="text/javascript">
	function don(id,name,int_due,due_day,paymethod_vehicle,due_date_rate,due_month,end_of_month_param)
	{
		//standart odeme yontemi bilgilerini gonderir ve tanımlıysa kredi kartı odeme yontemi inputlarını bosaltır 
		<cfif isDefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse><cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif></cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
		</cfif>
		<cfif isDefined("attributes.field_duedate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_duedate#</cfoutput>.value=int_due;
		</cfif>
		<cfif isDefined("attributes.field_dueday")>
			if(end_of_month_param == 1)
			{
				<cfif isdefined('attributes.FUNCTION_NAME') and isdefined('attributes.function_parameter')>
					paper_date_ = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#evaluate("attributes.function_parameter")#</cfoutput>').value;
					var date_diff_today = (parseInt(new Date(paper_date_.split("/")[2], paper_date_.split("/")[1], 0).getDate())-paper_date_.split("/")[0]);
					new_due_day = parseInt(due_day) + parseInt(date_diff_today);
				<cfelse>
					new_due_day = due_day;
				</cfif>
			}
			else
				new_due_day = due_day;
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dueday#</cfoutput>.value = new_due_day;
		</cfif>	
		<cfif isDefined("attributes.field_duedate_rate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_duedate_rate#</cfoutput>.value = due_date_rate;
		</cfif>	
		<cfif isDefined("attributes.field_due_month")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_due_month#</cfoutput>.value = due_month;
		</cfif>	
		<cfif isDefined("attributes.field_paymethod_vehicle")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_paymethod_vehicle#</cfoutput>.value = paymethod_vehicle;
		</cfif>
		<cfif isDefined("attributes.field_card_payment_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_card_payment_id#</cfoutput>.value='';
		</cfif>
		<cfif isDefined("attributes.field_comission_stock_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_comission_stock_id#</cfoutput>.value='';
		</cfif>
		<cfif isDefined("attributes.field_commission_product_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_commission_product_id#</cfoutput>.value = '';
		</cfif>
		<cfif isDefined("attributes.field_commission_rate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_commission_rate#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined('attributes.FUNCTION_NAME') and isdefined('attributes.function_parameter') >
			<cfif isdefined("attributes.draggable")><cfelse>window.opener.</cfif><cfoutput>#attributes.FUNCTION_NAME#('#attributes.function_parameter#');</cfoutput>
		<cfelseif isdefined('attributes.FUNCTION_NAME')>
			<cfif isdefined("attributes.draggable")><cfelse>window.opener.</cfif><cfoutput>#attributes.FUNCTION_NAME#();</cfoutput>
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	function add_card_paymethod_info(id,name,stock_id,product_id,rate)
	{
		//kredi kartı odeme yontemi bilgilerini gonderir ve tanımlıysa standart odeme yontemi inputlarını bosaltır
		<cfif isDefined("attributes.field_card_payment_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_card_payment_id#</cfoutput>.value=id;
		</cfif>
		<cfif isDefined("attributes.field_card_payment_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_card_payment_name#</cfoutput>.value=name.replace(/<.*?>/g,'');
		</cfif>
		<cfif isDefined("attributes.field_comission_stock_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_comission_stock_id#</cfoutput>.value=stock_id;
		</cfif>
		<cfif isDefined("attributes.field_commission_product_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_commission_product_id#</cfoutput>.value = product_id;
		</cfif>
		<cfif isDefined("attributes.field_commission_rate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_commission_rate#</cfoutput>.value = rate;
		</cfif>
		<cfif isDefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value='';
		</cfif>
		<cfif isDefined("attributes.field_duedate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_duedate#</cfoutput>.value='';
		</cfif>
		<cfif isDefined("attributes.field_dueday")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_dueday#</cfoutput>.value = '';
		</cfif>
			<cfif isDefined("attributes.field_duedate_rate")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_duedate_rate#</cfoutput>.value = '';
		</cfif>	
		<cfif isDefined("attributes.field_due_month")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_due_month#</cfoutput>.value = '';
		</cfif>	
		<cfif isDefined("attributes.field_paymethod_vehicle")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_paymethod_vehicle#</cfoutput>.value = '';
		</cfif>
		<cfif isdefined('attributes.FUNCTION_NAME') and isdefined('attributes.function_parameter') >
			<cfif isdefined("attributes.draggable")><cfelse>window.opener.</cfif><cfoutput>#attributes.FUNCTION_NAME#('#attributes.function_parameter#','','',1);</cfoutput>
		<cfelseif isdefined('attributes.FUNCTION_NAME')>
			<cfif isdefined("attributes.draggable")><cfelse>window.opener.</cfif><cfoutput>#attributes.FUNCTION_NAME#();</cfoutput>
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Ödeme Yöntemleri',32805)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="list_paymethods" method="post" action="#request.self#?fuseaction=objects.popup_paymethods&#url_string#">
			<cfparam name="attributes.paymentdate_value" default="">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_paymethods' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<cfif paymethods.recordcount>
				<thead>
					<cfif not isdefined("attributes.is_paymethods")>
						<tr>
							<th colspan="6"><cf_get_lang dictionary_id='34698.Standart Ödeme Yöntemleri'>
						</tr>
					</cfif>
					<tr>
						<th><cf_get_lang dictionary_id='29472.Yontem'></th>
						<th><cf_get_lang dictionary_id='32729.Vade Gün Toplam'> </th>
						<th><cf_get_lang dictionary_id='32730.Vade Aylık(Taksit)'></th>
						<th><cf_get_lang dictionary_id='32731.Peşinat Oranı'>% </th>
						<th><cf_get_lang dictionary_id='46582.Genel Tatil Kontrolü'></th>
						<th><cf_get_lang dictionary_id='46579.Ay Sonu Kontrolü'></th>
					</tr>
				</thead>
				<cfif len(attributes.paymentdate_value)><cf_date tarih="attributes.paymentdate_value"></cfif>
				<tbody>
					<cfoutput query="paymethods">
						<tr>
							<cfif len(DUE_DAY)>
								<cfif len(due_start_month)>
									<cfset new_due_day = (due_start_month*30) + due_day>
								<cfelseif  len(due_start_day)>
									<cfset new_due_day = due_start_day + due_day>
								<cfelse>
									<cfset new_due_day = due_day>
								</cfif>
							<cfelse>
								<cfif len(due_start_month)>
									<cfset new_due_day = (due_start_month*30)>
								<cfelseif len(due_start_day)>
									<cfset new_due_day = due_start_day>
								<cfelse>
									<cfset new_due_day = 0>
								</cfif>
							</cfif>
							<cfif len(attributes.paymentdate_value)>
								<cfset new_due_date = dateformat(date_add("d",new_due_day,attributes.paymentdate_value),dateformat_style)>
							<cfelse>
								<cfset new_due_date = "">
							</cfif>
							<td>
								<a href="javascript://" onclick="don('#paymethod_id#','#paymethod#','','#new_due_day#','#payment_vehicle#','#TlFormat(due_date_rate)#','#due_month#','#IS_DUE_ENDOFMONTH#');" class="tableyazi">#paymethod#</a>
								<cfswitch expression="#PAYMENT_VEHICLE#">
									<cfcase value="1"> - <cf_get_lang dictionary_id='58007.Çek'></cfcase>
									<cfcase value="2"> - <cf_get_lang dictionary_id='58008.Senet'></cfcase>
									<cfcase value="3"> - <cf_get_lang dictionary_id='32736.Havale'></cfcase>
									<cfcase value="4"> - <cf_get_lang dictionary_id='32737.Açık Hesap'></cfcase>
									<cfcase value="5"> - <cf_get_lang dictionary_id='32738.Kredi Kart'></cfcase>
									<cfcase value="6"> - <cf_get_lang dictionary_id='58645.Nakit'></cfcase>
								</cfswitch>
							</td>
							<td>#due_day#<cfif len(due_day)><cf_get_lang dictionary_id='57490.Gün'></cfif></td>
							<td>#due_month#</td>	
							<td>#in_advance#</td>
							<td align="center"><cfif paymethods.IS_DATE_CONTROL eq 1>*</cfif></td>
							<td align="center"><cfif paymethods.is_due_endofmonth eq 1>*</cfif></td>
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="8"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
						</tr>
				</tbody>
			</cfif>
		</cf_grid_list>
		<br>
		<cfif card_payment_types.recordcount>
			<cf_grid_list>
				<thead>
					<tr>
						<th colspan="4"><cf_get_lang dictionary_id='34257.Kredi Kartı Ödeme Yöntemi '></th>
					</tr>
					<tr>
						<th><cf_get_lang dictionary_id='29472.Yontem'></th>
						<th><cf_get_lang dictionary_id='34129.Taksit Sayısı'></th>
						<th><cf_get_lang dictionary_id='34258.Hizmet Komisyon Oranı'></th>
						<th><cf_get_lang dictionary_id='34259.Sanal POS'></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="card_payment_types">
						<tr>
							<td><a href="javascript:add_card_paymethod_info('#payment_type_id#','#card_no#','<cfif len(commission_stock_id)>#commission_stock_id#</cfif>','<cfif len(commission_product_id)>#commission_product_id#</cfif>','<cfif len(commission_multiplier)>#commission_multiplier#</cfif>')" class="tableyazi">#card_no#</a></td>
							<td><cfif len(NUMBER_OF_INSTALMENT)>#NUMBER_OF_INSTALMENT#<cfelse><cf_get_lang dictionary_id='32662.Peşin'></cfif></td>	
							<td><cfif len(commission_multiplier)>%#commission_multiplier#</cfif></td>	
							<td><cfif len(POS_TYPE)>*</cfif></td>	
						</tr>
					</cfoutput>
				</tbody>
			</cf_grid_list>
		</cfif> 
	</cf_box>
</div>

<script type="text/javascript">
	$(document).ready(function(){
    $( "#keyword" ).focus();
});
</script>
