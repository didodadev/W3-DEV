<!--- TolgaS 20070207 devir fislerinde stok yaşını düzenlemek icin yazıldı
secilen kaynak dönemden hedef döneme stok yaşlarını hesaplayarak atıyor
******dikkaattttt : rapor şimdilik genel stok yaşına göre (departmana bakmadan) stok yaşı hesaplayarak stok devir fişlerinde düzenliyor 
departman lı olarakda yazıldı sayfa ancak parametrenin formlarda tanımlı olması lazım
 --->
<script type="text/javascript">
	function basamak_1()
	{
		if(document.form_transfer.transfer_type[0].checked==true)
		{
			if(document.form_transfer.kaynak_period_1.value=='')
			{
				alert("<cf_get_lang no ='2064.Kaynak Dönem Secmelisiniz'>!");
				return false;
			}
			if(document.form_transfer.hedef_period_1.value=='')
			{
				alert("<cf_get_lang no ='2075.Hedef Dönem Secmelisiniz'>!");
				return false;
			}
		}
		else
		{
			if(document.form_transfer.hedef_period_1.value=='')
			{
				alert("<cf_get_lang no ='2075.Hedef Dönem Secmelisiniz'>!");
				return false;
			}		
		}
		if(confirm("<cf_get_lang no ='2097.Stok Yaşları Aktarım İşlemi Yapacaksınız!! Bu İşlem Geri Alınamaz!!! Emin misiniz'>?"))
			document.form_transfer.submit();
		else 
			return false;
	}	
	function basamak_2()
	{
		if(confirm("<cf_get_lang no ='2097.Stok Yaşları Aktarım İşlemi Yapacaksınız!! Bu İşlem Geri Alınamaz!!! Emin misiniz'>?"))
			document.form_transfer_2.submit();
		else 
			return false;
	}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.from_cmp") and len(attributes.from_cmp))>
			var company_id = document.getElementById('from_cmp').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'kaynak_period_1',1,'Dönemler');
		</cfif>
	}
	)
	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('from_cmp').value != '')
			{
				var company_id = document.getElementById('from_cmp').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'kaynak_period_1',1,'Dönemler');
			}
		}
		else if(number == 2)
		{
			if(document.getElementById('to_cmp').value != '')
			{
				var company_id = document.getElementById('to_cmp').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
			}
		}
	}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.to_cmp") and len(attributes.to_cmp))>
			var company_id = document.getElementById('to_cmp').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
		</cfif>
		}
	)
</script>
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfparam name="attributes.fis_date" default="">
<cfif isdate(attributes.fis_date)>
	<cfset attributes.fis_date = dateformat(attributes.fis_date, dateformat_style)>
