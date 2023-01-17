<cfparam name="attributes.table_code" default="">
<cfparam name="attributes.table_info" default="">
<cfparam name="attributes.main_price_type" default="">
<cfparam name="attributes.row_count" default="0">
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<script type="text/javascript" src="wbp/retail/files/js/shortcut.js"></script>
<style>
	#manage_table tr td input
	{
	border:0px none #f1f0ff;
	border-width:0px;
	border-bottom-width:0px;
	background-color:transparent;
	color:#000;
	font-size:10px;
	font-family:Verdana, Geneva, sans-serif;
	font-weight:500;
	}
	
	#manage_table tr td select
	{
	border:0px none #f1f0ff;
	border-width:0px;
	border-bottom-width:0px;
	background-color:transparent;
	color:#000;
	font-size:10px;
	font-family:Verdana, Geneva, sans-serif;
	font-weight:500;
	}
	}
</style>


<cfquery name="get_search_lists" datasource="#dsn_dev#">
    SELECT
        LIST_ID,
        LIST_NAME
    FROM
        SEARCH_LISTS
    ORDER BY
        LIST_NAME
</cfquery>

<cfset used_rival_list = ''>
<cfif len(attributes.table_code)>
	<cfquery name="get_table_info" datasource="#dsn_dev#">
    	SELECT * FROM RIVAL_TABLES WHERE TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    <cfset attributes.table_info = get_table_info.table_info>
    <cfset attributes.main_price_type = get_table_info.main_price_type>
    
    <cfquery name="get_prices" datasource="#dsn3#">
    	SELECT * FROM PRICE_RIVAL WHERE TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    <cfif get_prices.recordcount>
    	<cfquery name="get_rivals" dbtype="query">
        	SELECT DISTINCT R_ID FROM get_prices
        </cfquery>
        <cfset used_rival_list = valuelist(get_rivals.R_ID)>
    </cfif>
    
    <cfquery name="get_price_products" dbtype="query">
    	SELECT DISTINCT PRODUCT_ID,STARTDATE,FINISHDATE FROM get_prices
    </cfquery>
    
    <cfoutput query="get_price_products">
    	<cfset 'row_product_id_#currentrow#' = product_id>
        <cfset 'row_product_name_#currentrow#' = get_product_name(product_id:product_id)>
        <cfset 'row_startdate_#currentrow#' = startdate>
        <cfset 'row_finishdate_#currentrow#' = finishdate>
        <cfquery name="get_fiy" datasource="#dsn3#">
            SELECT 
                ISNULL(( 
                    SELECT TOP 1 
                        PT1.NEW_PRICE_KDV
                    FROM
                        #DSN_DEV#.PRICE_TABLE PT1
                    WHERE
                        PT1.IS_ACTIVE_S = 1 AND
                        (
                        PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                        ) 
                        AND
                        PT1.PRODUCT_ID = P.PRODUCT_ID
                    ORDER BY
                        PT1.STARTDATE DESC,
                        PT1.ROW_ID DESC
                ),PS.PRICE_KDV) AS PRICE_KDV
            FROM 
                PRODUCT P,
                PRICE_STANDART PS
            WHERE 
                P.PRODUCT_ID = PS.PRODUCT_ID AND
                PS.PURCHASESALES = 1 AND
                PS.PRICESTANDART_STATUS = 1 AND
                P.PRODUCT_ID = #product_id#
        </cfquery>
        <cfset 'row_special_#currentrow#' = get_fiy.PRICE_KDV>
    </cfoutput>
    
	<cfset attributes.row_count = get_price_products.recordcount>
    
    <cfoutput query="get_prices">
    	<cfset 'row_#r_id#_#product_id#' = PRICE>
        <cfset 'row_price_type_#r_id#_#product_id#' = PRICE_TYPE>
    </cfoutput>
</cfif>

