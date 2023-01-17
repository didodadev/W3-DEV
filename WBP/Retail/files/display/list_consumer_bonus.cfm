<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = "">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = "">
</cfif>
<cfset attributes.form_submitted = 1>
<cfparam name="attributes.card_no" default="">
<cfparam name="attributes.bonus_type" default="">
<cfparam name="attributes.branch_id" default="">

<cfif IsDefined("attributes.consumer_id") and len(attributes.consumer_id)>
    <cfquery name="GET_CONS" datasource="#DSN#">
        SELECT GENIUS_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
    </cfquery>
<cfelse>
    <cfquery name="GET_CONS" datasource="#DSN#">
        SELECT GENIUS_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
    </cfquery>
</cfif>
<cfif not len(get_cons.genius_id)>
    Bu Üyeye Ait Kart Bulunmamaktadır.
    <cfexit method="exittemplate">
</cfif>
<cfquery name="get_card" datasource="#dsn_gen#">
	SELECT * FROM CARD WHERE FK_CUSTOMER = #GET_CONS.GENIUS_ID#
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME,OZEL_KOD FROM BRANCH WHERE OZEL_KOD IS NOT NULL ORDER BY BRANCH_NAME 
</cfquery>
<cfset branch_ozel_kod_list = valuelist(get_branch.OZEL_KOD)>
<cfset branch_name_list = valuelist(get_branch.BRANCH_NAME)>
<cfif (len(get_cons.GENIUS_ID) or get_cons.GENIUS_ID neq 0) and isdefined("attributes.form_submitted")>
    <cfquery name="GET_CARDS" datasource="#DSN_GEN#"> 
        SELECT
        	CB.TRANSACTION_DATE,
            C.CODE,
            C.ID,
            CB.*
        FROM 
        	CARD C,
            CUSTOMER_BONUS CB
        WHERE 
        	C.ID = CB.FK_CARD 
            AND C.FK_CUSTOMER = #GET_CONS.GENIUS_ID#
         	<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                AND CB.TRANSACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
            </cfif>
            <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                AND CB.TRANSACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.finish_date)#">
            </cfif>
            <cfif len(attributes.card_no)>
            	AND C.CODE = '#attributes.card_no#'
            </cfif>
            <cfif len(attributes.bonus_type)>
            	AND CB.FK_REASON_TYPE = #attributes.bonus_type#
            </cfif>
            <cfif len(attributes.branch_id)>
            	AND CB.FK_STORE = #attributes.branch_id#
            </cfif>
        ORDER BY 
        	TRANSACTION_DATE DESC
    </cfquery>
<cfelse>
	<cfset get_cards.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif GET_CARDS.recordcount>
	<cfparam name="attributes.totalrecords" default='#GET_CARDS.RECORDCOUNT#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfset total_kazanilan = 0>
<cfset total_kullanilan = 0>
<cfset total_alan = 0>

<cfset url_str = "">
<cfif IsDefined("attributes.consumer_id") and len(attributes.consumer_id)>
   <cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
<cfelse>
   <cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cf_big_list_search title="Müşteri Puan Bilgileri"> 
	<cf_big_list_search_area>
    	<cfform name="srch_form" action="#request.self#?fuseaction=retail.list_consumer_bonus#url_str#" method="post">
    		<table>
            	<tr>
                	<td>
                    	<select name="branch_id" id="branch_id">
                        	<option value="">Şubeler</option>
                        	<cfoutput query="get_branch">
								<option value="#ozel_kod#" <cfif attributes.branch_id eq ozel_kod>selected</cfif>>#branch_name#</option>
							</cfoutput>	
                        </select>
                    </td>
                	<td>
                    	<select name="card_no" id="card_no">
                        	<option value="">Kart No</option>
                            <cfoutput query="get_card">
                            	<option value="#code#" <cfif attributes.card_no eq CODE>selected</cfif>>#code#</option>
							</cfoutput>
                        </select>
                    </td>
                    <td>
                    	<select name="bonus_type" id="bonus_type">
                        	<option value="">Puan Tipi</option>
                            <option value="1" <cfif attributes.bonus_type eq 1>selected</cfif>>Kazanılan</option>
                            <option value="2" <cfif attributes.bonus_type eq 2>selected</cfif>>Kullanılan</option>
                        </select>
                    </td>
                	<td>
						<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate">				
						<cf_wrk_date_image date_field="start_date">
					</td>
					<td>
						<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate">
						<cf_wrk_date_image date_field="finish_date">
					</td>
                    <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                      <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
                	<td><input type="hidden" name="form_submitted" id="form_submitted" value="1">
                    	<cf_wrk_search_button>
                    </td>
                    <td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_add_bonus#url_str#</cfoutput>','small')"><img src="../images/money_plus.gif" title="Puan Ekle Çıkar"></a></td>
                </tr>
            </table>
        </cfform>
    </cf_big_list_search_area>
