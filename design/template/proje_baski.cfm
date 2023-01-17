<cf_get_lang_set module_name="objects2"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_OFFER_CURRENCIES" datasource="#dsn3#">
	SELECT 
		OFFER_CURRENCY_ID, 
		OFFER_CURRENCY 
	FROM 
		OFFER_CURRENCY
	ORDER BY
		OFFER_CURRENCY
</cfquery>
<cfset offer_currency_list = valuelist(GET_OFFER_CURRENCIES.OFFER_CURRENCY_ID)>

<cfquery name="PROJECT_DETAIL" datasource="#dsn#">
	SELECT 
		*
	FROM 
		PRO_PROJECTS,		
		SETUP_PRIORITY
	WHERE
		PRO_PROJECTS.PROJECT_ID=#attributes.action_id# AND 		
		PRO_PROJECTS.PRO_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID 
	ORDER BY 
		PRO_PROJECTS.RECORD_DATE
</cfquery>

<cfquery name="GET_LAST_REC" datasource="#dsn#">
	SELECT
		MAX(HISTORY_ID) AS HIS_ID
	FROM
		PRO_HISTORY
	WHERE
		PROJECT_ID=#attributes.action_id#		
</cfquery>

<cfset hist_id=get_last_rec.HIS_ID>

<cfif LEN(hist_id)>
	<cfquery name="GET_HIST_DETAIL" datasource="#dsn#">
		SELECT
			*
		FROM
			PRO_HISTORY,
			SETUP_PRIORITY
		WHERE
			PRO_HISTORY.PRO_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID AND
			PRO_HISTORY.HISTORY_ID = #HIST_ID#
	</cfquery>
</cfif>

<cfset sayac = 0 >
<input type="hidden" name="#notes#" id="#notes#" value="">
<!---ikon ve başlık--->
<table width="590" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td style="text-align:right;"> <STRONG>
      <cfset TARGET_START = date_add('h',session.ep.TIME_ZONE,PROJECT_DETAIL.TARGET_START)>
      <cfoutput>#Dateformat(TARGET_START,dateformat_style)# #Timeformat(TARGET_START,timeformat_style)#</cfoutput> -
      <cfset TARGET_FINISH = date_add('h',session.ep.TIME_ZONE,PROJECT_DETAIL.TARGET_FINISH)>
      <cfoutput>#Dateformat(TARGET_FINISH,dateformat_style)# #Timeformat(TARGET_FINISH,timeformat_style)#</cfoutput></STRONG><cf_get_lang_main no='330.Tarih'><STRONG><cfoutput>#PROJECT_DETAIL.PROJECT_HEAD#</cfoutput>
      <cfif PROJECT_DETAIL.PROJECT_STATUS neq 1>
        <font color="#FF0000">(<cf_get_lang no='717.Gündemde Değil'>)</font>
      </cfif>
      </STRONG><cf_get_lang no='718.Başlıklı Proje'></td>
  </tr>
