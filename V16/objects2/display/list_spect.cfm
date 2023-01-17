<!---spec_cat eger spec urune degil kategoriye baglanacaksa--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_id" default="">

<cf_xml_page_edit fuseact="objects.popup_list_spect_main">
<cfif not len(attributes.stock_id) and isdefined('attributes.product_id')>
	<cfquery name="GET_STK" datasource="#DSN3#" maxrows="1">
		SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
	</cfquery>
	<cfset attributes.stock_id = get_stk.stock_id>
</cfif>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date="">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date="">
</cfif>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT	
    	RATE1,
        RATE2,
        MONEY 
    FROM 
    	SETUP_MONEY 
    WHERE 
    	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND 
        MONEY_STATUS = 1 AND 
        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
</cfquery>
<cfset url_str = "">
<cfif isdefined("attributes.create_main_spect_and_add_new_spect_id")>
	<cfset url_str = "#url_str#&create_main_spect_and_add_new_spect_id=#attributes.create_main_spect_and_add_new_spect_id#">
</cfif>
<cfif isdefined("attributes.row_id")>
	<cfset url_str = "#url_str#&row_id=#attributes.row_id#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_main_id")>
	<cfset url_str = "#url_str#&field_main_id=#attributes.field_main_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.basket_id")>
	<cfset url_str = "#url_str#&basket_id=#attributes.basket_id#">
</cfif>
<cfif isdefined("attributes.is_refresh")>
	<cfset url_str = "#url_str#&is_refresh=#attributes.is_refresh#">
</cfif>
<cfif isdefined("attributes.form_name")>
	<cfset url_str = "#url_str#&form_name=#attributes.form_name#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined("attributes.stock_id")>
	<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
</cfif>
<cfif isdefined("attributes.main_stock_amount")>
	<cfset url_str = "#url_str#&main_stock_amount=#attributes.main_stock_amount#">
</cfif>
<cfif isdefined("attributes.paper_department")>
	<cfset url_str = "#url_str#&paper_department=#attributes.paper_department#">
</cfif>
<cfif isdefined("attributes.paper_location")>
	<cfset url_str = "#url_str#&paper_location=#attributes.paper_location#">
</cfif>
<cfif isdefined("attributes.sepet_process_type")>
	<cfset url_str = "#url_str#&sepet_process_type=#attributes.sepet_process_type#">
</cfif>
<cfloop query="get_money">
	<cfif isdefined("attributes.#money#") >
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfif isdefined("attributes.search_process_date")>
	<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isdefined("attributes.only_list") and len(attributes.only_list)><!--- spec tiklandidinda detayina gidecekse yoksa baskete atar--->
	<cfset url_str="&only_list=#attributes.only_list#">
</cfif>
<cfparam name="attributes.select_spect_type" default="0">
<cfset url_str_2 = "">
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfset url_str_2="&stock_id=#attributes.stock_id#">
</cfif>
<cfif len(attributes.stock_id)>
	<cfquery name="PRODUCT_NAMES" datasource="#DSN3#">
		SELECT
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.PROPERTY,
			STOCKS.PRODUCT_NAME,
			STOCKS.IS_PROTOTYPE,
			STOCKS.IS_PRODUCTION
		FROM
			STOCKS
		WHERE
			STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	</cfquery>
	<cfset attributes.product_name = product_names.product_name>
</cfif>
<!--- <cfif  len(attributes.stock_id) and PRODUCT_NAMES.IS_PRODUCTION and PRODUCT_NAMES.IS_PROTOTYPE ><!--- and session.ep.our_company_info.product_config --->
	<cfset attributes.spect_type="objects.popup_add_spect"><!---fiyat farklı--->
<cfelseif (len(attributes.stock_id) and PRODUCT_NAMES.IS_PRODUCTION and PRODUCT_NAMES.IS_PROTOTYPE)>
	<cfset attributes.spect_type="objects.popup_add_spect_price"><!---fiyatlı--->
<cfelse>
	<cfset attributes.spect_type="objects.popup_add_spect_property">
</cfif> --->
<cfset attributes.spect_type="objects.popup_add_spect_list">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >

<cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_SPECT_VAR" datasource="#DSN3#">
    	WITH CTE1 AS
        (
            SELECT
                SPECTS.SPECT_VAR_ID AS SPECT_VAR_ID,
                SPECTS.SPECT_MAIN_ID,
                SPECTS.SPECT_VAR_NAME,
                SPECTS.RECORD_EMP,
                SPECTS.RECORD_DATE AS RECORD_DATE,
                SPECT_MAIN.SPECT_STATUS
            FROM
                SPECTS,
                SPECT_MAIN
            WHERE
                SPECTS.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID
                AND SPECT_MAIN.SPECT_STATUS = 1
                <cfif len(attributes.keyword)>
					AND SPECTS.SPECT_VAR_NAME LIKE '#attributes.keyword#%'
                </cfif>
                <cfif len(attributes.stock_id)>
                    AND SPECTS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                </cfif>
                <cfif len(attributes.start_date)>
                    AND SPECTS.RECORD_DATE >= #attributes.start_date#
                </cfif>
                <cfif len(attributes.finish_date)>
                    AND SPECTS.RECORD_DATE <= #attributes.finish_date#
                </cfif>
		),
        CTE2 AS (
            SELECT
                CTE1.*,
                    ROW_NUMBER() OVER (ORDER BY SPECT_VAR_ID DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
            FROM
                CTE1
        )
        SELECT
            CTE2.*
        FROM
            CTE2
        WHERE
            RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)   
    </cfquery>
<cfelse>
	<cfset get_spect_var.recordcount=0>
</cfif>

<cfif isdefined("get_spect_var.query_count")>
	<cfparam name="attributes.totalrecords" default="#get_spect_var.query_count#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="#get_spect_var.recordcount#">
</cfif>

<!-- sil -->
<cfform name="form_search" action="#request.self#?fuseaction=#attributes.fuseaction##url_str#" method="post">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%; height:35px;">
        <tr>
            <td class="headbold">Spec</td>
            <td style="vertical-align:bottom;">
                <table align="right">
                    <tr>
                        <td>Spec Tipi</td>
                        <td>
                            <cfset spect_type__ = url_str>
                            <select name="select_spect_type" id="select_spect_type" onchange="go_page(this.value)" style="width:75px">
                                <option value="0" <cfif attributes.select_spect_type eq 0>selected</cfif>><cf_get_lang_main no ='235.Spec'></option>
                                <option value="<cfoutput>#spect_type__#</cfoutput>" <cfif attributes.select_spect_type eq spect_type__>selected</cfif>>Main Spect</option>
                            </select>
                        </td>
                        <td><cf_get_lang_main no ='672.Fiyat '><cf_get_lang_main no ='52.Güncelle'><input type="checkbox" name="price_change" id="price_change" value="1"></td>
                        <td><cfinput type="text" name="keyword" id="keyword" style="width:70px;" value="#attributes.keyword#"></td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button search_function='input_control()'></td>
                        <cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'> 
                    </tr>
                </table>
			</td>
        </tr>
        <tr>
        	<td colspan="2">
                <table align="right">
                    <tr>
                        <td><cf_get_lang_main no="245.Ürün"></td>
                        <td>
                            <cf_wrk_products form_name = 'form_search' product_name='product_name' stock_id='stock_id'>
                            <input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
                            <input type="text" name="product_name" id="product_name" style="width:80px;" value="<cfoutput>#attributes.product_name#</cfoutput>" onkeyup="get_product();">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=form_search.product_name&field_id=form_search.stock_id&keyword='+encodeURIComponent(document.form_search.product_name.value),'list');"><img src="/images/plus_thin.gif"></a>
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no ='1615.Başlama Tarihi Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date, 'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
                            <cf_wrk_date_image date_field="start_date">
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no ='327.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date, 'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
                            <cf_wrk_date_image date_field="finish_date">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>
<!-- sil -->

