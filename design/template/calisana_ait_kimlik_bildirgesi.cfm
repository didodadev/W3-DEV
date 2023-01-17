<!--- Pronet Calisanlara ait Kimlik Bildirme Belgesi 20110919 --->
<cfset attributes.employee_id = attributes.iid>

<cfquery name="get_employee" datasource="#dsn#">
	SELECT
		EMPLOYEES.EMPLOYEE_NAME AD,
		EMPLOYEES.EMPLOYEE_SURNAME SOYAD,
		EMPLOYEES_IDENTY.TC_IDENTY_NO TC_KIMLIK,
		EMPLOYEES_IDENTY.FATHER BABA_ADI,
		EMPLOYEES_IDENTY.MOTHER ANA_ADI,
		EMPLOYEES_IDENTY.BIRTH_PLACE DOGUM_YERI,
		EMPLOYEES_IDENTY.BIRTH_DATE DOGUM_TARIHI,
		EMPLOYEES_IDENTY.MARRIED MEDENI_HALI,
		EMPLOYEES_IDENTY.CITY,
		EMPLOYEES_IDENTY.COUNTY,
		EMPLOYEES_IDENTY.WARD,
		EMPLOYEES_IDENTY.VILLAGE,
		EMPLOYEES_IDENTY.NATIONALITY,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEES_DETAIL.SEX,
		EMPLOYEES_IDENTY.GIVEN_DATE,
		EMPLOYEES_IDENTY.BINDING,
		EMPLOYEES_IDENTY.FAMILY,
		EMPLOYEES_IDENTY.CUE,
		EMPLOYEES_DETAIL.HOMEADDRESS,
		EMPLOYEES.PHOTO,
		EMPLOYEES.PHOTO_SERVER_ID
	FROM 
		EMPLOYEES
		LEFT JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
		LEFT JOIN EMPLOYEES_DETAIL ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID
		LEFT JOIN EMPLOYEES_IDENTY ON EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
	WHERE
		EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>

<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>

<cfif isdefined("attributes.employee_id") and len("attributes.employee_id")>
	<cfquery name="get_pos_other" datasource="#dsn#">
		SELECT 
			EP.POSITION_NAME,
			EP.POSITION_ID,
			EP.EMPLOYEE_ID,
			EP.POSITION_CODE,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_CITY,
			BRANCH.BRANCH_COUNTY,
			BRANCH.BRANCH_ADDRESS,
			BRANCH.BRANCH_FAX,
			BRANCH.BRANCH_TELCODE,
			BRANCH.BRANCH_TEL1,
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			OUR_COMPANY.NICK_NAME,
            OUR_COMPANY.ADDRESS,
            OUR_COMPANY.TEL_CODE,
            OUR_COMPANY.TEL,
			EMPLOYEES_IN_OUT.START_DATE,
			EMPLOYEES_IN_OUT.FINISH_DATE
		FROM
			EMPLOYEE_POSITIONS EP,
			BRANCH,
			DEPARTMENT,
			OUR_COMPANY,
			EMPLOYEES_IN_OUT
		WHERE
			EMPLOYEES_IN_OUT.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
			EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			DEPARTMENT.DEPARTMENT_ID = EP.DEPARTMENT_ID
			AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
			AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
	</cfquery>