<cfif isdefined("attributes.search_list_id") and len(attributes.search_list_id)>
	<cfquery name="get_price_products" datasource="#dsn3#">
    	SELECT 
        	ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) 
                    AND
                    (PT1.PRODUCT_ID = P.PRODUCT_ID)
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PS.PRICE_KDV) AS PRICE_KDV,
            P.PRODUCT_ID,
           	P.PRODUCT_NAME,
            GETDATE() AS STARTDATE,
            NULL AS FINISHDATE 
        FROM 
        	PRODUCT P,
			PRICE_STANDART PS
        WHERE 
        	P.PRODUCT_ID = PS.PRODUCT_ID AND
            PS.PURCHASESALES = 1 AND
			PS.PRICESTANDART_STATUS = 1 AND
        	P.PRODUCT_ID IN 
            (
            	SELECT
                	SLR.PRODUCT_ID
                FROM
                	#dsn_dev_alias#.SEARCH_LISTS_ROWS SLR
                WHERE
                	SLR.LIST_ID = #attributes.search_list_id#
            )
    </cfquery>
    <cfset attributes.row_count = get_price_products.recordcount>
    <cfoutput query="get_price_products">
    	<cfset 'row_product_id_#currentrow#' = product_id>
        <cfset 'row_product_name_#currentrow#' = product_name>
        <cfset 'row_startdate_#currentrow#' = startdate>
        <cfset 'row_finishdate_#currentrow#' = finishdate>
        <cfset 'row_special_#currentrow#' = PRICE_KDV>
    </cfoutput>
</cfif>


<cfquery name="get_rival_list" datasource="#dsn#">
	SELECT
		R_ID,
		RIVAL_NAME,
		RIVAL_DETAIL
	FROM
		SETUP_RIVALS
    ORDER BY
    	RIVAL_NAME ASC
</cfquery>

<cfquery name="get_rival_types" datasource="#dsn_dev#">
	SELECT
		*
	FROM
		RIVAL_PRICE_TYPES
    ORDER BY
    	TYPE_NAME ASC
</cfquery>

