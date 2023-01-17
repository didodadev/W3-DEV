<cfif isDefined("attributes.startdate") and len(attributes.startdate) and isDefined("attributes.finishdate") and len(attributes.finishdate)>
  <cf_date tarih="attributes.STARTDATE">
  <cf_date tarih="attributes.finishdate">
<cfelse>
  <cfset attributes.startdate="">
  <cfset attributes.finishdate="">
</cfif>

<cfquery name="PURCHASE" datasource="#dsn2#">
	SELECT 
		SHIP.SHIP_TYPE, 
		SHIP.DELIVER_DATE, 
		SHIP.COMPANY_ID, 
		SHIP.PURCHASE_SALES AS PS, 
		SHIP.DELIVER_STORE_ID, 
		SHIP_ROW.*, 
		PRD.PRODUCT_NAME, 
		ST.PROPERTY, 
		PRD.PRODUCT_ID
		FROM 
		SHIP_ROW, 
		SHIP, 
		#dsn3_alias#.PRODUCT AS PRD, 
		#dsn3_alias#.STOCKS AS ST 
	WHERE
		SHIP_ROW.STOCK_ID = #attributes.ID# 
	AND 
		SHIP_ROW.STOCK_ID=ST.STOCK_ID 
	AND 
		ST.PRODUCT_ID= PRD.PRODUCT_ID 
	AND 
		SHIP_ROW.SHIP_ID=SHIP.SHIP_ID	
	AND
		<cfif len(attributes.startdate) and len(attributes.finishdate)>
			 SHIP.DELIVER_DATE>= #attributes.startdate# and SHIP.DELIVER_DATE <= #attributes.finishdate#
	  	<cfelse>
		  		SHIP.DELIVER_DATE <= #now()#
		</cfif>
	ORDER BY 
		SHIP.DELIVER_DATE
</cfquery>
<cfparam name="attributes.page" default=1> 
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default=#purchase.recordcount#>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang_main no='2267.Stok Hakeretleri'></td>
    <td height="30" class="headbold" width="250">
      <!--- Arama --->
      <table width="250">
        <cfform  name="search" action="#request.self#?fuseaction=stock.detail_stock_popup&id=#attributes.id#" method="post">
          <tr>
            <td ALIGN="right" style="text-align:right;">
			<cfsavecontent variable="message"><cf_get_lang_main no='326.başlama girmelisiniz'></cfsavecontent>
			<cfinput TYPE="text" NAME="startdate" VALUE="" STYLE="width:80px;" validate="#validate_style#" maxlength="10" message="#message#"></td>
            <td ALIGN="right" style="text-align:right;"> <cf_wrk_date_image date_field="startdate"></td>
            <td ALIGN="right" style="text-align:right;">
			<cfsavecontent variable="message"><cf_get_lang no='228.bitiş girmelisiniz'></cfsavecontent>
			<cfinput TYPE="text" NAME="finishdate" VALUE="" STYLE="width:80px;" validate="#validate_style#" maxlength="10" message="#message#"></td>
            <td ALIGN="right" style="text-align:right;"> <cf_wrk_date_image date_field="finishdate"> </td>
            <td>
			<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
            </td>
            <td ALIGN="right" style="text-align:right;">
              <cf_wrk_search_button></td>
          </tr>
        </CFFORM>
      </table>
      <!--- Arama --->
    </td>
  </tr>
