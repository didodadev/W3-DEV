<cfparam name="attributes.table_code" default="">
<cfparam name="attributes.table_info" default="">
<cfparam name="attributes.department_id" default="#listfirst(session.ep.user_location,'-')#">
<cfparam name="attributes.process_date" default="#now()#">
<cfparam name="attributes.row_count" default="0">
<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
        (
            (
            D.IS_STORE IN (1,3) AND
            ISNULL(D.IS_PRODUCTION,0) = 0
            )
            OR
            D.DEPARTMENT_ID = #firin_depo_id#
        ) AND
        D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfif len(attributes.table_code)>
	<cfquery name="get_table_code" datasource="#dsn_dev#">
    	SELECT * FROM STOCK_MANAGE_TABLES WHERE TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    <cfif get_table_code.recordcount>
    	<cfset attributes.department_id = get_table_code.department_id>
        <cfset attributes.table_info = get_table_code.table_info>
        <cfset attributes.process_date = get_table_code.process_date>
        <cfset attributes.order_id = get_table_code.order_id>
        
        <cfquery name="get_rows" datasource="#dsn2#">
        	SELECT
            	P.PRODUCT_NAME,
                SR.*,
                S.PROPERTY,
				(SELECT sum(GSL.PRODUCT_STOCK) as PRODUCT_STOCK FROM GET_STOCK_LAST_LOCATION GSL WHERE GSL.STOCK_ID = S.STOCK_ID AND GSL.DEPARTMENT_ID = #attributes.department_id#) AS GERCEK_STOK
            FROM
            	STOCKS_ROW SR,
                #dsn1_alias#.STOCKS S,
                #dsn1_alias#.PRODUCT P
            WHERE
            	S.STOCK_ID = SR.STOCK_ID AND
                S.PRODUCT_ID = P.PRODUCT_ID AND
                SR.WRK_ROW_ID = '#attributes.table_code#'
        </cfquery>
        <cfset attributes.row_count = get_rows.recordcount>
    </cfif>
</cfif>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="add_" action="#request.self#?fuseaction=retail.emptypopup_manage_stocks" method="post">
		<cf_box>
			<input type="hidden" name="last_active_row" id="last_active_row" value="">
			<cfinput type="hidden" name="row_count" id="row_count" value="#attributes.row_count#">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61478.Tablo Kodu'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="table_code" value="#attributes.table_code#" readonly="yes">
                        </div>
                    </div>
					<div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61494.Tablo Açıklama'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="table_info" value="#attributes.table_info#" maxlength="100">
                        </div>
                    </div>
					<div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37748.Mağaza'></label>
                        <div class="col col-8 col-sm-12">
                            <cfselect name="department_id" id="department_id" required="yes" message="Depo Seçiniz!">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_departments_search">
									<option value="#department_id#" <cfif attributes.department_id eq DEPARTMENT_ID>selected</cfif>>#DEPARTMENT_HEAD#</option>
								</cfoutput>
							</cfselect>
                        </div>
                    </div>
					<div class="form-group" id="item-promotion_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                        <div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfinput type="text" name="process_date" id="process_date" maxlength="10" value="#dateformat(attributes.process_date,'dd/mm/yyyy')#" required="yes" validate="eurodate" message="#getLang('','Tarih Hatalı',56704)#!">
								<span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
							</div>
                        </div>
                    </div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cfif not isdefined("attributes.order_id") or not len(attributes.order_id)>
					<cf_workcube_buttons add_function='kontrol()' button_type="1">
					<cfelse>
					<font style="color:red;"><cf_get_lang dictionary_id='62689.Bu Tablo Sayım işleminden oluşturulmuştur. Düzeltme Yapılamaz'>!!!</font>
				</cfif>
			</cf_box_footer>
		</cf_box>
		<cf_box>
			<cf_ajax_list id="manage_table">
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th><cf_get_lang dictionary_id='40490.Stok Adı'></th>
						<th><cf_get_lang dictionary_id='57692.İşlem'></th>
						<th><cf_get_lang dictionary_id='57635.Miktar'></th>
						<th><cf_get_lang dictionary_id='57452.Stok'></th>
						<th width="30" style="text-align:center"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=1</cfoutput>','list')"><i class="fa fa-plus"></i></a></th>
					</tr>
				</thead>
				<tbody>
					<cfif attributes.row_count gt 0>
						<cfoutput query="get_rows">
						<cfif stock_in gt 0>
							<cfset stock_count_ = stock_in>
							<cfset stock_type_ = 1>
						<cfelse>
							<cfset stock_count_ = stock_out>
							<cfset stock_type_ = -1>
						</cfif>
							<tr>
								<td>#currentrow#</td>
								<td><div class="form-group">
								<input type="hidden" name="sid_#currentrow#" id="sid_#currentrow#" value="#stock_id#">
								<input type="Text" name="txt_product_#currentrow#" id="txt_product_#currentrow#"  value="<cfif len(property)>#property#<cfelse>#PRODUCT_NAME#</cfif>" readonly></div>
								</td>                    
								<td>
								<select name="stock_type_#currentrow#"><option value="1" <cfif stock_type_ eq 1>selected</cfif>><cf_get_lang dictionary_id='34493.Ekleme'></option><option value="-1" <cfif stock_type_ eq -1>selected</cfif>><cf_get_lang dictionary_id='62739.Çıkarma'></option></select>
								</td>                    
								<td><div class="form-group">
								<cfinput type="text" name="stock_count_#currentrow#" value="#tlformat(stock_count_)#" required="Yes" onkeyup="return(FormatCurrency(this,event,2));"></div>
								</td>
								<td style="text-align:left;">#TLFORMAT(GERCEK_STOK)#</td>
								<td width="30"></td>
							</tr>
						</cfoutput>
					</cfif>
				</tbody>
			</cf_ajax_list>
			<script>
				set_input_contr();
				
				function kontrol()
				{
					if(document.getElementById('row_count').value == 0)
					{
						alert('<cf_get_lang dictionary_id='52345.Tabloya En Az Bir Satır Eklemelisiniz'>!');
						return false;	
					}
					if(document.getElementById('stock_count_').value == 0)
					{
						alert('<cf_get_lang dictionary_id='29943.Lütfen miktar giriniz'>!');
						return false;	
					}
				}
				
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
							   next_row = myRow_real;
						   
							try
							{
								$('#manage_table tr:eq(' + (next_row+1) + ') td:eq(' + myCol + ')').children().focus();
								get_row_active(next_row+1);
							}
							catch(e)
							{
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
						   
							myRow_real = myRow - 1;
							next_row = myRow_real;
						   
							try
							{
								$('#manage_table tr:eq(' + (next_row+1) + ') td:eq(' + myCol + ')').children().focus();
								get_row_active(next_row+1);
							}
							catch(e)
							{
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
				
				
				function add_row(product_id,product_name,g_stok)
				{
					d_stok_sql = "SELECT GSL.PRODUCT_STOCK FROM GET_STOCK_LAST_LOCATION GSL WHERE GSL.DEPARTMENT_ID = " + document.getElementById('department_id').value + " AND GSL.STOCK_ID = " + product_id;
					d_stok = wrk_query(d_stok_sql,'dsn2');
					
					if(d_stok.recordcount > 0)
					g_stok_d = d_stok.PRODUCT_STOCK;
					else
					g_stok_d = 0;
				
					sira_no_ = parseInt(document.getElementById('row_count').value) + 1;
					document.getElementById('row_count').value = sira_no_;
					veri = '<tr class="color-row" id="row_' + sira_no_ + '">';
					veri += '<td>' + sira_no_ + '</td>';
					
					veri += '<td>';
					veri += '<input type="hidden" name="sid_' + sira_no_ + '" id="sid_' + sira_no_ + '" value="' + product_id + '">';
					veri += '<input type="text"  name="txt_product_' + sira_no_ + '" id="txt_product_' + sira_no_ + '"value="' + product_name + '" readonly="yes">';
					veri += '</td>';
					
					veri += '<td>';
					veri += '<select name="stock_type_' + sira_no_ + '"><option value="1">Ekleme</option><option value="-1">Çıkarma</option></select>';
					veri += '</td>';
					
					veri += '<td>';
					veri += '<cfinput type="text" name="stock_count_' + sira_no_ + '" id="stock_count_" value="" required="Yes" onkeyup="return(FormatCurrency(this,event,2));">';
					veri += '</td>';
					
					veri += '<td style="text-align:left;">';
					veri += commaSplit(g_stok_d);
					veri += '</td>';

					veri += '<td>';
					veri += ''
					veri += '</td>';	
				
					veri += '</tr>';
					
					$('#manage_table').append(veri);
					set_input_contr();	
				}
				
				</script>
		</cf_box>
	</cfform>
</div>