<script>
function get_ort_fiyat(row_id)
{
	total_deger_ = 0;
	total_sayi_ = 0;
	<cfoutput query="get_rival_list">
	if(document.getElementById('rival_pric_' + row_id + '_#R_ID#').value != '')
	{
		deger_ = parseFloat(filterNum(document.getElementById('rival_pric_' + row_id + '_#R_ID#').value));
		if(deger_ != '' && deger_ != 0)
		{
			total_deger_ = total_deger_ + deger_;
			total_sayi_ = total_sayi_ + 1;
		}
		if(deger_ == 0)
		{
			document.getElementById('rival_pric_' + row_id + '_#R_ID#').value = '';	
		}
	}
	</cfoutput>
	
	
	if(total_sayi_ != 0)
	{
	document.getElementById('rival_pric_' + row_id + '_ortalama').value = commaSplit(wrk_round(total_deger_ / total_sayi_));
	}
}
</script>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" action="" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<input type="hidden" name="last_active_row" id="last_active_row" value="">
			<cfinput type="hidden" name="row_count" id="row_count" value="#attributes.row_count#">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-search_list_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57509.Liste'></label>
						<div class="col col-8 col-sm-12">
							<select name="search_list_id" id="search_list_id" onchange="send_search_list();">
								<option value=""><cf_get_lang dictionary_id='57509.Liste'></option>
								<cfoutput query="get_search_lists">
									<option value="#list_id#" <cfif isdefined("attributes.search_list_id") and attributes.search_list_id eq list_id>selected</cfif>>#list_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-table_code">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61478.Tablo Kodu'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="table_code" value="#attributes.table_code#" readonly="yes">
						</div>
					</div>
					<div class="form-group" id="item-table_info">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61494.Tablo Açıklama'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="table_info" value="#attributes.table_info#" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-search_list_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61480.Fiyat Tipi'></label>
						<div class="col col-8 col-sm-12">
							<select name="main_price_type">
								<option value=""><cf_get_lang dictionary_id='62217.Fiyat Tipi Seçiniz'>!</option>
								<cfoutput query="get_rival_types">
									<option value="#type_id#" <cfif attributes.main_price_type eq type_id>selected</cfif>>#type_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-search_list_id">
						<div class="col col-8 col-sm-12">
							<input type="checkbox" checked="checked" name="rival_check_0" id="rival_check_0" value="1" onclick="set_cols('0');"/>
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30905.Ortalama'></label>
						</div>
					</div>
					<cfoutput query="get_rival_list">
						<div class="form-group" id="item-search_list_id">
							<div class="col col-8 col-sm-12">
								<input type="checkbox" name="rival_check_#r_id#" id="rival_check_#r_id#" value="1" <cfif listfindnocase(used_rival_list,get_rival_list.R_ID)>checked</cfif> onclick="set_cols('#r_id#');"/> <label class="col col-4 col-sm-12">#rival_name#</label>
							</div>
						</div>
					</cfoutput>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' extra_info="" add_function='kontrol()'> 
				</cf_box_footer>
		</cfform>
	</cf_box>
	<cf_box>
		<cf_ajax_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='44019.Ürün'></th>
					<th width="150"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
					<th width="150"><cf_get_lang dictionary_id='57502.Bitiş'></th>
					<th><cfoutput>#market_name#</cfoutput> <cf_get_lang dictionary_id='58084.Fiyat'></th>
					<cfloop query="get_rival_list">
						<cfoutput><th colspan="2" class="form-title" rel="rival_kolon_#get_rival_list.R_ID#" <cfif not listfindnocase(used_rival_list,get_rival_list.R_ID)>style="display:none;text-align:center;"</cfif>>#get_rival_list.RIVAL_NAME#</th></cfoutput>
					</cfloop>
					<th rel="rival_kolon_0"><cf_get_lang dictionary_id='30905.Ortalama'></th>
					<th width="30"><a href="javascript://" onclick="add_row_pencere();" class="tableyazi"><i class="fa fa-plus"></i></a></th>
				</tr>
			</thead>
			<tbody id="manage_table">
				<tr>
					<td></td>
					<td></td>
					<td width="150" class="text-right" ><div class="form-group"><div class="input-group">
						<input type="text" name="p_startdate" id="p_startdate" maxlength="10" value="" class="text-right" validate="eurodate" message="Tarih Hatalı!" class="box">
						<span class="input-group-addon"><cf_wrk_date_image date_field="p_startdate"></span>
						<a href="javascript://" onclick="set_down_p_startdate();"><img src="/images/listele_down.gif" /></a></div></div>
					</td>
					<td width="150" class="text-right"><div class="form-group"><div class="input-group">
						<input type="text" name="p_finishdate" id="p_finishdate" maxlength="10" value="" class="text-right" validate="eurodate" message="Tarih Hatalı!" class="box">
						<span class="input-group-addon"><cf_wrk_date_image date_field="p_finishdate"></span>
						<a href="javascript://" onclick="set_down_p_finishdate();"><img src="/images/listele_down.gif" /></a></div></div>
					</td>
					<td></td>
					<cfloop query="get_rival_list"><cfoutput><td rel="rival_kolon_#get_rival_list.R_ID#" colspan="2" <cfif not listfindnocase(used_rival_list,get_rival_list.R_ID)>style="display:none;"</cfif>></td></cfoutput></cfloop>
					<td> </td>
					<td> </td>
				</tr>
				<cfoutput>
				<cfloop from="1" to="#attributes.row_count#" index="i">
					<cfif isdefined("row_product_id_#i#")>
						<cfset product_id_ = evaluate('row_product_id_#i#')>
						<cfset product_name_ = evaluate('row_product_name_#i#')>
						<cfset startdate_ = evaluate('row_startdate_#i#')>
						<cfset finishdate_ = evaluate('row_finishdate_#i#')>
						<cfset spe_fiyat_ = evaluate('row_special_#i#')>
					<cfelse>
						<cfset product_id_ = "">
						<cfset product_name_ = "">
						<cfset startdate_ = "">
						<cfset finishdate_ = "">
						<cfset spe_fiyat_ = "">
					</cfif>
					<tr  id="row_#i#" <cfif i gt attributes.row_count>style="display:none;"</cfif> ondblclick="get_row_passive('#i#');" onclick="get_row_active('#i#');">
						<td>#i#</td>
						<td>
							<input type="hidden" name="pid_#i#" id="pid_#i#" value="#product_id_#">
							<input type="Text"  style="width:200px; text-align:left;" name="txt_product_#i#" id="txt_product_#i#" class="box" value="#product_name_#" onfocus="AutoComplete_Create('txt_product_#i#','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','add_options_get_product','0','PRODUCT_ID,SATIS_KDV','pid_#i#,g_price_#i#','','3','225');" autocomplete="off">
						</td>
						<td><div class="form-group"><div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
							<input validate="eurodate" message="#message#" type="text" name="startdate_#i#"  maxlength="10" value="#dateformat(startdate_,'dd/mm/yyyy')#" >
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate_#i#"></span></div></div>
						</td>
						<td><div class="form-group"><div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
							<input  validate="eurodate"  type="text" name="finishdate_#i#"  maxlength="10" value="#dateformat(finishdate_,'dd/mm/yyyy')#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate_#i#"></span></div></div>
						</td>
						<td style="border-right:1px solid ##F00;">
							<input type="text" name="g_price_#i#" maxlength="10" value="#tlformat(spe_fiyat_)#" class="box" readonly="yes">
						</td>
						<cfset ort_ = 0>
						<cfset total_ = 0>
						<cfloop query="get_rival_list">
							<td rel="rival_kolon_#get_rival_list.R_ID#"  style="<cfif not listfindnocase(used_rival_list,get_rival_list.R_ID)>display:none;</cfif>text-align:left;">
								<cfif len(product_id_) and isdefined("row_#get_rival_list.R_ID#_#product_id_#")>
									<cfset deger_ = evaluate("row_#get_rival_list.R_ID#_#product_id_#")>
									<cfset ort_ = ort_ + 1>
									<cfset total_ = total_ + deger_>
									<cfset row_price_type_ = evaluate("row_price_type_#get_rival_list.R_ID#_#product_id_#")>
								<cfelse>
									<cfset deger_ = "">
									<cfset row_price_type_ = "">
								</cfif>
								<input type="text" name="rival_pric_#i#_#get_rival_list.R_ID#" value="#tlformat(deger_)#" style="width:40px;" onkeyup="return(FormatCurrency(this,event,2));" onBlur="get_ort_fiyat('#i#');" class="box">
						   </td>
						   <td rel="rival_kolon_#get_rival_list.R_ID#"  style="<cfif not listfindnocase(used_rival_list,get_rival_list.R_ID)>display:none;</cfif>text-align:left; border-right:1px solid ##F00;">
								<select name="price_type_#i#_#get_rival_list.R_ID#" style="width:40px;">
									<option value="">FT</option>
									<cfloop query="get_rival_types">
										<option value="#get_rival_types.type_id#" <cfif row_price_type_ eq get_rival_types.type_id>selected</cfif>>#get_rival_types.type_name#</option>
									</cfloop>
								</select>
							</td>
						</cfloop>
						<td rel="rival_kolon_0">
							<cfif ort_ gt 0>
								<cfset ort_deger_ = total_ / ort_>
							<cfelse>
								<cfset ort_deger_ = "">
							</cfif>
							<input type="text" name="rival_pric_#i#_ortalama" value="#tlformat(ort_deger_)#" readonly="yes" style="width:40px;" onkeyup="return(FormatCurrency(this,event,2));" class="box">
						</td>
				   </tr>
				   </cfloop>
			   </cfoutput>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="<cfoutput>#get_rival_list.recordcount + 5#</cfoutput>" height="30">
						<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'> 
					</td>
				</tr>
			</tfoot>
		</cf_ajax_list>
	</cf_box>
