<cfif fuseaction contains "popup">
    <cfset is_popup=1>
    <cfelse>
    <cfset is_popup=0>
  </cfif>
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
    <tr>
      <td class="headbold"><cf_get_lang_main no='375.Cari Hesap Extresi'></td>
	  <!-- sil --><td style="text-align:right;"><cfoutput><a href="#request.self#?fuseaction=ch.list_extre#page_code#&print=1"><img src="/images/print.gif" alt="<cf_get_lang_main no='375.Cari Hesap Extresi'>" border="0"></a></cfoutput></td><!-- sil -->
    </tr>
  </table>
  <!--- işlemler --->
  <cf_date tarih="attributes.date1">
  <cf_date tarih="attributes.date2">
  <cfset max_id = attributes.COMPANY_ID1>
  <cfset min_id = attributes.COMPANY_ID2>
  <cfif max_id lt min_id and len(min_id)>
    <cfset max_id = attributes.COMPANY_ID2>
    <cfset min_id = attributes.COMPANY_ID1>
  </cfif>
  <cfset max_name = attributes.comp_name1>
  <cfset min_name = attributes.comp_name2>
  <cfif max_name lt min_name and len(min_name)>
    <cfset max_name = attributes.comp_name2>
    <cfset min_name = attributes.comp_name1>
  </cfif>
  <cfquery name="GET_CMP_IDS" datasource="#dsn#">
	SELECT 
		COMPANY_ID,
		FULLNAME 
	FROM 
		COMPANY 
	WHERE
		<cfif attributes.ORDER_TYPE EQ 1>
			<cfif len(MAX_ID) and LEN(MIN_ID)>
				COMPANY_ID >= #MIN_ID# 
				AND 
				COMPANY_ID <= #MAX_ID#
			<cfelseif LEN(MAX_ID)>
				COMPANY_ID = #MAX_ID# 
			<cfelse>
			1=0
			</cfif>
		<cfelse>
			<cfif len(MAX_NAME) and len(MIN_NAME)>
				FULLNAME >= '#MIN_NAME#' AND FULLNAME <='#MAX_NAME#'
			<cfelseif len(MAX_NAME)>
				FULLNAME = '#MAX_NAME#'
			<cfelse>
				1=0
			</cfif>
		</cfif>
	ORDER BY
		<cfif attributes.ORDER_TYPE EQ 1>
			COMPANY_ID
		<cfelse>
			FULLNAME
		</cfif>
  </cfquery>
  <cfloop query="get_cmp_ids">
    <cfset attributes.COMPANY_ID=COMPANY_ID>
		<cfquery name="CARI_ROWS" datasource="#dsn2#">
			SELECT 
					CR.PAPER_NO, 
					CR.ACTION_DATE, 
					CR.ACTION_NAME, 
					0 AS BORC, 
					(CR.ACTION_VALUE*(SM.RATE2 / SM.RATE1)) AS ALACAK 
				FROM 
					CARI_ROWS CR, 
					#dsn_alias#.SETUP_MONEY SM
				WHERE
					SM.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
					( 
						CR.FROM_CMP_ID = #attributes.COMPANY_ID# AND 
						CR.ACTION_DATE >= #attributes.date1# AND 
						CR.ACTION_DATE <= #attributes.date2# 
					) AND 
					CR.ACTION_CURRENCY_ID = SM.MONEY 
			UNION 
				SELECT 
					CR.PAPER_NO,
					CR.ACTION_DATE, 
					CR.ACTION_NAME, 
					(CR.ACTION_VALUE*(SM.RATE2 / SM.RATE1)) AS BORC, 
					0 AS ALACAK 
				FROM 
					CARI_ROWS CR,
					#dsn_alias#.SETUP_MONEY SM 
				WHERE
					SM.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
					(
						CR.TO_CMP_ID = #attributes.COMPANY_ID# AND 
						CR.ACTION_DATE >= #attributes.date1# AND 
						CR.ACTION_DATE <= #attributes.date2#
					) AND 
					CR.ACTION_CURRENCY_ID = SM.MONEY
				ORDER BY 
					ACTION_DATE
    </cfquery>
    <table cellpadding="0" cellspacing="0" border="0" width="98%" align="center">
      <tr class="color-border">
        <td>
          <table cellpadding="2" border="0" width="100%" cellspacing="1">
            <tr height="25" class="color-header">
              <td class="form-title" colspan="6"><cfoutput>#fullname# &nbsp;&nbsp;#dateformat(attributes.date1,dateformat_style)#-#dateformat(attributes.date2,dateformat_style)#</cfoutput> </td>
            </tr>
            <tr height="22" class="color-list">
              <td width="65" class="txtboldblue"><cf_get_lang_main no='330.Tarih'></td>
              <td class="txtboldblue"><cf_get_lang_main no='468.Belge No'></td>
              <td class="txtboldblue"><cf_get_lang_main no='280.İşlem'></td>
              <td class="txtboldblue" style="text-align:right;"><cf_get_lang_main  no='175.Borç'></td>
              <td class="txtboldblue" style="text-align:right;"><cf_get_lang_main  no='176.Alacak'></td>
              <td class="txtboldblue" style="text-align:right;"><cf_get_lang_main  no='177.Bakiye'></td>
            </tr>
            <cfset total = 0>
            <cfset borctoplam = 0>
            <cfset alacaktoplam = 0>
			<cfoutput query="cari_rows">
				<cfset borctoplam = borctoplam + borc>
              <cfset alacaktoplam = alacaktoplam + alacak> 
              <cfset total = abs( borctoplam - alacaktoplam)>
              <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td>#dateformat(action_date,dateformat_style)#</td>
                <td>#PAPER_NO#</td>
                <td>#action_name#</td>
                <td style="text-align:right;">#TLFormat(borc)# #session.ep.money#</td>
                <td style="text-align:right;">#TLFormat(alacak)# #session.ep.money#</td>
                <td style="text-align:right;">
					<cfif borctoplam GT alacaktoplam>
							#TLFormat(abs(total))# #session.ep.money# (B)
					<cfelse>
							#TLFormat(abs(total))# #session.ep.money# (A)
					</cfif>																															
                </td>
              </tr>
            </cfoutput>
            <tr height="20" class="color-row">
              <td colspan="3" class="txtboldblue" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
              <td style="text-align:right;"><cfoutput>#TLFormat(borctoplam)# #session.ep.money#</cfoutput></td>
              <td style="text-align:right;"><cfoutput>#TLFormat(alacaktoplam)# #session.ep.money#</cfoutput></td>
              <td style="text-align:right;"> 
				<cfoutput>
                  <cfif borctoplam GT alacaktoplam>
                    #TLFormat(total)# #session.ep.money# (B)
                  <cfelseif borctoplam LT alacaktoplam>
                    #TLFormat(total)# #session.ep.money# (A)
                  <cfelse>
                    #TLFormat(total)# #session.ep.money#
                  </cfif>
                </cfoutput>
			  </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
    <br/>
  </cfloop>
