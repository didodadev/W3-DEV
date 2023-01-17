<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate = now()>
</cfif>
<cfset attributes.form_submitted = 1>
<cfparam name="attributes.card_no" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.top_r" default="10">

<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME,OZEL_KOD FROM BRANCH WHERE OZEL_KOD IS NOT NULL ORDER BY BRANCH_NAME 
</cfquery>
<cfset branch_ozel_kod_list = valuelist(get_branch.OZEL_KOD)>
<cfset branch_name_list = valuelist(get_branch.BRANCH_NAME)>


<cfset adres = "retail.list_consumer_bonus_report&form_submitted=1">
<cfif len(attributes.finishdate)>
	<cfset adres = adres&"&finishdate=#attributes.finishdate#">
</cfif>
<cfif len(attributes.startdate)>
	<cfset adres = adres&"&startdate=#attributes.startdate#">
</cfif>
<cfif len(attributes.branch_id)>
	<cfset adres = adres&"&branch_id=#attributes.branch_id#">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Müşteri Puan Dashboard',62970)#">
        <cfform name="srch_form" action="#request.self#?fuseaction=retail.list_consumer_bonus_dash" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-card_no">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30364.Kart Numarası'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="card_no" value="#attributes.card_no#">
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29434.Şubeler'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="branch_id" id="branch_id">
                                <option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
                                <cfoutput query="get_branch">
                                    <option value="#ozel_kod#" <cfif attributes.branch_id eq ozel_kod>selected</cfif>>#branch_name#</option>
                                </cfoutput>	
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-startdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="startdate" id="startdate" maxlength="10" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate">				
						        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate">			
						        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57483.Kayıt'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="top_r" id="top_r">
                                <option value="10" <cfif attributes.top_r eq 10>selected</cfif>>10 <cf_get_lang dictionary_id='57483.Kayıt'></option>
                                <option value="25" <cfif attributes.top_r eq 25>selected</cfif>>25 <cf_get_lang dictionary_id='57483.Kayıt'></option>
                                <option value="50" <cfif attributes.top_r eq 50>selected</cfif>>50 <cf_get_lang dictionary_id='57483.Kayıt'></option>
                                <option value="75" <cfif attributes.top_r eq 75>selected</cfif>>75 <cf_get_lang dictionary_id='57483.Kayıt'></option>
                                <option value="100" <cfif attributes.top_r eq 100>selected</cfif>>100 <cf_get_lang dictionary_id='57483.Kayıt'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <cf_wrk_search_button button_type="1" search_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
    <cf_box  title="#getLang('','En Çok İşlem Yapan',39889)# #attributes.top_r# #getLang('','Kullanıcı',57930)#" uidrop="1">
        <cfquery name="GET_TOP_10_HAREKET" datasource="#DSN#"> 
            SELECT TOP #attributes.top_r#
                *
            FROM
                (
                SELECT
                    (
                        SELECT 
                            COUNT(GA2.ACTION_ID)
                            FROM 
                            #dsn3_alias#.POS_EQUIPMENT PE,
                            #dsn_dev_alias#.GENIUS_ACTIONS GA2 
                            WHERE 
                            GA2.MUSTERI_NO = CC.CARD_NO AND
                            PE.EQUIPMENT_CODE = GA2.KASA_NUMARASI
                            <cfif len(attributes.branch_id)>
                                AND PE.BRANCH_ID = #attributes.branch_id#
                            </cfif>
                            <cfif len(attributes.startdate)>
                                AND GA2.FIS_TARIHI >= #attributes.startdate# 
                            </cfif>
                            <cfif len(attributes.finishdate)>
                                AND GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
                            </cfif>
                    ) AS TOPLAM_HAREKET,
                    (
                        SELECT 
                            COUNT(DISTINCT CAST(YEAR(FIS_TARIHI) AS NVARCHAR) + CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + CAST(DAY(FIS_TARIHI) AS NVARCHAR))
                            FROM 
                            #dsn3_alias#.POS_EQUIPMENT PE,
                            #dsn_dev_alias#.GENIUS_ACTIONS GA2 
                            WHERE 
                            GA2.MUSTERI_NO = CC.CARD_NO AND
                            PE.EQUIPMENT_CODE = GA2.KASA_NUMARASI
                            <cfif len(attributes.branch_id)>
                                AND PE.BRANCH_ID = #attributes.branch_id#
                            </cfif>
                            <cfif len(attributes.startdate)>
                                AND GA2.FIS_TARIHI >= #attributes.startdate# 
                            </cfif>
                            <cfif len(attributes.finishdate)>
                                AND GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
                            </cfif>
                    ) AS TOPLAM_GUN,
                    (
                        SELECT 
                            C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME
                        FROM
                            #dsn_alias#.CONSUMER C
                        WHERE
                            C.CONSUMER_ID = CC.ACTION_ID
                    ) AS MUSTERI,
                    CC.CARD_NO
                FROM 
                    CUSTOMER_CARDS CC
                WHERE
                    CC.CARD_NO IS NOT NULL
                    <cfif len(attributes.card_no)>
                        AND CC.CARD_NO = '#attributes.card_no#'
                    </cfif>
                ) T1
            ORDER BY
                TOPLAM_HAREKET DESC
        </cfquery>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='54817.Kart No'></th>
                    <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
                    <th><cf_get_lang dictionary_id='62855.Toplam Hareket'></th>
                    <th><cf_get_lang dictionary_id='57490.Gün'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="GET_TOP_10_HAREKET">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#CARD_NO#</td>
                        <td>#MUSTERI#</td>
                        <td><a href="#request.self#?fuseaction=#adres#&card_no=#CARD_NO#" class="tableyazi" target="p_window">#TOPLAM_HAREKET#</a></td>
                        <td>#TOPLAM_GUN#</td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
    <cf_box title="#getLang('','En Çok Puan Kazanan',62856)# #attributes.top_r# #getLang('','Kullanıcı',57930)#" uidrop="1">
        <cfquery name="GET_TOP_10_HAREKET" datasource="#DSN#"> 
            SELECT TOP #attributes.top_r#
                *
            FROM
                (
                SELECT
                    (
                        SELECT 
                            SUM(GA2.KAZANILAN_PUAN) 
                            FROM 
                            #dsn3_alias#.POS_EQUIPMENT PE,
                            #dsn_dev_alias#.GENIUS_ACTIONS GA2 
                            WHERE 
                            GA2.MUSTERI_NO = CC.CARD_NO AND
                            PE.EQUIPMENT_CODE = GA2.KASA_NUMARASI
                            <cfif len(attributes.branch_id)>
                                AND PE.BRANCH_ID = #attributes.branch_id#
                            </cfif>
                            <cfif len(attributes.startdate)>
                                AND GA2.FIS_TARIHI >= #attributes.startdate# 
                            </cfif>
                            <cfif len(attributes.finishdate)>
                                AND GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
                            </cfif>
                    ) AS TOPLAM_PUAN,
                    (
                        SELECT 
                            COUNT(DISTINCT CAST(YEAR(FIS_TARIHI) AS NVARCHAR) + CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + CAST(DAY(FIS_TARIHI) AS NVARCHAR))
                            FROM 
                            #dsn3_alias#.POS_EQUIPMENT PE,
                            #dsn_dev_alias#.GENIUS_ACTIONS GA2 
                            WHERE 
                            GA2.MUSTERI_NO = CC.CARD_NO AND
                            PE.EQUIPMENT_CODE = GA2.KASA_NUMARASI
                            <cfif len(attributes.branch_id)>
                                AND PE.BRANCH_ID = #attributes.branch_id#
                            </cfif>
                            <cfif len(attributes.startdate)>
                                AND GA2.FIS_TARIHI >= #attributes.startdate# 
                            </cfif>
                            <cfif len(attributes.finishdate)>
                                AND GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
                            </cfif>
                    ) AS TOPLAM_GUN,
                    (
                        SELECT 
                            C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME
                        FROM
                            #dsn_alias#.CONSUMER C
                        WHERE
                            C.CONSUMER_ID = CC.ACTION_ID
                    ) AS MUSTERI,
                    CC.CARD_NO
                FROM 
                    CUSTOMER_CARDS CC
                WHERE
                    CC.CARD_NO IS NOT NULL
                    <cfif len(attributes.card_no)>
                        AND CC.CARD_NO = '#attributes.card_no#'
                    </cfif>
                ) T1
            ORDER BY
                TOPLAM_PUAN DESC
        </cfquery>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='54817.Kart No'></th>
                    <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
                    <th class="text-right"><cf_get_lang dictionary_id='58985.Toplam Puan'></th>
                    <th><cf_get_lang dictionary_id='57490.Gün'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="GET_TOP_10_HAREKET">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#CARD_NO#</td>
                        <td>#MUSTERI#</td>
                        <td class="text-right"><a href="#request.self#?fuseaction=#adres#&card_no=#CARD_NO#" class="tableyazi" target="p_window">#tlformat(TOPLAM_PUAN)#</a></td>
                        <td>#TOPLAM_GUN#</td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>

<script type="text/javascript">
	
	function kontrol()
	{
		return date_check(document.getElementById('startdate'),document.getElementById('finishdate'),"<cf_get_lang dictionary_id='56017.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
	}
</script>