</div>

<script>
set_input_contr();

function set_input_contr()
{
	$("input").focus(function() 
		{
			input_ = $(this);
			setTimeout(function ()
			  {
				input_.select();
			  },30);
		}
		);
	
	$("input").keydown(function(e)
	{
	  kod_ = e.keyCode;
		if(kod_ == 40)
		{
		   input_ = $(this);
		   td_ = input_.closest('td');
		   tr_ = td_.closest('tr');
		   myRow = tr_.index();
		   myCol = td_.index();
		   myall = $('#manage_table tr').length;
		   
		   
		   myRow_real = myRow + 1;
		   next_row = myRow + 1;
		   
			if(myRow_real == myall)
			{
				//alert('Zaten En Alttasınız!');
				return false;
			}
			else
			{
				$('#manage_table tr:eq(' + (next_row+2) + ') td:eq(' + myCol + ')').children().focus();
				get_row_active(next_row+1);
			}
		   
		}
		else if(kod_ == 38)
		{
		input_ = $(this);
		   td_ = input_.closest('td');
		   tr_ = td_.closest('tr');
		   myRow = tr_.index();
		   myCol = td_.index();
		   myall = 0;
		   
		   myRow_real = myRow;
		   next_row = myRow - 1;
		   
			if(myRow_real == myall)
			{
				//alert('Zaten En Üsttesiniz!');
				return false;
			}
			else
			{
				$('#manage_table tr:eq(' + (next_row+2) + ') td:eq(' + myCol + ')').children().focus();
				get_row_active(next_row+1);
			}
		}
	});	
}

