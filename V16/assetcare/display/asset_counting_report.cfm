<cf_box title="#getlang('','Sayım Raporu','47205')#">
<cfsetting showdebugoutput="no">
<cf_xml_page_edit>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset barcode_list = "">
<cfquery name="GET_ASSET_STATE" datasource="#DSN#">
    SELECT ASSET_STATE_ID,ASSET_STATE FROM ASSET_STATE ORDER BY ASSET_STATE
</cfquery>
<cfquery name="get_process_stage" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = #session.ep.company_id# AND
		PT.FACTION LIKE '%assetcare.form_upd_assetp,%'
</cfquery>

<cfif not isdefined("attributes.uploaded_file")>
<cf_basket_form>
    <cfform name="formimport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=assetcare.asset_counting_report&upload_id=1">
        <cf_box_elements>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12" index="1" type="column" sort="true">
        <div class="col col-6 col-md-6 col-sm-6 col-xs-8">
<!---    Belge Formatı      --->
                    <div class="form-group" id="item-assetp_cat_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55926.Belge Formatı'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <input type="hidden" name="html_file" id="html_file" value="<cfoutput>#createUUID()#</cfoutput>.html">
                            <select name="file_format" id="file_format" style="width:200px;">
                                <option value="utf-8">UTF-8</option>
                            </select>
                        </div>
                    </div>
<!---    Belge      --->
                    <div class="form-group" id="item-assetp_cat_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-example_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/Sayım_Raporu.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div> 
        </div>
<!---    Format      --->
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                    <div class=" d-flex form-group" id="item-assetp_cat_name">
                    <ul class="list-group" style="list-style-type: none" >
                        <li class="list-group-item mb-3"><span style=" font-size: 14px;font-weight: bold;"><cf_get_lang dictionary_id='58594.Format'></span></li>
                        <li class="list-group-item"><cf_get_lang dictionary_id="54674.Dosya excel formatında hazırlanmalıdır"></li>
                        <li class="list-group-item"><cf_get_lang dictionary_id="53889.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır"></li>
                        <li class="list-group-item"><cf_get_lang dictionary_id="54675.Alan İsmi Olarak Barcode Yazılmalıdır"></li>
                        <li class="list-group-item">1- * <cf_get_lang dictionary_id="57633.Barkod"></li>
                    </ul>  
                    </div>
                </div>
        </div>

        
        </cf_box_elements>

        <cf_box_footer>
            <cf_workcube_buttons insert_info = '#getlang('','Çalıştır',57911)#' is_cancel='0' add_function='kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_basket_form>
</cfif>


<cfif isdefined("attributes.uploaded_file")>
	<cfparam name="attributes.is_submit" default="1">
	<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
    <cftry>
        <cffile action = "upload" 
                filefield = "uploaded_file" 
                destination = "#upload_folder_#"
                nameconflict = "MakeUnique"  
                mode="777" charset="#attributes.file_format#">
        <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
        <cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="#attributes.file_format#">	
        <cfset file_size = cffile.filesize>
        <cfcatch type="Any">
            <script type="text/javascript">
                alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
                history.back();
            </script>
            <cfabort>
        </cfcatch>  
    </cftry>
    <cftry>
        <cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
        <cffile action="delete" file="#upload_folder_##file_name#">
    <cfcatch>
        <script type="text/javascript">
            alert("<cf_get_lang_main no='1653.Dosya Okunamadı Karakter Seti Yanlış Seçilmiş Olabilir'>.");
            history.back();
        </script>
        <cfabort>
    </cfcatch>
    </cftry>
	<cfscript>
        CRLF = Chr(13) & Chr(10);// satır atlama karakteri
        dosya = Replace(dosya,';;','; ;','all');
        dosya = Replace(dosya,';;','; ;','all');
        dosya = ListToArray(dosya,CRLF);
        line_count = ArrayLen(dosya);
        counter = 0;
        liste = "";
    </cfscript>
    <cfloop from="2" to="#line_count#" index="i">
		<cfset j= 1>
		<cfset error_flag = 0>
		<cftry>
			<cfscript>
			counter = counter + 1;
			//barcode
			barcode = Listgetat(dosya[i],j,";");
			barcode =trim(barcode);
			j=j+1;
			</cfscript>
            <cfset series[i-1] = barcode>
            <cfcatch type="Any">
				<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
				<cfoutput>#i#</cfoutput>. <cf_get_lang_main no='1096.satır'> <cf_get_lang no='2964.Birinci adımda sorun oluştu'><br/>
				<cfset error_flag = 1>
			</cfcatch>
        </cftry>
    </cfloop>
    <cfset qResult.recordcount = line_count-1>
    <cfset  loop_stone = qResult.recordcount>
    <cfset  loop_count = qResult.recordcount/10000>
    <cfif  listlen (loop_count,'.') gt 1 >
    	<cfset loop_count = int (loop_count)+1 >
    </cfif>
    <cfquery name="check_table" datasource="#dsn#">
    	IF EXISTS ( SELECT * FROM tempdb.sys.tables where name='####TMP_BARCODE' )
        	drop table ####TMP_BARCODE
    </cfquery>
    <cfquery name="cret_tmp_table" datasource="#dsn#">
    	CREATE TABLE ####TMP_BARCODE
        			(
                    	BARCODE  NVARCHAR(50)
                    )
    </cfquery>
    <cfset bitis = 10000>
    <cfset baslangic =1>
    <cfloop from="1" to="#loop_count#" index="aaa">
       <cfquery name="Ins_Table" datasource="#dsn#">
            Insert Into
               ####TMP_BARCODE (BARCODE)
               <cfloop index = "i" from = "1" to = "#ArrayLen(series)#"> 
                <cfif i neq 1>
                    UNION ALL
                </cfif>	
                    SELECT #series[i]#
        </cfloop>     
        </cfquery> 
    	 <cfset baslangic =baslangic+bitis>
    </cfloop>
