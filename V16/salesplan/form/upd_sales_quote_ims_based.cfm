<!--- Asagidaki ifade bulundugu ay ve ondan sonraki degerlerin guncellenmesi icin eklendi. --->
<cfsavecontent variable="ay1"><cf_get_lang_main no ='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no ='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no ='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no ='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no ='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no ='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no ='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no ='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no ='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no ='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no ='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no ='191.Aralık'></cfsavecontent>
<cfscript>
	kontrol_date = createDateTime(year(now()),month(now()),01,0,0,0);
	aylar = '#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#';
	list_target = "IMS Hedefi,Karlılık Hedefi,Ciro Hedefi,Tahsilat Hedefi";
</cfscript>
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_SALES_QUOTES_GROUP" datasource="#dsn#">
	SELECT QUOTE_YEAR FROM SALES_QUOTES_GROUP WHERE SALES_QUOTE_ID = #attributes.sales_quote_id#
</cfquery>
<cfquery name="GET_TEAM_NAME" datasource="#dsn#">
	SELECT TEAM_NAME FROM SALES_ZONES_TEAM WHERE TEAM_ID = #attributes.ims_team_id#
</cfquery>
<cfquery name="GET_SALES_QUOTE_ZONE" datasource="#dsn#">
	SELECT 
		SQ.*,
		SQR.*,
		SZ.SZ_NAME,
		SZ.SZ_ID
	FROM 
		SALES_QUOTES_GROUP SQ,
		SALES_QUOTES_GROUP_ROWS SQR,
		SALES_ZONES SZ
	WHERE		
		SQR.SALES_QUOTE_ID = SQ.SALES_QUOTE_ID AND
		SZ.SZ_ID = SQ.SALES_ZONE_ID AND
		SQR.IMS_TEAM_ID = #attributes.ims_team_id# AND
		SQ.SALES_QUOTE_ID = #attributes.sales_quote_id#
</cfquery>
<cfquery name="GET_QUOTE_TEAMS" datasource="#dsn#">
	SELECT
		SZT.TEAM_NAME,
		SZT.TEAM_ID,
		IMC.IMS_ID,
		SC.IMS_CODE_NAME,
		SC.IMS_CODE
	FROM
		SALES_ZONES_TEAM SZT,
		SALES_ZONES_TEAM_IMS_CODE IMC,
		SETUP_IMS_CODE SC
	WHERE
		SZT.TEAM_ID = #attributes.ims_team_id# AND
		SZT.SALES_ZONES = #get_sales_quote_zone.sales_zone_id# AND
		SZT.TEAM_ID = IMC.TEAM_ID AND
		IMC.IMS_ID = SC.IMS_CODE_ID
</cfquery>
<cfquery name="GET_ROWS" datasource="#dsn#">
	SELECT 
		SQGR.SALES_INCOME,
		SQGR.TOTAL_MARKET,
		SQGR.ROW_MONEY,
		SQGR.QUOTE_MONTH,
		SQGR.IMS_ID AS IMS_ID,
		SQGR.IMS_CODE,
		SQGR.IMS_TEAM_ID
	FROM 
		SALES_QUOTES_GROUP_ROWS SQGR,
		SALES_ZONES_TEAM_IMS_CODE IMC
	WHERE
		SQGR.SALES_QUOTE_ID = #get_sales_quote_zone.sales_quote_id# AND
		IMC.IMS_ID = SQGR.IMS_ID
UNION ALL
	SELECT 
		SQGR.SALES_INCOME,
		SQGR.TOTAL_MARKET,
		SQGR.ROW_MONEY,
		SQGR.QUOTE_MONTH,
		-1 AS IMS_ID,
		'' AS IMS_CODE,
		SQGR.IMS_TEAM_ID
	FROM 
		SALES_QUOTES_GROUP_ROWS SQGR		
	WHERE
		SQGR.SALES_QUOTE_ID = #get_sales_quote_zone.sales_quote_id# AND
		SQGR.IMS_ID IS NULL 
	ORDER BY
		IMS_ID,
		QUOTE_MONTH ASC	
</cfquery>
<cfsavecontent variable="title_">
	<cfoutput>#Listgetat(list_target,attributes.target_type)# Güncelle</cfoutput>
