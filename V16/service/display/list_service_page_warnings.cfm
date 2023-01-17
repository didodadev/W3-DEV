<!---TolgaS 20050810
windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_page_warnings&action=#attributes.fuseaction#&action_name=list_id&action_id=#attributes.list_id#&w_id=#attributes.w_id#</cfoutput>','medium');
action :fuseaction
action_name :yollanan idnin ismi
action_id :yolananan id
action_name2 :eğer biren fazla id yollanacaksa 2.id'nin ismini tutar.
action_id2 :yolananan 2. id
w_id : eğer uyarı idsi biliniyorsa bu değer yollanır
İlişkili kayıtları listelemek istediğinizde uyarı linkinin sonuna
"relation_papers_type=P_ORDER_ID" bu ifadeyi eklemeniz gerekiyor.Burda üretim ekranından geldiği için P_ORDER_ID gönderildi.
Bunların dışında gönderebileceğiniz ID tipleri aşağıdadır..ID'nin değerini değil sadece adını göndereceksiniz.
"relation_papers_type=OPP_ID"
"relation_papers_type=OFFER_ID"
"relation_papers_type=ORDER_ID"
"relation_papers_type=SHIP_ID" 
"relation_papers_type=INVOICE_ID" 
"relation_papers_type=SHIP_RESULT_ID" 
"relation_papers_type=P_ORDER_ID"
"relation_papers_type=PR_ORDER_ID" 
"relation_papers_type=FIS_ID" 
--->
<cfscript>
	url_link="";
	if(isdefined('action'))
	{
		url_link="#action#";
	}
	if(isdefined('action_name'))
	{
		url_link="#url_link#&#action_name#=";
	}
	if(isdefined('action_name'))
	{
		url_link="#url_link##action_id#";
	}
	if(isdefined('action_name2'))
	{
		url_link="#url_link#&#action_name2#=";
	}
	if(isdefined('action_name2'))
	{
		url_link="#url_link##action_id2#";
	}
</cfscript>
<!--- modüllerin our_company_id veya period_id kaydedip etmeyeceği, burada yapılan değişiklikler myhome/query/add_warning.cfm sayfasında da uygulanmalı EÖ 20100710--->
<cfset use_period_module = 'finance,cash,bank,cheque,ch,cost,budget,account,defin,fintab,invent,pos,store,stock,account,invoice,contract,executive,worknet,salesplan,credit'>
<cfset use_company_module = 'production,prod,call,sales,purchase,service,campaign,finance,cash,bank,cheque,ch,cost,budget,account,defin,fintab,invent,pos,store,stock,account,invoice,contract,executive,worknet,salesplan,credit'>
<cfif Len(url_link)>
	<cfset url_modul=ListFirst(Right(url_link,len(url_link)-find('action=',url_link)),'.')>
<cfelse>
	<cfset url_modul="">
