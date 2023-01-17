<!---
File: transfer_salary_scale.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date:24.09.2019
Controller: -
Description: İlgili pozisyon tipi için minimim ve maximum ücret tutarlarının import edildiği sayfa querysidir.
--->
<cfif not len(attributes.salary_file)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='44501.Display Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
<cfelse>
    <cfset upload_folder = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile
			action = "upload" 
			fileField = "salary_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777" charset="#attributes.file_format#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='44501.Display Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
                console.log("<cfoutput>#cfcatch.Message#</cfoutput>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>	
	<cftry>
		<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
		<cffile action="delete" file="#upload_folder##file_name#">
		<cfcatch>
			<script type="text/javascript">
				alert("Dosya Okunamadı ! ");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya1 = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya1);
	</cfscript>
	<cfif line_count eq 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='44524.Dosya Geçersiz veya Satır Sayısı Hatalı. Lütfen Dosyanızı Kontrol Ediniz'>!");
			<cfset kont = 0>
			history.back();
		</script>
		<cfabort>
	</cfif>
    <cfset get_wage_scale = createObject('component','V16.hr.cfc.wage_scale')><!--- Temel Ücret Skalası. --->
    <cfloop from="2" to="#line_count#" index="i">
		<cfset kont=1>
		<cftry>
			<cfset sira = trim(listgetat(dosya1[i],1,';'))>
			<cfset position_id = trim(listgetat(dosya1[i],2,';'))>
			<cfset year = trim(listgetat(dosya1[i],3,';'))>				
			<cfset min_salary = trim(listgetat(dosya1[i],4,';'))>
			<cfset max_salary = trim(listgetat(dosya1[i],5,';'))>
			<cfset money = trim(listgetat(dosya1[i],6,';'))>
			<cfif max_salary contains ','>
				<cfset max_salary = replace(max_salary,',','.',"all")>
			</cfif>
            <cfif min_salary contains ','>
				<cfset min_salary = replace(min_salary,',','.',"all")>
			</cfif>
            <cfset get_scale = get_wage_scale.GET_WAGE_SCALE(
                    position_id : position_id,
                    year : year
                )>
            <cfif get_scale.recordcount><!--- Eğer daha önce bu pozisyon id 'ye dair kayıt varsa güncelleme yapıyor.---->
                <cfset update_scale = get_wage_scale.UPDATE_WAGE_SCALE(
                        position_id : position_id,
                        year : year,
                        min_salary : min_salary,
                        max_salary : max_salary,
                        money : money
                    )>
            <cfelse>
                <cfset insert_scale = get_wage_scale.SAVE_WAGE_SCALE(
                        position_id : position_id,
                        year : year,
                        min_salary : min_salary,
                        max_salary : max_salary,
                        money : money
                    )>
            </cfif>
            <cfoutput>#i-1#.<cf_get_lang dictionary_id='58508.Satır'><cf_get_lang dictionary_id='35707.Bitti'>...</cfoutput><br/>
			<cfcatch type="Any">
				<cfset kont = 0>
				<cfoutput>#cfcatch.Message# #i#.<cf_get_lang dictionary_id='44849.Satır Verilerini Okuma Aşamasında Hata Var.'><br/></cfoutput>	
				<script type="text/javascript">
					window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.form_transfer_salary_scale</cfoutput>";
				</script>
			</cfcatch>  
		</cftry>
		<cfif kont eq 1>
			<cf_get_lang dictionary_id='52934.İşlem Başarıyla Tamamlanmıştır'>.
			<script type="text/javascript">
				window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.form_transfer_salary_scale</cfoutput>";
			</script>
		</cfif>
    </cfloop>
</cfif>
<script type="text/javascript">
    window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.form_transfer_salary_scale</cfoutput>";
</script>