</cfif>
<style>
	.box_yazi {border : 0px none #e1ddda;border-width : 0px 0px 0px 0px;border-bottom-width : 0px;background-color : transparent;background-color:#FFFFFF;text-align: left;} <!--- font-size:12px;font-family:Arial, Helvetica, sans-serif; --->
</style>
<table border="0" cellpadding="0" cellspacing="0" style="height:265mm; width:190mm;">
	<tr>
    	<td rowspan="30" style="width:15mm;">&nbsp;</td>
    </tr>
    <tr>
    	<td style="height:10mm;" valign="top">
        	<table border="0" cellpadding="0" cellspacing="0" style="height:10mm;" width="100%">
            	<tr>
               	    <td class="formbold" align="center"><br>ÇALIŞANLARA AİT KİMLİK BİLDİRME BELGESİ<br>ÇALIŞILAN YERİN</td>
                </tr>
            </table>
        </td>
	</tr>
    <tr><td style="height:1mm;">&nbsp;</td></tr>
    <tr>
    	<td style="height:20mm;" valign="top">
        	<table border="1" cellpadding="0" cellspacing="0" width="100%">
				<cfoutput>
				<tr>
            	  	<td rowspan="4" style="writing-mode: tb-rl; filter:flipv() fliph(); width:25mm;" align="center">TESİSİN</td>
					<td rowspan="2" style="writing-mode: tb-rl; filter:flipv() fliph(); width:5mm;" align="center">TÜRÜ</td>
                    <td align="center" style="width:15mm; height:5mm;">İşyeri</td>
                    <td align="center" style="width:15mm;">Konut</td>                    
                    <td align="center" style="width:15mm;">Yurt</td>
                   <td rowspan="2" style="writing-mode: tb-rl; filter:flipv() fliph(); width:5mm;" align="center">ADI</td>
				   <td rowspan="2" colspan="4" style="width:50mm">&nbsp;#get_pos_other.branch_name#</td>
				   <td rowspan="4" align="center" style="width:120px">
				   		<cf_get_server_file output_file="hr/#get_employee.photo#" output_server="#get_employee.photo_server_id#" output_type="0" image_width="120" image_height="160"><br>
				   </td>
                </tr>
                <tr>
					<td>&nbsp;X</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            	<tr>
					<td rowspan="2" style="writing-mode: tb-rl; filter:flipv() fliph(); width:5mm;" align="center">YERİ</td>
                    <td style="width:15mm; height:5mm;" align="center">İl-İlçe</td>
                    <td style="width:25mm;" align="center" colspan="4">Adres</td>
                    <td style="width:22mm;" align="center">Tel No.</td>
                </tr>
                <tr>
                    <td style="height:14mm;" align="center">&nbsp;#get_pos_other.branch_city#-#get_pos_other.branch_county#</td>
                    <td align="center" colspan="4">&nbsp;#get_pos_other.branch_address#</td>
                    <td>&nbsp;(#get_pos_other.branch_telcode#) #get_pos_other.branch_tel1#</td>
                </tr>
				</cfoutput>
            </table>
        </td>
    </tr>
    <tr>
    	<td style="height:10mm;" valign="top">
        	<table border="0" cellpadding="0" cellspacing="0" style="height:10mm;" width="100%">
            	<tr>
               	    <td class="formbold" align="center"><br>ÇALIŞANIN</td>
                </tr>
            </table>
        </td>
	</tr>
    <tr>
    	<td style="height:56mm;" valign="top">
        	<table border="1" cellpadding="0" cellspacing="0" width="100%">
            	<cfoutput>
				 <tr>
                	<td>&nbsp;T.C Kimlik No</td>
                    <td>&nbsp;#get_employee.tc_kimlik#</td>
					 <td colspan="3" style="width:84mm;">
                    	<table border="0" cellpadding="0" cellspacing="0">
                        	<tr>
                            	<td style="width:71mm;" align="right">Nüfusa Kayıtlı Olduğu</td>
                            </tr>
                        </table>
                   	</td>
                </tr>
				<tr>
                	<td style="height:5mm; width:35mm;">&nbsp;Adı</td>
                    <td style="width:55mm;">&nbsp;#get_employee.ad#</td>
                    <td style="width:24mm;">&nbsp;İl</td>
                    <td style="width:59mm;" colspan="2">&nbsp;#get_employee.city#</td>
                </tr>
               <tr>
                	<td style="height:5mm; width:35mm;">&nbsp;Soyadı</td>
                    <td style="width:55mm;">&nbsp;#get_employee.soyad#</td>
                    <td style="width:24mm;">&nbsp;İlçe</td>
                    <td style="width:59mm;" colspan="2">&nbsp;#get_employee.county#</td>
                </tr>
				<tr>
                	<td style="height:5mm;">&nbsp;Ana Adı</td>
                    <td>&nbsp;#get_employee.ana_adi#</td>
					<td>&nbsp;Mah-Köyü</td>
                    <td colspan="2">#get_employee.ward#<cfif len(get_employee.ward)>-</cfif>#get_employee.village#</td>
                </tr>
                <tr>
                	<td style="height:5mm;">&nbsp;Baba Adı</td>
                    <td>&nbsp;#get_employee.baba_adi#</td>
					 <td rowspan="2">Nüfus Cüzdanı veya Pasaport Tar.</td>
                    <td rowspan="2" colspan="2">#dateformat(get_employee.given_date,dateformat_style)#</td>
                </tr>
                <tr>
                	<td style="height:5mm;">&nbsp;Doğum Yeri</td>
                    <td>&nbsp;#get_employee.dogum_yeri#</td>
                </tr>
				 <tr>
                	<td style="height:5mm;">&nbsp;Doğum Tarihi</td>
                    <td>&nbsp;#DateFormat(get_employee.dogum_tarihi,dateformat_style)#</td>
                    <td rowspan="2">&nbsp;Ika.Tez.T ve S.</td>
                    <td rowspan="2" colspan="2">&nbsp;</td> 
                </tr>
                 <tr>
                	<td style="height:5mm;">&nbsp;Uyruğu</td>
                    <td>&nbsp;<cfloop query="get_country"><cfif get_country.country_id eq get_employee.nationality or (not len(get_employee.nationality) and is_default eq 1)>#country_name#</cfif></cfloop></td>
                </tr> 
				 <tr>
                	<td style="height:5mm;">&nbsp;Medeni Hali</td>
                    <td>&nbsp;<cfif get_employee.medeni_hali eq 1>Evli<cfelse>Bekar</cfif></td>
                    <td>Cilt No</td>
					<td>Hane No</td>
					<td>Sayfa No</td>
                </tr>
				<tr>
                	<td style="height:5mm;">&nbsp;Cinsiyeti</td>
                    <td>&nbsp;<cfif get_employee.sex eq 1>Erkek<cfelse>Bayan</cfif></td>
                    <td>#get_employee.binding#</td>
					<td>#get_employee.family#</td>
					<td>#get_employee.cue#</td>
                </tr>
				<tr valign="top">
					<td rowspan="2">İkamet Adresi ve Telefon No. Gsm No.</td>
					<td rowspan="2">#get_employee.homeaddress#</td>
					<td style="height:5mm;">Yaptığı İş</td>
					<td style="width:30mm;" colspan="2">&nbsp;#get_employee.position_name#</td>
				</tr>
				<tr>
                     <td style="width:25mm;">Başlama Tarihi</td><!--- #DateFormat(GET_WORK_INFO.BASLAMA_TARIHI,dateformat_style)# --->
					 <td style="width:20mm;">#DateFormat(get_pos_other.start_date,dateformat_style)#</td>
                     <td style="width:40mm;">İşyerinde Barınıyor mu?</td>
				</tr>
				</cfoutput>
           </table>
        </td>
    </tr>
    <tr>
    	<td style="height:10mm;" valign="top">
        	<table border="0" cellpadding="0" cellspacing="0" style="height:10mm;" width="100%">
            	<tr>
               	    <td class="formbold" align="center"><br>BELGEYİ DÜZENLEYENİN</td>
                </tr>
            </table>
        </td>
	</tr>
    <tr>
    	<td valign="top" style="height:30mm;">
        	<table border="1" cellpadding="0" cellspacing="0" width="100%">
				<cfoutput>					
					<cfquery name="employee" datasource="#dsn#">
						SELECT 
							EMPLOYEES_IDENTY.TC_IDENTY_NO,
							EMPLOYEES_IDENTY.FATHER,
							EMPLOYEES_IDENTY.MOTHER,
							EMPLOYEES_IDENTY.BIRTH_PLACE,
							EMPLOYEES_IDENTY.BIRTH_DATE,
							EMPLOYEES_IDENTY.NATIONALITY,
							EMPLOYEES_DETAIL.HOMEADDRESS,
							EMPLOYEES_DETAIL.HOMETEL_CODE,
							EMPLOYEES_DETAIL.HOMETEL,
							EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
							EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                            EMPLOYEES_IDENTY.MARRIED,
                            EMPLOYEES_DETAIL.SEX
						FROM 
							EMPLOYEES_IDENTY,
							EMPLOYEES_DETAIL,
							EMPLOYEE_POSITIONS
						WHERE 
							EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
							EMPLOYEES_IDENTY.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
							EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID							
					</cfquery>	
				<tr>
					<td style="height:5mm; width:24mm;">&nbsp;T.C. Kimlik No</td>
                    <td>&nbsp;#employee.tc_identy_no#</td>
                    <td colspan="3" align="center">Durumu</td>
                </tr>
                <tr>
                	<td style="height:5mm; width:24mm;">&nbsp;Adı</td>
                    <td style="width:57mm;">&nbsp;#employee.employee_name#</td>
                    <td rowspan="3" style="width:21mm;">&nbsp;İşyerinde</td>
              	    <td style="width:50mm;">&nbsp;Sahibi</td>
              	    <td style="width:12mm;">&nbsp;</td>
                </tr>
				 <tr>
                	<td style="height:5mm; width:24mm;">&nbsp;Soyadı</td>
                    <td style="width:57mm;">&nbsp;#employee.employee_surname#</td>
              	    <td style="width:50mm;">&nbsp;Kiracısı</td>
              	    <td style="width:12mm;">&nbsp;</td>
                </tr>
				 <tr>
                	<td style="height:5mm; width:24mm;">&nbsp;Ana Adı</td>
                    <td style="width:57mm;">&nbsp;#employee.mother#</td>
              	    <td style="width:50mm;">&nbsp;Sorumlu İşletmecisi</td>
              	    <td style="width:12mm;">&nbsp;X</td>
                </tr>
                <tr>
                	<td style="height:5mm; width:24mm;">&nbsp;Baba Adı</td>
                    <td>&nbsp;#employee.father#</td>
                    <td rowspan="2">&nbsp;Konutta</td>
                    <td>&nbsp;Aile Reisi</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                	<td style="height:5mm; width:24mm;">&nbsp;Doğum Yeri</td>
                    <td>&nbsp;#employee.birth_place#</td>
					 <td>&nbsp;Yönetici veya yetkili üye</td>
                    <td>&nbsp;</td>
                </tr>
				 <tr>
                	<td style="height:5mm; width:24mm;">&nbsp;Doğum Tarihi</td>
                    <td>&nbsp;#Dateformat(employee.birth_date,dateformat_style)#</td>
                   	<td>&nbsp;Yurtta</td>
                    <td>&nbsp;Sorumlu işletici</td>
                    <td>&nbsp;</td>
                </tr>
				
                <tr>
                	<td style="height:5mm; width:24mm;">&nbsp;Uyruğu</td>
                    <td>&nbsp;<cfloop query="get_country"><cfif get_country.country_id eq employee.nationality or (not len(employee.nationality) and is_default eq 1)>#COUNTRY_NAME#</cfif></cfloop></td>
					<td rowspan="4" colspan="3" valign="top">
						<table border="0">
							<tr>
								<td>&nbsp;</td>
								<td colspan="2">VERDİĞİM BU BİLGİLERİN DOĞRULUĞUNU ONAYLARIM.</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td align="center">TARİH</td>
								<td align="center">İMZA</td>
							</tr>
						</table>
					</td>
                </tr>
				 <tr>
                	<td style="height:5mm; width:24mm;">&nbsp;Medeni Hali</td>
                    <td>&nbsp;<cfif employee.married eq 1>Evli<cfelse>Bekar</cfif></td>
                </tr>
				 <tr>
                	<td style="height:5mm; width:24mm;">&nbsp;Cinsiyeti</td>
                    <td>&nbsp;<cfif employee.sex eq 1>Erkek<cfelse>Bayan</cfif></td>
                </tr>
                <tr>
                	<td style="height:5mm; width:24mm;">&nbsp;İkamet Adresi ve Tel. No</td>
                    <td>&nbsp;#employee.homeaddress#&nbsp; #(employee.hometel_code)# #employee.hometel#</td>
                  
                </tr>
				</cfoutput>
            </table>
        </td>
    </tr>
    <tr>
    	<td valign="top" style="height:1mm;">
        	<table border="0" cellpadding="0" cellspacing="0">
            	<tr><td><!--- ara bosluk --->&nbsp;</td></tr>
            </table>
        </td>
	</tr>
    <tr>
		<td valign="top" style="height:24mm;" align="right">
        	<table border="0" cellpadding="0" cellspacing="0" width="100%">
            	<tr>
					<td align="center">
						<table border="0" cellpadding="0" cellspacing="0" style="height:24mm;">
							<tr><td colspan="2" class="formbold" align="center">Belgeyi Teslim Alanın</td></tr>
							<tr>
								<td style="height:6mm;" align="right">&nbsp;Adı Soyadı :..............................</td>
								<td>&nbsp;Görevi :..............................</td>
							</tr>
							<tr>
								<td style="height:6mm;" align="right">&nbsp;Rütbesi :..............................</td>
								<td>&nbsp;İmzası :..............................</td>
							</tr>
							<tr>
							<td colspan="2" align="center">Alınış Tarihi: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;/ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; /</td>
							</tr>
						</table>
					</td>
				</tr>
            </table>
        </td>
    </tr>
	<tr>
    	<td style="height:10mm;" valign="top">
        	<table border="0" cellpadding="0" cellspacing="0" style="height:10mm;" width="100%">
            	<tr>
               	    <td class="formbold" align="center"><br>ÇALISANIN AYRILMASI HALİNDE BELGEYİ DÜZENLEYEN İLE KOLLUK<br> ÖRGÜTÜ ARASINDA DEĞİŞTİRİLECEK KISIM</td>
                </tr>
            </table>
        </td>
	</tr>
	<tr>
		<td valign="top">
			<table border="1" cellpadding="0" cellspacing="0" width="100%">
				<cfoutput>
				<tr>
					<td style="width:24mm; height:7mm;">&nbsp;T.C. Kimlik No</td>
					<td style="width:60mm;">#get_employee.TC_KIMLIK#</td>
					<td style="width:22mm;">&nbsp;Çalışılan Yerin &nbsp;Adresi</td>
					<td style="width:58mm;">#get_pos_other.branch_city#-#get_pos_other.branch_county#</td>
				</tr>
				<tr>
					<td style="width:24mm; height:7mm;">&nbsp;Soyadı Adı</td>
					<td style="width:60mm;">#get_employee.ad# #get_employee.soyad#</td>
					<td style="width:22mm;">&nbsp;Ayrılış Tarihi</td>
					<td style="width:58mm;">#DateFormat(get_pos_other.finish_date,dateformat_style)#&nbsp;</td>
				</tr>
				<tr>
					<td style="width:24mm; height:7mm;">&nbsp;Baba Adı</td>
					<td style="width:60mm;">#get_employee.baba_adi#</td>
					<td style="width:22mm;" rowspan="2">&nbsp;İmza</td>
					<td rowspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td style="width:24mm; height:7mm;">&nbsp;D.Y. ve Tarihi</td>
					<td style="width:60mm;">#get_employee.dogum_yeri# #dateformat(get_employee.dogum_tarihi,dateformat_style)#</td>
				</tr>
				<tr>
					<td colspan="4">BU KISMIN BELGE ÖRNEĞİ İLE BİRLİKTE 3 YIL SAKLANMASI ZORUNLUDUR.</td>
				</tr>
			</cfoutput>
			</table>
		</td>
	</tr>
</table>
