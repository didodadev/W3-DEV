<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate = "">
</cfif>
<cfset attributes.form_submitted = 1>
<cfparam name="attributes.card_no" default="">
<cfparam name="attributes.bonus_type" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.order_sort" default="ASC">
<cfparam name="attributes.order_col" default="FIS_TARIHI">

<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME,OZEL_KOD FROM BRANCH WHERE OZEL_KOD IS NOT NULL ORDER BY BRANCH_NAME 
</cfquery>
<cfset branch_ozel_kod_list = valuelist(get_branch.OZEL_KOD)>
<cfset branch_name_list = valuelist(get_branch.BRANCH_NAME)>

<cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_CARDS" datasource="#DSN_dev#"> 
    SELECT
    	*
    FROM
    	(
        SELECT
            (
            	SELECT 
                	C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME
                FROM
                	#dsn_alias#.CONSUMER C,
                    #dsn_alias#.CUSTOMER_CARDS CC
                WHERE
                	C.CONSUMER_ID = CC.ACTION_ID AND
                    CC.CARD_NO = GA.MUSTERI_NO
            ) AS MUSTERI,
            B.BRANCH_NAME,
            GAT.TYPE_NAME AS BELGE_TUR_ADI,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS KASIYER,
            GA.*
        FROM 
            #dsn_alias#.BRANCH B,
            GENIUS_ACTIONS GA
                INNER JOIN GENIUS_ACTION_TYPES GAT ON (GAT.TYPE_ID = GA.BELGE_TURU)
                INNER JOIN #dsn_alias#.EMPLOYEES E ON (E.EMPLOYEE_ID = GA.KASIYER_NO)
        WHERE 
        	(GA.MUSTERI_NO IS NOT NULL AND MUSTERI_NO <> '') AND
            (GA.KAZANILAN_PUAN > 0 OR GA.KULLANILAN_PUAN > 0) AND
			<cfif len(attributes.startdate)>
                GA.FIS_TARIHI >= #attributes.startdate# AND 
            </cfif>
            <cfif len(attributes.finishdate)>
            	GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)# AND
            </cfif>
            <cfif len(attributes.branch_id)>
            	GA.BRANCH_ID = #attributes.branch_id# AND
            </cfif>
            <cfif len(attributes.card_no)>
            	GA.MUSTERI_NO = '#attributes.card_no#' AND
            </cfif>
            GA.BRANCH_ID = B.BRANCH_ID
        ) T1
    ORDER BY
    	#attributes.order_col# #attributes.order_sort#
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
<cfset total_fis = 0>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="srch_form" action="#request.self#?fuseaction=retail.list_consumer_bonus_report" method="post">
    		<cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="card_no" value="#attributes.card_no#" placeholder="#getLang('','Kart Numarası',30364)#">
                </div>
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#" <cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                        </cfoutput>	
                    </select>
                </div>
                <div class="form-group">
                    <select name="bonus_type" id="bonus_type">
                        <option value=""><cf_get_lang dictionary_id='62373.Puan Tipi'></option>
                        <option value="1" <cfif attributes.bonus_type eq 1>selected</cfif>><cf_get_lang dictionary_id='62374.Kazanılan'></option>
                        <option value="2" <cfif attributes.bonus_type eq 2>selected</cfif>><cf_get_lang dictionary_id='59563.Kullanılan'></option>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput type="text" name="startdate" id="startdate" maxlength="10" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" placeholder="#getLang('','Başlangıç Tarihi',58053)#">				
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" placeholder="#getLang('','Bitiş Tarihi',57700)#">				
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='43958.Kayıt Sayısı Hatalı'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
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
    <cfif len(attributes.finishdate)>
        <cfset adres = adres&"&finishdate=#attributes.finishdate#">
    </cfif>
    <cfif len(attributes.startdate)>
        <cfset adres = adres&"&startdate=#attributes.startdate#">
    </cfif>
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='62375.Müşteri Puan Bilgileri'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='30364.Kart Numarası'></th>
                    <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
                    <th><cf_get_lang dictionary_id='37748.Mağaza'></th>
                    <th><cf_get_lang dictionary_id='39344.Yazar Kasa'></th>
                    <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57946.Fiş No'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61603.Alışveriş Tutarı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='62376.Kazanılan Bonus'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='62377.Kullanılan Bonus'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='62378.Kalan Bonus'></th>
                </tr>
            </thead>
            <tbody>
            <cfif get_cards.recordcount>
                <cfoutput query="GET_CARDS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#MUSTERI_NO#</td>
                        <td>#MUSTERI#</td>
                        <td>#BRANCH_NAME#</td>
                        <td>#KASA_NUMARASI#</td>
                        <td>#dateformat(fis_tarihi,'dd/mm/yyyy')#</td>
                        <td>#FIS_NUMARASI#</td>
                        <td style="text-align:right;">
                            #TLFormat(FIS_TOPLAM)#
                            <cfset total_fis = total_fis + FIS_TOPLAM>
                        </td>
                        <td style="text-align:right;">
                            #TLFormat(KAZANILAN_PUAN)#
                            <cfset total_kazanilan = total_kazanilan + KAZANILAN_PUAN>
                        </td>
                        <td style="text-align:right;">
                            #TLFormat(KULLANILAN_PUAN)#
                            <cfset total_kullanilan = total_kullanilan + KULLANILAN_PUAN>
                        </td>
                        <td style="text-align:right;">
                            <cfset total_alan = total_kazanilan - total_kullanilan>
                            #TLFormat(total_kazanilan-total_kullanilan,2)#
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr><td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
            </cfif>
            </tbody>
            <tfoot>
                <cfoutput>
                <tr class="color-header">
                    <td colspan="7"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
                    <td style="text-align:right;">#TLFormat(total_fis)#</td>
                    <td style="text-align:right;">#TLFormat(total_kazanilan)#</td>
                    <td style="text-align:right;">#TLFormat(total_kullanilan)#</td>
                    <td style="text-align:right;">#TLFormat(total_kazanilan-total_kullanilan)#</td>
                </tr>
                </cfoutput>
            </tfoot>
        </cf_grid_list>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#" 
            adres="#adres#">
    </cf_box>
</div>
