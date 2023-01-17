<cfparam name="attributes.hedef_year" default="#year(now())#">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.is_other_money_diff" default="">
<cfif isdefined("attributes.is_form_submitted")>
<cfquery name="GET_PERIODS" datasource="#DSN#">
	SELECT 
		PERIOD,
		PERIOD_YEAR,
		OUR_COMPANY_ID 
	FROM 
		SETUP_PERIOD 
	WHERE 
		PERIOD_YEAR = #attributes.hedef_year#
	ORDER BY 
		OUR_COMPANY_ID 
</cfquery>
<cfloop query="GET_PERIODS">
<cfset new_dsn2 = '#dsn#_#get_periods.PERIOD_YEAR#_#get_periods.OUR_COMPANY_ID#'>
	<cfset temp_q_name= 'GET_BORC_ALACAK_#get_periods.OUR_COMPANY_ID#'>
	<cfquery name="#temp_q_name#" datasource="#new_dsn2#">
		SELECT 
			AC.*,
			TOPL1,
			TOPL2
		FROM
			(SELECT SUM(AMOUNT) AS TOPL1,CARD_ID FROM ACCOUNT_CARD_ROWS,ACCOUNT_PLAN AP WHERE BA=0 AND AP.ACCOUNT_CODE = ACCOUNT_CARD_ROWS.ACCOUNT_ID GROUP BY CARD_ID) AS Q1,
			(SELECT SUM(AMOUNT) AS TOPL2,CARD_ID FROM ACCOUNT_CARD_ROWS,ACCOUNT_PLAN AP WHERE BA=1 AND AP.ACCOUNT_CODE = ACCOUNT_CARD_ROWS.ACCOUNT_ID GROUP BY CARD_ID) AS Q2,
			ACCOUNT_CARD AS AC
		WHERE
			Q1.CARD_ID = Q2.CARD_ID AND 
			ROUND(TOPL1,2)<>ROUND(TOPL2,2) AND 
			AC.CARD_ID=Q2.CARD_ID
	</cfquery>
	<cfif isdefined('attributes.is_other_money_diff')>
		<cfquery name="#temp_q_name#_2" datasource="#new_dsn2#">
			SELECT 
				AC.*,
				OTHER_TOPL1,
				OTHER_TOPL2 ,
				Q1.OTHER_CURRENCY
			FROM
				(SELECT SUM(OTHER_AMOUNT) AS OTHER_TOPL1,OTHER_CURRENCY,CARD_ID FROM ACCOUNT_CARD_ROWS,ACCOUNT_PLAN AP WHERE BA=0 AND AP.ACCOUNT_CODE = ACCOUNT_CARD_ROWS.ACCOUNT_ID AND OTHER_CURRENCY IS NOT NULL AND OTHER_AMOUNT IS NOT NULL GROUP BY CARD_ID,OTHER_CURRENCY) AS Q1,
				(SELECT SUM(OTHER_AMOUNT) AS OTHER_TOPL2,OTHER_CURRENCY,CARD_ID FROM ACCOUNT_CARD_ROWS,ACCOUNT_PLAN AP WHERE BA=1 AND AP.ACCOUNT_CODE = ACCOUNT_CARD_ROWS.ACCOUNT_ID AND OTHER_CURRENCY IS NOT NULL AND OTHER_AMOUNT IS NOT NULL GROUP BY CARD_ID,OTHER_CURRENCY) AS Q2,
				ACCOUNT_CARD AS AC
			WHERE 
				Q1.CARD_ID = Q2.CARD_ID AND 
				Q1.OTHER_CURRENCY=Q2.OTHER_CURRENCY AND
				ROUND(OTHER_TOPL1,2)<>ROUND(OTHER_TOPL2,2) AND 
				AC.CARD_ID=Q2.CARD_ID AND
				AC.CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD_ROWS GROUP BY CARD_ID HAVING COUNT(DISTINCT OTHER_CURRENCY)=1)
		</cfquery>
	</cfif>
