<cf_get_lang_set module_name="report">
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_ezgi_branch_analist">
<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
	<cfset adres = '#adres#&keyword=#attributes.keyword#'>
</cfif>
<cfif isDefined('attributes.oby') and len(attributes.oby)>
	<cfset adres = '#adres#&oby=#attributes.oby#'>
</cfif>
<cfif isdefined('attributes.analyst_status') and len(attributes.analyst_status)>
	<cfset adres = '#adres#&analyst_status=#attributes.analyst_status#'>
</cfif>
<cfif isdefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
	<cfset adres = adres&"&is_form_submitted=1">
</cfif>
<cfset total_ezgi_gelir = 0>
<cfset total_ezgi_gider = 0>
<cfset total_ezgi_sonuc = 0>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.oby" default="1">
<cfparam name="attributes.analyst_status" default="">
<cfparam name="attributes.month_value" default="">
<cfparam name="attributes.year_value" default="">
<cfparam name="attributes.branch_id" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_ezgi_branch_analist.cfm">
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_analyst_branch.recordcount = 0>
	<cfset arama_yapilmali = 1>
</cfif>
<cfquery name="get_period" datasource="#dsn#">
	SELECT        
    	TOP (5) PERIOD_YEAR
	FROM            
    	SETUP_PERIOD
	WHERE        
    	OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY 
    	PERIOD_YEAR DESC
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
</cfquery>
<cfoutput query="get_branch">
	<cfset 'BRANCH_NAME_#BRANCH_ID#' = BRANCH_NAME>
