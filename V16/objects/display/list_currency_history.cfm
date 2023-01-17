<cf_xml_page_edit fuseact="objects.popup_list_currency_history">
<cfparam name="attributes.starting_date" default="">
<cfparam name="attributes.finishing_date" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.money" default="">
<cfif isdate(attributes.finishing_date) and len(attributes.finishing_date)>
	<cf_date tarih = "attributes.finishing_date">
<cfelse>
	<cfset attributes.finishing_date = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdate(attributes.starting_date) and len(attributes.starting_date)>
	<cf_date tarih = "attributes.starting_date">
<cfelse>
	<cfset attributes.starting_date = attributes.finishing_date>
</cfif>
<cfif len(attributes.starting_date) or len(attributes.finishing_date)>
	<cfquery name="GET_CURRENCY" datasource="#DSN#">
		SELECT
			MH.MONEY,
			MH.VALIDATE_DATE RECORD_DATE,<!--- eski kayıtlara bakmak için geçerlilk tarihinden bakılır --->
			MH.RATE2,
			MH.RATE3,
			MH.RATEPP2,
			MH.RATEPP3,
			MH.RATEWW2,
			MH.RATEWW3,
			MH.EFFECTIVE_SALE,
			MH.EFFECTIVE_PUR,
			MH.RECORD_EMP,
			0 M_TYPE
		FROM
			MONEY_HISTORY MH
		WHERE
			MH.MONEY <> '#session.ep.money#' AND
			MH.COMPANY_ID = #session.ep.company_id# AND
			MH.PERIOD_ID = #session.ep.period_id#
		<cfif isdefined('attributes.money') and len(attributes.money)>
			AND MH.MONEY='#attributes.money#'
		</cfif>	
		<cfif len(attributes.starting_date)>
			AND MH.VALIDATE_DATE >= #attributes.starting_date#
		</cfif>
		<cfif len(attributes.finishing_date)>
			AND MH.VALIDATE_DATE < #DATEADD('d',1,attributes.finishing_date)#
		</cfif>	
		ORDER BY
			MH.VALIDATE_DATE
	</cfquery>
