<!--- kumulatif toplamlar standart döküm oldugu icin kaldırıldı. --->
<cfprocessingdirective suppresswhitespace="yes">
	<cfscript>
		yevmiye_borc=0;
		yevmiye_alacak=0;
		yevmiye_borc_dev=0;
		yevmiye_alacak_dev=0;
		satir_sayisi=0;
		bastan = 0;
	</cfscript>
		<cf_date tarih="attributes.date1">
		<cf_date tarih="attributes.date2">
		<cfset date1 = dateformat(attributes.date1,dateformat_style)>
		<cfset date2 = dateformat(attributes.date2,dateformat_style)>
	<cfquery name="GET_CARD_ID" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
	<cfif isdefined('attributes.is_detail')>
		SELECT 
			CARD_ID, 
			ACTION_DATE,
			BILL_NO,
			CARD_TYPE,
			CARD_TYPE_NO,		
			PAPER_NO,
			ACTION_TYPE,
			CARD_DETAIL,
			COMPANY.FULLNAME AS CARI_HESAP,
			COMPANY.TAXOFFICE AS VERGI_DAIRESI,
			COMPANY.TAXNO AS VERGI_NO,
			COMPANY.IS_RELATED_COMPANY AS BAGLI_UYE
		FROM
			ACCOUNT_CARD,
			#dsn_alias#.COMPANY COMPANY
		WHERE 
			ACC_COMPANY_ID = COMPANY.COMPANY_ID AND 
			ACC_COMPANY_ID IS NOT NULL 
		<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
			AND (
			<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
				(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
				<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
			</cfloop>  
				)
		</cfif>				
		<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
			AND ACTION_DATE <= #attributes.date2# 
			AND ACTION_DATE>=#attributes.date1#
		</cfif>
	UNION 
		SELECT 
			CARD_ID, 
			ACTION_DATE,
			BILL_NO,
			CARD_TYPE,
			CARD_TYPE_NO,		
			PAPER_NO,
			ACTION_TYPE,
			CARD_DETAIL,
			(CONSUMER.CONSUMER_NAME + CONSUMER.CONSUMER_SURNAME) AS CARI_HESAP,
			CONSUMER.TAX_OFFICE AS VERGI_DAIRESI,
			TAX_POSTCODE AS VERGI_NO,
			CONSUMER.IS_RELATED_CONSUMER AS BAGLI_UYE
			
		FROM
			ACCOUNT_CARD,	
			#dsn_alias#.CONSUMER CONSUMER
		WHERE 	
			ACC_CONSUMER_ID = CONSUMER.CONSUMER_ID 
			AND ACC_CONSUMER_ID IS NOT NULL
		<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
			AND (
			<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
				(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
				<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
			</cfloop>  
				)
		</cfif>				
		<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
			AND ACTION_DATE <= #attributes.date2# 
			AND ACTION_DATE>=#attributes.date1#
		</cfif>
	UNION 
	</cfif>
		SELECT 
			CARD_ID, 
			ACTION_DATE,
			BILL_NO,
			CARD_TYPE,
			CARD_TYPE_NO,
			PAPER_NO,
			ACTION_TYPE,
			CARD_DETAIL,
			'' AS CARI_HESAP,
			'' AS VERGI_DAIRESI,
			'' AS VERGI_NO,
			2 AS BAGLI_UYE
			
		FROM
			ACCOUNT_CARD 
		WHERE
			CARD_ID IS NOT NULL
		<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
			AND (
			<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
				(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
				<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
			</cfloop>  
				)
		</cfif>				
		<cfif isdefined('attributes.is_detail') and attributes.is_detail eq 1>
			AND ACC_CONSUMER_ID IS NULL
			AND ACC_COMPANY_ID IS NULL 
		</cfif>
		<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
			AND ACTION_DATE <= #attributes.date2# 
			AND ACTION_DATE>=#attributes.date1#
		</cfif>
		ORDER BY
			BILL_NO ASC,
			CARD_TYPE
	</cfquery>
</cfprocessingdirective>

<cf_report_list>
	<thead>
		<tr>
			<td colspan="6" align="center"><strong><cf_get_lang dictionary_id='39033.YEVMİYE RAPORU'></strong></td>
		</tr>
		<tr>
			<td nowrap style="width:120px;"></td>
			<td style="width:160px;"><cf_get_lang dictionary_id='38889.Hesap Kodu'></td>
			<td><cf_get_lang dictionary_id='38890.Hesap Adı'></td>
			<td><cf_get_lang dictionary_id='57629.Açıklama'></td>
			<td align="right" style="width:100px;"><cf_get_lang dictionary_id='57587.Borç'></td>
			<td align="right" style="width:100px;"><cf_get_lang dictionary_id='57588.Alacak'></td>
		</tr>
	</thead>
	
	<cfset satir_sayisi = satir_sayisi + 1>
	<cfset total_ = get_card_id.recordcount>
	<tbody>
		<cfif GET_CARD_ID.RECORDCOUNT>
			<cfloop from="1" to="#total_#" index="I">
				 <cfset A_toplam=0>
				 <cfset B_toplam=0>
				 <cfquery name="GET_CARD_ROWS" datasource="#DSN2#">
					 SELECT 
						 ACR.AMOUNT,
						 ACR.BA,
						 ACR.DETAIL,
						 <cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)>
						 AP.IFRS_CODE AS ACCOUNT_ID,
						 AP.IFRS_NAME AS ACCOUNT_NAME
						 <cfelse>
						 ACR.ACCOUNT_ID,
						 AP.ACCOUNT_NAME
						 </cfif>
					 FROM 
						 ACCOUNT_CARD_ROWS ACR, 
						 ACCOUNT_PLAN AP 
					 WHERE 
						 CARD_ID = #GET_CARD_ID.CARD_ID[I]# AND 
						 AP.ACCOUNT_CODE=ACR.ACCOUNT_ID
					 ORDER BY 
						 BA
				 </cfquery>
				 <cfset TARIH=dateformat(GET_CARD_ID.ACTION_DATE[I],dateformat_style)>
				 <cfset NO=GET_CARD_ID.BILL_NO[I]>
				 <cfset TYPE_NO=GET_CARD_ID.CARD_TYPE_NO[I]>
				 <cfset CARD_TYPE=GET_CARD_ID.CARD_TYPE[I]>
				 <cfswitch expression="#CARD_TYPE#">
					 <cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1 ></cfcase>
					 <cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
					 <cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
					 <cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
					 <cfcase value="19"><cfset TYPE = 'KAPANIS'></cfcase>
				 </cfswitch>
				 <tr>
					 <cfset satir_sayisi = satir_sayisi + 1>
					 <td colspan="6" align="center">
					 <cfoutput>___________#TARIH#____________</cfoutput>
					 </td>
				 </tr>
			 <cfset is_new_acc_card=1>
			 <cfoutput query="GET_CARD_ROWS">
				 <cfif satir_sayisi neq 1 and (satir_sayisi mod pdf_page_row) eq 1>
					 <tr>
						 <cfif is_new_acc_card eq 1 or bastan eq 1><td style="width:120px;">&nbsp;</td></cfif>
						 <td colspan="3"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
						 <td align="right" style="width:100px;">#tlformat(yevmiye_borc)#</td>
						 <td align="right" style="width:100px;">#tlformat(yevmiye_alacak)#</td>
					 </tr>
					 
				 </cfif>
				 <tr>
					 <cfset satir_sayisi = satir_sayisi + 1>
					 <cfif is_new_acc_card eq 1>
					   <td rowspan="#GET_CARD_ROWS.RECORDCOUNT#" valign="top" style="width:120px;">
						   <cf_get_lang dictionary_id='39373.YEVMİYE NO'>:#GET_CARD_ID.BILL_NO[I]# <br/>
						 <cfif len(TYPE_NO)>#TYPE# <cf_get_lang dictionary_id='57946.Fiş No'>: #TYPE_NO#</cfif>
						 <cfif isdefined('attributes.is_detail')>
							 <br/><cf_get_lang dictionary_id='57880.Belge No'>: <cfif len(GET_CARD_ID.PAPER_NO[I])>#GET_CARD_ID.PAPER_NO[I]#</cfif>
							 <cfif len(GET_CARD_ID.CARI_HESAP[I])>
								 <br/>#GET_CARD_ID.CARI_HESAP[I]#
								 <br/><cf_get_lang dictionary_id='58762.Vergi D.'>/ <cf_get_lang dictionary_id='57487.No'> : <cfif len(GET_CARD_ID.VERGI_DAIRESI[I])>#GET_CARD_ID.VERGI_DAIRESI[I]#</cfif> <cfif len(GET_CARD_ID.VERGI_NO[I])>-#GET_CARD_ID.VERGI_NO[I]#</cfif>
							 </cfif>
						 </cfif>
						 <cfset bastan = 0>
					   </td>
					 </cfif>
					 <cfif bastan eq 1><td style="width:120px;">&nbsp;</td></cfif>
					 <cfset is_new_acc_card =0>
					 <td style="width:160px;">#GET_CARD_ROWS.ACCOUNT_ID#</td>
					 <td>#left(ACCOUNT_NAME,attributes.character_account_code)#</td>
					 <td>#left(DETAIL,attributes.character_detail)#</td>
					 <td align="right" style="width:100px;">&nbsp;<cfif BA eq 0>#TLFormat(GET_CARD_ROWS.AMOUNT)#<cfset yevmiye_borc=yevmiye_borc+GET_CARD_ROWS.AMOUNT><cfset B_toplam = B_toplam + GET_CARD_ROWS.amount ></cfif></td>
					 <td align="right" style="width:100px;">&nbsp;<cfif BA eq 1>#TLFormat(GET_CARD_ROWS.AMOUNT)#<cfset yevmiye_alacak = yevmiye_alacak + GET_CARD_ROWS.AMOUNT ><cfset A_toplam = A_toplam + GET_CARD_ROWS.amount ></cfif></td>
				 </tr>
			 </cfoutput>
			 <cfif satir_sayisi neq 1 and (satir_sayisi mod pdf_page_row) eq 1>
				 <tr>
					 <td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
					 <td align="right" style="width:100px;"><cfoutput>#TLFormat(yevmiye_borc)#</cfoutput></td>
					 <td align="right" style="width:100px;"><cfoutput>#TLFormat(yevmiye_alacak)#</cfoutput></td>
				 </tr>
				
			 </cfif>
			 <tr>
				 <cfset satir_sayisi = satir_sayisi + 1>
				 <td colspan="6" align="center"> <cfoutput> #TYPE_NO# <cf_get_lang dictionary_id='47357.NOLU'> #TYPE# <cf_get_lang dictionary_id='47356.FİŞİNDEN'> </cfoutput> </td>
			 </tr>
			 <cfif GET_CARD_ROWS.currentrow neq 1 and (satir_sayisi mod pdf_page_row) eq 1>
				 <tr>
					 <td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
					 <td align="right" style="width:100px;"><cfoutput>#TLFormat(yevmiye_borc)#</cfoutput></td>
					 <td align="right" style="width:100px;"><cfoutput>#TLFormat(yevmiye_alacak)#</cfoutput></td>
				 </tr>
				 
			 </cfif>
			 <tr>
				 <cfset satir_sayisi = satir_sayisi + 1>
			   <td colspan="4"><cf_get_lang dictionary_id='57492.Toplam'></td>
			   <td align="right" style="width:100px;"><cfoutput>#TLFormat(A_toplam)#</cfoutput></td>
			   <td align="right" style="width:100px;"><cfoutput>#TLFormat(B_toplam)#</cfoutput></td>
			 </tr>
			 <cfif satir_sayisi neq 1 and (satir_sayisi mod pdf_page_row) eq 1>
				 <tr>
					 <td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
					 <td align="right" style="width:100px;"><cfoutput>#TLFormat(yevmiye_borc)#</cfoutput></td>
					 <td align="right" style="width:100px;"><cfoutput>#TLFormat(yevmiye_alacak)#</cfoutput></td>
				 </tr>
				
			 </cfif>
			 <cfif i eq total_>
				 <tr>
					 <td colspan="4"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
					 <td align="right" style="width:100px;"><cfoutput>#TLFormat(yevmiye_borc)#</cfoutput></td>
					 <td align="right" style="width:100px;"><cfoutput>#TLFormat(yevmiye_alacak)#</cfoutput></td>
				 </tr>			
			 </cfif>
		   </cfloop>
		 </cfif>
	</tbody>	
</cf_report_list>
<script>
	$("#play").hide();
	$(".catalyst-share-alt").hide();
	$(".catalyst-eye").hide();
</script>
