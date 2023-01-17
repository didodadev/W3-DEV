<cfinclude template="../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfif isdefined('session.ww.userid')>
	 <cfquery name="GET_CONS_CAT" datasource="#DSN#">
        SELECT DISTINCT 
            CC.CONSCAT,
            CC.CONSCAT_ID 
        FROM 
            CONSUMER_CAT CC,
            CATEGORY_SITE_DOMAIN CSD 
        WHERE 
            CC.CONSCAT_ID = CSD.CATEGORY_ID
    </cfquery>
	<cfif isdefined("attributes.form_submitted")>
		<cfquery name="GET_CONS_REF_CODE" datasource="#DSN#">
            SELECT CONSUMER_REFERENCE_CODE,CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
        </cfquery>
        <cfquery name="GET_CAMP_ID" datasource="#DSN3#">
            SELECT 
                CAMP_ID,
                CAMP_HEAD
            FROM 
                CAMPAIGNS 
            WHERE 
                CAMP_STARTDATE <= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> AND
                CAMP_FINISHDATE >= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
        </cfquery>
        <cfif get_camp_id.recordcount>
            <cfquery name="GET_LEVEL" datasource="#DSN3#">
                SELECT ISNULL(MAX(PREMIUM_LEVEL),0) AS PRE_LEVEL FROM SETUP_CONSCAT_PREMIUM WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cons_ref_code.consumer_cat_id#"> AND CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_camp_id.camp_id#">
            </cfquery>
            <cfset ref_count = get_level.pre_level + listlen(get_cons_ref_code.consumer_reference_code,'.')>
        <cfelse>
            <cfset ref_count = 0>
        </cfif>
		<cfquery name="GET_REF_MEMBER" datasource="#DSN#">
            SELECT 
                C.CONSUMER_ID,
                C.CONSUMER_NAME,
                C.CONSUMER_SURNAME,
                C.MEMBER_CODE,
                C.REF_POS_CODE,
				O.DEMAND_AMOUNT,
				O.GIVEN_AMOUNT,
				O.STOCK_ID,
				O.DEMAND_AMOUNT,
				O.DEMAND_TYPE,
				O.RECORD_DATE,
                S.PRODUCT_NAME,
                S.STOCK_CODE_2,
                S.PROPERTY,
                CC.CONSCAT
            FROM 
                CONSUMER C,
                CONSUMER_CAT CC,
                CATEGORY_SITE_DOMAIN CSD,
				#DSN3#.ORDER_DEMANDS O,
                #DSN3#.STOCKS S
            WHERE
                (
                    C.REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR 
                    (
                        C.CONSUMER_REFERENCE_CODE IS NOT NULL AND
                        '.'+C.CONSUMER_REFERENCE_CODE+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#session.ww.userid#.%"> AND
                        (LEN(REPLACE(C.CONSUMER_REFERENCE_CODE,'.','..'))-LEN(C.CONSUMER_REFERENCE_CODE)+1) < = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_count#">
                    )
                ) AND
                C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
                CC.CONSCAT_ID = CSD.CATEGORY_ID AND
				C.CONSUMER_ID = O.RECORD_CON AND 
                <!---CSD.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND --->
                <cfif isDefined('session.pp.menu_id')>
                	CSD.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#"> AND
                <cfelse>
                	CSD.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#"> AND                
                </cfif>
                CSD.MEMBER_TYPE = 'CONSUMER' AND
				O.RECORD_CON = C.CONSUMER_ID AND
                O.DEMAND_STATUS = 1 AND
                S.STOCK_ID =  O.STOCK_ID AND
				O.DEMAND_AMOUNT - O.GIVEN_AMOUNT > 0 AND
                C.CONSUMER_STATUS = 1 
				<cfif isdefined("attributes.conscat") and len(attributes.conscat)>
					AND CC.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.conscat#">
				</cfif>
				<cfif isdefined("attributes.my_ref_keyword") and len(attributes.my_ref_keyword)>
					<cfif len(attributes.my_ref_keyword) eq 1>
						AND (C.CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.my_ref_keyword#%"> OR C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.my_ref_keyword#%"> OR C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.my_ref_keyword#%"> OR S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.my_ref_keyword#%">)
					<cfelse>
						AND (C.CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_ref_keyword#%"> OR C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_ref_keyword#%"> OR C.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_ref_keyword#%"> OR S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_ref_keyword#%">)
					</cfif>
				</cfif>
			ORDER BY
				C.CONSUMER_NAME,
				C.CONSUMER_SURNAME,
                S.PRODUCT_NAME
        </cfquery>
	<cfelse>
	 	<cfset get_ref_member.recordcount = 0>
	</cfif>
</cfif>
<cfif isdefined("session.ww.maxrows")>
	<cfparam name="attributes.maxrows" default='session.ww.maxrows'>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_ref_member.recordcount#">
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset stock_list = ''>
<cfif get_ref_member.recordcount>
	<cfoutput query="get_ref_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif len(stock_id) and not listfind(stock_list,stock_id,',')>
			<cfset stock_list = listappend(stock_list,stock_id)>
		</cfif>					
	</cfoutput>
</cfif>
<cfif listlen(stock_list)>
	<cfset stock_list=listsort(stock_list,"numeric","ASC",",")>
	<cfquery name="GET_STOCKS" datasource="#DSN3#">
		SELECT PRODUCT_NAME,PROPERTY,STOCK_ID,PRODUCT_ID,PRODUCT_CODE_2 FROM STOCKS WHERE STOCK_ID IN (#stock_list#) ORDER BY PRODUCT_NAME
	</cfquery>
	<cfset stock_list = listsort(listdeleteduplicates(valuelist(get_stocks.stock_id,',')),'numeric','ASC',',')>
</cfif>

<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
	<tr>
		<td align="right" style="text-align:right;">
		<cfform name="my_ref" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
			<table  align="right">
        		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <tr>
                    <td></td>
                    <td><input type="text" name="my_ref_keyword" id="my_ref_keyword" value="<cfif isdefined('attributes.my_ref_keyword')><cfoutput>#attributes.my_ref_keyword#</cfoutput></cfif>" maxlength="255"></td>
                    <td>
                        <select name="conscat" id="conscat">
                            <option value=""><cf_get_lang no='933.Seviye'></option>
                            <cfoutput query="get_cons_cat">
                                <option value="#conscat_id#" <cfif isdefined('attributes.conscat') and attributes.conscat eq conscat_id>selected="selected"</cfif>>#conscat#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td><cf_wrk_search_button></td>
                </tr>
			</table>
		</cfform>
		</td>
	</tr>
</table>

<table cellspacing="2" cellpadding="1" border="0" align="center" style="width:100%;">
	<tr class="color-header" style="height:22px;">
		<td class="form-title" style="width:20px;"><cf_get_lang_main no='75.No'></td>
		<td class="form-title" style="width:50px;"><cf_get_lang_main no='146.Uye No'></td>
		<td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
		<td class="form-title">Ürün</td>
		<td class="form-title"><cf_get_lang no='933.Seviye'></td>
		<td class="form-title">Ürün Kodu</td>
		<td class="form-title">Miktar</td>
		<td class="form-title">Takip Türü</td>
		<td class="form-title">Tarih</td>
	</tr>
	<cfif get_ref_member.recordcount>
		<cfoutput query="get_ref_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
				<td align="center">#currentrow#</td>
				<td align="right" style="padding-right:10px;">#member_code#</td>
				<td><a href="#request.self#?fuseaction=objects2.reference_detail&cid=#consumer_id#" class="tableyazi" title="Temsilci Detay">#consumer_name#&nbsp;#consumer_surname#</a></td>
				<td>#product_name# #property#</td>
				<td>#conscat#</td>	
				<td>#stock_code_2#</td>
				<td style="text-align:center;">#demand_amount-given_amount#</td>
				<td><cfif demand_type eq 1>Fiyat Habercisi<cfelseif demand_type eq 2>Stok Habercisi<cfelseif demand_type eq 3>Ön Sipariş</cfif></td>
				<td>#dateformat(record_date,'dd/mm/yyyy')#</td>
			</tr>
		</cfoutput> 
	<cfelse>
		<tr class="color-row" style="height:20px;"> 
			<td colspan="11"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no="72.Kayit Yok"> !<cfelse><cf_get_lang_main no="289.Filtre Ediniz"> !</cfif></td>
		</tr>
	</cfif>
</table>

<cfif attributes.maxrows lt attributes.totalrecords> 
	<cfset url_str = "">
	<cfif isdefined("attributes.my_ref_keyword") and len(attributes.my_ref_keyword)>
		<cfset url_str = "#url_str#&my_ref_keyword=#attributes.my_ref_keyword#">
	</cfif>
	<cfif isdefined("attributes.conscat") and len(attributes.conscat)>
		<cfset url_str = "#url_str#&conscat=#attributes.conscat#">
	</cfif>
	<cfif isdefined("attributes.form_submitted")>
		<cfset url_str = "#url_str#&form_submitted=1">
	</cfif>
	<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:100%; height:35px;">
		<tr> 
			<td> 
			  	<cf_pages page="#attributes.page#" 
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="objects2.list_my_ref_order_demands#url_str#"> 
			</td>
			<td align="right" style="text-align:right;"><cfoutput> <cf_get_lang_main no="128.Toplam Kayit">:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no="169.Sayfa">:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('my_ref_keyword').focus();
</script>