</cfif>
<!--- //modüllerin our_company_id veya period_id kaydedip etmeyeceği --->
<cfquery name="GET_WARNINGS" datasource="#DSN#">
	SELECT
		* 
	FROM 
		PAGE_WARNINGS
	WHERE	
		IS_PARENT=1 
		 <cfif find('.upd_internaldemand',url_link) or find('.upd_purchasedemand',url_link)>
		 	<!--- Talepler Birden Fazla Yerden Geliyor, Hepsi Kendi Sayfasinda Gorundugu Zaman Uyarinin Geldigi Anlasilmiyor, Bu Yuzden Ekledim FBS 20121106 --->
			AND (
				<cfif find('myhome.',url_link)>
					URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'myhome','correspondence')#' OR URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'myhome','correspondence')#&%' OR
					URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'myhome','purchase')#' OR URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'myhome','purchase')#&%' OR
				<cfelseif find('correspondence.',url_link)>
					URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'correspondence','myhome')#' OR URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'correspondence','myhome')#&%' OR
					URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'correspondence','purchase')#' OR URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'correspondence','purchase')#&%' OR
				<cfelseif find('purchase.',url_link)>
					URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'purchase','correspondence')#' OR URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'purchase','correspondence')#&%' OR
					URL_LINK  LIKE '#request.self#?fuseaction=#Replace(url_link,'purchase','myhome')#' OR URL_LINK LIKE '#request.self#?fuseaction=#Replace(url_link,'purchase','myhome')#&%' OR
				</cfif>
				URL_LINK LIKE '#request.self#?fuseaction=#url_link#' OR URL_LINK LIKE '#request.self#?fuseaction=#url_link#&%'
				)
		<cfelseif len(url_link) and not isdefined("attributes.is_content") and not isdefined("attributes.is_payment")>
			AND (URL_LINK  LIKE '#request.self#?fuseaction=#url_link#' OR URL_LINK  LIKE '#request.self#?fuseaction=#url_link#&%')
		</cfif>
		<cfif isdefined("attributes.is_content")><!--- FB 20071008 literaturdeki dokuman taleplerinin de icerikte goruntulenmesi icin is_content add_optionstan gelecek --->
			AND (	URL_LINK  LIKE '#request.self#?fuseaction=#url_link#' OR URL_LINK  LIKE '#request.self#?fuseaction=#url_link#&%' OR
					URL_LINK LIKE '#request.self#?fuseaction=rule.dsp_rule&cntid=#url.action_id#')
			AND IS_CONTENT = 1
		</cfif>
		<cfif isdefined("attributes.is_payment")><!--- FB 20071008 literaturdeki dokuman taleplerinin de icerikte goruntulenmesi icin is_content add_optionstan gelecek --->
			AND (	URL_LINK  LIKE '#request.self#?fuseaction=#url_link#' OR URL_LINK  LIKE '#request.self#?fuseaction=#url_link#&%' OR
					URL_LINK LIKE '#request.self#?fuseaction=correspondence.upd_payment_actions&closed_id=#url.action_id#&%')
		</cfif>
		<cfif isdefined('w_id') and len(w_id)>
			AND W_ID = #w_id#
		</cfif>
		<cfif listfind(use_company_module,url_modul,',')>
			AND OUR_COMPANY_ID = #session.ep.company_id#
		</cfif>
		<cfif listfind(use_period_module,url_modul,',')>
			AND PERIOD_ID = #session.ep.period_id#
		</cfif>
	ORDER BY 
		W_ID DESC
</cfquery>
<cfif get_warnings.recordcount>
	<cfset position_list = "">
	<cfset employee_list = "">
	<cfset partner_list = "">
	<cfset consumer_list = "">
	<cfoutput query="get_warnings">
		<cfif len(position_code) and not listfind(position_list,position_code)>
			<cfset position_list=listappend(position_list,position_code)>
		</cfif>
		<cfif len(record_emp) and not listfind(employee_list,record_emp)>
			<cfset employee_list=listappend(employee_list,record_emp)>
		</cfif>
		<cfif len(record_par) and not listfind(partner_list,record_par)>
			<cfset partner_list=listappend(partner_list,record_par)>
		</cfif>
		<cfif len(record_con) and not listfind(consumer_list,record_con)>
			<cfset consumer_list=listappend(consumer_list,record_con)>
		</cfif>
	</cfoutput>
	<cfif len(position_list)>
		<cfset position_list=listsort(position_list,"numeric","ASC",",")>
		<cfquery name="get_positions" datasource="#dsn#">
			SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#position_list#) ORDER BY POSITION_CODE
		</cfquery>
	</cfif>
	<cfif len(employee_list)>
		<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
		<cfquery name="get_employees" datasource="#dsn#">
			SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
		</cfquery>
	</cfif>
	<cfif len(partner_list)>
		<cfset partner_list=listsort(partner_list,"numeric","ASC",",")>
		<cfquery name="GET_PARTNERS" datasource="#DSN#">
			SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#partner_list#) ORDER BY PARTNER_ID
		</cfquery>
	</cfif>
	<cfif len(consumer_list)>
		<cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
		<cfquery name="GET_CONSUMERS" datasource="#DSN#">
			SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
		</cfquery>
	</cfif>