</cfif>
<cfif not isdefined("attributes.hedef_period")>
	<cfsavecontent variable = "title">
		<cf_get_lang no ='1564.Stok Yaşı Aktarım'>
	</cfsavecontent>
	<cf_form_box title="#title#">
		<cf_area width="50%">
			<cfform name="form_transfer" method="post"action="">
				<table>
					<tr>
						<td><cf_get_lang no ='2096.Aktarım Yöntemi'></td>
						<td><cf_get_lang no ='2095.Dönemlerden'>:</td>
						<td><input type="radio" name="transfer_type" id="transfer_type" value="1" <cfif not isdefined("attributes.transfer_type") or attributes.transfer_type eq 1>checked</cfif> onclick="goster_type();"></td>
						<tr>
							<td></td>
							<td><cf_get_lang no ='2094.Dosyadan'>:</td>
							<td>
								<input type="radio" name="transfer_type" id="transfer_type" value="2" <cfif isdefined("attributes.transfer_type") and attributes.transfer_type eq 2>checked</cfif> onclick="goster_type();">
							</td>
						</tr>
					</tr>
					<tr>
						<td></br></td>
						<tr id="transfer_type_2_a" style="display:none">
							<td><cf_get_lang no ='2093.Fiş Tipi'></td>
							<td><cf_get_lang no ='2092.Devir Fişleri'>:</td>
							<td><input type="radio" name="fis_type" id="fis_type" value="114" <cfif not isdefined("attributes.fis_type") or attributes.fis_type eq 114>checked</cfif>></td>
							<tr id="transfer_type_2_a_2" style="display:none">
								<td></td>
								<td><cf_get_lang no ='2091.Sayım Fişleri'>:</td>
									<td><input type="radio" name="fis_type" id="fis_type" value="115" <cfif isdefined("attributes.fis_type") and attributes.fis_type eq 115>checked</cfif>>
								</td>
							</tr>
						</tr>
					</tr>
					<tr id="transfer_type_1_a">
						<td><cf_get_lang no ='1784.Kaynak Dönem'></td>
						<td > 
							<select name="from_cmp" id="from_cmp" onchange="show_periods_departments(1)">
								<cfoutput query="get_companies">
									<option value="#COMP_ID#" <cfif isdefined("attributes.from_cmp") and attributes.from_cmp eq COMP_ID>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
								</cfoutput>
							</select>
						</td>
						<td>
							<div id="source_div">
								<select name="kaynak_period_1" id="kaynak_period_1" >
									<cfif isdefined("attributes.from_cmp") and len(attributes.from_cmp)>
										<cfquery name="get_periods" datasource="#dsn#">
											SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #attributes.from_cmp# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
										</cfquery>
										<cfoutput query="get_periods">				
											<option value="#period_id#" <cfif isdefined("attributes.kaynak_period_1") and attributes.kaynak_period_1 eq period_id>selected</cfif>>#period#</option>						
										</cfoutput>
									</cfif>
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no ='1277.Hedef Dönem'></td>
						<td>
							<select name="to_cmp" id="to_cmp" onchange="show_periods_departments(2)">
								<cfoutput query="get_companies">
									<option value="#comp_id#" <cfif isdefined("attributes.to_cmp") and attributes.to_cmp eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
								</cfoutput>
							</select>
						</td>
						<td>
							<div id="target_div">
								 <select name="hedef_period_1" id="hedef_period_1" >
									<cfif isdefined("attributes.to_cmp") and len(attributes.to_cmp)>
										<cfoutput query="get_periods">				
											<option value="#period_id#" <cfif isdefined("attributes.hedef_period_1") and attributes.hedef_period_1 eq period_id>selected</cfif>>#period#</option>						
										</cfoutput>
									</cfif>
								 </select>
							</div>
						</td>
					</tr>
					<tr id="transfer_type_2_b" style="display:none">
						<td><cf_get_lang_main no ='279.Dosya'></td>
						<td><input type="file" name="transfer_file" id="transfer_file" value=""></td>
					</tr>
					<tr id="transfer_type_2_c" style="display:none">
						<td><cf_get_lang_main no='1182.Format'></td>
						<td colspan="3"><br/><cf_get_lang no ='2088.Stok Kodu;Yaş (gün olarak)'> &nbsp; <cf_get_lang no ='2089.olacaktır'><br/> <cf_get_lang no ='2090.Dil formatı UTF-8 olacak ve ilk satırda kolon adları olmalıdır'>
					</tr>
					<tr>
						<td><cf_get_lang no ='2087.Fişlerdeki Departmana Baksın'></td>
						<td><input type="checkbox" name="department" id="department" value="1" <cfif isdefined('attributes.department') and len(attributes.department)>checked</cfif>> </td>
					</tr>
					<tr id="transfer_type_2_d" style="display:none">
						<td><cf_get_lang_main no ='160.Departman'></td>
						<td>
							<input type="text" name="dep_name" id="dep_name" value="<cfif isdefined('attributes.dep_name') and len(attributes.dep_name) and len(attributes.dep_id)><cfoutput>#attributes.dep_name#</cfoutput></cfif>">
							<input type="hidden" name="dep_id" id="dep_id" value="<cfif isdefined('attributes.dep_name') and len(attributes.dep_name) and len(attributes.dep_id)><cfoutput>#attributes.dep_id#</cfoutput></cfif>">
							<input type="hidden" name="loc_id" id="loc_id" value="<cfif isdefined('attributes.dep_name') and len(attributes.dep_name) and len(attributes.loc_id)><cfoutput>#attributes.loc_id#</cfoutput></cfif>">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=form_transfer&field_name=dep_name&field_id=dep_id&field_location_id=loc_id','list')" ><img src="/images/plus_thin.gif" alt="<cf_get_lang no='168.seçiniz'>" border="0" align="absmiddle"></a>
						</td>
					</tr>
					<tr id="transfer_type_1_b">
						<td><cf_get_lang no ='2086.Devir Yapılmışları Devretmesin'></td>
						<td colspan="4"><input type="checkbox" name="not_transfer" id="not_transfer" value="1" <cfif isdefined('attributes.not_transfer') and len(attributes.not_transfer)>checked</cfif>> </td>
					</tr>
					<tr id="transfer_type_2_e" style="display:none">
						<td><cf_get_lang no ='2085.Sayım Fişi Tarihi'></td>
						<td colspan="4">
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
							<input value="<cfoutput>#attributes.fis_date#</cfoutput>" type="text" name="fis_date" id="fis_date" validate="#validate_style#">
							<cf_wrk_date_image date_field="fis_date">
						</td>
					</tr>
					<tr><td><br/></td></tr>
					<tr>
						<td><input type="button" value="<cf_get_lang_main no ='1264.Aktar'>" onClick="basamak_1();"></td>
					</tr>
				</table>
			</cfform>
		</cf_area>
		<cf_area width="50%">
			<table>
					<tr height="30">
						<td class="headbold" valign="top"><cf_get_lang_main no='21.Yardım'></td>
					</tr>    
					<tr>
						<td valign="top"> 
							<cftry>
								<tr>
									<td>
									<font><cf_get_lang no ='2084.Bu İşlem Kaynak Yıla Ait Dönemde Bulunan Stok Yaşlarını Hedef Dönemdeki Stok Devir Fişlerine Aktarmaya Olanak Sağlar'>.</font>
									<br/><br/><font> <cf_get_lang no='2919.Dönemden Aktarımlarda'>;</font>
									<br/><br/><cf_get_lang no='2920.Fişlerdeki Departmana Baksın seçili ise; stok yaşının aktarılacağı fişlerdeki depolara göre hareket edilir'> <br/>
									<cf_get_lang no='2921.Fişteki ürünlerin stok yaşları fişte seçilmiş olan depolardaki işlemlerinden hesaplanır ve depo sevk ,ithal mal girişi ,'> <br/>
									<cf_get_lang no='2925.ambar fişi işlemleri de hesaplamaya katılır'>.
									<br/><br/><cf_get_lang no='2927.Devir Yapılmışları Devretmesin  sadece dönemden aktarımlarda geçerlidir'>. 
									<br/><br/><cf_get_lang no='2929.Devir Yapılmışları Devretmesin  seçili ise hedef dönemde stok yaşı aktarılmış devir fişi satırları için yeniden aktarım yapılmaz'><br/>  <cf_get_lang no='2930.Seçilmediginde tüm devir fişleri için tekrar aktarım yapılır'>
									<br/><br/>
									<font> <cf_get_lang no='2931.Dosyadan Aktarımlarda'>;</font>
									<br/><br/> <cf_get_lang no='2932.Dosya formatı UTF-8 olmalı ve alanlar noktalı virgül (;) ile ayrılmalıdır'>.
									<br/><br/> <cf_get_lang no='2933.Dosyadaki alanlar sırasıyla; Stok Kodu;Yaş (gün olarak)  olmalıdır ve ilk satırda kolon adları olmalıdır'>.
									<br/><br/><cf_get_lang no='2934.Fişlerdeki Departmana Baksın ve Departman seçili ise; seçilen departmandaki (belirtilen fiş tipindeki) fişlere stok yaşı aktarımı yapılır'>.
									</td>
								</tr>
								<!---Yardım Dosya yolu eklenecek--->
								<!---<cfinclude template="#file_web_path#templates/period_help/filename_#session.ep.language#.html">--->
								<cfcatch>
									<script type="text/javascript">
										alert("<cf_get_lang_main no='1963.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
									</script>
								</cfcatch>
							</cftry>
						</td>
					</tr>
				</table>
		</cf_area>
	</cf_form_box>

	<script type="text/javascript">
		goster_type();
		function goster_type()
		{
			if(document.form_transfer.transfer_type[0].checked==true)
			{
				document.getElementById('transfer_type_1_a').style.display='';
				document.getElementById('transfer_type_1_b').style.display='';
				document.getElementById('transfer_type_2_a').style.display='none';
				document.getElementById('transfer_type_2_a_2').style.display='none';
				document.getElementById('transfer_type_2_b').style.display='none';
				document.getElementById('transfer_type_2_c').style.display='none';
				document.getElementById('transfer_type_2_d').style.display='none';
				document.getElementById('transfer_type_2_e').style.display='none';
			}
			else
			{
				document.getElementById('transfer_type_1_a').style.display='none';
				document.getElementById('transfer_type_1_b').style.display='none';
				document.getElementById('transfer_type_2_a').style.display='';
				document.getElementById('transfer_type_2_a_2').style.display='';
				document.getElementById('transfer_type_2_b').style.display='';
				document.getElementById('transfer_type_2_c').style.display='';
				document.getElementById('transfer_type_2_d').style.display='';
				document.getElementById('transfer_type_2_e').style.display='';
			
			}
		}
	</script>
</cfif>
<cfif isdefined("attributes.hedef_period_1") and isdefined("attributes.kaynak_period_1")>
	<cfif not len(attributes.hedef_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2075.Hedef Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfif not len(attributes.kaynak_period_1) and attributes.transfer_type eq 1><!--- dönemden ise kaynak db seçilir --->
		<script type="text/javascript">
			alert("<cf_get_lang no ='2064.Kaynak Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="get_hedef_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_period_1#">
	</cfquery>
	
	<cfif attributes.transfer_type eq 1>
		<cfquery name="get_kaynak_period" datasource="#dsn#">
			SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.kaynak_period_1#">
		</cfquery>
	</cfif>
	<cfif attributes.transfer_type eq 2>
		<cfif not len(attributes.transfer_file)>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1292.Dosya Secmelisiniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
		<cftry>
			<cffile action = "upload" 
					fileField = "transfer_file" 
					destination = "#upload_folder_#"
					nameConflict = "MakeUnique"  
					mode="777" charset="utf-8">
			<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
			<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
			<cfset file_size = cffile.filesize>
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>  
		</cftry>
	</cfif>
	<form action="" name="form_transfer_2" method="post">
		<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#attributes.hedef_period_1#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_year" id="aktarim_hedef_year" value="<cfoutput>#get_hedef_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.OUR_COMPANY_ID#</cfoutput>">
		<cfif isdefined('get_kaynak_period')><!--- dönemden ise kaynak db var --->
			<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
		<cf_get_lang no ='2028.Kaynak Veri Tabanı'> : <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
		<cfelse>
			<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="">
			<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="">
			<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="">
		</cfif>
		<cfif isdefined('attributes.department') and len(attributes.department)><input type="hidden" name="aktarim_department" id="aktarim_department" value="1"></cfif>
		<cfif isdefined('attributes.not_transfer') and len(attributes.not_transfer)><input type="hidden" name="aktarim_not_transfer" id="aktarim_not_transfer" value="1"></cfif>
		<input type="hidden" name="aktarim_transfer_type" id="aktarim_transfer_type" value="<cfoutput>#attributes.transfer_type#</cfoutput>">
		<input type="hidden" name="aktarim_fis_type" id="aktarim_fis_type" value="<cfoutput>#attributes.fis_type#</cfoutput>">
		<input type="hidden" name="aktarim_dep_name" id="aktarim_dep_name" value="<cfoutput>#attributes.dep_name#</cfoutput>">
		<input type="hidden" name="aktarim_dep_id" id="aktarim_dep_id" value="<cfoutput>#attributes.dep_id#</cfoutput>">
		<input type="hidden" name="aktarim_loc_id" id="aktarim_loc_id" value="<cfoutput>#attributes.loc_id#</cfoutput>">
		<input type="hidden" name="aktarim_file_name" id="aktarim_file_name" value="<cfif isdefined('file_name')><cfoutput>#file_name#</cfoutput></cfif>"><!--- dosyaya verilen uuid ismi --->
		<input type="hidden" name="aktarim_fis_date" id="aktarim_fis_date" value="<cfoutput>#attributes.fis_date#</cfoutput>">
		<cf_get_lang no ='2029.Hedef Veri Tabanı'> : <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br/>
		<input type="button" value="<cf_get_lang no ='2027.Aktarımı Başlat'>" onClick="basamak_2();">
	</form>
</cfif>
<cfif isdefined("attributes.aktarim_hedef_period")>
	<cfset hedef_dsn2 = '#dsn#_#attributes.aktarim_hedef_year#_#attributes.aktarim_hedef_company#'>
	<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfset islem_tarihi = CreateDateTime(attributes.aktarim_kaynak_year,12,31,0,0,0)>
	<cfif attributes.aktarim_transfer_type eq 1><!--- donemden aktarılacaksa --->
        <cfquery name="GET_FIS_ROW" datasource="#hedef_dsn2#"><!--- hedef donem devir fisleri --->
                SELECT TOP 1
                    IR.STOCK_ID,
                    I.FIS_DATE,
                    SUM(IR.AMOUNT) AMOUNT
                    <cfif isdefined('attributes.aktarim_department') and len(attributes.aktarim_department)>
                    ,I.DEPARTMENT_IN
                    ,I.LOCATION_IN
                    </cfif>
                FROM
                    STOCK_FIS I,
                    STOCK_FIS_ROW IR
                WHERE
                    I.FIS_ID = IR.FIS_ID AND
                    I.FIS_TYPE=114
                    <cfif isdefined('attributes.aktarim_not_transfer') and len(attributes.aktarim_not_transfer)>
                    AND (IR.DUE_DATE IS NULL OR IR.DUE_DATE=0)
                    </cfif>
                GROUP BY
                    IR.STOCK_ID,
                    I.FIS_DATE
                    <cfif isdefined('attributes.aktarim_department') and len(attributes.aktarim_department)>
                    ,I.DEPARTMENT_IN
                    ,I.LOCATION_IN
                    </cfif>
            </cfquery>
            <cfif not GET_FIS_ROW.recordcount>
				 <script type="text/javascript">
                    alert("Stok Yaşı Aktarabilmek İçin Öncelikle Stok Devri Yapmalısınız !");
                    history.go(-2);
                </script>
            </cfif>
    		<cfquery name="control_table" datasource="#hedef_dsn2#">
              IF EXISTS (select * from tempdb.sys.tables where name='####stock_age_transfer_#session.ep.userid#')
                DROP TABLE  ####stock_age_transfer_#session.ep.userid#
              IF EXISTS (select * from tempdb.sys.tables where name='####stock_age_transfer2_#session.ep.userid#')
                DROP TABLE  ####stock_age_transfer2_#session.ep.userid#
            </cfquery>
            <cfquery name="GET_FIS_ROW1" datasource="#hedef_dsn2#" result="xx">
                    SELECT FIS_ROW.STOCK_ID,
                           FIS_ROW.AMOUNT  AS GENEL_TOPLAM,
                           STOCK_AGE.GUN_FARKI,
                           STOCK_AGE.ISLEM_TARIHI,
                           STOCK_AGE.AMOUNT,
                           ROW_NUMBER() OVER(ORDER BY FIS_ROW.STOCK_ID, STOCK_AGE.ISLEM_TARIHI DESC) AS ROWNUM 
                    INTO ####stock_age_transfer_#session.ep.userid#
                    FROM   (
                                SELECT IR.STOCK_ID,
                                    I.FIS_DATE,
                                    SUM(IR.AMOUNT) AMOUNT
                                    <cfif isdefined('attributes.aktarim_department') and len(attributes.aktarim_department)>
                                        ,I.DEPARTMENT_IN
                                        ,I.LOCATION_IN
                                    </cfif>
                                FROM   
                                    STOCK_FIS I,
                                    STOCK_FIS_ROW IR
                                WHERE  
                                    I.FIS_ID = IR.FIS_ID
                                    AND I.FIS_TYPE = 114
                                    <cfif isdefined('attributes.aktarim_not_transfer') and len(attributes.aktarim_not_transfer)>
                                        AND (IR.DUE_DATE IS NULL OR IR.DUE_DATE=0)
                                    </cfif>
                                GROUP BY
                                    IR.STOCK_ID,
                                    I.FIS_DATE
                                    <cfif isdefined('attributes.aktarim_department') and len(attributes.aktarim_department)>
                                        ,I.DEPARTMENT_IN
                                        ,I.LOCATION_IN
                                    </cfif>
                           )               AS FIS_ROW
                           OUTER APPLY (
                           			 SELECT * FROM
               							(
                                            SELECT IR.STOCK_ID,
                                                   IR.AMOUNT,
                                                   ISNULL(I.DELIVER_DATE, I.SHIP_DATE) AS ISLEM_TARIHI,
                                                   ISNULL(
                                                       DATEDIFF(DAY, I.DELIVER_DATE,#islem_tarihi#),
                                                       DATEDIFF(DAY, I.SHIP_DATE,#islem_tarihi#)
                                                   )         AS GUN_FARKI,
                                                   I.DEPARTMENT_IN,
                                                   I.LOCATION_IN
                                            FROM   #kaynak_dsn2#.SHIP       I,
                                                   #kaynak_dsn2#.SHIP_ROW   IR
                                            WHERE  I.SHIP_ID = IR.SHIP_ID
                                                   AND I.IS_SHIP_IPTAL = 0 AND
                                                   <cfif isdefined('attributes.aktarim_department') and len(attributes.aktarim_department)><!--- depo varsa depolar arası sevk VE ithal mal girisine bak --->
                                                        I.SHIP_TYPE IN (76,81,811,87)
                                                    <cfelse>
                                                        I.SHIP_TYPE IN(76,87)
                                                    </cfif>
                                            UNION ALL
                                            SELECT IR.STOCK_ID,
                                                   IR.AMOUNT,
                                                   I.FIS_DATE   ISLEM_TARIHI,
                                                   DATEDIFF(DAY, I.FIS_DATE, FIS_ROW.FIS_DATE) + ISNULL(IR.DUE_DATE, 0) GUN_FARKI,
                                                   I.DEPARTMENT_IN,
                                                   I.LOCATION_IN
                                            FROM   #kaynak_dsn2#.STOCK_FIS       I,
                                                   #kaynak_dsn2#.STOCK_FIS_ROW   IR
                                            WHERE   I.FIS_ID = IR.FIS_ID AND
                                                   <cfif isdefined('attributes.aktarim_department') and len(attributes.aktarim_department)><!--- depo varsa ambar fisine bak --->
                                                        I.FIS_TYPE IN (110,113,114,115,119)
                                                    <cfelse>
                                                        I.FIS_TYPE IN (110,114,115,119)
                                                    </cfif>
                                        )  AS xxxx
                                       WHERE xxxx.STOCK_ID =FIS_ROW.STOCK_ID
									 <cfif isdefined('attributes.aktarim_department') and len(attributes.aktarim_department)>
                                        AND xxxx.DEPARTMENT_IN =FIS_ROW.DEPARTMENT_IN 
                                        AND xxxx.LOCATION_IN = FIS_ROW.LOCATION_IN
                                    </cfif>	

                                )          
                                AS STOCK_AGE
                    ORDER BY
                           STOCK_ID,
                           ISLEM_TARIHI DESC 
                    ;WITH CTE1 AS 
                    (
                        SELECT 
                            STOCK_ID ,
                            ROWNUM,
                            GUN_FARKI,
                            CASE WHEN GENEL_TOPLAM > AMOUNT THEN GUN_FARKI * AMOUNT 
                                 WHEN GENEL_TOPLAM < AMOUNT THEN  GUN_FARKI END AS AGIRLIKLI_TOPLAM,
                            AMOUNT AS MIKTAR_TOPLAM,
                            GENEL_TOPLAM - AMOUNT AS FARK 
                        FROM 
                            ####stock_age_transfer_#session.ep.userid#
                        WHERE
                            ROWNUM = 1 
                        UNION ALL
                        SELECT 
                            T.STOCK_ID,
                            T.ROWNUM,
                            T.GUN_FARKI,
                            CASE WHEN C.STOCK_ID = T.STOCK_ID THEN C.AGIRLIKLI_TOPLAM + (T.AMOUNT*T.GUN_FARKI) ELSE  T.GUN_FARKI END AS AGIRLIKLI_TOPLAM,
                            CASE WHEN C.STOCK_ID = T.STOCK_ID THEN C.MIKTAR_TOPLAM + T.AMOUNT ELSE  T.AMOUNT END AS AMOUNT_TOPLAM,
                            CASE WHEN  C.STOCK_ID = T.STOCK_ID THEN C.FARK - T.AMOUNT ELSE  T.GENEL_TOPLAM - T.AMOUNT END AS FARK
                        FROM 
                            ####stock_age_transfer_#session.ep.userid# T JOIN CTE1 AS C ON T.ROWNUM = C.ROWNUM+1 
                                          
                    )
                    
                    SELECT * 
                    INTO ####stock_age_transfer2_#session.ep.userid#
                    FROM CTE1  OPTION (MAXRECURSION 0)  
                    
              UPDATE STOCK_FIS_ROW SET DUE_DATE=STOK_AGE 
                 FROM 
                (
                    SELECT 
                            FIS_ROW.STOCK_ID,  
                            CASE WHEN  POSITIVE.AGIRLIKLI_TOPLAM IS NOT NULL AND NEGATIVE.GUN_FARKI IS NOT  NULL THEN 
                                        (POSITIVE.AGIRLIKLI_TOPLAM + (POSITIVE.FARK * ISNULL(NEGATIVE.GUN_FARKI,0))) / #DSN_ALIAS#.IS_ZERO((FIS_ROW.GENEL_TOPLAM),1) 
                                 WHEN POSITIVE.AGIRLIKLI_TOPLAM IS  NULL AND NEGATIVE.GUN_FARKI IS NOT  NULL THEN 
                                        NEGATIVE.GUN_FARKI 
                                 ELSE  
                                    (POSITIVE.AGIRLIKLI_TOPLAM + (POSITIVE.FARK * ISNULL(NEGATIVE.GUN_FARKI,0))) / #DSN_ALIAS#.IS_ZERO((FIS_ROW.GENEL_TOPLAM-POSITIVE.FARK),1) 
                            END AS STOK_AGE
                             <cfif isdefined('attributes.aktarim_department') and len(attributes.aktarim_department)>
                                    ,DEPARTMENT_IN
                                    ,LOCATION_IN
                              </cfif>
                    FROM 
                    
                    (
                               SELECT IR.STOCK_ID,
                                      I.FIS_DATE,
                                      SUM(IR.AMOUNT)  AS GENEL_TOPLAM
                                       <cfif isdefined('attributes.aktarim_department') and len(attributes.aktarim_department)>
                                            ,I.DEPARTMENT_IN
                                            ,I.LOCATION_IN
                                        </cfif>
                               FROM   STOCK_FIS I,
                                      STOCK_FIS_ROW IR
                               WHERE  I.FIS_ID = IR.FIS_ID
                                      AND I.FIS_TYPE = 114
										<cfif isdefined('attributes.aktarim_not_transfer') and len(attributes.aktarim_not_transfer)>
                                            AND (IR.DUE_DATE IS NULL OR IR.DUE_DATE=0)
                                        </cfif>         
                    			GROUP BY
                                      IR.STOCK_ID,
                                      I.FIS_DATE
                                       <cfif isdefined('attributes.aktarim_department') and len(attributes.aktarim_department)>
                                            ,I.DEPARTMENT_IN
                                            ,I.LOCATION_IN
                                        </cfif>
                           )  AS FIS_ROW
                           
                      OUTER APPLY
                    (
                        SELECT TOP 1 *
                        FROM   (
                                   SELECT 
                                        ISNULL(AGIRLIKLI_TOPLAM,0) AS AGIRLIKLI_TOPLAM,
                                        ISNULL(MIKTAR_TOPLAM,0) AS MIKTAR_TOPLAM,
                                        ISNULL(FARK,0) AS  FARK,
                                        GUN_FARKI,
                                        ROWNUM,
                                        STOCK_ID
                                    FROM  ####stock_age_transfer2_#session.ep.userid#
                               ) AS XXX
                        WHERE  STOCK_ID = FIS_ROW.STOCK_ID
                               AND XXX.FARK >= 0
                        ORDER BY
                               XXX.ROWNUM DESC
                    )         AS POSITIVE
                    OUTER APPLY
                    (
                        SELECT TOP 1 *
                        FROM   (
                                  SELECT 
                                        ISNULL(AGIRLIKLI_TOPLAM,0) AS AGIRLIKLI_TOPLAM,
                                        ISNULL(MIKTAR_TOPLAM,0) AS MIKTAR_TOPLAM,
                                        ISNULL(FARK,0) AS  FARK,
                                        GUN_FARKI,
                                        ROWNUM,
                                        STOCK_ID
                                   FROM  ####stock_age_transfer2_#session.ep.userid#
                               ) AS XXX
                        WHERE  STOCK_ID = FIS_ROW.STOCK_ID
                               AND XXX.FARK < 0
                        ORDER BY
                               XXX.ROWNUM ASC
                    )         AS NEGATIVE   
             )  as xxx JOIN STOCK_FIS_ROW ON xxx.STOCK_ID = STOCK_FIS_ROW.STOCK_ID AND STOCK_FIS_ROW.FIS_ID IN 
             (
             	SELECT FIS_ID FROM STOCK_FIS WHERE FIS_TYPE=114
              
              ) 
            </cfquery>           
	<cfelse>
		<!--- dosyadan aktarılacaksa --->
		<cfif len(attributes.aktarim_fis_date)>
			<cf_date tarih="attributes.aktarim_fis_date">
		</cfif>
		<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
		<cfset hedef_dsn3 = '#dsn#_#attributes.aktarim_hedef_company#'>
		<cffile action="read" file="#upload_folder_##aktarim_file_name#" variable="dosya" charset="UTF-8">
		<cfscript>
			CRLF = Chr(13) & Chr(10);// satır atlama karakteri
			dosya = Replace(dosya,';;','; ;','all');
			dosya = Replace(dosya,';;','; ;','all');
			dosya = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya);
			counter = 0;
		</cfscript>
		<cfquery name="GET_STOCK" datasource="#hedef_dsn3#">
			SELECT STOCK_ID,STOCK_CODE FROM STOCKS
		</cfquery>
		<cfscript>
			if(isdefined('attributes.aktarim_department') and len(attributes.aktarim_department))
				where_txt_upd='AND FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS WHERE FIS_TYPE=#attributes.aktarim_fis_type# AND DEPARTMENT_IN = #attributes.aktarim_dep_id# AND LOCATION_IN = #attributes.aktarim_loc_id#';
			else
				where_txt_upd='AND FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS WHERE FIS_TYPE=#attributes.aktarim_fis_type#';
			if(len(attributes.aktarim_fis_date))
				where_txt_upd=where_txt_upd&' AND FIS_DATE = #attributes.aktarim_fis_date#';
			where_txt_upd=where_txt_upd&')';
		</cfscript>
		<cflock name="#createUUID()#" timeout="60">
			<cftransaction>

				<cfloop from="2" to="#line_count#" index="i">
					<cfset j= 1>
					<cfset error_flag = 0>
					<cftry>
						<cfscript>
							counter = counter + 1;
							kolon_1 = Listgetat(dosya[i],j,";");
							kolon_1 =trim(kolon_1);
							j=j+1;

							kolon_2 = Listgetat(dosya[i],j,";");
							kolon_2 = trim(kolon_2);
							j=j+1;
						</cfscript>
					<cfcatch type="Any">
							<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
							<cfset error_flag = 1>
						</cfcatch>
					</cftry>
					<cfscript>
					if(error_flag neq 1 and len(kolon_1) and len(kolon_2))
					{
						sql_txt="SELECT STOCK_ID FROM GET_STOCK WHERE STOCK_CODE='#kolon_1#'";
						GET_STOCK_ID = cfquery(SQLString:sql_txt,Datasource:'',dbtype:"query",is_select:1);
						if(GET_STOCK_ID.RECORDCOUNT)
						{
							sql_txt='UPDATE STOCK_FIS_ROW SET DUE_DATE=#kolon_2# WHERE STOCK_ID=#GET_STOCK_ID.STOCK_ID# #where_txt_upd#';
							UPD_PROD_AGE = cfquery(SQLString:sql_txt,Datasource:hedef_dsn2,dbtype:"",is_select:0);
						}
					}
					</cfscript>
				</cfloop>

			</cftransaction>
		</cflock>
	</cfif>
 	<script type="text/javascript">
		alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmıştır'>!");
		history.go(-2);
	</script>
</cfif>﻿
