
<cf_xml_page_edit fuseact ="invoice.list_sale_multi">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.from_report" default="0">
<cfparam name="attributes.is_invoice_type" default="">
<cfparam name="attributes.is_hobim" default="">
<cfparam name="attributes.hobim_id" default="">
<cfparam name="attributes.startrow" default="">
<cfparam name="attributes.is_einvoice" default="">
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.startdate=''>
    <cfelse>
        <cfset attributes.startdate = wrk_get_today()>
	</cfif>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfif session.ep.OUR_COMPANY_INFO.UNCONDITIONAL_LIST>
		<cfset attributes.finishdate=''>
    <cfelse>
        <cfset attributes.finishdate = wrk_get_today()>
    </cfif>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.form_submit')>
	<cfquery name="get_invoice_multi" datasource="#dsn2#"><!--- #70024 numaralı iş gereği SQL paging 25/10/2013 tarihinde MCP tarafından eklendi. --->
    WITH CTE1 AS (
		SELECT
			IM.PROCESS_CAT,
            IM.PAY_METHOD,
            IM.CARD_PAYMETHOD,
            IM.DEPARTMENT_ID,
            IM.START_DATE,
            IM.FINISH_DATE,
            IM.INVOICE_DATE,
            IM.RECORD_EMP,
            IM.RECORD_DATE,
            IM.HOBIM_ID,
            IM.INVOICE_MULTI_ID,
            IM.IS_GROUP_INVOICE,
            IM.IS_EINVOICE,
            FE.IS_IPTAL,
            FE.IS_SENT,
            FE.IS_PRINTED,
            FE.FILE_NAME,
            EMP.EMPLOYEE_NAME +' '+ EMP.EMPLOYEE_SURNAME AS RECORD_EMP_NAME,
            DEP.DEPARTMENT_HEAD,
            SPC.PROCESS_CAT AS PROCESS_NAME,
            SP.PAYMETHOD,
            CPT.CARD_NO
            <cfif session.ep.our_company_info.is_efatura>
                ,(SELECT COUNT(INVOICE_ID) FROM INVOICE WHERE INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID) INVOICE_COUNT,
                (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD,INVOICE WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID AND STATUS_CODE = 1) EINVOICE_COUNT_,
                (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD,INVOICE WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID) EINVOICE_COUNT
            </cfif>
            <!--- listede kontrolü yapılmadigindan burada kontrol kaldirildi --->
            <!--- <cfif session.ep.our_company_info.is_earchive>--->
                ,(SELECT COUNT(INVOICE_ID) FROM INVOICE,EARCHIVE_RELATION ER,EARCHIVE_SENDING_DETAIL ESD WHERE ESD.OUTPUT_TYPE IN('0010','0011','0110','0111') AND ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND ER.ACTION_ID = INVOICE.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE' AND INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID AND ISNULL(IS_PDF,0) = 0 AND INVOICE.HOBIM_ID IS NULL AND ESD.SENDING_DETAIL_ID = (SELECT MAX(ESDD.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESDD WHERE ESDD.ACTION_ID=INVOICE.INVOICE_ID AND ESDD.ACTION_TYPE = 'INVOICE')) CONTROL_COUNT,
                (SELECT COUNT(INVOICE_ID) FROM INVOICE,EARCHIVE_RELATION ER,EARCHIVE_SENDING_DETAIL ESD WHERE ESD.OUTPUT_TYPE IN('0010','0011','0110','0111') AND ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND ER.ACTION_ID = INVOICE.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE' AND INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID AND ESD.SENDING_DETAIL_ID = (SELECT MAX(ESDD.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESDD WHERE ESDD.ACTION_ID=INVOICE.INVOICE_ID AND ESDD.ACTION_TYPE = 'INVOICE')) CONTROL_COUNT_,
                (SELECT COUNT(INVOICE_ID) FROM INVOICE WHERE INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID AND ISNULL(IS_PDF,0) = 1 AND INVOICE.HOBIM_ID IS NULL) HOBIM_SEND_COUNT,
                (SELECT SUM(NETTOTAL) FROM INVOICE WHERE INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID) INVOICE_TOTAL,
                ISNULL((SELECT ISNULL(COUNT(INVOICE_ID),0) FROM INVOICE WHERE INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID AND INVOICE.HOBIM_ID IS NOT NULL),0) HOBIM_COUNT,
                (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD WHERE ESD.ACTION_TYPE = 'INVOICE' AND ESD.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID AND STATUS_CODE = 0 AND (ERROR_CODE = '00' OR ERROR_CODE = '30') AND ESD.SENDING_DETAIL_ID = (SELECT MAX(ER.SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ER WHERE ER.ACTION_ID=ESD.ACTION_ID AND ER.ACTION_TYPE = 'INVOICE')) ERROR_COUNT,
                (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD,INVOICE WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID AND STATUS_CODE = 1) EARCHIVE_COUNT_,
                (SELECT COUNT(SENDING_DETAIL_ID) FROM EARCHIVE_SENDING_DETAIL ESD,INVOICE WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID) EARCHIVE_COUNT
			<!---</cfif>--->
        FROM
			INVOICE_MULTI IM
                LEFT OUTER JOIN FILE_EXPORTS FE ON FE.E_ID = IM.HOBIM_ID
                LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = IM.RECORD_EMP
                LEFT JOIN #dsn_alias#.DEPARTMENT DEP ON DEP.DEPARTMENT_ID = IM.DEPARTMENT_ID
                LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = IM.PROCESS_CAT
                LEFT JOIN #dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = IM.PAY_METHOD
                LEFT JOIN #dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID = IM.CARD_PAYMETHOD
		WHERE
			1=1
		<cfif isdefined('attributes.startdate') and len(attributes.startdate) and isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND IM.RECORD_DATE <= #DATEADD('d',1,attributes.finishdate)# AND IM.RECORD_DATE >= #attributes.startdate#
		<cfelseif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND IM.RECORD_DATE <= #DATEADD('d',1,attributes.finishdate)#
		<cfelseif isdefined('attributes.startdate') and len(attributes.startdate)>
			AND IM.RECORD_DATE >= #attributes.startdate#
		</cfif>
		<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)>
			AND IM.RECORD_EMP = #attributes.employee_id#
		</cfif>
		<cfif isdefined("attributes.from_report") and len(attributes.from_report)>
			AND ISNULL(IM.IS_FROM_REPORT,0) =  <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.from_report#">
		</cfif>
        <cfif isdefined("attributes.is_hobim") and attributes.is_hobim eq 1>
			AND IM.HOBIM_ID IS NOT NULL AND ISNULL(FE.IS_IPTAL,0) != 1 
        <cfelseif isdefined("attributes.is_hobim") and attributes.is_hobim eq 0>
        	AND (IM.HOBIM_ID IS NULL OR ISNULL(FE.IS_IPTAL,0) = 1)
		</cfif>
        <cfif isdefined("attributes.hobim_id") and len(attributes.hobim_id) and isnumeric(attributes.hobim_id)>
			AND IM.HOBIM_ID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hobim_id#">
		</cfif>
		<cfif isdefined("attributes.is_invoice_type") and attributes.is_invoice_type eq 1>
			AND ISNULL(IM.IS_GROUP_INVOICE,0) =  <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_invoice_type#">
        <cfelseif isdefined("attributes.is_invoice_type") and attributes.is_invoice_type eq 0>
        	AND ISNULL(IM.IS_GROUP_INVOICE,0) !=  <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
            AND ISNULL(IM.IS_FROM_REPORT,0) !=  <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
		</cfif>
        <cfif len(attributes.is_einvoice) and attributes.is_einvoice eq 1>
        	AND IS_EINVOICE = 1
        <cfelseif len(attributes.is_einvoice) and attributes.is_einvoice eq 2>
        	AND IS_EINVOICE = 1
			AND (SELECT COUNT(INVOICE_ID) FROM INVOICE WHERE INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID) = (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD,INVOICE WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID AND STATUS_CODE = 1)
        <cfelseif len(attributes.is_einvoice) and attributes.is_einvoice eq 3>
        	AND IS_EINVOICE = 1
			AND (SELECT COUNT(INVOICE_ID) FROM INVOICE WHERE INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID) <> (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD,INVOICE WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE' AND INVOICE.INVOICE_MULTI_ID = IM.INVOICE_MULTI_ID AND STATUS_CODE = 1)
        <cfelseif len(attributes.is_einvoice) and attributes.is_einvoice eq 0>
        	AND IS_EINVOICE != 1
        </cfif>
        ),
		CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY RECORD_DATE DESC ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
		ORDER BY 
			RECORD_DATE DESC
	</cfquery>
     <cfset multi_id_list = ''>
	<cfoutput query="get_invoice_multi">
    	<cfif is_group_invoice eq 0>
			<cfset multi_id_list = listappend(multi_id_list,get_invoice_multi.INVOICE_MULTI_ID)>
        </cfif>
	</cfoutput>
	<cfif listlen(multi_id_list)>
		<cfquery name="get_invoice" datasource="#dsn2#">
            SELECT
                SUM(TOPLAM) TOPLAM,
                SUM(SAYI) SAYI,<!--- FATURA SAYISI --->
                INVOICE_MULTI_ID
            FROM
                (
                	<!--- MAİL GÖNDERİLECEK --->
                    SELECT 
                        SUM(I.NETTOTAL) TOPLAM,
                        COUNT(INVOICE_MULTI_ID) SAYI,
                        0 TOPLAM_2,
                        0 SAYI_2,
                        INVOICE_MULTI_ID
                    FROM
                        INVOICE I (NOLOCK)
                        LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC (NOLOCK) ON SC.SUBSCRIPTION_ID = I.SUBSCRIPTION_ID
                        LEFT JOIN #dsn3_alias#.SUBSCRIPTION_INFO_PLUS SI (NOLOCK) ON SC.SUBSCRIPTION_ID = SI.SUBSCRIPTION_ID,
                        #dsn_alias#.COMPANY C (NOLOCK)
                    WHERE
                        INVOICE_MULTI_ID IN(#multi_id_list#) AND
                        C.COMPANY_ID = I.COMPANY_ID AND
                        ISNULL(C.USE_EARCHIVE,0) = 1
                    GROUP BY
                        INVOICE_MULTI_ID
                ) T1
            GROUP BY
                INVOICE_MULTI_ID
        </cfquery>
		<cfset invoice_multi_id_list = valuelist(get_invoice.invoice_multi_id)>
	</cfif>
<cfelse>
	<cfset get_invoice_multi.recordcount = 0>
</cfif>
<cfif get_invoice_multi.recordcount gt 0>
<cfparam name="attributes.totalrecords" default='#get_invoice_multi.QUERY_COUNT#'>
<cfelse>
<cfparam name="attributes.totalrecords" default='#get_invoice_multi.recordcount#'>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_form" method="post" action="#request.self#?fuseaction=invoice.list_sale_multi">
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<input name="all_records" id="all_records" type="hidden" value="<cfoutput>#get_invoice_multi.recordcount#</cfoutput>">
			<cf_box_search more="0"> 
				<div class="form-group" id="form_ul_employee_name">
					<div class="input-group">
						<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57899.Kayıt Eden'></cfsavecontent>    
						<input type="hidden" maxlength="50" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input placeHolder="<cf_get_lang dictionary_id='57899.Kayıt Eden'>" type="text" maxlength="50" name="employee_name" id="employee_name"  value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>">
						<span class="input-group-addon icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search_form.employee_name&field_emp_id=search_form.employee_id&select_list=1','list');return false"></span>
					</div>
				</div>						
				<cfif session.ep.our_company_info.is_efatura>
					<div class="form-group" id="form_ul_is_einvoice">
						<cfsavecontent variable="header_"><cf_get_lang dictionary_id="29872.E-Fatura"></cfsavecontent>
						<select name="is_einvoice" id="is_einvoice">
							<option value="" selected="selected"><cf_get_lang dictionary_id="29872.E-Fatura"></option>
							<option value="1" <cfif attributes.is_einvoice eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="38801.Kullananlar"></option>
							<option value="0" <cfif attributes.is_einvoice eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="38804.Kullanmayanlar"></option>
							<option value="2" <cfif attributes.is_einvoice eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id="31752.Gönderilenler"></option>
							<option value="3" <cfif attributes.is_einvoice eq 3>selected="selected"</cfif>><cf_get_lang dictionary_id="59817.Gönderilmeyenler"></option>
						</select>
					</div>
				</cfif>
				<div class="form-group" id="form_ul_from_report">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id="59818.Sistemden Gelenler"></cfsavecontent>
					<select name="from_report" id="from_report">
						<option value="0" <cfif isDefined('attributes.from_report') and attributes.from_report eq 0>selected</cfif>><cf_get_lang dictionary_id="59818.Sistemden Gelenler"></option>
						<option value="1" <cfif isDefined('attributes.from_report') and attributes.from_report eq 1>selected</cfif>><cf_get_lang dictionary_id="59819.Rapordan Gelenler"></option>
					</select>
				</div>						
				<div class="form-group" id="form_ul_is_invoice_type">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id="57092.Hobim ID"></cfsavecontent>
					<select name="is_invoice_type" id="is_invoice_type">
						<option value=""><cf_get_lang dictionary_id='57287.Faturalama Tipi'></option>
						<option value="0" <cfif isDefined('attributes.is_invoice_type') and attributes.is_invoice_type eq 0>selected</cfif>><cf_get_lang dictionary_id="57407.Toplu Faturalama"></option>
						<option value="1" <cfif isDefined('attributes.is_invoice_type') and attributes.is_invoice_type eq 1>selected</cfif>><cf_get_lang dictionary_id="57295.Grup Faturalama"></option>
					</select>
				</div>
				<div class="form-group" id="form_ul_startdate">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='41039.Lütfen Başlangıç Tarihi Giriniz'> !</cfsavecontent>
						<cfif isdefined("attributes.startdate")>
							<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" maxlength="10" message="#message#" validate="#validate_style#">
						<cfelse>
							<cfinput type="text" name="startdate" value=""  validate="#validate_style#" maxlength="10" message="#message#">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div> 
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş tarihini yazınız'> !</cfsavecontent>
						<cfif isdefined("attributes.finishdate")>
							<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" maxlength="10" message="#message#" validate="#validate_style#">
						<cfelse>
							<cfinput type="text" name="finishdate" value=""  validate="#validate_style#" maxlength="10" message="#message1#">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" maxlength="3" onKeyUp="isNumber(this)" range="1,250" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function="kontrol()" button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box> 
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="57274.Toplu Fatura"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<cfset colspan_ = 21>
					<th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th>F.T</th>
					<th><cf_get_lang dictionary_id="57288.Fatura Tipi"></td>
					<th><cf_get_lang dictionary_id="58516.Ödeme Yöntemi"></th>
					<th><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></th>
					<th><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></th>
					<th><cf_get_lang dictionary_id="58759.Fatura Tarihi"></th>
					<th><cf_get_lang dictionary_id="50763.Toplam Adet"></th>
					<th><cf_get_lang dictionary_id="29534.Toplam Tutar"></th>
					<th><cf_get_lang dictionary_id="29463.Mail"> <cf_get_lang dictionary_id="58082.Adet"></th>
					<th><cf_get_lang dictionary_id="29463.Mail"> <cf_get_lang dictionary_id="57673.Tutar"></th>
					<th><cf_get_lang dictionary_id="41981.Kağıt"> <cf_get_lang dictionary_id="58082.Adet"></th>
					<th><cf_get_lang dictionary_id="41981.Kağıt"> <cf_get_lang dictionary_id="57673.Tutar"></th>
					<cfif session.ep.our_company_info.is_efatura>
						<cfset colspan_++>
						<th><cf_get_lang dictionary_id="29872.E-Fatura"><br />Gön.</th>
					</cfif>
					<cfif session.ep.our_company_info.is_earchive>
						<cfset colspan_++>
						<th><cf_get_lang dictionary_id="57145.E-Arşiv"><br />Gön.</th>
					</cfif>
					<th>Hobim <br />Gönderilen</th>
					<th>Hobim <br />Gönderilecek</th>
					<th><cf_get_lang dictionary_id="55812.Kayıt Eden"></th>
					<th><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></th>
					<!-- sil -->
					<th class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=invoice.list_sale_multi&event=add</cfoutput>','wide','add_sales');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					
					<cfif session.ep.our_company_info.is_efatura or session.ep.our_company_info.is_earchive>
						<cfset colspan_++>
						<th class="header_icn_none text-center"><img src="images/icons/efatura_black.gif" title=<cf_get_lang dictionary_id="29872.E-Fatura">/<cf_get_lang dictionary_id="57145.E-Arşiv">></th>
					</cfif>
					<cfoutput><th class="header_icn_none"><a href="javascript://"><i class="fa fa-check-square" title="#getlang('','PDF','29733')# #getlang('','Kontrol','43698')#"></i> </a></th></cfoutput>
					<th class="header_icn_none"><a href="javascript://"><i class="fa fa-exclamation" style="font-size:15px;color:#FF0000 !important;" title="<cf_get_lang dictionary_id='59821.Hata Alınan Faturalar'>"></a></th>
					<!-- sil -->
				</tr> 
			</thead>
			<tbody>
				<cfif get_invoice_multi.recordcount>
					<cfoutput query="get_invoice_multi">
					<tr>
						<td>#ROWNUM#</td>
						<td><cfif is_group_invoice eq 1><b>GF</b><cfelseif attributes.from_report eq 1>SF<cfelse>TF</cfif></td>
						<td><cfif len(process_cat)>#process_name#</cfif></td>
						<td><cfif len(pay_method)>
								#paymethod#
							<cfelseif len(card_paymethod)>				
								#card_no#
							</cfif>
						</td>
						<td>#dateformat(start_date,dateformat_style)#</td>
						<td>#dateformat(finish_date,dateformat_style)#</td>
						<td>#dateformat(invoice_date,dateformat_style)#</td>
						<cfif isdefined('invoice_count') and len(invoice_count)> <td style="text-align:right;">#invoice_count#</cfif></td>
						<td style="text-align:right;">#TLFormat(invoice_total)#</td>
						<cfif is_group_invoice eq 0>
							<td style="text-align:right;">#get_invoice.sayi[listfind(invoice_multi_id_list,invoice_multi_id)]#</td>
							<td style="text-align:right;">#TLFormat(get_invoice.toplam[listfind(invoice_multi_id_list,invoice_multi_id)])#</td>
							<td style="text-align:right;">#CONTROL_COUNT_#<cfset zarf_adet = CONTROL_COUNT_><cfif not len(zarf_adet)><cfset zarf_adet = 0></cfif></td>
							<td style="text-align:right;">#TLFormat(INVOICE_TOTAL)#</td>
							<cfif session.ep.our_company_info.is_efatura>
							<td style="text-align:right;">#EINVOICE_COUNT_#</td>
							</cfif>
							<cfif session.ep.our_company_info.is_earchive>
							<td style="text-align:right;">#EARCHIVE_COUNT_#</td>
							</cfif>
							<td style="text-align:right;">#HOBIM_COUNT#</td>
							<td style="text-align:right;">#zarf_adet-HOBIM_COUNT#</td>
						<cfelse>
							<td style="text-align:right;"></td>
							<td style="text-align:right;"></td>
							<td style="text-align:right;"></td>
							<td style="text-align:right;"></td>
							<cfif session.ep.our_company_info.is_efatura>
							<td style="text-align:right;">#EINVOICE_COUNT_#</td>
							</cfif>
							<cfif session.ep.our_company_info.is_earchive>
							<td style="text-align:right;">#EARCHIVE_COUNT_#</td>
							</cfif>
							<td style="text-align:right;"></td>
							<td style="text-align:right;"></td>
						</cfif>
						<td><cfif len(record_emp)>#record_emp_name#</cfif></td>
						<td>#dateformat(record_date,dateformat_style)#</td>
						<!-- sil -->
						<td width="15">
							<cfif (not len(hobim_id)) or  (len(hobim_id) and is_iptal eq 1)>
								<cfif get_module_power_user(20) and not (isdefined('EINVOICE_COUNT') and len(EINVOICE_COUNT) and EINVOICE_COUNT gt 0) and not (len(EARCHIVE_COUNT) and EARCHIVE_COUNT gt 0)>
									<a href="javascript://" onclick="if (confirm('<cf_get_lang dictionary_id='57387.İlişkili Tüm Faturalar Silinecek Emin misiniz?'>')) windowopen('#request.self#?fuseaction=invoice.emptypopup_del_invoice_multi&invoice_multi_id=#get_invoice_multi.invoice_multi_id#<cfif listlen(process_cat)>&name=#process_name#</cfif>','medium');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a>
								</cfif>
							</cfif>
						</td>
						<cfset kontrol_earchive = 0>
						<cfif session.ep.our_company_info.is_efatura or session.ep.our_company_info.is_earchive>
							<td class="text-center">
								<cfif session.ep.our_company_info.is_efatura and is_einvoice eq 1>
									<cfif isdefined('EINVOICE_COUNT') and len(EINVOICE_COUNT) and EINVOICE_COUNT gt 0 and EINVOICE_COUNT_ eq INVOICE_COUNT>
										<img title="E-Fatura Kesildi" src="images/icons/efatura_yellow.gif">
									<cfelse>
										<a href="javascript://" onclick="if (confirm('Faturalar E-Fatura Sistemine Gönderilecek. Emin misiniz?')) openBoxDraggable('#request.self#?fuseaction=invoice.popup_create_multiple_xml&action_id=#get_invoice_multi.invoice_multi_id#&action_type=INVOICE');">
										<img title="Gönderilmedi" src="images/icons/efatura_blue.gif"></a>
									</cfif>
								<cfelseif session.ep.our_company_info.is_earchive and is_einvoice eq 0  and datediff('d',session.ep.our_company_info.earchive_date,invoice_date) gte 0>
									<cfset kontrol_earchive = 1>
									<cfif isdefined('EARCHIVE_COUNT') and  len(EARCHIVE_COUNT) and EARCHIVE_COUNT gt 0 and EARCHIVE_COUNT_ eq INVOICE_COUNT>
										<img title="Gönderildi" src="images/icons/earchive_green.gif">
									<cfelse>
										<a href="javascript://" onclick="if (confirm('Faturalar E-Arşiv Sistemine Gönderilecek. Emin misiniz?')) openBoxDraggable('#request.self#?fuseaction=invoice.popup_create_multiple_earchive_xml&action_id=#get_invoice_multi.invoice_multi_id#&action_type=INVOICE');"><img title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" src="images/icons/earchive_blue.gif"></a>
									</cfif>
								</cfif>
							</td>
						</cfif>
						<td >
							<cfif kontrol_earchive eq 1 and is_group_invoice eq 0 and control_count gt 0>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=invoice.popup_control_earchive&invoice_multi_id=#get_invoice_multi.invoice_multi_id#','small');"><i class="fa fa-check-square" title="<cf_get_lang dictionary_id='29733.PDF'> <cf_get_lang dictionary_id='43698.Kontrol'>"></i></a>
							</cfif>
						</td> 
						<td>
							<cfif kontrol_earchive eq 1 and is_group_invoice eq 0 and error_count gt 0>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=invoice.popup_show_inv_error&invoice_multi_id=#get_invoice_multi.invoice_multi_id#','project');"><i class="fa fa-exclamation" style="font-size:12px;color:##FF0000 !important;" title="<cf_get_lang dictionary_id='59821.Hata Alınan Faturalar'>"></i></a>
							</cfif>
						</td>
						<!-- sil -->
					</tr>
					</cfoutput>
				<cfelse>              
					<tr>
						<td colspan="<cfoutput>#colspan_#</cfoutput>"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset url_string = ''>
		<cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
			<cfset url_string = '&form_submit=#attributes.form_submit#'>
		</cfif>
		<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
			<cfset url_string = "#url_string#&employee_id=#attributes.employee_id#">
		</cfif>
		<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)>
			<cfset url_string = "#url_string#&employee_name=#attributes.employee_name#">
		</cfif>
		<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
			<cfset url_string = "#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
			<cfset url_string = "#url_string#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.is_invoice_type") and len(attributes.is_invoice_type)>
			<cfset url_string = "#url_string#&is_invoice_type=#attributes.is_invoice_type#">
		</cfif>
		<cfif isdefined("attributes.from_report") and len(attributes.from_report)>
			<cfset url_string = "#url_string#&from_report=#attributes.from_report#">
		</cfif>
		<cfif len(attributes.is_hobim)>
			<cfset url_string = "#url_string#&is_hobim=#attributes.is_hobim#">
		</cfif>
		<cfif len(attributes.hobim_id)>
			<cfset url_string = "#url_string#&hobim_id=#attributes.hobim_id#">
		</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="invoice.list_sale_multi#url_string#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('employee_name').focus();
	function kontrol()
	{
		if (!date_check (document.getElementById('startdate'),document.getElementById('finishdate'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!"))
			return false;
		else
			return true;	
	}
	function control_function()
	{
		var is_selected=0;
		var invoice_multi_id_list = 0;
		if(document.getElementById('all_records').value>1)
		{
			for(var js=1;js <= document.getElementById('all_records').value;js++)
			{
				if(document.getElementById('invoice_multi_id'+js) != undefined && document.getElementById('invoice_multi_id'+js).checked)
				{
					is_selected=1;
					invoice_multi_id_list=invoice_multi_id_list+','+document.getElementById('invoice_multi_id'+js).value;
				}
			}
		}
		else
		{
			if(document.getElementById('invoice_multi_id'+1) != undefined && document.getElementById('invoice_multi_id'+1).checked)
			{
				is_selected=1;
				invoice_multi_id_list=document.getElementById('invoice_multi_id'+1).value;
			}	
		}
		if(is_selected==0)
		{
			alert("<cf_get_lang dictionary_id ='57354.Hobim Dosyası Oluşturulacak Toplu Faturalama Seçiniz'>");
			return false;
		}
		else
		{
			windowopen('<cfoutput>#request.self#?fuseaction=invoice.emptypopup_export_hobim&hobim_stage_id=#x_hobim_stage_id#&invoice_multi_id='+invoice_multi_id_list+'&is_group=0&from_report='+document.search_form.from_report.value+'</cfoutput>','medium','export_hobim');
			return true;	
		}
	}
</script>