</cfif>
<br />
<!--- MerveT 20150826 Başvuru ekranlarındaki ilişkili süreçleri göstermek için yapılmıştır.--->
<cfquery name="Get_Ship_Stock_Invoıce_Query" datasource="#dsn3#">
        SELECT
            1 TYPE,
            SF.FIS_ID BELGE_ID,
            SF.FIS_NUMBER BELGE_NO,
            SF.FIS_DATE BELGE_TARIH,
            SFR.OTHER_MONEY OTHER_MONEY,
            SUM(SFR.NET_TOTAL) BELGE_TOPLAM
        FROM 
            #dsn2_alias#.STOCK_FIS SF
            LEFT JOIN #dsn2_alias#.STOCK_FIS_ROW SFR ON SF.FIS_ID = SFR.FIS_ID
            LEFT JOIN SERVICE GS ON SF.SERVICE_ID = GS.SERVICE_ID
        WHERE
            GS.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		GROUP BY
        	SF.FIS_ID,
            SF.FIS_NUMBER,
            SF.FIS_DATE ,
            SFR.OTHER_MONEY        
    
    UNION ALL
        
        SELECT 
            2 TYPE,
            S.SHIP_ID BELGE_ID,
            S.SHIP_NUMBER BELGE_NO,
            S.SHIP_DATE BELGE_TARIH,
            S.OTHER_MONEY OTHER_MONEY,
            SUM(S.NETTOTAL) BELGE_TOPLAM
        FROM 
            #dsn2_alias#.SHIP S
            LEFT JOIN SERVICE GS ON S.SERVICE_ID = GS.SERVICE_ID
        WHERE
            GS.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		GROUP BY
        	S.SHIP_ID,
            S.SHIP_NUMBER,
            S.SHIP_DATE,
            S.OTHER_MONEY              
    
    UNION ALL
    
        SELECT 
            3 TYPE,
            I.INVOICE_ID BELGE_ID,
            I.INVOICE_NUMBER BELGE_NO,
            I.INVOICE_DATE BELGE_TARIH,
            I.OTHER_MONEY OTHER_MONEY,
            SUM(I.NETTOTAL) BELGE_TOPLAM
        FROM 
            #dsn2_alias#.INVOICE I
            LEFT JOIN SERVICE GS ON I.SERVICE_ID = GS.SERVICE_ID
        WHERE
            GS.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		GROUP BY
        	I.INVOICE_ID,
            I.INVOICE_NUMBER,
            I.INVOICE_DATE,
            I.OTHER_MONEY           	
</cfquery>
<cf_medium_list>
	<thead>
		<tr>
            <th colspan="3"><img src="../../images/workdevanalys.gif" border="0" align="absmiddle" /><cf_get_lang_main no='1447.Süreç'> </th>
        </tr>
        <tr>
            <th class="txtboldblue"><img src="../../images/forklift.gif" border="0" align="absmiddle"> Stok Fişi</th>
            <th class="txtboldblue"><img src="../../images/package.gif" border="0" align="absmiddle"> <cf_get_lang_main no='361.İrsaliye'></th>
            <th class="txtboldblue"><img src="../../images/control.gif" border="0" align="absmiddle"> <cf_get_lang_main no='29.Fatura'></th>
        </tr>
	</thead>
	<tbody>
    	<cfif Get_Ship_Stock_Invoıce_Query.RecordCount>
            <tr>
                <td>
                    <cfquery name="Get_Stok_Fıs" dbtype="query">
                        SELECT * FROM Get_Ship_Stock_Invoıce_Query WHERE TYPE = 1
                    </cfquery>
                    <cfoutput query="Get_Stok_Fıs">
                        <a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#Belge_Id#" target="_blank" class="tableyazi">#Belge_No#</a><br />
                        #DateFormat(Belge_Tarih,dateformat_style)#<br />
                        #Tlformat(Belge_Toplam,2)# #Other_Money#<br />
                    </cfoutput>
                </td>
                <td>
                    <cfquery name="Get_Shıp" dbtype="query">
                        SELECT * FROM Get_Ship_Stock_Invoıce_Query WHERE TYPE = 2
                    </cfquery>
                    <cfoutput query="Get_Shıp">
                        <a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#Belge_Id#" target="_blank" class="tableyazi">#Belge_No#</a><br />
                        #DateFormat(Belge_Tarih,dateformat_style)#<br />
                        #Tlformat(Belge_Toplam,2)#<br />
                    </cfoutput>
                </td>
                <td>
                    <cfquery name="Get_Invoice" dbtype="query">
                        SELECT * FROM Get_Ship_Stock_Invoıce_Query WHERE TYPE = 3
                    </cfquery>
                    <cfoutput query="Get_Invoice">
                        <a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#Belge_Id#" target="_blank" class="tableyazi">#Belge_No#</a><br />
                        #DateFormat(Belge_Tarih,dateformat_style)#<br />
                        #Tlformat(Belge_Toplam,2)#<br />
                    </cfoutput>
                </td>
            </tr>
        <cfelse>
        	<tr>
            	<td><cf_get_lang_main no="1447.Süreç"> <cf_get_lang_main no="1134.Yok"> !</td>
            </tr>
        </cfif>
	</tbody>
