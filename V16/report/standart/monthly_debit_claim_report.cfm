<!--- ...Ayşenur20070328--->
<cfparam name="attributes.module_id_control" default="4">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.member_name" default="">
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id ='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id ='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id ='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id ='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id ='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id ='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id ='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id ='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id ='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id ='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id ='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id ='57603.Aralık'></cfsavecontent>
<cfif attributes.is_excel eq 0><!--- excel alınırken ColdFusion was unable to add the header hatası nedeniyle bu kontrol eklendi --->
	<cfflush interval="1000">
</cfif>
<cfset month_list = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39661.Borç/Alacak Aylara Göre Adatlandırılmış Rapor'></cfsavecontent>
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
    	<cfform name="form_report" action="#request.self#?fuseaction=report.monthly_debit_claim_report" method="post">
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
								<input type="hidden" name="is_submitted" id="is_submitted" value="1">
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57519.Cari Hesap'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<cfoutput>
												<input type="hidden" id="member_id" name="member_id" value="<cfif len(attributes.member_id) and len(attributes.member_name)>#attributes.member_id#</cfif>">
												<input type="hidden" id="member_type" name="member_type" value="<cfif Len(attributes.member_id) and len(attributes.member_name)>#attributes.member_type#</cfif>">
												<input type="text" name="member_name" id="member_name" style="width:140px;" value="<cfif Len(attributes.member_id) and len(attributes.member_name)>#attributes.member_name#</cfif>" autocomplete="off"  onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','MEMBER_ID,MEMBER_TYPE','member_id,member_type','form_report','3','250');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_member_name=form_report.member_name&field_name=form_report.member_name&field_comp_id=form_report.member_id&field_consumer=form_report.member_id&field_type=form_report.member_type&select_list=2,3&keyword='+encodeURIComponent(document.form_report.member_name.value),'list')"></span>
											</cfoutput>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cf_wrk_report_search_button is_excel='1' button_type='1' search_function='control()'>
						</div>
					</div>
				</div>
			</div>
    	</cfform>
		
	</cf_report_list_search_area>
