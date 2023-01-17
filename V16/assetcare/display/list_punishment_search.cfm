<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<!--  Currency'de bir belirsizlik var. Onur P...-->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_punishment_search.cfm">
<cfif isDefined("attributes.is_submitted")>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_punishment_search.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset accident_id_list = ''>
	<cfif get_punishment_search.recordcount>
	<cfquery dbtype="query" name="get_total_punishment">
            SELECT SUM(PAID_AMOUNT) AS TOTAL_PUNISHMENT_AMOUNT FROM get_punishment_search
    </cfquery>
	  <cfoutput query="get_punishment_search" >
		<cfif len(accident_id) and not listFind(accident_id_list,accident_id,',')>
			<cfset accident_id_list = listAppend(accident_id_list,accident_id)>
		</cfif>
	  </cfoutput>
	</cfif>
	<cfif len(accident_id_list)>
	  <cfquery name="get_accident" datasource="#dsn#">
		SELECT
			ASSET_P.ASSETP,
			ASSET_P_ACCIDENT.ACCIDENT_DATE,
			ASSET_P_ACCIDENT.ACCIDENT_ID
		FROM 
			ASSET_P_ACCIDENT,
			ASSET_P
		WHERE
			ASSET_P_ACCIDENT.ACCIDENT_ID IN (#accident_id_list#) AND
			ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID
	  </cfquery>
	</cfif>
</cfif>

<cf_grid_list>
	<thead>
		<tr> 
		  <th><cf_get_lang no='446.Kaza Iliskisi'></th>
		  <th><cf_get_lang_main no='1656.Plaka'></th>
		  <th><cf_get_lang_main no='132.Sorumlu'></th>
		  <th><cf_get_lang no='416.Ceza Tarih'></th>
		  <th><cf_get_lang no='414.Ceza Tipi'></th>
		  <th style="text-align:right;"><cf_get_lang no='417.Ceza Tutar'></th>
		  <th><cf_get_lang no='185.Son Ödeme Tar'></th>
		  <th style="text-align:right;"><cf_get_lang no='418.Ödenen Tutar'></th>
		  <th width="20"></th>
		</tr>
	</thead>
    <tbody>
		<cfif isdefined("attributes.is_submitted")>
			<cfif get_punishment_search.recordcount>
                <cfset aratoplam = 0>
                <cfoutput query="get_punishment_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                    <cfif currentrow eq 1 or ASSETP[currentrow] eq ASSETP[currentrow-1]>
                        <tr> 
                            <td>
                            <cfif len(accident_id)>
                            <cfquery name="get_accident_record" dbtype="query">
                                SELECT * FROM get_accident WHERE ACCIDENT_ID = #accident_id# 
                            </cfquery>
                            <a href="javascript://"   onclick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_accident_detail&accident_id=#get_accident_record.accident_id#');">#get_accident_record.accident_id# 
                            <cf_get_lang no='451.Nolu '>#dateformat(get_accident_record.accident_date,dateformat_style)# 
                            <cf_get_lang no='450.tarihli kaza'></a> </cfif> </td>
                            <td>#assetp#</td>
                            <td><a href="javascript://"   onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','small','popup_emp_det');">#employee_name# #employee_surname#</a></td>
                            <td>#dateformat(punishment_date,dateformat_style)#</td>
                            <td>#punishment_type_name#</td>
                            <td style="text-align:right;"><cfif len(punishment_amount)>#tlformat(punishment_amount)# #punishment_amount_currency#</cfif></td>
                            <td>#dateformat(last_payment_date,dateformat_style)#</td>
                            <td style="text-align:right;">#tlformat(paid_amount)# #paid_amount_currency#</td>
                            <td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_punishment_detail&punishment_id=#punishment_id#','medium','popup_upd_punishment_detail');"><i class="fa fa-pencil" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></i></a></td>
                        </tr>
                        <cfset x = 0>
                        <cfif len(paid_amount)>
                            <cfset x = paid_amount>
                        </cfif>
                        <cfset aratoplam = aratoplam + x>
                    <cfelse>
                        <tr class="total"> 
                            <td colspan="11" style="text-align:right;"><strong><cf_get_lang no='463.Ara Toplam'> : #tlformat(aratoplam)#</strong></td>
                        </tr>
                        <cfset aratoplam = 0>
                        <tr> 
                            <td> <cfif len(accident_id)>
                            <cfquery name="get_accident_record" dbtype="query">
                            SELECT * FROM get_accident WHERE ACCIDENT_ID = #accident_id# 
                            </cfquery>
                            <a href="javascript://"   onclick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_accident_detail&accident_id=#get_accident_record.accident_id#');">#get_accident_record.accident_id# 
                            <cf_get_lang no='451.Nolu'> #dateformat(get_accident_record.accident_date,dateformat_style)# 
                            <cf_get_lang no='450.tarihli kaza'></a></cfif></td>
                            <td>#assetp#</td>
                            <td><a href="javascript://"   onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','small','popup_emp_det');">#employee_name# 
                            #employee_surname#</a></td>
                            <td>#dateformat(punishment_date,dateformat_style)#</td>
                            <td>#punishment_type_name#</td>
                            <td style="text-align:right;"><cfif len(punishment_amount)>
                            #tlformat(punishment_amount)# #punishment_amount_currency#</cfif></td>
                            <td>#dateformat(last_payment_date,dateformat_style)#</td>
                            <td style="text-align:right;">#tlformat(paid_amount)# #paid_amount_currency#</td>
                            <td width="15"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_upd_punishment_detail&punishment_id=#punishment_id#');"><i class="fa fa-pencil" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></i></a></td>
                        </tr>
                        <cfset y = 0>
                        <cfif len(paid_amount)>
                            <cfset y = paid_amount>
                        </cfif>
                        <cfset aratoplam = aratoplam + y>
                    </cfif>
                </cfoutput> 
                <tr class="total"> 
                    <td colspan="11" style="text-align:right;"><strong><cf_get_lang no='463.Ara Toplam'>: <cfoutput>#tlformat(aratoplam)#</cfoutput></strong></td>
                </tr>
                <tr class="total"> 
                    <td colspan="11" style="text-align:right;"><strong><cf_get_lang no='464.Toplam Ödenen Ceza Tutarı'> : <cfoutput>#tlformat(get_total_punishment.total_punishment_amount)#</cfoutput></strong></td>
                </tr>
            <cfelse>
                <tr> 
                    <td colspan="11"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
                </tr>
            </cfif>
        <cfelse>
            <tr> 
                <td colspan="13"><cf_get_lang_main no='289.Filtre Ediniz '>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>
<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined("attributes.branch_id")>
	  <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.branch")>
	  <cfset url_str = "#url_str#&branch=#attributes.branch#">
	</cfif>
	<cfif isdefined("attributes.is_submitted")>
	  <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
	</cfif>
	<cfif isdefined("attributes.assetp_id")>
	  <cfset url_str = "#url_str#&assetp_id=#attributes.assetp_id#">
	</cfif>
	<cfif isdefined("attributes.assetp_name")>
	  <cfset url_str = "#url_str#&assetp_name=#attributes.assetp_name#">
	</cfif>
	<cfif isdefined("attributes.employee_id")>
	  <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
	</cfif>
	<cfif isdefined("attributes.employee_name")>
	  <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
	</cfif>
	<cfif isdefined("attributes.punishment_type_id")>
	  <cfset url_str = "#url_str#&punishment_type_id=#attributes.punishment_type_id#">
	</cfif>
	<cfif isdefined("attributes.accident_relation")>
	  <cfset url_str = "#url_str#&accident_relation=#attributes.accident_relation#">
	</cfif>
	<cfif isdefined("attributes.date_interval")>
	  <cfset url_str = "#url_str#&date_interval=#attributes.date_interval#">
	</cfif>
	<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	  <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date)#">
	</cfif>
	<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	  <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date)#">
	</cfif>	
	<!-- sil -->
	<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="assetcare.popup_list_punishment_search#url_str#"></td>
  	<!-- sil -->
</cfif>
