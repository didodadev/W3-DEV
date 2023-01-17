<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT 
    	IS_SERIAL_CONTROL,
		IS_SERIAL_CONTROL_LOCATION
    FROM 
    	OUR_COMPANY_INFO 
    WHERE
    	<cfif isDefined('session.ep.userid')> 
	    	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfelseif isDefined('session.pp.userid')>
	    	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">        
        </cfif>
</cfquery>
<cfif isdefined("attributes.select_unit")>
	<cfset select_unit = 1>
</cfif>
<cfset unit_row_quantity = "">
<!--- ******************** SERI NOLAR TEXT FILE DAN IMPORT EDILIYORSA *****************--->
<cfif len(uploaded_file) and attributes.method eq 2>
	<cftry>
		<cffile   action = "upload" 
				  filefield = "uploaded_file" 
				  destination = "#upload_folder#"
				  nameconflict = "MakeUnique"  
				  mode="777" charset="utf-8">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="utf-8">	
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("Dosyanız upload edilemedi ! Dosyanızı kontrol edinizs!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="utf-8">
	
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		//dosya = Replace(dosya,CRLF,',','all'); 
	</cfscript>
	<cfset attributes.row_lot_no1 = ''>
	<cfset reference_numbers = ''>
	<cfset attributes.unit_row_quantity1 = ''>
	<cfset unit_row_quantity = ''>
	<cfset list_numbers = "">
	<cfloop list="#dosya#" index="i" delimiters="#CRLF#">
		<cfset my_seri_ = listfirst(i,';')>
		<cfif listlen(i,';') gt 1>
				<cfset sayi_ = listgetat(i,2,';')>
				<cfset my_count_ = listfirst(sayi_,'.')>
				<cfif len(my_count_) gt 1>
					<cfloop from="1" to="#len(my_count_)#" index="syk">
						<cfset act_value_ = mid(my_count_,syk,1)>
						<cfif act_value_ gt 0 and isdefined("seri_basim_")>
							<cfset seri_basim_ = "#seri_basim_#" & "#act_value_#">
						<cfelseif act_value_ gt 0>
							<cfset seri_basim_ = "#act_value_#">
						<cfelseif isdefined("seri_basim_") and len(seri_basim_)>
							<cfset seri_basim_ = "#seri_basim_#" & "0">			
						</cfif>
					</cfloop>
				<cfelse>
					<cfset seri_basim_ = 1>
				</cfif>
		<cfelse>
			<cfset seri_basim_ = 1>
		</cfif>
		
		<cfif listlen(i,';') gte 2>
			<cfset unit_row_quantity = listgetat(i,2,';')>
			<cfif not len(unit_row_quantity)>
				<cfset unit_row_quantity = '*_*'>
			</cfif> 
		<cfelse>
			<cfset unit_row_quantity = '*_*'>
		</cfif>
		<cfif listlen(i,';') gte 3>
			<cfset lot_ = listgetat(i,3,';')>
			<cfif not len(lot_)>
				<cfset lot_ = '*_*'>
			</cfif> 
		<cfelse>
			<cfset lot_ = '*_*'>
		</cfif>
		<cfset attributes.unit_row_quantity1 = listappend(attributes.unit_row_quantity1,unit_row_quantity,',')>
		<cfset list_numbers = listappend(list_numbers,my_seri_,',')>
		<cfif seri_basim_ neq 1>
			<!--- coklu --->
			<cfset yer = 0>
			<cfset yer2 = 0>
			<cfset f1 = 0>
			<cfset f2 = 0>
			<cfset sayi = "">
			<cfset uzunluk = len(my_seri_)>
			<cfset str = my_seri_>
			<cfset counter = seri_basim_>
			<!--- sayısal kısım bulunur --->
			<cfloop from="1" to="#uzunluk#" index="j">
				<cfset temp = mid(str,uzunluk-j+1,1)>
				<cfif isnumeric(temp)>
					<cfif f1>
						<cfset sayi =  "#temp##sayi#">
					<cfelse>
						<cfset f1 = 1>
						<cfset sayi =  "#temp##sayi#">
					</cfif>
				<cfelse>
					<cfif len(sayi)>
						<cfset yer =j>
						<cfbreak>
					<cfelse>
						<cfset yer2 =j>
					</cfif>
				</cfif>
			</cfloop>
			<cfif yer>
				<cfset start = left(str,len(str)-yer+1)>
			<cfelse>
				<cfset start = "">
			</cfif>
			
			<cfif len(sayi) and len(start)>
				<cfset len_str = len(str)>
				<cfset len_sayi = len(sayi)>
				<cfset len_start = len(start)>
				<cfset minus = len_str - len_sayi-len_start>
				 <cfif minus gt 0>
					<cfset end = right(str,abs(minus))>
				 <cfelse>
					<cfset end = "">
				 </cfif>	
			<cfelse>
				<cfset end = "">
			</cfif>
			<!--- // sayısal kısım bulunur --->
			<!--- sayısal kısım başındaki sıfırlar saklanır --->
			<cfset zero_count = 0>
			<cfset str_zero="">
			<cfset ilk = "">
			<cfif not len(sayi)>
				<cfset sayi = "0">
				<cfif len(yer2)>
					<cfset ilk = left(str,yer2)>
				</cfif>
			</cfif>
			<cfset zero_count = 1>
			<cfset counter_ = len(sayi)>
			<cfloop from="1" to="#len(sayi)#" index="k">
				<cfif mid(sayi,counter_,1) eq 0>
					<cfset zero_count = zero_count + 1>
				</cfif>
				<cfset counter_ = counter_ -1>
			</cfloop>
			<cfset zero_count = zero_count-1>
			<cfif (zero_count eq 1) and left(sayi, 1)>
				<cfset zero_count = 0>
			</cfif>
			<cfif zero_count neq 0>
				<cfloop from="1" to="#zero_count#" index="m">
					<cfset str_zero = str_zero & "0">
				</cfloop>
			</cfif>
			<!--- //sayısal kısım başındaki sıfırlar saklanır --->
			
			<cfloop from="0" to="#counter-1#" index="i">
				<cfset temp_sayi = "#sayi#">
				<cfif len(ilk)>
					<cfset temp_sayi = "#ilk##temp_sayi#">
				</cfif>
				<cfif len(start)>
					<cfset temp_sayi = "#start##temp_sayi#">
				</cfif>
				<cfif len(end)>
					<cfset temp_sayi = "#temp_sayi##end#">
				</cfif>
				<!--- Sadece dosyadaki değerlerin gelmesi için kapatıldı. ---> 
				<!--- <cfset list_numbers = listappend(list_numbers, temp_sayi, ',')> --->
				<cfset sayi = add_one(sayi)>
			</cfloop>
				<!--- coklu --->
			</cfif>
					<cfset seri_basim_ = "">
					
	
		<cfset attributes.row_lot_no1 = listappend(attributes.row_lot_no1,lot_,',')>
		<cfif listlen(i,';') gte 4>
			<cfset ref_no_action = 1>
			<cfset ref_no_ = listgetat(i,4,';')>
			<cfif len(ref_no_)>
				<cfset reference_numbers = listappend(reference_numbers,ref_no_,',')>
			</cfif>
		</cfif>
	</cfloop>
	<!--- ******************** //SERI NOLAR TEXT FILE DAN IMPORT EDILIYORSA *****************--->
<cfelse>
	<cfset list_numbers = "">
	<cfset yer = 0>
	<cfset yer2 = 0>
	<cfset f1 = 0>
	<cfset f2 = 0>
	<cfif attributes.method eq 0 or attributes.method eq 3>
		<cfif isDefined('attributes.m_type')>
			<cfif attributes.m_type eq 1>
                <cfset my_ship_start_no = replace(attributes.ship_start_no,'*','-','all')>
            <cfelseif attributes.m_type eq 2>
                <cfset my_ship_start_no = replace(attributes.ship_start_no_orta,'*','-','all')>
            <cfelseif attributes.m_type eq 3>
                <cfset my_ship_start_no = replace(attributes.ship_start_no_son,'*','-','all')>
            </cfif>
		<cfelse>
			<cfset my_ship_start_no = 0>
		</cfif>
	<cfelse>
		<cfset my_ship_start_no = replace(attributes.ship_start_no,'*','-','all')>
	</cfif>
	<cfset uzunluk = len(my_ship_start_no)>
	<cfset str = my_ship_start_no>
	<cfif isdefined("attributes.amount_2") and len(attributes.amount_2) and attributes.select_unit eq 2>
		<cfset counter = attributes.amount_2>
		<cfset unit_row_quantity = attributes.range_number / attributes.amount_2>
		
		<cfquery name="get_total_quantity" datasource="#dsn3#">
			SELECT SUM(UNIT_ROW_QUANTITY) AS QUANTITY FROM SERVICE_GUARANTY_NEW WHERE STOCK_ID = #attributes.stock_id# and PROCESS_ID = #attributes.process_id# and WRK_ROW_ID = '#attributes.wrk_row_id#'
		</cfquery>
		<cfif get_total_quantity.recordcount and len(get_total_quantity.QUANTITY)>
			<cfset unit_row_quantity = attributes.range_number - get_total_quantity.QUANTITY>
			<cfset unit_row_quantity = unit_row_quantity / attributes.amount_2>
		</cfif>
	<cfelse>
		<cfset counter = attributes.amount>
		<cfset unit_row_quantity = attributes.range_number / attributes.range_number >
	</cfif>
	<cfif attributes.method eq 0>
		<cfset sayi = "">
		<!--- sayısal kısım bulunur --->
		<cfloop from="1" to="#uzunluk#" index="j">
			<cfset temp = mid(str,uzunluk-j+1,1)>
			<cfif isnumeric(temp)>
				<cfif f1>
					<cfset sayi =  "#temp##sayi#">
				<cfelse>
					<cfset f1 = 1>
					<cfset sayi =  "#temp##sayi#">
				</cfif>
			<cfelse>
				<cfif len(sayi)>
					<cfset yer =j>
					<cfbreak>
				<cfelse>
					<cfset yer2 =j>
				</cfif>
			</cfif>
		</cfloop>
		<cfif yer>
			<cfset start = left(str,len(str)-yer+1)>
		<cfelse>
			<cfset start = "">
		</cfif>
		<cfif len(sayi) and len(start)>
			<cfset len_str = len(str)>
			<cfset len_sayi = len(sayi)>
			<cfset len_start = len(start)>
			<cfset minus = len_str - len_sayi-len_start>
			 <cfif minus gt 0>
				<cfset end = right(str,abs(minus))>
			 <cfelse>
				<cfset end = "">
			 </cfif>	
		<cfelse>
			<cfset end = "">
		</cfif>
		<!--- // sayısal kısım bulunur ---> 
		<!--- sayısal kısım başındaki sıfırlar saklanır --->
		<cfset zero_count = 0>
		<cfset str_zero="">
		<cfset ilk = "">
		<cfif not len(sayi)>
			<cfset sayi = "0">
			<cfif len(yer2)>
				<cfset ilk = left(str,yer2)>
			</cfif>
		</cfif>
		<cfset zero_count = 1>
		<cfset counter_ = len(sayi)>
		<cfloop from="1" to="#len(sayi)#" index="k">
			<cfif mid(sayi,counter_,1) eq 0>
				<cfset zero_count = zero_count + 1>
			</cfif>
			<cfset counter_ = counter_ -1>
		</cfloop>
		<cfset zero_count = zero_count-1>
		<cfif (zero_count eq 1) and left(sayi, 1)>
			<cfset zero_count = 0>
		</cfif>
		<cfif zero_count neq 0>
			<cfloop from="1" to="#zero_count#" index="m">
				<cfset str_zero = str_zero & "0">
			</cfloop>
		</cfif>        
		<!--- //sayısal kısım başındaki sıfırlar saklanır --->
		<cfif attributes.sale_product eq 0>
			<cfloop from="0" to="#counter-1#" index="i">
				<cfset temp_sayi = "#sayi#">
				<cfif len(ilk)>
					<cfset temp_sayi = "#ilk##temp_sayi#">
				</cfif>
				<cfif len(start)>
					<cfset temp_sayi = "#start##temp_sayi#">
				</cfif>
				<cfif len(end)>
					<cfset temp_sayi = "#temp_sayi##end#">
				</cfif>
				<!--- isbak üretim emir seri generate py --->
				<cfif isdefined("is_generate_serial_nos")>
					<cfif temp_sayi gt 999>
						<cfset my_exp = mid(temp_sayi,1,2)>
						<cfset my_exp2 = mid(temp_sayi,3,2)>
						<cfswitch expression="#my_exp#">
							<cfcase value="10">
								<cfset my_exp = 'A'>
							</cfcase>
							<cfcase value="11">
								<cfset my_exp = 'B'>
							</cfcase>
							<cfcase value="12">
								<cfset my_exp = 'C'>
							</cfcase>
							<cfcase value="13">
								<cfset my_exp = 'D'>
							</cfcase>
							<cfcase value="14">
								<cfset my_exp = 'E'>
							</cfcase>
							<cfcase value="15">
								<cfset my_exp = 'F'>
							</cfcase>
							<cfcase value="16">
								<cfset my_exp = 'G'>
							</cfcase>
							<cfcase value="17">
								<cfset my_exp = 'H'>
							</cfcase>
							<cfcase value="18">
								<cfset my_exp = 'I'>
							</cfcase>
							<cfcase value="19">
								<cfset my_exp = 'J'>
							</cfcase>
							<cfcase value="20">
								<cfset my_exp = 'K'>
							</cfcase>
							<cfcase value="21">
								<cfset my_exp = 'L'>
							</cfcase>
							<cfcase value="22">
								<cfset my_exp = 'M'>
							</cfcase>
							<cfcase value="23">
								<cfset my_exp = 'N'>
							</cfcase>
							<cfcase value="24">
								<cfset my_exp = 'O'>
							</cfcase>
							<cfcase value="25">
								<cfset my_exp = 'P'>
							</cfcase>
							<cfcase value="26">
								<cfset my_exp = 'R'>
							</cfcase>
							<cfcase value="27">
								<cfset my_exp = 'Q'>
							</cfcase>
							<cfcase value="28">
								<cfset my_exp = 'S'>
							</cfcase>
							<cfcase value="29">
								<cfset my_exp = 'T'>
							</cfcase>
						</cfswitch>  
						<cfset temp_sayi = my_exp&my_exp2>
					</cfif>
				</cfif>
				<cfif isDefined('attributes.m_type')>
					<cfif attributes.m_type eq 1>
						<cfif isdefined("attributes.ship_start_no_orta") and len(attributes.ship_start_no_orta)>
							<cfset temp_sayi = "#temp_sayi##attributes.ship_start_no_orta#">
						</cfif>
						<cfif isdefined("attributes.ship_start_no_son") and len(attributes.ship_start_no_son)>
							<cfset temp_sayi = "#temp_sayi##attributes.ship_start_no_son#">
						</cfif>
					<cfelseif attributes.m_type eq 2>
						<cfif isdefined("attributes.ship_start_no") and len(attributes.ship_start_no)>
							<cfset temp_sayi = "#attributes.ship_start_no##temp_sayi#">
						</cfif>
						<cfif isdefined("attributes.ship_start_no_son") and len(attributes.ship_start_no_son)>
							<cfset temp_sayi = "#temp_sayi##attributes.ship_start_no_son#">
						</cfif>
					<cfelseif attributes.m_type eq 3>
						<cfif isdefined("attributes.ship_start_no_orta") and len(attributes.ship_start_no_orta)>
							<cfset temp_sayi = "#attributes.ship_start_no_orta##temp_sayi#">
						</cfif>
						<cfif isdefined("attributes.ship_start_no") and len(attributes.ship_start_no)>
							<cfset temp_sayi = "#attributes.ship_start_no##temp_sayi#">
						</cfif>
					</cfif>
				<cfelse>
					<cfset temp_sayi = 0>
				</cfif>
				<cfif listlen(list_numbers) and not listfind(list_numbers, temp_sayi, ',')>
					<cfset list_numbers = listappend(list_numbers, temp_sayi, ',')>
				<cfelseif not listlen(list_numbers)>
					<cfset list_numbers = listappend(list_numbers, temp_sayi, ',')>
				</cfif>
				<cfset sayi = add_one(sayi)>
			</cfloop>
		<cfelse>
			<cfset temp_sayi = "#sayi#">
			<cfif len(ilk)>
				<cfset temp_sayi = "#ilk##temp_sayi#">
			</cfif>
			<cfif len(start)>
				<cfset temp_sayi = "#start##temp_sayi#">
			</cfif>
			<cfif len(end)>
				<cfset temp_sayi = "#temp_sayi##end#">
			</cfif>
			<cfset list_numbers = listappend(list_numbers, temp_sayi, ',')>
			<cfset unit_row_quantity = attributes.amount>
		</cfif>
	<cfelse>
		<cfset attributes.ship_start_no = ListChangeDelims(replacelist(attributes.ship_start_nos,"#chr(13)##chr(10)#",";"),",",";")>
		<cfset attributes.ship_start_no = attributes.ship_start_no>
		<cfset counter = 0>
		<cfset list_numbers = listappend(list_numbers,attributes.ship_start_no,',')>
	</cfif>
</cfif>
<cfif isdefined("attributes.reference_nos") and not isdefined("ref_no_action")>
	<cfset attributes.reference_no = ListChangeDelims(replacelist(attributes.reference_nos,"#chr(13)##chr(10)#",";"),",",";")>
	<cfset reference_numbers = ListDeleteDuplicates(attributes.reference_no)>
	<cfset ref_no_action = 1>
</cfif>
<cfif isdefined("attributes.xml_serial_out_control") and attributes.xml_serial_out_control and attributes.sale_product eq 0>
	<cfquery name="control_serial_no" datasource="#dsn3#">
    	SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO IN (
        <cfloop list="#list_numbers#" index="cc">
        	'#cc#' <cfif listlast(list_numbers) neq cc>,</cfif>
        </cfloop>
        )
    </cfquery>
    <cfif control_serial_no.recordcount>
    	<script type="text/javascript">
        	alert("Bu Seri Daha Önce Sisteme Girilmiş. Giriş Yapamazsınız!")
			history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>

<!--- reference kontrolü --->
<cfif isdefined("ref_no_action") and listlen(reference_numbers)>
	<cfquery name="get_seri_kontrol_all" datasource="#dsn3#">
		SELECT 
			GUARANTY_ID,
			DEPARTMENT_ID,
			LOCATION_ID,
			SERIAL_NO,
			STOCK_ID,
			IN_OUT,
			IS_SERVICE,
			IS_PURCHASE,
			PROCESS_CAT,
			REFERENCE_NO
		FROM 
			SERVICE_GUARANTY_NEW 
		WHERE 
			REFERENCE_NO IN ('#Replace(reference_numbers,",","','","all")#') AND 
			STOCK_ID = #attributes.stock_id#
			<cfif attributes.process_cat neq 1194>
				AND PROCESS_CAT <> 1194
			</cfif>
	</cfquery>
	<cfloop list="#reference_numbers#" index="k">
		<cfif get_our_company_info.is_serial_control eq 1 or get_our_company_info.is_serial_control_location eq 1> <!--- session da seri kontrol yapilmasi parametresi gelmezse 596. satira kadar buraya girmez --->	
			<cfif listfindnocase('73,74,75,76,77,80,82,84,86,87,110,114,140,171,1194',attributes.process_cat,',')><!--- alim isleminde alis var mi? "115-sayım fişi çıkarıldı" 0115 PY--->
				<cfquery name="get_seri_kontrol" dbtype="query">
					SELECT 
						GUARANTY_ID ,
                        IN_OUT
					FROM 
						get_seri_kontrol_all 
					WHERE 
						(REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#') AND 
						STOCK_ID = #attributes.stock_id#
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
                    ORDER BY GUARANTY_ID DESC
				</cfquery>
                <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                    <cfloop list="#attributes.x_serino_control_out#" index="cc">
                        <cfif listfind("73,74,75,76,77,80,82,84,86,87,110,114,140,171,1194",cc)>
                            <cfset is_control_0 = 1>
                        </cfif>
                    </cfloop>
                    <cfif isdefined("is_control_0")>
                        <cfif get_seri_kontrol.recordcount AND get_seri_kontrol.IN_OUT EQ 1>
                            <script type="text/javascript">
                                alert("<cfoutput>#k#</cfoutput> seri no sistemde kullanılmaktadır! Aynı seri ile giriş yapamazsınız!");
                                history.back();
                            </script>
                            <cfabort>
                        </cfif>
                    </cfif>
                 <cfelse>
                 	 <cfif get_seri_kontrol.recordcount AND get_seri_kontrol.IN_OUT EQ 1>
						<script type="text/javascript">
                            alert("<cfoutput>#k#</cfoutput> seri no sistemde kullanılmaktadır! Aynı seri ile giriş yapamazsınız!");
                            history.back();
                        </script>
                        <cfabort>
                     </cfif>
                 </cfif>
			<cfelseif listfindnocase('81,811,113',attributes.process_cat,',')>
                   <cfquery name="get_seri_kontrol" dbtype="query" maxrows="1"><!--- sevk isleminde alis var mi?--->
                        SELECT
                            IN_OUT
                        FROM 
                            get_seri_kontrol_all
                        WHERE 
                            (REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#') AND 
							STOCK_ID = #attributes.stock_id#
							<cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
                        ORDER BY 
                            GUARANTY_ID DESC
					</cfquery>
                 <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                    <cfloop list="#attributes.x_serino_control_out#" index="cc">
                        <cfif listfind("81,811,113",cc)>
                            <cfset is_control_0 = 1>
                        </cfif>
                    </cfloop>
                    <cfif isdefined("is_control_0")>
                        <cfif (get_seri_kontrol.recordcount EQ 1 and get_seri_kontrol.in_out eq 0) or (not get_seri_kontrol.RECORDCOUNT)>
                            <script type="text/javascript">
								<cfif get_our_company_info.is_serial_control_location eq 1>
										alert('Seçilen depoda <cfoutput>#k#</cfoutput> seri no bulunamadı! Giriş olmayan serinin çıkışını yapamazsınız!');
									<cfelse>
										alert("<cfoutput>#k#</cfoutput> seri no sistemde bulunamadı! Giriş olmayan serinin çıkışını yapamazsınız!");
									</cfif>
                                history.back();
                            </script>
                            <cfabort>
                        </cfif>
                    </cfif>
                <cfelse>
                		<cfif (get_seri_kontrol.recordcount EQ 1 and get_seri_kontrol.in_out eq 0) or (not get_seri_kontrol.RECORDCOUNT)>
							<script type="text/javascript">
								<cfif get_our_company_info.is_serial_control_location eq 1>
									alert('Seçilen depoda <cfoutput>#k#</cfoutput> seri no bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!');
								<cfelse>
									alert("<cfoutput>#k#</cfoutput> seri no sistemde bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!");
								</cfif>
								history.back();
							</script>
							<cfabort>
						</cfif>
                </cfif>
			<cfelseif listfindnocase('70,71,72,78,79,83,88,111',attributes.process_cat,',')>
            	<cfquery name="get_seri_kontrol" dbtype="query"><!--- satis isleminde alis var mi?--->
                    SELECT 
                        GUARANTY_ID,DEPARTMENT_ID,LOCATION_ID
                    FROM 
                        get_seri_kontrol_all
                    WHERE 
                        (REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#') AND 
						STOCK_ID = #attributes.stock_id#
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
                </cfquery>
                <cfquery name="get_seri_kontrol_satis" dbtype="query" maxrows="1"><!--- satis isleminde satis var mi?--->
					SELECT 
						IN_OUT 
					FROM 
						get_seri_kontrol_all 
					WHERE 
						(REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#') AND 
						STOCK_ID = #attributes.stock_id#
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
					ORDER BY 
						GUARANTY_ID DESC
				</cfquery>
            	<cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                        <cfloop list="#attributes.x_serino_control_out#" index="cc">
							<cfif listfind("70,71,72,78,79,83,88,111",cc)>
								<cfset is_control_1 = 1>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("is_control_1")>
							<cfif not get_seri_kontrol.recordcount>
                                <script type="text/javascript">
                                   <cfif get_our_company_info.is_serial_control_location eq 1>
									alert('Seçilen depoda <cfoutput>#k#</cfoutput> seri no bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!');
								<cfelse>
									alert("<cfoutput>#k#</cfoutput> seri no sistemde bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!");
								</cfif>
                                    history.back();
                                </script>
                                <cfabort>
                            </cfif>
                            <cfif get_seri_kontrol_satis.in_out neq 1>
                                <script type="text/javascript">
                                    alert('<cfoutput>#k#</cfoutput> seri no satılamaz durumda!\nSeri ile ilgili işlemleri kontrol ediniz!');
                                    history.back();
                                </script>
                                <cfabort>
                            </cfif>
                        </cfif>
                <cfelse>
                	<cfif not get_seri_kontrol.recordcount>
						<script type="text/javascript">
                           <cfif get_our_company_info.is_serial_control_location eq 1>
									alert('Seçilen depoda <cfoutput>#k#</cfoutput> seri no bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!');
								<cfelse>
									alert("<cfoutput>#k#</cfoutput> seri no sistemde bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!");
								</cfif>
                            history.back();
                        </script>
                        <cfabort>
                    </cfif>
                    <cfif get_seri_kontrol_satis.in_out neq 1>
						<script type="text/javascript">
							alert('<cfoutput>#k#</cfoutput> seri no satılamaz durumda!\nSeri ile ilgili işlemleri kontrol ediniz!');
							history.back();
						</script>
						<cfabort>
					</cfif>
                </cfif>
			<cfelseif listfindnocase('73,74,75',attributes.process_cat,',')><!--- satis donenler --->
				<cfquery name="get_seri_kontrol" dbtype="query" maxrows="1"><!--- satis dönüs isleminde satis var mi?--->
					SELECT 
						IN_OUT,
						IS_PURCHASE
					FROM 
						get_seri_kontrol_all 
					WHERE 
						( REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#' ) AND 
						STOCK_ID = #attributes.stock_id#
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
					ORDER BY GUARANTY_ID DESC
				</cfquery>
                <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                        <cfloop list="#attributes.x_serino_control_out#" index="cc">
							<cfif listfind("73,74,75",cc)>
								<cfset is_control_2 = 1>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("is_control_2")>
                        	<cfif not get_seri_kontrol.recordcount or (get_seri_kontrol.recordcount and get_seri_kontrol.in_out eq 1)>
								<script type="text/javascript">
                                   <cfif get_our_company_info.is_serial_control_location eq 1>
										alert("Seçilen depoda <cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün satış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
									<cfelse>
                                    	alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün satış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
									</cfif>
                                    history.back();
                                </script> 
                                <cfabort>
                            </cfif>
                        </cfif>
                <cfelse>
                	<cfif not get_seri_kontrol.recordcount or (get_seri_kontrol.recordcount and get_seri_kontrol.in_out eq 1)>
						<script type="text/javascript">
                            <cfif get_our_company_info.is_serial_control_location eq 1>
								alert("Seçilen depoda <cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün satış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
							<cfelse>
								alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün satış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
							</cfif>  
                            history.back();
                        </script> 
                        <cfabort>
                    </cfif>
                </cfif>
			<cfelseif listfindnocase('78,79',attributes.process_cat,',')><!--- alis donenler --->
				<cfquery name="get_seri_kontrol" dbtype="query" maxrows="1"><!--- satis alis isleminde satis var mi?--->
					SELECT 
						IN_OUT,
						IS_PURCHASE
					FROM 
						get_seri_kontrol_all 
					WHERE 
						(REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#') AND 
						STOCK_ID = #attributes.stock_id#
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
					ORDER BY GUARANTY_ID DESC
				</cfquery>
                <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                    <cfloop list="#attributes.x_serino_control_out#" index="cc">
                        <cfif listfind("78,79",cc)>
                            <cfset is_control_3 = 1>
                        </cfif>
                    </cfloop>
                    <cfif isdefined("is_control_3")>
                    	<cfif not get_seri_kontrol.recordcount or (get_seri_kontrol.recordcount and (get_seri_kontrol.in_out neq 1 or get_seri_kontrol.IS_PURCHASE eq 0))>
							<script type="text/javascript">
                                <cfif get_our_company_info.is_serial_control_location eq 1>
									alert("Seçilen depoda <cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün alış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
								<cfelse>
									alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün alış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
								</cfif> 
                                history.back();
                            </script> 
                            <cfabort>
                        </cfif>
                    </cfif>
                <cfelse>
                	<cfif not get_seri_kontrol.recordcount or (get_seri_kontrol.recordcount and (get_seri_kontrol.in_out neq 1 or get_seri_kontrol.IS_PURCHASE eq 0))>
						<script type="text/javascript">
                           <cfif get_our_company_info.is_serial_control_location eq 1>
									alert("Seçilen depoda <cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün alış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
								<cfelse>
									alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün alış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
								</cfif>  
                            history.back();
                        </script> 
                        <cfabort>
                    </cfif>
                </cfif>
			<cfelseif listfindnocase('111,112,113,117',attributes.process_cat,',')><!--- fis islemleri --->
				<cfquery name="get_seri_kontrol" dbtype="query">
					SELECT 
						GUARANTY_ID 
					FROM 
						get_seri_kontrol_all 
					WHERE 
						( REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#' ) AND  
						STOCK_ID = #attributes.stock_id# AND
						PROCESS_CAT IN (76,77,82,84,1190,113,115,811,171,81)
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
				</cfquery>
                <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                    <cfloop list="#attributes.x_serino_control_out#" index="cc">
                        <cfif listfind("111,112,113,117",cc)>
                            <cfset is_control_4 = 1>
                        </cfif>
                    </cfloop>
                    <cfif isdefined("is_control_4")>
                    	<cfif not get_seri_kontrol.recordcount>
							<script type="text/javascript">
                                <cfif get_our_company_info.is_serial_control_location eq 1>
									alert("Seçilen depoda <cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\nAlışı olmayan seriye işlem yapamazsınız!");
								<cfelse>
									alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\nAlışı olmayan seriye işlem yapamazsınız!");
								</cfif>  
                                history.back();
                            </script> 
                            <cfabort>
                        </cfif>
                    </cfif>
                <cfelse>
                	<cfif not get_seri_kontrol.recordcount>
						<script type="text/javascript">
                            <cfif get_our_company_info.is_serial_control_location eq 1>
								alert("Seçilen depoda <cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\nAlışı olmayan seriye işlem yapamazsınız!");
							<cfelse>
								alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\nAlışı olmayan seriye işlem yapamazsınız!");
							</cfif> 
                            history.back();
                        </script> 
                        <cfabort>
                    </cfif>
                </cfif>
			<cfelseif listfindnocase('86',attributes.process_cat,',')><!--- ureticiden giris islemleri --->
			<cfelseif listfindnocase('85',attributes.process_cat,',')><!--- ureticiye cikis islemleri --->	
				<cfquery name="get_seri_kontrol" dbtype="query">
					SELECT 
						GUARANTY_ID 
					FROM 
						get_seri_kontrol_all 
					WHERE 
						( REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#' ) AND 
						STOCK_ID = #attributes.stock_id# AND
						PROCESS_CAT IN (76,77,82,84,1190)
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
				</cfquery>
                <cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,85)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
					<cfif not get_seri_kontrol.recordcount>
                        <script type="text/javascript">
                           <cfif get_our_company_info.is_serial_control_location eq 1>
								alert("Seçilen depoda <cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\nAlışı olmayan seriye işlem yapamazsınız!");
							<cfelse>
								alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\nAlışı olmayan seriye işlem yapamazsınız!");
							</cfif>  
                            history.back();
                        </script> 
                        <cfabort>
                    </cfif>
                </cfif>
                <cfquery name="get_seri_kontrol_son_durum" dbtype="query" maxrows="1">
					SELECT 
						IN_OUT,
						IS_SERVICE,
						IS_PURCHASE,
						PROCESS_CAT
					FROM 
						get_seri_kontrol_all 
					WHERE 
						( REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#' ) AND 
						STOCK_ID = #attributes.stock_id#
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
					ORDER BY GUARANTY_ID DESC
				</cfquery>
                <cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,85)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
                    <cfif not (get_seri_kontrol_son_durum.IN_OUT eq 1 or get_seri_kontrol_son_durum.IS_SERVICE eq 1)>
						<script type="text/javascript">
                            alert("<cfoutput>#k#</cfoutput> seri no'lu ürün üreticiye gönderilemez!\Seri adımlarını kontrol ediniz!");
                            history.back();
                        </script> 
                        <cfabort>
                    </cfif>
                </cfif>
			<cfelseif listfindnocase('140',attributes.process_cat,',')><!--- servis giris islemleri --->
				<cfquery name="get_seri_kontrol" dbtype="query" maxrows="1">
					SELECT 
						GUARANTY_ID 
					FROM 
						get_seri_kontrol_all 
					WHERE 
						( REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#' ) AND 
						STOCK_ID = #attributes.stock_id# AND
						PROCESS_CAT IN (70,71,72,83,111)
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
					ORDER BY GUARANTY_ID DESC
				</cfquery>
				<cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,140)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
                	<cfif not get_seri_kontrol.recordcount>
						<script type="text/javascript">
                           <cfif get_our_company_info.is_serial_control_location eq 1>
								alert("Seçilen depoda <cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\Satışı olmayan seriye servis giriş işlemi yapamazsınız!");
							<cfelse>
								alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\Satışı olmayan seriye servis giriş işlemi yapamazsınız!");
							</cfif> 
                            history.back();
                        </script> 
                        <cfabort>
                    </cfif>
                </cfif>
				<cfquery name="get_seri_kontrol_giris" dbtype="query"><!--- servis cikis isleminde alis var mi?--->
					SELECT 
						PROCESS_CAT 
					FROM 
						get_seri_kontrol_all 
					WHERE 
						( REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#' ) AND 
						STOCK_ID = #attributes.stock_id# AND
						PROCESS_CAT = 140
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
					ORDER BY
						GUARANTY_ID DESC
				</cfquery>
				<cfquery name="get_seri_kontrol_cikis" dbtype="query"><!--- servis cikis isleminde alis var mi?--->
					SELECT 
						PROCESS_CAT 
					FROM 
						get_seri_kontrol_all 
					WHERE 
						( REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#' ) AND 
						STOCK_ID = #attributes.stock_id#
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
					ORDER BY
						GUARANTY_ID DESC
				</cfquery>
				<cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,140)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
					<cfif get_seri_kontrol_giris.recordcount and get_seri_kontrol_cikis.process_cat neq 141>
                        <script type="text/javascript">
                            alert('<cfoutput>#k#</cfoutput> seri no Serviste görünüyor.!\nTekrar Giriş yapamazsınız!');
                            history.back();
                        </script>
                        <cfabort>
                    </cfif>	
                </cfif>
			<cfelseif listfindnocase('141',attributes.process_cat,',')><!--- servis cikis islemleri --->
				<cfquery name="get_seri_kontrol" dbtype="query" maxrows="1"><!--- servis cikis isleminde alis var mi?--->
					SELECT 
						GUARANTY_ID 
					FROM 
						get_seri_kontrol_all 
					WHERE 
						( REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#' ) AND 
						STOCK_ID = #attributes.stock_id# AND
						PROCESS_CAT IN (73,74,75,76,77,80,81,82,84,86,110,114,140,811,1190)
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
					ORDER BY
						GUARANTY_ID DESC
				</cfquery>
				<cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,141)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
					<cfif not get_seri_kontrol.recordcount>
                        <script type="text/javascript">
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                	alert('Seçilen depoda <cfoutput>#k#</cfoutput> seri no bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!');
								<cfelse>
                                	alert('<cfoutput>#k#</cfoutput> seri no sistemde bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!');
								</cfif> 
                            history.back();
                        </script>
                        <cfabort>
                    </cfif>
                </cfif>	
				<cfquery name="get_seri_kontrol_son" dbtype="query"><!--- servis cikis isleminde alis var mi?--->
					SELECT 
						PROCESS_CAT 
					FROM 
						get_seri_kontrol_all 
					WHERE 
						( REFERENCE_NO = '#ucase(k)#' OR REFERENCE_NO = '#lcase(k)#' ) AND 
						STOCK_ID = #attributes.stock_id#
						<cfif get_our_company_info.is_serial_control_location eq 1>
							AND DEPARTMENT_ID = #attributes.department_id#
							AND LOCATION_ID = #attributes.location_id#
						</cfif>
					ORDER BY
						GUARANTY_ID DESC
				</cfquery>
				<cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,141)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
					<cfif get_seri_kontrol_son.PROCESS_CAT eq 141>
                        <script type="text/javascript">
                            <cfif get_our_company_info.is_serial_control_location eq 1>
								alert('Seçilen depoda <cfoutput>#k#</cfoutput> seri no için çıkış yapılmış!\nTekrar Çıkış yapamazsınız!');
							<cfelse>
								alert('<cfoutput>#k#</cfoutput> seri no için çıkış yapılmış!\nTekrar Çıkış yapamazsınız!');
							</cfif> 
                            history.back();
                        </script>
                        <cfabort>
                    </cfif>	
                </cfif> 
			</cfif>
		</cfif> <!--- session da seri kontrol yapilmasi parametresi gelmezse buraya girmez --->
	</cfloop>
</cfif>
<!--- //reference kontrolü --->
<cfset list_numbers = ListDeleteDuplicates(list_numbers)>

<!--- alış-satış kontrolü --->
<cfset list_control_alis = "">
<cfset list_control_satis = "">
<cfif listlen(list_numbers)>
	<cfquery name="get_seri_kontrol_all" datasource="#dsn3#">
		SELECT 
			GUARANTY_ID,
			DEPARTMENT_ID,
			LOCATION_ID,
			SERIAL_NO,
			STOCK_ID,
			IN_OUT,
			IS_SERVICE,
			IS_PURCHASE,
			PROCESS_CAT,
			UPPER(SERIAL_NO) SERIAL_NO2 <!--- query of query de text alaninda arama yaparken sorun old. dolayi eklendi --->
		FROM 
			SERVICE_GUARANTY_NEW 
		WHERE 
			SERIAL_NO IN ('#Replace(list_numbers,",","','","all")#') AND 
			STOCK_ID = #attributes.stock_id#
			<cfif attributes.process_cat neq 1194>
				AND PROCESS_CAT <> 1194
			</cfif>
	</cfquery>
	<cfloop list="#list_numbers#" index="k">
		<cfif get_our_company_info.is_serial_control eq 1> <!--- session da seri kontrol yapilmasi parametresi gelmezse 596. satira kadar buraya girmez --->	
			<cfif listfindnocase('73,76,77,80,82,84,86,110,114,171,1194',attributes.process_cat,',')><!--- alim isleminde alis var mi?  "115-sayım fişi çıkarıldı" 0115 PY--->
					<cfquery name="get_seri_kontrol" dbtype="query">
						SELECT
							GUARANTY_ID,
                            IN_OUT
						FROM
							get_seri_kontrol_all
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id#
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
                         ORDER BY GUARANTY_ID DESC
					</cfquery>
                    <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                        <cfloop list="#attributes.x_serino_control_out#" index="cc">
							<cfif listfind("73,75,76,77,80,82,84,86,110,114,171,1194",cc)>
								<cfset is_control_5 = 1>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("is_control_5")>
							<cfif get_seri_kontrol.recordcount AND get_seri_kontrol.IN_OUT EQ 1 And (isdefined("attributes.xml_serial_out_control") and attributes.xml_serial_out_control)>
                                <script type="text/javascript">
                                    <cfif isdefined("attributes.x_serial_no_create_type") and attributes.x_serial_no_create_type eq 1>
                                        alert("<cfoutput>#k#</cfoutput> seri no sistemde kullanılmaktadır! Aynı seri ile giriş yapamazsınız! Ay ve Yıl Değerlerini Tekrar Seçip Kaydediniz !");
                                    <cfelse>	
                                        alert("<cfoutput>#k#</cfoutput> seri no sistemde kullanılmaktadır! Aynı seri ile giriş yapamazsınız!");
                                    </cfif>
                                    history.back();
                                </script>
                                <cfabort>
                            </cfif>
                        </cfif>
                    <cfelse>
                    	<cfif get_seri_kontrol.recordcount AND get_seri_kontrol.IN_OUT EQ 1>
							<script type="text/javascript">
                                <cfif isdefined("attributes.x_serial_no_create_type") and attributes.x_serial_no_create_type eq 1>
                                    alert("<cfoutput>#k#</cfoutput> seri no sistemde kullanılmaktadır! Aynı seri ile giriş yapamazsınız! Ay ve Yıl Değerlerini Tekrar Seçip Kaydediniz !");
                                <cfelse>	
                                    alert("<cfoutput>#k#</cfoutput> seri no sistemde kullanılmaktadır! Aynı seri ile giriş yapamazsınız!");
                                </cfif>
                                history.back();
                            </script>
                            <cfabort>
                        </cfif>
                    </cfif>
				<cfelseif listfindnocase('81,811,113',attributes.process_cat,',')>
					<cfquery name="get_seri_kontrol" dbtype="query" maxrows="1"><!--- sevk isleminde alis var mi?--->
                        SELECT
                            IN_OUT
                        FROM 
                            get_seri_kontrol_all
                        WHERE 
                            (SERIAL_NO = '#ucase(k)#' OR SERIAL_NO= '#lcase(k)#') AND 
                            STOCK_ID = #attributes.stock_id#
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
                        ORDER BY 
                            GUARANTY_ID DESC
					</cfquery>
            		<cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                        <cfloop list="#attributes.x_serino_control_out#" index="cc">
                            <cfif listfind("81,811,113",cc)>
                                <cfset is_control_0 = 1>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("is_control_0")>
                            <cfif (get_seri_kontrol.recordcount EQ 1 and get_seri_kontrol.in_out eq 0) or (not get_seri_kontrol.RECORDCOUNT)>
                                <script type="text/javascript">
                                    alert("<cfoutput>#k#</cfoutput> seri no sistemde bulunamadı! Giriş olmayan serinin çıkışını yapamazsınız!");
                                    history.back();
                                </script>
                                <cfabort>
                            </cfif>
                        </cfif>
                     <cfelse>
                     	<cfif (get_seri_kontrol.recordcount EQ 1 and get_seri_kontrol.in_out eq 0) or (not get_seri_kontrol.RECORDCOUNT)>
							<script type="text/javascript">
								alert("<cfoutput>#k#</cfoutput> seri no sistemde bulunamadı! Giriş olmayan serinin çıkışını yapamazsınız!");
								history.back();
							</script>
							<cfabort>
						</cfif>
                     </cfif>
				<cfelseif listfindnocase('70,71,72,78,79,83,88,111',attributes.process_cat,',')>
					<cfquery name="get_seri_kontrol" dbtype="query"><!--- satis isleminde alis var mi?--->
						SELECT 
							GUARANTY_ID,DEPARTMENT_ID,LOCATION_ID
						FROM 
							get_seri_kontrol_all
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' OR SERIAL_NO2 = '#ucase(k)#' OR SERIAL_NO2 = '#lcase(k)#' ) AND 
							STOCK_ID = #attributes.stock_id#
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
					</cfquery>
                    <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                        <cfloop list="#attributes.x_serino_control_out#" index="cc">
							<cfif listfind("70,71,72,78,79,83,88,111",cc)>
								<cfset is_control_6 = 1>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("is_control_6")>
							<cfif not get_seri_kontrol.recordcount>
                                <script type="text/javascript">
                                    alert('<cfoutput>#k#</cfoutput> seri no sistemde bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!');
                                    history.back();
                                </script>
                                <cfabort>
                            </cfif>
                         </cfif>
                    <cfelse>
                    	<cfif not get_seri_kontrol.recordcount>
							<script type="text/javascript">
                                alert('<cfoutput>#k#</cfoutput> seri no sistemde bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!');
                                history.back();
                            </script>
                            <cfabort>
                        </cfif>
                    </cfif>
					<cfquery name="get_seri_kontrol_satis" dbtype="query" maxrows="1"><!--- satis isleminde satis var mi?--->
						SELECT 
							IN_OUT 
						FROM 
							get_seri_kontrol_all 
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id#
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
						ORDER 
							BY GUARANTY_ID DESC
					</cfquery>
                    <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                        <cfloop list="#attributes.x_serino_control_out#" index="cc">
							<cfif listfind("70,71,72,78,79,83,88,111",cc)>
								<cfset is_control_7 = 1>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("is_control_7")>
							<cfif get_seri_kontrol_satis.in_out neq 1>
                                <script type="text/javascript">
                                    alert('<cfoutput>#k#</cfoutput> seri no satılamaz durumda!\nSeri ile ilgili işlemleri kontrol ediniz!');
                                    history.back();
                                </script>
                                <cfabort>
                            </cfif>
                         </cfif>
                     <cfelse>
                     	<cfif get_seri_kontrol_satis.in_out neq 1>
							<script type="text/javascript">
                                alert('<cfoutput>#k#</cfoutput> seri no satılamaz durumda!\nSeri ile ilgili işlemleri kontrol ediniz!');
                                history.back();
                            </script>
                            <cfabort>
                        </cfif>
                     </cfif>
				<cfelseif listfindnocase('73,74,75',attributes.process_cat,',')><!--- satis donenler --->
					<cfquery name="get_seri_kontrol" dbtype="query" maxrows="1"><!--- satis donus isleminde satis var mi?--->
						SELECT 
							IN_OUT,
							IS_PURCHASE
						FROM 
							get_seri_kontrol_all 
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id#
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
						ORDER BY GUARANTY_ID DESC
					</cfquery>
                    <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                        <cfloop list="#attributes.x_serino_control_out#" index="cc">
							<cfif listfind("73,74,75",cc)>
								<cfset is_control_8 = 1>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("is_control_8")>
							<cfif not get_seri_kontrol.recordcount or (get_seri_kontrol.recordcount and get_seri_kontrol.in_out eq 1)>
                                <script type="text/javascript">
                                    alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün satış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
                                    history.back();
                                </script> 
                                <cfabort>
                            </cfif>
                        </cfif>
                    <cfelse>
						<cfif not get_seri_kontrol.recordcount or (get_seri_kontrol.recordcount and get_seri_kontrol.in_out eq 1)>
                            <script type="text/javascript">
                                alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün satış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
                                history.back();
                            </script> 
                            <cfabort>
                        </cfif>
                    </cfif>
				<cfelseif listfindnocase('78,79',attributes.process_cat,',')><!--- alis donenler --->
					<cfquery name="get_seri_kontrol" dbtype="query" maxrows="1"><!--- satis alim donus isleminde satis var mi?--->
						SELECT 
							IN_OUT,
							IS_PURCHASE
						FROM 
							get_seri_kontrol_all 
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id#
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
						ORDER BY GUARANTY_ID DESC
					</cfquery>
                    <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                        <cfloop list="#attributes.x_serino_control_out#" index="cc">
                            <cfif listfind("78,79",cc)>
                                <cfset is_control_9 = 1>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("is_control_9")>
                        	<cfif not get_seri_kontrol.recordcount or (get_seri_kontrol.recordcount and (get_seri_kontrol.in_out neq 1 or get_seri_kontrol.IS_PURCHASE eq 0))>
								<script type="text/javascript">
                                    alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün alış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
                                    history.back();
                                </script> 
                                <cfabort>
                            </cfif>
                        </cfif>
                    <cfelse>
						<cfif not get_seri_kontrol.recordcount or (get_seri_kontrol.recordcount and (get_seri_kontrol.in_out neq 1 or get_seri_kontrol.IS_PURCHASE eq 0))>
                            <script type="text/javascript">
                                alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı veya ürün alış durumu uygun değil!\nKoşulları Kontrol Ediniz!");
                                history.back();
                            </script> 
                            <cfabort>
                        </cfif>
                    </cfif>
				<cfelseif listfindnocase('111,112,113,117',attributes.process_cat,',')><!--- fis islemleri --->
					<cfquery name="get_seri_kontrol" dbtype="query" maxrows="1">
						SELECT  IN_OUT
						FROM 
							get_seri_kontrol_all 
						WHERE 
							(SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' OR SERIAL_NO2 = '#ucase(k)#' OR SERIAL_NO2 = '#lcase(k)#') AND  
							STOCK_ID = #attributes.stock_id# 
							<!---AND
							PROCESS_CAT IN (76,77,82,84,1190,86,113,115,811,171,81)--->
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
						order by GUARANTY_ID DESC
					</cfquery>
                    <cfif isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out)>
                        <cfloop list="#attributes.x_serino_control_out#" index="cc">
                            <cfif listfind("111,112,113,117",cc)>
                                <cfset is_control_10 = 1>
                            </cfif>
                        </cfloop>
                        <cfif isdefined("is_control_10")>
                        	<cfif get_seri_kontrol.in_out neq 1>
								<script type="text/javascript">
                                    alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\nAlışı olmayan seriye işlem yapamazsınız!");
                                    history.back();
                                </script> 
                                <cfabort>
                            </cfif>
                        </cfif>
                    <cfelse>
						<cfif get_seri_kontrol.in_out neq 1>
                            <script type="text/javascript">
                                alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\nAlışı olmayan seriye işlem yapamazsınız!");
                                history.back();
                            </script> 
                            <cfabort>
                        </cfif>
                    </cfif>
				<cfelseif listfindnocase('86',attributes.process_cat,',')><!--- ureticiden giris islemleri --->
				<cfelseif listfindnocase('85',attributes.process_cat,',')><!--- ureticiye cikis islemleri --->	
					<cfquery name="get_seri_kontrol" dbtype="query">
						SELECT 
							GUARANTY_ID 
						FROM 
							get_seri_kontrol_all 
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id# AND
							PROCESS_CAT IN (76,77,82,84,1190,86)
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
					</cfquery>
                	<cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,85)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
						<cfif not get_seri_kontrol.recordcount>
                            <script type="text/javascript">
                                alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\nAlışı olmayan seriye işlem yapamazsınız!");
                                history.back();
                            </script> 
                            <cfabort>
                        </cfif>
                    </cfif>
					<cfquery name="get_seri_kontrol_son_durum" dbtype="query" maxrows="1">
						SELECT 
							IN_OUT,
							IS_SERVICE,
							IS_PURCHASE,
							PROCESS_CAT
						FROM 
							get_seri_kontrol_all 
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id#
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
						ORDER BY GUARANTY_ID DESC
					</cfquery>
                	<cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,85)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
						<cfif not (get_seri_kontrol_son_durum.IN_OUT eq 1 or get_seri_kontrol_son_durum.IS_SERVICE eq 1)>
                            <script type="text/javascript">
                                alert("<cfoutput>#k#</cfoutput> seri no'lu ürün üreticiye gönderilemez!\Seri adımlarını kontrol ediniz!");
                                history.back();
                            </script> 
                            <cfabort>
                        </cfif>
                    </cfif>
				<cfelseif listfindnocase('140',attributes.process_cat,',')><!--- servis giris islemleri --->
					<cfquery name="get_seri_kontrol" dbtype="query" maxrows="1">
						SELECT 
							GUARANTY_ID 
						FROM 
							get_seri_kontrol_all 
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id# AND
							PROCESS_CAT IN (70,71,72,78,79,83,88,111)
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
						ORDER BY
							GUARANTY_ID DESC
					</cfquery>
					<cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,140)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
						<cfif not get_seri_kontrol.recordcount>
                            <script type="text/javascript">
                                alert("<cfoutput>#k#</cfoutput> seri no'lu ürün bulunamadı!\Satışı olmayan seriye servis giriş işlemi yapamazsınız!");
                                history.back();
                            </script> 
                            <cfabort>
                        </cfif>
                    </cfif>
					<cfquery name="get_seri_kontrol_giris" dbtype="query"><!--- servis cikis isleminde alis var mi?--->
						SELECT 
							PROCESS_CAT 
						FROM 
							get_seri_kontrol_all 
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id# AND
							PROCESS_CAT = 140
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
						ORDER BY
							GUARANTY_ID DESC
					</cfquery>
					<cfquery name="get_seri_kontrol_cikis" dbtype="query"><!--- servis cikis isleminde alis var mi?--->
						SELECT 
							PROCESS_CAT 
						FROM 
							get_seri_kontrol_all 
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id#
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
						ORDER BY
							GUARANTY_ID DESC
					</cfquery>
					<cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,140)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
						<cfif get_seri_kontrol_giris.recordcount and get_seri_kontrol_cikis.process_cat neq 141>
                            <script type="text/javascript">
                                alert('<cfoutput>#k#</cfoutput> seri no Serviste görünüyor.!\nTekrar Giriş yapamazsınız!');
                                history.back();
                            </script>
                            <cfabort>
                        </cfif>	
                    </cfif>										
				<cfelseif listfindnocase('141',attributes.process_cat,',')><!--- servis cikis islemleri --->
					<cfquery name="get_seri_kontrol" dbtype="query" maxrows="1"><!--- servis cikis isleminde alis var mi?--->
						SELECT 
							GUARANTY_ID 
						FROM 
							get_seri_kontrol_all 
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id# AND
							PROCESS_CAT IN (73,74,75,76,77,80,81,82,84,86,110,114,140,811,1190)
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
						ORDER BY
							GUARANTY_ID DESC
					</cfquery>
					<cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,141)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
						<cfif not get_seri_kontrol.recordcount>
                            <script type="text/javascript">
                                alert('<cfoutput>#k#</cfoutput> seri no sistemde bulunamadı!\nGiriş olmayan serinin çıkışını yapamazsınız!');
                                history.back();
                            </script>
                            <cfabort>
                        </cfif>	
                    </cfif>
					<cfquery name="get_seri_kontrol_son" dbtype="query"><!--- servis cikis isleminde alis var mi?--->
						SELECT 
							PROCESS_CAT 
						FROM 
							get_seri_kontrol_all 
						WHERE 
							( SERIAL_NO = '#ucase(k)#' OR SERIAL_NO = '#lcase(k)#' OR SERIAL_NO = '#k#' ) AND 
							STOCK_ID = #attributes.stock_id#
                            <cfif get_our_company_info.is_serial_control_location eq 1>
                                AND DEPARTMENT_ID = #attributes.department_id#
                                AND LOCATION_ID = #attributes.location_id#
                            </cfif>
						ORDER BY
							GUARANTY_ID DESC
					</cfquery>
					<cfif (isdefined("attributes.x_serino_control_out") and len(attributes.x_serino_control_out) and listfind(attributes.x_serino_control_out,141)) or (not isdefined("attributes.x_serino_control_out")) or (isdefined("attributes.x_serino_control_out") and not len(attributes.x_serino_control_out))>
						<cfif get_seri_kontrol_son.PROCESS_CAT eq 141>
                            <script type="text/javascript">
                                alert('<cfoutput>#k#</cfoutput> seri no için çıkış yapılmış!\nTekrar Çıkış yapamazsınız!');
                                history.back();
                            </script>
                            <cfabort>
                        </cfif>	
                    </cfif> 
			</cfif>
		</cfif>
		<!--- session da seri kontrol yapilmasi parametresi gelmezse buraya girmez --->
	</cfloop>
</cfif>

<!--- //alış-satış kontrolü --->
<cfif isdefined("attributes.guarantycat_id") and len(attributes.guarantycat_id)>
    <cfquery name="get_guaranty_time_" datasource="#dsn3#">
        SELECT (SELECT GUARANTYCAT_TIME FROM #dsn_alias#.SETUP_GUARANTYCAT_TIME SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME FROM  #dsn_alias#.SETUP_GUARANTY SETUP_GUARANTY WHERE GUARANTYCAT_ID = #attributes.guarantycat_id# AND 1 = 0
    </cfquery>
</cfif>
<cfset temp_start_date = attributes.start_date>
<cfif isdate(temp_start_date) and isdefined("get_guaranty_time_.GUARANTYCAT_TIME") and len(get_guaranty_time_.GUARANTYCAT_TIME)>
	<cf_date tarih="temp_start_date">
	<cfset temp_date = date_add("m", get_guaranty_time_.GUARANTYCAT_TIME, temp_start_date)>
</cfif>

<cfif attributes.method eq 3>
	<cfif isdefined("attributes.amount_2") and len(attributes.amount_2) and attributes.select_unit eq 2>
		<cfset satir_sayisi = attributes.amount_2>
		<cfset unit_row_quantity = attributes.range_number / attributes.amount_2>
		
		<cfquery name="get_total_quantity" datasource="#dsn3#">
			SELECT SUM(UNIT_ROW_QUANTITY) AS QUANTITY FROM SERVICE_GUARANTY_NEW WHERE STOCK_ID = #attributes.stock_id# and PROCESS_ID = #attributes.process_id#
		</cfquery>
		<cfif get_total_quantity.recordcount and len(get_total_quantity.QUANTITY)>
			<cfset unit_row_quantity = attributes.range_number - get_total_quantity.QUANTITY>
			<cfset unit_row_quantity = unit_row_quantity / attributes.amount_2>
		</cfif>
	<cfelse>
		<cfset satir_sayisi = attributes.amount>
	</cfif>
	<cfif satir_sayisi lt 1><cfset satir_sayisi = 1></cfif>
<cfelse>
	<cfset satir_sayisi = listlen(list_numbers)>
</cfif>
<cfset attributes.row_rma_no1 = ''>
<cfif not len(attributes.rma_no)>
	<cfset attributes.rma_no = '*_*'>
</cfif>

<cfset attributes.ref_no1 = ''>
<cfif isdefined("reference_numbers")>
	<cfset attributes.ref_no1 = reference_numbers>
<cfelse>
	<cfset attributes.ref_no1 = '*_*'>
</cfif>

<cfif listlen(attributes.ref_no1) lt satir_sayisi>
	<cfloop from="#listlen(attributes.ref_no1)#" to="#satir_sayisi#" index="mck">
		<cfset attributes.ref_no1 = listappend(attributes.ref_no1,'*_*')>
	</cfloop>
</cfif>

<cfif not isdefined("attributes.row_lot_no1")><!--- filedan lot_no gelmiyor ise --->
	<cfset attributes.row_lot_no1 = ''>
	<cfif not len(attributes.lot_no)>
		<cfset attributes.lot_no = '*_*'>
	</cfif>
	
	<cfloop from="1" to="#satir_sayisi#" index="mck"> <!--- lot ve rmalar otomnatik uretilir --->
		<cfset attributes.row_lot_no1 = listappend(attributes.row_lot_no1,attributes.lot_no,',')>
		<cfset attributes.row_rma_no1 = listappend(attributes.row_rma_no1,attributes.rma_no,',')>
	</cfloop>
<cfelse>
	<cfloop from="1" to="#satir_sayisi#" index="mck"> <!--- rmalar otomnatik uretilir lotlar dosyadan gelir--->
		<cfset attributes.row_rma_no1 = listappend(attributes.row_rma_no1,attributes.rma_no,',')>
	</cfloop>
</cfif>

<cfif listlen(attributes.row_lot_no1) lt satir_sayisi>
	<cfloop from="#listlen(attributes.row_lot_no1)#" to="#satir_sayisi#" index="mck">
		<cfset attributes.row_lot_no1 = listappend(attributes.row_lot_no1,'*_*')>
	</cfloop>
</cfif>
<cfif isdefined("attributes.unit_row_quantity1") and listlen(attributes.unit_row_quantity1) lt satir_sayisi>
	<cfloop from="#listlen(attributes.unit_row_quantity1)#" to="#satir_sayisi#" index="mck">
		<cfset attributes.unit_row_quantity1 = listappend(attributes.unit_row_quantity1,'*_*')>
	</cfloop>
</cfif>


<cfset attributes.serial_no_start_number1 = ''>
<cfif attributes.method eq 3 and not listlen(list_numbers)>
	<cfloop from="1" to="#satir_sayisi#" index="mck">
		<cfset attributes.serial_no_start_number1 = listappend(attributes.serial_no_start_number1,'---',',')>
	</cfloop>
<cfelse>
	<cfset attributes.serial_no_start_number1 = list_numbers>
</cfif>
<cfif isdefined("attributes.x_is_quantity_control") and attributes.x_is_quantity_control eq 1>
	<cfif isdefined("attributes.amount") and isdefined("attributes.serial_no_start_number1")>
        <cfif listlen(attributes.serial_no_start_number1) gt attributes.amount>
            <script type="text/javascript">
                alert('Toplam Miktar Sayısından Fazla Kayıt Girmeye Çalışıyorsunuz!');
                history.back();
            </script>
            <cfabort>
        </cfif>
    </cfif>
</cfif>

<cfset attributes.guaranty_cat1 = attributes.guarantycat_id>
<cfif attributes.take_get eq 1>
	<cfset attributes.guaranty_purchasesales1 = 1>
<cfelse>
	<cfset attributes.guaranty_purchasesales1 = 0>
</cfif>
<cfset attributes.guaranty_startdate1 = attributes.start_date>
<cfset attributes.stock_id1 = attributes.stock_id>
    <cfif listfind("81,811,113",attributes.process_cat)>
    	<cfscript>
			add_serial_no
			(
			session_row : 1,
			wrk_row_id : attributes.wrk_row_id, 
			process_type : attributes.process_cat, 
			process_number : attributes.process_number,
			process_id : attributes.process_id,
			dpt_id : attributes.department_id,
			loc_id : attributes.location_id,
			par_id : attributes.partner_id,
			con_id : attributes.consumer_id,
			main_stock_id : attributes.main_stock_id,
			spect_id : attributes.spect_id,
			comp_id : attributes.company_id,
			is_in_out : 0,
			unit : select_unit,
			unit_row_quantity : unit_row_quantity
			)
			;
		</cfscript>
        <cfif (isdefined("attributes.is_delivered") and attributes.is_delivered eq 1) or (isdefined("attributes.is_delivered") and not len(attributes.is_delivered))>
        	<cfscript>
				add_serial_no
				(
				session_row : 1,
				wrk_row_id : attributes.wrk_row_id, 
				process_type : attributes.process_cat, 
				process_number : attributes.process_number,
				process_id : attributes.process_id,
				dpt_id : attributes.department_id2,
				loc_id : attributes.location_id2,
				par_id : attributes.partner_id,
				con_id : attributes.consumer_id,
				main_stock_id : attributes.main_stock_id,
				spect_id : attributes.spect_id,
				comp_id : attributes.company_id,
				is_in_out : 1,
				unit : select_unit,
				unit_row_quantity : unit_row_quantity
				)
				;
			</cfscript>
        </cfif>
    <cfelseif listfind("116",attributes.process_cat)>
    	<cfscript> 
			 add_serial_no
            (
				session_row : 1,
				wrk_row_id : attributes.wrk_row_id, 
				process_type : attributes.process_cat, 
				process_number : attributes.process_number,
				process_id : attributes.process_id,
				dpt_id : attributes.department_id,
				loc_id : attributes.location_id,
				par_id : attributes.partner_id,
				con_id : attributes.consumer_id,
				main_stock_id : attributes.main_stock_id,
				spect_id : attributes.spect_id,
				comp_id : attributes.company_id,
				is_in_out : 1,
				unit : select_unit,
				unit_row_quantity : unit_row_quantity
				);
			</cfscript>
	<cfelseif listfind("111,112",attributes.process_cat)>
		<cfscript> 
				add_serial_no
			(
				session_row : 1,
				wrk_row_id : attributes.wrk_row_id, 
				process_type : attributes.process_cat, 
				process_number : attributes.process_number,
				process_id : attributes.process_id,
				dpt_id : attributes.department_id,
				loc_id : attributes.location_id,
				par_id : attributes.partner_id,
				con_id : attributes.consumer_id,
				main_stock_id : attributes.main_stock_id,
				spect_id : attributes.spect_id,
				comp_id : attributes.company_id,
				is_in_out : 1,
				unit : select_unit,
				unit_row_quantity : unit_row_quantity
				);
			</cfscript>
    <cfelse>
		<cfscript>
            add_serial_no
            (
            session_row : 1,
            wrk_row_id : attributes.wrk_row_id, 
            process_type : attributes.process_cat, 
            process_number : attributes.process_number,
            process_id : attributes.process_id,
            dpt_id : attributes.department_id,
            loc_id : attributes.location_id,
            par_id : attributes.partner_id,
            con_id : attributes.consumer_id,
            main_stock_id : attributes.main_stock_id,
            spect_id : attributes.spect_id,
            comp_id : attributes.company_id,
			unit : select_unit,
			unit_row_quantity : unit_row_quantity
            );
        </cfscript>
    </cfif>
<cfif listfindnocase('171,76,74,73,114',attributes.process_cat,',') and len(attributes.ship_seri_baslangic)><!--- listfindnocase('110,76,77,82,84,114,171',attributes.process_cat,',') --->
	<cfset son_seri = attributes.ship_seri_baslangic + listlen(attributes.serial_no_start_number1) - 1>
	<cfquery datasource="#dsn3#" name="upd_">
		UPDATE STOCKS SET SERIAL_BARCOD = #son_seri# WHERE STOCK_ID = #attributes.stock_id#
	</cfquery>
</cfif>
<cfif isdefined("attributes.is_store") and attributes.is_store eq 1>
	<cfset store_kontrol = 1>
<cfelse>
	<cfset store_kontrol = 0>
</cfif>
<cfif not isdefined("attributes.order_type_")>
<script type="text/javascript">
	wrk_opener_reload();
</script>
</cfif>
<cfinclude template="../query/get_serial_info.cfm">
<cfsavecontent variable="url_">
<cfoutput>
#request.self#?fuseaction=stock.list_serial_operations&event=det<cfif isdefined("attributes.is_delivered")>&is_delivered=#attributes.is_delivered#</cfif><cfif isdefined("attributes.department_id2")>&dept_id2=#attributes.department_id2#&loc_id2=#attributes.location_id2#</cfif><cfif isdefined("attributes.is_line")>&is_line=1</cfif>&wrk_row_id=#attributes.wrk_row_id#&main_stock_id=#attributes.main_stock_id#<cfif isdefined("attributes.select_unit")>&#attributes.select_unit#</cfif><cfif isdefined("attributes.product_amount_2")>&product_amount_2=#attributes.product_amount_2#</cfif>&product_amount=#attributes.product_amount#&recorded_count=#GET_SERIAL_INFO.RecordCount#&product_id=#attributes.product_id#&stock_id=#attributes.stock_id#&process_number=#URLEncodedFormat(attributes.process_number)#&process_cat=#attributes.process_cat#&process_id=#attributes.process_id#&sale_product=#attributes.take_get#&par_id=#attributes.partner_id#&company_id=#attributes.company_id#&con_id=#attributes.consumer_id#&loc_id=#attributes.location_id#&dept_id=#attributes.department_id#&guaranty_startdate=#attributes.start_date#&guaranty_cat=#attributes.guarantycat_id#&department_id=&guaranty_method=#attributes.method#&spect_id=#attributes.spect_id#&is_store=#store_kontrol#&reload=1&process_date=#attributes.process_date#
</cfoutput>
</cfsavecontent>
<cfif not isdefined("is_generate_serial_nos")>
<cflocation url="#url_#" addtoken="no">
</cfif>