</table>
<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header">
          <td height="22" class="form-title" width="75"><cf_get_lang_main no='330.tarih'></td>
          <td class="form-title" width="75"><cf_get_lang_main no='1372.referans no'></td>
          <td class="form-title"><cf_get_lang_main no='1121.belge tipi'></td>
          <td class="form-title"><cf_get_lang_main no='107.cari hesap'></td>
          <td class="form-title"><cf_get_lang_main no='1351.depo'></td>
          <td class="form-title"><cf_get_lang_main no='223.miktar'></td>
          <td class="form-title"><cf_get_lang_main no='261.tutar'></td>
        </tr>
          <cfset TOTAL=0>
		<cfif purchase.recordcount>
          <cfoutput query="purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td height="20">#dateformat(DELIVER_DATE,dateformat_style)#</td>
              <td align="right" style="text-align:right;"> #SHIP_ID# </td>
              <td>
                <cfset SHIP_T = SHIP_TYPE>
                <cfif ship_t eq 76>
                  <cf_get_lang_main no='1784.Mal Alım İrsaliyesi'>
                  <cfelseif ship_t eq 78>
                  <cf_get_lang_main no='1787.Alım İade İrsaliyesi'>
                  <cfelseif ship_t eq 77>
                  <cf_get_lang no='79.Konsinye Giriş'>
                  <cfelseif ship_t eq 79>
                  <cf_get_lang no='80.Konsinye Giriş İade'>
                  <cfelseif ship_t eq 80>
                  <cf_get_lang no='81.Müstahsil Makbuz'>
                  <cfelseif ship_t eq 71>
                  <cf_get_lang_main no='1340.Toptan Satış İrsaliyesi'>
                  <cfelseif ship_t eq 70>
                  <cf_get_lang no='83.Parekande Satış İrsaliyesi'>
                  <cfelseif ship_t eq 72>
                  <cf_get_lang_main no='1341.Konsinye Çıkış İrsaliyesi'>
                  <cfelseif ship_t eq 73>
                  <cf_get_lang no='85.Parekande Satış İade İrsaliyesi'>
                  <cfelseif ship_t eq 74>
                  <cf_get_lang_main no='1783.Toptan Satış İade İrsaliyesi'>
                  <cfelseif ship_t eq 75>
                  <cf_get_lang_main no='1343.Konsinye Çıkış İade İrsaliyesi'>
                </cfif>
              </td>
              <td>
                <cfif LEN(company_id) and company_id neq 0>
                  <cfset attributes.company_id = company_id>
                  <cfinclude template="../query/get_company_name.cfm">
                  #company_name.nickname#
                  <cfelse>
                  <cfquery name="GET_CONS_NAME_UPD" datasource="#dsn#">
						SELECT 
							CONSUMER_NAME,
							CONSUMER_SURNAME, 
							COMPANY,
							CONSUMER_ID 
						FROM 
							CONSUMER 
						WHERE 
							CONSUMER_ID=#CONSUMER_ID#
                  </cfquery>
                  #get_cons_name_upd.CONSUMER_NAME#&nbsp;#get_cons_name_upd.CONSUMER_SURNAME#
                </cfif>
              </td>
              <td>
				<cfif len(DELIVER_STORE_ID)>
					<cfquery name="DEPO" datasource="#DSN#">
						SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID=#DELIVER_STORE_ID#
					</cfquery>
					#DEPO.DEPARTMENT_HEAD# 
				<cfelse>
					<cfquery name="DEPO" datasource="#DSN#">
						SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID=#DEPARTMENT_IN#
					</cfquery>
					#DEPO.DEPARTMENT_HEAD# 
				</cfif>
			  </td>
              <td>
                <cfif PS EQ 1>
                  <cfset SIGN="-">
                  <cfelseIF PS EQ 0>
                  <cfset SIGN="+">
                </cfif>
                <cfif SIGN EQ "-">&nbsp;</cfif>
                #SIGN#&nbsp;
                <cfquery name="GET_U" datasource="#DSN3#">
                SELECT PU.MAIN_UNIT, PU.MULTIPLIER FROM PRODUCT_UNIT PU WHERE
                PU.PRODUCT_ID=#PRODUCT_ID# AND
                PU.ADD_UNIT LIKE '#UNIT#'
                </cfquery>
                <cfset UNITS = AMOUNT*GET_U.MULTIPLIER>
                #UNITS#&nbsp;&nbsp;#GET_U.MAIN_UNIT#
                <cfif SIGN EQ "+">
                  <cfset TOTAL=TOTAL+UNITS>
                  <cfelse>
                  <cfset TOTAL=TOTAL-UNITS>
                </cfif>
              </td>
              <td align="right" style="text-align:right;">#EVALUATE(PRICE+(PRICE*(TAX/100)))# #session.ep.money#</td>
            </tr>
          </cfoutput> 
		  <cfoutput>
            <tr class="COLOR-ROW">
              <td colspan="7" align="right" style="text-align:right;">#TOTAL#&nbsp;&nbsp;#GET_U.MAIN_UNIT#</td>
            </tr>
          </cfoutput>
        <cfelse>
          <tr class="color-row">
            <td colspan="7"><cf_get_lang_main no='72.kayıt yok'></td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table cellpadding="0" cellspacing="0" border="0" width="98%" align="center" height="35">
    <tr>
      <td>
				<cf_pages
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#purchase.recordcount#"
					startrow="#attributes.startrow#"
					adres="stock.detail_stock_popup&id=#attributes.id#&startdate=#attributes.startdate#&finishdate=#attributes.finishdate#">
		  </td>
      <td width="275" align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='80.toplam'>: #attributes.totalrecords# - <cf_get_lang_main no='169.sayfa'>: #attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>