</cfsavecontent>
<cf_popup_box title="#title_#">
    <cfform name="form_basket" method="post" action="#request.self#?fuseaction=salesplan.emptypopup_upd_sales_quote_ims_based">
        <input type="hidden" name="sales_zone_id" id="sales_zone_id" value="<cfoutput>#get_sales_quote_zone.sales_zone_id#</cfoutput>">
        <input type="hidden" name="quote_year" id="quote_year" value="<cfoutput>#get_sales_quote_zone.quote_year#</cfoutput>">
        <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
        <input type="hidden" name="target_type" id="target_type" value="<cfoutput>#get_sales_quote_zone.target_type#</cfoutput>">
        <input type="hidden" name="sales_quote_id" id="sales_quote_id" value="<cfoutput>#get_sales_quote_zone.sales_quote_id#</cfoutput>">
        <input type="hidden" name="ims_team_id" id="ims_team_id" value="<cfoutput>#attributes.ims_team_id#</cfoutput>">
        <table>
            <tr>
                <td width="80px"><cf_get_lang_main no='247.Satış Bölgesi'></td>
                <td width="200px"><input type="text" name="sales_zone" id="sales_zone" value="<cfoutput>#get_sales_quote_zone.sz_name#</cfoutput>" readonly  style="width:150px;"></td>
                <td width="80px">Hedef Tipi *</td>
                <td><select name="target_type_select" id="target_type_select" onchange="window.open(this.options[this.selectedIndex].value,'_self')" style="width:100px;">
                  <cfoutput>
                  <cfloop from="1" to="#listlen(list_target)#" index="i">
                    <option value="#request.self#?fuseaction=salesplan.popup_check_sales_quote_ims_based&target_type=#i#&team_id=#get_sales_quote_zone.sales_zone_id#-#attributes.ims_team_id#-#attributes.branch_id#&quote_year=#get_sales_quote_zone.quote_year#&is_submit=1" <cfif get_sales_quote_zone.target_type eq i>selected</cfif>>#Listgetat(list_target,i)#</option>
                  </cfloop>
                  </cfoutput>
                  </select></td>
            </tr>
            <tr>
                <td><cf_get_lang no='12.İlgili Şube'></td>
                <td><cfinclude template="../query/get_branch_name.cfm">
                  <input type="text" name="sales_zone" id="sales_zone" value="<cfoutput>#get_branch_name.branch_name#</cfoutput>" readonly style="width:150px;"></td>
                <td><cf_get_lang_main no='1060.Dönem'> *</td>
                <td>
                    <select name="quote_year_select" id="quote_year_select" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }" style="width:100px;">
						<cfoutput>
                            <cfloop from="#session.ep.period_year#" to="2020" index="i">
                                <option value="#request.self#?fuseaction=salesplan.popup_check_sales_quote_ims_based&quote_year=#i#&team_id=#get_sales_quote_zone.sales_zone_id#-#attributes.ims_team_id#-#attributes.branch_id#&target_type=#get_sales_quote_zone.target_type#&is_submit=1" <cfif get_sales_quote_zone.quote_year eq i>selected</cfif>>#i#</option>
                            </cfloop>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang no='115.Planlayan'></td>
                <td><input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_sales_quote_zone.planner_emp_id#</cfoutput>">
                 <input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(get_sales_quote_zone.planner_emp_id,0,0)#</cfoutput>" readonly style="width:150px;">
                 <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.employee_id&field_name=form_basket.employee_name','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
                <td><cf_get_lang_main no='217.Açıklama'></td>
                <td rowspan="2"><textarea name="quote_detail" id="quote_detail" style="width:200px;height:45px;"><cfoutput>#get_sales_quote_zone.quote_detail#</cfoutput></textarea></td>
            </tr>
            <tr>
                <td><cf_get_lang no='34.Takım Adı'></td>
                <td><input type="text" name="team_name" id="team_name" value="<cfoutput>#get_team_name.team_name#</cfoutput>" readonly style="width:150px;"></td>
                <td>&nbsp;</td>
            </tr> 
        </table>
		<cfscript>
			son_toplam = 0;
			kolon_1 = 0;kolon_2 = 0;kolon_3 = 0;kolon_4 = 0;kolon_5 = 0;kolon_6 = 0;
			kolon_7 = 0;kolon_8 = 0;kolon_9 = 0;kolon_10 = 0;kolon_11 = 0;kolon_12 = 0;
			
			son_toplam_market = 0;
			kolonmarket_1 = 0;kolonmarket_2 = 0;kolonmarket_3 = 0;kolonmarket_4 = 0;kolonmarket_5 = 0;kolonmarket_6 = 0;
			kolonmarket_7 = 0;kolonmarket_8 = 0;kolonmarket_9 = 0;kolonmarket_10 = 0;kolonmarket_11 = 0;kolonmarket_12 = 0;
		</cfscript>
        <cf_basket>
		<table class="detail_basket_list">
        <thead>
            <tr>
                <th width="75"><cf_get_lang_main no='77.Para Birimi'></th>
                <th colspan="70">
                	<select name="money" id="money">
						<cfoutput query="get_moneys">
                            <option value="#money#" <cfif get_sales_quote_zone.quote_money is '#money#'>selected</cfif>>#money#</option>
                        </cfoutput>
                    </select>
                </th>
            </tr>
            <tr>
                <th>
                    IMS
                    <input type="hidden" name="ims_ids" id="ims_ids" value="<cfoutput>#valuelist(get_quote_teams.ims_id)#</cfoutput>">
                    <input type="hidden" name="team_ids" id="team_ids" value="<cfoutput>#valuelist(get_quote_teams.team_id)#</cfoutput>">
                    <input type="hidden" name="ims_codes" id="ims_codes" value="<cfoutput>#valuelist(get_quote_teams.ims_code)#</cfoutput>">
                </th>
                <cfset im = 0>
                <cfloop from="1" to="12" index="k">
                    <th align="center" colspan="3"><cfoutput>#Listgetat(aylar,k)#</cfoutput></th>
                    <cfif k mod 3 eq 0>
                       <cfset im = im + 1>
                    <th align="center" colspan="3"><cfoutput>#im#</cfoutput>. Çeyrek</th>
                    </cfif>
                </cfloop>
                <th colspan="3" align="center">12 Aylık Ortalama</th>
                <th align="center" colspan="3" nowrap style="display:none;"><cf_get_lang_main no='758.Satır Toplam'></th>
            </tr>
            <tr>
                <th>&nbsp;</th>
                <cfloop from="1" to="12" index="k">
                    <th align="center"><cf_get_lang_main no='539.Hedef'></th>
                    <th align="center"><cf_get_lang no='52.Gerçekleşen'></th>
                    <th align="center">%</th>
                    <cfif k mod 3 eq 0>
                        <th align="center"><cf_get_lang_main no='539.Hedef'></th>
                        <th align="center"><cf_get_lang no='52.Gerçekleşen'></th>
                        <th align="center">%</th>
                    </cfif>
                </cfloop>
                <th align="center"><cf_get_lang_main no='539.Hedef'></th>
                <th align="center"><cf_get_lang no='52.Gerçekleşen'></th>
                <th align="center">%</th>
                <th align="center" style="display:none;"><cf_get_lang_main no='539.Hedef'></th>
                <th align="center" style="display:none;"><cf_get_lang no='52.Gerçekleşen'></th>
                <th align="center" style="display:none;">%</th>
            </tr>
            <cfif get_sales_quote_zone.recordcount>
            <cfquery name="GET_SALES_OTHER_QUOTES" datasource="#dsn#">
                SELECT
                SQGR.QUOTE_MONTH,
                SQGR.SALES_INCOME,
                SQGR.ROW_MONEY
                FROM
                SALES_QUOTES_GROUP SQ,
                SALES_QUOTES_GROUP_ROWS SQGR
                WHERE
                SQ.QUOTE_TYPE = 2 AND
                SQGR.SALES_QUOTE_ID = SQ.SALES_QUOTE_ID AND
                SQ.QUOTE_YEAR = #get_sales_quote_zone.quote_year# AND
                SQ.SALES_ZONE_ID = #get_sales_quote_zone.sales_zone_id# AND
                SQGR.TEAM_ID = #get_sales_quote_zone.ims_team_id#
                ORDER BY
                SQGR.QUOTE_MONTH ASC
            </cfquery>
         </thead>
         <tbody>
            <tr>
                <td class="txtbold"><cf_get_lang no='121.Brickler'></td>
                <cfset toplam_other_quotes=0>
                <cfif get_sales_other_quotes.recordcount>
                <cfoutput query="get_sales_other_quotes">
                <td nowrap width="75"> <cf_get_lang no='122.Depo Satışı'><!--- #tlformat(get_sales_other_quotes.SALES_INCOME,0)# ---></td>
                <cfset toplam_other_quotes=toplam_other_quotes+get_sales_other_quotes.sales_income>
                <td nowrap width="75"><cf_get_lang no='123.Pazar Tahmini'></td>
                <td width="45"><cf_get_lang no='124.Pazar Payı'> %</td>
                </cfoutput>
                <td nowrap width="75"><cf_get_lang no='122.Depo Satışı'><!--- <cfoutput>#tlformat(toplam_other_quotes,0)#</cfoutput> ---></td>
                <td nowrap width="75"><cf_get_lang no='123.Pazar Tahmini'></td>
                <td width="45"><cf_get_lang no='124.Pazar Payı'> %</td>
                <cfelse>
                <td colspan="70" align="center"><cf_get_lang no='118.Kayıtlı Takım Hedefi Yok'></td>
                </cfif>
            </tr>
            </cfif>
            <cfscript>
				geneltoplam1a = 0;
				geneltoplam1b = 0;
				geneltoplam2a = 0;
				geneltoplam2b = 0;
				geneltoplam3a = 0;
				geneltoplam3b = 0;
				geneltoplam4a = 0;
				geneltoplam4b = 0;
            </cfscript>
            <cfoutput query="get_quote_teams">
            <tr>
                <td nowrap class="txtbold">#ims_code# - #ims_code_name#</td>
                <cfscript>
                toplam = 0;
                toplam_market = 0;
                imsd = 0;
                total11 = 0;
                total12 = 0;
                total13 = 0;
                klms = 0;
                </cfscript>
                <cfloop from="1" to="12" index="k">
                <cfset klms = klms + 1>
                <cfquery name="get_team_target" dbtype="query">
                SELECT
                    SALES_INCOME,
                    TOTAL_MARKET
                FROM
                    GET_ROWS
                WHERE
                    QUOTE_MONTH = #k# AND
                    IMS_ID = #IMS_ID# AND
                    IMS_TEAM_ID = #TEAM_ID#
                </cfquery>
                <cfif get_team_target.recordcount and len(get_team_target.sales_income)>
                <cfset yazilacak_rakam = get_team_target.sales_income>
                <cfelse>
                <cfset yazilacak_rakam = 0>
                </cfif>
                <cfif get_team_target.recordcount and len(get_team_target.total_market)>
                <cfset yazilacak_market = get_team_target.total_market>
                <cfelse>
                <cfset yazilacak_market = 0>
                </cfif>
                <cfset 'kolon_#k#' = evaluate("kolon_#k#") + yazilacak_rakam>
                <cfset 'kolonmarket_#k#' = evaluate("kolonmarket_#k#") + yazilacak_market>
                <cfset son_toplam = son_toplam + yazilacak_rakam>
                <cfset son_toplam_market = son_toplam_market + yazilacak_market>
                <cfset toplam = toplam + yazilacak_rakam>
                <cfset toplam_market = toplam_market + yazilacak_market>
                <cfif yazilacak_market gt 0>
                 <cfset ay_ortalama = (100 * yazilacak_rakam) / yazilacak_market>
                <cfelse>
                 <cfset ay_ortalama = 0>
                </cfif>
                <cfif evaluate("kolonmarket_#k#") gt 0>
                 <cfset 'kolonortalama_#k#' = (100 * evaluate("kolon_#k#")) / evaluate("kolonmarket_#k#")>
                <cfelse>
                 <cfset 'kolonortalama_#k#' = 0>
                </cfif>
                <cfif toplam_market gt 0>
                 <cfset toplam_ortalama = (100 * toplam) / toplam_market>
                <cfelse>
                 <cfset toplam_ortalama = 0>
                </cfif>
                <cfset total11 = total11 + yazilacak_market>
                <cfset total12 = total12 + yazilacak_rakam>
                <cfif total11 gt 0>
                 <cfset total13 = (100 * (total12/3)) / (total11/3)>
                </cfif>
                <td nowrap width="75"><input name="teammarket_#team_id#_#ims_id#_#k#" id="teammarket_#team_id#_#ims_id#_#k#" type="text" class="box" style="width:100%;" tabindex="#k#" onFocus="son_deger_degis_team(#team_id#,#ims_id#,#k#);" onBlur="toplam_al_team(#team_id#,#ims_id#,#k#);" onkeyup="return(FormatCurrency(this,event,2));" value="#tlformat(yazilacak_market,2)#" <cfif kontrol_date gt createdatetime(get_sales_quote_zone.quote_year,klms,01,0,0,0)><cfif not get_module_power_user(41)> readonly</cfif></cfif> autocomplete="off"></td>
                <td nowrap width="75"><input name="team_#team_id#_#ims_id#_#k#" id="team_#team_id#_#ims_id#_#k#" type="text" class="box" style="width:100%;" tabindex="#k#" onFocus="son_deger_degis(#team_id#,#ims_id#,#k#);" onBlur="toplam_al(#team_id#,#ims_id#,#k#);" onKeyUp="return(FormatCurrency(this,event,2));" value="#tlformat(yazilacak_rakam,2)#" <cfif kontrol_date gt createdatetime(get_sales_quote_zone.quote_year,klms,01,0,0,0)><cfif not get_module_power_user(41)> readonly</cfif></cfif> autocomplete="off"></td>
                <td nowrap width="50"><input type="text" name="teamortalama_#team_id#_#ims_id#_#k#" id="teamortalama_#team_id#_#ims_id#_#k#" value="#tlformat(ay_ortalama,2)#" readonly="yes" class="box" style="width:100%;"></td>
                <cfif k mod 3 eq 0>
					<cfset imsd = imsd + 1>
                    <cfif (k eq 1) or (k eq 2) or (k eq 3)>
                    <cfset geneltoplam1a = geneltoplam1a + (total11/3)>
                    <cfset geneltoplam1b = geneltoplam1b + (total12/3)>
                    <cfelseif (k eq 4) or (k eq 5) or (k eq 6)>
                    <cfset geneltoplam2a = geneltoplam2a + (total11/3)>
                    <cfset geneltoplam2b = geneltoplam2b + (total12/3)>
                    <cfelseif (k eq 7) or (k eq 8) or (k eq 9)>
                    <cfset geneltoplam3a = geneltoplam3a + (total11/3)>
                    <cfset geneltoplam3b = geneltoplam3b + (total12/3)>
                    <cfelseif (k eq 10) or (k eq 11) or (k eq 12)>
                    <cfset geneltoplam4a = geneltoplam4a + (total11/3)>
                    <cfset geneltoplam4b = geneltoplam4b + (total12/3)>
                </cfif>
                <td nowrap width="75"><cfinput type="text" name="quarter_teammarket_#team_id#_#ims_id#_#imsd#"  readonly style="width:100%;" class="box" value="#tlformat((total11/3),2)#"></td>
                <td nowrap width="75"><cfinput type="text" name="quarter_team_#team_id#_#ims_id#_#imsd#" readonly style="width:100%;" value="#tlformat((total12/3),2)#" class="box"></td>
                <td nowrap width="50"><cfinput type="text" name="quarter_teamortalama_#team_id#_#ims_id#_#imsd#" value="#tlformat(total13,2)#" class="box" readonly style="width:100%;"></td>
                </cfif>
                <cfif (k eq 3) or (k eq 6) or (k eq 9) or (k eq 12)>
					<cfset total11 = 0>
                    <cfset total12 = 0>
                    <cfset total13 = 0>
                </cfif>
                </cfloop>
                <td nowrap><cfinput type="text" name="ortalama_toplammarket_#team_id#_#ims_id#" class="box" readonly style="width:100%;" value="#tlformat((toplam_market/12),2)#"></td>
                <td><cfinput type="text" name="ortalama_toplam_#team_id#_#ims_id#" class="box" readonly style="width:100%;" value="#tlformat((toplam/12),2)#"></td>
                <td><cfinput type="text" name="ortalama_toplamortalama_#team_id#_#ims_id#" class="box" readonly style="width:100%;" value="#tlformat(toplam_ortalama,2)#"></td>
                <td nowrap width="75" style="display:none;"><cfinput type="text" name="toplammarket_#team_id#_#ims_id#" value="#tlformat(toplam_market,2)#" class="box" readonly style="width:100%;"></td>
                <td nowrap width="75" style="display:none;"><cfinput type="text" name="toplam_#team_id#_#ims_id#" value="#tlformat(toplam,2)#" class="box" readonly style="width:100%;"></td>
                <td nowrap width="50" style="display:none;"><cfinput type="text" name="toplamortalama_#team_id#_#ims_id#" value="#tlformat(toplam_ortalama,2)#" readonly class="box" style="width:100%;"></td>
            </tr>
            </cfoutput>
            <cfoutput>
            <tr>
                <td nowrap class="txtbold"><cfoutput>#get_team_name.team_name#</cfoutput></td>
					<cfscript>
                    toplam = 0;
                    toplam_market = 0;
                    imsk = 0;
                    total21 = 0;
                    total22 = 0;
                    total23 = 0;
                    </cfscript>
                    <cfloop from="1" to="12" index="k">
                    <cfquery name="get_team_target" dbtype="query">
                    SELECT SALES_INCOME, TOTAL_MARKET, IMS_TEAM_ID FROM GET_ROWS WHERE QUOTE_MONTH = #k# AND IMS_CODE = ''
                    </cfquery>
                    <cfif get_team_target.recordcount and len(get_team_target.sales_income)>
                    <cfset yazilacak_rakam = get_team_target.sales_income>
                    <cfelse>
                    <cfset yazilacak_rakam = 0>
                    </cfif>
                    <cfif get_team_target.recordcount and len(get_team_target.total_market)>
                    <cfset yazilacak_market = get_team_target.total_market>
                    <cfelse>
                    <cfset yazilacak_market = 0>
                    </cfif>
                    <cfset 'kolon_#k#' = evaluate("kolon_#k#") + yazilacak_rakam>
                    <cfset 'kolonmarket_#k#' = evaluate("kolonmarket_#k#") + yazilacak_market>
                    <cfset son_toplam = son_toplam + yazilacak_rakam>
                    <cfset son_toplam_market = son_toplam_market + yazilacak_market>
                    <cfset toplam = toplam + yazilacak_rakam>
                    <cfset toplam_market = toplam_market + yazilacak_market>
                    <cfif yazilacak_market gt 0>
                     <cfset ay_ortalama = (100 * yazilacak_rakam) / yazilacak_market>
                    <cfelse>
                     <cfset ay_ortalama = 0>
                    </cfif>
                    <cfif evaluate("kolonmarket_#k#") gt 0>
                     <cfset 'kolonortalama_#k#' = (100 * evaluate("kolon_#k#")) / evaluate("kolonmarket_#k#")>
                    <cfelse>
                     <cfset 'kolonortalama_#k#' = 0>
                    </cfif>
                    <cfif toplam_market gt 0>
                     <cfset toplam_ortalama = (100 * toplam) / toplam_market>
                    <cfelse>
                     <cfset toplam_ortalama = 0>
                    </cfif>
                    <cfset readonly_ = "">
                    <cfif kontrol_date gt createdatetime(get_sales_quote_zone.quote_year,k,01,0,0,0)><cfif not get_module_power_user(41)><cfset readonly_ = "readonly"></cfif></cfif>
                <td nowrap width="75"><input #readonly_# name="teammarket_#ims_team_id#_YY_#k#" id="teammarket_#ims_team_id#_YY_#k#" type="text" class="box" style="width:100%;" tabindex="#k#" onFocus="son_deger_degis_team(#ims_team_id#,'YY',#k#);" onBlur="toplam_al_team(#ims_team_id#,'YY',#k#);" onkeyup="return(FormatCurrency(this,event,2));" value="#tlformat(yazilacak_market,2)#" autocomplete="off"></td>
                <td nowrap width="75"><input #readonly_# name="team_#ims_team_id#_YY_#k#" id="team_#ims_team_id#_YY_#k#" type="text" class="box" style="width:100%;" tabindex="#k#" onFocus="son_deger_degis(#ims_team_id#,'YY',#k#);" onBlur="toplam_al(#ims_team_id#,'YY',#k#);" onKeyUp="return(FormatCurrency(this,event,2));" value="#tlformat(yazilacak_rakam,2)#" autocomplete="off"></td>
                <td nowrap width="50"><input type="text" name="teamortalama_#ims_team_id#_YY_#k#" id="teamortalama_#ims_team_id#_YY_#k#" value="#tlformat(ay_ortalama,2)#" readonly="yes" class="box" style="width:100%;"></td>
					<cfset total21 = total21 + yazilacak_market>
                    <cfset total22 = total22 + yazilacak_rakam>
                    <cfif total21 gt 0>
                     <cfset total23 = (100 * (total22/3)) / (total21/3)>
                    </cfif>
                    <cfif k mod 3 eq 0>
                    <cfset imsk = imsk + 1>
                    <cfif (k eq 1) or (k eq 2) or (k eq 3)>
                        <cfset geneltoplam1a = geneltoplam1a + (total21/3)>
                        <cfset geneltoplam1b = geneltoplam1b + (total22/3)>
                    <cfelseif (k eq 4) or (k eq 5) or (k eq 6)>
                        <cfset geneltoplam2a = geneltoplam2a + (total21/3)>
                        <cfset geneltoplam2b = geneltoplam2b + (total22/3)>
                    <cfelseif (k eq 7) or (k eq 8) or (k eq 9)>
                        <cfset geneltoplam3a = geneltoplam3a + (total21/3)>
                        <cfset geneltoplam3b = geneltoplam3b + (total22/3)>
                    <cfelseif (k eq 10) or (k eq 11) or (k eq 12)>
                        <cfset geneltoplam4a = geneltoplam4a + (total21/3)>
                        <cfset geneltoplam4b = geneltoplam4b + (total22/3)>
                    </cfif>
                <td nowrap width="75"><cfinput type="text" name="quarter_teammarket_#attributes.ims_team_id#_YY_#imsk#" readonly style="width:100%;" class="box" value="#tlformat((total21/3),2)#"></td>
                <td nowrap width="75"><cfinput type="text" name="quarter_team_#attributes.ims_team_id#_YY_#imsk#" readonly style="width:100%;" value="#tlformat((total22/3),2)#" class="box"></td>
                <td nowrap width="50"><cfinput type="text" name="quarter_teamortalama_#attributes.ims_team_id#_YY_#imsk#" value="#tlformat(total23,2)#" class="box" readonly style="width:100%;"></td>
                </cfif>
                <cfif (k eq 3) or (k eq 6) or (k eq 9) or (k eq 12)>
					<cfset total21 = 0>
                    <cfset total22 = 0>
                    <cfset total23 = 0>
                </cfif>
                </cfloop>
                <td nowrap><cfinput type="text" name="ortalama_toplammarket_#attributes.ims_team_id#_YY" value="#tlformat((toplam_market/12),2)#" class="box" readonly style="width:100%;"></td>
                <td><cfinput type="text" name="ortalama_toplam_#attributes.ims_team_id#_YY" value="#tlformat((toplam/12),2)#" class="box" readonly style="width:100%;"></td>
                <td><cfinput type="text" name="ortalama_toplamortalama_#attributes.ims_team_id#_YY" value="#tlformat(toplam_ortalama,2)#" class="box" readonly style="width:100%;"></td>
                <td nowrap width="75" style="display:none;"><cfinput type="text" name="toplammarket_#ims_team_id#_YY" value="#tlformat(toplam_market,2)#" class="box" readonly style="width:100%;"></td>
                <td nowrap width="75" style="display:none;"><cfinput type="text" name="toplam_#ims_team_id#_YY" value="#tlformat(toplam,2)#" class="box" readonly style="width:100%;"></td>
                <td nowrap width="50" style="display:none;"><cfinput type="text" name="toplamortalama_#ims_team_id#_YY" value="#tlformat(toplam_ortalama,2)#" readonly class="box" style="width:100%;"></td>
            </tr>
            </cfoutput>
          </tbody>
          <tfoot>
            <tr>
                <td><cf_get_lang no='119.Toplamlar'></td>
                <cfset imsm = 0>
                <cfloop from="1" to="12" index="m">
                    <td nowrap width="75"><input type="text" name="toplammarket_colon_<cfoutput>#m#</cfoutput>" id="toplammarket_colon_<cfoutput>#m#</cfoutput>" class="box" value="<cfoutput>#tlformat(evaluate("kolonmarket_#m#"),2)#</cfoutput>" readonly style="width:100%;"></td>
                    <td nowrap width="75"><input type="text" name="toplam_colon_<cfoutput>#m#</cfoutput>" id="toplam_colon_<cfoutput>#m#</cfoutput>" class="box" value="<cfoutput>#tlformat(evaluate("kolon_#m#"),2)#</cfoutput>" readonly style="width:100%;"></td>
                    <td nowrap width="50"><input type="text" name="toplamortalama_colon_<cfoutput>#m#</cfoutput>" id="toplamortalama_colon_<cfoutput>#m#</cfoutput>" value="<cfoutput>#tlformat(evaluate("kolonortalama_#m#"),2)#</cfoutput>" class="box" readonly style="width:100%;"></td>
                    <cfif m mod 3 eq 0>
						<cfset imsm = imsm + 1>
                        <cfif (m eq 1) or (m eq 2) or (m eq 3)>
                            <td nowrap><input type="text" name="quarter_toplammarket_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplammarket_colon_<cfoutput>#imsm#</cfoutput>" style="width:100%;" class="box" value="<cfoutput>#tlformat(geneltoplam1a,2)#</cfoutput>" readonly></td>
                            <td><input type="text" name="quarter_toplam_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplam_colon_<cfoutput>#imsm#</cfoutput>" style="width:100%;" class="box" value="<cfoutput>#tlformat(geneltoplam1b,2)#</cfoutput>" readonly></td>
                            <td><input type="text" name="quarter_toplamortalama_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplamortalama_colon_<cfoutput>#imsm#</cfoutput>" value="0" class="box" style="width:100%;" readonly></td>
                        <cfelseif (m eq 4) or (m eq 5) or (m eq 6)>
                            <td nowrap><input type="text" name="quarter_toplammarket_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplammarket_colon_<cfoutput>#imsm#</cfoutput>" style="width:100%;" class="box" value="<cfoutput>#tlformat(geneltoplam2a,2)#</cfoutput>" readonly></td>
                            <td><input type="text" name="quarter_toplam_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplam_colon_<cfoutput>#imsm#</cfoutput>" style="width:100%;" class="box" value="<cfoutput>#tlformat(geneltoplam2b,2)#</cfoutput>" readonly></td>
                            <td><input type="text" name="quarter_toplamortalama_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplamortalama_colon_<cfoutput>#imsm#</cfoutput>" value="0" class="box" style="width:100%;" readonly></td>
                        <cfelseif (m eq 7) or (m eq 8) or (m eq 9)>
                            <td nowrap><input type="text" name="quarter_toplammarket_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplammarket_colon_<cfoutput>#imsm#</cfoutput>" style="width:100%;" class="box" value="<cfoutput>#tlformat(geneltoplam3a,2)#</cfoutput>" readonly></td>
                            <td><input type="text" name="quarter_toplam_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplam_colon_<cfoutput>#imsm#</cfoutput>" style="width:100%;" class="box" value="<cfoutput>#tlformat(geneltoplam3b,2)#</cfoutput>" readonly></td>
                            <td><input type="text" name="quarter_toplamortalama_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplamortalama_colon_<cfoutput>#imsm#</cfoutput>" value="0" class="box" style="width:100%;" readonly></td>
                        <cfelseif (m eq 10) or (m eq 11) or (m eq 12)>
                            <td nowrap><input type="text" name="quarter_toplammarket_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplammarket_colon_<cfoutput>#imsm#</cfoutput>" style="width:100%;" class="box" value="<cfoutput>#tlformat(geneltoplam4a,2)#</cfoutput>" readonly></td>
                            <td><input type="text" name="quarter_toplam_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplam_colon_<cfoutput>#imsm#</cfoutput>" style="width:100%;" class="box" value="<cfoutput>#tlformat(geneltoplam4b,2)#</cfoutput>" readonly></td>
                            <td><input type="text" name="quarter_toplamortalama_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplamortalama_colon_<cfoutput>#imsm#</cfoutput>" value="0" class="box" style="width:100%;" readonly></td>
                        </cfif>
                    </cfif>
                </cfloop>
                <cfif son_toplam_market gt 0>
                <cfset son_toplam_ortalama = (100 * son_toplam) / son_toplam_market>
                <cfelse>
                <cfset son_toplam_ortalama = 0>
                </cfif>
                <td nowrap width="75"><input type="text" name="ortalama_son_toplam_market" id="ortalama_son_toplam_market" style="width:100%;" class="box" value="<cfoutput>#tlformat((son_toplam_market/12),2)#</cfoutput>" readonly></td>
                <td nowrap width="75"><input type="text" name="ortalama_son_toplam" id="ortalama_son_toplam" style="width:100%;" class="box" value="<cfoutput>#tlformat((son_toplam/12),2)#</cfoutput>" readonly></td>
                <td nowrap width="50"><input type="text" name="ortalama_son_toplam_ortalama" id="ortalama_son_toplam_ortalama" style="width:100%;" class="box" value="0" readonly></td>
                <td nowrap style="display:none;"><input type="text" name="son_toplam_market" id="son_toplam_market" value="<cfoutput>#tlformat(son_toplam_market,2)#</cfoutput>" class="box" readonly style="width:100%;"></td>
                <td style="display:none;"><input type="text" name="son_toplam" id="son_toplam" value="<cfoutput>#tlformat(son_toplam,2)#</cfoutput>" class="box" readonly style="width:100%;"></td>
                <td style="display:none;"><input type="text" name="son_toplam_ortalama" id="son_toplam_ortalama" class="box" value="<cfoutput>#tlformat(son_toplam_ortalama,2)#</cfoutput>" readonly style="width:100%;"></td>
            </tr>
          </tbody>
	    </table>
        </cf_basket>
        <cf_popup_box_footer>
            <cf_record_info query_name="get_sales_quote_zone">
            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='upd_form()'>
        </cf_popup_box_footer>
    </cfform>
