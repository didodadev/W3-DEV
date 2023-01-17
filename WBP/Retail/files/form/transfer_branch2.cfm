<cfajaximport tags="cfwindow">
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("d",-90,bugun_)>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = dateadd("d",-1,bugun_)>
</cfif>

<cfquery name="get_department" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.DEPARTMENT_ID = #attributes.department_id#
</cfquery>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#,#attributes.department_id#) AND
        D.DEPARTMENT_ID IN (#attributes.search_department_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfif len(attributes.top_stock_price)>
	<cfset attributes.top_stock_price = filternum(attributes.top_stock_price)>
</cfif>
<cfif len(attributes.stock_price)>
	<cfset attributes.stock_price = filternum(attributes.stock_price)>
</cfif>


<cfquery name="get_product_list" datasource="#dsn3#" result="a_list">
SELECT <cfif len(attributes.top_stock_price)>TOP #attributes.top_stock_price#</cfif>
	*
FROM
	(
    SELECT
        *,
        GUNCEL_STOCK * LISTE_FIYATI ELDEKI_TUTAR
    FROM
        (
        SELECT 
            SUM(PRODUCT_STOCK) GUNCEL_STOCK,
            STOCK_ID,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_ALIS
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_P = 1 AND
                    PT1.P_STARTDATE <= #bugun_# AND 
                    DATEADD("d",-1,PT1.P_FINISHDATE) >= #bugun_# AND
                    (PT1.STOCK_ID = GSP.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = GSP.PRODUCT_ID))
                ORDER BY
                    PT1.P_STARTDATE DESC,
                    PT1.ROW_ID DESC
            ),PS.PRICE) AS LISTE_FIYATI,
            ISNULL((SELECT TOP 1 ETR.SUB_TYPE_ID FROM #DSN_DEV_ALIAS#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE GSP.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#),0) AS SUB_TYPE_ID
        FROM 
            #DSN2_ALIAS#.GET_STOCK_PRODUCT GSP,
            PRICE_STANDART PS,
            PRODUCT P
        WHERE 
            <cfif isdefined("attributes.HIERARCHY1") and len(attributes.HIERARCHY1)>
                <cfif isdefined("attributes.cat_in_out1")>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY1#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY1)>
                        	OR
                        </cfif>
                    </cfloop>
                )
                AND
                <cfelse>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY1#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY1)>
                        	AND
                        </cfif>
                    </cfloop>
                )
                AND
                </cfif>
            </cfif>
            
            <cfif isdefined("attributes.HIERARCHY2") and len(attributes.HIERARCHY2)>
                <cfif isdefined("attributes.cat_in_out2")>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY2#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY2)>
                        	OR
                        </cfif>
                    </cfloop>
                )
                AND
                <cfelse>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY2#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY2)>
                        	AND
                        </cfif>
                    </cfloop>
                )
                AND
                </cfif>
            </cfif>
            
            <cfif isdefined("attributes.HIERARCHY3") and len(attributes.HIERARCHY3)>
                <cfif isdefined("attributes.cat_in_out3")>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY3#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY3)>
                        	OR
                        </cfif>
                    </cfloop>
                )
                AND
                <cfelse>
                (
                	<cfset count_ = 0>
                    <cfloop list="#attributes.HIERARCHY3#" index="ccc">
                    	<cfset count_ = count_ + 1>
                    	P.PRODUCT_CODE NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                        <cfif count_ Neq listlen(attributes.HIERARCHY3)>
                        	AND
                        </cfif>
                    </cfloop>
                )
                AND
                </cfif>
            </cfif>
            P.PRODUCT_ID = PS.PRODUCT_ID AND
            GSP.PRODUCT_ID = PS.PRODUCT_ID AND
            PS.PRICESTANDART_STATUS = 1 AND
            PS.PURCHASESALES = 0 AND
            GSP.DEPARTMENT_ID = #attributes.department_id#
            <cfif isdefined("attributes.search_stock_id") and len(attributes.search_stock_id)>
            AND
                GSP.STOCK_ID IN (#attributes.search_stock_id#)
            </cfif>
            
        GROUP BY 
            STOCK_ID,
            PS.PRICE,
            GSP.PRODUCT_ID
        ) T1
    WHERE
        GUNCEL_STOCK > 0
        <cfif isdefined("attributes.uretici") and listlen(attributes.uretici)>
            AND SUB_TYPE_ID IN (#attributes.uretici#)
        </cfif>
   ) T2
   <cfif len(attributes.stock_price)>
   WHERE
   	ELDEKI_TUTAR >= #attributes.stock_price#
   </cfif>