</cf_medium_list>
<!--- MerveT 20150826 Başvuru ekranlarındaki ilişkili süreçleri göstermek için yapılmıştır.--->
<cf_medium_list_search title="#getLang('main',13)#/#getLang('main',88)#"></cf_medium_list_search>
<cf_medium_list>
<thead>
		<tr> 
			<th width="200"><cf_get_lang_main no='13.Uyarı'> / <cf_get_lang_main no='88.Onay'></th>
			<th width="120">Gönderen</th>
			<th width="90"><cf_get_lang_main no='330.Tarih'></th>
			<th width="100"><cf_get_lang_main no='250.Alan'></th>
			<th><cf_get_lang_main no='217.Açıklama'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_warnings.recordcount>
			<cfoutput query="get_warnings">
				<cfquery name="get_sub_warnings" datasource="#DSN#">
					SELECT 
						*
					FROM 
						PAGE_WARNINGS 
					WHERE
						IS_PARENT = 0 AND
						PARENT_ID = #get_warnings.w_id# AND
						W_ID <> #get_warnings.w_id#
					ORDER BY
						RESPONSE_ID
				</cfquery>
				<tr>	
					<td width="200">#get_warnings.warning_head#</td>
					<td width="120">
						<cfif len(record_emp)>
							#get_employees.employee_name[listfind(employee_list,record_emp,',')]# #get_employees.employee_surname[listfind(employee_list,record_emp,',')]#
						<cfelseif len(record_par)>
							#get_partners.company_partner_name[listfind(partner_list,record_par,',')]# #get_partners.company_partner_surname[listfind(partner_list,record_par,',')]#
						<cfelseif len(record_con)>
							#get_consumers.consumer_name[listfind(consumer_list,record_con,',')]# #get_consumers.consumer_surname[listfind(consumer_list,record_con,',')]#
					  </cfif>
					</td>
					<td width="90">#dateformat(get_warnings.record_date,dateformat_style)# #TimeFormat(date_add("h",session.ep.time_zone,get_warnings.record_date),timeformat_style)#</td>
					<td width="100">
						#get_positions.employee_name[listfind(position_list,position_code,',')]# #get_positions.employee_surname[listfind(position_list,position_code,',')]#
          </td>
					<td title="#warning_description#">#get_warnings.warning_description#</td>
				</tr>
				<cfif get_sub_warnings.recordcount>
					<cfloop from="1" to="#get_sub_warnings.recordcount#" index="i">
						<tr>
							<td>&nbsp;&nbsp;&nbsp;#get_sub_warnings.warning_head[i]# / &nbsp;#get_warnings.warning_result#</td>
							<td>
							<cfif len(evaluate('get_sub_warnings.record_emp[#i#]'))>
								<cfquery name="get_demander" datasource="#DSN#">
									SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID =  #get_sub_warnings.record_emp[i]#	  
								</cfquery>
									#get_demander.employee_name# #get_demander.employee_surname#
			          <cfelseif len(evaluate('get_sub_warnings.record_par[#i#]'))>
								<cfquery name="get_demander" datasource="#DSN#">
									SELECT COMPANY_PARTNER_NAME , COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID =  #get_sub_warnings.record_par[i]#	  
								</cfquery>
									#get_demander.company_partner_name# #get_demander.company_partner_surname#
			          <cfelseif len(evaluate('get_sub_warnings.record_con[#i#]'))>
								<cfquery name="get_demander" datasource="#DSN#">
									SELECT CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID =  #get_sub_warnings.record_con[i]#  
								</cfquery>
									#get_demander.consumer_name# #get_demander.consumer_surname#
							</cfif>
							</td>
							<td>#dateformat(get_sub_warnings.record_date[i],dateformat_style)# #TimeFormat(date_add("h",session.ep.time_zone,get_sub_warnings.record_date[i]),timeformat_style)#</td>
							<td>#get_emp_info(get_sub_warnings.position_code[i],1,0)#</td>
							<td>#get_sub_warnings.warning_description[i]#</td>
						</tr>
					</cfloop>
				</cfif>
			</cfoutput>
		<cfelse>
			<tr> 
				<td colspan="9"><cf_get_lang_main no='72.Kayıt yok'>!</td>
			</tr>
		</cfif>					
	</tbody>
</cf_medium_list>
