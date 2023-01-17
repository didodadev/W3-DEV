<!--- Barbaros Sonra silinebilir 20080212 --->

<!-- sil --><table><tr><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></tr></table><!-- sil -->
<cfset filename = "#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
<cfprocessingdirective suppresswhitespace="yes">
<cfsetting enablecfoutputonly="Yes">
<cfflush interval='2000'>
<cfquery name="GET_ACCOUNT_NAME_ALL" datasource="#DSN2#">
  SELECT
	  ACCOUNT_CODE, 
	  ACCOUNT_NAME,
	  ACCOUNT_ID
  FROM 
	  ACCOUNT_PLAN 
 <cfif (isdefined('attributes.CODE1') and len(attributes.CODE1)) or (isdefined('attributes.CODE2') and len(attributes.CODE2))>
  WHERE 
 </cfif>
  <cfif isdefined('attributes.CODE1') and len(attributes.CODE1)>
	  ACCOUNT_CODE >= '#attributes.CODE1#'
  </cfif>
  <cfif isdefined('attributes.CODE1') and len(attributes.CODE1) and isdefined('attributes.CODE2') and len(attributes.CODE2)>
	   AND 
  </cfif>
  <cfif isdefined('attributes.CODE2') and len(attributes.CODE2)>
	  ACCOUNT_CODE <= '#attributes.CODE2#' 
  </cfif>
  ORDER BY 
	  ACCOUNT_CODE
</cfquery>
<!--- <cfset acc_code_list = valuelist(GET_ACCOUNT_NAME.ACCOUNT_CODE,',')>
<cfset acc_hesap_list = valuelist(GET_ACCOUNT_NAME.ACCOUNT_NAME,';')> --->

<cfquery name="get_account_id" dbtype="query">
  SELECT
  
	  ACCOUNT_CODE, 
	  ACCOUNT_NAME 
  FROM 
	  GET_ACCOUNT_NAME_ALL 
  WHERE 
	  ACCOUNT_CODE NOT LIKE '%.%' 
  ORDER BY 
	  ACCOUNT_CODE
</cfquery>

<cfquery name="GET_ACCOUNT_CARD_ROWS_ALL" datasource="#DSN2#" blockfactor="1000">
	SELECT 
		AC.BILL_NO, 
		AC.CARD_TYPE, 
		AC.CARD_TYPE_NO, 
		AC.RECORD_DATE, 
		AC.CARD_DETAIL AS DETAIL,
		AC.ACTION_DATE, 
		ACR.AMOUNT ,
		ACR.ACCOUNT_ID,
		ACR.BA
	FROM 
		ACCOUNT_CARD AC, 
		ACCOUNT_CARD_ROWS ACR 
	WHERE 
		AC.CARD_ID = ACR.CARD_ID
	<cfif isdefined('attributes.code2') and len(attributes.code2)>
		AND ACR.ACCOUNT_ID <= '#attributes.code2#' <!--- 20051026 tek bir hesabin muavinleri cekilirken hepsi secilmezse sorun olmasin diye --->
	</cfif>	
	<cfif isdefined("attributes.date1") and len(attributes.date1)>
		AND AC.ACTION_DATE >= #attributes.date1#
	</cfif>
	<cfif isdefined("attributes.date2") and len(attributes.date2)>
		AND AC.ACTION_DATE <= #attributes.date2#
	</cfif>
	ORDER BY 
		ACR.ACCOUNT_ID ASC,
		AC.BILL_NO
</cfquery>