function get_row_active(prod_id)
{
	old_ = document.getElementById('last_active_row').value;
	document.getElementById('last_active_row').value = prod_id;
	
	if(old_ != '' && old_ != prod_id)
	{
		get_row_passive(old_);
		document.getElementById('row_' + prod_id).style.backgroundColor = '#ADFF2F';
	}
	else if(old_ != '' && old_ == prod_id)
	{
		//document.getElementById('last_active_row').value = '';
		//document.getElementById('product_row_' + old_).className = 'color-list';
	}
	else
	{
		document.getElementById('row_' + prod_id).style.backgroundColor = '#ADFF2F';
	}
}

function get_row_passive(prod_id)
{
	document.getElementById('row_' + prod_id).style.backgroundColor = '';
}

function add_row_pencere()
{
	windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products</cfoutput>','list');	
}

function add_row(product_id,product_name,special_price)
{
	sira_no_ = parseInt(document.getElementById('row_count').value) + 1;
	document.getElementById('row_count').value = sira_no_;
	veri = '<tr >';
	veri += '<td>' + sira_no_ + '</td>';
	
	veri += '<td>';
	veri += '<input type="hidden" name="pid_' + sira_no_ + '" id="pid_' + sira_no_ + '" value="' + product_id + '">';
	veri += '<input type="Text"  style="width:200px; text-align:left;" name="txt_product_' + sira_no_ + '" id="txt_product_' + sira_no_ + '" value="' + product_name + '" readonly="yes">';
	veri += '</td>';
	
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
	veri += '<td id="startdate_' + sira_no_ + '_td">';
	veri += '<input validate="eurodate" class="text-right" message="#message#" type="text" name="startdate_' + sira_no_ + '" id="startdate_' + sira_no_ + '"  maxlength="10" value="" >';
	veri += '</td>';

	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'>!</cfsavecontent>
	veri += '<td id="finishdate_' + sira_no_ + '_td">';
	veri += '<input validate="eurodate"  class="text-right" type="text" name="finishdate_' + sira_no_ + '" id="finishdate_' + sira_no_ + '" maxlength="10"  value="">';
	veri += '</td>';
	
	veri += '<td>';
	veri += '<input type="text" name="g_price_' + sira_no_ + '" maxlength="10" value="' + special_price + '" class="box" readonly="yes">';
	veri += '</td>';
	veri += '<td>';
	veri += '';
	veri += '</td>';
	
	<cfoutput>
	<cfloop query="get_rival_list">
	if(document.getElementById('rival_check_#get_rival_list.R_ID#').checked == true)
		deger1_ = 'display:;text-align:left;'
	else
		deger1_ = 'display:none;text-align:left;'
	
	veri += '<td rel="rival_kolon_#get_rival_list.R_ID#" style="' + deger1_ + '">';
	veri += '<input type="text" name="rival_pric_' + sira_no_ +'_#get_rival_list.R_ID#" value="" style="width:40px;" onkeyup="return(FormatCurrency(this,event,2));" onBlur="get_ort_fiyat(' + sira_no_ +');" class="box">';
	veri += '</td>';
	veri += '<td rel="rival_kolon_#get_rival_list.R_ID#" style="' + deger1_ + '">';
	veri += '<select name="price_type_' + sira_no_ +'_#get_rival_list.R_ID#" style="width:40px;"><option value="">FT</option><cfloop query="get_rival_types"><option value="#get_rival_types.type_id#">#get_rival_types.type_name#</option></cfloop></select>';
	veri += '</td>';
	</cfloop>
	</cfoutput>
	
	veri += '<td rel="rival_kolon_0">';
	veri += '<input type="text" name="rival_pric_' + sira_no_ + '_ortalama" value="" readonly="yes" style="width:40px;" class="box">';
	veri += '</td>';	
	
	veri += '</tr>';
	
	$('#manage_table').append(veri);
	wrk_date_image('startdate_' + sira_no_);
	wrk_date_image('finishdate_' + sira_no_);
	set_input_contr();	
}