</cf_report_list_search>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename="monthly_debit_claim_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
</cfif>
<cfif isdefined("attributes.is_submitted")>
<cf_report_list>
	<cfquery name="get_member_remainder" datasource="#dsn2#">
	<cfif (len(attributes.member_id) and len(attributes.member_name) and attributes.member_type is 'partner') or not len(attributes.member_name)>
		SELECT
			1 TYPE,
			COMPANY_ID MEMBER_ID, 
			ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
			ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
			SUM(BORC) AS BORC,
			SUM(BORC2) AS BORC2,
			SUM(ALACAK) AS ALACAK,
			SUM(ALACAK2) AS ALACAK2,
			CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
			CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK,
			MONTH(ACTION_DATE) AY
		FROM
			CARI_ROWS_TOPLAM
		<cfif len(attributes.member_id) and len(attributes.member_name) and attributes.member_type is 'partner'>
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		</cfif>
		GROUP BY
			COMPANY_ID,
			ACTION_DATE,
			DUE_DATE
	</cfif>
	<cfif not len(attributes.member_id)>
	UNION ALL
	</cfif>
	<cfif (len(attributes.member_id) and len(attributes.member_name) and attributes.member_type is 'consumer') or not len(attributes.member_name)>
		SELECT
			2 TYPE,
			CONSUMER_ID MEMBER_ID, 
			ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
			ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
			SUM(BORC) AS BORC,
			SUM(BORC2) AS BORC2,
			SUM(ALACAK) AS ALACAK,
			SUM(ALACAK2) AS ALACAK2,
			CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
			CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK,
			MONTH(ACTION_DATE) AY
		FROM
			CARI_ROWS_CONSUMER
		<cfif len(attributes.member_id) and len(attributes.member_name) and attributes.member_type is 'consumer'>
			WHERE
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		</cfif>
		GROUP BY
			CONSUMER_ID,
			ACTION_DATE,
			DUE_DATE
	</cfif>
	</cfquery>
	 
	<cfset borc_toplam = 0>
	<cfset borc_toplam2 = 0>
	<cfset borc_toplam_vade = 0>
	<cfset alacak_toplam = 0>
	<cfset alacak_toplam2 = 0>
	<cfset alacak_toplam_vade = 0>
	<cfset fark_toplam = 0>
	<cfset bakiye_toplam = 0>
	<cfset bakiye_toplam2 = 0>
	
		<thead>
			<tr>
				<th class="txtbold" colspan="10"><cfif isdefined("attributes.member_id") and isDefined("attributes.member_name") and len(attributes.member_id) and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif></th>
			</tr>
            <tr>
                <th>&nbsp;</th>
                <th align="center" colspan="2" class="txtbold"><cf_get_lang dictionary_id ='57587.Borç'></th>
                <th align="center" class="txtbold"><cf_get_lang dictionary_id ='57587.Borç'><cf_get_lang dictionary_id ='57640.Vade'> </th>
                <th align="center" colspan="2" class="txtbold"><cf_get_lang dictionary_id ='57588.Alacak'></th>
                <th align="center" class="txtbold"><cf_get_lang dictionary_id ='57588.Alacak'><cf_get_lang dictionary_id ='57640.Vade'></th>
                <th align="center" class="txtbold"><cf_get_lang dictionary_id ='58583.Fark'></th>
                <th align="center" colspan="2" class="txtbold"><cf_get_lang dictionary_id ='57589.Bakiye'></th>
            </tr>
		</thead>
		<tbody>
            <tr>
                <td class="txtbold" width="90"><cf_get_lang dictionary_id ='58672.Aylar'></td>
                <cfoutput>
					<td align="center" class="txtbold" width="100">#session.ep.money#</td>
					<td align="center" class="txtbold" width="100">#session.ep.money2#</td>
					<td align="center" class="txtbold" width="80"></td>
					<td align="center" class="txtbold" width="100">#session.ep.money#</td>
					<td align="center" class="txtbold" width="100">#session.ep.money2#</td>
					<td width="80">&nbsp;</td>
					<td width="80">&nbsp;</td>
					<td align="center" class="txtbold" width="100">#session.ep.money#</td>
					<td align="center" class="txtbold" width="100">#session.ep.money2#</td>
                </cfoutput>
            </tr>
	
            <cfoutput>
                <cfloop from="1" to="#ListLen(month_list)#" index="month_index">
                    <cfquery name="get_member_remainder_daily" dbtype="query">
                        SELECT
                            SUM(BAKIYE) AS BAKIYE, 
                            SUM(BAKIYE2) AS BAKIYE2, 
                            SUM(BORC) AS BORC,
                            SUM(BORC2) AS BORC2,
                            SUM(ALACAK) AS ALACAK,
                            SUM(ALACAK2) AS ALACAK2,
                            SUM(BORC*VADE_BORC) VADE_BORC,
                            SUM(ALACAK*VADE_ALACAK) VADE_ALACAK			
                        FROM
                            get_member_remainder
                        WHERE
                             AY = #month_index#
                    </cfquery>
                    <tr>
                        <td nowrap class="txtbold">#listgetat(month_list,month_index,',')#</td>
                        <td style="text-align:right;">#TLFormat(get_member_remainder_DAILY.BORC)#</td>
                        <td style="text-align:right;">#TLFormat(get_member_remainder_DAILY.BORC2)#</td>
                        <td style="text-align:right;"><cfif get_member_remainder_DAILY.BORC gt 0>#TLFormat(get_member_remainder_DAILY.VADE_BORC/get_member_remainder_DAILY.BORC,0)#<cfset borc1 = get_member_remainder_DAILY.VADE_BORC/get_member_remainder_DAILY.BORC><cfelse>0<cfset borc1 = 0></cfif></td>
                        <td style="text-align:right;">#TLFormat(get_member_remainder_DAILY.ALACAK)#</td>
                        <td style="text-align:right;">#TLFormat(get_member_remainder_DAILY.ALACAK2)#</td>
                        <td style="text-align:right;"><cfif get_member_remainder_DAILY.ALACAK gt 0>#TLFormat(get_member_remainder_DAILY.VADE_ALACAK/get_member_remainder_DAILY.ALACAK,0)#<cfset alacak1 = get_member_remainder_DAILY.VADE_ALACAK/get_member_remainder_DAILY.ALACAK><cfelse>0<cfset alacak1 = 0></cfif></td>
                        <td style="text-align:right;">#TLFormat(borc1-alacak1,0)#<cfset fark_toplam = fark_toplam + (borc1-alacak1)></td>
                        <td style="text-align:right;">#TLFormat(get_member_remainder_DAILY.BAKIYE)#</td>
                        <td style="text-align:right;">#TLFormat(get_member_remainder_DAILY.BAKIYE2)#</td>
                        <cfif len(get_member_remainder_DAILY.BORC)><cfset borc_toplam = borc_toplam + get_member_remainder_DAILY.BORC></cfif>
                        <cfif len(get_member_remainder_DAILY.BORC2)><cfset borc_toplam2 = borc_toplam2 + get_member_remainder_DAILY.BORC2></cfif>
                        <cfif len(get_member_remainder_DAILY.VADE_BORC)><cfset borc_toplam_vade = borc_toplam_vade + borc1></cfif>
                        <cfif len(get_member_remainder_DAILY.ALACAK)><cfset alacak_toplam = alacak_toplam + get_member_remainder_DAILY.ALACAK></cfif>
                        <cfif len(get_member_remainder_DAILY.ALACAK2)><cfset alacak_toplam2 = alacak_toplam2 + get_member_remainder_DAILY.ALACAK2></cfif>
                        <cfif len(get_member_remainder_DAILY.VADE_ALACAK)><cfset alacak_toplam_vade = alacak_toplam_vade + alacak1></cfif>
                        <cfif len(get_member_remainder_DAILY.BAKIYE)><cfset bakiye_toplam = bakiye_toplam + get_member_remainder_DAILY.BAKIYE></cfif>
                        <cfif len(get_member_remainder_DAILY.BAKIYE2)><cfset bakiye_toplam2 = bakiye_toplam2 + get_member_remainder_DAILY.BAKIYE2></cfif>
                    </tr>
                </cfloop>
			</tbody>
			<tfoot>
			<tr>
				<td nowrap class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam'></td>
				<td style="text-align:right;">#TLFormat(borc_toplam)#</td>
				<td style="text-align:right;">#TLFormat(borc_toplam2)#</td>
				<td style="text-align:right;">#TLFormat(borc_toplam_vade,0)#</td>
				<td style="text-align:right;">#TLFormat(alacak_toplam)#</td>
				<td style="text-align:right;">#TLFormat(alacak_toplam2)#</td>
				<td style="text-align:right;">#TLFormat(alacak_toplam_vade,0)#</td>
				<td style="text-align:right;">#TLFormat(fark_toplam,0)#</td>
				<td style="text-align:right;">#TLFormat(bakiye_toplam)#</td>
				<td style="text-align:right;">#TLFormat(bakiye_toplam2)#</td>
			</tr>
			</tfoot>
		</cfoutput>	
		
</cf_report_list>
</cfif>
<script>
    function control(){
		if(document.form_report.is_excel.checked==false)
			{
				document.form_report.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.monthly_debit_claim_report"
				return true;
			}
			else
				document.form_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_monthly_debit_claim_report</cfoutput>"
	}
</script>
