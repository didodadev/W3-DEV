<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.is_purchase" default="0">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.employee_id_new" default="">
<cfinclude template="../query/get_commethod.cfm">
<cfquery name="GET_ORDER_LIST" datasource="#dsn3#">
	SELECT DISTINCT
		ORDERS.ORDER_ID,
		ORDERS.CONSUMER_ID,
		ORDERS.PARTNER_ID,
		ORDERS.ORDER_NUMBER,
		ORDERS.ORDER_CURRENCY,
		ORDERS.ORDER_HEAD,
		ORDERS.OTHER_MONEY,
		ORDERS.TAX,
		ORDERS.COMMETHOD_ID,
		ORDERS.GROSSTOTAL, 
		ORDERS.ORDER_CURRENCY, 
		ORDERS.RECORD_DATE, 
		ORDERS.DELIVERDATE, 
		ORDERS.RECORD_EMP, 
		ORDERS.PRIORITY_ID, 
		ORDERS.IS_PROCESSED, 
		ORDERS.IS_WORK, 
		EMP.EMPLOYEE_NAME, 
		EMP.EMPLOYEE_EMAIL, 
		EMP.EMPLOYEE_SURNAME,
		ORDERS.ORDER_DATE
	FROM 
		ORDERS, 
		ORDER_ROW,
		#dsn_alias#.EMPLOYEES AS EMP
	WHERE 		
		ORDERS.ORDER_STATUS = 1 
		AND ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
		AND	ORDERS.RECORD_EMP = EMP.EMPLOYEE_ID 
		AND	
		<cfif isdefined("attributes.is_purchase") and attributes.is_purchase eq 0>
				(
				(
					ORDERS.PURCHASE_SALES = 1 AND
					ORDERS.ORDER_ZONE = 0
				)  
			OR
				(	
					ORDERS.PURCHASE_SALES = 0 AND
					ORDERS.ORDER_ZONE = 1
				)
			) 
		<cfelse>
			ORDERS.PURCHASE_SALES = 0
		    AND ORDERS.ORDER_ZONE = 0 
		</cfif>
	
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
				ORDERS.ORDER_HEAD LIKE '%#attributes.keyword#%'
			OR
				ORDERS.ORDER_NUMBER LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isDefined("currency_id") and len(currency_id)>
		AND ORDER_ROW.ORDER_ROW_CURRENCY = #currency_id#
	</cfif>
	<cfif isDefined("attributes.member_id") and len(attributes.member_id)>
		AND ORDERS.COMPANY_ID = #attributes.member_id#
	</cfif>
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		AND ORDERS.CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif isDefined("attributes.employee_id_new") and len(attributes.employee_id_new)>
		AND ORDERS.EMPLOYEE_ID = #attributes.employee_id_new#
	</cfif>
</cfquery>
<cfif not len(GET_ORDER_LIST.recordcount)>
	<cfset GET_ORDER_LIST.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default=#get_order_list.recordcount#>  
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>  
<cfset sayac = 0 >
<cfset url_str="">
<cfif isdefined("attributes.is_submitted")>
	<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.is_purchase")>
	<cfset url_str = "#url_str#&is_purchase=#attributes.is_purchase#">