</table>
<br/>
<br/>
<table width="590" align="center">
  <tr>
    <td valign="top">
      <table>
        <tr height="20">
          <td width="75" class="txtbold"><cf_get_lang no="200.Kalan Zaman"></td>
          <td width="200"><cf_per_cent start_date = '#PROJECT_DETAIL.TARGET_START#' finish_date = '#PROJECT_DETAIL.TARGET_FINISH#' color1='ff6600' color2='99cc66' width="175"></td>
        </tr>
        <tr height="20">
          <td class="txtbold"><cf_get_lang_main no='1716.Süre'></td>
          <td>
            <cfset days=abs(datediff('d', project_detail.TARGET_FINISH, project_detail.TARGET_START))>
            <cfoutput>#days+1# <cf_get_lang_main no='78.Gün'></cfoutput></td>
        </tr>
        <tr height="20">
			<td class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
			<td>
				<cfquery name="GET_PROCESS" datasource="#dsn#">
					SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #project_detail.PRO_CURRENCY_ID#
				</cfquery>
				<cfoutput><font color="##FF0000">#GET_PROCESS.STAGE#</font></cfoutput>
			</td>
        </tr>
        <tr  height="20">
          <td class="txtbold"><cf_get_lang_main no='73.Öncelik'></td>
          <td> <cfoutput><font color="##FF0000">#get_hist_detail.PRIORITY#</font></cfoutput></td>
        </tr>
        <tr height="20">
          <td class="txtbold" colspan="2">
		  		<cf_get_lang_main no='71.Kayıt'>: 
              <cfset rec_date = date_add('h',session.ep.TIME_ZONE,PROJECT_DETAIL.RECORD_DATE)>
			  <cfif len(PROJECT_DETAIL.RECORD_EMP)>
				<cfoutput>#GET_EMP_INFO(PROJECT_DETAIL.RECORD_EMP,0,0)#</cfoutput>
			  <cfelseif len(PROJECT_DETAIL.RECORD_PAR)>
				<cfoutput>#GET_PAR_INFO(PROJECT_DETAIL.RECORD_PAR,0,1,0)#</cfoutput>
			  </cfif> - <cfoutput>#Dateformat(rec_date,dateformat_style)# #Timeformat(rec_date,timeformat_style)#</cfoutput> </td>
        </tr>
        <tr height="20">
          <td  class="txtbold"><cf_get_lang_main no='246.Üye'></td>
          <td>
			<cfif len(PROJECT_DETAIL.PARTNER_ID)>
				<cfoutput>#GET_PAR_INFO(PROJECT_DETAIL.PARTNER_ID,0,1,0)#</cfoutput>
			<cfelseif len(PROJECT_DETAIL.CONSUMER_ID)>
				<cfoutput>#GET_CONS_INFO(PROJECT_DETAIL.CONSUMER_ID,0,0)#</cfoutput>
			</cfif>
          </td>
        </tr>
        <tr height="20">
          <td class="txtbold"><cf_get_lang no='675.Proje Lideri'></td>
          <td>
			<cfif get_hist_detail.PROJECT_EMP_ID  neq 0 and len(get_hist_detail.PROJECT_EMP_ID )>
				<cfoutput>#GET_EMP_INFO(get_hist_detail.PROJECT_EMP_ID,0,0)#</cfoutput>
			</cfif>
			<cfif (project_detail.OUTSRC_PARTNER_ID neq 0) and len(project_detail.OUTSRC_PARTNER_ID)>
				<cfoutput>#GET_PAR_INFO(project_detail.OUTSRC_PARTNER_ID,0,0,0)#</cfoutput>
			</cfif>
          </td>
        </tr>
      </table>
      <hr color="#999999">
      <table>
        <tr height="20">
          <td colspan="2" class="txtbold"><cf_get_lang no='674.Proje Hedefi'></td>
        </tr>
        <tr height="20">
          <td colspan="2">
            <cfif len(PROJECT_DETAIL.PROJECT_TARGET)>
              <cfoutput>#PROJECT_DETAIL.PROJECT_TARGET#</cfoutput>
              <cfelse>
              -
            </cfif>
          </td>
        </tr>
        <tr height="20">
          <td colspan="2" class="txtbold"><cf_get_lang_main no='217.Açıklama'></td>
        </tr>
        <tr height="20">
          <td colspan="2">
            <cfif len(PROJECT_DETAIL.PROJECT_DETAIL)>
              <cfoutput>#PROJECT_DETAIL.PROJECT_DETAIL#</cfoutput>
              <cfelse>
              -
            </cfif>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td><hr color="#999999">
    </td>
  </tr>
</table>
<table width="590" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
      <!---işler--->
      <!---
		TYPE 1 ise isler
		2 ise teklif
		3 ise siparis
		4 ise uretim emri
	 --->