ORDER BY
	ELDEKI_TUTAR DESC
</cfquery>

<cfif isdefined("session.ep.userid")>
	<cfset userid_ = session.ep.userid>
<cfelse>
	<cfset userid_ = session.pp.userid>
</cfif>

<cfif not get_product_list.recordcount>
	<script>
		alert('Aktarım Yapılacak Ürünü Bulunamadı!');
		history.back();
	</script>
    <cfabort>
<cfelse>
	<cfset p_list = valuelist(get_product_list.stock_id)>
</cfif>

<cfset dept_count = get_departments_search.recordcount>
<cfset dept_list = valuelist(get_departments_search.DEPARTMENT_ID)>
<cfset dept_name_list = valuelist(get_departments_search.DEPARTMENT_HEAD)>


<cfinclude template="../query/get_products_transfer.cfm">

<table width="98%" align="center">
<tr>
<td style="text-align:center; height:50px;">
    <table class="color-list" width="100%">
        <tr>
            <td class="headbold" width="250" height="35">Stok Dağıtım : <cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput></td>
            <td style="text-align:right;">
            	<input type="text" id="all_dagilim" name="all_dagilim" value="" onKeyUp="return(FormatCurrency(this,event,0))" style="width:50px;">
                <input type="button" onClick="write_dagilim();" value="&nbsp;&nbsp;Dağılım Yap&nbsp;&nbsp;">
                <input type="button" onClick="save_table_func();" value="&nbsp;&nbsp;Sevk Emri Oluştur&nbsp;&nbsp;">
                <input type="button" onClick="print_table_func(1);" value="&nbsp;&nbsp;Print&nbsp;&nbsp;">
                <input type="button" onClick="print_table_func(2);" value="&nbsp;&nbsp;Excel&nbsp;&nbsp;">
                <input type="button" onClick="sadece_dagilimlar();" value="&nbsp;&nbsp;Sadece Dağılımlar&nbsp;&nbsp;">
            </td>
       </tr>
   </table>
</td>
</tr>
</table>



<script type="text/javascript" src="/js/transfer_branch.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<div id="control_h"></div>
<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.base.css" />
<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.energyblue.css" />
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdata.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxscrollbar.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxmenu.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.edit.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.selection.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsresize.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsreorder.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.filter.js"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxnumberinput_new.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxinput.js"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcheckbox.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxtooltip.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdropdownlist.js"></script>


