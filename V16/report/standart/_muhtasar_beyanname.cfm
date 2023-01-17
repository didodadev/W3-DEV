<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfif isdefined("attributes.is_form")>
	<cfparam name="attributes.page" default=1>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfquery name="get_muhtasar" datasource="#dsn2#">
		SELECT
			EIP.TAX_CODE,
			EIP.EXPENSE_DATE DATE_,
			EIP.PAPER_NO PAPER_NO_,
			(EIP.TOTAL_AMOUNT-EIP.STOPAJ) TOTAL_VALUE,
			EIP.STOPAJ,
			SPC.PROCESS_CAT,
			CASE WHEN EIP.CH_PARTNER_ID IS NOT NULL THEN EIP.CH_PARTNER_ID ELSE EIP.CH_CONSUMER_ID END AS MEMBER_ID,
			CASE WHEN EIP.CH_PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_NAME ELSE CNS.CONSUMER_NAME END AS NAME,
			CASE WHEN EIP.CH_PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_SURNAME ELSE CNS.CONSUMER_SURNAME END AS SURNAME,
			CASE WHEN EIP.CH_PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_ADDRESS ELSE CNS.HOMEADDRESS END AS ADDRESS,
			CASE WHEN EIP.CH_PARTNER_ID IS NOT NULL THEN CP.TC_IDENTITY ELSE CNS.TC_IDENTY_NO END AS TC_NO,
			CASE WHEN EIP.CH_COMPANY_ID IS NOT NULL THEN CMP.TAXNO ELSE '' END AS TAX_NO,
			ISNULL((SELECT SUM(BEYAN_TUTAR) TEVKIFAT_TUTAR FROM INVOICE_TAXES IT WHERE IT.EXPENSE_ID = EIP.EXPENSE_ID),0) AS TEVKIFAT
		FROM
			EXPENSE_ITEM_PLANS EIP
				LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = EIP.CH_PARTNER_ID
				LEFT JOIN #dsn_alias#.COMPANY CMP ON CMP.COMPANY_ID = EIP.CH_COMPANY_ID
				LEFT JOIN #dsn_alias#.CONSUMER CNS ON CNS.CONSUMER_ID = EIP.CH_CONSUMER_ID,
			#dsn3_alias#.SETUP_PROCESS_CAT SPC
		WHERE
			EIP.TAX_CODE IS NOT NULL
			AND SPC.PROCESS_CAT_ID = EIP.PROCESS_CAT
		
		UNION ALL
		
		SELECT
			I.TAX_CODE,
			I.INVOICE_DATE DATE_,
			I.INVOICE_NUMBER PAPER_NO_,
			(I.NETTOTAL-I.STOPAJ) TOTAL_VALUE,
			I.STOPAJ,
			SPC.PROCESS_CAT,
			CASE WHEN I.PARTNER_ID IS NOT NULL THEN I.PARTNER_ID ELSE I.CONSUMER_ID END AS MEMBER_ID,
			CASE WHEN I.PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_NAME ELSE CNS.CONSUMER_NAME END AS NAME,
			CASE WHEN I.PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_SURNAME ELSE CNS.CONSUMER_SURNAME END AS SURNAME,
			CASE WHEN I.PARTNER_ID IS NOT NULL THEN CP.COMPANY_PARTNER_ADDRESS ELSE CNS.HOMEADDRESS END AS ADDRESS,
			CASE WHEN I.PARTNER_ID IS NOT NULL THEN CP.TC_IDENTITY ELSE CNS.TC_IDENTY_NO END AS TC_NO,
			CASE WHEN I.COMPANY_ID IS NOT NULL THEN CMP.TAXNO ELSE '' END AS TAX_NO,
			ISNULL((SELECT SUM(TEVKIFAT_TUTAR) TEVKIFAT_TUTAR FROM INVOICE_TAXES IT WHERE IT.INVOICE_ID = I.INVOICE_ID),0) AS TEVKIFAT
		FROM
			INVOICE I
				LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = I.PARTNER_ID
				LEFT JOIN #dsn_alias#.COMPANY CMP ON CMP.COMPANY_ID = I.COMPANY_ID
				LEFT JOIN #dsn_alias#.CONSUMER CNS ON CNS.CONSUMER_ID = I.CONSUMER_ID,
			#dsn3_alias#.SETUP_PROCESS_CAT SPC
		WHERE
			I.TAX_CODE IS NOT NULL	
			AND SPC.PROCESS_CAT_ID = I.PROCESS_CAT
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_muhtasar.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>