</cf_popup_box>	
<script type="text/javascript">
function upd_form(){
	x = (200 - form_basket.quote_detail.value.length);
	if(x < 0){ 
		alert ("<cf_get_lang_main no='217.Açıklama'> "+ ((-1) * x) +" Karakter Uzun");
		return false;
	}	
	UnformatFields();
	<cfoutput query="get_quote_teams">
	for(var i=1; i<=12; i++){
		if(eval("form_basket.team_#team_id#_#ims_id#_"+i).value == '')
			eval("form_basket.team_#team_id#_#ims_id#_"+i).value = 0;
		if(eval("form_basket.teammarket_#team_id#_#ims_id#_"+i).value == '')
			eval("form_basket.teammarket_#team_id#_#ims_id#_"+i).value = 0;
	}
	</cfoutput>
	<cfoutput>
	for(var i=1; i<=12; i++){
		if(eval("form_basket.team_#attributes.ims_team_id#_YY_"+i).value == '')
			eval("form_basket.team_#attributes.ims_team_id#_YY_"+i).value = 0;
		if(eval("form_basket.teammarket_#attributes.ims_team_id#_YY_"+i).value == '')
			eval("form_basket.teammarket_#attributes.ims_team_id#_YY_"+i).value = 0;
	}
	</cfoutput>
	return true;
}
function UnformatFields(){	
	<cfoutput query="get_quote_teams">
	for(var i=1; i<=12; i++){ 
		eval("form_basket.team_#team_id#_#ims_id#_"+i).value = filterNum(eval("form_basket.team_#team_id#_#ims_id#_"+i).value);
		eval("form_basket.teammarket_#team_id#_#ims_id#_"+i).value = filterNum(eval("form_basket.teammarket_#team_id#_#ims_id#_"+i).value);
	}
	</cfoutput>
	<cfoutput>
	for(var i=1; i<=12; i++){ 
		eval("form_basket.team_#attributes.ims_team_id#_YY_"+i).value = filterNum(eval("form_basket.team_#attributes.ims_team_id#_YY_"+i).value);
		eval("form_basket.teammarket_#attributes.ims_team_id#_YY_"+i).value = filterNum(eval("form_basket.teammarket_#attributes.ims_team_id#_YY_"+i).value);
	}
	</cfoutput>	
}
function son_deger_degis(satir_id,kolon_adi,kolon_no)
{
	son_deger = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	son_deger = filterNum(son_deger);
}
function toplam_al(satir_id,kolon_adi,kolon_no)
{
	gelen_satir_toplam_partner = eval("form_basket.toplammarket_" + satir_id + "_" + kolon_adi).value;
	gelen_satir_toplam_partner = filterNum(gelen_satir_toplam_partner);
	gelen_satir_toplam = eval("form_basket.toplam_" + satir_id + "_" + kolon_adi).value;
	gelen_satir_toplam = filterNum(gelen_satir_toplam);
	
	gelen_input_partner = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	gelen_input_partner = filterNum(gelen_input_partner);
	gelen_input = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	gelen_input = filterNum(gelen_input);
	
	gelen_kolon_toplam_partner = eval("form_basket.toplammarket_colon_" + kolon_no).value;
	gelen_kolon_toplam_partner = filterNum(gelen_kolon_toplam_partner);
	gelen_kolon_toplam = eval("form_basket.toplam_colon_" + kolon_no).value;
	gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
	
	son_toplam_partner = form_basket.son_toplam_market.value;
	son_toplam_partner = filterNum(son_toplam_partner);
	son_toplam = form_basket.son_toplam.value;
	son_toplam = filterNum(son_toplam);
			
	son_toplam = (son_toplam + gelen_input) - son_deger;
	gelen_kolon_toplam = (gelen_kolon_toplam + gelen_input) - son_deger;
	gelen_satir_toplam = (gelen_satir_toplam + gelen_input) - son_deger;
	
	if(gelen_input_partner > 0)
		ay_ortalama = (100 * gelen_input) / gelen_input_partner;
	else
		ay_ortalama = 0;
	
	if(gelen_satir_toplam_partner > 0)
		satir_ortalama = (100 * gelen_satir_toplam) / gelen_satir_toplam_partner;
	else
		satir_ortalama = 0;
	
	if(gelen_kolon_toplam_partner > 0)
		kolon_ortalama = (100 * gelen_kolon_toplam) / gelen_kolon_toplam_partner;
	else
		kolon_ortalama = 0;
	
	if(son_toplam_partner > 0)
		son_toplam_ortalama = (100 * son_toplam) / son_toplam_partner;
	else
		son_toplam_ortalama = 0;
	
	if((kolon_no == 1) || (kolon_no == 2) || (kolon_no == 3)){
		ceyrekdeger = 1;
		ortalamatoplanacak1 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_1.value");
		ortalamatoplanacak2 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_2.value");
		ortalamatoplanacak3 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_3.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak1) + filterNum(ortalamatoplanacak2) + filterNum(ortalamatoplanacak3))/3;
	}
	else if((kolon_no == 4) || (kolon_no == 5) || (kolon_no == 6)){
		ceyrekdeger = 2;
		ortalamatoplanacak4 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_4.value");
		ortalamatoplanacak5 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_5.value");
		ortalamatoplanacak6 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_6.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak4) + filterNum(ortalamatoplanacak5) + filterNum(ortalamatoplanacak6))/3;
	}
	else if((kolon_no == 7) || (kolon_no == 8) || (kolon_no == 9)){	
		ceyrekdeger = 3;
		ortalamatoplanacak7 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_7.value");
		ortalamatoplanacak8 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_8.value");
		ortalamatoplanacak9 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_9.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak7) + filterNum(ortalamatoplanacak8) + filterNum(ortalamatoplanacak9))/3;
	}
	else if((kolon_no == 10) || (kolon_no == 11) || (kolon_no == 12)){
		ceyrekdeger = 4;
		ortalamatoplanacak10 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_10.value");
		ortalamatoplanacak11 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_11.value");
		ortalamatoplanacak12 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_12.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak10) + filterNum(ortalamatoplanacak11) + filterNum(ortalamatoplanacak12))/3;
	}
	/*eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(ilkceyrekortalam,2);*/
	gelenceyrekgerceklesen = eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	gelenceyrekgerceklesen = filterNum(gelenceyrekgerceklesen);
	
	degereski = eval("form_basket.quarter_team_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	degereski = filterNum(degereski);
	/*gelenceyrektoplam = eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	gelenceyrektoplam = filterNum(gelenceyrektoplam);*/
	
	ceyrekdegertoplam = eval("form_basket.quarter_toplam_colon_" + ceyrekdeger).value;
	ceyrekdegertoplam = filterNum(ceyrekdegertoplam);

	ceyrekdegertoplam = ceyrekdegertoplam + ilkceyrekortalama - degereski; 
	
	if(gelenceyrekgerceklesen > 0)
		yuzdegerceklesen = (100 * ilkceyrekortalama) / gelenceyrekgerceklesen;
	else
		yuzdegerceklesen = 0;
	
	eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(gelenceyrekgerceklesen,2);
	eval("form_basket.quarter_team_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(ilkceyrekortalama,2);
	eval("form_basket.quarter_teamortalama_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(yuzdegerceklesen,2);
	eval("form_basket.quarter_toplam_colon_" + ceyrekdeger).value = commaSplit(ceyrekdegertoplam,2);
	
	ortalama_son_toplam_ = commaSplit(son_toplam/12);
	deger_ortalama_toplam = commaSplit(gelen_satir_toplam/12);
	gelen_input = commaSplit(gelen_input,2);
	gelen_satir_toplam = commaSplit(gelen_satir_toplam,2);
	gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,2);
	son_toplam = commaSplit(son_toplam,2);
	ay_ortalama = commaSplit(ay_ortalama,2);
	satir_ortalama = commaSplit(satir_ortalama,2);
	kolon_ortalama = commaSplit(kolon_ortalama,2);
	son_toplam_ortalama = commaSplit(son_toplam_ortalama,2);
	
	eval("form_basket.ortalama_toplam_" + satir_id + "_" + kolon_adi).value = deger_ortalama_toplam;
	eval("form_basket.toplam_" + satir_id + "_" + kolon_adi).value = gelen_satir_toplam;
	eval("form_basket.toplam_colon_" + kolon_no).value = gelen_kolon_toplam;
	eval("form_basket.teamortalama_" + satir_id + "_" + kolon_adi + "_" + kolon_no).value = ay_ortalama;
	eval("form_basket.toplamortalama_" + satir_id + "_" + kolon_adi).value = satir_ortalama;
	eval("form_basket.ortalama_toplamortalama_" + satir_id + "_" + kolon_adi).value = satir_ortalama;
	eval("form_basket.toplamortalama_colon_" + kolon_no).value = kolon_ortalama;
	eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no).value = gelen_input;
	form_basket.son_toplam_ortalama.value = son_toplam_ortalama;
	form_basket.son_toplam.value = son_toplam;
	form_basket.ortalama_son_toplam.value = ortalama_son_toplam_;
	
}
function son_deger_degis_team(satir_id,kolon_adi,kolon_no)
{
	son_deger_market = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	son_deger_market = filterNum(son_deger_market);
}
function toplam_al_team(satir_id,kolon_adi,kolon_no,type)
{
	
	gelen_satir_toplam = eval("form_basket.toplammarket_" + satir_id + "_" + kolon_adi).value;
	gelen_satir_toplam = filterNum(gelen_satir_toplam);
	gelen_satir_toplam_partner = eval("form_basket.toplam_" + satir_id + "_" + kolon_adi).value;
	gelen_satir_toplam_partner = filterNum(gelen_satir_toplam_partner);
	
	gelen_input = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	gelen_input = filterNum(gelen_input);
	gelen_input_partner = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	gelen_input_partner = filterNum(gelen_input_partner);
	
	gelen_kolon_toplam = eval("form_basket.toplammarket_colon_" + kolon_no).value;
	gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
	gelen_kolon_toplam_partner = eval("form_basket.toplam_colon_" + kolon_no).value;
	gelen_kolon_toplam_partner = filterNum(gelen_kolon_toplam_partner);
	
	son_toplam = form_basket.son_toplam_market.value;
	son_toplam = filterNum(son_toplam);
	son_toplam_partner = form_basket.son_toplam.value;
	son_toplam_partner = filterNum(son_toplam_partner);
			
	son_toplam = (son_toplam + gelen_input) - son_deger_market;
	gelen_kolon_toplam = (gelen_kolon_toplam + gelen_input) - son_deger_market;
	gelen_satir_toplam = (gelen_satir_toplam + gelen_input) - son_deger_market;

	if(gelen_input > 0)
		ay_ortalama = (100 * gelen_input_partner) / gelen_input;
	else
		ay_ortalama = 0;
	
	if(gelen_satir_toplam > 0)
		satir_ortalama = (100 * gelen_satir_toplam_partner) / gelen_satir_toplam;
	else
		satir_ortalama = 0;
	
	if(gelen_kolon_toplam > 0)
		kolon_ortalama = (100 * gelen_kolon_toplam_partner) / gelen_kolon_toplam;
	else
		kolon_ortalama = 0;
	
	if(son_toplam > 0)
		son_toplam_ortalama = (100 * son_toplam_partner) / son_toplam;
	else
		son_toplam_ortalama = 0;
	
	if((kolon_no == 1) || (kolon_no == 2) || (kolon_no == 3)){
		ceyrekdeger = 1;
		ortalamatoplanacak1 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_1.value");
		ortalamatoplanacak2 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_2.value");
		ortalamatoplanacak3 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_3.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak1) + filterNum(ortalamatoplanacak2) + filterNum(ortalamatoplanacak3))/3;
	}
	else if((kolon_no == 4) || (kolon_no == 5) || (kolon_no == 6)){
		ceyrekdeger = 2;
		ortalamatoplanacak4 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_4.value");
		ortalamatoplanacak5 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_5.value");
		ortalamatoplanacak6 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_6.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak4) + filterNum(ortalamatoplanacak5) + filterNum(ortalamatoplanacak6))/3;
	}
	else if((kolon_no == 7) || (kolon_no == 8) || (kolon_no == 9)){	
		ceyrekdeger = 3;
		ortalamatoplanacak7 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_7.value");
		ortalamatoplanacak8 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_8.value");
		ortalamatoplanacak9 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_9.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak7) + filterNum(ortalamatoplanacak8) + filterNum(ortalamatoplanacak9))/3;
	}
	else if((kolon_no == 10) || (kolon_no == 11) || (kolon_no == 12)){
		ceyrekdeger = 4;
		ortalamatoplanacak10 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_10.value");
		ortalamatoplanacak11 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_11.value");
		ortalamatoplanacak12 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_12.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak10) + filterNum(ortalamatoplanacak11) + filterNum(ortalamatoplanacak12))/3;
	}
	/*eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(ilkceyrekortalam,2);*/
	gelenceyrekgerceklesen = eval("form_basket.quarter_team_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	gelenceyrekgerceklesen = filterNum(gelenceyrekgerceklesen);
	
	degereski = eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	degereski = filterNum(degereski);
		
	/*gelenceyrektoplam = eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	gelenceyrektoplam = filterNum(gelenceyrektoplam);*/
	
	ceyrekdegertoplam = eval("form_basket.quarter_toplammarket_colon_" + ceyrekdeger).value;
	ceyrekdegertoplam = filterNum(ceyrekdegertoplam);

	ceyrekdegertoplam = ceyrekdegertoplam + ilkceyrekortalama - degereski; 
	
	if(gelenceyrekgerceklesen > 0)
		yuzdegerceklesen = (100 * gelenceyrekgerceklesen) / ilkceyrekortalama;
	else
		yuzdegerceklesen = 0;
	
	eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(ilkceyrekortalama,2);
	eval("form_basket.quarter_team_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(gelenceyrekgerceklesen,2);
	eval("form_basket.quarter_teamortalama_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(yuzdegerceklesen,2);
	eval("form_basket.quarter_toplammarket_colon_" + ceyrekdeger).value = commaSplit(ceyrekdegertoplam,2);
	
	ortalama_son_toplam_ = commaSplit(son_toplam/12);
	deger_ortalama_toplam = commaSplit(gelen_satir_toplam/12);
	gelen_input = commaSplit(gelen_input,2);
	gelen_satir_toplam = commaSplit(gelen_satir_toplam,2);
	gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,2);
	son_toplam = commaSplit(son_toplam,2);
	ay_ortalama = commaSplit(ay_ortalama,2);
	satir_ortalama = commaSplit(satir_ortalama,2);
	kolon_ortalama = commaSplit(kolon_ortalama,2);
	son_toplam_ortalama = commaSplit(son_toplam_ortalama,2);
	
	eval("form_basket.ortalama_toplammarket_" + satir_id + "_" + kolon_adi).value = deger_ortalama_toplam;
	eval("form_basket.toplammarket_" + satir_id + "_" + kolon_adi).value = gelen_satir_toplam;
	eval("form_basket.toplammarket_colon_" + kolon_no).value = gelen_kolon_toplam;
	eval("form_basket.teamortalama_" + satir_id + "_" + kolon_adi + "_" + kolon_no).value = ay_ortalama;
	eval("form_basket.toplamortalama_" + satir_id + "_" + kolon_adi).value = satir_ortalama;
	eval("form_basket.ortalama_toplamortalama_" + satir_id + "_" + kolon_adi).value = satir_ortalama;
	eval("form_basket.toplamortalama_colon_" + kolon_no).value = kolon_ortalama;
	eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_" + kolon_no).value = gelen_input;
	form_basket.son_toplam_ortalama.value = son_toplam_ortalama;
	form_basket.son_toplam_market.value = son_toplam;
	form_basket.ortalama_son_toplam_market.value = ortalama_son_toplam_;
}
</script>