<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%;">
	<thead>
        <tr class="color-header" style="height:22px;">
            <th width="7%"><cf_get_lang_main no='75.No'></th>
            <th width="15%">Main Spect ID</th>
            <th style="width:65px"><cf_get_lang_main no='821.Tanım'></th>
            <th width="20%"><cf_get_lang_main no='487.Kaydeden'></th>
            <th width="10%"><cf_get_lang_main no='330.Tarih'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_spect_var.recordcount>
			<cfoutput query="get_spect_var">
				<tr style="height:20px;">
					<td>#spect_var_id#</td>
					<td>#spect_main_id#</td>
					<td>
						<!---<cfif isdefined('attributes.only_list') and only_list>
							<a href="#request.self#?fuseaction=objects.popup_upd_spect&id=#spect_var_id#&is_upd=0#url_str#" class="tableyazi">#spect_var_name#</a>
						<cfelse>--->
                        <a href="##" onclick="gonder('#spect_var_id#'<cfif isdefined('attributes.field_main_id')>,'#spect_main_id#'</cfif>);" class="tableyazi">#spect_var_name#</a>
						<!---</cfif>--->
					</td>
					<td>#get_emp_info(record_emp,0,0)#</td>
					<td>#dateformat(record_date,"dd/mm/yyyy")#</td>
					<!---<!-- sil -->
					<td><a href="#request.self#?fuseaction=objects.popup_upd_spect&id=#spect_var_id#&is_upd=0#url_str#"><img src="/images/update_list.gif" title="Spec Güncelle"></a></td>
					<!-- sil -->--->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Yok'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</table>
<cfif isdefined("attributes.stock_id")>
	<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
</cfif>
<cfif isdefined("attributes.finish_date")>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdefined("attributes.start_date")>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isdefined("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#attributes.fuseaction#&#url_str#">
<!---<cfif attributes.totalrecords gt attributes.maxrows>
	<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%;">
		<tr>
			<td>
				<cfif len(attributes.form_submitted)>
					<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
				</cfif>
				<cf_pages 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="objects2.popup_list_spect&keyword=#attributes.keyword##url_str#">
			</td>
			<!-- sil --><td  style="text-align:right;height:35px"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>--->

<form name="form_gonder_spect"  method="post" action="<cfoutput>#request.self#?fuseaction=objects.popup_list_spect_js</cfoutput>">
	<input type="hidden" name="spect_id" id="spect_id">
	<input type="hidden" name="spect_main_id" id="spect_main_id">
	<input type="hidden" name="price_change" id="price_change">
	<cfif isdefined("attributes.row_id")>
		<input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.field_main_id")>
		<input type="hidden" name="field_main_id" id="field_main_id" value="<cfoutput>#attributes.field_main_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.basket_id")>
		<input type="hidden" name="basket_id" id="basket_id" value="<cfoutput>#attributes.basket_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.is_refresh")>
		<input type="hidden" name="is_refresh" id="is_refresh" value="<cfoutput>#attributes.is_refresh#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.form_name")>
		<input type="hidden" name="form_name" id="form_name" value="<cfoutput>#attributes.form_name#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.company_id")>
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.consumer_id")>
		<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
	</cfif>
	<cfoutput>
		<cfloop query="get_money">
			<cfif isdefined("attributes.#money#") >
				<input type="hidden" name="#money#" id="#money#" value="#evaluate('attributes.#money#')#">
			</cfif>
		</cfloop>
		<cfif isdefined("attributes.search_process_date")>
			<input type="hidden" name="search_process_date" id="search_process_date" value="<cfoutput>#attributes.search_process_date#</cfoutput>">
		</cfif>
	</cfoutput>
</form>

<script type="text/javascript">
	document.getElementById('keyword').focus();
	function input_control()
	{
		if(trim(document.getElementById('keyword').value).length < 3)
		{
			alert('Filtre alanına en az üç karakter giriniz');
			document.getElementById('keyword').focus();
			return false;
		}
		if(trim(document.getElementById('product_name').value)=='')
			document.getElementById('stock_id').value='';
		return true;
	}
	function gonder(id,main_id,name_,price,other_price,money_type,prod_cost)
	{
		if(document.form_search.price_change.checked==true)
			document.form_gonder_spect.price_change.value = 1;
		document.form_gonder_spect.spect_id.value = id;
		document.form_gonder_spect.spect_main_id.value = main_id;//spect main id
		document.form_gonder_spect.submit();
	}
	function go_page(url_address)
	{
		if(url_address!=0)
		{
			if(document.form_search.price_change.checked==true)
			var url_address = url_address+'&price_change=1';
			window.location.href='<cfoutput>#request.self#?fuseaction=objects2.popup_list_spect_main&main_to_add_spect=1<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>&stock_id=#attributes.stock_id#</cfif></cfoutput>' + url_address + ' ';
		}
	}
</script>
