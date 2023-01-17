<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfif isdefined("session.pp")>
	<cfset period_year_ = session.pp.period_year>
	<cfparam name="attributes.maxrows" default="#session.pp.maxrows#">
<cfelseif isdefined("session.cp")>
	<cfset period_year_ = session.cp.period_year>
	<cfparam name="attributes.maxrows" default="#session.cp.maxrows#">
<cfelseif isdefined("session.ep")>
	<cfset period_year_ = session.ep.period_year>
	<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfelse>
	<cfset period_year_ = session.ww.period_year>
	<cfparam name="attributes.maxrows" default="#session.ww.maxrows#">
</cfif>

<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cfset attributes.finish_date = dateformat(attributes.finish_date,'dd/mm/yyyy') >
	<cf_date tarih = "attributes.finish_date">
	<cfset attributes.finish_date = date_add("d",1,attributes.finish_date)>
	<cfset attributes.finish_date = date_add("s",-1,attributes.finish_date)>
	<cfset attributes.finish_date = dateformat(attributes.finish_date,'dd/mm/yyyy') >
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#period_year_#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date,'dd/mm/yyyy') >
	<cf_date tarih = "attributes.start_date">
	<cfset attributes.start_date = dateformat(attributes.start_date,'dd/mm/yyyy') >
<cfelse>
	<cfset attributes.start_date = date_add('ww',-1,attributes.finish_date)>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_return.cfm">
	<cfquery name="GET_RETURN_CAT" datasource="#DSN3#">
		SELECT RETURN_CAT_ID, RETURN_CAT FROM SETUP_PROD_RETURN_CATS ORDER BY RETURN_CAT
	</cfquery>
<cfelse>
	<cfset get_returns.recordcount = 0>
</cfif>
<cfquery name="GET_RETURN_STAGES" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		<cfif isdefined("session.pp")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.add_return%">
	ORDER BY
		PTR.PROCESS_ROW_ID
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.totalrecords" default = "#get_returns.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>

<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
  	<tr>
		<!-- sil -->
    	<td style="vertical-align:bottom;">
            <cfform name="form1" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
            <table align="right">
                <input type="hidden" name="form_submitted" id="form_submitted"  value="1">
                <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                </cfif>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'>: </td>
                    <td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:90px;"></td>
                    <td>
                        <select name="return_stage" id="return_stage">
                            <option value=""><cf_get_lang_main no='70.Aşama'></option>
                            <cfoutput query="get_return_stages">
                                <option value="#process_row_id#" <cfif isdefined("attributes.return_stage") and attributes.return_stage eq process_row_id>selected</cfif>>#stage#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td>
                        <cfsavecontent variable="alert"><cf_get_lang_main no ='326.Lütfen Başlangıç Tarihini Giriniz'></cfsavecontent>
                        <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                            <cfinput type="text" name="start_date" id="start_date" value="#DateFormat(attributes.start_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" message="#alert#">
                        <cfelse>
                            <cfinput type="text" name="start_date" id="start_date" value="" style="width:65px;" validate="eurodate" message="#alert#" maxlength="10">
                        </cfif>
                        <cf_wrk_date_image date_field="start_date">
                    </td>
                    <td>
                        <cfsavecontent variable="alert"><cf_get_lang_main no ='327.Lütfen Bitiş Tarihi Giriniz'></cfsavecontent>
                        <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                            <cfinput type="text" name="finish_date" id="finish_date" value="#DateFormat(attributes.finish_date,'dd/mm/yyyy')#" style="width:65px;" maxlength="10" validate="eurodate" message="#alert#">
                        <cfelse>
                            <cfinput type="text" name="finish_date" id="finish_date" value="" style="width:65px;" validate="eurodate" message="#alert#" maxlength="10">
                        </cfif>
                        <cf_wrk_date_image date_field="finish_date">
                    </td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button></td>
                    <cf_workcube_file_action doc='1'>
              </tr>
            </table>
            </cfform>				
    	</td>
  	</tr>