<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.grouping.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.aggregates.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/scripts/demos.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/demos/jqxgrid/localization.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/globalization/globalize.culture.tr-TR.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
    
	<cfquery name="get_defines" datasource="#dsn_dev#">
        SELECT * FROM SEARCH_TABLES_DEFINES
    </cfquery>
   
    <cfoutput>
        <style>
            .jqx-grid-cell-selected-energyblue{ background-color:###get_defines.focus_color# !important;  color:##2b465e !important;}/*cfdde9*/
            .jqx-grid-cell-hover-energyblue{ background-color:###get_defines.hover_color# !important;} /*cfdde9*/
            .jqx-grid-group-collapse,.jqx-grid-group-expand{background-color:###get_defines.group_color# !important;}
            .selectedclassRow{background-color:###get_defines.row_focus_color# !important;}
            .hoverclassRow{background-color:##C0C !important;}
        </style>
    </cfoutput>
        
	<script type="text/javascript">
		function sadece_dagilimlar()
		{
			$("#jqxgrid").jqxGrid('beginupdate');
			
			<cfoutput query="get_departments_search">
				<cfif currentrow eq 1>
					old_ = $("##jqxgrid").jqxGrid('getcolumnproperty', 'sube_ortalama_satis_#department_id#','hidden');
				</cfif>
			</cfoutput>
			
			if(old_ == false)
			{
				<cfoutput query="get_departments_search">
					$("##jqxgrid").jqxGrid('setcolumnproperty', 'sube_ortalama_satis_#department_id#','hidden',true);
					$("##jqxgrid").jqxGrid('setcolumnproperty', 'sube_stock_yeterlilik_#department_id#','hidden',true);
					$("##jqxgrid").jqxGrid('setcolumnproperty', 'yoldaki_#department_id#','hidden',true);
					$("##jqxgrid").jqxGrid('setcolumnproperty', 'ship_internal_#department_id#','hidden',true);
					$("##jqxgrid").jqxGrid('setcolumnproperty', 'dagilim_#department_id#','hidden',true);
					//$("##jqxgrid").jqxGrid('setcolumnproperty', 'sube_stock_#department_id#','hidden',true);
				</cfoutput>
			}
			else
			{
				<cfoutput query="get_departments_search">
					$("##jqxgrid").jqxGrid('setcolumnproperty', 'sube_ortalama_satis_#department_id#','hidden',false);
					$("##jqxgrid").jqxGrid('setcolumnproperty', 'sube_stock_yeterlilik_#department_id#','hidden',false);
					$("##jqxgrid").jqxGrid('setcolumnproperty', 'yoldaki_#department_id#','hidden',false);
					$("##jqxgrid").jqxGrid('setcolumnproperty', 'ship_internal_#department_id#','hidden',false);
					$("##jqxgrid").jqxGrid('setcolumnproperty', 'dagilim_#department_id#','hidden',false);
					//$("##jqxgrid").jqxGrid('setcolumnproperty', 'sube_stock_#department_id#','hidden',false);
				</cfoutput>
			}
			$("#jqxgrid").jqxGrid('endupdate');	
		}
	
	
        function write_dagilim()
		{
			deger_ = document.getElementById('all_dagilim').value;
			if(deger_ == '')
			{
				alert('Dağılım Rakamı Girmediniz!');
				return false;	
			}
			deger_ = parseFloat(filterNum(deger_));
			
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;
			
			var cells = $('#jqxgrid').jqxGrid('getselectedcells');
			c_eleman_sayisi = cells.length;


			for (var m=0; m < c_eleman_sayisi; m++)
			{
				var cell = cells[m];
         		row_ = cell.rowindex;
				kolon_ = cell.datafield;
				
				deger_ = document.getElementById('all_dagilim').value;
				deger_ = parseFloat(filterNum(deger_));
				
				if(kolon_.indexOf("reel_dagilim_") >= 0)
				{
					kolon_code_ = 'onay_' + list_getat(kolon_,list_len(kolon_,'_'),'_');
					row_no_ = row_;
					$("#jqxgrid").jqxGrid('setcellvalue',row_,kolon_,deger_);
					$("#jqxgrid").jqxGrid('setcellvalue',row_no_,kolon_code_,true);
				}
			}
		}
		
		function grid_duzenle()
		{
			var position = $('#jqxgrid').jqxGrid('scrollposition');
			$("#jqxgrid").jqxGrid('applyfilters');
			var left_ = position.left;
			var top_ = position.top;
			$('#jqxgrid').jqxGrid('scrolloffset',top_,left_);	
		}
		
		function header_duzenle()
		{
			<cfoutput query="get_departments_search">
			$("##div_onay_#department_id#").jqxCheckBox({ width: 20, height: 20,checked:false});
			</cfoutput>
			
			<cfoutput query="get_departments_search">
			$("##div_onay_#department_id#").bind('change', function (event) 
			{
				var checked = event.args.checked;
				var rows = $('##jqxgrid').jqxGrid('getboundrows');
				var eleman_sayisi = rows.length;
			
				for (var m=0; m < eleman_sayisi; m++)
				{
					rows[m].onay_#department_id# = checked;
				}
				grid_duzenle();
			});
			</cfoutput>
		}
		
		function save_table_func()
		{
			if(document.getElementById('all_stock_list').value == '')
			{
				alert('Stok Seçiniz!');
				return false;	
			}
			
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			document.getElementById('print_note').value = JSON.stringify(rows);
			windowopen('','medium','save_window_scr');
			adress_ = 'index.cfm?fuseaction=retail.popup_transfer_branch3';
			
			document.print_form.action = adress_;
			document.print_form.target = 'save_window_scr';
			document.print_form.submit();
		}
		
		function print_table_func(type)
		{
			if(document.getElementById('all_stock_list').value == '')
			{
				alert('Stok Seçiniz!');
				return false;	
			}
			
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			document.getElementById('print_note').value = JSON.stringify(rows);
			windowopen('','medium','print_window_scr');
			adress_ = 'index.cfm?fuseaction=retail.popup_transfer_branch4';
			
			adress_ += '&type=' + type;
			
			document.print_form.action = adress_;
			document.print_form.target = 'print_window_scr';
			document.print_form.submit();
		}
		
		$(document).ready(function () 
		{
			islem_depo = <cfoutput>#attributes.department_id#</cfoutput>;
			f1_pop = 0;
			f2_pop = 0;
			f3_pop = 0;
			f4_pop = 0;
			f5_pop = 0;
			f6_pop = 0;
			f7_pop = 0;
			f8_pop = 0;
			f9_pop = 0;
			f10_pop = 0;
		   
			foot_ = parseInt(600);
			head_ = parseInt(50);
			
		   jheight = foot_ - head_ - 90;
		   jwidth = window.innerWidth - 25;
			
			// prepare the data
            <cfoutput>var url = "/documents/retail/xml/transfer_#userid_#.txt";</cfoutput>
            var source =
            {
                dataType: "json",
                updaterow: function (rowid, rowdata, commit) {
                    // synchronize with the server - send update command
                    // call commit with parameter true if the synchronization with the server is successful 
                    // and with parameter false if the synchronization failder.
                    commit(true);
                },
                datafields:
                [
                    {name: 'sira_no', type: 'string' },
					{name: 'stock_id', type: 'float'},
					{name: 'product_name', type: 'string'},
					{name: 'product_code', type: 'string'},
					{name: 'stock_name', type: 'string'},
					{name: 'barcode', type: 'string'},
   					{name: 'stock_code', type: 'string'},
    				{name: 'product_cat', type: 'string'},
					{name: 'koli_carpan', type: 'string'},
					{name: 'list_price', type: 'float'},
					<cfloop from="1" to="#dept_count#" index="cc">
						<cfset dept_id_ = listgetat(dept_list,cc)>
						<cfoutput>
						{name: 'sube_ortalama_satis_#dept_id_#', type: 'float'},
						{name: 'sube_stock_#dept_id_#', type: 'float'},
						{name: 'sube_stock_yeterlilik_#dept_id_#', type: 'float'},
						{name: 'dagilim_#dept_id_#', type: 'float'},
						{name: 'reel_dagilim_#dept_id_#', type: 'float'},
						{name: 'yoldaki_#dept_id_#', type: 'float'},
						{name: 'ship_internal_#dept_id_#', type: 'float'},
						{name: 'onay_#dept_id_#', type: 'bool'},
						</cfoutput>
					</cfloop>
					{name: 'sube_stock', type: 'float'},
					{name: 'dagilim_toplam', type: 'float'},
					{name: 'tutar_sube_stock', type: 'float'},
					{name: 'depo_stock', type: 'float'},
					{name: 'sube_ortalama_satis', type: 'float'},
					{name: 'sube_yeter', type: 'float'}
                ],
                id:'id',
                url: url
            };
            var dataAdapter = new $.jqx.dataAdapter(source);
			
			last_row = -5;
			$('#jqxgrid').on('rowclick', function (event) 
			{
				var position = $('#jqxgrid').jqxGrid('scrollposition');
				this_row_ = event.args.rowindex;
				
				if(last_row != this_row_)
				{
					var left_ = position.left+1;
					var top_ = position.top+1;
					$('#jqxgrid').jqxGrid('scrolloffset',top_,left_);
					var left_ = left_-1;
					var top_ = top_-1;
					$('#jqxgrid').jqxGrid('scrolloffset',top_,left_);
					last_row = this_row_;
				}
				else
				{
					//	
				}
				return false;
			 });
			 
			$("#jqxgrid").on('cellendedit', function (event) 
			{					
				alan_adi = event.args.datafield;
				value = event.args.value;
				
				if(alan_adi.indexOf("reel_dagilim_") >= 0)
				{
					kolon_code_ = 'onay_' + list_getat(alan_adi,list_len(alan_adi,'_'),'_');
					if(value != '' && value > 0)
					{
					$("#jqxgrid").jqxGrid('setcellvalue',event.args.rowindex,kolon_code_,true);
					}
					else
					{
					$("#jqxgrid").jqxGrid('setcellvalue',event.args.rowindex,kolon_code_,false);	
					}
				}
			});
			
            // initialize jqxGrid
            $("#jqxgrid").jqxGrid(
            {
                ready: function () 
				{
					header_duzenle();
				},
				theme: 'energyblue',
				width: jwidth,
				height:jheight,
                source: dataAdapter,
                editable: true,
                enabletooltips: true,
				showfilterrow: true,
				sortable: false,
				localization: getLocalization('de'),
				columnsResize: true,
				columnsReorder: true,
				filterable: true,
				filtermode: 'excel',
				showaggregates:true,
                selectionmode: 'multiplecellsadvanced',
				handlekeyboardnavigation: handleKeys,
				showstatusbar: true,
				statusbarheight: 25,
				verticalscrollbarstep:200,
				verticalscrollbarlargestep:-25000,
                columns: [
                  { text: 'Sıra No', columntype: 'textbox', datafield: 'sira_no', width: 60,pinned:true,pinned:true,cellclassname:cellclass},
				  { text: 'kod', columntype: 'textbox', datafield: 'product_code', width: 60,hidden:true,pinned:true,cellclassname:cellclass},
				  { text: 'Stok Kodu', columntype: 'textbox', datafield: 'stock_code', width: 120,editable:false,pinned:true,cellclassname:cellclass},
				  { text: 'Alt Grup 2', columntype: 'textbox', datafield: 'product_cat', width: 120,editable:false,pinned:true,cellclassname:cellclass},
				  { text: 'Barkod', columntype: 'textbox', datafield: 'barcode', width: 120,editable:false,pinned:true,cellclassname:cellclass},
				  { text: 'Ürün Adı', columntype: 'textbox', datafield: 'product_name', width: 120,editable:false,hidden:true,cellclassname:cellclass},
				  { text: 'Stok Adı', columntype: 'textbox', datafield: 'stock_name', width:200,editable:false,pinned:true,cellclassname:cellclass},
				  { text: 'Koli Adedi', columntype: 'textbox', datafield: 'koli_carpan', width:40,editable:false,pinned:true,cellclassname:cellclass},
				  { text: 'Liste Fiyatı', columntype: 'textbox', align: 'right', cellsalign: 'right',datafield: 'list_price', filtertype:'number', cellsformat:'c2',width:65,editable:false,pinned:true,cellclassname:cellclass},
				  { 
				  	text: '<cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput> Stok', 
					columntype: 'textbox', 
					datafield: 'sube_stock', 
					width:75,
					editable:false,
					align: 'right', 
						cellsalign: 'right',
					filtertype:'number', cellsformat:'c2',
					pinned:true,
					cellclassname:cellclass
					},
					{
					text: '<cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput> Stok Tutar', 
					columntype: 'textbox', 
					datafield: 'tutar_sube_stock', 
					width:75,
					editable:false,
					align: 'right', 
					cellsalign: 'right',
					filtertype:'number', 
					cellsformat:'c2',
					pinned:true,
					cellclassname:cellclass
					},
					{ 
				  	text: '<cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput> Ort.', 
					columntype: 'textbox', 
					datafield: 'sube_ortalama_satis', 
					width:75,
					editable:false,
					align: 'right', 
					cellsalign: 'right',
					filtertype:'number', cellsformat:'c2',pinned:true,
					cellclassname:cellclass
					},
					{ 
				  	text: '<cfoutput>#get_department.DEPARTMENT_HEAD#</cfoutput> Ytr.', 
					columntype: 'textbox', 
					datafield: 'sube_yeter', 
					width:75,
					editable:false,
					align: 'right', 
					cellsalign: 'right',
					filtertype:'number', cellsformat:'c2',pinned:true,
					cellclassname:cellclass
					},
					{ 
				  	text: 'M. Stk', 
					columntype: 'textbox', 
					datafield: 'depo_stock', 
					width:75,
					editable:false,
					align: 'right', 
					cellsalign: 'right',
					filtertype:'number', cellsformat:'c2',pinned:true,
					cellclassname:cellclass
					},
					{ 
					text: 'Dağılım Toplam', 
					columntype: 'textbox', 
					align: 'right',
					cellsalign: 'right',
					datafield: 'dagilim_toplam', 
					width:40,
					editable:false,
					pinned:true,
					cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata) 
					{
                          var total = 0;
						  <cfoutput query="get_departments_search">
						  if(rowdata.onay_#department_id# == true)
								var total = total + parseFloat(rowdata.reel_dagilim_#department_id#);
						  </cfoutput>
                          return "<div style='margin: 4px;' class='jqx-right-align'>" + wrk_round(total) + "</div>";
					},
					cellclassname:cellclass},
				 <cfoutput query="get_departments_search">
				 	{ 
				  	text: 'Ort. Sat.', 
					columntype: 'textbox', 
					datafield: 'sube_ortalama_satis_#department_id#', 
					width:75,
					editable:false,
					align: 'right', 
					cellsalign: 'right',
					columngroup: 'dept_#department_id#',
					filtertype:'number', cellsformat:'c2',
					cellclassname:cellclass
					},
					{ 
				  	text: 'Stok Yet.', 
					columntype: 'textbox', 
					datafield: 'sube_stock_yeterlilik_#department_id#', 
					width:75,
					editable:false,
					align: 'right', 
					cellsalign: 'right',
					columngroup: 'dept_#department_id#',
					filtertype:'number', 
					cellsformat:'c2',
					cellclassname:cellclass
					},
					{ 
				  	text: 'Yoldaki', 
					columntype: 'textbox', 
					datafield: 'yoldaki_#department_id#', 
					width:50,
					editable:false,
					align: 'right', 
					cellsalign: 'right',
					columngroup: 'dept_#department_id#',
					filtertype:'number', 
					cellsformat:'c2',
					cellclassname:cellclass
					},
					{ 
				  	text: 'S.Talep', 
					columntype: 'textbox', 
					datafield: 'ship_internal_#department_id#', 
					width:50,
					editable:false,
					align: 'right', 
					cellsalign: 'right',
					columngroup: 'dept_#department_id#',
					filtertype:'number', 
					cellsformat:'c2',
					cellclassname:cellclass
					},
					{ 
				  	text: 'İhtiyaç', 
					columntype: 'textbox', 
					datafield: 'dagilim_#department_id#', 
					width:75,
					editable:false,
					align: 'right', 
					cellsalign: 'right',
					columngroup: 'dept_#department_id#',
					filtertype:'number', 
					cellsformat:'c0',
					cellclassname:cellclass
					},
					{ 
				  	text: 'Dağılım', 
					columntype: 'textbox', 
					datafield: 'reel_dagilim_#department_id#', 
					width:75,
					editable:true,
					align: 'right', 
					cellsalign: 'right',
					columngroup: 'dept_#department_id#',
					filtertype:'number', cellsformat:'c0',
					cellclassname:cellclass,
					aggregates: [
									{'' : function(aggregatedValue,currentValue,element,summaryData) 
										{
											var last_row = $('##jqxgrid').jqxGrid('getrowdatabyid',summaryData.uid);
											deger_ = parseFloat(last_row.reel_dagilim_#department_id#);
											if(summaryData.onay_#department_id#)
											{
													aggregatedValue = aggregatedValue + deger_;
											}
											return aggregatedValue;
										}
									  }]
					},
					{ 
				  	text: 'Stok', 
					columntype: 'textbox', 
					datafield: 'sube_stock_#department_id#', 
					width:75,
					editable:false,
					align: 'right', 
					cellsalign: 'right',
					columngroup: 'dept_#department_id#',
					filtertype:'number', cellsformat:'c2',
					cellclassname:cellclass
					},
					{ 
				  	text: '<table class="jqx-grid-column-header-table" cellpadding="0" cellspacing="0" width="100%"><tr><td height="22"><div id="div_onay_#department_id#" style="width:100%; height:20px;" class="jqx-grid-column-header-search-div"></div></td></tr></table>', 
					columntype: 'checkbox', 
					datafield: 'onay_#department_id#', 
					width:35,
					editable:true,
					filtertype:'bool',
					columngroup: 'dept_#department_id#',
					cellclassname:cellclass,
					aggregates: [
									{'' : function(aggregatedValue,currentValue,element,summaryData) 
										{
											var last_row = $('##jqxgrid').jqxGrid('getrowdatabyid',summaryData.uid);
											deger_ = last_row.reel_dagilim_#department_id#;
											if(summaryData.onay_#department_id#)
											{
													aggregatedValue = aggregatedValue + 1;
											}
											return aggregatedValue;
										}
									  }]
					},
				 </cfoutput>
				  { text: 'Stok ID', columntype: 'textbox', datafield: 'stock_id', width: 120,hidden:true}
                ],
				columngroups: 
                [
                  <cfoutput query="get_departments_search">
				  { text: '#department_head#', align: 'center', name: 'dept_#department_id#'}<cfif currentrow neq get_departments_search.recordcount>,</cfif>
				  </cfoutput>
                ]
            });
        });
    </script>
</head>

<style>
	.dagilimcss{background-color:#458b74; color:#ffd700 !important;}
	.dagilimcss div{color:#ffd700 !important;}
	.dagilimcss table tr td{color:#ffd700 !important;}
	
	.depostockcss{background-color:#444444; color:#e0ffff !important;}
	.depostockcss div{color:#e0ffff !important;}
	.depostockcss table tr td{color:#e0ffff !important;}
	
	.depoyoldakicss{background-color:#000000; color:#ff00cc !important;}
	.depoyoldakicss div{color:#ff00cc !important;}
	.depoyoldakicss table tr td{color:#ff00cc !important;}
	
	.shipinternalcss{background-color:#000000; color:#ff00cc !important;}
	.shipinternalcss div{color:#ff00cc !important;}
	.shipinternalcss table tr td{color:#ff00cc !important;}
	
	.depoihtiyaccss{background-color:#458b74; color:#cdb79e !important;}
	.depoihtiyaccss div{color:#cdb79e !important;}
	.depoihtiyaccss table tr td{color:#cdb79e !important;}
	
	.depoyetercss{background-color:#000000; color:#ff781f !important;}
	.depoyetercss div{color:#ff781f !important;}
	.depoyetercss table tr td{color:#ff781f !important;}
	
	.depoortalamacss{background-color:#000000; color:#ff781f !important;}
	.depoortalamacss div{color:#ff781f !important;}
	.depoortalamacss table tr td{color:#ff781f !important;}
	
	.depo_stockcss{background-color:#444444; color:#e0ffff !important;}
	.depo_stockcss div{color:#e0ffff !important;}
	.depo_stockcss table tr td{color:#e0ffff !important;}
</style>

<body class='default'>
    <div id='jqxWidget'>
        <div id="jqxgrid"></div>
        <div style="font-size: 12px; font-family: Verdana, Geneva, 'DejaVu Sans', sans-serif; margin-top: 30px;">
            <div id="cellbegineditevent"></div>
            <div style="margin-top: 10px;" id="cellendeditevent"></div>
       </div>
    </div>

<form name="print_form" action="index.cfm?fuseaction=retail.popup_transfer_branch3" method="post">
	<div id="print_div" style="display:none;">
        <input type="text" name="all_stock_list" id="all_stock_list" value="<cfif myQuery.recordcount><cfoutput>#valuelist(myQuery.stock_id)#</cfoutput></cfif>">
        <input type="text" name="rowcount" value="<cfoutput>#myQuery.recordcount#</cfoutput>">
        <input type="text" name="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
        <input type="text" name="department_id_list" value="<cfoutput>#dept_list#</cfoutput>">
        <input type="text" name="is_from_list" value="<cfoutput>#attributes.is_from_list#</cfoutput>">
        <textarea id="print_note" name="print_note" style="height:150px; width:200px;"></textarea>
    </div>
</form>

</body>
</html>