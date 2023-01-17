<!--- Fiyat Listeleri --->
<cfif fuseaction contains "popup">
  <cfset is_popup=1>
  <cfelse>
  <cfset is_popup=0>
</cfif>
<cfparam name="attributes.currency" default="0">
<cfquery name="GET_PRICE_CAT" DATASOURCE="#dsn3#">
	SELECT 
		* 
	FROM 
		PRICE_CAT
	WHERE 
		1 = 1		
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND PRICE_CAT LIKE '%#attributes.keyword#%'
	</cfif>
	<cfif attributes.currency neq 0>
		<cfif attributes.currency is 1>
			AND COMPANY_CAT <> ','
		<cfelseif attributes.currency is 2>
			AND CONSUMER_CAT <> ','
		<cfelseif attributes.currency is 3>
			AND BRANCH <> ','
		</cfif>
	</cfif>
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_PRICE_CAT.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
  <tr>
    <td class="headbold" height="35"><cf_get_lang dictionary_id='37028.Fiyat Listeleri'></td>
    <td align="right" style="text-align:right;">
      <table>
        <cfform action="" method="post">
          <tr>
            <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            <td>
              <select name="currency" id="currency" style="width:150px;">
				<option value="0"<cfif attributes.currency is 0> selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<option value="1"<cfif attributes.currency is 1> selected</cfif>><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
				<option value="2"<cfif attributes.currency is 2> selected</cfif>><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
				<option value="3"<cfif attributes.currency is 3> selected</cfif>><cf_get_lang dictionary_id='29434.Şubeler'></option>
              </select>
            </td>
            <td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button></td>
			<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'> 
			</tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0"  border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22">
          <td class="form-title" width="99"><cf_get_lang dictionary_id='37144.Liste Adı'></td>
          <td class="form-title"><cf_get_lang dictionary_id='37220.Fiyat Geçerlilik Alanları'></td>
          <td class="form-title" width="80"><cf_get_lang dictionary_id='37045.Marj'></td>
          <td class="form-title" width="80"><cf_get_lang dictionary_id='57641.İndirim'></td>
          <td class="form-title" width="80"><cf_get_lang dictionary_id='37221.Aktif Ürün'></td>
        </tr>
        <cfoutput query="get_price_cat" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td height="22"><a href="#request.self#?fuseaction=product.list_product&price_catid=#price_catid#" class="tableyazi">#price_Cat#</a></td>
              <td>
					<cfif not len(listsort(COMPANY_CAT,'Numeric'))>
					  <cf_get_lang dictionary_id='57952.Herkes'>
					<cfelse>
					  <cfquery name="GET_COMPANY_CAT" datasource="#dsn#">
						  SELECT 
							  COMPANYCAT 
						  FROM 
							  COMPANY_CAT 
						  WHERE 
							  COMPANYCAT_ID IN (#listsort(COMPANY_CAT,'Numeric')#)
					  </cfquery>
				  #valuelist(get_company_cat.COMPANYCAT)# 
                </cfif>
				
                <cfif not len(listsort(consumer_cat,'Numeric'))>
					<cfif len(listsort(COMPANY_CAT,'Numeric'))>
	                   <cf_get_lang dictionary_id='57952.Herkes'>
				   </cfif>
                <cfelse>
                  <cfquery name="GET_CONSUMER_CAT" datasource="#dsn#">
					  SELECT 
						  CONSCAT 
					  FROM 
						  CONSUMER_CAT 
					  WHERE 
						  CONSCAT_ID IN (#listsort(consumer_cat,'Numeric')#)
                  </cfquery>
                  <cfloop from="1" to="#get_consumer_cat.recordcount#" index="j">
                    #get_consumer_cat.CONSCAT[j]#,
				  </cfloop>
                </cfif>
                <cfif len(listsort(BRANCH,'Numeric'))>
					<cfquery name="GET_BRANCH" datasource="#dsn#">
						SELECT 
							* 
						FROM 
							BRANCH 
						WHERE 
							BRANCH_ID IN (#listsort(BRANCH,'Numeric')#)
					</cfquery>
				    <font face="Verdana" color="##ff0000"> #valuelist(get_branch.BRANCH_NAME)# </font>
 				</cfif>
              </td>
              <td>#margin# </td>
              <td>#discount# </td>
              <cfquery name="calculate_ac_prd" datasource="#dsn3#">
              	SELECT
					COUNT(PRICE_ID) AS Sum_Prd FROM PRICE
				WHERE
					PRICE_CATID = #price_catid# AND
					STARTDATE <= #now()# AND
					(FINISHDATE >= #now()# OR FINISHDATE IS NULL)
              </cfquery>
              <cfquery name="sum_product" datasource="#dsn3#">
              	SELECT COUNT(PRODUCT_ID) SUM_PRD FROM PRODUCT WHERE PRODUCT_STATUS = 1
              </cfquery>
              <td>#calculate_ac_prd.sum_prd#</td>
            </tr>
        </cfoutput>
      </table>
    </td>
  </tr>
</table>
<cf_paging page="#attributes.page#" 
maxrows="#attributes.maxrows#"
totalrecords="#attributes.totalrecords#"
startrow="#attributes.startrow#"
adres="product.list_price&keyword=#attributes.keyword#&currency=#attributes.currency#">
<br/>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
  <tr>
    <td>
      <cfquery name="GET_CONS_CAT" datasource="#dsn#">
      	SELECT * FROM CONSUMER_CAT
      </cfquery>
      <cfquery name="GET_COMP_CAT" datasource="#dsn#">
      	SELECT * FROM COMPANY_CAT
      </cfquery>
      <cfoutput query="GET_CONS_CAT">
        <cfset durum = 0>
        <cfloop from="1" to="#get_price_cat.recordcount#" index="k">
          <cfloop from="1" to="#listlen(get_price_Cat.CONSUMER_CAT[k])#" index="j">
            <cfif listgetat(get_price_cat.CONSUMER_CAT[k],j,",") is get_cons_Cat.CONSCAT_ID>
              <cfset durum = 1>
            </cfif>
          </cfloop>
        </cfloop>
      </cfoutput><cf_get_lang dictionary_id='58599.Dikkat'>:<br/>
      <cfoutput query="GET_COMP_CAT">
        <cfset durum = 0>
        <cfloop from="1" to="#get_price_cat.recordcount#" index="k">
          <cfloop from="1" to="#listlen(get_price_Cat.COMPANY_CAT[k])#" index="j">
            <cfif listgetat(get_price_cat.COMPANY_CAT[k],j,",") is GET_COMP_CAT.COMPANYCAT_ID>
              <cfset durum = 1>
            </cfif>
          </cfloop>
        </cfloop>
        <cfif durum is 0>
          <font color="##ff0000"><strong>#COMPANYCAT#</strong>,</font>
        </cfif>
      </cfoutput><br/>
      <cf_get_lang dictionary_id='37224.Kullanıcı grupları herhangi bir fiyat listesine dahil değildir'> 
	  <cf_get_lang dictionary_id='37225.Bu gruplar alışveriş yapamayacaktır'> 
	  </td>
  </tr>
</table>
<br/>
