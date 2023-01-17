<cfquery name="ALL_DEPARTMENTS" datasource="#DSN#">
	SELECT DISTINCT
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		BRANCH.COMPANY_ID
	FROM 
		DEPARTMENT, 
		BRANCH,
		EMPLOYEE_POSITION_BRANCHES
	WHERE 
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		BRANCH.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND
        BRANCH.BRANCH_STATUS = 1 AND
        DEPARTMENT.DEPARTMENT_STATUS = 1 AND
        DEPARTMENT.IS_STORE <> 1 AND
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	ORDER BY 
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfquery name="PERIODS" datasource="#DSN#">
	SELECT PERIOD_ID,PERIOD FROM SETUP_PERIOD ORDER BY PERIOD
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Kurumsal Üye Aktarım','42018')#" closable="0">
        <cfform name="form_import" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.add_member_import">
        <input type="hidden" name="html_file" id="html_file" value="<cfoutput>#createUUID()#</cfoutput>.html">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="file_format" id="file_format">
                                <option value="UTF-8"><cf_get_lang dictionary_id='55929.UTF-8'></option>
                                <option value="ISO-8859-9"><cf_get_lang dictionary_id='53845.ISO-8859-9 (Türkçe)'></option>
                            </select>
                        </div>
                    </div>                   
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="uploaded_file" id="uploaded_file">
                        </div>
                    </div>                   
                    <div class="form-group" id="item-download-link">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <a href="/IEF/standarts/import_example_file/Kurumsal_uye_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                        </div>
                    </div>
                    <div class="form-group" id="item-period_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'>*</label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="period_id" id="period_id">
                                <cfoutput query="periods">
                                    <option value="#period_id#" <cfif periods.period_id eq session.ep.period_id> selected</cfif>>#period#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-location_format">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                            <select name="location" id="location">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="all_departments">
                                    <option value="#COMPANY_ID#,#department_id#,#branch_id#">#branch_name# / #department_head#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div>
                        <input type="checkbox" name="status" id="status" value="1" checked tabindex="4"><cf_get_lang dictionary_id='57493.Aktif'>
                        <input type="checkbox" name="ispotential" id="ispotential" value="1" tabindex="5"><cf_get_lang dictionary_id='57577.Potansiyel'>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-format">
                        <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                    </div>  
                    <div class="form-group" id="item-exp1">
                        <label><b><cf_get_lang dictionary_id='44191.Mail Hesabı Ayarları'>.<cf_get_lang dictionary_id='53875.Format UTF-8 olmalıdır'>.<cf_get_lang dictionary_id='36511.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.</b></label>
                    </div> 
                    <div class="form-group" id="item-exp2">
                        <label><b><cf_get_lang dictionary_id='63181.Firma adlarında özel karakterler kesinlikle kullanılmamalıdır'>(',",#)</b></label>
                    </div>  
                    <div class="form-group" id="item-exp3">
                        <label><b><cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'>:58 <cf_get_lang dictionary_id='53860.Alanlar sırasıyla'>;</b></label>
                    </div>                 
                    <div class="form-group" id="item-exp4">
                        1-<cf_get_lang dictionary_id='44159.Kısa Firma Adı'>(*)<br/>
                        2-<cf_get_lang dictionary_id='34578.Firma Adı'>(*)<br/>
                        3-<cf_get_lang dictionary_id='44161.Firma Adres'><br/>
                        4-<cf_get_lang dictionary_id='44582.Firma İlçe'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        5-<cf_get_lang dictionary_id='44163.Firma Şehir'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        6-<cf_get_lang dictionary_id='44164.Firma Semt'><br/>
                        7-<cf_get_lang dictionary_id='63182.Firma Mahalle'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        8-<cf_get_lang dictionary_id='44165.Firma Ülke'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        9-<cf_get_lang dictionary_id='44166.Firma Tel Alan Kodu'>(<cf_get_lang dictionary_id='63183.5 haneli'>)<br/>
                        10-<cf_get_lang dictionary_id='44168.Firma Tel'>(<cf_get_lang dictionary_id='63184.10 haneli'>)<br/>
                        11-<cf_get_lang dictionary_id='44168.Firma Tel'>2(<cf_get_lang dictionary_id='63184.10 haneli'>)<br/>
                        12-<cf_get_lang dictionary_id='44168.Firma Tel'>3(<cf_get_lang dictionary_id='63184.10 haneli'>)<br/>
                        13-<cf_get_lang dictionary_id='44170.Firma Fax'>(<cf_get_lang dictionary_id='63184.10 haneli'>)<br/>
                        14-<cf_get_lang dictionary_id='44171.Firma E-mail'><br/>
                        15-<cf_get_lang dictionary_id='45044.Firma İnternet Adresi'><br/>
                        16-<cf_get_lang dictionary_id='45047.Firma Cep Tel Alan Kodu'><br/>
                        17-<cf_get_lang dictionary_id='45045.Firma Cep Tel'><br/>
                        18-<cf_get_lang dictionary_id='57659.Satış Bölgesi'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        19-<cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        20-<cf_get_lang dictionary_id='58830.İlişki Şekli'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        21-<cf_get_lang dictionary_id='57482.Aşama'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)(*)<br/>
                        22-<cf_get_lang dictionary_id='57486.Kategori'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)(*)<br/>
                        23-<cf_get_lang dictionary_id='56460.Grup Şirketi'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        24-<cf_get_lang dictionary_id='44172.Vergi Dairesi İsmi'><br/>
                        25-<cf_get_lang dictionary_id='57752.Vergi No'><br/>
                        26-<cf_get_lang dictionary_id='57579.Sektör'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        27-<cf_get_lang dictionary_id='57764.Cinsiyet'>(<cf_get_lang dictionary_id='44174.Bay - Bayan'>)<br/>
                        28-<cf_get_lang dictionary_id='30325.Yetkili Adı'>(*)<br/>
                        29-<cf_get_lang dictionary_id='63185.Yetkili Soyadı'>(*)<br/>
                        30-<cf_get_lang dictionary_id='57571.Ünvan'>(<cf_get_lang dictionary_id='63186.Ünvan girilmelidir'>)<br/>
                        31-<cf_get_lang dictionary_id='57572.Departman'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)(*)<br/>
                        32-<cf_get_lang dictionary_id='44176.Kişisel E-mail'><br/>
                        33-<cf_get_lang dictionary_id='44177.Tel Alan Kodu'>(<cf_get_lang dictionary_id='63183.5 haneli'>)<br/>
                        34-<cf_get_lang dictionary_id='55107.Telefon No'>(<cf_get_lang dictionary_id='63184.10 haneli'>)<br/>
                        35-<cf_get_lang dictionary_id='45046.Yetkili Dahili No'><br/>
                        36-<cf_get_lang dictionary_id='44178.Cep Tel Alan Kodu'>(<cf_get_lang dictionary_id='63183.5 haneli'>)<br/>
                        37-<cf_get_lang dictionary_id='51518.Cep Tel'>(<cf_get_lang dictionary_id='63184.10 haneli'>)<br/>
                        38-<cf_get_lang dictionary_id='55594.Ev Adresi'><br/>
                        39-<cf_get_lang dictionary_id='44181.Ev Alan Kodu'><br/>
                        40-<cf_get_lang dictionary_id='44182.Ev Posta Kodu'><br/>
                        41-<cf_get_lang dictionary_id='58814.Ev Telefonu'><br/>
                        42-<cf_get_lang dictionary_id='44184.Ev Semt'><br/>
                        43-<cf_get_lang dictionary_id='44581.Ev İlçe'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        44-<cf_get_lang dictionary_id='44185.Ev Sehir'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        45-<cf_get_lang dictionary_id='44186.Ev Ülke'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        46-<cf_get_lang dictionary_id='58552.Müşteri Değeri'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        47-<cf_get_lang dictionary_id='58025.TC Kimlik No'><br/>
                        48-<cf_get_lang dictionary_id='44188.Not Başlığı'><br/>
                        49-<cf_get_lang dictionary_id='57467.Not'><br/>
                        50-<cf_get_lang dictionary_id='63187.2. Not Başlığı'><br/>
                        51-<cf_get_lang dictionary_id='63188.2. Not'><br/>
                        52-<cf_get_lang dictionary_id='52269.Üyelik Başlama Tarihi'><br/>
                        53-<cf_get_lang dictionary_id='57558.Üye No'><br/>
                        54-<cf_get_lang dictionary_id='57908.Temsilci'>(<cf_get_lang dictionary_id='44685.id girilmelidir'>)<br/>
                        55-<cf_get_lang dictionary_id='57789.Özel Kod'><br/>
                        56-<cf_get_lang dictionary_id='30338.Özel Kod 2'><br/>
                        57-<cf_get_lang dictionary_id='30343.Özel Kod 3'><br/>
                        58-<cf_get_lang dictionary_id='59876.Kep Adresi'><br/>
                    </div>
                    <div class="form-group" id="item-exp5">
                        <label><b><cf_get_lang dictionary_id='57467.Not'>:<cf_get_lang dictionary_id='43095.* ile işaretli alanlar zorunludur'></b></label>
                    </div>
                </div> 
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>  
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{	
	if(document.form_import.uploaded_file.value.length == 0)
	{
		alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
		return false;
	}
	if(document.form_import.period_id.value.length ==0)
	{
		alert("<cf_get_lang dictionary_id='43274.Dönem Seçmelisiniz'>");
		return false;
	}
	return true;
}
</script>
