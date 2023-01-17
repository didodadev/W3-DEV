<!--- Sayfada; yevmiye raporunun olusturacağı pdf dosyasının sayfa sayısını ve içereceği muhasebe fis sayısı bilgileri gösterilir --->
<cf_date tarih="attributes.date1">
<cf_date tarih="attributes.date2">
<cfquery name="GET_ACCOUNT_CARD" datasource="#dsn2#">
	SELECT 	
		COUNT(ACC.CARD_ID) AS FIS_SAYISI
	FROM
		ACCOUNT_CARD ACC
	<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
	WHERE
		ACC.ACTION_DATE <= #attributes.date2# 
		AND ACC.ACTION_DATE>=#attributes.date1#
	</cfif>
</cfquery>
<cfset pdf_row=1>
<cfif GET_ACCOUNT_CARD.recordcount>
	<cfif isdefined('attributes.yevmiye_report_type') and listfind('2,3',attributes.yevmiye_report_type)>
		<cfset pdf_row = pdf_row + GET_ACCOUNT_CARD.FIS_SAYISI><!--- fislerin yevmiye no-tarih bilgilerinin tutuldugu satır sayısı ekleniyor --->
	<cfelseif isdefined('attributes.yevmiye_report_type') and listfind('4,5,6',attributes.yevmiye_report_type)>
		<cfset pdf_row = pdf_row + (GET_ACCOUNT_CARD.FIS_SAYISI*3)>	
	<cfelse>
		<cfset pdf_row = pdf_row + (GET_ACCOUNT_CARD.FIS_SAYISI*2)><!--- fislerin yevmiye no-tarih  ve fis toplam satırlarının sayısı ekleniyor --->
	</cfif>
	<cfif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 4>
		<cfquery name="GET_ALL_CARD_ROWS" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT 
				SUM(AMOUNT) AS AMOUNT,
				BA,
				ACTION_DATE,
				BILL_NO,
				CARD_TYPE,
				CARD_TYPE_NO,
				CARD_ID,	
				ACCOUNT_NAME,
				PAPER_NO,
				ACTION_TYPE,
				CARD_DETAIL,
				ACCOUNT_ID,
				DETAIL	
			FROM
				GET_ACCOUNT_CARD
			<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
			WHERE 
				ACTION_DATE <= #attributes.date2# 
				AND ACTION_DATE >= #attributes.date1#
			</cfif>
			GROUP BY
				CARD_ID,
				BILL_NO,
				ACCOUNT_ID,
				BA,
				ACTION_DATE,
				CARD_TYPE,
				CARD_TYPE_NO,	
				ACCOUNT_NAME,
				PAPER_NO,
				ACTION_TYPE,
				CARD_DETAIL,
				DETAIL	
			ORDER BY
				ACTION_DATE,
				BILL_NO
		</cfquery>
		<cfquery name="GET_ACCOUNT_CARD_ROWS" dbtype="query">
			SELECT 		
				COUNT(CARD_ID) AS SATIR_SAYISI	
			FROM
				GET_ALL_CARD_ROWS
		</cfquery>
	<cfelseif isdefined('attributes.yevmiye_report_type') and listfind('5,7',attributes.yevmiye_report_type)>		
		<cfquery name="GET_ALL_CARD_ROWS" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT 
				SUM(AMOUNT) AS AMOUNT,
				TOP_ACCOUNT_NAME AS ACCOUNT_NAME,
				TOP_ACCOUNT_CODE AS ACCOUNT_ID,
				CARD_DETAIL AS DETAIL,
				BA,
				ACTION_DATE,
				BILL_NO,
				CARD_TYPE,
				CARD_TYPE_NO,
				CARD_ID,	
				PAPER_NO,
				ACTION_TYPE
			FROM
				GET_ACCOUNT_CARD_GROUP
			<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
			WHERE 
				ACTION_DATE <= #attributes.date2# 
				AND ACTION_DATE>=#attributes.date1#
			</cfif>
			GROUP BY
				CARD_ID,
				BILL_NO,
				TOP_ACCOUNT_NAME,
				BA,
				ACTION_DATE,
				CARD_TYPE,
				CARD_TYPE_NO,	
				TOP_ACCOUNT_CODE,
				PAPER_NO,
				ACTION_TYPE,
				CARD_DETAIL
			ORDER BY
				ACTION_DATE,
				BILL_NO
		</cfquery>	
		<cfquery name="GET_ACCOUNT_CARD_ROWS" dbtype="query">
			SELECT 		
				COUNT(CARD_ID) AS SATIR_SAYISI	
			FROM
				GET_ALL_CARD_ROWS
		</cfquery>
	<cfelse>
		<cfquery name="GET_ACCOUNT_CARD_ROWS" datasource="#dsn2#">
			SELECT 		
				COUNT(ACR.CARD_ID) AS SATIR_SAYISI	
			FROM
				ACCOUNT_CARD_ROWS ACR,
				ACCOUNT_CARD ACC
			WHERE
				ACC.CARD_ID=ACR.CARD_ID
			<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
				AND ACC.ACTION_DATE <= #attributes.date2# 
				AND ACC.ACTION_DATE >= #attributes.date1#
			</cfif>
		</cfquery>
	</cfif>
 	<cfif GET_ACCOUNT_CARD_ROWS.recordcount>
		<cfif isdefined('attributes.yevmiye_report_type') and listfind('2,3',attributes.yevmiye_report_type)>
			<cfset pdf_row = pdf_row + (GET_ACCOUNT_CARD_ROWS.SATIR_SAYISI*2)><!---muhasebe fisi satırları ve ust hesap bilgilerinin gosterildigi satırlar ekleniyor --->
		<cfelseif  isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 7>
			<cfset pdf_row = pdf_row + (GET_ACCOUNT_CARD_ROWS.SATIR_SAYISI*1.8)>
		<cfelseif  isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 6>
			<cfset pdf_row = pdf_row + (GET_ACCOUNT_CARD_ROWS.SATIR_SAYISI*1.8)>			
		<cfelse>
			<cfset pdf_row = pdf_row + GET_ACCOUNT_CARD_ROWS.SATIR_SAYISI><!--- fislerin yevmiye no-tarih bilgilerinin tutuldugu satır sayısı ekleniyor --->
		</cfif>
	</cfif>