<cfelse>
	<cfquery name="GET_CURRENCY" datasource="#DSN#">
		SELECT
			SM.MONEY,
			<cfif database_type is 'MSSQL'>
				ISNULL(SM.UPDATE_DATE,SM.RECORD_DATE) RECORD_DATE,
			<cfelseif database_type is 'DB2'>
				COALESCE(SM.UPDATE_DATE,SM.RECORD_DATE) RECORD_DATE,
			</cfif>
			<!--- ISNULL(SM.UPDATE_DATE,SM.RECORD_DATE) RECORD_DATE, --->
			SM.RATE2,
			SM.RATE3,
			SM.RATEPP2,
			SM.RATEPP3,
			SM.RATEWW2,
			SM.RATEWW3,
			SM.EFFECTIVE_SALE,
			SM.EFFECTIVE_PUR,
			<cfif database_type is 'MSSQL'>
				ISNULL(SM.UPDATE_EMP,SM.RECORD_EMP) RECORD_EMP,
			<cfelseif database_type is 'DB2'>
				COALESCE(SM.UPDATE_EMP,SM.RECORD_EMP) RECORD_EMP,
			</cfif>
			<!--- ISNULL(SM.UPDATE_EMP,SM.RECORD_EMP) RECORD_EMP, --->
			1 M_TYPE
		FROM
			SETUP_MONEY AS SM
		WHERE
			SM.MONEY <> '#session.ep.money#' AND
			SM.PERIOD_ID = #session.ep.period_id#
		<cfif len(attributes.money)>
			AND SM.MONEY='#attributes.money#'
		</cfif>
		ORDER BY
			MONEY_ID
	</cfquery>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_currency.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('','Kur Bilgileri',57674)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="list_currency" id="list_currency" method="post" action="#request.self#?fuseaction=objects.popup_list_currency_history">
		<cf_box_search>
			<div class="form-group" id="money">
				<cfinclude template="../query/get_money.cfm">
				<select name="money" id="money">
					<option  value=""><cf_get_lang dictionary_id='57489.Para Br'></option>
					<cfif get_money2.recordcount >
					<cfoutput query="get_money2" >
						<option  value="#money#" <cfif attributes.money eq money>selected</cfif>>#money#</option>
					</cfoutput>
					</cfif>
				</select>
			</div> 
			<div class="form-group" id="money">
				<div class="input-group">
					<cfinput type="text" name="starting_date" value="#dateformat(attributes.starting_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
					<span class="input-group-addon"><cf_wrk_date_image date_field="starting_date"></span>
				</div>
			</div>
			<div class="form-group" id="money">
				<div class="input-group">
					<cfinput type="text" name="finishing_date" value="#dateformat(attributes.finishing_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
					<span class="input-group-addon"><cf_wrk_date_image date_field="finishing_date"></span>
				</div>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_currency' , #attributes.modal_id#)"),DE(""))#">
			</div>
			<div class="form-group">
				<cfif get_module_user(16)>  
					<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=finance.list_currencies&event=add</cfoutput>');" class="ui-btn ui-btn-gray"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='54259.Alt Hesap Ekle'>"></i></a>
				</cfif>
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th><cfif get_currency.m_type eq 0><cf_get_lang dictionary_id='58624.Gecerlilik Tarihi'><cfelse><cf_get_lang dictionary_id='57742.Tarih'></cfif></th>
				<th><cf_get_lang dictionary_id='33032.Para'></th>
				<cf_get_lang_set module_name="finance">
					<th><cf_get_lang dictionary_id='30028.Alış Kuru'></th>
					<th><cf_get_lang dictionary_id='30014.Satış Kuru'></th>
					<th><cf_get_lang dictionary_id='58945.Efektif'> <cf_get_lang dictionary_id='30028.Alış Kuru'></th>
					<th><cf_get_lang dictionary_id='58945.Efektif'> <cf_get_lang dictionary_id='30014.Satış Kuru'></th>
				<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">  
				<cfif partner_kur_is_show eq 1>
					<th><cf_get_lang dictionary_id ='33733.Partner Alış'></th>
					<th><cf_get_lang dictionary_id ='33734.Partner Satış'></th>
				</cfif>
				<cfif public_kur_is_show eq 1>
					<th><cf_get_lang dictionary_id='33735.Public Alış'></th>
					<th><cf_get_lang dictionary_id='33736.Public Satış'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_currency.recordcount>
				<cfoutput query="get_currency" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#dateformat(date_add('h', session.ep.time_zone,record_date),dateformat_style)#</td>
					<td>#get_currency.money#</td>
					<td class="text-right">#TLFormat(rate3,session.ep.our_company_info.rate_round_num)#</td>
					<td class="text-right">#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#</td>
					<td class="text-right">#TLFormat(effective_pur,session.ep.our_company_info.rate_round_num)#</td>
					<td class="text-right">#TLFormat(effective_sale,session.ep.our_company_info.rate_round_num)#</td>
					<cfif partner_kur_is_show eq 1>
					<td class="text-right">#TLFormat(ratepp3,session.ep.our_company_info.rate_round_num)#</td>
					<td class="text-right">#TLFormat(ratepp2,session.ep.our_company_info.rate_round_num)#</td>
					</cfif>
					<cfif public_kur_is_show eq 1>
					<td class="text-right">#TLFormat(rateww3,session.ep.our_company_info.rate_round_num)#</td>
					<td class="text-right">#TLFormat(rateww2,session.ep.our_company_info.rate_round_num)#</td>
					</cfif>
					<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#');">#get_emp_info(record_emp,0,0)#</a></td>
				</tr>
				</cfoutput>
			<cfelse>
				<tr class="color-row" height="20">
				<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset adres="">
		<cfif len(attributes.keyword)>
			<cfset adres="#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.starting_date)>
			<cfset adres="#adres#&starting_date=#dateformat(attributes.starting_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.finishing_date)>
			<cfset adres="#adres#&finishing_date=#dateformat(attributes.finishing_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.money)>
			<cfset adres="#adres#&money=#attributes.money#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_list_currency_history&#adres#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
