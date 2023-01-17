<!---FA20060405 hobimden gelen belge ile fatura numalaraını hobimin verdiği fatua numaraları ile değiştiriyor--->
<cfsetting showdebugoutput="no">
<!---<cfif dateformat(now(),timeformat_style) gte '17:00'>--->
	<cfif not isdefined('attributes.is_import')>
<cf_popup_box title="Hobim Fatura Dönüşüm İmport">
    <cfform name="formexport" enctype="multipart/form-data" method="post" action="">
	<input type="hidden" name="is_import" id="is_import" value="1">
        <table>
            <tr>
                <td width="100">Belge Formatı</td>
                <td>
                    <select name="file_format" id="file_format" style="width:200;">
                        <option value="iso-8859-9">ISO-8859-9 (Türkçe)</option>
                        <option value="utf-8">UTF-8</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>Belge*</td>
                <td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200;"></td>
            </tr>
        </table>
        <cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
    </cfform>
    </cf_popup_box>
	<cfelseif isdefined('attributes.is_import') and attributes.is_import eq 1>
		<cfset upload_folder = "#upload_folder#invoice#dir_seperator#">
		<cftry>
			<cffile action = "upload" 
					fileField = "uploaded_file" 
					destination = "#upload_folder#"
					nameConflict = "MakeUnique"  
					mode="777" charset="#attributes.file_format#">
			<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
			
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
			
			<cfset file_size = cffile.filesize>
			<cfcatch type="Any">
				<script language="JavaScript">
					alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz !");
					history.back();
				</script>
				<cfabort>
			</cfcatch>  
		</cftry>
		
		<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
		
		<cfscript>
			CRLF = Chr(13) & Chr(10);// satır atlama karakteri
			dosya = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya);
			okunacak_line=1000;
		</cfscript>
	
	<cfloop from="1" to="#ceiling(line_count/okunacak_line)#" index="j">
		<cfset 'invoice_no_list_#j#'="">
		<cfset 'invoice_id_list_#j#'="">
		<cfset start_line=((j-1)*okunacak_line)+1>
		<cfset finish_line=(start_line-1)+okunacak_line>
		<cfif finish_line gt line_count><cfset finish_line=line_count></cfif>
		<cfloop from="#start_line#" to="#finish_line#" index="i">
			 <cftry>
				<cfscript>
					kayit =dosya[i];
					/*fatura_id =val(mid(kayit,1,10));
					fatura_no =trim(mid(kayit,10,20));*/
					fatura_id = val(mid(kayit,1,10));
					fatura_no = trim(mid(kayit,10,16));
					ekbilgi_1 = trim(mid(kayit,26,24));
					ekbilgi_2 = trim(mid(kayit,51,2));
					
					'invoice_number_#fatura_id#'=fatura_no;
					'ekbilgi_1_#fatura_id#'=ekbilgi_1;
					'ekbilgi_2_#fatura_id#'=ekbilgi_2;

					'invoice_no_list_#j#'=listappend(evaluate('invoice_no_list_#j#'),fatura_no,',');
					'invoice_id_list_#j#'=listappend(evaluate('invoice_id_list_#j#'),fatura_id,',');
				</cfscript>
			 <cfcatch type="Any">
				<cfoutput>#i#</cfoutput>. fatura idli satır 1. adımda (okumada) sorun oluştu.<br>
			 </cfcatch>
			</cftry>
		</cfloop>
		<cfset "invoice_no_list_#j#" = ListQualify(evaluate("invoice_no_list_#j#"),"'",",")>
        
		<cfquery name="GET_INVOICE_CONTROL" datasource="#dsn2#">
			SELECT
				INVOICE_ID,
				INVOICE_NUMBER,
				PURCHASE_SALES,
				INVOICE_CAT,
				WRK_ID
			FROM
				INVOICE
			WHERE
				PURCHASE_SALES = 1 AND 
				INVOICE_NUMBER IN (#evaluate('invoice_no_list_#j#')#)
		</cfquery>
		<cfset 'invoice_id_list_kontrol_#j#'="">
		<cfoutput query="GET_INVOICE_CONTROL">
			<cfset 'invoice_id_list_kontrol_#j#'=listappend(evaluate('invoice_id_list_kontrol_#j#'),INVOICE_ID,',')>
			#GET_INVOICE_CONTROL.INVOICE_NUMBER#  fatura numarası var....<br>
		</cfoutput>
		
		<cfquery name="GET_INVOICE" datasource="#dsn2#">
			SELECT
				INVOICE_ID,
				INVOICE_NUMBER,
				PURCHASE_SALES,
				INVOICE_CAT,
				WRK_ID,
				INVOICE_DATE,
				COMPANY_ID,
				CONSUMER_ID
			FROM
				INVOICE
			WHERE
				PURCHASE_SALES = 1 AND 
				INVOICE_ID IN (#evaluate('invoice_id_list_#j#')#)
				<cfif GET_INVOICE_CONTROL.recordcount> AND INVOICE_ID NOT IN (#evaluate('invoice_id_list_kontrol_#j#')#)</cfif>
		</cfquery>
        
		<cfset comp_list=listsort(listdeleteduplicates(valuelist(GET_INVOICE.COMPANY_ID,',')),'numeric','ASC')>
		<cfif listlen(comp_list,',')>
			<cfquery name="get_comp" datasource="#dsn#">
				SELECT COMPANY_ID,FULLNAME MEMBER_NAME FROM COMPANY WHERE COMPANY_ID IN (#comp_list#)
			</cfquery>
		</cfif>
		<cfset con_list=listsort(listdeleteduplicates(valuelist(GET_INVOICE.CONSUMER_ID,',')),'numeric','ASC')>
		<cfif listlen(con_list,',')>
			<cfquery name="get_cons" datasource="#dsn#">
				SELECT CONSUMER_ID,CONSUMER_NAME+' '+CONSUMER_SURNAME MEMBER_NAME FROM CONSUMER WHERE CONSUMER_ID IN (#con_list#)
			</cfquery>
		</cfif>
		<cfoutput query="GET_INVOICE">
		<cfif len(COMPANY_ID)>
			<cfquery name="get_member" dbtype="query">
				SELECT MEMBER_NAME FROM get_comp WHERE COMPANY_ID =#COMPANY_ID#
			</cfquery>
		<cfelseif len(CONSUMER_ID)>
			<cfquery name="get_member" dbtype="query">
				SELECT MEMBER_NAME FROM get_cons WHERE CONSUMER_ID =#CONSUMER_ID#
			</cfquery>
		</cfif>
		<cftry>
			<cflock name="#CreateUUID()#" timeout="30">
			<cftransaction>
				<cfif isdefined('invoice_number_#GET_INVOICE.INVOICE_ID#') and len(evaluate('invoice_number_#GET_INVOICE.INVOICE_ID#'))>
				<cfset yeni_fatura_no=evaluate('invoice_number_#GET_INVOICE.INVOICE_ID#')>
				<cfset yeni_fatura_detail="Ft: #yeni_fatura_no# #get_member.MEMBER_NAME#">
                <cfset yeni_ekbilgi_1=evaluate('ekbilgi_1_#GET_INVOICE.INVOICE_ID#')>
                <cfset yeni_ekbilgi_2=evaluate('ekbilgi_2_#GET_INVOICE.INVOICE_ID#')>
                
 					<cfquery name="UPD_INVOICE_SALE" datasource="#dsn2#">
						UPDATE INVOICE SET INVOICE_NUMBER='#yeni_fatura_no#' WHERE INVOICE_ID=#GET_INVOICE.INVOICE_ID#
					</cfquery>
		
					<cfquery name="UPD_CARI_ROWS" datasource="#dsn2#">
						UPDATE CARI_ROWS SET PAPER_NO='#yeni_fatura_no#' WHERE ACTION_ID=#GET_INVOICE.INVOICE_ID# AND ACTION_TYPE_ID=#GET_INVOICE.INVOICE_CAT#
					</cfquery>
					
					<cfquery name="UPD_ACCOUNT_CARD" datasource="#dsn2#">
						UPDATE ACCOUNT_CARD SET PAPER_NO='#yeni_fatura_no#' WHERE ACTION_ID=#GET_INVOICE.INVOICE_ID# AND ACTION_TYPE=#GET_INVOICE.INVOICE_CAT#
					</cfquery>
						
					<cfquery name="UPD_ACCOUNT_CARD_ROW" datasource="#dsn2#">
						UPDATE 
							ACCOUNT_CARD_ROWS 
						SET 
							DETAIL='#yeni_fatura_detail#'
						WHERE 
							CARD_ID IN (SELECT CARD_ID FROM ACCOUNT_CARD WHERE ACTION_ID=#GET_INVOICE.INVOICE_ID# AND ACTION_TYPE=#GET_INVOICE.INVOICE_CAT#)
					</cfquery>
				 
					<cfquery name="UPD_INVOICE_SALE" datasource="#dsn2#">
						UPDATE SHIP SET SHIP_NUMBER='#yeni_fatura_no#' WHERE SHIP_NUMBER='#GET_INVOICE.INVOICE_NUMBER#' AND WRK_ID='#GET_INVOICE.WRK_ID#'
					</cfquery>
					
					<cfquery name="UPD_INVOICE_SHIPS" datasource="#dsn2#">
						UPDATE INVOICE_SHIPS SET INVOICE_NUMBER='#yeni_fatura_no#', SHIP_NUMBER='#yeni_fatura_no#' WHERE INVOICE_ID=#GET_INVOICE.INVOICE_ID#
					</cfquery>
                    
                    <cfquery name="invoice_add_info" datasource="#dsn2#">
						INSERT INTO INVOICE_INFO_PLUS
                            (
                                PROPERTY2,
                                PROPERTY3,
                                INVOICE_ID
                            )
                                VALUES
                            (
                                '#yeni_ekbilgi_1#',
                                '#yeni_ekbilgi_2#',
                                #GET_INVOICE.INVOICE_ID#
                            )
					</cfquery>
	
				<cfelse>
					#fatura_id# fatura idli satırda (kaydı güncellemede) adımda sorun oluştu (Satır boş olabilir).<br>
				</cfif>
				
			</cftransaction>
			</cflock>
					
			<cfcatch type="Any">
				#fatura_id# fatura idli satır 2. adımda (kaydı güncellemede) sorun oluştu. Bu fatura için güncelleme işlemi yapılmadı<br>
			</cfcatch>
		</cftry>
		
		</cfoutput>
		<cfset 'invoice_id_list_kontrol_#j#'="">
        <cfset 'invoice_no_list_#j#'="">
        <cfset 'invoice_id_list_#j#'="">
	</cfloop>
		<cfoutput>işlem tamamlandı !!!</cfoutput><cfabort>	
	</cfif>
<!---<cfelse>
	<script language="javascript">
		alert('Bu raporu mesai saatleri içinde çalıştırmayınız. Saat:19:00 dan sonra çalıştıra bilirsiniz!');
	</script>
	<cfexit method="exittemplate">
</cfif>--->