<cfquery name="GET_WORK" datasource="#DSN3#">
	<!--- Satış Teklifler--->	
		
			SELECT
				0 AS WORK_CAT,
				O.OFFER_ID AS WORK_ID,
				O.OFFER_HEAD  AS WORK_HEAD,
				0 AS OUTSRC_PARTNER_ID,
				RECORD_DATE AS TARGET_START,
				DELIVERDATE AS TARGET_FINISH,
				'' AS PRIORITY,
				'' AS COLOR,
				'' AS CURRENCY,
				OFFER_CURRENCY AS STR_CURRENCY,
				SALES_EMP_ID EMPLOYEE_ID,
				2 AS TYPE,
				'Satış Teklifleri ' AS TASK_TYPE,
				'sales.detail_offer_tv&offer_id='  AS LINK,
				1 AS LINK_TYPE			
			FROM
				OFFER O
			WHERE
				OFFER_ZONE=0 AND 
				PURCHASE_SALES=1 AND
				OFFER_STATUS = 1 AND
				IS_PROCESSED=0 AND
				PROJECT_ID=#URL.action_id#
		 
	<!--- Satınalma Teklifler--->	
	UNION ALL
			
				SELECT
					0 AS WORK_CAT,
					O.OFFER_ID AS WORK_ID,
					O.OFFER_HEAD  AS WORK_HEAD,
					0 AS OUTSRC_PARTNER_ID,
					RECORD_DATE AS TARGET_START,
					DELIVERDATE AS TARGET_FINISH,
					'' AS PRIORITY,
					'' AS COLOR,
					'' AS CURRENCY,
					OFFER_CURRENCY AS STR_CURRENCY,
					0 EMPLOYEE_ID,
					2 AS TYPE,
					'Satınalma Teklifleri ' AS TASK_TYPE,
					'purchase.detail_offer_ta&offer_id=' AS LINK,
					1 AS LINK_TYPE			
				FROM
					OFFER O
				WHERE
					PROJECT_ID=#URL.action_id# AND 
					OFFER_ZONE=0 AND 
					PURCHASE_SALES=0 AND 
					OFFER_STATUS = 1 AND 
					IS_PROCESSED=0
			UNION ALL
				SELECT
					0 AS WORK_CAT,
					O.OFFER_ID AS WORK_ID,
					O.OFFER_HEAD  AS WORK_HEAD,
					0 AS OUTSRC_PARTNER_ID,
					RECORD_DATE AS TARGET_START,
					DELIVERDATE AS TARGET_FINISH,
					'' AS PRIORITY,
					'' AS COLOR,
					'' AS CURRENCY,
					OFFER_CURRENCY AS STR_CURRENCY,
					0 EMPLOYEE_ID,
					2 AS TYPE,
					'Satınalma Teklifleri ' AS TASK_TYPE,
					'purchase.detail_offer_ptv&offer_id='  AS LINK,
					1 AS LINK_TYPE
				FROM
					OFFER O
				WHERE
					PROJECT_ID=#URL.action_id# AND 
					OFFER_ZONE=1 AND 
					PURCHASE_SALES=1 AND 
					OFFER_STATUS = 1 AND 
					IS_PROCESSED=0
				
	<!--- Satış Siparişleri--->	
	UNION ALL
		
			SELECT
				0 AS WORK_CAT,
				O.ORDER_ID AS WORK_ID,
				O.ORDER_HEAD  AS WORK_HEAD,
				0 AS OUTSRC_PARTNER_ID,
				RECORD_DATE AS TARGET_START,
				DELIVERDATE AS TARGET_FINISH,
				'' AS PRIORITY,
				'' AS COLOR,
				'' AS CURRENCY,
				ORDER_CURRENCY AS STR_CURRENCY,
				<!--- SALES_POSITION_CODE AS  POSITION_CODE, --->
				ORDER_EMPLOYEE_ID AS EMPLOYEE_ID,
				3 AS TYPE,
				'Satış Siparişleri ' AS TASK_TYPE,
				'sales.detail_order_sa&order_id='   AS LINK,
				1 AS LINK_TYPE
			FROM
				ORDERS O
			WHERE
				PROJECT_ID=#URL.action_id# AND
				ORDER_ZONE=0 AND 
				PURCHASE_SALES=1 AND 
				ORDER_STATUS = 1 AND 
				IS_PROCESSED=0
			
		UNION ALL
			SELECT
				0 AS WORK_CAT,
				O.ORDER_ID AS WORK_ID,
				O.ORDER_HEAD  AS WORK_HEAD,
				0 AS OUTSRC_PARTNER_ID,
				RECORD_DATE AS TARGET_START,
				DELIVERDATE AS TARGET_FINISH,
				'' AS PRIORITY,
				'' AS COLOR,
				'' AS CURRENCY,
				ORDER_CURRENCY AS STR_CURRENCY,
				<!--- SALES_POSITION_CODE POSITION_CODE, --->
				ORDER_EMPLOYEE_ID EMPLOYEE_ID,
				3 AS TYPE,
				'Satış Siparişleri ' AS TASK_TYPE,
				'sales.detail_order_psv&order_id=' AS LINK,
				1 AS LINK_TYPE
			FROM
				ORDERS O
			WHERE
				PROJECT_ID=#URL.action_id# AND 
				ORDER_ZONE=1 AND 
				PURCHASE_SALES=0 AND 
				ORDER_STATUS = 1 AND 
				IS_PROCESSED=0
		
		UNION ALL

			SELECT
				0 AS WORK_CAT,
				O.ORDER_ID AS WORK_ID,
				O.ORDER_HEAD  AS WORK_HEAD,
				0 AS OUTSRC_PARTNER_ID,
				RECORD_DATE AS TARGET_START,
				DELIVERDATE AS TARGET_FINISH,
				'' AS PRIORITY,
				'' AS COLOR,
				'' AS CURRENCY,
				ORDER_CURRENCY AS STR_CURRENCY,
				0 EMPLOYEE_ID,
				3 AS TYPE,
				'Satınalma Siparişleri ' AS TASK_TYPE,
				'purchase.detail_order&order_id=' AS LINK,
				1 AS LINK_TYPE
			FROM
				ORDERS O
			WHERE
				PROJECT_ID=#URL.action_id# AND 
				ORDER_ZONE=0 AND 
				PURCHASE_SALES=0 AND 
				ORDER_STATUS = 1 AND 
				IS_PROCESSED=0
		
		UNION ALL
	<!--- Üretim Emirleri--->						
		
			SELECT
				0 AS WORK_CAT,
				PO.P_ORDER_ID  AS WORK_ID,
				'Üretim Emri'  AS WORK_HEAD,
				0 AS OUTSRC_PARTNER_ID,
				PO.START_DATE AS TARGET_START,
				PO.FINISH_DATE AS TARGET_FINISH,
				'' AS PRIORITY,
				'' AS COLOR,
				'' AS CURRENCY,
				-1000 AS STR_CURRENCY,
				0 EMPLOYEE_ID,
				4 AS TYPE,
				'Üretim Emri ' AS TASK_TYPE,
				'prod.form_upd_prod_order&upd=' AS LINK,
				1 AS LINK_TYPE
			FROM
				PRODUCTION_ORDERS PO,
				WORKSTATIONS W
			WHERE
				W.STATION_ID=PO.STATION_ID AND
				PO.DP_ORDER_ID  IS NULL AND 
				PO.PROJECT_ID=#URL.action_id#	
		 
		ORDER BY TARGET_START	