</cfif>
<cf_box title="#getLang('','Alınan Siparişler',34049)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_orders"  action="#request.self#?fuseaction=objects.popup_orders_list#url_str#" method="post">
		<cf_box_search>
			<input name="is_submitted" id="is_submitted" type="hidden"  value="1">
			<div class="form-group" id="item-keyword">
				<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
			</div>	
			<div class="form-group" id="item-currency_id">
				<select name="currency_id" id="currency_id">
					<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
					<option value="-7" <cfif attributes.currency_id eq -7>selected</cfif>><cf_get_lang dictionary_id ='29748.Eksik Teslimat'></option>
					<option value="-8" <cfif attributes.currency_id eq -8>selected</cfif>><cf_get_lang dictionary_id ='29749.Fazla Teslimat'></option>
					<option value="-6" <cfif attributes.currency_id eq -6>selected</cfif>><cf_get_lang dictionary_id ='58761.Sevk'></option>
					<option value="-5" <cfif attributes.currency_id eq -5>selected</cfif>><cf_get_lang dictionary_id ='57456.Üretim'></option>
					<option value="-4" <cfif attributes.currency_id eq -4>selected</cfif>><cf_get_lang dictionary_id ='29747.Kısmi Üretim'></option>
					<option value="-3" <cfif attributes.currency_id eq -3>selected</cfif>><cf_get_lang dictionary_id ='29746.Kapatıldı'></option>
					<option value="-2" <cfif attributes.currency_id eq -2>selected</cfif>><cf_get_lang dictionary_id ='29745.Tedarik'></option>
					<option value="-1" <cfif attributes.currency_id eq -1>selected</cfif>><cf_get_lang dictionary_id ='58717.Açık'></option>
				</select>			
			</div>
			<div class="form-group" id="member_name">
				<div class="input-group">
					<input type="hidden" name="member_id" id="member_id" value="<cfif isdefined("attributes.member_id") and not(isdefined("attributes.employee_id_new") and len(attributes.employee_id_new))><cfoutput>#attributes.member_id#</cfoutput></cfif>">
					<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
					<input type="hidden" name="employee_id_new" id="employee_id_new" value="<cfif isdefined("attributes.employee_id_new")><cfoutput>#attributes.employee_id_new#</cfoutput></cfif>">
					<input type="text" name="member_name" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,','member_id,consumer_id,employee_id_new','','3','250');" value="<cfif isdefined("attributes.member_id") and len(attributes.member_id) and not(isdefined("attributes.employee_id_new") and len(attributes.employee_id_new))><cfoutput>#get_par_info(attributes.member_id,1,1,0)#</cfoutput><cfelseif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput><cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput><cfelseif isdefined("attributes.employee_id_new") and len(attributes.employee_id_new)><cfoutput>#get_emp_info(attributes.employee_id_new,0,0,0)#</cfoutput></cfif>" autocomplete="off">
					<cfset str_linke_ait2="is_cari_action=1&field_comp_id=search_orders.member_id&field_name=search_orders.member_name&field_comp_name=search_orders.member_name&field_consumer=search_orders.consumer_id&field_member_name=search_orders.member_name&field_emp_id=search_orders.employee_id_new&select_list=1,2,3,9">
					<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&#str_linke_ait2#</cfoutput>');"></span>										
				</div>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_orders' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>  
		<thead>
			<tr> 
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th><cf_get_lang dictionary_id='57611.Sipariş'></th>
				<th><cf_get_lang dictionary_id='57574.Şirket'>-<cf_get_lang dictionary_id='57578.Yetkili'></th>
				<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
				<th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
				<th><cf_get_lang dictionary_id='57485.Öncelik'></th>
				<th><cf_get_lang dictionary_id='57680.Genel Toplam'></th> 
			</tr>
		</thead>
		<tbody>
			<cfif not isDefined("url.id")>
				<cfset id = "">
			</cfif>
			<cfif get_order_list.recordcount>
			<cfset partner_id_list=''>
			<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
				<cfset partner_id_list = Listappend(partner_id_list,partner_id)>
				</cfif>
			</cfoutput>
			<cfif len(partner_id_list)>
				<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>			
				<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
					SELECT
						CP.COMPANY_PARTNER_NAME,	
						CP.COMPANY_PARTNER_SURNAME,
						CP.PARTNER_ID,
						CP.COMPANY_ID,
						C.NICKNAME
					FROM
						COMPANY_PARTNER CP,
						COMPANY C
					WHERE
						CP.COMPANY_ID = C.COMPANY_ID AND	    
						CP.PARTNER_ID IN (#partner_id_list#)
					ORDER BY
						CP.PARTNER_ID				
				</cfquery>						
			</cfif>
				<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td><a href="javascript://" onClick="ekle(#order_id#,'#order_number#');" class="tableyazi" >#order_number#</a></td>
						<td style="text-align:right;">#TLFormat(grosstotal)#</td>
						<td>#order_head#</td>
						<td> <cfif len(partner_id)>#get_partner_detail.nickname[listfind(partner_id_list,get_order_list.partner_id,',')]# -  #get_partner_detail.company_partner_name[listfind(partner_id_list,get_order_list.partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(partner_id_list,get_order_list.partner_id,',')]#</cfif></td>
						<td>#employee_name# #employee_surname#</td>
						<td>#dateformat(ORDER_DATE,dateformat_style)# - #dateformat(DELIVERDATE,dateformat_style)#</td>
						<td><font color="#get_commethod.color#">#get_commethod.priority#</font></td>
						<td style="text-align:right;">#TLFormat(get_order_list.GROSSTOTAL)# #session.ep.money#</td>
					</tr>
				</cfoutput> 
			<cfelse>
				<tr>
					<td colspan="10"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.kayıt yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>

	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.currency_id") and len(attributes.currency_id)>
			<cfset url_str = "#url_str#&currency_id=#attributes.currency_id#">
		</cfif>
		<cfif isdefined("attributes.employee_id_new")>
			<cfset url_str = "#url_str#&employee_id_new=#attributes.employee_id_new#">
		</cfif>
		<cfif len(attributes.member_id) and len(attributes.member_name)>
			<cfset url_str="#url_str#&member_id=#attributes.member_id#&member_name=#attributes.member_name#">
		</cfif>
		<cfif len(attributes.consumer_id) and len(attributes.member_name)>
			<cfset url_str="#url_str#&consumer_id=#attributes.consumer_id#&member_name=#attributes.member_name#">
		</cfif>
		<cfset url_str = "#url_str#&is_submitted=1">
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_orders_list#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
<script type="text/javascript">
function ekle(order_no,order_head)
{
	<cfif isDefined("attributes.field_id")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_id#</cfoutput>.value=order_no;
	</cfif>
	<cfif isDefined("attributes.field_name")>
		<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.field_name#</cfoutput>.value=order_head;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