</cf_big_list_search>
<cf_big_list>
    	<thead>
            <tr>
                <th>Kart Numarası</th>
                <th>Mağaza</th>
                <th>Yazar Kasa</th>
                <th>İşlem Tarihi</th>
                <th>İşlem Kodu</th>
                <th style="text-align:right;">Kazanılan Bonus</th>
                <th style="text-align:right;">Kullanılan Bonus</th>
                <th style="text-align:right;">Kalan Bonus</th>
            </tr>
        </thead>
        <tbody>
        <cfif get_cards.recordcount>
        	<cfif attributes.page neq 1>
            	<cfoutput query="GET_CARDS" startrow="1" maxrows="#attributes.startrow-1#">
                	<cfif FK_REASON_TYPE eq 1>
						<cfset total_kazanilan = total_kazanilan + amount>
                    <cfelse>
                    	<cfset total_kullanilan = total_kullanilan + amount>
                    </cfif>
                </cfoutput>
             <cfset total_alan = total_kazanilan - total_kullanilan> 
              
                        
                <cfoutput>
                <tr>
                    <td colspan="5" class="txtbold">Devir Toplam</td>
                    <td class="txtbold" style="text-align:right;">#TLFormat(total_kazanilan,2)#</td>
                    <td class="txtbold" style="text-align:right;">#TLFormat(total_kullanilan,2)#</td>
                    <td class="txtbold" style="text-align:right;">#TLFormat(total_alan,2)#</td>
                </tr>
                </cfoutput>
            </cfif>
            <cfoutput query="GET_CARDS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            	<tr>
                	<td>#code#</td>
                    <td>
                    <cfif listfind(branch_ozel_kod_list,FK_STORE)>
                    	<cfset sira_ = listfind(branch_ozel_kod_list,FK_STORE)>
                        <cfset b_name_ = listgetat(branch_name_list,sira_)>
                        #b_name_#
                    <cfelse>
                    	-
                    </cfif>
                    </td>
                    <td></td>
                    <td>#dateformat(transaction_date,'dd/mm/yyyy')#</td>
                    <td>#WRK_ID#</td>
                    <td style="text-align:right;">
						<cfif FK_REASON_TYPE eq 1>
							<cfset total_kazanilan = total_kazanilan + amount>
                            #TLFormat(amount,2)#
                        <cfelse>
                        	-
                        </cfif>
                    </td>
                    <td style="text-align:right;">
						<cfif FK_REASON_TYPE eq 2>
							<cfset total_kullanilan = total_kullanilan + amount>
                            #TLFormat(amount,2)#
                        <cfelse>
                        	-
                        </cfif>
                    </td>
                    <td style="text-align:right;">
                    	<cfset total_alan = total_kazanilan - total_kullanilan>
                        #TLFormat(total_kazanilan-total_kullanilan,2)#
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
        	<tr><td colspan="9">Kayıt Yok</td></tr>
        </cfif>
        </tbody>
        <tfoot>
			<cfoutput>
        	<tr class="color-gray">
            	<td colspan="5" class="txtbold">Sayfa Sonu Toplam</td>
                <td class="txtbold" style="text-align:right;">#TLFormat(total_kazanilan,2)#</td>
                <td class="txtbold" style="text-align:right;">#TLFormat(total_kullanilan,2)#</td>
                <td class="txtbold" style="text-align:right;">#TLFormat(total_alan,2)#</td>
            </tr>
            <tr class="color-header">
            	<td class="txtbold" colspan="5">Genel Toplam</td>
                <cfquery name="get_total1" datasource="#dsn_gen#">
                    SELECT ISNULL(SUM(AMOUNT),0) AMOUNT1 FROM CARD C,CUSTOMER_BONUS CB WHERE C.ID = CB.FK_CARD AND C.FK_CUSTOMER = #get_cons.GENIUS_ID# AND FK_REASON_TYPE = 1
                </cfquery>
                <cfquery name="get_total2" datasource="#dsn_gen#">
                    SELECT ISNULL(SUM(AMOUNT),0) AMOUNT2 FROM CARD C,CUSTOMER_BONUS CB WHERE C.ID = CB.FK_CARD AND C.FK_CUSTOMER = #get_cons.GENIUS_ID# AND FK_REASON_TYPE = 2
                </cfquery>
                <td class="txtbold" style="text-align:right;">#TLFormat(get_total1.amount1)#</td>
                <td class="txtbold" style="text-align:right;">#TLFormat(get_total2.amount2)#</td>
                <td class="txtbold" style="text-align:right;">#TLFormat(get_total1.amount1-get_total2.amount2)#</td>
            </tr>
			</cfoutput>
        </tfoot>
</cf_big_list>
<cfset adres = attributes.fuseaction>
<cfif isdefined('form_submitted')><cfset adres = adres&"&form_submitted=1"></cfif>
<cfif len(attributes.card_no)>
	<cfset adres = adres&"&card_no=#attributes.card_no#">
</cfif>
<cfif len(attributes.bonus_type)>
	<cfset adres = adres&"&bonus_type=#attributes.bonus_type#">
</cfif>
<cfif len(attributes.branch_id)>
	<cfset adres = adres&"&branch_id=#attributes.branch_id#">
</cfif>
<cfif IsDefined("attributes.consumer_id") and len(attributes.consumer_id)>
   <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#">
<cfelse>
   <cfset adres = "#adres#&company_id=#attributes.company_id#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset adres = adres&"&finish_date=#attributes.finish_date#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset adres = adres&"&start_date=#attributes.start_date#">
</cfif>

<cf_paging 
	page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#" 
	adres="#adres#">