</table>
<!-- sil -->
<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
    <tr class="color-header" style="height:22px;">
        <td class="form-title" style="width:20px;"><cf_get_lang_main no='75.No'></td>
        <td class="form-title"><cf_get_lang no='40.Başvuru Yapan'></td>
        <td class="form-title"><cf_get_lang_main no='721.Fatura No'></td>
        <td class="form-title"><cf_get_lang_main no='106.Stok Kodu'></td>
        <td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
        <td class="form-title"><cf_get_lang no='578.Fatura Miktarı'></td>
        <td class="form-title"><cf_get_lang no='580.İade Miktarı'></td>
        <td class="form-title"><cf_get_lang no='581.Nedeni'></td>
        <td class="form-title"><cf_get_lang no='582.Ambalaj'></td>
        <td class="form-title"><cf_get_lang no='583.Aksesuar'></td>
        <td class="form-title"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
        <td class="form-title"><cf_get_lang_main no='70.Aşama'></td>
        <td class="form-title"><cf_get_lang_main no='217.Açıklama'></td>
        <td style="width:15px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.add_return"><img src="/images/plus_square.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a></td>
    </tr>
	<cfif isdefined("attributes.form_submitted") and get_returns.recordcount>
		<cfset stage_list = ''>
		<cfset return_type_list = ''>
		<cfoutput query="get_returns" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfset stage_list = listappend(stage_list,get_returns.return_stage,',')>
			<cfset return_type_list = listappend(return_type_list,get_returns.return_type,',')>
		</cfoutput>
		<cfset return_type_list=listsort(return_type_list,"numeric","ASC",",")>
		
		<cfif len(stage_list)>
			<cfset stage_list=listsort(stage_list,"numeric","ASC",",")>
			<cfquery name="GET_STAGES" datasource="#DSN#">
				SELECT
					STAGE,
					PROCESS_ROW_ID
				FROM
					PROCESS_TYPE_ROWS
				WHERE
					PROCESS_ROW_ID IN (#stage_list#)
			</cfquery>
			<cfset stage_list = listsort(listdeleteduplicates(valuelist(get_stages.process_row_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfset stock_id_list = ''>
		<cfoutput query="get_returns">
			<cfif len(stock_id)>
				<cfif not listfind(stock_id_list,stock_id)>
					<cfset stock_id_list=listappend(stock_id_list,stock_id)>
				</cfif>
			</cfif>
		</cfoutput>
		<cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
		<cfif listlen(stock_id_list)>
            <cfquery name="GET_PRODUCTS" datasource="#DSN3#">
                SELECT
                    S.PRODUCT_NAME,
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PROPERTY,
                    S.STOCK_CODE
                FROM
                    STOCKS S
                WHERE
                    S.STOCK_ID IN (#stock_id_list#)
                ORDER BY
                    S.STOCK_ID
            </cfquery>
            <cfset main_stock_id_list = listsort(listdeleteduplicates(valuelist(get_products.stock_id,',')),'numeric','ASC',',')>
        </cfif>		
        <cfoutput query="get_returns" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
                <td>#currentrow#</td>
                <td>
                    <cfif len(service_partner_id)>
                        #get_par_info(service_partner_id,0,-1,0)#
                    <cfelseif len(service_consumer_id)>
                        #get_cons_info(service_consumer_id,1,0)#
                    <cfelseif len(service_employee_id)>
                        #get_emp_info(service_employee_id,0,0)#
                    </cfif>
                </td>
                <cfquery name="GET_PERIOD" datasource="#DSN#">
                    SELECT PERIOD_ID,PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#">
                </cfquery>
                <cfset my_source = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
                <cfquery name="get_inv_no" datasource="#my_source#">
                    SELECT 
                        INVOICE.INVOICE_NUMBER,
                        INVOICE_ROW.AMOUNT
                    FROM
                        INVOICE,
                        INVOICE_ROW
                    WHERE
                        INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
                        INVOICE_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
                        INVOICE.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_id#">
                </cfquery>
                <td>#get_inv_no.invoice_number#</td>
                <td>#get_products.stock_code[listfind(main_stock_id_list,stock_id,',')]#</td>
                <td>#get_products.product_name[listfind(main_stock_id_list,stock_id,',')]# #get_products.property[listfind(main_stock_id_list,stock_id,',')]#</td>
                <td><cfif len(get_inv_no.amount)>#amountformat(get_inv_no.amount)#</cfif></td>
                <td><cfif len(amount)>#amountformat(amount)#</cfif></td>
                <td>
                    <cfif len(return_type)>
                        <cfquery name="GET_CAT_NAME" dbtype="query">
                            SELECT RETURN_CAT FROM GET_RETURN_CAT WHERE RETURN_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#return_type#">
                        </cfquery>
                        #get_cat_name.return_cat#
                    </cfif>
                </td>
                <td><cfif len(package) and package eq 1><cf_get_lang no='586.Tam'><cfelseif len(package) and package eq 2><cf_get_lang no='585.Hasarlı'></cfif></td>
                <td><cfif len(accessories) and package eq 1><cf_get_lang no='586.Tam'><cfelseif len(accessories) and package eq 2><cf_get_lang no='587.Eksik'>/<cf_get_lang no='585.Hasarlı'></cfif></td>
                <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                <td><cfif len(return_stage)>#get_stages.stage[listfind(stage_list,return_stage,',')]#</cfif></td>
                <td>#detail#</td>
                <td><a href="#request.self#?fuseaction=objects2.upd_return&return_id=#return_id#"><img src="/images/update_list.gif" border="0" title="<cf_get_lang no='652.İade Detayı'>"></a></td>
            </tr>
		</cfoutput>
	<cfelse>
	  	<tr class="color-row" style="height:20px;">
			<td colspan="14"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.filtre ediniz'>!</cfif></td>
	  	</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
    <table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%;">
        <tr>
            <td>
            	<cf_pages page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="objects2.list_return&keyword=#attributes.keyword#&form_submitted=1"></td>
            <!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_returns.recordcount# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
    </table>
</cfif>
<br/>
<script type="text/javascript">
	/*function kontrol()
	{    
		if( !date_check(document.getElementById('start_date'), document.getElementById('finish_date')), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;
	} */
	document.form1.keyword.focus();
</script>