</cfoutput>
<cfquery name="get_price_cat" datasource="#dsn3#">
	SELECT PRICE_CATID, BRANCH, PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND IS_SALES = 1
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_analyst_branch.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="branch_analist" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_ezgi_branch_analist" method="post">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
 	<cf_big_list_search title="#getLang('main',3604)#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'></td>
					<td width="115px"><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
                    <td width="80px">
                   		<select name="year_value" id="year_value" style="width:65px; height:20px">
                        	<option value="" <cfif attributes.month_value eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
                        	<cfoutput query="get_period">
                        		<option value="#PERIOD_YEAR#" <cfif attributes.year_value eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
                            </cfoutput>
               			</select>
                	</td>
                    <td width="85px">
                   		<select name="month_value" id="month_value" style="width:70px; height:20px">
                        	<option value="" <cfif attributes.month_value eq ''>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
                            <option value="1" <cfif attributes.month_value eq 1>selected</cfif>><cf_get_lang_main no='180.Ocak'></option>
                            <option value="2" <cfif attributes.month_value eq 2>selected</cfif>><cf_get_lang_main no='181.Şubat'></option>
                            <option value="3" <cfif attributes.month_value eq 3>selected</cfif>><cf_get_lang_main no='182.Mart'></option>
                            <option value="4" <cfif attributes.month_value eq 4>selected</cfif>><cf_get_lang_main no='183.Nisan'></option>
                            <option value="5" <cfif attributes.month_value eq 5>selected</cfif>><cf_get_lang_main no='184.Mayıs'></option>
                            <option value="6" <cfif attributes.month_value eq 6>selected</cfif>><cf_get_lang_main no='185.Haziran'></option>
                            <option value="7" <cfif attributes.month_value eq 7>selected</cfif>><cf_get_lang_main no='186.Temmuz'></option>
                            <option value="8" <cfif attributes.month_value eq 8>selected</cfif>><cf_get_lang_main no='187.Ağustos'></option>
                            <option value="9" <cfif attributes.month_value eq 9>selected</cfif>><cf_get_lang_main no='188.Eylül'></option>
                            <option value="10" <cfif attributes.month_value eq 10>selected</cfif>><cf_get_lang_main no='189.Ekim'></option>
                            <option value="11" <cfif attributes.month_value eq 11>selected</cfif>><cf_get_lang_main no='190.Kasım'></option>
                            <option value="12" <cfif attributes.month_value eq 12>selected</cfif>><cf_get_lang_main no='191.Aralık'></option>
                 		</select>
                  	</td>
                    <td width="110px">
                   		<select name="branch_id" id="branch_id" style="width:95px;height:20px">
                         	<option value=""><cf_get_lang_main no='41.Sube'></option>
                          	<cfoutput query="get_branch">
                            	<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and branch_id eq attributes.branch_id>selected</cfif>>#branch_name#</option>
                         	</cfoutput>
                     	</select> 
                 	</td>
                    <td style="text-align:right;">
						<cf_get_lang_main no='487.Kaydeden'>
						<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
						<input name="record_emp_name" type="text" id="record_emp_name" style="width:120px;" onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','branch_analist','3','125');" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput> </cfif>" autocomplete="off">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=branch_analist.record_emp_name&field_emp_id=branch_analist.record_emp_id<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,9','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
                    <td><cf_get_lang_main no='1512.Sıralama'></td>
                    <td align="center">
                        <select name="oby" style="width:120px; height:20px">
                            <option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
                            <option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
                        </select>
                  	</td>
                    <td><cf_get_lang_main no='482.Statü'></td>
                    <td align="center">
                        <select name="analyst_status" style="width:80px; height:20px">
                            <option value=""><cf_get_lang_main no='296.Tümü'></option>
                            <option value="1"<cfif isDefined("attributes.analyst_status") and (attributes.analyst_status eq 1)> selected</cfif>><cf_get_lang_main no='3198.İşleyen'></option>
                            <option value="0"<cfif isDefined("attributes.analyst_status") and (attributes.analyst_status eq 0)> selected</cfif>><cf_get_lang_main no='3105.Biten'></option>
                        </select>
                    </td>
                    <td><cf_wrk_search_button></td>
              	</tr>
          	</table>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<table class="big_list" cellpadding="1" cellspacing="1">
	<cf_big_list id="piece_">
	<thead>
		<tr>
			<th style="width:30px;text-align:center; height:20px" class="header_icn_txt"><cf_get_lang_main no='1165.Sira'></th>
            <th style="width:65px;text-align:center"><cf_get_lang_main no='1043.Yıl'></th>
            <th style="width:65px;text-align:center"><cf_get_lang_main no='1312.Ay'></th>
            <th style="width:65px;text-align:center"><cf_get_lang_main no='41.Sube'></th>
            <th style="width:90px;text-align:center"><cf_get_lang_main no='677.Gelirler'></th>
            <th style="width:90px;text-align:center"><cfoutput>#getLang('budget',47)#</cfoutput></th>
            <th style="width:90px;text-align:center"><cfoutput>#getLang('report',832)# / #getLang('report',833)#</cfoutput></th>
            
		  	<th style="width:70px;text-align:center"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
            <th style="width:170px;text-align:center"><cf_get_lang_main no='487.Kaydeden'></th>
		  	<th style="text-align:center"><cf_get_lang_main no='217.Açıklama'></th>
		  	<th style="width:15px;text-align:center">&nbsp;</th>
            <!-- sil --><th class="header_icn_none"> <a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.</cfoutput>add_ezgi_branch_analist"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='3200.İşlem Tipi Ekle'>"> </a></th><!-- sil -->
		</tr>
   	</thead>
	<tbody>
		<cfif get_analyst_branch.recordcount>
			<cfoutput query="get_analyst_branch" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            	<cfquery name="get_upd" datasource="#dsn3#">
                    SELECT * FROM EZGI_ANALYST_BRANCH WHERE ANALYST_BRANCH_ID = #get_analyst_branch.ANALYST_BRANCH_ID#
                </cfquery>
                <cfset attributes.upd_id = get_analyst_branch.ANALYST_BRANCH_ID>
                <cfinclude template="../query/get_ezgi_branch_gelirler.cfm">
                <cfinclude template="../query/get_ezgi_branch_giderler.cfm">
                <cfinclude template="../query/get_ezgi_branch_sonuc.cfm">
                
                <cfif len(get_TOTAL.SMM)>
					<cfset total_smm = get_TOTAL.SMM>
                <cfelse>
                    <cfset total_smm = 0>
                </cfif>
                <cfif len(GET_TOTAL_EXPENSE.GIDER)>
                    <cfset expense_gider = GET_TOTAL_EXPENSE.GIDER>
                <cfelse>
                    <cfset expense_gider = 0>
                </cfif>
                <cfif len(GET_TOTAL.TOTAL_SALES)>
                    <cfset net_total = GET_TOTAL.TOTAL_SALES>
                <cfelse>
                    <cfset net_total = 0>
                </cfif>
				<tr>
					<td style="text-align:right">#currentrow#&nbsp;</td>
					<td style="text-align:center">
                    	<a href="#request.self#?fuseaction=report.upd_ezgi_branch_analist&upd_id=#ANALYST_BRANCH_ID#" class="tableyazi">
                    		#YEAR_VALUE#
                   		</a>
                    </td>
                    <td style="text-align:center">
                    	<a href="#request.self#?fuseaction=report.upd_ezgi_branch_analist&upd_id=#ANALYST_BRANCH_ID#" class="tableyazi">
                    		#MONTH_VALUE#
                   		</a>
                    </td>
                    <td style="text-align:center">
                    	<a href="#request.self#?fuseaction=report.upd_ezgi_branch_analist&upd_id=#ANALYST_BRANCH_ID#" class="tableyazi">
                        	<cfif IS_BRANCH eq 1>
                    			#Evaluate('BRANCH_NAME_#BRANCH_ID#')#
                            <cfelse>
                            	<strong>
                            	#Evaluate('BRANCH_NAME_#BRANCH_ID#')#
                                </strong>
                            </cfif>
                   		</a>
                    </td>
                    <td style="text-align:right">#TlFormat(net_total-total_smm,2)#</td>
                    <td style="text-align:right">#TlFormat(expense_gider,2)#</td>
                    <td style="text-align:right;background-color:<cfif net_total-total_smm-expense_gider gt 0>PaleTurquoise<cfelseif net_total-total_smm-expense_gider lt 0>Bisque</cfif>">
                    		#TlFormat(net_total-total_smm-expense_gider,2)#
                    </td>
					<td style="text-align:center">#dateformat(get_analyst_branch.DATE,'dd/mm/yyyy')#</td>
                    <td>#get_emp_info(employee_id,0,0)#</td>
                    <td>#DETAIL#</td>
					<td style="text-align:center;">
						<cfif STATUS eq 0>
							 <img src="/images/lock_open.gif" title="<cf_get_lang_main no='2068.Tamamlanmadı'>">
						<cfelse>
							 <img src="/images/lock_buton.gif" title="<cf_get_lang_main no='1374.Tamamlandı'>">
						</cfif>       
					</td>
					
					<td align="center"><a href="#request.self#?fuseaction=report.upd_ezgi_branch_analist&upd_id=#ANALYST_BRANCH_ID#" class="tableyazi"> <img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Düzenle'>" border="0"></a>
					</td>
				</tr>
                <cfset total_ezgi_gelir = total_ezgi_gelir + (net_total-total_smm)>
                <cfset total_ezgi_gider = total_ezgi_gider + (expense_gider)>
			</cfoutput>
			<cfoutput>
				<tr class="color-row" height="20">
					<td colspan="4" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
                    <td style="text-align:right"><strong>#TlFormat(total_ezgi_gelir,2)#</strong></td>
                    <td style="text-align:right"><strong>#TlFormat(total_ezgi_gider,2)#</strong></td>
                    <td style="text-align:right"><strong>#TlFormat(total_ezgi_gelir-total_ezgi_gider,2)#</strong></td>
					<td colspan="5">&nbsp;</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr height="20" class="color-row">
				<td colspan="14"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'><cfelse><cf_get_lang_main no='72.Kayıt Yok'></cfif>!</td>
			</tr>
		</cfif>
   	</tbody>
    </cf_big_list>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<!-- sil -->
	  <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr>
		  <td colspan="5">
			<cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#"
				adres="#adres#">
			</td>
		  <td colspan="5" align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_analyst_branch.recordcount# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	  </table>
	<!-- sil -->
</cfif>
<script language="javascript">
	document.branch_analist.keyword.select();
</script>