</cfloop>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfform name="form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
	<cfsavecontent variable='title'><cf_get_lang dictionary_id='39161.Borc Alacak Tutmayan Muhasebe Fisleri'></cfsavecontent>
    <cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"> <cf_get_lang dictionary_id='58472.Donem'></td></label>
									<div class="col col-12 col-xs-12">                                           
										<select name="hedef_year" id="hedef_year">
											<cfloop from="#Evaluate(SESSION.EP.PERIOD_YEAR-4)#" to="#SESSION.EP.PERIOD_YEAR#" index="yy">
											<cfoutput><option value="#yy#" <cfif isdefined("attributes.hedef_year") and attributes.hedef_year eq yy>selected</cfif>>#yy#</option></cfoutput>
											</cfloop>
										</select>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-12 col-xs-12"> 
										<input type="checkbox" name="is_other_money_diff" id="is_other_money_diff" <cfif isdefined('attributes.is_other_money_diff') and len(attributes.is_other_money_diff)>checked</cfif>><cf_get_lang dictionary_id ='57796.Dövizli'>B/A<cf_get_lang dictionary_id ='40358.Tutmayanlar'>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">              
							<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename="borc_alacak_tutmayanlar#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
<cfheader name="Expires" value="#Now()#">
<cfcontent type="application/vnd.msexcel;charset=utf-16">
<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
</cfif>
<cf_report_list>
	<thead>
		<tr height="22" class="color-header">
			<th class="form-title"><cf_get_lang dictionary_id='57946.Fis No'></th>
			<th class="form-title"><cf_get_lang dictionary_id='57880.Belge No'></th>
			<th class="form-title"><cf_get_lang dictionary_id='39346.Fis Tr'></th>
			<th class="form-title"><cf_get_lang dictionary_id='57629.Aciklama'></th>
			<th class="form-title"><cf_get_lang dictionary_id='57742.Tarih'></th>
		</tr>
	</thead>				
	<cfif isdefined("attributes.is_form_submitted") and GET_PERIODS.recordcount>
		<tbody>
			<cfloop query="GET_PERIODS">
				<cfset new_dsn2 = '#dsn#_#get_periods.PERIOD_YEAR#_#get_periods.OUR_COMPANY_ID#'>
				<cfset temp_q_name= evaluate('GET_BORC_ALACAK_#get_periods.OUR_COMPANY_ID#')>
				<tr class="color-list">
					<td colspan="5" class="txtbold" align="center"><cfoutput>#get_periods.period#</cfoutput></td>
				</tr>
				<cfif temp_q_name.recordcount> <!--- sistem para birimi cinsinden borc-alacak tutmayan fisler --->
					<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
						<cfset attributes.startrow=1>
						<cfset attributes.maxrows = temp_q_name.recordcount>
					</cfif>
					<cfoutput query="temp_q_name">
					<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#temp_q_name.bill_no#</td>
						<td>#temp_q_name.paper_no#</td>
						<td><cfswitch expression="#temp_q_name.card_type#" >
								<cfcase value="10"><cf_get_lang dictionary_id='58756.Acilis Fisi'></cfcase>
								<cfcase value="11"><cf_get_lang dictionary_id='58844.Tahsil Fisi'></cfcase>
								<cfcase value="12"><cf_get_lang dictionary_id='58954.Tediye Fisi'></cfcase>
								<cfcase value="13"><cf_get_lang dictionary_id='58452.Mahsup Fisi'></cfcase>
								<cfcase value="14"><cf_get_lang dictionary_id='29435.Özel Fis'></cfcase>
								<cfcase value="15"><cf_get_lang dictionary_id='57884.Kur Farki'></cfcase>
								<cfcase value="19"><cf_get_lang dictionary_id='29543.Kapanış Fisi'></cfcase>
								<cfcase value="40"><cf_get_lang dictionary_id='39390.Cari Hesap Acilis Fisi'></cfcase>
							</cfswitch>
						</td>
						<td>#temp_q_name.card_detail#</td>
						<td>#dateformat(temp_q_name.action_date,dateformat_style)#</td>
					</tr>
					</cfoutput>	
					<cfparam name="attributes.totalrecords" default="#temp_q_name.recordcount#">
				</cfif>
				<cfif isdefined('attributes.is_other_money_diff') and len(attributes.is_other_money_diff)>
					<cfset temp_q_name_dovizli= evaluate('GET_BORC_ALACAK_#get_periods.OUR_COMPANY_ID#_2')>
					<cfif temp_q_name_dovizli.recordcount>
						<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
							<cfset attributes.startrow=1>
							<cfset attributes.maxrows = temp_q_name_dovizli.recordcount>
						</cfif>
						<tr class="color-list">
							<td colspan="5" class="txtbold"><cf_get_lang dictionary_id ='57796.Dövizli'>B/A<cf_get_lang dictionary_id ='40358.Tutmayanlar'></td>
						</tr>
						<cfoutput query="temp_q_name_dovizli">
						<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td>#bill_no#</td>
							<td>#paper_no#</td>
							<td><cfswitch expression="#card_type#" >
									<cfcase value="10"><cf_get_lang dictionary_id='58756.Acilis Fisi'></cfcase>
									<cfcase value="11"><cf_get_lang dictionary_id='58844.Tahsil Fisi'></cfcase>
									<cfcase value="12"><cf_get_lang dictionary_id='58954.Tediye Fisi'></cfcase>
									<cfcase value="13"><cf_get_lang dictionary_id='58452.Mahsup Fisi'></cfcase>
									<cfcase value="14"><cf_get_lang dictionary_id='29435.Özel Fis'></cfcase>
									<cfcase value="15"><cf_get_lang dictionary_id='57884.Kur Farki'></cfcase>
									<cfcase value="19"><cf_get_lang dictionary_id='29543.Kapanış Fisi'></cfcase>
									<cfcase value="40"><cf_get_lang dictionary_id='39390.Cari Hesap Acilis Fisi'></cfcase>
								</cfswitch>
							</td>
							<td>#card_detail#</td>
							<td>#dateformat(action_date,dateformat_style)#</td>
						</tr>
						</cfoutput>
						<cfparam name="attributes.totalrecords" default="#temp_q_name_dovizli.recordcount#">
					</cfif>
				<cfelse>	
					<cfset temp_q_name_dovizli.recordcount =0>
				</cfif>
				<cfif not temp_q_name.recordcount and not temp_q_name_dovizli.recordcount>
					<tr class="color-list">
						<td colspan="5"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif> 	
			</cfloop> 
		</tbody>
	<cfelse>
		<tr class="color-row">
			<td height="20" colspan="5"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='58486.Kayit Bulunamadi'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
		</tr>		
	</cfif>		
</cf_report_list>
<cfif isdefined("attributes.totalrecords") and len(attributes.totalrecords)>
	<cfset url_string = "#attributes.fuseaction#">
	<cfset url_string = "#url_string#&is_form_submitted=#attributes.is_form_submitted#">
	<cfif len(attributes.is_other_money_diff)>
		<cfset url_string = "#url_string#&is_other_money_diff=#attributes.is_other_money_diff#">
	</cfif>
	<cfif isdate(attributes.hedef_year)>
		<cfset url_string = "#url_string#&hedef_year=#dateformat(attributes.hedef_year,dateformat_style)#">
	</cfif>
	<cf_paging
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#url_string#">
</cfif>
<script type="text/javascript">
	function control() 
	{
		if(document.form.is_excel.checked==false)
			{
				document.form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.borc_alacak_tutmayanlar";
				return true;
			}
			else
			{
				document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_borc_alacak_tutmayanlar</cfoutput>";
			}	
	}
</script>