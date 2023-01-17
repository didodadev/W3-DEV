<cfquery name="get_employee_detail" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EIO.SOCIALSECURITY_NO,
		B.BRANCH_NAME,
		B.SSK_NO,
		EIO.SSK_STATUTE,
		EIO.RETIRED_SGDP_NUMBER
	FROM
		EMPLOYEES_IN_OUT EIO,
		BRANCH B,
		EMPLOYEES E
	WHERE
		EIO.EMPLOYEE_ID = #attributes.action_id# AND
		EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EIO.FINISH_DATE IS NULL AND
		EIO.BRANCH_ID = B.BRANCH_ID
</cfquery>

<cfoutput>
    <div id="verify_div">
        <table style="width:200mm;height:275mm;" align="center" class="book">
            <tr>
                <td height="75">&nbsp;</td>
            </tr>
            <tr>
                <td class="formbold" height="30"><u><cf_get_lang dictionary_id="32589.Ek"> -2 :</u></td>
            </tr>
            <tr>
                <td class="formbold" height="30" align="center"><u><cf_get_lang dictionary_id="30896.TAAHHÜTNAME"></u></td>
            </tr>
            <tr>
                <td class="formbold" height="30"><u><cf_get_lang dictionary_id="57480.Konu">:</u> <cf_get_lang dictionary_id="53659.Asgari Geçim İndirimi"> <cf_get_lang dictionary_id="56358.Aile Durum Bildirimi"></td>
            </tr>
            <tr>
                <td height="25">
                <b>#get_employee_detail.SOCIALSECURITY_NO#</b> <cf_get_lang dictionary_id="60960.SGK sicil numarası ile şirketinizde çalışmaktayım">.
                <br/><br/>
                <cf_get_lang dictionary_id="60961.Asgari Geçim İndiriminden faydalanabilmek için vermiş olduğum, Aile Durum Bildirim formundaki 
                bilgilerin doğruluğunu ve bu bilgilerde değişiklik olduğunda, bu değişiklikleri 1 ay içinde bildireceğimi taahhüt eder,
                beyan ettiğim bilgilerin yanlışlığından kaynaklanan her türlü cezai yaptırımı ve bu durumun iş aktimin işverence haklı nedenle
                feshine neden olacağını peşinen kabul ederim.">
                <br/><br/><br/>
                <b>#get_employee_detail.EMPLOYEE_NAME# #get_employee_detail.EMPLOYEE_SURNAME#</b><br/>
                <cf_get_lang dictionary_id="57742.Tarih"> / <cf_get_lang dictionary_id="58957.İmza"> :
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
    </div>
</cfoutput>