<table class="dph">
	<tr>
		<td class="dpht"><a href="javascript:gizle_goster_ikili('muhtasar_','muhtasar_basket');">&raquo;<cf_get_lang dictionary_id='47453.Muhtasar Beyannamesi'></a></td>
		<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module="muhtasar_basket" is_ajax="1">
	</tr>
</table>	
<cfform name="form_" method="post" action="#request.self#?fuseaction=report.muhtasar_beyanname">
	<cf_basket_form id="muhtasar_">
		<input name="is_form" id="is_form" value="1" type="hidden">
		<table>
			<tr>
				<td></td>
			</tr>
		</table>
		<cf_basket_form_button margintop="1"> 
			<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi Hatasi Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#" style="width:25px;">
			<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Çalıştır' insert_alert=''>
		</cf_basket_form_button>	
	<!-- sil -->
	</cf_basket_form>
</cfform>
<cf_basket id="muhtasar_basket">
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
	</cfif>
	<cfsavecontent variable="excel_icerik">
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<!-- sil -->
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_muhtasar.recordcount>
	</cfif>
	<table class="detail_basket_list">
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='30006.Vergi Kodu'></th>
				<th><cf_get_lang dictionary_id='57631.Ad'></th>
				<th><cf_get_lang dictionary_id='58726.Soyad'></th>
				<th><cf_get_lang dictionary_id='58723.Adres'></th>
				<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
				<th><cf_get_lang dictionary_id='57752.Vergi No'></th>
				<th><cf_get_lang dictionary_id='30006.Vergi Kodu'></th>
				<th><cf_get_lang dictionary_id='54314.Gayri Safi Tutar'>(<cf_get_lang dictionary_id='56257.Brüt'>)</th>
				<th><cf_get_lang dictionary_id='58578.Belge Türü'></th>
				<th><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th><cf_get_lang dictionary_id='57880.Belge No'></th>
				<th><cf_get_lang dictionary_id='60651.Vergi Kesinti Tutar'></th>
				<th><cf_get_lang dictionary_id='57639.KDV'> <cf_get_lang dictionary_id='58022.Tevkifatı'></th>
				<th><cf_get_lang dictionary_id='58723.Adres'> <cf_get_lang dictionary_id='57487.No'></th>
			</tr>
		</thead>
		<tbody>
			<cfif isdefined("attributes.is_form") and get_muhtasar.recordcount>
				<cfoutput query="get_muhtasar" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr class="color-row" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';">
						<td>#currentrow#</td>
						<td></td>
						<td>#name#</td>
						<td>#surname#</td>
						<td>#address#</td>
						<td>#tc_no#</td>
						<td>#tax_no#</td>
						<td>#tax_code#</td>
						<td style="text-align:right;">#tlFormat(total_value,2)#</td>
						<td>#process_cat#</td>
						<td>#dateFormat(date_,dateformat_style)#</td>
						<td>#paper_no_#</td>
						<td style="text-align:right;">#tlFormat(stopaj,2)#</td>
						<td style="text-align:right;">#tlFormat(tevkifat,2)#</td>
						<td></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td class="color-row" colspan="38"><cfif not isdefined("attributes.is_form")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</table>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<!-- sil -->
		</cfif>
	</cfsavecontent>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfoutput>#wrk_content_clear(excel_icerik)#</cfoutput>
	<cfelse>
		<cfoutput>#excel_icerik#</cfoutput>
	</cfif>	
</cf_basket>

<cfif isdefined("attributes.is_form")> 
	<cfset url_str = "report.muhtasar_beyanname&is_form=1">
	<cfif attributes.totalrecords gt attributes.maxrows>
		<table width="99%" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td><cf_pages 
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#url_str#"></td>
				<td style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			</tr>
		</table>
	 </cfif>
</cfif>