<!--- <cfdocument format="pdf" filename="#upload_folder#account/fintab/#filename#.pdf" fontembed="yes" orientation="portrait" backgroundvisible="false" pagetype="custom" unit="cm" pageheight="29" pagewidth="21" marginleft="1" marginright="0"> --->
<table cellpadding="2" cellspacing="1" border="0" width="98%">
<cfparam name="attributes.totalrecords" default="#get_account_id.recordcount#">
<cfloop from="1" to="#attributes.totalrecords#" index="I">
	<cfset alacak_bakiye = 0>
	<cfset borc_bakiye = 0>
	<cfset bakiye = 0>
	<cfquery name="GET_ACCOUNT_CARD_ROWS" dbtype="query">
		SELECT 
			*
		FROM 
			GET_ACCOUNT_CARD_ROWS_ALL
		WHERE 
			 ACCOUNT_ID LIKE '#get_account_id.account_code[i]#%'
	</cfquery>
	<cfoutput>
		<tr>
			<td colspan="9">
				<strong><cf_get_lang no='650.Ana Hesap Kodu'> :</strong>#get_account_id.account_code[i]#&nbsp;&nbsp;&nbsp; <strong>
				<cf_get_lang no='651.Ana Hesap Adı'> :</strong> 
				<cfquery name="GET_ACCOUNT_NAME" dbtype="query">
					SELECT 
						*
					FROM 
						GET_ACCOUNT_NAME_ALL
					WHERE 
						 ACCOUNT_CODE = '#get_account_id.ACCOUNT_CODE[i]#'
				</cfquery>	
				#GET_ACCOUNT_NAME.ACCOUNT_NAME#					
				<!--- #listgetat(acc_hesap_list,listfind(acc_code_list,get_account_id.ACCOUNT_CODE[i],','),';')# ---></td>
		</tr>
	</cfoutput>
	<tr style="font:'Courier New', Courier, mono;font-size:8px">
		<td><cf_get_lang_main no='330.Tarih'></td>
		<td><cf_get_lang_main no='534.Fiş No'></td>
		<td><cf_get_lang no='652.Yev No'></td>
		<td><cf_get_lang no='168.Hesap Kodu'></td>
		<td><cf_get_lang no='169.Hesap Adı'></td>
		<td><cf_get_lang_main no='217.Açıklama'></td>
		<td align="right" style="text-align:right;"><cf_get_lang_main no='175.Borç'></td>
		<td align="right" style="text-align:right;"><cf_get_lang_main no='176.Alacak'></td>
		<td align="right" style="text-align:right;"><cf_get_lang_main no='177.Bakiye'></td>
	</tr>

	<cfoutput query="get_account_card_rows">
		<tr style="font:'Courier New', Courier, mono;font-size:8px">
			<td>#dateformat(get_account_card_rows.ACTION_DATE,dateformat_style)#</td>
			<td>#CARD_TYPE_NO#</td>
			<td>#BILL_NO#</td>
			<td>#ACCOUNT_ID#</td>
			<td nowrap>
			<cfif len(account_id)>
				<cfquery name="GET_ACCOUNT_NAME" dbtype="query">
					SELECT 
						*
					FROM 
						GET_ACCOUNT_NAME_ALL
					WHERE 
						 ACCOUNT_CODE = '#ACCOUNT_ID#'
				</cfquery>	
				#GET_ACCOUNT_NAME.ACCOUNT_NAME#	
				<!--- #listgetat(acc_hesap_list,listfind(acc_code_list,ACCOUNT_ID,','),';')# --->
			<cfelse>
				 <font color="FF0000">!!<cf_get_lang no='654.Hesap Yok'> !!</font>
			</cfif>
			</td>
			<td nowrap>#left(DETAIL,22)#</td>
			<cfif BA > <!--- eq 1 : alacak --->
				<cfset alacak_bakiye = alacak_bakiye + AMOUNT>
				<td align="right" style="text-align:right;">&nbsp;</td>
				<td align="right" style="text-align:right;">#TLFormat(AMOUNT)#</td>
			<cfelse> <!--- borc --->
				<cfset borc_bakiye = borc_bakiye + AMOUNT>
				<td align="right" style="text-align:right;">#TLFormat(AMOUNT)#</td>
				<td align="right" style="text-align:right;">&nbsp;</td>
			</cfif>
			<td align="right" style="text-align:right;">
				<cfif borc_bakiye gt alacak_bakiye>
					<cfset bakiye = borc_bakiye - alacak_bakiye>
					#TlFormat(bakiye)#(B)
				<cfelse>
					<cfset bakiye = alacak_bakiye - borc_bakiye>
					#TlFormat(bakiye)#(A)
				</cfif>
			</td>
		</tr>
		<!--- <cfif currentrow mod 20>
			</table>
			<cfdocumentitem type="pagebreak"/>
			<table cellpadding="2" cellspacing="1" border="0" width="98%">
		</cfif> --->
 	</cfoutput>
</cfloop>
</table>
<!--- </cfdocument> --->
<cfsetting enablecfoutputonly="no">
</cfprocessingdirective>
