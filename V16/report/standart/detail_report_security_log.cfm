<cfparam name="attributes.cat" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.attack_types" default="">
<cfparam name="attributes.ipadress" default="">
<cfparam name="attributes.max_rows" default="20">
<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.barcod" default="">
<cfparam name="attributes.stock_code" default="">
<cfparam name="attributes.stock_code_2" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.property" default="">
<cfparam name="attributes.department_id" default="">
<cfif isdate(attributes.start_date)><cf_date tarih="attributes.start_date"><cfelse><cfset attributes.start_date = ""></cfif>
<cfif isdate(attributes.finish_date)><cf_date tarih="attributes.finish_date"><cfelse><cfset attributes.finish_date = ""></cfif>
<cfquery name="get_department" datasource="#dsn#">
	SELECT 
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		BRANCH B,
		DEPARTMENT D
	WHERE
		B.COMPANY_ID = #session.ep.company_id# AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
		D.DEPARTMENT_STATUS = 1 AND
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		DEPARTMENT_HEAD
</cfquery>
<cfset branch_dep_list=valuelist(get_department.department_id,',')>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT * FROM STOCKS_LOCATION
</cfquery>
<cfif isdefined("attributes.form_submitted")>
<cfquery name="get_product" datasource="#dsn2#">
    SELECT
        S.PRODUCT_ID,
        S.PRODUCT_NAME,
        S.PROPERTY,
        S.BARCOD,
        S.STOCK_CODE,
        S.STOCK_CODE_2,
        S.PRODUCT_STATUS,
        SUM(SR.STOCK_IN - SR.STOCK_OUT) AS TOPLAM,
        MAX(SR.PROCESS_DATE) AS PROCESS_DATE
    FROM 
        #dsn3_alias#.STOCKS S,
        STOCKS_ROW SR
    WHERE
        S.STOCK_ID = SR.STOCK_ID AND
		<cfif len(attributes.department_id)>
			(
                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                (SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
                <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                </cfloop>  
			)  AND
        <cfelseif len(branch_dep_list)>
            SR.STORE IN (#branch_dep_list#) AND
        </cfif>
        <cfif len(attributes.cat)>
            S.PRODUCT_CODE LIKE '#attributes.cat#.%' AND
        </cfif>
        <cfif isdefined("attributes.product_status") and len(attributes.product_status)>S.PRODUCT_STATUS = #attributes.product_status# AND</cfif> <!--- PRODUCT_STATUS  tanimsiz geliyordu diye isdefined kontrolu ekledim.. M.E.Y 20120615--->
        S.STOCK_ID NOT IN
        (
            SELECT
                STOCK_ID
            FROM 
                STOCKS_ROW
            WHERE 
                STOCK_ID IS NOT NULL
                <cfif not len(attributes.start_date) and not len(attributes.finish_date)>
                   AND PROCESS_DATE IS NOT NULL 
                </cfif>
                <cfif len(attributes.start_date)>
                   AND PROCESS_DATE >= #attributes.start_date# 
                </cfif>
                <cfif len(attributes.finish_date)>
                    AND PROCESS_DATE <= #attributes.finish_date#
                </cfif>
        )
    GROUP BY
        S.PRODUCT_ID,
        S.PRODUCT_NAME,
        S.PROPERTY,
        S.BARCOD,
        S.STOCK_CODE,
        S.STOCK_CODE_2,
        S.PRODUCT_STATUS
	UNION ALL
	SELECT
        S.PRODUCT_ID,
        S.PRODUCT_NAME,
        S.PROPERTY,
        S.BARCOD,
        S.STOCK_CODE,
        S.STOCK_CODE_2,
        S.PRODUCT_STATUS,
        0 AS TOPLAM,
        0 AS PROCESS_DATE
    FROM 
        #dsn3_alias#.STOCKS S
    WHERE
		1 = 1
        <cfif len(attributes.cat)>
            AND S.PRODUCT_CODE LIKE '#attributes.cat#.%' 
        </cfif>
        <cfif isdefined("attributes.product_status") and len(attributes.product_status)>S.PRODUCT_STATUS = #attributes.product_status# AND</cfif><!--- PRODUCT_STATUS  tanimsiz geliyordu diye isdefined kontrolu ekledim.. M.E.Y 20120615--->
     	AND S.STOCK_ID NOT IN
        (
            SELECT
                STOCK_ID
            FROM 
                STOCKS_ROW
            WHERE 
                STOCK_ID IS NOT NULL
                <cfif not len(attributes.start_date) and not len(attributes.finish_date)>
                   AND PROCESS_DATE IS NOT NULL 
                </cfif>
                <cfif len(attributes.start_date)>
                   AND PROCESS_DATE >= #attributes.start_date# 
                </cfif>
                <cfif len(attributes.finish_date)>
                    AND PROCESS_DATE <= #attributes.finish_date#
                </cfif>
        )
		AND S.STOCK_ID NOT IN
        (
            SELECT
                STOCK_ID
            FROM 
                STOCKS_ROW
            WHERE 
                STOCK_ID IS NOT NULL
		)
</cfquery>
<cfset product_id_list = ValueList(get_product.PRODUCT_ID,',')>
<cfif len(product_id_list)>
	<cfquery name="get_product_cost_all" datasource="#dsn1#">
		SELECT  
			PRODUCT_ID,
			PURCHASE_NET_SYSTEM,
			PURCHASE_EXTRA_COST_SYSTEM,
			START_DATE,
			RECORD_DATE
		FROM
			PRODUCT_COST
		WHERE
			 PRODUCT_ID IN (#product_id_list#)
		<cfif len(attributes.start_date)>
			AND START_DATE >= #attributes.start_date#
		</cfif>
		<cfif len(attributes.finish_date)>
			AND START_DATE <= #attributes.finish_date#
		</cfif>
		<cfif not len(attributes.start_date) and not len(attributes.finish_date)>
			AND PRODUCT_COST_STATUS = 1
		</cfif>
		ORDER BY START_DATE DESC,RECORD_DATE DESC
	</cfquery>
	<cfif get_product_cost_all.recordcount>
		<cfloop query="get_product_cost_all">
			<cfscript>
				'product_cost_#PRODUCT_ID#' =PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM;
			</cfscript>
		</cfloop>
	</cfif>
</cfif>
</cfif>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td class="headbold" height="35" width="99%"><a href="javascript:gizle_goster(search);">&raquo;<cf_get_lang dictionary_id='40607.Hareket Görmeyen Ürünler'>
       	 <!-- sil --><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'><!-- sil --> 
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border" id="search">
    <!-- sil -->
    <tr class="color-row">
        <td>
            <table> 
				<cfform name="search_product" method="post" action="#request.self#?report.detail_report_security_log">
					<tr>
						<input type="hidden" name="form_submitted" id="form_submitted" value="1">
						<td valign="top"><cf_get_lang dictionary_id='55440.IP Adresi'></td>
						<td valign="top" width="190">
								<input name="ipadress" type="text" id="ipadress" style="width:170px;"  value="<cfif len(attributes.ipadress)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
						</td>
						
						<td valign="top"><cf_get_lang dictionary_id='57742.Tarih'></td>
						<td valign="top">
							<cfinput name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;">
							<cf_wrk_date_image date_field="start_date">
							<cfinput name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;">
							<cf_wrk_date_image date_field="finish_date">
						</td>
					</tr>
					<tr>
						<td valign="top"><cf_get_lang dictionary_id='60676.Saldırı türü'></td>
						<td valign="top">
							<select name="attack_types" id="attack_types" style="width:170px;">
								<option value="" <cfif attributes.attack_types eq ''>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
								<option value="1" <cfif attributes.attack_types eq 1>selected</cfif>>XSS</option>
								<option value="2" <cfif attributes.attack_types eq 2>selected</cfif>>SQL Injection</option>
								<option value="3" <cfif attributes.attack_types eq 3>selected</cfif>>LFI</option>
								<option value="4" <cfif attributes.attack_types eq 4>selected</cfif>>RFI</option>
							</select>
						</td>                            
						<td colspan="2" align="right" style="text-align:right;">
							<input name="is_excel" id="is_excel" type="checkbox" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'>
                            <input name="max_rows" id="max_rows" style="width:30px;" value="<cfoutput>#attributes.max_rows#</cfoutput>"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
							<cf_workcube_buttons add_function='kontrol()' is_upd='0' is_cancel='0' insert_info='#message#' insert_alert=''>
						</td>
					</tr>
				</cfform>
            </table>
        </td>
    </tr>
<!-- sil -->
</table>
<br/>
<cfif isdefined("attributes.form_submitted")>
		<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cfset filename = "#createuuid()#">
            <cfheader name="Expires" value="#Now()#">
            <cfcontent type="application/vnd.msexcel;charset=utf-8">
            <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
            <meta http-equiv="content-type" content="text/plain; charset=utf-8">
        </cfif>	
        <table width="98%" border="0" cellpadding="2" cellspacing="1" class="color-border" align="center">
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.totalrecords" default="#get_product.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.max_rows)+1>
		<cfif get_product.recordcount>
		<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
			<cfset attributes.startrow=1>
            <cfset attributes.max_rows=get_product.recordcount>
        </cfif>
			<tr class="color-header" height="22"> 
				<td width="1%" class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
				<td class="form-title"><cf_get_lang dictionary_id='57633.Barkod'></td>
				<td class="form-title"><cf_get_lang dictionary_id='57789.Özel Kod'></td>
                <td class="form-title"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
				<td class="form-title"><cf_get_lang dictionary_id='57657.Ürün'></td>
				<td class="form-title"><cf_get_lang dictionary_id='40608.Son Hareket Tarihi'></td>
				<td class="form-title"><cf_get_lang dictionary_id='58258.Maliyet'></td>
				<td class="form-title"><cf_get_lang dictionary_id='33936.Stok Miktarı'></td>
			</tr>
			<cfoutput query="get_product" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td width="1%">#currentrow#</td>
					<td>#barcod#</td>
					<td>#stock_code_2#</td>
                    <td>#stock_code#</td>
					<td>
                    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
                    	#PRODUCT_NAME# #PROPERTY#
					<cfelse>
                    	<a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">#PRODUCT_NAME#  #PROPERTY#</a>
                    </cfif>
                    </td>
					<td>#DateFormat(PROCESS_DATE,dateformat_style)#</td>
					<td align="right" style="text-align:right;"><cfif isdefined('product_cost_#PRODUCT_ID#')>#tlformat(Evaluate('product_cost_#PRODUCT_ID#'))# #session.ep.money#<cfelse>-</cfif></td>
					<td align="right" style="text-align:right;">#tlformat(TOPLAM)#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr class="color-row">
				<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
	</table>
	<cfif attributes.totalrecords gt attributes.max_rows>
		<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
			<tr><!-- sil --> 
				<td>	
				<cfscript>
					str_link = "form_submitted=1";
					str_link = "#str_link#&max_rows=#attributes.max_rows#&barcod=#attributes.barcod#&stock_code=#attributes.stock_code#&stock_code_2=#attributes.stock_code_2#&form_submitted=#attributes.form_submitted#&finish_date=#attributes.finish_date#&start_date=#attributes.start_date#";
					str_link = "#str_link#&product_name=#attributes.product_name#&product_id=#attributes.product_id#&property=#attributes.property#&cat=#attributes.cat#&is_excel=#attributes.is_excel#&department_id=#attributes.department_id#";
				</cfscript>
				<!-- sil -->
                <cf_pages 
						page="#attributes.page#" 
						maxrows="#attributes.max_rows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="report.nosale_products_report&#str_link#">
                <!-- sil --> 
				</td> 
				<td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
			</tr>
		</table>
	</cfif>	
</cfif>
<script type="text/javascript">
function kontrol()
	{
		if(document.search_product.is_excel.checked == false)
		{
			document.search_product.action="<cfoutput>#request.self#?fuseaction=report.detail_report_security_log</cfoutput>";
			return true;
		}
		else
		{
			document.search_product.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_report_security_log</cfoutput>";
		}
	}
</script>