</cfquery>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr height="22">
          <td colspan="10" class="formbold"><cf_get_lang_main no='1576.Aksiyonlar'></td>
        </tr>
        <cfif  not get_work.recordcount>
          <tr height="20">
            <td colspan="10" class="label"><cf_get_lang_main no='1074.Kayıt Bulunamadı'></td>
          </tr>
          <cfelse>
          <tr height="22" class="txtbold">
            <td width="25"><cf_get_lang_main no='75.No'></td>
            <td><cf_get_lang_main no='1033.İş'></td>
            <td><cf_get_lang_main no='218.Tip'></td>
            <td width="85"><cf_get_lang_main no='157.Görevli'></td>
            <td width="85"><cf_get_lang_main no='89.Başlangıç'></td>
            <td width="100"><cf_get_lang_main no='90.Bitiş'></td>
            <td width="50"><cf_get_lang_main no='73.Öncelik'></td>
            <td width="50"><cf_get_lang_main no='70.Aşama'></td>
          </tr>
          <cfoutput query="get_work">
            <tr>
              <td height="20">#currentrow#</td>
              <td>#WORK_HEAD#</td>
              <td>#TASK_TYPE#</td>
              <td>
				<cfif get_work.EMPLOYEE_ID neq 0 and len(get_work.EMPLOYEE_ID)>
					<cfif len(get_work.type eq 3)>#GET_EMP_INFO(get_work.EMPLOYEE_ID,0,1)#
						<cfelse>#GET_EMP_INFO(get_work.EMPLOYEE_ID,0,1)#<!--- Siparişte order_employee_id gelmesi için düzenlendi--->
					</cfif>
				</cfif>
				<cfif (get_work.OUTSRC_PARTNER_ID neq 0) and len(get_work.OUTSRC_PARTNER_ID)>
					#GET_PAR_INFO(get_work.OUTSRC_PARTNER_ID,0,0,1)#
				</cfif>
              </td>
              <td>
                <cfif len(TARGET_START) >
                  <cfset sdate=date_add("h",session.ep.TIME_ZONE,TARGET_START)>
                </cfif>
                <cfif len(TARGET_FINISH)>
                  <cfset fdate=date_add("h",session.ep.TIME_ZONE,TARGET_FINISH)>
                </cfif>
                <cfif "1,4,3,2" contains type >
                  #dateformat(sdate,dateformat_style)#
                </cfif>
                <cfif "1,4" contains type >
                  <cfset shour=datepart("h",sdate)>
                  <cfset fhour=datepart("h",fdate)>
                  #shour#:00
                </cfif>
              </td>
              <td>
                <cfif "1,4,3,2" contains type  and len(TARGET_FINISH)>
                  #dateformat(fdate,dateformat_style)#
                </cfif>
                <cfif  "1,4" contains type and isDefined("fhour") >
                  #fhour#:00
                </cfif>
              </td>
              <td>
                <cfif  TYPE eq 1 >
                  <font color="#COLOR#">#PRIORITY#</font>
                </cfif>
              </td>
              <td> <font color="#COLOR#">
                <cfif  TYPE eq 1 >
                  #CURRENCY#
                <cfelseif TYPE eq 2>
                  <cfset counter = listfindnocase(offer_currency_list,STR_CURRENCY)>
                  #GET_OFFER_CURRENCIES.OFFER_CURRENCY[counter]#
                </cfif>
                </font> </td>
            </tr>
          </cfoutput>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif isdefined("attributes.print")>
	<script type="text/javascript">
		window.print();
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
