<cfquery name="GET_OFFER_LIST" datasource="#DSN3#">
	SELECT 
		OFFER_ID,
		CONSUMER_ID,
		PARTNER_ID,
		COMPANY_ID,	
		OFFER_DETAIL,	
		OFFER_TO,
		OFFER_TO_PARTNER,
		SALES_EMP_ID,
		<!--- SALES_POSITION_CODE, --->
		SALES_PARTNER_ID,
		OFFER_NUMBER,
		RECORD_DATE,
		OFFER_HEAD,
		NETTOTAL,
		PRICE,
		OTHER_MONEY,
		OFFER_STATUS,
		COMMETHOD_ID,
		RECORD_MEMBER,
		OFFER_CURRENCY,
		OFFER_ZONE,
		OFFER_DATE,
		OFFER_STAGE
		<cfif len(session.ep.money2)>
		,PRICE/(OFFER_MONEY.RATE2/OFFER_MONEY.RATE1) AS PRICE2
        </cfif>
	FROM 
		OFFER
		<cfif len(session.ep.money2)>
		,OFFER_MONEY
		</cfif>
	WHERE 
	  ((PURCHASE_SALES = 1 AND OFFER_ZONE = 0) OR (PURCHASE_SALES = 0 AND OFFER_ZONE = 1))
	<cfif len(session.ep.money2)>
		AND OFFER.OFFER_ID = OFFER_MONEY.ACTION_ID
		AND OFFER_MONEY.MONEY_TYPE = '#session.ep.money2#'
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>
		AND COMPANY_ID =	#attributes.company_id#
	</cfif>
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name)>
		AND CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	 <cfif isdefined("attributes.belge_no") and len(attributes.belge_no)>
		AND (OFFER_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%')
	</cfif>
	<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
		AND EMPLOYEE_ID = #attributes.employee_id#	
	</cfif>
	<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
		AND OFFER_DATE >= #attributes.start_date#
	</cfif>
	<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
		AND OFFER_DATE <= #attributes.finish_date#
	</cfif>
	ORDER BY 
		OFFER_DATE DESC
</cfquery>
<cfif not len(GET_OFFER_LIST.recordcount)>
	<cfset GET_OFFER_LIST.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_OFFER_LIST.recordcount#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
    <cf_medium_list>
        <thead>
          <tr>
              <th width="50"><cf_get_lang dictionary_id='57487.No'></th>
              <th width="180"><cf_get_lang dictionary_id ='57742.Tarih'></th>		  
              <th width="120"><cf_get_lang dictionary_id ='57880.Belge No'></th>
              <th width="250"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
              <th width="150"><cf_get_lang dictionary_id ='57673.Tutar'></th>
              <th width="150"><cf_get_lang dictionary_id ='34136.Tutar Döviz'></th>
          </tr>
       </thead>
       <tbody>
          <cfif GET_OFFER_LIST.recordcount>
              <cfoutput query="get_offer_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
              <tr>
                  <td><a href="#request.self#?fuseaction=sales.detail_offer<cfif offer_zone eq 1>_pta<cfelseif offer_zone eq 0>_tv</cfif>&offer_id=#offer_id#" class="tableyazi">#OFFER_ID#</a></td>
                  <td>#dateformat(OFFER_DATE,dateformat_style)# &nbsp; #timeformat(date_add('h',session.ep.time_zone,OFFER_DATE),timeformat_style)#</td>
                  <td><a href="#request.self#?fuseaction=sales.detail_offer<cfif offer_zone eq 1>_pta<cfelseif offer_zone eq 0>_tv</cfif>&offer_id=#offer_id#" class="tableyazi">#OFFER_NUMBER#</a></td>
                  <td>#OFFER_DETAIL#</td>
                  <td  style="text-align:right;">
                    #TLFormat(get_offer_list.PRICE)# #session.ep.money#
                  </td>
                  <td  style="text-align:right;">
                    #TLFormat(get_offer_list.PRICE2)# #session.ep.money2#
                  </td>
              </tr>
              </cfoutput>
          <cfelse>
              <tr>
                  <td colspan="14">
                  <cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif>
                  </td>
              </tr>	
         </cfif> 
       </tbody>
    </cf_medium_list>
 <cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
    <tr>
      <td>
        <cfset adres="objects.popup_list_related_papers">
        <cfif isDefined('attributes.sec') and len(attributes.sec)>
            <cfset adres = "#adres#&sec=#attributes.sec#">
        </cfif>
            <cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>
                <cfset adres = "#adres#&company_id=#attributes.company_id#" >
                <cfset adres = "#adres#&member_name=#attributes.member_name#">
            </cfif>
            <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name)>
                <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#" >
                <cfset adres = "#adres#&member_name=#attributes.member_name#">
            </cfif>
            <cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
                <cfset adres = "#adres#&employee_id=#attributes.employee_id#" >
                <cfset adres = "#adres#&employee=#attributes.employee#">
            </cfif>
            <cfif isdefined("attributes.belge_no") and len(attributes.belge_no)>
                <cfset adres = "#adres#&belge_no=#attributes.belge_no#" >
            </cfif>
            <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
                <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
            </cfif>
            <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
                <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
            </cfif>
            <cfif isdefined("attributes.form_varmi")>
            <cfset adres = "#adres#&form_varmi=#attributes.form_varmi#" >
        </cfif>
        <cf_pages page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#"></td>
      <td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id ='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id ='57581.Sayfa'>:#attributes.page#</cfoutput>
      </td>
    </tr>
  </table>
</cfif>	
			 	  