function send_search_list()
{
	list_id_ = document.getElementById('search_list_id').value;	
	if(list_id_ != '')
	{
		window.location.href = '<cfoutput>#request.self#?fuseaction=retail.form_add_rival_price&search_list_id=</cfoutput>' + list_id_;	
	}
}
function kontrol()
{
	if(document.getElementById('row_count').value == 0)
	{
		alert('<cf_get_lang dictionary_id='52345.Tabloya En Az Bir Satır Eklemelisiniz'>!');
		return false;	
	}
	for (var m=1; m <= 300; m++)
	{
		if(document.getElementById('txt_product_' + m).value != '' && document.getElementById('pid_' + m).value != '' && document.getElementById('startdate_' + m).value == '')
		{
			alert(m + '. <cf_get_lang dictionary_id='62876.Satır İçin Tarih Girmelisiniz'>!');
			return false;
		}
	}	
}

function set_down_p_startdate()
{
	for (var m=1; m <= 300; m++)
	{
		document.getElementById('startdate_' + m).value = document.getElementById('p_startdate').value;
	}
}

function set_down_p_finishdate()
{
	for (var m=1; m <= 300; m++)
	{
		document.getElementById('finishdate_' + m).value = document.getElementById('p_finishdate').value;
	}
}

function set_cols(col)
{
	if(document.getElementById('row_count').value == 0)
	{
		alert('<cf_get_lang dictionary_id='52345.Tabloya En Az Bir Satır Eklemelisiniz'>!');
		document.getElementById('rival_check_' + col).checked = false;
		return false;
	}
	
	rel_ = "rel='rival_kolon_" + col + "'";
	col1 = $("#manage_table tr th[" + rel_ + "]");
	col2 = $("#manage_table tr td[" + rel_ + "]");

	if(document.getElementById('rival_check_' + col).checked == true)
	{
		col1.show();
		col2.show();
	}
	else
	{
		col1.hide();
		col2.hide();
	}	
}

/*
function add_rows()
{
	old_ = 	parseInt(document.getElementById('row_count').value);
	new_ = old_ + 10;
	if(new_ == 310)
	{
		alert('300 Satır Ekleyebilirsiniz!');
	}
	else
	{
		document.getElementById('row_count').value = new_;
		for (var m=(old_ + 1); m <= new_; m++)
		{
			show('row_' + m);
		}
	}
}

function del_rows()
{
	old_ = 	parseInt(document.getElementById('row_count').value);
	new_ = old_ - 10;
	if(new_ == 0)
	{
		alert('10 Satırdan Aşağı İnemezsiniz!');
	}
	else
	{
		document.getElementById('row_count').value = new_;
		for (var m=(new_ + 1); m <= old_; m++)
		{
			hide('row_' + m);
		}
	}
}

shortcut.add('ctrl+1', function() {
    del_rows();
});
*/

shortcut.add('shift+1', function() {
    add_row_pencere();
});

</script>