</cfif>
<cfif isdefined('attributes.row_number') and len(attributes.row_number)>
	<cfset pdf_page_break_number=attributes.row_number>
<cfelse>
	<cfset pdf_page_break_number=55>
</cfif>
<cfif isdefined('attributes.yevmiye_report_type') and listfind('2,3',attributes.yevmiye_report_type)><!--- ust hesap bilgili yevmiye raporu --->
	<cfset avg_pdf_page = pdf_row/pdf_page_break_number>
	<cfset pdf_row = pdf_row + (avg_pdf_page*2)><!--- sayfaların sonundaki devreden ve kumule toplam satırları ekleniyor --->
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 4><!--- hesap bazında yevmiye raporu --->
	<cfset avg_pdf_page = pdf_row/pdf_page_break_number>
	<cfset pdf_row = pdf_row + avg_pdf_page><!--- sayfaların sonundaki kumule toplam satırları ekleniyor --->
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 5><!--- ust hesap bazında yevmiye raporu --->
	<cfset avg_pdf_page = pdf_row/pdf_page_break_number>
	<cfset pdf_row = pdf_row + avg_pdf_page><!--- sayfaların sonundaki kumule toplam satırları ekleniyor --->
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 7><!--- yevmiye no bazında yevmiye raporu --->
	<cfset avg_pdf_page = pdf_row/pdf_page_break_number>
	<cfset pdf_row = pdf_row + avg_pdf_page><!--- sayfaların sonundaki kumule toplam satırları ekleniyor --->
<cfelseif isdefined('attributes.yevmiye_report_type') and attributes.yevmiye_report_type eq 6><!--- standart dokum yevmiye raporu --->
	<cfset avg_pdf_page = pdf_row/pdf_page_break_number>
	<cfset pdf_row = pdf_row + avg_pdf_page><!--- sayfaların sonundaki kumule toplam satırları ekleniyor --->
</cfif>
<cfif pdf_row lte pdf_page_break_number>
	<cfset pdf_page_count = 1>
<cfelseif (pdf_row mod pdf_page_break_number) gt 0>
	<cfset pdf_page_count = wrk_round(pdf_row/pdf_page_break_number)+1>
<cfelse>
	<cfset pdf_page_count = wrk_round(pdf_row/pdf_page_break_number)>
</cfif>
<table cellspacing="1" cellpadding="2" border="0" height="100%" width="100%" class="color-border">
	  <tr class="color-list">
		<td height="35" class="headbold">Yevmiye Raporu Özet Bilgisi</td>
	  </tr>
      <tr class="color-row" valign="top">
		<td>
			<ul>
				<li>Yevmiye Defteri <strong><cfoutput>#GET_ACCOUNT_CARD.FIS_SAYISI#</cfoutput></strong> muhasebe fişinden oluşmaktadır.</li>
				<li>Oluşturulacak yevmiye defteri yaklaşık <strong><cfoutput>#TLFormat(pdf_page_count,0,0)#</cfoutput></strong> sayfadır.</li>
				<li>Oluşacak sayfa sayısı, font boyutu olarak <strong>8 px</strong> seçildiği takdirde sağlıklı sonuçlar verir.</li>
				<li>Font boyutu daha yüksek seçilirse oluşan pdf sayısı ile özet bilgide gösterilen pdf sayısı farklılık gösterebilir.</li>
				<li>Satır sayısı 55 den düşük seçilirse oluşan pdf sayısı ile özet bilgide gösterilen pdf sayısı farklılık gösterebilir.</li>				
			</ul> 
		</td>
  </tr>
</table>