</cfif> 
<cfif isdefined("attributes.is_submit")> 
<cfif xml_single_show eq 1>
    <cfquery name="get_sistem_bo_excel_barcode" datasource="#dsn#">
        WITH CTE1 AS (
            SELECT 
                ASSET_P.BARCODE as BARCODE--,
                --TB.BARCODE AS BARCODE_EXCEL
                ,ASSET_P.ASSETP_ID
                ,ASSET_P.ASSETP_STATUS
                ,ASSET_P.STATUS
                ,ASSET_P.PROCESS_STAGE
            FROM
                ASSET_P
            LEFT JOIN
                ####TMP_BARCODE  TB
            ON
                ASSET_P.BARCODE =  TB.BARCODE	 COLLATE TURKISH_CI_AS 
                
            WHERE
                 ASSET_P.BARCODE IS NOT NULL and  TB.BARCODE IS NULL
        ),
        CTE2 AS (
                        SELECT
                            CTE1.*,
                            ROW_NUMBER() OVER (	ORDER BY
                                                BARCODE
                                               ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
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
    <CFSET attributes.totalrecords = get_sistem_bo_excel_barcode.query_count>
	<cfset barcode_list = valuelist(get_sistem_bo_excel_barcode.ASSETP_ID)>
<cfelseif xml_single_show eq 0>
	<cfquery name="get_sistem_bo_excel_barcode" datasource="#dsn#">
		SELECT 
			COUNT(BARCODE) AS SAYILMAYAN
			FROM 
			(
			SELECT 
                ASSET_P.BARCODE as BARCODE,
                TB.BARCODE AS BARCODE_EXCEL
            FROM
                ASSET_P
            LEFT JOIN
                ####TMP_BARCODE  TB
            ON
                ASSET_P.BARCODE =  TB.BARCODE	 COLLATE TURKISH_CI_AS  
            WHERE
                 ASSET_P.BARCODE IS NOT NULL and  TB.BARCODE IS NULL
				 )
				 AS T1
    </cfquery> 
    <cfset sayilmayan = get_sistem_bo_excel_barcode.SAYILMAYAN>
    <cfquery name="GET_SAYILAN" datasource="#DSN#">
    	SELECT COUNT(*) AS COUNT FROM ####TMP_BARCODE
    </cfquery> 
    <cfset sayilan = GET_SAYILAN.COUNT>
</cfif>
<cf_basket>
        <form name="upd_form" id="upd_form" method="post" action="<cfoutput>#request.self#?fuseaction=assetcare.emptypopup_upd_report_count</cfoutput>">
        <input type="hidden" name="is_submit" id="is_submit" value="1" />
        <input type="hidden" name="barcode_list" id="barcode_list" value="<cfoutput>#barcode_list#</cfoutput>" />
        <input type="hidden" name="page" id="page" value="<cfoutput>#attributes.page#</cfoutput>" />
        <input type="hidden" name="xml_single_show" value="<cfoutput>#xml_single_show#</cfoutput>" />
        <cf_grid_list class="detail_basket_list">
        
			<cfif xml_single_show eq 1>
                <thead>
				<cfoutput>         	
					<tr>
                    	<th style="width:20px;"></th>
                        <th></th>
                        <th>
                        	<select name="status" id="status" style="width:120px" onchange="order_copy_status()">
                                <option value=""><cf_get_lang dictionary_id="57756.Durum"></option>
                                <cfloop query="get_asset_state">
                                    <option value="#asset_state_id#">#asset_state#</option>
                                </cfloop>
                            </select>	
                        </th>
                        <th>
                        	<select name="process_stage" id="process_stage" style="width:120px;" onchange="order_copy_process_stage()">
                                <option value=""><cf_get_lang dictionary_id="57482.Aşama"></option>
                                <cfloop query="get_process_stage">
                                    <option value="#PROCESS_ROW_ID#">#STAGE#</option>
                                </cfloop>
                            </select>
                        </th>
                        <th>
                           
                        	<input type="checkbox" name="is_active" id="is_active" onclick="order_copy_is_active()" value="1" />
                        </th>
                        <th style="width:15px;"></th>
                    </tr>
                    <tr>
                    	<th style="width:20px;"></th>
                        <th><cf_get_lang dictionary_id="57633.Barkod"></th>
                        <th><cf_get_lang dictionary_id="57756.Durum"></th>
                        <th><cf_get_lang dictionary_id="57482.Aşama"></th>
                        <th><cf_get_lang dictionary_id="57493.Aktif">/<cf_get_lang dictionary_id="57494.Pasif"></th>
                        <th style="width:15px;"><input type="checkbox" name="all_select" id="all_select" onclick="select_all()" value="1" /></th>
                    </tr>
                </cfoutput>       
                </thead>
                <tbody>
                    <cfif get_sistem_bo_excel_barcode.recordcount>
                            <cfoutput query="get_sistem_bo_excel_barcode">
                            <tr>
                            	<td>#rownum#</td>
                                <td>#BARCODE#</td>
                                <td>  
                                    <div class="form-group">          
                                        <select name="status_#ASSETP_ID#" id="status_#ASSETP_ID#">
                                            <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                            <cfloop query="get_asset_state">
                                                <option value="#asset_state_id#" <cfif isdefined("get_sistem_bo_excel_barcode.ASSETP_STATUS") and len(get_sistem_bo_excel_barcode.ASSETP_STATUS) and asset_state_id eq get_sistem_bo_excel_barcode.ASSETP_STATUS>selected</cfif>>#asset_state#</option>
                                            </cfloop>
                                        </select>	
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <select name="process_stage_#ASSETP_ID#" id="process_stage_#ASSETP_ID#" style="width:120px;">
                                            <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                            <cfloop query="get_process_stage">
                                                <option value="#PROCESS_ROW_ID#" <cfif isdefined("get_sistem_bo_excel_barcode.PROCESS_STAGE") and len(get_sistem_bo_excel_barcode.PROCESS_STAGE) and PROCESS_ROW_ID eq get_sistem_bo_excel_barcode.PROCESS_STAGE>selected</cfif>>#STAGE#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">  
                                        <input type="checkbox" name="is_active_#assetp_id#" id="is_active_#assetp_id#" value="#get_sistem_bo_excel_barcode.status#" <cfif get_sistem_bo_excel_barcode.status eq 1>checked</cfif> />
                                    </div>
                                    </td>
                                <td style="width:15px;">
                                    <div class="form-group">  
                                        <input type="checkbox" name="asset_id_#ASSETP_ID#" id="asset_id_#ASSETP_ID#" value="#ASSETP_ID#" />
                                    </div>
                                </td>
                            </tr>
                        </cfoutput>
                    </cfif>
                </tbody>
            <cfelse>
            	<thead>
                	<tr>
                    	<th><cf_get_lang dictionary_id="57492.Toplam"></th>
                        <th><cf_get_lang dictionary_id="57756.Durum"></th>
                        <th><cf_get_lang dictionary_id="57482.Aşama"></th>
                        <th><cf_get_lang dictionary_id="57493.Aktif">/<cf_get_lang dictionary_id="57494.Pasif"></th>
                        <th style="width:15px;">
                        </th>
                    </tr>
                </thead>
                <tbody>
                	<cfoutput>
                	<tr>
                        <td><cf_get_lang dictionary_id="54680.Sayılan"> #sayilan#</td>
                        <td> 
                            <div class="form-group">
                            <select name="status" id="status" style="width:120px">
                                <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                <cfloop query="get_asset_state">
                                    <option value="#asset_state_id#">#asset_state#</option>
                                </cfloop>
                            </select>	
                        </div>
                        </td>
                        <td>
                            <div class="form-group">
                            <select name="process_stage" id="process_stage" style="width:120px;">
                                <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                <cfloop query="get_process_stage">
                                    <option value="#PROCESS_ROW_ID#">#STAGE#</option>
                                </cfloop>
                            </select>
                        </div>
                        </td>
                        <td>
                            <div class="form-group">
                        	<input type="checkbox" name="is_active" id="is_active" value="1" />
                        </div>

                        </td>
                        <td style="width:15px;"><input type="checkbox" name="is_counted" id="is_counted" value="1" /></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id="54681.Sayılmayan"> #sayilmayan#</td>
                        <td> 
                            <div class="form-group">
                            <select name="status1" id="status1" style="width:120px">
                                <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                <cfloop query="get_asset_state">
                                    <option value="#asset_state_id#">#asset_state#</option>
                                </cfloop>
                            </select>	
                        </div>
                        </td>
                        <td>
                            <div class="form-group">
                            <select name="process_stage1" id="process_stage1" style="width:120px;">
                                <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                <cfloop query="get_process_stage">
                                    <option value="#PROCESS_ROW_ID#">#STAGE#</option>
                                </cfloop>
                            </select>
                        </div>
                        </td>
                        <td>
                            <div class="form-group">
                        	<input type="checkbox" name="is_active1" id="is_active1" value="1" />
                        </div>
                        </td>
                        <td style="width:15px;">
                            <div class="form-group">
                                <input type="checkbox" name="is_counted1" id="is_counted1" value="1" />
                            </div>
                        </td>
                    </tr>
                    </cfoutput>
                </tbody>
            </cfif>
            <tfoot>
            	<tr>
                	<td colspan="6">
                    	<cf_workcube_buttons is_cancel='0' type_format='1'>
                    </td>
                </tr>
            </tfoot>
       
    </cf_grid_list>
        </form>
    </cf_basket>
<cfset url_str = "">
<cfif xml_single_show eq 1>
	<cfif isdefined("attributes.is_submit")>
        <cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
    </cfif>
    <cf_paging
        page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="assetcare.asset_counting_report#url_str#">
    </cfif> 
</cfif>

</cf_box>


<script type="text/javascript">
	function kontrol()
	{
		if(formimport.uploaded_file.value.length==0)
		{
			alert("<cf_get_lang dictionary_id='43930.İmport Edilecek Belge Girmelisiniz'>!");
			return false;
		}
			return true;
	}
	<cfoutput>
		function select_all()
		{
				<cfloop list="#barcode_list#" index="i">
					if(document.getElementById('all_select').checked == true)
						document.getElementById('asset_id_#i#').checked=true;
					else
					{
						if	(document.getElementById('asset_id_#i#').checked==false)	
							 document.getElementById('asset_id_#i#').checked=true;
						else
							(document.getElementById('asset_id_#i#').checked=false)	
							 document.getElementById('asset_id_#i#').checked==true;
					}
				</cfloop>
		}
		var number = '#listlen(barcode_list)#';
		function order_copy_status()
		{
			nesne = 'status';
			<cfloop list="#barcode_list#" index="i">
				nn = '#i#';
				var temp_nesne = nesne + '_' + nn;
				document.getElementById(temp_nesne).value=document.getElementById(nesne).value;
			</cfloop>
		}
		
		function order_copy_is_active()
		{
			nesne = 'is_active';
			<cfloop list="#barcode_list#" index="i">
				nn = '#i#';
				var temp_nesne = nesne + '_' + nn;
				if(document.getElementById(nesne).checked == false)
				{
					document.getElementById(temp_nesne).value = 1;
					document.getElementById(temp_nesne).checked = false;
				}
				else if(document.getElementById(nesne).checked == true)
				{
					document.getElementById(temp_nesne).value = 0;
					document.getElementById(temp_nesne).checked = true;
				}
				
			</cfloop>
		}
		
		function order_copy_process_stage()
		{
			nesne = 'process_stage';
			<cfloop list="#barcode_list#" index="i">
				nn = '#i#';
				var temp_nesne = nesne + '_' + nn;
				document.getElementById(temp_nesne).value=document.getElementById(nesne).value;
			</cfloop>
		}
	</cfoutput>
</script>


