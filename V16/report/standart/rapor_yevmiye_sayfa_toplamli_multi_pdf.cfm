<cfsetting showdebugoutput="no"> 
<cfprocessingdirective suppresswhitespace="yes">
<cfflush interval="3000">
<!---  buranin sirasina dokunmayin!!!!  --->
<cfset yevmiye_borc=0>
<cfset yevmiye_alacak=0>
<cf_date tarih="attributes.date1">
<cf_date tarih="attributes.date2">
<cfset date1 = dateformat(attributes.date1,dateformat_style)>
<cfset date2 = dateformat(attributes.date2,dateformat_style)>
<cfquery name="GET_CARD_ID" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT 
		*
	FROM
		GET_ACCOUNT_CARD
	<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
	WHERE 
		ACTION_DATE <= #attributes.date2# 
		AND ACTION_DATE>=#attributes.date1#
	</cfif>
	ORDER BY
		ACTION_DATE,
		BILL_NO
</cfquery>
<cfset pdf_sayisi=ceiling(GET_CARD_ID.recordcount/pdf_row_count)-1> 
<cfloop from="0" to="#pdf_sayisi#" index="k">
	<cfset satir_sayisi = 0>
	<cfset filename = "#k#_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
	<cfdocument format="pdf" filename="#upload_folder#account/fintab/#filename#.pdf" orientation="portrait" backgroundvisible="false" pagetype="#pagetype_#">
	<style type="text/css">table{font-size:4px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : #333333;}</style>
	<table cellpadding="2" cellspacing="1" width="98%" border="0">
		<tr style="font:'Courier New', Courier, mono;font-size:7px">
		  <td nowrap><cf_get_lang dictionary_id='39373.Yevmiye No'></td>
		  <td><cf_get_lang dictionary_id='47299.Hesap Kodu'></td>
		  <td><cf_get_lang dictionary_id='55271.Hesap Adı'></td>
		  <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
		  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57771.Detay'></td>
		  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
		  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
		</tr>
	<cfset satir_sayisi = satir_sayisi + 1>
	<cfif GET_CARD_ID.RECORDCOUNT>
		<cfset start_row = (k*8000) + 1>
		<cfoutput query="GET_CARD_ID" startrow="#start_row#" maxrows="8000"> 
			<cfswitch expression="#CARD_TYPE#">
				<cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1 ></cfcase>
				<cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
				<cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
				<cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
				<cfcase value="19"><cfset TYPE = 'KAPANIS'></cfcase>
			</cfswitch>
			<cfif currentrow eq 1 or GET_CARD_ID.CARD_ID[currentrow] neq GET_CARD_ID.CARD_ID[currentrow-1]>
				<cfset satir_sayisi = satir_sayisi + 1>
				<tr style="font:'Courier New', Courier, mono;font-size:7px">
					<td>#GET_CARD_ID.BILL_NO#</td>
					<td colspan="2">___#dateformat(GET_CARD_ID.ACTION_DATE,dateformat_style)#___</td>
					<td>Fiş Tipi:#TYPE#___</td>
					<td colspan="3">&nbsp;</td>		
				</tr>
				<cfif ((satir_sayisi mod 76) eq 1) or GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount>
					<tr style="font:'Courier New', Courier, mono;font-size:7px">
					<td>&nbsp;</td>
					<td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
					<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
					<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
					</tr>
					</table>
					<cfif not (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount)>
						<cfdocumentitem type="pagebreak"/>
						<table cellpadding="2" cellspacing="1" border="0" width="98%">
						<tr style="font:'Courier New', Courier, mono;font-size:7px">
							<td colspan="5"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
						</tr>
					</cfif> 
				</cfif>
			</cfif>
			<cfset satir_sayisi = satir_sayisi + 1> <!--- fis satırı yazılacak,satır_sayisi arttırılıyor --->
			<tr style="font:'Courier New', Courier, mono;font-size:7px">
				<td>&nbsp;</td>
 				<td>#ACCOUNT_ID#</td>
				<td>#left(ACCOUNT_NAME,22)#</td>
				<td>#left(DETAIL,22)#</td>
				<td align="right" style="text-align:right;">&nbsp;#TLFormat(AMOUNT)#</td>
				<td align="right" style="text-align:right;">&nbsp;<cfif BA eq 0>#TLFormat(AMOUNT)#<cfset yevmiye_borc=yevmiye_borc+AMOUNT></cfif></td>
				<td align="right" style="text-align:right;">&nbsp;<cfif BA eq 1>#TLFormat(AMOUNT)#<cfset yevmiye_alacak = yevmiye_alacak + AMOUNT></cfif></td>
		  </tr>
		<cfif ((satir_sayisi mod 76) eq 1) or GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount>
				<tr style="font:'Courier New', Courier, mono;font-size:7px">
				<td>&nbsp;</td><!---  --->
				<td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
				<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
				<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
				</tr>
				</table>
			<cfif not( GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount)>
				<cfdocumentitem type="pagebreak"/>
			 	<table cellpadding="2" cellspacing="1" border="0" width="98%">
				<tr style="font:'Courier New', Courier, mono;font-size:7px">
				  <td nowrap>&nbsp;</td>
				  <td><cf_get_lang dictionary_id='47299.Hesap Kodu'></td>
				  <td><cf_get_lang dictionary_id='55271.Hesap Adı'></td>
				  <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
				  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57771.Detay'></td>
				  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
				  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
				</tr>
				<tr style="font:'Courier New', Courier, mono;font-size:7px">
					<td colspan="5"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
					<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
					<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
				</tr>
			</cfif> 
		</cfif>
	</cfoutput> 
	</cfif>
	</table> 
	</cfdocument>
	 <script type="text/javascript">
		<cfoutput>windowopen('#user_domain#documents/account/fintab/#filename#.pdf','list');</cfoutput>
	</script>
</cfloop>
</cfprocessingdirective>

