<cfset kontrol_file = 0>
<cfset upload_folder = "#upload_folder#finance#dir_seperator#">
<cftry>
	<cffile action = "upload" 
		  fileField = "uploaded_file" 
		  destination = "#upload_folder#"
		  nameConflict = "MakeUnique"  
		  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
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
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
	<cfcatch type="Any">
		<cfset kontrol_file = 1>
	</cfcatch>
</cftry>
<cfif kontrol_file eq 0>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	</cfscript>
	<cfset action_date_ = dateformat(now(),dateformat_style)>
	<cfloop from="2" to="#line_count#" index="k">
		<cfset j= 1>
		<cfscript>
			dosya[k] = dosya[k] & ' ';
			
			borc_emp_id = Listgetat(dosya[k],j,";"); // borçlu üye id
			borc_emp_id = trim(borc_emp_id);
			j=j+1;	
			
			alacak_emp_id = Listgetat(dosya[k],j,";"); // alacaklı üye id
			alacak_emp_id = trim(alacak_emp_id);
			j=j+1;	
			
			borc_project_id = Listgetat(dosya[k],j,";"); // borçlu proje id
			borc_project_id = trim(borc_project_id);
			j=j+1;
			
			alacak_project_id = Listgetat(dosya[k],j,";"); // alacaklı proje id
			alacak_project_id = trim(alacak_project_id);
			j=j+1;
			
			borc_branch_id = Listgetat(dosya[k],j,";"); // borçlu şube id
			borc_branch_id = trim(borc_branch_id);
			j=j+1;
			
			alacak_branch_id = Listgetat(dosya[k],j,";"); // alacaklı şube id
			alacak_branch_id = trim(alacak_branch_id);
			j=j+1;
			
			paper_no = Listgetat(dosya[k],j,";"); // belge no
			paper_no = trim(paper_no);
			j=j+1;
			
			amount = Listgetat(dosya[k],j,";"); // tutar
			amount = trim(replace(amount,',','.'));
			j=j+1;
			
			currency_id = Listgetat(dosya[k],j,";"); // para br
			currency_id = trim(currency_id);
			j=j+1;
			
			if(listlen(dosya[k],';') gte j) 
			{
				detail = Listgetat(dosya[k],j,";"); // açıklama
				detail = trim(detail);
				j=j+1;
			}
			else
			{
				detail = '';
				j=j+1;
			}
			
			if(listlen(dosya[k],';') gte j) 
			{
				action_date = Listgetat(dosya[k],j,";"); // borç ödeme tarih
				action_date = trim(action_date);
				j=j+1;
			}
			else
			{
				action_date = '#action_date_#';
				j=j+1;
			}
			
			if(listlen(dosya[k],';') gte j)
			{
				borc_assetp_id = Listgetat(dosya[k],j,";"); // borçlu fiziki varlık
				borc_assetp_id = trim(borc_assetp_id);
				j=j+1;
			}
			else
			{
				borc_assetp_id = '';
				j=j+1;
			}
			
			if(listlen(dosya[k],';') gte j)
			{
				alacak_assetp_id = Listgetat(dosya[k],j,";"); // alacaklı fiziki varlık
				alacak_assetp_id = trim(alacak_assetp_id);
				j=j+1;
			}
			else
			{
				alacak_assetp_id = '';
				j=j+1;
			}	
			if(listlen(dosya[k],';') gte j) 
			{
				from_due_date = Listgetat(dosya[k],j,";"); // alacak ödeme tarih
				from_due_date = trim(from_due_date);
				j=j+1;
			}
			else
			{
				from_due_date = '';
				j=j+1;
			}		
		</cfscript>
        <cfscript>
			from_company_id = '';
			from_consumer_id = '';
			from_employee_id = '';
			to_company_id = '';
			to_consumer_id = '';
			to_employee_id = '';
		</cfscript>
        <cfquery name="get_id" datasource="#dsn#"> <!--- kurumsal uye --->
            SELECT 
                COMPANY_ID,
                '' CONSUMER_ID,
                '' EMPLOYEE_ID
            FROM 
                COMPANY 
            WHERE 
                MEMBER_CODE = '#borc_emp_id#'
        </cfquery>
        <cfif get_id.recordcount eq 0> <!--- bireysel uye --->
            <cfquery name="get_id" datasource="#dsn#">
                SELECT
                    '' COMPANY_ID,
                    CONSUMER_ID,
                    '' EMPLOYEE_ID
                FROM 
                    CONSUMER 
                WHERE 
                    MEMBER_CODE = '#borc_emp_id#'
            </cfquery>
        </cfif>
        <cfif get_id.recordcount eq 0> <!--- Çalışan --->
            <cfquery name="get_id" datasource="#dsn#">
                SELECT
                    '' COMPANY_ID,
                    '' CONSUMER_ID,
                    EMPLOYEE_ID
                FROM 
                    EMPLOYEES 
                WHERE 
                    EMPLOYEE_NO = '#borc_emp_id#'
            </cfquery>	
        </cfif>
        <cfquery name="get_id2" datasource="#dsn#"> <!--- kurumsal uye --->
            SELECT 
                COMPANY_ID,
                '' CONSUMER_ID,
                '' EMPLOYEE_ID
            FROM 
                COMPANY 
            WHERE 
                MEMBER_CODE = '#alacak_emp_id#'
        </cfquery>
        <cfif get_id2.recordcount eq 0> <!--- bireysel uye --->
            <cfquery name="get_id2" datasource="#dsn#">
                SELECT
                    '' COMPANY_ID,
                    CONSUMER_ID,
                    '' EMPLOYEE_ID
                FROM 
                    CONSUMER 
                WHERE 
                    MEMBER_CODE = '#alacak_emp_id#'
            </cfquery>
        </cfif>
        <cfif get_id2.recordcount eq 0> <!--- Çalışan --->
            <cfquery name="get_id2" datasource="#dsn#">
                SELECT
                    '' COMPANY_ID,
                    '' CONSUMER_ID,
                    EMPLOYEE_ID
                FROM 
                    EMPLOYEES 
                WHERE 
                    EMPLOYEE_NO = '#alacak_emp_id#'
            </cfquery>	
        </cfif>
		<cfoutput>
        <cfif get_id.recordcount eq 0 or get_id2.recordcount eq 0>
        	<script type="text/javascript">
				alert('Lütfen #k#. satırdaki üye/çalışan kodlarını kontrol ediniz.');
			</script>
            <cfabort>
        </cfif>
		<cfif not len(action_date)>
        	<script type="text/javascript">
				alert('Lütfen #k#. satırdaki Ödeme Tarihi giriniz.');
			</script>
            <cfabort>
        </cfif>
		</cfoutput>
        <cfscript>
			from_company_id = '#get_id2.company_id#';
			from_consumer_id = '#get_id2.consumer_id#';
			from_employee_id = '#get_id2.employee_id#';
			to_company_id = '#get_id.company_id#';
			to_consumer_id = '#get_id.consumer_id#';
			to_employee_id = '#get_id.employee_id#';
		</cfscript>
        <cfoutput>
			<script type="text/javascript">
				row_number = parseFloat(window.top.document.getElementById("record_num").value)+1;
				window.top.add_row('#paper_no#','#from_company_id#','#from_consumer_id#','#from_employee_id#','#to_company_id#','#to_consumer_id#','#to_employee_id#','#amount#','','#currency_id#','#action_date#','#from_due_date#','#detail#','#borc_assetp_id#','#alacak_assetp_id#','#borc_project_id#','#alacak_project_id#','#borc_branch_id#','#alacak_branch_id#');
				window.top.kur_ekle_f_hesapla('action_currency_id',false,row_number);
			</script>
		</cfoutput>
	</cfloop>
	<script type="text/javascript">
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
	  </script>
</cfif>